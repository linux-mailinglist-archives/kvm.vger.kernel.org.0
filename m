Return-Path: <kvm+bounces-67452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9562FD05755
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 19:21:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 68F0C3042FD7
	for <lists+kvm@lfdr.de>; Thu,  8 Jan 2026 18:20:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3B031062E;
	Thu,  8 Jan 2026 18:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l9tDBaeN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7328530FC3E
	for <kvm@vger.kernel.org>; Thu,  8 Jan 2026 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767896454; cv=none; b=Prp1EMHYoZV2Yf9Eld7tF7EDLfuMaTvDT1Ya/vi4Zh6coHn/EZENd4aqaWciEILiHvceFK55rXBzLeHVNxuLNDJWD8KEOJ4e4ONXIgmTFSSq/BDpW15Otso+vS0xqS1yaXmnBgHFf5BjmOtbFo4egZok3KO+a5NXLVjT4EfH/Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767896454; c=relaxed/simple;
	bh=GzuqYe/6g3NXsycaPJ3wfrGJWIZ9Zq2hM7oJaoMdsKc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gCLzUzvuVqE/1P6zr82fTsAi7QbRtZhu3LTDbSrlEBIGrurvPCuMRV0lNkPJm1XwpgCpHJiou9A69owt78JTfdQ83LJUZKtc87Xi0/ZBpvYC/FTp5SqahSM5udBZncpBi/5u5CYWf0/C0sPkfmpiBzMBNgJnJrZ6P308HXwT+S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l9tDBaeN; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-59b6d5bd575so2713249e87.1
        for <kvm@vger.kernel.org>; Thu, 08 Jan 2026 10:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767896451; x=1768501251; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qIWbnb8wuVC6CuULSZXd500nKi+vGu5lt07cRCcuv7s=;
        b=l9tDBaeNp3+kLcEW9d+Kldiz02VwGoT24dhp+LJ0gXfy8BkIyYYExSmxwSGS/m3mRL
         7wQvums+dk/OcEdVvNZjpLz84J/VFviM6EO7Khl6bl5aeGE4tX/X7mHzyahJA9kBJGMl
         nlywFHjqG1Ts7YaIWh7YgpKAQjXtj5lutGG20naWUWacg/25D0UvUk/OqbaKSyp6BkPC
         p2LkCiGHjc0EeBrVl9EDq/oRIG38q/boQsY8cq32Wi3Wc2pAOrcA+jm66qhjTMTmcc9F
         hBjqwPMqC7V0QIXgIrj9zksRCVQsS7kSPnyH9o3XsnVw1+IFBHiywgFAnespzXwrONwO
         z07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767896451; x=1768501251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qIWbnb8wuVC6CuULSZXd500nKi+vGu5lt07cRCcuv7s=;
        b=EUK7GDPkJ2adTuzHBOMM+9n7okVvTjjmPzhAuoQ8vI4gB6NTsUznWUppIOwmZbEi0q
         aETC5DWu4shmjTH10cSBik4JMpDSIf0Da5tnYRQrsBfZwxJDYaDX7e2kiaUWs56XXUaE
         oFZQi/JPH3dwvN5YILAH+a+G0msowGm8iXu3EU9019BVb43tSQmenkiheEeGAEClZ+yf
         tXamG9CPNfBczqXkbE9IA0w3Oa0SY9sV3DxNZOkVQdoDOBhtNGX8Nag9c02KM27PYRsa
         Eki+cNSFYG1yXWQTGxd14yFXsRFtYaMkos2scbb0gzJfBbwvQtHFL6ePuVyK061hB1tt
         48kw==
X-Forwarded-Encrypted: i=1; AJvYcCX1QuyuFyOJrjQQ5yAY5T7Qu3C+ur3qQsbO770rxkI3ZdCIuWj6mCxNgqE14pPj0y83yC4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPnCWrSHzniiF8a/dMDArsP9RD0VohNtC7KYEXpwWE9sYrpmhP
	1KN/NL46lFbyC0VPZVVxuNxh2Z89MWFVdRAYGVrQcB/QE1HMn04a1b+tDcUXukNKrQXZICDzpcS
	i/Cl/cWr46ci6JgPOVP7ArMqOgS4pOKvX+D2vS7YRijIP9yy5n/92I/zGoaQ=
X-Gm-Gg: AY/fxX42X1OQfyQ5l4omC7FRdYvDTXYnzUgyBVYHQ3mVg0ZC5NPjtJZipc1RqkA9ngH
	FateGtBziHt6Q7R3QkIIuXQ67Yiqv+lp7IbId0ApsOj5trrdhFDWFHu6xKeff9mIwdcGZdSH/uN
	0WHHAg91Yc+K5GE10f7IOyXhid20P0735TD+BbZfgeO9bpRpr3T7ooISefniaCZycmZeG7Nf8zF
	IhJQ8zP4IfXp09dB+kFZK225A/LHOB2pp+pdzh/HSvqM/9wSyDDD/mkoH1iUP2XAbEW2nf9
X-Google-Smtp-Source: AGHT+IGlNr+3Kfg1ZZ1Rz3y9SDsVCFvv2d1eRF6oYKoBZYZUZix/Hoq5N+7xb5AEgTcbVMLSMIeLtGWM+CA8pDiBRA8=
X-Received: by 2002:a05:6512:33ca:b0:59b:77f8:910a with SMTP id
 2adb3069b0e04-59b77f89309mr957015e87.19.1767896450308; Thu, 08 Jan 2026
 10:20:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260107-scratch-amastro-vfio-dma-mapping-mmio-test-v1-1-0cec5e9ec89b@fb.com>
 <aV7yIchrL3mzNyFO@google.com> <aV8mTHk/CUsyEEs1@devgpu015.cco6.facebook.com> <20260108084208.30edd533@shazbot.org>
In-Reply-To: <20260108084208.30edd533@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Thu, 8 Jan 2026 10:20:22 -0800
X-Gm-Features: AQt7F2qKH486tR5MMOncEkjWyL_zCi9lKI_qFkK-DGaW8N_GezgP57tFurPCsY0
Message-ID: <CALzav=ctJBKYsYQ47XMHDQ_whzF=XpcsN6B6GmGc9gy4-tPfzg@mail.gmail.com>
Subject: Re: [PATCH] vfio: selftests: Add vfio_dma_mapping_mmio_test
To: Alex Williamson <alex@shazbot.org>
Cc: Alex Mastro <amastro@fb.com>, Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.com>, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Jason Gunthorpe <jgg@ziepe.ca>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 7:42=E2=80=AFAM Alex Williamson <alex@shazbot.org> w=
rote:
>
> On Wed, 7 Jan 2026 19:36:44 -0800
> Alex Mastro <amastro@fb.com> wrote:
> > On Wed, Jan 07, 2026 at 11:54:09PM +0000, David Matlack wrote:
> > >
> > > Speaking of, maybe we can add a test that creating writable IOMMU
> > > mappings fails for read-only BARs?
> >
> > I think I'll have to look into this as a follow-on. I'm not sure how to=
 validate
> > it yet without mocks or similar since I don't have such HW.
>
> I think the read-only aspect would be in the mmap, not the BAR itself,
> ie. can we create a read-write DMA mapping to a read-only mmap.

Good point. So it'd be better to have a test of that in
vfio_dma_mapping_test. No need to use a BAR mapping.

> ROM BARs are the only BARs that are read-only, but they can share a
> decoder with the standard BARs and therefore have a separate enable in
> the BAR register itself.  Due to this, and their general usage, it's
> never been necessary to allow mmap of the ROM BAR, therefore we cannot
> actually DMA map the ROM BAR.  Thanks,

Ahh, good to know, thanks for the context!

