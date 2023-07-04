Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05CC747756
	for <lists+kvm@lfdr.de>; Tue,  4 Jul 2023 18:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbjGDQ66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jul 2023 12:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbjGDQ65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jul 2023 12:58:57 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C946C1AC;
        Tue,  4 Jul 2023 09:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=DabEsTadhQxjy5l0iivtu039CZEIVIYM+Tg+eA1/T04=; b=uAHjvH5ak/q0Cyv04hU2og4/RD
        HeQk6Efk5ea8ZyqH1x1gsPaBJOFNh54yiE32FGfIkjxSOFRHoq7t/nh/Dli247dERND8/oHpunIsn
        0sv0fxIhAzuB7qpjwjh017LEznjHtow93ZIiVqERpqu4mn8QTNLxesgBaj9ZQP1frXCN0C7tmI87G
        5X3421T7KYkERxRsw5sh3KbrdTu0EQ+ORwf19gBzw6ELDUnAkAIRegxVFiIUiiYA3sHY2FB9czD8f
        sEUfi43cubRIt3Zj8z6f6667HPyYR86dgMT85ONknDdql7d0JNViDcTQJWTWqCgq14X7AMscLC0D6
        femuk+Lw==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qGjMM-009JrU-8j; Tue, 04 Jul 2023 16:58:38 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id C764F3002B1;
        Tue,  4 Jul 2023 18:58:36 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id A1EBE2029A1AD; Tue,  4 Jul 2023 18:58:36 +0200 (CEST)
Date:   Tue, 4 Jul 2023 18:58:36 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Rafael J Wysocki <rafael.j.wysocki@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        Reinette Chatre <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        "nik.borisov@suse.com" <nik.borisov@suse.com>,
        "hpa@zytor.com" <hpa@zytor.com>, Sagi Shahar <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "bp@alien8.de" <bp@alien8.de>, Chao Gao <chao.gao@intel.com>,
        Len Brown <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Ying Huang <ying.huang@intel.com>,
        Dan J Williams <dan.j.williams@intel.com>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v12 07/22] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230704165836.GB462772@hirez.programming.kicks-ass.net>
References: <cover.1687784645.git.kai.huang@intel.com>
 <104d324cd68b12e14722ee5d85a660cccccd8892.1687784645.git.kai.huang@intel.com>
 <20230628131717.GE2438817@hirez.programming.kicks-ass.net>
 <0c9639db604a0670eeae5343d456e43d06b35d39.camel@intel.com>
 <20230630092615.GD2533791@hirez.programming.kicks-ass.net>
 <2659d6eef84f008635ba300f4712501ac88cef2c.camel@intel.com>
 <20230630183020.GA4253@hirez.programming.kicks-ass.net>
 <20230630190514.GH3436214@ls.amr.corp.intel.com>
 <ZJ9IKALhz1Q6ogu1@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZJ9IKALhz1Q6ogu1@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 30, 2023 at 02:24:56PM -0700, Sean Christopherson wrote:

> Waiting until userspace attempts to create the first TDX guest adds complexity
> and limits what KVM can do to harden itself.  Currently, all feature support in
> KVM is effectively frozen at module load.  E.g. most of the setup code is
> contained in __init functions, many module-scoped variables are effectively 
> RO after init (though they can't be marked as such until we smush kvm-intel.ko
> and kvm-amd.ko into kvm.ko, which is tentatively the long-term plan).  All of
> those patterns would get tossed aside if KVM waits until userspace attempts to
> create the first guest.

....

People got poked and the following was suggested:

On boot do:

 TDH.SYS.INIT
 TDH.SYS.LP.INIT
 TDH.SYS.CONFIG
 TDH.SYS.KEY.CONFIG

This should get TDX mostly sorted, but doesn't consume much resources.
Then later, when starting the first TDX guest, do the whole

 TDH.TDMR.INIT

dance to set up the PAMT array -- which is what gobbles up memory. From
what I understand the TDH.TDMR.INIT thing is not one of those
excessively long calls.

If we have concerns about allocating the PAMT array, can't we use CMA
for this? Allocate the whole thing at boot as CMA such that when not
used for TDX it can be used for regular things like userspace and
filecache pages?

Those TDH.SYS calls should be enough to ensure TDX is actually working,
no?
