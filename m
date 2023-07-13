Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE49751C0D
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 10:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234423AbjGMIrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 04:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234272AbjGMIqy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 04:46:54 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B254DE4D;
        Thu, 13 Jul 2023 01:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=0iE4oWpU34GZzmhlu1waBjlWtnlO5JVQSNcDSOmRsIg=; b=ecaen0Dzkg0jUwk8kFciiVMftL
        lt/rrfffKIkKOckxgnWejkdB5+MDIpm7M6xbud7JVed+lhnoVdf036fS2GSlvpxGiBHfg8XW4wEdg
        zz2rff7hK/aXHkwb5VK2KndXVJANoZ5ve/aqiQFEHmzbLlUaAu7CsXfmQcEI+ZF2Yv0oDJAIMHFuK
        Gz0vTSwAz5KGYFoDkdYEE4rh0x9UrYkKFFG41YCqdT16QjkUcKftvOmMSipXhjmdB6o6dTQNbW22D
        4USso2k62rfkr5eiCb3tfd6bO0g35LCyTedKO/BE18othXXu8UWkqlFkrq1+gNlS0XF9rfr2pAEkM
        QFAKhE1w==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qJryD-004Zb3-1G;
        Thu, 13 Jul 2023 08:46:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 09ECD30007E;
        Thu, 13 Jul 2023 10:46:41 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E7689245CA116; Thu, 13 Jul 2023 10:46:40 +0200 (CEST)
Date:   Thu, 13 Jul 2023 10:46:40 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "Hansen, Dave" <dave.hansen@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>
Subject: Re: [PATCH 07/10] x86/tdx: Extend TDX_MODULE_CALL to support more
 TDCALL/SEAMCALL leafs
Message-ID: <20230713084640.GB3138667@hirez.programming.kicks-ass.net>
References: <cover.1689151537.git.kai.huang@intel.com>
 <ecfd84af9186aa5368acb40a2740afbf1d0d1b5d.1689151537.git.kai.huang@intel.com>
 <20230712165336.GA3115257@hirez.programming.kicks-ass.net>
 <6489a835da0d21c7637d071b7ef40ae1cda87237.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6489a835da0d21c7637d071b7ef40ae1cda87237.camel@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 13, 2023 at 07:48:20AM +0000, Huang, Kai wrote:

> I found below comment in KVM code:
> 
> > +	 * See arch/x86/kvm/vmx/vmenter.S:
> > +	 *
> > +	 * In theory, a L1 cache miss when restoring register from stack
> > +	 * could lead to speculative execution with guest's values.
> 
> And KVM explicitly does XOR for the registers that gets "pop"ed almost
> instantly, so I followed.
> 
> But to be honest I don't quite understand this.  :-)

Urgh, I suppose that actually makes sense. Since pop is a load it might
continue speculation with the previous value. Whereas the xor-clear
idiom is impossible to speculate through.

Oh well...
