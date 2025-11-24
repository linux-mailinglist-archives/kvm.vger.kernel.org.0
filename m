Return-Path: <kvm+bounces-64439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 65A0AC82B53
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 23:42:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 41F9E4E664A
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 22:41:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7424270EBA;
	Mon, 24 Nov 2025 22:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d6axL12d"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA72D2673BA
	for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 22:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764024094; cv=none; b=ILOyTumuBm6UInqGGqshC7kETcPT2e/Ddp9WqyopbhD7sUt/VnffK+wyDQWjdhrlTq2I6bhX+zci6fZBnW1fWPvB7CDCEXZxXsX4HiosY9Qoo0kWcSIPJnlsC1zf4jh/TYwQ8wrMhrR3NsxVKelRByQOOwOJBL07XyjTQqEcGBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764024094; c=relaxed/simple;
	bh=uf5lyw4AUyS8ftD2FcoTbB+BC47e8kfLHSii3wS8DGA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WqonYn1GIV0ELJCy9aOz3+CdFkVY8YLC0V65iDA5vh1AnSJPOu/W8Bdc8VrHHGjMn7YWDIvHRHQlSegoIWbRLjF8Rujs0ZiPEOgcM02I9Dx8q+IohLTSqmMJuMfpWwzjSdqpbvQZ73WUAB0KTC+UqwAzfscSpeIX4rCh4O89AbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d6axL12d; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4ed67a143c5so120681cf.0
        for <kvm@vger.kernel.org>; Mon, 24 Nov 2025 14:41:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764024090; x=1764628890; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uf5lyw4AUyS8ftD2FcoTbB+BC47e8kfLHSii3wS8DGA=;
        b=d6axL12d7XOKHDBrnexbos1blv1Qr5khpwi2Ng/B4HW0q0ngd2PQKb8o+eOEtXSVkF
         At6C9MO6PTzHvgzIcP6zJebvLWS30u14KR2YDRbGndeTzQ5EvsUfAqnZQInzD81TDbGx
         dlGk+0b7m1CDC9fI+hsP9Zo/hJE0eXEasvRSJHSXUZ/qdzjGCl48xiiOgyci7tiKxCIx
         UMnktIidHemXk7hoH6GsDZDwPS09oV86XZ8ilRN54XCQb11DTC/qK8/g8m88hiDaoKTd
         B+0rCHbSEMgMyP3dO9GIzuyGGzJ0/kCslbxf4JAXc6sHW6uOolWvnaxv+64TX+XClsd4
         z+9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764024090; x=1764628890;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uf5lyw4AUyS8ftD2FcoTbB+BC47e8kfLHSii3wS8DGA=;
        b=RkV13t55Zc63E7DrQb63oOuVvQ/hBdlAwDivGBGHE6YQpPrsra9XoMhP7jKWtbFOFG
         4i2ymctJa9VY0odVK5/+ojo1j9YM2KbW2JanDHdCyBqlo5VKAgV+V4Fj0ygFjKk2f75S
         yJiixQWp37VeztJ24DJQ4eoHho6ad1oRghk5MjcwlFqbMd/bQhCcCr74uuHnkCLpU9JB
         8uflw/NS3oWOKg90eNdtrD67/ymyL5mxaK+ORmSbDAfmxfCsAogjcbbIxnpOpoS20YiZ
         KdwbuI7QC57czCyQdDT8lGM9iSPUSvgRmDWdTgJ59+c+Jk4jMRcFntCjkJMGBxdi0fSL
         YiHw==
X-Forwarded-Encrypted: i=1; AJvYcCUXSf6xGrreHln/97yJ59Pe7hp7pGhCykTz1KWvuwgMZdWqsGPEeHm3MDEa70CvyKXrxk8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUP0aSlV7gIJlWEu0FWtKCyfCE/wK++4oFzDU04TcKFpWI7++o
	M1niTBLT/bXU6j3UiFnlUWb1PHltkYX5GrOmICuFLH4678NZ7j8tGXHVyDdzLLWi0gxE9la7Mnl
	j70yLxEIJV6KjcA/mNXH4Iw/VDVmsiPkWb8sX3i5f
X-Gm-Gg: ASbGncuP/BrciH1iXSXQce61+M84PjK9bxVqEvqHH0M4vsijx1fUrFDVwfnHcuf7swz
	Bsoeo/5BfzXkCqN0eIHXg6MNouxOs70vs8J6QD7g9b+ZnH6mPiw8D6l4sfl0pawGy8sqHYSs0p8
	dculd//J7SG6nsxPg8b43t3ntwbC69UxHeSX7trTl7jPH2+Ne3wDa9UPKf7KBkk1eGFuY4sRfUi
	ep5RNVYreHK79Kn7QBE1wTbxKRZzhP/Y5qAxh3ooVr+UJdBf9ISTalUkCYqTP2e5Low2P6R
X-Google-Smtp-Source: AGHT+IFOQkAxR4ULJFB4RScZMAEAUkNKfmbfyajpBFtB8b5ePnIrEnIzK+kruSK7VAVgeojPUj2lG/e5h+FFPP490nY=
X-Received: by 2002:a05:622a:11cc:b0:4e8:85ac:f7a7 with SMTP id
 d75a77b69052e-4efbe8f05d2mr254121cf.9.1764024089358; Mon, 24 Nov 2025
 14:41:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240423174114.526704-1-jacob.jun.pan@linux.intel.com>
 <20251124104836.3685533-1-lrizzo@google.com> <87a50bi7e0.ffs@tglx>
In-Reply-To: <87a50bi7e0.ffs@tglx>
From: Luigi Rizzo <lrizzo@google.com>
Date: Mon, 24 Nov 2025 23:40:51 +0100
X-Gm-Features: AWmQ_bm3FHGHdRVq_GUSGfDS_8Fd7xuBa7l-CHqDp7boVmlt7n6cClYUopURHS0
Message-ID: <CAMOZA0+Bo--AeyrkMHJv384kdANLbWKc6ieubkiwyQD-r44CtA@mail.gmail.com>
Subject: Re: [PATCH v3 00/12] Coalesced Interrupt Delivery with posted MSI
To: Thomas Gleixner <tglx@linutronix.de>
Cc: jacob.jun.pan@linux.intel.com, rizzo.unipi@gmail.com, seanjc@google.com, 
	a.manzanares@samsung.com, acme@kernel.org, axboe@kernel.dk, 
	baolu.lu@linux.intel.com, bp@alien8.de, dan.j.williams@intel.com, 
	dave.hansen@intel.com, guang.zeng@intel.com, helgaas@kernel.org, 
	hpa@zytor.com, iommu@lists.linux.dev, jim.harris@samsung.com, joro@8bytes.org, 
	kevin.tian@intel.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	maz@kernel.org, mingo@redhat.com, oliver.sang@intel.com, 
	paul.e.luse@intel.com, peterz@infradead.org, robert.hoo.linux@gmail.com, 
	robin.murphy@arm.com, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 7:59=E2=80=AFPM Thomas Gleixner <tglx@linutronix.de=
> wrote:
>
> On Mon, Nov 24 2025 at 10:48, Luigi Rizzo wrote:
> > I think there is an inherent race condition when intremap=3Dposted_msi
> > and the IRQ subsystem resends pending interrupts via __apic_send_IPI().
> > ...
...
> It sends an IPI to the actual vector, which invokes the handler
> directly. That works only once because the remap interrupt chip does not
> issue an EOI, so the vector becomes stale.... Clearly nobody ever tested
> that code.

Thanks for clarifying that the problem is the missing EOI.

> ...
> So instead of playing games with the PIR, this can be actually solved
> for both cases. See below.

Thanks, I verified that your patch fixes the problem (and also works
with software moderation)

Tested-by: Luigi Rizzo <lrizzo@google.com>

cheers
luigi

