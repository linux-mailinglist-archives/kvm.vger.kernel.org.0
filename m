Return-Path: <kvm+bounces-32119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D0199D3304
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 05:54:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4920B22CE2
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 04:54:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2A5158858;
	Wed, 20 Nov 2024 04:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vRRieKB9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C3315098B
	for <kvm@vger.kernel.org>; Wed, 20 Nov 2024 04:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732078466; cv=none; b=ISJAI8OfZT3BDIqPb0+XflvnDoMQzRZaII7+J1pTFG8/IuJ791lyMN0FeN/WWh1eZGFRDjyJMdAztrx2mdZACWFSdIOYroSYGy7rLGT0CvPKIlErbu0F260KwuNbN8UOwurIyRZ6nsnE9QoecvG0HIDwXOsUUDK86mZ0C5gIgQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732078466; c=relaxed/simple;
	bh=Ljz1BrQoWBFpeQ9m1RBteXaIKOeLwRVMaB6NrIwZjxI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fDYk+q7SQL/n3GEIcIbyUg9zaQr5pH1KBqjRn2nL0x33bGS6qLT4rLb+BC2mJBhBLTN1n15lzUC4tXUa92FTkxtUZRt/7cZY2efYAyXolMOI/WY9pstbj45T6aYKcL6xOxjLn3aiEtDxUoMsGygznKMHsvORnGx5xfY6OM9uYJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vRRieKB9; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-5cef772621eso8123074a12.3
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 20:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732078463; x=1732683263; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+w9doJ3O9i/6/XMKrJrXKq0re8dFhV90KwO8YySlAAY=;
        b=vRRieKB9DbTTdn4Y4mOziFJYknrUcAuHHohR0+GX3NXcUbvihp0/WmNqw+ZmwA8Iur
         4dY5fLgK5u/T42phMTQPZXdgVlKrxAwbdfhkR+hS1FQ8iJ5Zo+kPVCOnVps41tUWHd6e
         ye77gfyy+AAI3TtfDo5pR7O26dcAMQOsi8PL5epADePgU5jeAHMTgDKQEydpTbIWljaT
         UxxJqXDtHGC0oNBt4HnZuQrAhYmsPoFBlA3PuLdTe883QIrT+fdVtwB+ENepxAb0pyyT
         msZ7noNtk2ZMFdTxW5O0tpRoRjVCvKx9XxG2cSc+2kfOh4VhOqScT+C3H43YR22ich0A
         fj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732078463; x=1732683263;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+w9doJ3O9i/6/XMKrJrXKq0re8dFhV90KwO8YySlAAY=;
        b=VNZ3+bl1l3S4z/6kIVuUDQHwr5XXoKooDVi8ymn4ZCXle3aTULk7W100/0o9e4OHCg
         PECkO+v6oJODNQavVOQdcEN9l6YZcz3f+Er3GzcEPdv19D5GlWYD21qtl5fKbK7o29tJ
         gPYGdKrjkZK9kAAp7qF7dBgQGmJUo0Layjaz37HpP3NlZjloDfwOa78TeY/j+4dit1eB
         rUMdkzpxN4cdC8FBv0aAVIs7gQsfvH0VIMsrzxAj7oOtUbrwJcG+OiwMJ3gvyJbCgIH5
         GuDg0n4UI1VFa3b5PB7SKPQxw4yzdrv8icskpj/PaLpyMtu92SqtezXV+J7YItvpiIuV
         dHJQ==
X-Gm-Message-State: AOJu0YykLj355Ye4Orkzs4ilVBDU1FdrAcQj33+DBFd7yj4Mo+vBtjaV
	MVYZK5qkaBPwGnIcn1vxL0VnU9fuqxL+7WIH6IOaaUO+iKqcWyUQ/QwwrU0MsP+5ttA/zJhqF5G
	wB209zFmpP77dSIFOtsAmNCO1L2Cyg5VPdDRM
X-Google-Smtp-Source: AGHT+IEos66313b6UbkDPdhPCR7c7Rdq6Wz6ePwqCzAV+nNb/KnIiVj6Io9mpvbYz+26LP7GyAuEAEv8qrF03Msz1Og=
X-Received: by 2002:a17:906:dacc:b0:aa4:9ab1:196a with SMTP id
 a640c23a62f3a-aa4dd551c83mr107508966b.21.1732078463132; Tue, 19 Nov 2024
 20:54:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241119133513.3612633-1-michael.roth@amd.com> <20241119133513.3612633-2-michael.roth@amd.com>
In-Reply-To: <20241119133513.3612633-2-michael.roth@amd.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Tue, 19 Nov 2024 20:54:12 -0800
Message-ID: <CAAH4kHZ_A7-dNyMiyrZ2p46te=Xi7SRosS_kSjYvG6sJTcmb7A@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] KVM: Introduce KVM_EXIT_COCO exit type
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, x86@kernel.org, pbonzini@redhat.com, 
	seanjc@google.com, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com, 
	liam.merwick@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 5:51=E2=80=AFAM Michael Roth <michael.roth@amd.com>=
 wrote:
>
> +struct kvm_exit_coco {
> +#define KVM_EXIT_COCO_REQ_CERTS                0
> +#define KVM_EXIT_COCO_MAX              1
> +       __u8 nr;
> +       __u8 pad0[7];
> +       __u32 ret;
> +       __u32 pad1;
> +       union {
> +               struct {
> +                       __u64 gfn;
> +                       __u32 npages;

Should this not also include a vmm_err code to report to the guest? We
need some way for user space to indicate that KVM should write the
vmm_err to the upper 32 bits of exit_info_2.
I don't think we have a snapshot of the GHCB accessible to userspace.

I'm still not quite able to get a good test of this patch series
ready. Making the certificate file accessible to the VMM process has
been unfortunately challenging due to how we manage chroots and VMM
upgrades.
Still, I'm stuck in the VMM implementation of grabbing the file lock
for the certificates and asking myself "how do I tell KVM to write
exit_info_2 =3D (2 << 32) | (exit_info_2 & ((1 << 32)-1) before entering
the guest?"
A __u32 vmm_err field of this struct would nicely make its size 64-bit alig=
ned..

--=20
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

