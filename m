Return-Path: <kvm+bounces-32575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B5869DAC2B
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 18:00:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2BA6716481D
	for <lists+kvm@lfdr.de>; Wed, 27 Nov 2024 17:00:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A75C201007;
	Wed, 27 Nov 2024 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SHdN3tAq"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB173FB8B
	for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 17:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732726812; cv=none; b=kGxJPjyCpyjtlcy38BPLsApV6YpBCNoFUpEtCKXCQrMiL4PmOlXxx3SjmP8j9CEMdjziG2bFTqxcLxDOtuQ1+dQgzN5wsDIqvJ1pka60ptGFIQZHaIYGJS7EThldBV9nsGGBy5pD02JmU0XCj5Mk4LLLN5Q9DeioVEUVN07lGQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732726812; c=relaxed/simple;
	bh=tFu8AMI5BKD4w9+zYVCgjxE9cnTJj6BcKXX/vTAlizM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fc9Zmt1MwfbOFjRs3eVQmECxBrYAzzF4TJ9z4J/tXDZXJpm+3xmCnkA/uW7tliPvcC0QTYnAw+dZS9ev+UBIJcfWEryA1rZaQOzxAAGeOrNy/0beLLQ3zEiMPAYhGa1RAw05mEgOIzItBCrEpItBdmdZbbsUj543f8RjOi6KuQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SHdN3tAq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732726809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jJR3B0odsZQHf7sVwTNPbyRTbyljXTxWTLBZbD2FzwQ=;
	b=SHdN3tAqftIwLOeuApKC8ngeDhBIWV1JTQaRzjgPjuzRUh/2ve8TlAUVGshjo3rPhiBLBa
	Nfa3BG/w4MDLfy6p4MD5rbICeyhdwBOwUrNciAc/pS9Ku00qdd7kHV3I3z2qOi6GCVCslZ
	yLs0AoT2LmMeTssbBeOIAasRGOiVyRk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-Dw46InjBMYOEOeyGshxi3g-1; Wed, 27 Nov 2024 12:00:08 -0500
X-MC-Unique: Dw46InjBMYOEOeyGshxi3g-1
X-Mimecast-MFC-AGG-ID: Dw46InjBMYOEOeyGshxi3g
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-434a876d15cso5588805e9.0
        for <kvm@vger.kernel.org>; Wed, 27 Nov 2024 09:00:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732726807; x=1733331607;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJR3B0odsZQHf7sVwTNPbyRTbyljXTxWTLBZbD2FzwQ=;
        b=SXlTuitDRUXYDOMo/lvIfPLNOVOKCeLSkP3Kz/ZAeY6vaUqg+MMZy2UrZY81qkt+S9
         zmP1dgz9naq39N0UcOOZet1MPR4to/h5HMoydH+mH1up6hGscv8MhfEVhzYQkhEkmkje
         ahipoBuX6r4SFHX8RNHROFlQRMUOyh7daFsnSI6A+R8YiZ4xvX3n6PQ78YL8udcCAh0L
         tpcfr8HTFkYydtnugze7fXuXoxKFm/R3WoI0hjiyJznDMWjrCNceulD9/B+k1ThLJGZT
         8jCF1V0IHFsr0FszL+ikNExqSW144f9B0w7oLFEMSpzcH/JCR38FO4OdFjyeLZNeO2pC
         mRbA==
X-Forwarded-Encrypted: i=1; AJvYcCWHRl2naEYQF7WDclTKwcdMnpmwWY9aIa99Y6/R/o24PmMvXm46W6eC6n525k7v323toVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJbgcwGiRIP6v430W7VKi3Z/heg6MMaq2MmzvZ6yKBU1Zm94kY
	fysO9tYN+TtThpyrNfIo7mY6S/HjU+YTCIaxQDuHjcQkwiug0zVe96dXkp67M4XBwZr8tAq+xbs
	OtP2PClDcYqA7EVmqCJ8wJfL7yQb1R1+Ch1+ZlALRfVLTQ3bTpGse6aQW17KwHSSU7M7reKcL87
	NFhknm7ps9itOTJe8oQNKZBo9u
X-Gm-Gg: ASbGnctdw5/mREsWsMLxGo554qbqSHE7cMkE/mtHZkP/+MKDjxl0YRIbsGNrE6iwNFp
	onmh7NmqYhK1BYNKQB8emQtffEJXPIbQU
X-Received: by 2002:a05:600c:4fcc:b0:42c:b67b:816b with SMTP id 5b1f17b1804b1-434afb8dea4mr965095e9.1.1732726806760;
        Wed, 27 Nov 2024 09:00:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGsYftJoVLH6XXc7eLyOZ8Xs3Ne7AzojxCTrGoIVZMgf+087kJMy68qK3SgXjDP+ni5zf++bz5A32H+CqPJmDs=
X-Received: by 2002:a05:600c:4fcc:b0:42c:b67b:816b with SMTP id
 5b1f17b1804b1-434afb8dea4mr963975e9.1.1732726804984; Wed, 27 Nov 2024
 09:00:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy2mLBzE63wpQrOaHtOV0rwqkaxTUMBA9oMZsk68o0EHMg@mail.gmail.com>
 <CABgObfacuB-8KN1+Czt5DaXQbaiw9=jP5zYGatw6CGooLnz9Sg@mail.gmail.com>
 <CAAhSdy1eYZc__ynDrF8sQCk8Rj+CRj+LBBbGnV+Hc4qHfYiEOA@mail.gmail.com>
 <CABgObfbKYc0Dqcq36dHsV=uopV+TAGu9-SuZF+QP=u6x0uMiHg@mail.gmail.com> <CAAhSdy1QCeg82kQsPHJx1+Oc=L7BoOUTpeLUNoeApao8rZDE+Q@mail.gmail.com>
In-Reply-To: <CAAhSdy1QCeg82kQsPHJx1+Oc=L7BoOUTpeLUNoeApao8rZDE+Q@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 27 Nov 2024 17:59:52 +0100
Message-ID: <CABgObfZ1iqNGqb+MW84_tgZEnSoAjMqzXFcoq0s58iTZDPMKgg@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv changes for 6.13, part #2
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Atish Patra <atishp@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>, samuel.holland@sifive.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2024 at 5:51=E2=80=AFPM Anup Patel <anup@brainfault.org> wr=
ote:
> > Ok, will do. But I'd like to understand if KVM patches needed the bare
> > metal support. If not, and the only reason to skip it in 6.12 was the
> > hwcap.h constants, then there was no reason to delay it. Just send the
> > hwcap.h update as a pull request to both me and Palmer, and we'll
> > merge it from the same commit into our trees.
>
> It was skipped in 6.12 due to confusion between myself and Palmer
> about which tree these patches will go through and we did not resolve
> this in time.

I still don't understand if KVM patches need any bare metal code though. :)

It's also unclear to me why "RISC-V: KVM: Allow Smnpm and Ssnpm
extensions for guests" came through the RISC-V tree, thus causing
conflicts in the KVM_RISCV_ISA_EXT_ID enum.  It doesn't seem to need
bare metal support, so it should have come through your tree.

This split between patches that you send to me and those that others
send to someone else is not your fault but it's a mess, and the RISC-V
maintainers should not have gone for the least-work option. If
anything has a bare metal and a KVM part it's totally okay that you
send it to me as a separate pull request, but the right way to do it
is to *include a topic branch from the RISC-V tree* and base the KVM
changes on top. Not to let Linus and myself sort out the conflicts.

Paolo


