Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C88344CEB9
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 02:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232520AbhKKBUz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 20:20:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbhKKBUy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 20:20:54 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E40C061767
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 17:18:06 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so3140064pjb.5
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 17:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t4nnDeLo1iCP0qWFNqUucoApDeR2qvBQ8UhWQ3UZmkc=;
        b=PQIcRaRFx0EEmilZQB4hvm/u+nMZhIQEbx87Ve5EiNZyg9Gr4GgiVSeuxX7yNDLsM2
         c+fUHjBAKtuyM+1oeAprgXKlyJ+7eVeUsL4rUT8ohL6Bcpt5QL0f7EtUqQNeA+k049kf
         3JqD39l+MC54PdQJ4H1t7UqLLGNNkv2xdX7QqCzx83xwOacUcb+Frqd7N7JOim4oprWY
         pDA2dAzVATQC2R4OyDgzJWGz4GkLd7w4ib6uhBCD4m1vtWF2nJWBR6QS5o/Y7mJa7jB6
         7MZdtTio6MqHrYXfPnJjcooaSRTdD8b+K5lO5XmcJDeasoYjXjnrH2k3DY7OGgBS/AJx
         ierg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t4nnDeLo1iCP0qWFNqUucoApDeR2qvBQ8UhWQ3UZmkc=;
        b=e/I7OawDam+Kw0bQDk4U+DL/97laoK8ORStdkbye6BLxjGfEViHwk+6AByCQuc/zHd
         cvy1G7Fm/rMnb0+LAWEmYN1BoDVfmKCIJ3HXPbCpJpKj7dEvxzfzOwRMdnh3pEOkis2O
         dUwEyiKu5C48u/Uz2r2IbXBD21rIdjbI94yAQKYmuVOMGHaFqQFZGjpxzyrFP8NgL3cU
         j/gFxkWn0NCNZqbNpUjR9gAv6Q8iEG/3X++bQMNnlJ/K0QOLu67uqm2FH4kx7LyVpJWo
         wcEvFUUjjs/mt8lPca5myeG+t8+S/oHNOY/Ygfsz3djcyGtLJeiXV/B/+0du4SG496yu
         QvCw==
X-Gm-Message-State: AOAM5319KfpYAV5D3dPTOp6MUCzojtRwqwAf4w2fEUE4wzMEr7FmElnH
        VuVTJNtbsA1vzbCyhraX7FBi3A==
X-Google-Smtp-Source: ABdhPJz8FPQc7GIFH5vWRt+n3wEUWrg+9k44PkN/N5CImHKZdrpBhr5CuaxR3JJDQS1irQfeUnVtwQ==
X-Received: by 2002:a17:902:e405:b0:141:b2fa:b00 with SMTP id m5-20020a170902e40500b00141b2fa0b00mr3935488ple.22.1636593485875;
        Wed, 10 Nov 2021 17:18:05 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z23sm609892pgn.14.2021.11.10.17.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 17:18:05 -0800 (PST)
Date:   Thu, 11 Nov 2021 01:18:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of
 make_spte
Message-ID: <YYxvSfUPTXbclpSa@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-12-bgardon@google.com>
 <80407e4a-36e1-e606-ed9f-74429f850e77@redhat.com>
 <CANgfPd8hzDU+v52t9Kr=b48utC1p_j3yJ8gHzo-uifAxHbh-eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANgfPd8hzDU+v52t9Kr=b48utC1p_j3yJ8gHzo-uifAxHbh-eQ@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 10, 2021, Ben Gardon wrote:
> On Wed, Nov 10, 2021 at 2:45 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 11/10/21 23:30, Ben Gardon wrote:
> > > -     WARN_ONCE(is_rsvd_spte(&vcpu->arch.mmu->shadow_zero_check, spte, level),
> > > +     WARN_ONCE(is_rsvd_spte(shadow_zero_check, spte, level),
> > >                 "spte = 0x%llx, level = %d, rsvd bits = 0x%llx", spte, level,
> > > -               get_rsvd_bits(&vcpu->arch.mmu->shadow_zero_check, spte, level));
> > > +               get_rsvd_bits(shadow_zero_check, spte, level));
> >
> > Hmm, there is a deeper issue here, in that when using EPT/NPT (on either
> > the legacy aka shadow or the TDP MMU) large parts of vcpu->arch.mmu are
> > really the same for all vCPUs.  The only thing that varies is those
> > parts that actually depend on the guest's paging mode---the extended
> > role, the reserved bits, etc.  Those are needed by the emulator, but
> > don't really belong in vcpu->arch.mmu when EPT/NPT is in use.
> >
> > I wonder if there's room for splitting kvm_mmu in two parts, such as
> > kvm_mmu and kvm_guest_paging_context, and possibly change the walk_mmu
> > pointer into a pointer to kvm_guest_paging_context.  This way the
> > EPT/NPT MMU (again either shadow or TDP) can be moved to kvm->arch.  It
> > should simplify this series and also David's work on eager page splitting.
> >
> > I'm not asking you to do this, of course, but perhaps I can trigger
> > Sean's itch to refactor stuff. :)
> >
> > Paolo
> >
> 
> I think that's a great idea. I'm frequently confused as to why the
> struct kvm_mmu is a per-vcpu construct as opposed to being VM-global.
> Moving part of the struct to be a member for struct kvm would also
> open the door to formalizing the MMU interface a little better and
> perhaps even reveal more MMU code that can be consolidated across
> architectures.

But what would you actually move?  Even shadow_zero_check barely squeaks by,
e.g. if NX is ever used to for NPT, then maybe it stops being a per-VM setting.

Going through the fields...

These are all related to guest context:

	unsigned long (*get_guest_pgd)(struct kvm_vcpu *vcpu);
	u64 (*get_pdptr)(struct kvm_vcpu *vcpu, int index);
	int (*page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
				  struct x86_exception *fault);
	gpa_t (*gva_to_gpa)(struct kvm_vcpu *vcpu, gpa_t gva_or_gpa,
			    u32 access, struct x86_exception *exception);
	gpa_t (*translate_gpa)(struct kvm_vcpu *vcpu, gpa_t gpa, u32 access,
			       struct x86_exception *exception);
	int (*sync_page)(struct kvm_vcpu *vcpu,
			 struct kvm_mmu_page *sp);
	void (*invlpg)(struct kvm_vcpu *vcpu, gva_t gva, hpa_t root_hpa);
	union kvm_mmu_role mmu_role;
	u8 root_level;
	u8 permissions[16];
	u32 pkru_mask;
	struct rsvd_bits_validate guest_rsvd_check;
	u64 pdptrs[4];
	gpa_t root_pgd;

One field, ept_ad, can be straight deleted as it's redundant with respect to
the above mmu_role.ad_disabled.

	u8 ept_ad;

Ditto for direct_map flag (mmu_role.direct) and shadow_root_level (mmu_role.level).
I haven't bothered to yank those because they have a lot of touchpoints.

	bool direct_map;
	u8 shadow_root_level;

The prev_roots could be dropped if TDP roots were tracked per-VM, but we'd still
want an equivalent for !TDP and nTDP MMUs.

	struct kvm_mmu_root_info prev_roots[KVM_MMU_NUM_PREV_ROOTS];

shadow_zero_check can be made per-VM if all vCPUs are required to have the same
cpuid.MAXPHYADDR or if we remove the (IMO) pointless 5-level vs. 4-level behavior,
which by-the-by, has my vote since we could make shadow_zero_check _global_, not
just per-VM, and everything I've heard is that the extra level has no measurable
performance overhead.

	struct rsvd_bits_validate shadow_zero_check;

And that leaves us with:
	hpa_t root_hpa;

	u64 *pae_root;
	u64 *pml4_root;
	u64 *pml5_root;

Of those, _none_ of them can be per-VM, because they are all nothing more than
shadow pages, and thus cannot be per-VM unless there is exactly one set of TDP
page tables for the guest.  Even if/when we strip the unnecessary role bits from
these for TDP (on my todo list), we still need up to three sets of page tables:

	1. Normal
	2. SMM
	3. Guest (if L1 doesn't use TDP)

So I suppose we could refactor KVM to explicitly track its three possible TDP
roots, but I don't think it buys us anything and would complicate supporting
!TDP as well as nTDP.
