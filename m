Return-Path: <kvm+bounces-46113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 41FF8AB2439
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 17:10:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E5834C0E72
	for <lists+kvm@lfdr.de>; Sat, 10 May 2025 15:10:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E843922FAF8;
	Sat, 10 May 2025 15:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JDIG4re3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FDD1DD0C7
	for <kvm@vger.kernel.org>; Sat, 10 May 2025 15:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746889810; cv=none; b=fusPYJyXXzoN4LZVkM4DMvyrkeBIF2LF2L3AO5TF/1vds7gc4o6fwg3A9vovCIPUvizItfDec+gbus/KG+jX41yF1qxjO/lP+dyAREQbZ8xgM4H63uoEVPlBGD0y7Mm2/0G9Nh5TUdPX2gkKF2Gd0LlEpbvAu/KoHX0GQWxv7TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746889810; c=relaxed/simple;
	bh=LSp0XQpzSTcNL5A8tzPVsKcCl0AKeTrOu/sN2l5jc/g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RbYVSwBqUWYoRkW16ypkeHlwGTQ5kz/rKI29OEYjyfTN21/tpYSlQ3Soq+bf/vmi1ZuwLIE3C+Qgz8IAjPVQDZ54KCf4nuEQ8IMyacUZoex9lxBaD4jJvFL8qWBebQmYuIxGTPIJ6F8byyWJ7OUC9Z53VR9hkxUDR5qIoFA8Yg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JDIG4re3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746889806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LSp0XQpzSTcNL5A8tzPVsKcCl0AKeTrOu/sN2l5jc/g=;
	b=JDIG4re3jCX3r4WEZyjRr+77HnOnilllL+rKiTizoby3ufG09onAtnTezG9UF6tL8d9ciw
	fD0AMrTtvMMNLobckAX8TT6f11x5tNpPoExrZsK6M5M+Mb3E125o/i71xL4/2CbNYKp6WS
	pDumVCE8X55lNbsn4ASy5QQR9S7I4UM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-407-4meS9jd5PUKHzNbOx4FWrQ-1; Sat, 10 May 2025 11:10:05 -0400
X-MC-Unique: 4meS9jd5PUKHzNbOx4FWrQ-1
X-Mimecast-MFC-AGG-ID: 4meS9jd5PUKHzNbOx4FWrQ_1746889804
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3a0b7cd223fso1594095f8f.2
        for <kvm@vger.kernel.org>; Sat, 10 May 2025 08:10:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746889802; x=1747494602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LSp0XQpzSTcNL5A8tzPVsKcCl0AKeTrOu/sN2l5jc/g=;
        b=b7oX9nKu5IkMg9NzgcthWaux2Q3X6WHlnr6KQNPQsoxgIuZyJH5N387XakktM3DgQz
         FyVqLenmOXNw1xLlcxogZVDg/CTQ0xqUH18XFFzl8JIB1b3awBd5yx59vLkxrHBP9B6G
         NsmV54xyxn/vv7WhnZx2+yoFZs9ii+r/dqZ2V/4sBopsOZ8HoAYPzF0tj21xiocuhGna
         LzdbEwdmnS01ivDfOvJVEEuyhnl5jOewpTzZC5pDPjltyDLJpvGor0H6VLVfJkUjthlc
         YnxG1MwdpmRYQQIPY5aCxgBzkzwyeNjAy7evJTkdjIrYxOiJP6uF9Brjn+diHFCftyX2
         Z6xQ==
X-Forwarded-Encrypted: i=1; AJvYcCU64hxDhVT9kMqNKpGrfkTynoypZNTOcsdhsp8dBfIBMW1SdowH+/GbzDgWebxhmmam0Pw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxKtTAsfe4gdHp64pZtA52oTXIuNMVUOwlVARp7/+3gSdoNQk4X
	Z55GFA3jHp6LOEZGUzW6ag36MVQ6dALJ9HJuXlkKfzQadbZw3J/RCEqdjacOjRIFlGI+lIXmiS0
	FYS1wfRGItHlXFmrAaP+ljuQb/IeRRW8TZaK9MIVGRn3Hlw3L2E649qYFHlDzTEV85+GMnG3xpS
	2ZzOW2s8ya5tFYco3poicXEp6UVxCg1K+vUOk=
X-Gm-Gg: ASbGncvM+O57VKsCcBKyKxoBwCqL8A8J+jOp1Lh9DvJlc8pPEUjuCK/R1ULxm7jViyx
	JWHFxCRekIP9qjv7eggHz3CBWaGpgTIy+yl7GQ0fuXoGOJN3bYGXjpINhbZom31A7Pl3N
X-Received: by 2002:adf:f44c:0:b0:3a1:f701:ea15 with SMTP id ffacd0b85a97d-3a1f701ea9bmr5340947f8f.55.1746889802388;
        Sat, 10 May 2025 08:10:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGTrsQVFY/Fgr8ISgzK47J1kK+Yrt701ZSvnSrnrcZmClYr8VRCd08zVc7FFV0ODaXSCdq0pbsc9V1BsmPfAkY=
X-Received: by 2002:adf:f44c:0:b0:3a1:f701:ea15 with SMTP id
 ffacd0b85a97d-3a1f701ea9bmr5340935f8f.55.1746889801993; Sat, 10 May 2025
 08:10:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy09tkokvdvACCQACLdvppTTQHDOR+O4jtkhVP4PaW_k7w@mail.gmail.com>
In-Reply-To: <CAAhSdy09tkokvdvACCQACLdvppTTQHDOR+O4jtkhVP4PaW_k7w@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 10 May 2025 17:09:50 +0200
X-Gm-Features: AX0GCFtixaY2aut0ABjtOGBW3kol_5pEkPm5-SgtfoURVxZJrIE5ml20E7vbZQM
Message-ID: <CABgObfY+2CpcBNc8ugsrvOKr9dR_P=KBuysgVN_cx3_ekQSR2Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.15 take #1
To: Anup Patel <anup@brainfault.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Palmer Dabbelt <palmer@rivosinc.com>, 
	Atish Patra <atishp@atishpatra.org>, Atish Patra <atishp@rivosinc.com>, 
	Andrew Jones <ajones@ventanamicro.com>, KVM General <kvm@vger.kernel.org>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 2, 2025 at 8:53=E2=80=AFAM Anup Patel <anup@brainfault.org> wro=
te:
>
> Hi Paolo,
>
> We have one fix for the 6.15 kernel which adds missing
> reset of smstateen CSRs.
>
> Please pull.

Done, thanks.

Paolo


