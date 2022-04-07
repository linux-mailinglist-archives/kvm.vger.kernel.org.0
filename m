Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFD54F868C
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 19:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346586AbiDGRuo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 13:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231892AbiDGRum (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 13:50:42 -0400
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF4B1EF9C7
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 10:48:25 -0700 (PDT)
Received: by mail-pf1-f182.google.com with SMTP id w7so6087037pfu.11
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 10:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0ylGqf4i8xaVHnuzuNWAr0rdTSo9ggN34EheyoaVllw=;
        b=T2XNQRl+r0zIk1OVANQpnZ0kLjjeMgE3T1kBSsEGPJ/WdktFsvAc6X1DcFRBLJ7mXg
         1Pb558/lqG3HBzLaYiOUJtl+vFvbc0IFPOfaPNP1pkXW8UwqxKmu3yHnPqHHHXDCn/Ee
         qR5agD1tj66okNOXjq8CR9JdBjoHqbekDcnLMfdocVzpTAJtb23SiMaUGSWtSGNCdFO3
         JdYOdYW9CBhjqgmsk/96rqmSmtHRwBmoBDOXQoyh31jggD2mHXLUIYoAk90jtAUP8/vB
         59FDufcnLIH89VvuMJ9R5IlLMlUuujlWd4acEgEC2mWXax4J2y6zr6micuF65FeWVXvQ
         gFvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0ylGqf4i8xaVHnuzuNWAr0rdTSo9ggN34EheyoaVllw=;
        b=sviL3d2WDY1P0dD+ad1M5x8/sxcWy2sax6bM+6VdbCuyve3K0HIB7plKCYoOhSgJje
         f4l9pxcZ05cLjX8CZejf3XIehH/eR4wrjNsxHXhbEvsP6h1Ut1YXm4buX0R1F2Z2gG4G
         Hrd9no9QPCBMVlKF0bK6laooI3haafxQGKNZm4oe7yF3SrFb9xwo4PT2Pbj4T+G8l6qR
         qHWAt9mpmk7gMIVIc4WSkRMAUYQnihI5xkfyoM78mpb31n4aIOINenxzvCVty5Eg7fmH
         724EDjqZAzMpwaVbhnrYGfsi6AH1VGd8Q0boRLis+V0RelXi6JI85qt/LKQaqvIuJ/Lf
         FeQQ==
X-Gm-Message-State: AOAM531kmG0qm7sQJT/30tIInsaTGR8mvQzkwL7l8zoU3vp45WW7u4Uh
        4Khzt3F7hbHGIrMq9qjU/YiNSkF7MGKWCw==
X-Google-Smtp-Source: ABdhPJz9gLSTqTEoNtyZG0nVnVCMWvVfvlkvkWMvPMxGQ/pln4HEy6TzKBmrC6xpjbWUw0Q91GsMzw==
X-Received: by 2002:a05:6a00:1252:b0:4fa:afcc:7d24 with SMTP id u18-20020a056a00125200b004faafcc7d24mr15180138pfi.85.1649353643466;
        Thu, 07 Apr 2022 10:47:23 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t6-20020a17090a2f8600b001cb162f1f52sm2829320pjd.53.2022.04.07.10.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 10:47:22 -0700 (PDT)
Date:   Thu, 7 Apr 2022 17:47:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/31] KVM: x86: hyper-v: Handle
 HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST{,EX} calls gently
Message-ID: <Yk8jp5ZoQO6X8aTG@google.com>
References: <20220407155645.940890-1-vkuznets@redhat.com>
 <20220407155645.940890-4-vkuznets@redhat.com>
 <Yk8gTB+x2UVE34Ds@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yk8gTB+x2UVE34Ds@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022, Sean Christopherson wrote:
> > @@ -1857,12 +1940,13 @@ static u64 kvm_hv_flush_tlb(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
> >  	struct hv_tlb_flush_ex flush_ex;
> >  	struct hv_tlb_flush flush;
> >  	DECLARE_BITMAP(vcpu_mask, KVM_MAX_VCPUS);
> > +	u64 entries[KVM_HV_TLB_FLUSH_RING_SIZE - 2];
> 
> What's up with the -2?  And given the multitude of things going on in this code,
> I'd strongly prefer this be tlbflush_entries.
> 
> Actually, if you do:
> 
> 	u64 __tlbflush_entries[KVM_HV_TLB_FLUSH_RING_SIZE - 2];
> 	u64 *tlbflush_entries;

Looking at future patches, tlb_flush_entries is better for consistency (apply everywhere).

> and drop all_addr, the code to get entries can be
> 
> 	if (hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE ||
> 	    hc->code == HVCALL_FLUSH_VIRTUAL_ADDRESS_SPACE_EX ||
> 	    hc->rep_cnt > ARRAY_SIZE(tlbflush_entries)) {
> 		tlbfluish_entries = NULL;
> 	} else {
> 		if (kvm_hv_get_tlbflush_entries(kvm, hc, __tlbflush_entries,
> 						consumed_xmm_halves, data_offset))
> 			return HV_STATUS_INVALID_HYPERCALL_INPUT;
> 		tlbfluish_entries = __tlbflush_entries;

Heh, fluish, because TLB entries are somewhat fluid?

> 	}
> 
> and the calls to queue flushes becomes
> 
> 			hv_tlb_flush_ring_enqueue(v, tlbflush_entries, hc->rep_cnt);
> 
> That way a bug will "just" be a NULL pointer dereference and not consumption of
> uninitialized data (though such a bug might be caught be caught by the compiler).
