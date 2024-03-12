Return-Path: <kvm+bounces-11643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 37A99878EF0
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 07:51:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DD43A281E81
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 06:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0416669950;
	Tue, 12 Mar 2024 06:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b="1PJM6vty"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1CD69944
	for <kvm@vger.kernel.org>; Tue, 12 Mar 2024 06:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710226306; cv=none; b=g69de4POLaWlHZnhzWtThRcLSrpsDpIisqF8I0UrW7ovSLC/aXEs3Fzi3lBt75vVtcJTiK9v8TR6xrcchZquT+cC6SNxORF9voEs3Tgyw8bW1phGpZ2B05HG4w0kGThYVPlt7sNUFMn8NxLoHFJMjETDtT9jwJr805D7ScLjseQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710226306; c=relaxed/simple;
	bh=C+y9lhjPOJixZnvKMHISpcq3TzzvTdUzoTg8dFQyfHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kA7lw83uwrb2bTSp/zxAl6tKLek6OdBRa2BHguOAJ4ck54jn71eZs0xsiKGmbuzBr+j4YHDBD9e96BXu4rWF/jkzzWHWfbirTeS5zZdAB1qC9q77feh3g7vgMPPAOuLC2nIPmPaysev76gXRx/Z4hrRd4XwIU7uD/6HqRYxGBrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org; spf=none smtp.mailfrom=brainfault.org; dkim=pass (2048-bit key) header.d=brainfault-org.20230601.gappssmtp.com header.i=@brainfault-org.20230601.gappssmtp.com header.b=1PJM6vty; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainfault.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=brainfault.org
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-36524116e30so19011685ab.0
        for <kvm@vger.kernel.org>; Mon, 11 Mar 2024 23:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brainfault-org.20230601.gappssmtp.com; s=20230601; t=1710226303; x=1710831103; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9jlbn6Y6RDa3oPVQhvM8AoFcycNttM1/rKlfiZkBWl0=;
        b=1PJM6vty2WDHZDKt4Y7b35oq/CfPZ92++CwsXshz77AC28PDQiDvgS7Krx7R4N+br1
         hd6tzCCl5LqsDoUeaSMy+k2fh2xg5nLiN2sz8b8+q5CinvzYnSjXfjF5w43UBda5nmey
         hXOwJ7OmrDxfKLqCS3fexyBbdMNAm9WEqfpdytWjXrGRwtEEvGqUUswPvEFgQP5LL4Ij
         3QfbgzqizKihFImuo7TWHoA331e0yUh4IFcfaXdKTkIae5Q8l4zSm74w9uGHGUBh8woa
         uEIg6Z2Wmu/VA8MYH2rTDLOQPIq+XOJMNalsfs3CQ/O08Pl/CDv2JAHyKnhK0Du8k3Ux
         JhaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710226303; x=1710831103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9jlbn6Y6RDa3oPVQhvM8AoFcycNttM1/rKlfiZkBWl0=;
        b=AKgW0gmlUly+/jCiDdWJoaNvKXKzopNxH+DPtt0iVWQpKovpt2UYGpUm7jd35d4zsN
         AunGO4XWMIVnZ8XwI5WQgnF/dbxMDFuGM3CRMft2maM+/9xpnHWR0Z++HN5WaUTsbcxT
         kQ1LLwYo1U0rMwZGXOmOohyd2AA7pB8Dohhx55H+jD16wBSvfeLnbSS5hRDiKo2b7gFz
         kSBGPgA/LCxlQvhcLR9yRKZkV1mkUM0j08sKeOiaiqfhU3LELhn9FEyaVkVTOUh0Rg1z
         LVaK4boxcEx16Hb2NsUEO6MkFXUVvlUTeM80LDokYCIotGnzmGNxXTsS3GXl0z4aimEa
         XAzA==
X-Forwarded-Encrypted: i=1; AJvYcCV0X/R8EMqj0z69y3dt2unz1OAMldHFt+sE/AB6CCl09/Q9dN3PkYCrptWm1pv6dk+bUnm7vNRSk0TJW39fQznTgF/P
X-Gm-Message-State: AOJu0YxjVGpigL4kUuNEOZERM3PseIHdgr8XJNRvONwciLJEDNQae0Gd
	0FVrVted1czA8MZGuUgz7QcSaqsjLn6fhgHEXMeplbF1CX9XPL/5C8PzBB21ICDdKM6OikGVRVd
	ObpK3/7kcaq9vSftIVbNwR5dV5iFEOhoQErAAkg==
X-Google-Smtp-Source: AGHT+IE+UAUPCSg5o/PrsQAcGrTsJf88kKmlwJBozqCvIfVtKdOiN8DWNHUTp+k6166aKqtWYTGV5HUAsA0LSDNfteY=
X-Received: by 2002:a05:6e02:1a26:b0:365:b614:5cb4 with SMTP id
 g6-20020a056e021a2600b00365b6145cb4mr1105311ile.29.1710226303335; Mon, 11 Mar
 2024 23:51:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy1rYFoYjCRWTPouiT=tiN26Z_v3Y36K2MyDrcCkRs1Luw@mail.gmail.com>
 <Zen8qGzVpaOB_vKa@google.com> <CAAhSdy2Mu08RsBM+7FMjkcV49p9gOj3UKEoZnPAVk92e_3q=sw@mail.gmail.com>
 <ZesxeoyFZUeo-Z9F@google.com> <6091398f-a2b3-4dc9-9f33-d7459a0a9594@redhat.com>
In-Reply-To: <6091398f-a2b3-4dc9-9f33-d7459a0a9594@redhat.com>
From: Anup Patel <anup@brainfault.org>
Date: Tue, 12 Mar 2024 12:21:31 +0530
Message-ID: <CAAhSdy2XEwtn47E5R93gGYHvDv5J0NSWXWyrmhe_kjQAw79N_w@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.9
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 11, 2024 at 7:40=E2=80=AFPM Paolo Bonzini <pbonzini@redhat.com>=
 wrote:
>
> On 3/8/24 16:40, Sean Christopherson wrote:
> > You're missing the point.  I don't care when patches land in the RISC-V=
 tree, nor
> > do I care that you made a last minute tweak to fix a bug.  I care when =
commits
> > show up in linux-next, and*none*  of these commits were in linux-next u=
ntil
> > yesterday.
> >
> >    $ git tag -l --contains 2c5af1c8460376751d57c50af88a053a3b869926
> >    next-20240307
> >    next-20240308
> >
> > The*entire*  purpose of linux-next is to integrate*all*  work destined =
for the
> > next kernel into a single tree, so that conflicts, bugs, etc. can be fo=
und and
> > fixed*before*  the next merge window.
>
> Indeed, and this is more important as more work is routed towards
> different trees.  At this point we have 5 more or less active
> architectures, and especially in selftests land it's important to
> coordinate with each other.
>
> Anup, ideally, when you say that a patch is "queued" it should only be a
> short time before you're ready to send it to me - and that means putting
> it in a place where linux-next picks it up.  For x86 I generally compile
> test and run kvm-unit-tests on one of Intel or AMD, and leave the
> remaining tests for later (because they take a day or two), but in
> general it's a matter of days before linux-next get the patches.
>

Currently, I was collecting patches in the queue and allowing people
(including myself) to test the queue for a longer time and updating
"next" branch only a couple of weeks before I send PR.

Going forward, I will follow your suggestion. This means once a
series is tested on queue, I will move it to the "next" branch sooner
so that "linux-next" picks it sooner.

Regards,
Anup

