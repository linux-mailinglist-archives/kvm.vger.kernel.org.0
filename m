Return-Path: <kvm+bounces-36167-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E48AA182BA
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 18:19:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D32893ABB78
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 17:19:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF66D1F5415;
	Tue, 21 Jan 2025 17:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="z5SoA3eR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31C71F37BB
	for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737479965; cv=none; b=V87AFAMDtS8vQom1SLKpkyJiIUkbQR0R7WtqDCzeOYCH+XO08AmzXCm/pZDVItDo9cK70+4gF0DpPaknTwAEXJoRhVH0OtE201QZGiX893waqAlEaVWEfHcEnTfpSbAPBEllSLU/FVhvN2eb61+2wLyeMVHJIiolEyLAcw7luEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737479965; c=relaxed/simple;
	bh=u2B1225CIVkWnANI8zdzZEVtAbUKglhh/qPVN3HdLJs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b6WidyoEO8zfxWA2+7pq49ZNXgP1OCwoiMZFTWNCQtSIpI4thXiZOogafO05+W+CYECV02P4l7RW9IWGHVfO/v3suoupSDRedVor0CWXvJK4tMJGduyd9KPd7/+akJ33MBQFJZVLrL+lEanRI5xx0gKjD7oefnGh9gHCF8hfIIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=z5SoA3eR; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-aaf60d85238so994759666b.0
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2025 09:19:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737479960; x=1738084760; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SvT0wHqFgmeFSd1d/5qNXkmKtyfl0fos/htQQVE14io=;
        b=z5SoA3eRLWWS76Vss4L8i4d2te5gHNi65ll5AwZWimKL1Eye34FmaZgzOprA3xE+sh
         oZMsysz1uWwD1rclj9hS5TdFRvl4N9Rd5n/ZSYrQrx3jmBnKyGxugOzlfWvmCQNoDZ3K
         34MSmHOYnSLhWqtcX9qtm5IZk/zxbXhsWUy+qyH02z/0yK5O4PxSoiUiESvujvIcTifO
         O8Gb3RyMjZqE0daDl4SZ50GfG1Dv+zi6W9LykHeW+K4somad57P6kMBkkq8sJtx9lwBp
         eHSJqhO3mXxmFshKCyjS/3QS1eNuvWlQyIs/LsdUtRY8MJmEo5gr30RXcp1ll1pcb8Y8
         tCjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737479960; x=1738084760;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SvT0wHqFgmeFSd1d/5qNXkmKtyfl0fos/htQQVE14io=;
        b=lPOjWvaf6Czn37+gB/532b+wwdzjBOF4zLB/i0987F4k0kzDrrJ42QmrVlfVf7O+zV
         Deg4316nEBJUq4pVUtSntT11x5I9Tg95Xq6IqG6cRbHvtuFrnXFfujoopLe+shsH+0nT
         8XGYw0gj5rYZIl+oR4fbL5HGrBQq02qrqYc1k79pJPncjNS5MQWgl90Z0fX0IR5vc8/z
         9sOFt/LPRj1mMaXq4E1jihVlzcbXtCjmWEIfcdnJIGTnsaDMedJyiy34cKCr/HWWhmpp
         x9gNixRpOIXIC0hPzs/u7asa017T7NJ9EwL8qz6bKhQyB9Hye1uKEc4BYAbawRpKd/ab
         dcTA==
X-Forwarded-Encrypted: i=1; AJvYcCXNhg4lkZcrCp4ks7JIguhhy4QfMGtButPApumvhee7hxxZ5DMejQ2+Y9Zri2yTikB1fuU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy6PET5GZr5IWeWjC9b5aY0LXRsKebxFr+E1s14yHf6I0hQuOIM
	x1m1yQbcldPg2dEOcDa/GCPPqVLltqVSjdM5WE3Piw8olDN5ALCWG0TkPL7r+zC8V7iODReVVvA
	sTWKK72ZBo8XwPhTFVizbJjoaHBshg4cOg/hL
X-Gm-Gg: ASbGnctOdp++5DAlE0J6Y6E5GvVrkkF6SCB20RJTweyVVA3s/793vZKTdTeD54GwVmG
	db5P+72wfClW6MSBS84k2CqNh6a9/4Pc8hAO0xuaFMYT6GAF1uMM=
X-Google-Smtp-Source: AGHT+IE2T563g0JRgyplghpBnxGXwll27PI7aZixKOdxjYYjAIR13bi252uUwK2w3uc597ZsGhAye1+zlmOPNSiYhDA=
X-Received: by 2002:a17:907:7b88:b0:ab3:61f5:13c7 with SMTP id
 a640c23a62f3a-ab38b4c9b89mr1575632966b.53.1737479959745; Tue, 21 Jan 2025
 09:19:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250120215818.522175-1-huibo.wang@amd.com> <20250120215818.522175-2-huibo.wang@amd.com>
 <CAAH4kHZL-9R+MLLvArcwQ2Zpk+gtqYTvVMR01WA1kVJ9goq_sw@mail.gmail.com> <Z4_Qs2mAXK28IwJa@google.com>
In-Reply-To: <Z4_Qs2mAXK28IwJa@google.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 21 Jan 2025 09:19:08 -0800
X-Gm-Features: AbW1kvaIHOhJ15ezHtXOpMLPtWwxrO6MYTW0Y72uan59Mj6uqWnxbb2NWaU7SY0
Message-ID: <CAAH4kHaCTGxQ_D+KbhJQ+RYL4n5qeG4UnDNu5FK9+3KJLpNw0Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
To: Sean Christopherson <seanjc@google.com>
Cc: Melody Wang <huibo.wang@amd.com>, kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, roedel@suse.de, 
	Tom Lendacky <thomas.lendacky@amd.com>, ashish.kalra@amd.com, liam.merwick@oracle.com, 
	pankaj.gupta@amd.com, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2025 at 8:52=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Jan 21, 2025, Dionna Amalie Glaze wrote:
> > On Mon, Jan 20, 2025 at 1:58=E2=80=AFPM Melody Wang <huibo.wang@amd.com=
> wrote:
> > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > index 943bd074a5d3..4896c34ed318 100644
> > > --- a/arch/x86/kvm/svm/sev.c
> > > +++ b/arch/x86/kvm/svm/sev.c
> > > @@ -4064,6 +4064,30 @@ static int snp_handle_guest_req(struct vcpu_sv=
m *svm, gpa_t req_gpa, gpa_t resp_
> > >         return ret;
> > >  }
> > >
> > > +static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
> > > +{
> > > +       struct vcpu_svm *svm =3D to_svm(vcpu);
> > > +       struct vmcb_control_area *control =3D &svm->vmcb->control;
> > > +
> > > +       if (vcpu->run->snp_req_certs.ret) {
> > > +               if (vcpu->run->snp_req_certs.ret =3D=3D ENOSPC) {
> > > +                       vcpu->arch.regs[VCPU_REGS_RBX] =3D vcpu->run-=
>snp_req_certs.npages;
> > > +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > > +                                               SNP_GUEST_ERR(SNP_GUE=
ST_VMM_ERR_INVALID_LEN, 0));
> > > +               } else if (vcpu->run->snp_req_certs.ret =3D=3D EAGAIN=
) {
> > > +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > > +                                               SNP_GUEST_ERR(SNP_GUE=
ST_VMM_ERR_BUSY, 0));
> >
> > Discussion, not a change request: given that my proposed patch [1] to
> > add rate-limiting for guest messages to the PSP generally was
> > rejected,
>
> For the record, it wasn't rejected outright.  I pointed out flaws in the =
proposed
> behavior[*], and AFAICT no one ever responded.  If I fully reject somethi=
ng, I
> promise I will make it abundantly clear :-)
>

Okay, well it was a no to the implementation strategy I had chosen and
did not have bandwidth to change. Your suggestion to exit to userspace
is more aligned with the topic of discussion now.

> [*] https://lore.kernel.org/all/Y8rEFpbMV58yJIKy@google.com
>
> > do we think it'd be proper to add a KVM_EXIT_SNP_REQ_MSG or
> > some such for the VMM to decide if the guest should have access to the
> > globally shared resource (PSP) via EAGAIN or 0?
>
> Can you elaborate?  I don't quite understand what you're suggesting.
>

I just mean that instead of only exiting to the VMM on an extended
guest request and this capability enabled, all guest requests exit to
the VMM to make the decision to permit access to the device. EAGAIN
means busy, try again later, and 0 means permit the request. That
allows for implementation-specific throttling policies to be
implemented.

> > [1] https://patchwork.kernel.org/project/kvm/cover/20230119213426.37931=
2-1-dionnaglaze@google.com/
> >
> > > +               } else {
> > > +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > > +                                               SNP_GUEST_ERR(SNP_GUE=
ST_VMM_ERR_GENERIC, 0));
> > > +               }
> > > +
> > > +               return 1; /* resume guest */
> > > +       }
> > > +
> > > +       return snp_handle_guest_req(svm, control->exit_info_1, contro=
l->exit_info_2);
> > > +}



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

