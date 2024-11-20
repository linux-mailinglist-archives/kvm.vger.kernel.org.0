Return-Path: <kvm+bounces-32120-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A0189D3306
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 05:56:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC0A51F23613
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 04:56:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CCEC157484;
	Wed, 20 Nov 2024 04:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2KHWw+QX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB34742AAB
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 04:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732078555; cv=none; b=NRHN+mkQJUTEIXxJUuZWQ3A37LPU+dfHdBDJ2wccqxKEz1VyWaBhwGng40bvmxqo/K2XQmllQEx2SxEW++WEMlH7LGURWi2CsRKyuYm1WpMx2kHnJR9zz6LSwXRj+zlnnGiV97Kiww0vm4KstspGdOmRf/7GYmUcn15k5qV+4Nw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732078555; c=relaxed/simple;
	bh=qidyDdoPMSrLqOEPcAD7Fm10v61MJZnJnKYjl/6vk68=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oxBoUeDFHBCAl5ahJB2ufcTDzqFAOczUAg5tn+8lKClfngaV/8ZS64nPmcR/CyPqbZIdM6W0p9i7t1+6MWYpPqSLDzewOpcgV5ixjyBFjRliA047/lbprHOTyJuA5+aBXiJEtbMnLDqyXFmkglY2Qap11Fi8B8YvmpDPhJiujk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2KHWw+QX; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-aa20c733e92so704417966b.0
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 20:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732078552; x=1732683352; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rLsyLORpZtZ6b2mAwzZkeZQ6i4pKu4Ce89IT06ouUsE=;
        b=2KHWw+QXDv6nUb3d+NKqaevr/+grlnuz8jQjJ+j+FMPgBK/cVUJyNDSFRA6IyeQWhm
         mDOucjhkUXSm2J1z6IQyKqaLsFNfmywSyjUmIyqkMb19nK2Il9vkqB7SSBw4ACi/WnZK
         URrFbgj36nbc7fOOoXJdParYew5Xd9df8/J/cagsyIDFALwo05rjFUpoMp4wj9JgaLTG
         nTcE/Qks39+gYiaLkrUDnOIFeyWTER1OEsgyYTzzZDlmWUqaPrsyPm/8eCsFVWKYD7pT
         xQuuZzR0Q1/zHC/lEbrY+WAPAwEFNn6nYRD4CZJW/7aSkj5sXnzBc3jP0wGCrZlTTh1y
         KMbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732078552; x=1732683352;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rLsyLORpZtZ6b2mAwzZkeZQ6i4pKu4Ce89IT06ouUsE=;
        b=rUuGkkQ2dXPkHds4WFiK7aelVX2PBsUXOddK+1fRnqRBuzY/xt9Tj0qQLJbzPwNehy
         TgvLG2qZFPIa2NmHBwe8Z5jjQXInuiWeQRpQdacmsQsad6nbULr32Kgh4xF3qs7ChcHz
         jqlUNYc6Nt2xlhHEOIEoDQw2kvL/7EBMSzhxdveqkCTJA/+4hS/lEsjOPVpRjYYz53PA
         Ghgk+5UENJjpw4u09h11FoWNWFKoJZ4gyvcB1BxkLB9KzjeyxRqofwHPyFdPQPDcqnWZ
         Aqx+HNjJWNPJKgXeDG5hORyw/WiMSSfEGO/KXSgNwpPiM2xeeWkKWo8Fh9+Scuxni9zZ
         EYYw==
X-Gm-Message-State: AOJu0YxAaH8b2QVmY7q5WTN/y/yO9IfAwQxdCeb7e9kn2PO8iP0rhvp2
	72SHDsHA0dKdgX7F4T4x9ZQaYtZWu2+13JQSKchq36yLoGkrQCY4oS9jizxFEuk1+bFn4HNWxBB
	3NKACBNLD+9Rx8i8QYEqspZW5gvyRMZ0P9Qph
X-Google-Smtp-Source: AGHT+IGineP2bUXtNwD1Ct4msCtFonm9FZ5ffyQckr3P3Efc8YypLgUph8KTFI3sRkQXjSxM5eevi7MkccDQbnEgqmo=
X-Received: by 2002:a17:907:961e:b0:aa4:777d:7394 with SMTP id
 a640c23a62f3a-aa4dd52feabmr116533166b.11.1732078552227; Tue, 19 Nov 2024
 20:55:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241119133513.3612633-1-michael.roth@amd.com>
 <20241119133513.3612633-2-michael.roth@amd.com> <CAAH4kHZ_A7-dNyMiyrZ2p46te=Xi7SRosS_kSjYvG6sJTcmb7A@mail.gmail.com>
In-Reply-To: <CAAH4kHZ_A7-dNyMiyrZ2p46te=Xi7SRosS_kSjYvG6sJTcmb7A@mail.gmail.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 19 Nov 2024 20:55:40 -0800
Message-ID: <CAAH4kHYncFsa=5NZVX35jk3jicx1fnYTHsLwapHmJ03+TNKa9w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: Introduce KVM_EXIT_COCO exit type
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com, 
	liam.merwick@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 8:54=E2=80=AFPM Dionna Amalie Glaze
<dionnaglaze@google.com> wrote:
>
> On Tue, Nov 19, 2024 at 5:51=E2=80=AFAM Michael Roth <michael.roth@amd.co=
m> wrote:
> >
> > +struct kvm_exit_coco {
> > +#define KVM_EXIT_COCO_REQ_CERTS                0
> > +#define KVM_EXIT_COCO_MAX              1
> > +       __u8 nr;
> > +       __u8 pad0[7];
> > +       __u32 ret;
> > +       __u32 pad1;
> > +       union {
> > +               struct {
> > +                       __u64 gfn;
> > +                       __u32 npages;
>
> Should this not also include a vmm_err code to report to the guest? We
> need some way for user space to indicate that KVM should write the
> vmm_err to the upper 32 bits of exit_info_2.
> I don't think we have a snapshot of the GHCB accessible to userspace.
>
> I'm still not quite able to get a good test of this patch series
> ready. Making the certificate file accessible to the VMM process has
> been unfortunately challenging due to how we manage chroots and VMM
> upgrades.
> Still, I'm stuck in the VMM implementation of grabbing the file lock
> for the certificates and asking myself "how do I tell KVM to write
> exit_info_2 =3D (2 << 32) | (exit_info_2 & ((1 << 32)-1) before entering
> the guest?"
> A __u32 vmm_err field of this struct would nicely make its size 64-bit al=
igned..

retracted. I needed to look 2 lines lower. I need to stop working this late=
.
>
> --
> -Dionna Glaze, PhD, CISSP, CCSP (she/her)



--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

