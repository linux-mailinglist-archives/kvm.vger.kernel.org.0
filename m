Return-Path: <kvm+bounces-39914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 33CDFA4CABF
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 19:07:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2CB33AF658
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 17:55:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F221C21CC74;
	Mon,  3 Mar 2025 17:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GVRm/GPu"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A9121883F
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 17:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741024546; cv=none; b=iXPBftKsBzEj268XU6QD/rnot0CjvuGnWCyEtEE+itZejY0L7nypaD6XFB29zHD1NBmAvEAQVn+8p6AW3tm7DEosaTipfxw4+i28tONw2A2XAVaxwNns3I6jzfUI3SdoT/1JkM/KasyCfgncoOuFmYKfnoVBLQnJjAe4GYR/+bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741024546; c=relaxed/simple;
	bh=RYeCiH4hrglpzCL4UionL7B70QIq6qUx4/oWmBloBco=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=s8R+y2ZvcR3NjLnKaRl5iy38BRNrcPm5tuqh/2qRwbbR/pN20O+8QDHVvZitSEXTw5ZnVMdcUElhq2UrzoR0b0i9K34FKT1Jhy6ZXFN4o1Kya41Z64w8QjwtW8WDg7GWxbo6K3Cp2GRUHqnzFtQ1L51zo4A3DRBQi8u5SkugAeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GVRm/GPu; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-22328fb6cbfso83937095ad.2
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 09:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741024544; x=1741629344; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t29eipV8nLIfT3AxIgJFAPTVE7nBNDXlcKJOKbdgiFo=;
        b=GVRm/GPu6oSeBjCxdOOKjdcfTC3oeOriYY13rcKw7VQRFIvzYqvyTFhyu+6ZRU1tnj
         QnGuemkgX8/SPupq4Krkt+S/7a86rm6SW/jnsUaaLZBZWeO1vtK+1gxgu7a9B5PrRyvd
         7EXYqKsphEucqUsv8Xa0Nh9MbTNyQZjck4YNOU3fjObe0MelUTSdPlb5itmEGCR0iMWC
         XUzoWdfS6B+uoX/lyC2K0YU7RAZrGJtstc0fOlLXhqj36QHuL2FmkkflII2Myct9aEVX
         NdV0ju2ZOoWwKkCQDCeZqy7n51Piy7cEqBP4ph1byVZac1gpY5cP9aB5ofabCL3+sq9Z
         uD1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741024544; x=1741629344;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t29eipV8nLIfT3AxIgJFAPTVE7nBNDXlcKJOKbdgiFo=;
        b=T+p2LfvG/8DGAQaYoH9Gvul/JUZ3T60rjHAIeKOREfz1GKL+1pzuPHN/a6H9Syls6G
         hpdKsF/KWK8FlRlzpF16Ti+8OK5GxOkea4n13MbBrUZEhnCtpRn/q/AX5g4S09sGlP42
         2yyo2e/8nJcgLrhzJ9mop7BX0WDKhreYy4U6c53CtChe1e5gsqRIKxgM8+MVxhQU86qk
         wEfbJyoWaGwtboI2MhUDe0WDCqmy9FRawgYk5uha5Cv3FaBzMhT+8/W0BJAdhuck0kV/
         PN+J9bWpGyuAhbG3Y+smRhBY49xtQwLumfMCVNXLKWJq51HEl7yao1eNhzwj3P5ie4jk
         bf1A==
X-Forwarded-Encrypted: i=1; AJvYcCWEpFzPMHfYp+3uM8SN40DhGtxwRIz1nTbQ9FJ4K+Zng4GxAyS/HxCAHlJp1FhLOSVQjDA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFuJ26VYvIrC6vwnShHQPkx+ud5GwDv3RS1ab3q74mvHSzRyOM
	AxecqscPqf5MjmXDGhnhCI1KSDZ/HI2jsO918oDHDRsfxIR6G5ueWRyF/jjwKmG4qMCP6cNrpjj
	7SA==
X-Google-Smtp-Source: AGHT+IHmiRcJ/TXtxOjZJ9TLtmElrBxOaPNxmsCaonemIQYwQWgcMwsBzh5CFU7u1TN6rwqurQh1oo4KA6M=
X-Received: from pfbmc22.prod.google.com ([2002:a05:6a00:7696:b0:730:92d9:52e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:22d0:b0:21f:89e5:2704
 with SMTP id d9443c01a7336-2236924f93cmr219888425ad.34.1741024543838; Mon, 03
 Mar 2025 09:55:43 -0800 (PST)
Date: Mon, 3 Mar 2025 09:55:42 -0800
In-Reply-To: <20250303052227.523411-1-zijie.wei@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241121065039.183716-1-zijie.wei@linux.alibaba.com> <20250303052227.523411-1-zijie.wei@linux.alibaba.com>
Message-ID: <Z8XtHvJ4KZTYa-yr@google.com>
Subject: Re: [PATCH v4] KVM: x86: ioapic: Optimize EOI handling to reduce
 unnecessary VM exits
From: Sean Christopherson <seanjc@google.com>
To: weizijie <zijie.wei@linux.alibaba.com>
Cc: kai.huang@intel.com, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	xuyun <xuyun_xy.xy@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Several minor comments.  No need to post v5, I'll do so today as a small se=
ries
with preparatory patches to refactor and deduplicate the userspace vs. in-k=
ernel
logic.

On Mon, Mar 03, 2025, weizijie wrote:
> Configuring IOAPIC routed interrupts triggers KVM to rescan all vCPU's
> ioapic_handled_vectors which is used to control which vectors need to
> trigger EOI-induced VMEXITs. If any interrupt is already in service on
> some vCPU using some vector when the IOAPIC is being rescanned, the
> vector is set to vCPU's ioapic_handled_vectors. If the vector is then
> reused by other interrupts, each of them will cause a VMEXIT even it is
> unnecessary. W/o further IOAPIC rescan, the vector remains set, and this
> issue persists, impacting guest's interrupt performance.
>=20
> Both
>=20
>   commit db2bdcbbbd32 ("KVM: x86: fix edge EOI and IOAPIC reconfig race")
>=20
> and
>=20
>   commit 0fc5a36dd6b3 ("KVM: x86: ioapic: Fix level-triggered EOI and
> IOAPIC reconfigure race")
>=20
> mentioned this issue, but it was considered as "rare" thus was not
> addressed. However in real environment this issue can actually happen
> in a well-behaved guest.
>=20
> Simple Fix Proposal:
> A straightforward solution is to record highest in-service IRQ that
> is pending at the time of the last scan. Then, upon the next guest
> exit, do a full KVM_REQ_SCAN_IOAPIC. This ensures that a re-scan of
> the ioapic occurs only when the recorded vector is EOI'd, and
> subsequently, the extra bits in the eoi_exit_bitmap are cleared,
> avoiding unnecessary VM exits.

Write changelogs as "commands", i.e. state what changes are actually being =
made,
as opposed to passively describing a proposed/possible change.

> Co-developed-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
> Signed-off-by: xuyun <xuyun_xy.xy@linux.alibaba.com>
> Signed-off-by: weizijie <zijie.wei@linux.alibaba.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/ioapic.c           | 10 ++++++++--
>  arch/x86/kvm/irq_comm.c         |  9 +++++++--
>  arch/x86/kvm/lapic.c            | 13 +++++++++++++
>  4 files changed, 29 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_h=
ost.h
> index 0b7af5902ff7..8c50e7b4a96f 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1062,6 +1062,7 @@ struct kvm_vcpu_arch {
>  #if IS_ENABLED(CONFIG_HYPERV)
>  	hpa_t hv_root_tdp;
>  #endif
> +	u8 last_pending_vector;

To be consistent with how KVM handles IRQs, this should probably be an "int=
" with
-1 as the "no pending EOI" value.

I also think we should go with a verbose name to try and precisely capture =
what
this field tracks, e.g. highest_stale_pending_ioapic_eoi.  It's abusrdly lo=
ng,
but with massaging and refactoring the line lengths are a non-issue, and I =
want
to avoid confusion with pending_ioapic_eoi and highest_isr_cache (and other=
s).

>  };
> =20
>  struct kvm_lpage_info {
> diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> index 995eb5054360..40252a800897 100644
> --- a/arch/x86/kvm/ioapic.c
> +++ b/arch/x86/kvm/ioapic.c
> @@ -297,10 +297,16 @@ void kvm_ioapic_scan_entry(struct kvm_vcpu *vcpu, u=
long *ioapic_handled_vectors)
>  			u16 dm =3D kvm_lapic_irq_dest_mode(!!e->fields.dest_mode);
> =20
>  			if (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
> -						e->fields.dest_id, dm) ||
> -			    kvm_apic_pending_eoi(vcpu, e->fields.vector))
> +						e->fields.dest_id, dm))
>  				__set_bit(e->fields.vector,
>  					  ioapic_handled_vectors);
> +			else if (kvm_apic_pending_eoi(vcpu, e->fields.vector)) {
> +				__set_bit(e->fields.vector,
> +					  ioapic_handled_vectors);
> +				vcpu->arch.last_pending_vector =3D e->fields.vector >
> +					vcpu->arch.last_pending_vector ? e->fields.vector :
> +					vcpu->arch.last_pending_vector;

Eh, no need to use a ternary operator, last_pending_vector only needs to be=
 written
if it's changing.

>  		}
>  	}
>  	spin_unlock(&ioapic->lock);
> diff --git a/arch/x86/kvm/irq_comm.c b/arch/x86/kvm/irq_comm.c
> index 8136695f7b96..1d23c52576e1 100644
> --- a/arch/x86/kvm/irq_comm.c
> +++ b/arch/x86/kvm/irq_comm.c
> @@ -426,9 +426,14 @@ void kvm_scan_ioapic_routes(struct kvm_vcpu *vcpu,
> =20
>  			if (irq.trig_mode &&
>  			    (kvm_apic_match_dest(vcpu, NULL, APIC_DEST_NOSHORT,
> -						 irq.dest_id, irq.dest_mode) ||
> -			     kvm_apic_pending_eoi(vcpu, irq.vector)))
> +						 irq.dest_id, irq.dest_mode)))
>  				__set_bit(irq.vector, ioapic_handled_vectors);
> +			else if (kvm_apic_pending_eoi(vcpu, irq.vector)) {
> +				__set_bit(irq.vector, ioapic_handled_vectors);
> +				vcpu->arch.last_pending_vector =3D irq.vector >
> +					vcpu->arch.last_pending_vector ? irq.vector :
> +					vcpu->arch.last_pending_vector;

This is wrong.  Well, maybe not "wrong" per se, but unnecessary.  The trig_=
mode
check guards both the "new" and "old" routing cases, i.e. KVM's behavior is=
 to
intercept EOIs for in-flight IRQs if and only if the IRQ is level-triggered=
.

This code really needs to be de-duplicated between the userspace and in-ker=
nel
I/O APICs.  It probably should have been de-duplicated by fceb3a36c29a ("KV=
M: x86:
ioapic: Fix level-triggered EOI and userspace I/OAPIC reconfigure race"), b=
ut it's
a much more pressing issue now.

> +			}
>  		}
>  	}
>  	srcu_read_unlock(&kvm->irq_srcu, idx);
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index a009c94c26c2..7c540a0eb340 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -1466,6 +1466,19 @@ static void kvm_ioapic_send_eoi(struct kvm_lapic *=
apic, int vector)
>  	if (!kvm_ioapic_handles_vector(apic, vector))
>  		return;
> =20
> +	/*
> +	 * When there are instances where ioapic_handled_vectors is
> +	 * set due to pending interrupts, clean up the record and do
> +	 * a full KVM_REQ_SCAN_IOAPIC.
> +	 * This ensures the vector is cleared in the vCPU's ioapic_handled_vect=
ors,
> +	 * if the vector is reused=C2=A0by non-IOAPIC interrupts, avoiding unne=
cessary
> +	 * EOI-induced VMEXITs for that vector.
> +	 */
> +	if (apic->vcpu->arch.last_pending_vector =3D=3D vector) {
> +		apic->vcpu->arch.last_pending_vector =3D 0;

I think it makes sense to reset the field when KVM_REQ_SCAN_IOAPIC, mainly =
so
that it's more obviously correct, i.e. so that it's easier to see that the =
field
is reset immediately prior to scanning, along with the bitmap itself.

> +		kvm_make_request(KVM_REQ_SCAN_IOAPIC, apic->vcpu);
> +	}
> +
>  	/* Request a KVM exit to inform the userspace IOAPIC. */
>  	if (irqchip_split(apic->vcpu->kvm)) {
>  		apic->vcpu->arch.pending_ioapic_eoi =3D vector;
> --=20
> 2.43.5
>=20

