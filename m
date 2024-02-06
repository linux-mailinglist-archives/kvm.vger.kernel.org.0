Return-Path: <kvm+bounces-8096-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4370584B20F
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 11:10:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F295D282D95
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 10:10:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F53812E1C0;
	Tue,  6 Feb 2024 10:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="qJZ/R1KK"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 998E712C7E1;
	Tue,  6 Feb 2024 10:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707214199; cv=none; b=rCn091Zs2Rmp6gcn6e0LxGayxw7yuH1RAU3X+BGa9ZjFIx42hMbRqUoTIRJI94hgte9jbVGj9J7H2WhYulTmnIIksQnSQb3enmEHrP77bdR6L4ngA6XQG5D9yesb7lEebzdAQo9Aef1bPxLOqH1r9d9QVFZ7Ba5yTuiNwCUpwnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707214199; c=relaxed/simple;
	bh=ASPBFTN6JvpMCOm0Rs9lW9fp3ECg1irBns2EH3oaCYY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=EL73gJdVV1z3mLghWhQBom1R6qa4lBoIxEfQShQkGIkylqJets7Fs8ZY5qEJk8eykVaVMZeUY/kVeANPHPafYBY8sA4NEZp3011jgUgrYusiSS0+1nZtqdF9+F4+ni8xt7osjCZnIOC12yeQLbf8n7wlm1krrZIDTYU9VO+hudo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=qJZ/R1KK; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1707214191;
	bh=RP5a0ngO4G8agxTcnKwbqd1t/bpdOgoBCm2CsXxO2i8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=qJZ/R1KK16stykfOA9nmlGuWZ5InS09F4RhGl/V4xPS71GVG2TnIZj8uLywVGoXTe
	 HEi5DB7PK//MlMiG2lQiNkt+yMNnjLvuhjJYj4YH4WvPfgUEqeYeaORyn57goS0foX
	 PZCpoEBMuEorR6dGtrmt/uaItDpqbojjLjPbGU1HqCJuPUoaMbI1b5of3HVYDMtDtf
	 m101EkFRmPkSJod2ewWgdqCV55+bjo4d392eMIEzauV4cS+q5AXW069fYbfOv0jSbk
	 o9mz/jbyuERKNn43KY0/E44VGrnip45yQE5xsG+qhpfOr3onEBfbR4oBrrk1ZnTN7x
	 MTq5vgIDO9AxA==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4TTfB748xTz4wyj;
	Tue,  6 Feb 2024 21:09:51 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Amit Machhiwal <amachhiw@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org,
 kvm@vger.kernel.org, kvm-ppc@vger.kernel.org
Cc: Vaibhav Jain <vaibhav@linux.ibm.com>, Nicholas Piggin
 <npiggin@gmail.com>, Jordan Niethe <jniethe5@gmail.com>, Vaidyanathan
 Srinivasan <svaidy@linux.ibm.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, "Naveen N . Rao" <naveen.n.rao@linux.ibm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>, Amit Machhiwal
 <amachhiw@linux.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: PPC: Book3S HV: Fix L2 guest reboot failure due
 to empty 'arch_compat'
In-Reply-To: <20240205181833.212955-1-amachhiw@linux.ibm.com>
References: <20240205181833.212955-1-amachhiw@linux.ibm.com>
Date: Tue, 06 Feb 2024 21:09:48 +1100
Message-ID: <87r0hp9a4z.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Amit,

One comment below ...

Amit Machhiwal <amachhiw@linux.ibm.com> writes:
> Currently, rebooting a pseries nested qemu-kvm guest (L2) results in
> below error as L1 qemu sends PVR value 'arch_compat' == 0 via
> ppc_set_compat ioctl. This triggers a condition failure in
> kvmppc_set_arch_compat() resulting in an EINVAL.
...
>  	
> diff --git a/arch/powerpc/kvm/book3s_hv_nestedv2.c b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> index 5378eb40b162..6042bdc70230 100644
> --- a/arch/powerpc/kvm/book3s_hv_nestedv2.c
> +++ b/arch/powerpc/kvm/book3s_hv_nestedv2.c
> @@ -347,8 +348,26 @@ static int gs_msg_ops_vcpu_fill_info(struct kvmppc_gs_buff *gsb,
>  			break;
>  		}
>  		case KVMPPC_GSID_LOGICAL_PVR:
> -			rc = kvmppc_gse_put_u32(gsb, iden,
> -						vcpu->arch.vcore->arch_compat);
> +			/*
> +			 * Though 'arch_compat == 0' would mean the default
> +			 * compatibility, arch_compat, being a Guest Wide
> +			 * Element, cannot be filled with a value of 0 in GSB
> +			 * as this would result into a kernel trap.
> +			 * Hence, when `arch_compat == 0`, arch_compat should
> +			 * default to L1's PVR.
> +			 *
> +			 * Rework this when PowerVM supports a value of 0
> +			 * for arch_compat for KVM API v2.
> +			 */

Is there an actual plan that PowerVM will support this in future?

If so, how will a future kernel know that it's running on a version of
PowerVM that does support arch_compat == 0?

Similarly how will we know when it's OK to drop support for this
workaround?

cheers

