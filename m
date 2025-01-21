Return-Path: <kvm+bounces-36156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31D67A1824F
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:52:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D847F168A20
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C23211F4E32;
	Tue, 21 Jan 2025 16:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kn1j32tF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7969219DFAB
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 16:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737478327; cv=none; b=m7Duhi2CVQq+xXNdWBRPBK5JM/xea3rWcN7i/n4qvGgG7Z8bJ4GATLqMASagTWK8sEhzw9htGPthUPZCSTgv4G0HAhXqXd1YD3E1Vx6SYHuzOMKHeQFSpp83Wy3xpB/D+O6bAUmDMN6qisUvH1vYaL3s+OSXpSqywrmrOiCmDt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737478327; c=relaxed/simple;
	bh=Cfq7dOuH8IKxACGY1ONgtep+oYU2dAXFSEktjpolXKQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LbBcLhGPyhmH7KbU+SVBRvSLt3Qe1pb7Y2Bb1K+/mfGMk15nRERyyjvh/N8vcVKWO73wilyUt0bLYEM3w61RRQfdDa4YH1UoW7jLJkGB8x6yFy18Ps6iSBuUx/fm7J+infV7bgoKV1EJ4zHePhq3+hZ52vp3ae5B/Ptjb9veLDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kn1j32tF; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2ef79d9c692so16020604a91.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 08:52:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737478325; x=1738083125; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vanCL9vX2YGo3j10SsliegdRcGeoN0tzUbAnVNu00e4=;
        b=Kn1j32tF8+mEABWl6spRGTE8gQDykXh+ShpGS3FVlAVUu44tSzUPYKG0NTJBfLPmsD
         LYDvZKgdP3MFzsepG/9DsZ00tJc9L261cvQTMD3adBabr1tS44rNqeJqooJ+LitUQYgE
         nnYQmO1ntkcmDiOB4jlztItt5KQERseqqeqbvE6jg3H/nOl8GYiWi3K3WUwGJJuY7aBp
         aYkbHI+lLdUhJFIDERIsZI4/07O6lFx9WQ2v79rNoGAASZHuBeXUQF28zmiGKdOfIIs6
         B8oJMz9Le90gp3vlite6UfshE8NxcUoLcs8cdMSK6z2FfHRnqGJZAybg3fMfeNJcWXcZ
         rxNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737478325; x=1738083125;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vanCL9vX2YGo3j10SsliegdRcGeoN0tzUbAnVNu00e4=;
        b=R23PT9PE88OGOumf7jujC1x0rLKzNBK43oU9x8wzvRV/Sq91f72ESSF50j6TC+dS2x
         65ZsuvzZBSmIzyMzzzsE3hrY01w440d+KJxVvY7pPA5r20bMsajfTGAu3UzDBMQ+AbJ8
         3heUm/g+9FiY7GBnbZWVSdZisiZnU952JwFZTo+R3zXB4bCPYWTcVyil3Rq5wocNXPAR
         NlgOiebc+0nthR0czKVKR/JF+J7fsX7pu6Z+DqAUQ61hNMCcixSHv2+EsEnSHtaqcmd7
         TJpmIPsf6VUYfYCiMLDwuvX/inTCR+3A3zAUucZHjY1udNGTvIua++r+sdd0fxnEf8HS
         rmvg==
X-Forwarded-Encrypted: i=1; AJvYcCVfI5VI0bIPHkQSH41cg1+yJFlSrWXWK6G1/HrarGBR4PD2wP8eBw5YC0ng2X3Q92vWe8M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4fUbqJr4P/huXgZ+kYJSJO9eIb2usGo+wpyRJ6JisdMBM/CfZ
	TsdDBG8bETNlEsM8Ey7Y+poCmJVIMXUlkgPhyQ0a3OIhwvpnZ9tNwiEBlwPNixeLbIrwK+YxTJg
	ErQ==
X-Google-Smtp-Source: AGHT+IHXgQjtXQTO+sAFYluyyMRqgYC+WSGpYCWP3vvuJUdftImnUJ8vLEZRgcWJPE48b1Om4zLopDGykcw=
X-Received: from pjbcv6.prod.google.com ([2002:a17:90a:fd06:b0:2ea:29de:af10])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a41:b0:2ea:4c8d:c7a2
 with SMTP id 98e67ed59e1d1-2f782d4ed35mr28239094a91.24.1737478324838; Tue, 21
 Jan 2025 08:52:04 -0800 (PST)
Date: Tue, 21 Jan 2025 08:52:03 -0800
In-Reply-To: <CAAH4kHZL-9R+MLLvArcwQ2Zpk+gtqYTvVMR01WA1kVJ9goq_sw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250120215818.522175-1-huibo.wang@amd.com> <20250120215818.522175-2-huibo.wang@amd.com>
 <CAAH4kHZL-9R+MLLvArcwQ2Zpk+gtqYTvVMR01WA1kVJ9goq_sw@mail.gmail.com>
Message-ID: <Z4_Qs2mAXK28IwJa@google.com>
Subject: Re: [PATCH v4 1/1] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
From: Sean Christopherson <seanjc@google.com>
To: Dionna Amalie Glaze <dionnaglaze@google.com>
Cc: Melody Wang <huibo.wang@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, roedel@suse.de, 
	Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	pankaj.gupta@amd.com, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2025, Dionna Amalie Glaze wrote:
> On Mon, Jan 20, 2025 at 1:58=E2=80=AFPM Melody Wang <huibo.wang@amd.com> =
wrote:
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 943bd074a5d3..4896c34ed318 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -4064,6 +4064,30 @@ static int snp_handle_guest_req(struct vcpu_svm =
*svm, gpa_t req_gpa, gpa_t resp_
> >         return ret;
> >  }
> >
> > +static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
> > +{
> > +       struct vcpu_svm *svm =3D to_svm(vcpu);
> > +       struct vmcb_control_area *control =3D &svm->vmcb->control;
> > +
> > +       if (vcpu->run->snp_req_certs.ret) {
> > +               if (vcpu->run->snp_req_certs.ret =3D=3D ENOSPC) {
> > +                       vcpu->arch.regs[VCPU_REGS_RBX] =3D vcpu->run->s=
np_req_certs.npages;
> > +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > +                                               SNP_GUEST_ERR(SNP_GUEST=
_VMM_ERR_INVALID_LEN, 0));
> > +               } else if (vcpu->run->snp_req_certs.ret =3D=3D EAGAIN) =
{
> > +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > +                                               SNP_GUEST_ERR(SNP_GUEST=
_VMM_ERR_BUSY, 0));
>=20
> Discussion, not a change request: given that my proposed patch [1] to
> add rate-limiting for guest messages to the PSP generally was
> rejected,

For the record, it wasn't rejected outright.  I pointed out flaws in the pr=
oposed
behavior[*], and AFAICT no one ever responded.  If I fully reject something=
, I
promise I will make it abundantly clear :-)

[*] https://lore.kernel.org/all/Y8rEFpbMV58yJIKy@google.com

> do we think it'd be proper to add a KVM_EXIT_SNP_REQ_MSG or
> some such for the VMM to decide if the guest should have access to the
> globally shared resource (PSP) via EAGAIN or 0?

Can you elaborate?  I don't quite understand what you're suggesting.

> [1] https://patchwork.kernel.org/project/kvm/cover/20230119213426.379312-=
1-dionnaglaze@google.com/
>=20
> > +               } else {
> > +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > +                                               SNP_GUEST_ERR(SNP_GUEST=
_VMM_ERR_GENERIC, 0));
> > +               }
> > +
> > +               return 1; /* resume guest */
> > +       }
> > +
> > +       return snp_handle_guest_req(svm, control->exit_info_1, control-=
>exit_info_2);
> > +}

