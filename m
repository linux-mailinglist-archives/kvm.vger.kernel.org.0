Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B9E6968B2
	for <lists+kvm@lfdr.de>; Tue, 14 Feb 2023 17:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjBNQCS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Feb 2023 11:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232128AbjBNQCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Feb 2023 11:02:10 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D61F2D52;
        Tue, 14 Feb 2023 08:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B8m1WYTfCwIRBef7Ts4H70l01shy+i4ZZD4VBDlUF0g=; b=ZDwawV4fqwWJVQzsvQDK+7YUXU
        gUppfAqBUVHj+lMaQ2ZlUmxKBjn+YdN437IPZGReHldG5w5ImBOKSusm9jzKCKEiH0MtHZiAokwk4
        yQd6BBjnFQNZh6lebR18Pmpqvk1NXjDOrfYzSpXgq4CTULk92CcdofvENu+YV62J0NuHooZZb0++G
        F7wLAGKhXqpAsOFbQT7HI/Z5dHq3xtPWRH5LYuEtqly1qqtOJlgXNHuzqOtsmBYZVBUL+3BlA34dC
        xgSvSnKZD2dia7cqDJ8G2JRLm7j+Cm5c2P/Bvdvj63JURLRFbBLxRKdxq8xnI6xHZrqpYaekxlOWX
        +0/wcc/Q==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pRxju-009g7r-31;
        Tue, 14 Feb 2023 16:01:49 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id B9CDF3033FF;
        Tue, 14 Feb 2023 15:12:50 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id AC39F23BDBD82; Tue, 14 Feb 2023 15:12:50 +0100 (CET)
Date:   Tue, 14 Feb 2023 15:12:50 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Kai Huang <kai.huang@intel.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
        seanjc@google.com, pbonzini@redhat.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, david@redhat.com,
        bagasdotme@gmail.com, sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v9 07/18] x86/virt/tdx: Do TDX module per-cpu
 initialization
Message-ID: <Y+uW4q//sIw+qQ+a@hirez.programming.kicks-ass.net>
References: <cover.1676286526.git.kai.huang@intel.com>
 <557c526a1190903d11d67c4e2c76e01f67f6eb15.1676286526.git.kai.huang@intel.com>
 <2d9172c5-e1e7-bf94-c52b-0e9bc5b5b319@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d9172c5-e1e7-bf94-c52b-0e9bc5b5b319@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023 at 10:07:30AM -0800, Dave Hansen wrote:
> On 2/13/23 03:59, Kai Huang wrote:
> > @@ -247,8 +395,17 @@ int tdx_enable(void)
> >  		ret = __tdx_enable();
> >  		break;
> >  	case TDX_MODULE_INITIALIZED:
> > -		/* Already initialized, great, tell the caller. */
> > -		ret = 0;
> > +		/*
> > +		 * The previous call of __tdx_enable() may only have
> > +		 * initialized part of present cpus during module
> > +		 * initialization, and new cpus may have become online
> > +		 * since then.
> > +		 *
> > +		 * To make sure all online cpus are TDX-runnable, always
> > +		 * do per-cpu initialization for all online cpus here
> > +		 * even the module has been initialized.
> > +		 */
> > +		ret = __tdx_enable_online_cpus();
> 
> I'm missing something here.  CPUs get initialized through either:
> 
>  1. __tdx_enable(), for the CPUs around at the time
>  2. tdx_cpu_online(), for hotplugged CPUs after __tdx_enable()
> 
> But, this is a third class.  CPUs that came online after #1, but which
> got missed by #2.  How can that happen?

offline CPUs, start TDX crap, online CPUs.
