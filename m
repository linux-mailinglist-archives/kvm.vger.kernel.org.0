Return-Path: <kvm+bounces-37933-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B489A31AB2
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 01:47:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37D673A7754
	for <lists+kvm@lfdr.de>; Wed, 12 Feb 2025 00:47:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF9CA1C695;
	Wed, 12 Feb 2025 00:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iVEYX4Bj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECD5A50
	for <kvm@vger.kernel.org>; Wed, 12 Feb 2025 00:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739321220; cv=none; b=txRaAP8efn7TrTGVFFLEnEiqfL5TUaM4iWVvB75gPjI082ILQ5ScmXvIIgyrr0dY7WhRDjUAlmNyAwafuiuQc8sJy8DCYBlBvS8ECwM4Ofwf8wjC8LgJJu9GDxruGbx+e6KIdR4soHmbe8m1/CPckkqFS94cSb2eim1WAsVHAhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739321220; c=relaxed/simple;
	bh=JkLCN4YFjTAam7Iy75o7EPqrBdKr3MgMAk4ZNfNOQps=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lhjLWixQQvXxw1zx9uJuC0pTSeEqXRcGZNFpeKaTgjRXFXtj0YifNwJxCmPLeHgqRJDVRhuKSm+3KyC59Jz9nx6Ka1wvZwHL0ulm+vxEOwMPcKTkoxxKPOSTl0D0EVPjVjqD4hfp8ToqTL/24TbeNHbczof2vFev99/dR0+LqPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iVEYX4Bj; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fa3b466245so8182680a91.0
        for <kvm@vger.kernel.org>; Tue, 11 Feb 2025 16:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739321218; x=1739926018; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MTX6y7TnilLrI/eaywdsRxlxFNQJZpUyGgd1QJfP8kg=;
        b=iVEYX4BjrHvdI1EhSE2uXGmutGmzu6SQvkQeuYkfmqbaGus5MPwvKD9VLf5+bRrl+T
         gcvzFyy1g4FV5IRs/S7aaEdbcEJIL3NfK0YqtglkvrEny5rCYdVGI4uIeONZ3Rqf1TTr
         NPTjNkx9ou35RdvNR3aOWkoJZqsXfK1zxpXOA2g/4E1oXkYu5kMvPTgS0xqlLS+nGwFU
         7Keus1Wm/PX1A2o+vmlvw4G85S/vNl+NMEJ6WO2+AFacaiOmhH24htXR482/dXErGUKo
         fDp5cOitsdUtSsTEu1vyCxFCuZxxBN3vYEMCRD00KnHjtaD8i10AyBSDmwttVzbgg/M1
         CORg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739321218; x=1739926018;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MTX6y7TnilLrI/eaywdsRxlxFNQJZpUyGgd1QJfP8kg=;
        b=Whc0d2dslatkaOhjUa1F+Qy0nASXKMQvVph2qU9vD5HDRL2Y4kfSFBhuW4q4w3SGS5
         5Vd4Ug98Vp0MzMUy+9hgoUxfhyL7qAHk8VLMPpqeeOsApGVHrPdoSch0lGHhRthviwjG
         Dn+NZ33GpiY3d5Nsp4xDEGAWAc2h8LdvEV0ctXcP8GHr9yRvwa5CPi7RzumV4mnP1Dg4
         cjX/Fkd8c4YZRg5oBV2647S+SZO8WQW5S7H4kwBkXmIfyLM5K6hrHYeYN+wXkX28S17O
         vscjdlMVv5SVvjxURwKPVzvolMfpbKnmihqk7Yco2NefQFkBNWN2v0o1B7lIGgbXtOxE
         hnhg==
X-Forwarded-Encrypted: i=1; AJvYcCXlL6Kg599yqCR6BaKEJQkCjfHULDlMhtfttYL+NAl/tB/XKF4Eo/z26f6v6fF1nFDm1bI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzU/OrxRKC2h5FBCRQe5Qwpalt88Ufan0CBiuBXK4p2uuEoHz1t
	w6s3lCPnJRStpqDE1HIuBqQQeyiVcYugDxO2Ines2rI8uB2WvvK9/GWXCM1kzr1Ds6SSg5Y1db6
	+9Q==
X-Google-Smtp-Source: AGHT+IEtQfaHsTrhBTIFHko0gpIlHMJl5CnUaVwMkKgniEw9UZfriGGKCvXVCxVHr/BGlkoEIHr/wUFj6/s=
X-Received: from pjbok7.prod.google.com ([2002:a17:90b:1d47:b0:2f9:d5f9:128f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5486:b0:2ee:48bf:7dc3
 with SMTP id 98e67ed59e1d1-2fbf5c10a46mr1908251a91.15.1739321217707; Tue, 11
 Feb 2025 16:46:57 -0800 (PST)
Date: Tue, 11 Feb 2025 16:46:56 -0800
In-Reply-To: <Z6sReszzi8jL97TP@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250211025442.3071607-1-binbin.wu@linux.intel.com>
 <20250211025442.3071607-6-binbin.wu@linux.intel.com> <Z6r0Q/zzjrDaHfXi@yzhao56-desk.sh.intel.com>
 <926a035f-e375-4164-bcd8-736e65a1c0f7@linux.intel.com> <Z6sReszzi8jL97TP@intel.com>
Message-ID: <Z6vvgGFngGjQHwps@google.com>
Subject: Re: [PATCH v2 5/8] KVM: TDX: Handle TDG.VP.VMCALL<MapGPA>
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Binbin Wu <binbin.wu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, 
	kvm@vger.kernel.org, rick.p.edgecombe@intel.com, kai.huang@intel.com, 
	adrian.hunter@intel.com, reinette.chatre@intel.com, xiaoyao.li@intel.com, 
	tony.lindgren@intel.com, isaku.yamahata@intel.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2025, Chao Gao wrote:
> On Tue, Feb 11, 2025 at 04:11:19PM +0800, Binbin Wu wrote:
> >
> >
> >On 2/11/2025 2:54 PM, Yan Zhao wrote:
> >> On Tue, Feb 11, 2025 at 10:54:39AM +0800, Binbin Wu wrote:
> >> > +static int tdx_complete_vmcall_map_gpa(struct kvm_vcpu *vcpu)
> >> > +{
> >> > +	struct vcpu_tdx *tdx =3D to_tdx(vcpu);
> >> > +
> >> > +	if (vcpu->run->hypercall.ret) {
> >> > +		tdvmcall_set_return_code(vcpu, TDVMCALL_STATUS_INVALID_OPERAND);
> >> > +		tdx->vp_enter_args.r11 =3D tdx->map_gpa_next;
> >> > +		return 1;
> >> > +	}
> >> > +
> >> > +	tdx->map_gpa_next +=3D TDX_MAP_GPA_MAX_LEN;
> >> > +	if (tdx->map_gpa_next >=3D tdx->map_gpa_end)
> >> > +		return 1;
> >> > +
> >> > +	/*
> >> > +	 * Stop processing the remaining part if there is pending interrup=
t.
> >> > +	 * Skip checking pending virtual interrupt (reflected by
> >> > +	 * TDX_VCPU_STATE_DETAILS_INTR_PENDING bit) to save a seamcall bec=
ause
> >> > +	 * if guest disabled interrupt, it's OK not returning back to gues=
t
> >> > +	 * due to non-NMI interrupt. Also it's rare to TDVMCALL_MAP_GPA
> >> > +	 * immediately after STI or MOV/POP SS.
> >> > +	 */
> >> > +	if (pi_has_pending_interrupt(vcpu) ||
> >> > +	    kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending)=
 {
> >> Should here also use "kvm_vcpu_has_events()" to replace
> >> "pi_has_pending_interrupt(vcpu) ||
> >>   kvm_test_request(KVM_REQ_NMI, vcpu) || vcpu->arch.nmi_pending" as Se=
an
> >> suggested at [1]?
> >>=20
> >> [1] https://lore.kernel.org/all/Z4rIGv4E7Jdmhl8P@google.com
> >
> >For TDX guests, kvm_vcpu_has_events() will check pending virtual interru=
pt
> >via a SEAM call.=C2=A0 As noted in the comments, the check for pending v=
irtual
> >interrupt is intentionally skipped to save the SEAM call. Additionally,

Drat, I had a whole response typed up and then discovered the implementatio=
n of
tdx_protected_apic_has_interrupt() had changed.  But I think the basic gist
still holds.

The new version:

 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
-       return pi_has_pending_interrupt(vcpu);
+       u64 vcpu_state_details;
+
+       if (pi_has_pending_interrupt(vcpu))
+               return true;
+
+       vcpu_state_details =3D
+               td_state_non_arch_read64(to_tdx(vcpu), TD_VCPU_STATE_DETAIL=
S_NON_ARCH);
+
+       return tdx_vcpu_state_details_intr_pending(vcpu_state_details);
 }

is much better than the old:

 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
 {
-       return pi_has_pending_interrupt(vcpu);
+       bool ret =3D pi_has_pending_interrupt(vcpu);
+       union tdx_vcpu_state_details details;
+       struct vcpu_tdx *tdx =3D to_tdx(vcpu);
+
+       if (ret || vcpu->arch.mp_state !=3D KVM_MP_STATE_HALTED)
+               return true;
+
+       if (tdx->interrupt_disabled_hlt)
+               return false;
+
+       details.full =3D td_state_non_arch_read64(tdx, TD_VCPU_STATE_DETAIL=
S_NON_ARCH);
+       return !!details.vmxip;
 }

because assuming the vCPU has an interrupt if it's not HALTED is all kinds =
of
wrong.

However, checking VMXIP for the !HLT case is also wrong.  And undesirable, =
as
evidenced by both this path and the EPT violation retry path wanted to avoi=
d
checking VMXIP.

Except for the guest being stupid (non-HLT TDCALL in an interrupt shadow), =
having
an interrupt in RVI that is fully unmasked will be extremely rare.  Actuall=
y,
outside of an interrupt shadow, I don't think it's even possible.  I can't =
think
of any CPU flows that modify RVI in the middle of instruction execution.  I=
.e. if
RVI is non-zero, then either the interrupt has been pending since before th=
e
TDVMCALL, or the TDVMCALL is in an STI/SS shadow.  And if the interrupt was
pending before TDVMCALL, then it _must_ be blocked, otherwise the interrupt
would have been serviced at the instruction boundary.

I am completely comfortable saying that KVM doesn't care about STI/SS shado=
ws
outside of the HALTED case, and so unless I'm missing something, I think it=
 makes
sense for tdx_protected_apic_has_interrupt() to not check RVI outside of th=
e HALTED
case, because it's impossible to know if the interrupt is actually unmasked=
, and
statistically it's far, far more likely that it _is_ masked.

> >unnecessarily returning back to guest will has performance impact.
> >
> >But according to the discussion thread above, it seems that Sean priorit=
ized
> >code readability (i.e. reuse the common helper to make TDX code less spe=
cial)
> >over performance considerations?
>=20
> To mitigate the performance impact, we can cache the "pending interrupt" =
status
> on the first read, similar to how guest RSP/RBP are cached to avoid VMREA=
Ds for
> normal VMs. This optimization can be done in a separate patch or series.
>=20
> And, future TDX modules will report the status via registers.

