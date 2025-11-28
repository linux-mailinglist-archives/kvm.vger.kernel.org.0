Return-Path: <kvm+bounces-64919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 53048C90CF6
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 04:59:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5F59D3508EE
	for <lists+kvm@lfdr.de>; Fri, 28 Nov 2025 03:59:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 849A72D3220;
	Fri, 28 Nov 2025 03:59:29 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from Atcsqr.andestech.com (60-248-80-70.hinet-ip.hinet.net [60.248.80.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D1E149C6F
	for <kvm@vger.kernel.org>; Fri, 28 Nov 2025 03:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.248.80.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764302369; cv=none; b=ATK/WDlyKUwi2QL5Yu9NYGW4LuYv4m7955Zw/3ROkUHfBaaEspEmd2IeXcVm+JnKWu+FHyDxLZp1+Jj978OYvHLrNROveBC7SQdZ65o2Q/XzPSmj4EvYn6bbkItaIlBDQtcBp8XXQGCA8kvKuUbrlm3V5V4b0mZfZ6xcWdLhMIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764302369; c=relaxed/simple;
	bh=aK+gMIALIsYPO0/tFUUhubGLbcujlJSnNwTTeG3p3W4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=K5IHBKdEULbQjL8OHlE6hfvsWm0twGFf+EHnOW97OgOwT6Df4NBUfR1rsVQrEcNE5spFyJ5wYv3qlrI1eTg5oxKArPrV9ivh3RanQmBTtGH96Rn9xDGQKdcIhiS3s8h9FDvl2I/ry5qnYJo3UjFBnnIdAeEYQhmYe4E13XhonAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com; spf=pass smtp.mailfrom=andestech.com; arc=none smtp.client-ip=60.248.80.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=andestech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andestech.com
Received: from mail.andestech.com (ATCPCS34.andestech.com [10.0.1.134])
	by Atcsqr.andestech.com with ESMTPS id 5AS3xEpv039276
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
	Fri, 28 Nov 2025 11:59:14 +0800 (+08)
	(envelope-from minachou@andestech.com)
Received: from atcsi01.andestech.com (10.0.15.32) by ATCPCS34.andestech.com
 (10.0.1.134) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Nov
 2025 11:59:14 +0800
Date: Fri, 28 Nov 2025 11:59:10 +0800
From: Mina Chou <minachou@andestech.com>
To: Anup Patel <anup@brainfault.org>
CC: <atish.patra@linux.dev>, <pjw@kernel.org>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <alex@ghiti.fr>, <kvm@vger.kernel.org>,
        <kvm-riscv@lists.infradead.org>, <linux-riscv@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <tim609@andestech.com>,
        <ben717@andestech.com>, <az70021@gmail.com>,
        <rkrcmar@ventanamicro.com>, <nutty.liu@hotmail.com>
Subject: Re: [PATCH v4] RISC-V: KVM: Flush VS-stage TLB after VCPU migration
 for split two-stage TLBs
Message-ID: <aSkdyHo0T6BYPF7A@atcsi01.andestech.com>
References: <20251117084555.157642-1-minachou@andestech.com>
 <CAAhSdy0mS++Oqp6jB8vf5n5Q8EYbFUDYceYxj1R6eH67=X2RZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAAhSdy0mS++Oqp6jB8vf5n5Q8EYbFUDYceYxj1R6eH67=X2RZg@mail.gmail.com>
User-Agent: Mutt/2.2.15 (2025-10-02)
X-ClientProxiedBy: ATCPCS33.andestech.com (10.0.1.100) To
 ATCPCS34.andestech.com (10.0.1.134)
X-DKIM-Results: atcpcs34.andestech.com; dkim=none;
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL:Atcsqr.andestech.com 5AS3xEpv039276

On Sun, Nov 23, 2025 at 11:34:28AM +0530, Anup Patel wrote:
> [EXTERNAL MAIL]
> 
> A shorter patch subject can be:
> "RISC-V: KVM: Flush VS-stage TLB after VCPU migration for Andes cores"
> 
> On Mon, Nov 17, 2025 at 2:19???PM Hui Min Mina Chou
> <minachou@andestech.com> wrote:
> >
> > Most implementations cache the combined result of two-stage
> > translation, but some, like Andes cores, use split TLBs that
> > store VS-stage and G-stage entries separately.
> >
> > On such systems, when a VCPU migrates to another CPU, an additional
> > HFENCE.VVMA is required to avoid using stale VS-stage entries, which
> > could otherwise cause guest faults.
> >
> > Introduce a static key to identify CPUs with split two-stage TLBs.
> > When enabled, KVM issues an extra HFENCE.VVMA on VCPU migration to
> > prevent stale VS-stage mappings.
> >
> > Signed-off-by: Hui Min Mina Chou <minachou@andestech.com>
> > Signed-off-by: Ben Zong-You Xie <ben717@andestech.com>
> > Reviewed-by: Radim Kr??m???? <rkrcmar@ventanamicro.com>
> > ---
> > Changelog:
> >
> > v4:
> >  - Rename the patch subject
> >  - Remove the Fixes tag
> >  - Add a static key so that HFENCE.VVMA is issued only on CPUs with
> >    split two-stage TLBs
> >  - Add kvm_riscv_setup_vendor_features() to detect mvendorid/marchid
> >    and enable the key when required
> >
> > v3:
> >  - Resolved build warning; updated header declaration and call side to
> >    kvm_riscv_local_tlb_sanitize
> >  - Add Radim Kr??m????'s Reviewed-by tag
> >  (https://lore.kernel.org/all/20251023032517.2527193-1-minachou@andestech.com/)
> >
> > v2:
> >  - Updated Fixes commit to 92e450507d56
> >  - Renamed function to kvm_riscv_local_tlb_sanitize
> >  (https://lore.kernel.org/all/20251021083105.4029305-1-minachou@andestech.com/)
> > ---
> >  arch/riscv/include/asm/kvm_host.h |  2 ++
> >  arch/riscv/include/asm/kvm_vmid.h |  2 +-
> >  arch/riscv/kvm/main.c             | 14 ++++++++++++++
> >  arch/riscv/kvm/vcpu.c             |  2 +-
> >  arch/riscv/kvm/vmid.c             |  6 +++++-
> >  5 files changed, 23 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
> > index d71d3299a335..21abac2f804e 100644
> > --- a/arch/riscv/include/asm/kvm_host.h
> > +++ b/arch/riscv/include/asm/kvm_host.h
> > @@ -323,4 +323,6 @@ bool kvm_riscv_vcpu_stopped(struct kvm_vcpu *vcpu);
> >
> >  void kvm_riscv_vcpu_record_steal_time(struct kvm_vcpu *vcpu);
> >
> > +DECLARE_STATIC_KEY_FALSE(kvm_riscv_tlb_split_mode);
> > +
> 
> "kvm_riscv_vsstage_tlb_no_gpa" is a better name for the static key.
> 
> >  #endif /* __RISCV_KVM_HOST_H__ */
> > diff --git a/arch/riscv/include/asm/kvm_vmid.h b/arch/riscv/include/asm/kvm_vmid.h
> > index ab98e1434fb7..75fb6e872ccd 100644
> > --- a/arch/riscv/include/asm/kvm_vmid.h
> > +++ b/arch/riscv/include/asm/kvm_vmid.h
> > @@ -22,6 +22,6 @@ unsigned long kvm_riscv_gstage_vmid_bits(void);
> >  int kvm_riscv_gstage_vmid_init(struct kvm *kvm);
> >  bool kvm_riscv_gstage_vmid_ver_changed(struct kvm_vmid *vmid);
> >  void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu);
> > -void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu);
> > +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu);
> 
> kvm_riscv_local_tlb_sanitize() must be declared in kvm_tlb.h
> 
> >
> >  #endif
> > diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
> > index 67c876de74ef..bf0e4f1abe0f 100644
> > --- a/arch/riscv/kvm/main.c
> > +++ b/arch/riscv/kvm/main.c
> > @@ -15,6 +15,18 @@
> >  #include <asm/kvm_nacl.h>
> >  #include <asm/sbi.h>
> >
> > +DEFINE_STATIC_KEY_FALSE(kvm_riscv_tlb_split_mode);
> > +
> > +static void kvm_riscv_setup_vendor_features(void)
> > +{
> > +       /* Andes AX66: split two-stage TLBs */
> > +       if (riscv_cached_mvendorid(0) == ANDES_VENDOR_ID &&
> > +           (riscv_cached_marchid(0) & 0xFFFF) == 0x8A66) {
> > +               static_branch_enable(&kvm_riscv_tlb_split_mode);
> > +               kvm_info("using split two-stage TLBs requiring extra HFENCE.VVMA\n");
> 
> I think the "VS-stage TLB does not cache guest physical addresses
> and VMID" message is more clear.
> 
> > +       }
> > +}
> > +
> >  long kvm_arch_dev_ioctl(struct file *filp,
> >                         unsigned int ioctl, unsigned long arg)
> >  {
> > @@ -159,6 +171,8 @@ static int __init riscv_kvm_init(void)
> >                 kvm_info("AIA available with %d guest external interrupts\n",
> >                          kvm_riscv_aia_nr_hgei);
> >
> > +       kvm_riscv_setup_vendor_features();
> > +
> >         kvm_register_perf_callbacks(NULL);
> >
> >         rc = kvm_init(sizeof(struct kvm_vcpu), 0, THIS_MODULE);
> > diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> > index 3ebcfffaa978..796218e4a462 100644
> > --- a/arch/riscv/kvm/vcpu.c
> > +++ b/arch/riscv/kvm/vcpu.c
> > @@ -968,7 +968,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
> >                  * Note: This should be done after G-stage VMID has been
> >                  * updated using kvm_riscv_gstage_vmid_ver_changed()
> >                  */
> > -               kvm_riscv_gstage_vmid_sanitize(vcpu);
> > +               kvm_riscv_local_tlb_sanitize(vcpu);
> >
> >                 trace_kvm_entry(vcpu);
> >
> > diff --git a/arch/riscv/kvm/vmid.c b/arch/riscv/kvm/vmid.c
> > index 3b426c800480..1dbd50c67a88 100644
> > --- a/arch/riscv/kvm/vmid.c
> > +++ b/arch/riscv/kvm/vmid.c
> > @@ -125,7 +125,7 @@ void kvm_riscv_gstage_vmid_update(struct kvm_vcpu *vcpu)
> >                 kvm_make_request(KVM_REQ_UPDATE_HGATP, v);
> >  }
> >
> > -void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
> > +void kvm_riscv_local_tlb_sanitize(struct kvm_vcpu *vcpu)
> >  {
> >         unsigned long vmid;
> >
> > @@ -146,4 +146,8 @@ void kvm_riscv_gstage_vmid_sanitize(struct kvm_vcpu *vcpu)
> >
> >         vmid = READ_ONCE(vcpu->kvm->arch.vmid.vmid);
> >         kvm_riscv_local_hfence_gvma_vmid_all(vmid);
> > +
> > +       /* For split TLB designs, flush VS-stage entries also */
> > +       if (static_branch_unlikely(&kvm_riscv_tlb_split_mode))
> > +               kvm_riscv_local_hfence_vvma_all(vmid);
> >  }
> 
> kvm_riscv_local_tlb_sanitize() implementation must be
> moved to kvm/tlb.c
> 
> > --
> > 2.34.1
> >
> 
> I will take care of the above comments at the time of merging
> this patch. If any further changes are required then I can squash
> changes before the end of next week.
> 
> Queued this patch for Linux-6.19.
> 
> Thanks,
> Anup

Hi Anup,

I won't be making any further changes to this patch. Thanks a lot
for your help and suggestions!
Regarding Nutty's comment about using a macro for ANDES_ARCH_ID,
we'll clean up the Andes CPU-related defines and update that part
in a future patch. Thanks also to Nutty for the suggestion!

Thanks again!
Mina

