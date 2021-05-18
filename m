Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9233F387429
	for <lists+kvm@lfdr.de>; Tue, 18 May 2021 10:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347541AbhERIiu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 04:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242786AbhERIij (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 04:38:39 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56A7C061756;
        Tue, 18 May 2021 01:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rE0H/Q8Q6VqgkakFnqfCmtWgnwAxCYwxpU5NtXrvg74=; b=uoKTY8wJ0J2QhESQcCp1nc+dx0
        nBG2Usoew0Pen9rl9x6RfuuHFM/NY/cgXAVlZy5qpOjopGDmEoKyxJDaer4p6Jp/9NA5X2v0YHQLw
        eqBHcA6z+YGN2YS/bToxNQl6b2wtls11XdoHyuKIVm0gLn0QaFQRsCnK+uylwo7EOWtP9C0/rG2+N
        ZJRNlihnCbbu7HgedvF+CLAdde7UxiEQGdjqWY6ZAEnOQR2wp6BkJJRUtiQK/CKqVFbCyfYOa2f/1
        ztmhLgrUQdPhfYXeQhkP0B6vDU5qdWdVPgRLiG+jkOiCBp8wh84i4sWQlthUkzvX+puNAe9stUGUs
        1or3bmGQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1livC5-00Do8E-Cq; Tue, 18 May 2021 08:35:26 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 7C107300233;
        Tue, 18 May 2021 10:35:09 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5AEAB2BE6E843; Tue, 18 May 2021 10:35:09 +0200 (CEST)
Date:   Tue, 18 May 2021 10:35:09 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Xu, Like" <like.xu@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, weijiang.yang@intel.com,
        Kan Liang <kan.liang@linux.intel.com>, ak@linux.intel.com,
        wei.w.wang@intel.com, eranian@google.com, liuxiangdong5@huawei.com,
        linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        Like Xu <like.xu@linux.intel.com>
Subject: Re: [PATCH v6 05/16] KVM: x86/pmu: Introduce the ctrl_mask value for
 fixed counter
Message-ID: <YKN8PQMs3x7Rpa4a@hirez.programming.kicks-ass.net>
References: <20210511024214.280733-1-like.xu@linux.intel.com>
 <20210511024214.280733-6-like.xu@linux.intel.com>
 <YKImwdg7LO/OPvVJ@hirez.programming.kicks-ass.net>
 <1fb87ea1-d7e6-0ca3-f3ed-4007a7e5a7d7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fb87ea1-d7e6-0ca3-f3ed-4007a7e5a7d7@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 18, 2021 at 03:55:13PM +0800, Xu, Like wrote:
> On 2021/5/17 16:18, Peter Zijlstra wrote:
> > On Tue, May 11, 2021 at 10:42:03AM +0800, Like Xu wrote:
> > > The mask value of fixed counter control register should be dynamic
> > > adjusted with the number of fixed counters. This patch introduces a
> > > variable that includes the reserved bits of fixed counter control
> > > registers. This is needed for later Ice Lake fixed counter changes.
> > > 
> > > Co-developed-by: Luwei Kang <luwei.kang@intel.com>
> > > Signed-off-by: Luwei Kang <luwei.kang@intel.com>
> > > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > > ---
> > >   arch/x86/include/asm/kvm_host.h | 1 +
> > >   arch/x86/kvm/vmx/pmu_intel.c    | 6 +++++-
> > >   2 files changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > > index 55efbacfc244..49b421bd3dd8 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -457,6 +457,7 @@ struct kvm_pmu {
> > >   	unsigned nr_arch_fixed_counters;
> > >   	unsigned available_event_types;
> > >   	u64 fixed_ctr_ctrl;
> > > +	u64 fixed_ctr_ctrl_mask;
> > >   	u64 global_ctrl;
> > >   	u64 global_status;
> > >   	u64 global_ovf_ctrl;
> > > diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
> > > index d9dbebe03cae..ac7fe714e6c1 100644
> > > --- a/arch/x86/kvm/vmx/pmu_intel.c
> > > +++ b/arch/x86/kvm/vmx/pmu_intel.c
> > > @@ -400,7 +400,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> > >   	case MSR_CORE_PERF_FIXED_CTR_CTRL:
> > >   		if (pmu->fixed_ctr_ctrl == data)
> > >   			return 0;
> > > -		if (!(data & 0xfffffffffffff444ull)) {
> > > +		if (!(data & pmu->fixed_ctr_ctrl_mask)) {
> > Don't we already have hardware with more than 3 fixed counters?
> 
> Yes, so we update this mask based on the value of pmu->nr_arch_fixed_counters:

Yes, I saw that, but the Changelog makes it appear this is only relevant
to ice lake, which I think is not fully correct.
