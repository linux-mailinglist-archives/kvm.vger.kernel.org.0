Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3002C3921C9
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 23:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbhEZVMb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 17:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbhEZVM0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 17:12:26 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D82C06175F
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 14:10:54 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id d78so1915541pfd.10
        for <kvm@vger.kernel.org>; Wed, 26 May 2021 14:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=f/rbjKviRvFVX0Te8u4k8bqeiTictapTyzo3WDV9mhs=;
        b=Memse1iJsMVqDZS5ISUSOn2BjkDNVbGZ2ReD6ANclbxOAXOX3XbY10C31X5O97HFbe
         D2z7fgKGs44dEuKE+PB4kGr6DjpUXnajPR0vdWaTZiW87hEYN0Y+XZyb2KGUA/Hiy3hX
         AWWoBXvpL22VtsdZ1z4Dvn0bWZp+48g7MsGEyuVdGdSTvb4vZN3JUb4V0fm5It7dFlHp
         IlRlVf5JaL5yXltVC48qFKg5rgvIZ/Yob9p2R8j36IW6PvI2A7kCqhKxhQebVfrMSu/+
         nSZ1Ppqy7V6fkzjvXCfj1aSgTtOLlufuXsdJ0TFgC+Vfu7PLdQd+ch5HBc1fdteiB+z2
         /Z5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=f/rbjKviRvFVX0Te8u4k8bqeiTictapTyzo3WDV9mhs=;
        b=t5OFMNCqobDkXIJ1qnc3uoNd9BhBxI879AMtkxyTzwjMjSYmUS8EH8hjn5ish66IgR
         YjYrMkGtZ2OX9TiGWaU7fNfpnx/CSAf3+oyGFUzbf+ywHz917NHn6tYE8u0Ufx+yGVp0
         vJ5dp3cNtC2AL2CVZ1LsLidFDI0FjyNScQnTNI1awec+A1y9tu8XDDPfpXN3JcLFjtrB
         Bju3tg0g0o6BeKNmzjrZ49QNNpZaWn3UR78zPOhzkJ6U2UG28GSWOV43ctX4IdnIDNHL
         X99WrA+zxEOW7ET5354J5znih3D/bW3JRKScY6OwpMqqdumLWDVoTvN4Xm4OBqgUsU+Z
         wNvQ==
X-Gm-Message-State: AOAM531JCNqXvSHAQS6+PHTCXo+K1a/TlTdVMJ/6s9aZjKSyx8UnaPyo
        4/KyYlAOUvHl5TsWggXTaSCvxLPgfbq9/A==
X-Google-Smtp-Source: ABdhPJwEpf8QCKAcrBl9kdSuy27Ib13bkmT1ykfsRRAaonJmBmQooZBPSunJU6Yma+he3eQ1OqYBBg==
X-Received: by 2002:a65:6a52:: with SMTP id o18mr392699pgu.177.1622063452156;
        Wed, 26 May 2021 14:10:52 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id o7sm9219pgs.45.2021.05.26.14.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 14:10:51 -0700 (PDT)
Date:   Wed, 26 May 2021 21:10:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Isaku Yamahata <isaku.yamahata@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH 00/10] KVM: x86/mmu: simplify argument to kvm page
 fault handler
Message-ID: <YK65V++S2Kt1OLTu@google.com>
References: <cover.1618914692.git.isaku.yamahata@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1618914692.git.isaku.yamahata@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 20, 2021, Isaku Yamahata wrote:
> This is a preliminary clean up for TDX which complicates KVM page fault
> execution path.

Ooh, a series to complicate the page fault path!  ;-)

Grammatical snarkiness aside, I'm all in favor of adding a struct to collect the
page fault collateral.  Overarching feedback:

  - Have kvm_mmu_do_page_fault() handle initialization of the struct.  That
    will allow making most of the fields const, and will avoid the rather painful
    kvm_page_fault_init().

  - Pass @vcpu separately.  Yes, it's associated with the fault, but literally
    the first line in every consumer is "struct kvm_vcpu *vcpu = kpf->vcpu;".

  - Use "fault" instead of "kpf", mostly because it reads better for people that
    aren't intimately familiar with the code, but also to avoid having to refactor
    a huge amount of code if we decide to rename kvm_page_fault, e.g. if we decide
    to use that name to return fault information to userspace.

  - Snapshot anything that is computed in multiple places, even if it is
    derivative of existing info.  E.g. it probably makes sense to grab
    write/fetch (or exec).


E.g. I'm thinking something like

struct kvm_page_fault {
	const gpa_t cr2_or_gpa;
	const u32 error_code;
	const bool write;
	const bool read;
	const bool fetch;
	const bool prefault;
	const bool is_tdp;

	gfn_t gfn;
	hva_t hva;
	int max_level;

	kvm_pfn_t pfn;
	bool map_writable;
};

int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);

static inline int kvm_mmu_do_page_fault(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
					u32 err, bool prefault)
{
	struct kvm_page_fault fault = {
		.cr2_or_gpa = cr2_or_gpa,
		.error_code = err,
		.write	    = err & PFERR_WRITE_MASK,
		.fetch	    = err & PFERR_FETCH_MASK,
		.perm	    = ...
		.rsvd	    = err & PFERR_RSVD_MASK,

		.is_tdp	    = vcpu->arch.mmu->page_fault == kvm_tdp_page_fault,

		...
	};

#ifdef CONFIG_RETPOLINE
	if (likely(fault.is_tdp))
		return kvm_tdp_page_fault(vcpu, &fault);
#endif
	return vcpu->arch.mmu->page_fault(vcpu, &fault);
}

