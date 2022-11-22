Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7184633818
	for <lists+kvm@lfdr.de>; Tue, 22 Nov 2022 10:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbiKVJNz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Nov 2022 04:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbiKVJNv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Nov 2022 04:13:51 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFDA047316;
        Tue, 22 Nov 2022 01:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=tAJyYdDr0qopnArMHRvaYWXVoISL97AHjwr5u25VtnE=; b=OsSMiaw1+GuLxGRH/nM06nOe8Z
        4tqVcJ5Mm4mo7LdqZ/9wrTL+JJGjdOyVEQXS1wDItstLOStUa2/9ylnONSaA92t70tSiWWk3BTSqt
        O1SNEobHJbRDzp8md6ZOShFUb16SeJBPv+25wcCiSCShG5tfO/VUs6oPNlgb6RWXQRu8T1QWpQll+
        E34HJu8vpiV9CCYmmQsuU/rkycCAM/h7PKVoQCT5DpW13jXxpNWhBbDOuyp/TjTvtKint5QpaEev/
        N8O2iQSfx1GWchy3qTJdjIJxPPqWUq4ze5cW5GvndiAfQ/QvnXxCPnjGCTO9fsz7msfjoA/4TQxdq
        cY53TdUw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oxPLZ-003O7s-3y; Tue, 22 Nov 2022 09:13:41 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id A1A4E3001D7;
        Tue, 22 Nov 2022 10:13:40 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 88F4A2D669369; Tue, 22 Nov 2022 10:13:40 +0100 (CET)
Date:   Tue, 22 Nov 2022 10:13:40 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Kai Huang <kai.huang@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com,
        dave.hansen@intel.com, dan.j.williams@intel.com,
        rafael.j.wysocki@intel.com, kirill.shutemov@linux.intel.com,
        ying.huang@intel.com, reinette.chatre@intel.com,
        len.brown@intel.com, tony.luck@intel.com, ak@linux.intel.com,
        isaku.yamahata@intel.com, chao.gao@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, bagasdotme@gmail.com,
        sagis@google.com, imammedo@redhat.com
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Message-ID: <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 21, 2022 at 01:26:28PM +1300, Kai Huang wrote:

> +/*
> + * Call the SEAMCALL on all online CPUs concurrently.  Caller to check
> + * @sc->err to determine whether any SEAMCALL failed on any cpu.
> + */
> +static void seamcall_on_each_cpu(struct seamcall_ctx *sc)
> +{
> +	on_each_cpu(seamcall_smp_call_function, sc, true);
> +}

Suppose the user has NOHZ_FULL configured, and is already running
userspace that will terminate on interrupt (this is desired feature for
NOHZ_FULL), guess how happy they'll be if someone, on another parition,
manages to tickle this TDX gunk?


