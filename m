Return-Path: <kvm+bounces-20299-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB897912BFA
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 18:58:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3D245B287BD
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 16:58:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B4F61662F0;
	Fri, 21 Jun 2024 16:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dnllD9RS"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D52915FA94
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 16:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718989076; cv=none; b=Cj6qupPBePXhgys9dBTn3UTSMY5R5/cOx0zOPzmLUev9GOwGoK7IxMi5OTTjUBm8Nj4DKG4e4kqi7hkL8bFaR9yqHpmHjailcK8HlQhH8VHX6yfZCp5zBqcKYaW3kRnnBbCSuYNktp65I6hq2TaSii508oPT2X05DQT/7HaMh8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718989076; c=relaxed/simple;
	bh=79G3j1alGKu1Ed2Tiohf1Y+b4uxS4/8Rze/yiGQx1k4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fakql+VFAvT/yNOlVytgvG00+/HK7RH6CpVqeCzznpBpEAusebr4DHhYnryeJ1mxLJQlKV5q93hvbIt5SiOlPy1aryOna4+mYMpyUsiQ3vDcBO1/bxqfFnCiGXazqhHG8jo9ewk5JBbks+gRI6F45Ck7xOOv9r+VrkbwpNIVoa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dnllD9RS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718989073;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=79G3j1alGKu1Ed2Tiohf1Y+b4uxS4/8Rze/yiGQx1k4=;
	b=dnllD9RSzz5Rp09lDsS+t0EodV0LCiRhXW6M1Mq0Hd7j0P93koVeC3aO5PwRpexNPT0vWc
	VMBTQKeZ8VUXsx/Tdy4yvaKSZM/2tBeIrcKBvMZzslHLeAEKvDBiG0SiSKox42gN9tyTfc
	3C73qOQC/99tqxVYsXLUJP6drZx7Egs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-G8vmtaZpOFaes81tvt_9Rw-1; Fri, 21 Jun 2024 12:57:52 -0400
X-MC-Unique: G8vmtaZpOFaes81tvt_9Rw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3643d0e3831so1413727f8f.0
        for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 09:57:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718989071; x=1719593871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=79G3j1alGKu1Ed2Tiohf1Y+b4uxS4/8Rze/yiGQx1k4=;
        b=nAgTUJsQDmi3MEcQYL1KwSWlxweela6KpcqtpAdiTyYMlUtdWq9fwwMiTEdXq1wMMs
         9FZ0ThtsnpFTedewHy1srIC85x0UkIWQbW4vJcZAxcLu+6AtCauYCtrx1sNkJSUHpHoZ
         eNcPQYWbaHbw01l18+gRgWHQ33qvwmxnpvfk1UKQpY56dQVq4+44z6B+JiU4RwVBaYRH
         3848J7yHfLamNGcAiyrELbVjPUSWqs3lmFNQ7L2juP4lYAFiAmDNPJkhivoa4XzdxH4E
         DKyzltLQgCrmR7hE3t7QHTCuT8qE5B3P8np8y/inbwFCsFlGoP2TPswb7q/Trbema1xe
         zL7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUuD8YnqJMtS2O0qaQ5l3uen1RXFr2SNDG9cq2mit12a1FlSErCp6iQC12EsJTHMTJaxBFOrlmf7/ThDgiFAlpdNI7e
X-Gm-Message-State: AOJu0YyDRlWm3RlAoI6eVe19d66kUQ0FSEqCCHc7K9NC5wjGtJacKwNE
	TNOBw5bRK6dbMGySm13vxN7c4Eku+BQbnhdlcYKMpMG7D+BP5trQNg+D8CqhEaX6TiOqFPyEWkV
	rpZePbEFqQWF56TqY7/9lsYbp79LX+NFOTV72y17jsNZpK64zoz57qzzbaAR0BiZbNOtphzafGE
	xzS/yXbWpIEu3OClQIOJe8CLIF
X-Received: by 2002:a5d:6783:0:b0:360:791c:aff2 with SMTP id ffacd0b85a97d-363195b234amr6006932f8f.47.1718989071281;
        Fri, 21 Jun 2024 09:57:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHkHbLlH0w9F69hASfuJKg+82uIi72lfMrpHnmS4F+cyOECiBz7FgjhlTMoe1Vs6ubjQ73Zp7rx7uw1c2rlp1s=
X-Received: by 2002:a5d:6783:0:b0:360:791c:aff2 with SMTP id
 ffacd0b85a97d-363195b234amr6006918f8f.47.1718989070973; Fri, 21 Jun 2024
 09:57:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAhSdy0wc=e5LW92Y7YdK6Bi0cxk6C1EhSyv5vMo1FxKMu_CpA@mail.gmail.com>
 <CAK9=C2U6Mctz6fMOVQroDUHeCJf6HPGrKkK35BPeTkPAx2WMfA@mail.gmail.com>
In-Reply-To: <CAK9=C2U6Mctz6fMOVQroDUHeCJf6HPGrKkK35BPeTkPAx2WMfA@mail.gmail.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 21 Jun 2024 18:57:39 +0200
Message-ID: <CABgObfa41Ui5qxUGR-Jw+UueuM9U12bEEBwG7wEPSDjQ4gaArA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/riscv fixes for 6.10 take #2
To: Anup Patel <apatel@ventanamicro.com>
Cc: Anup Patel <anup@brainfault.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Palmer Dabbelt <palmer@rivosinc.com>, Atish Patra <atishp@atishpatra.org>, 
	Atish Patra <atishp@rivosinc.com>, Andrew Jones <ajones@ventanamicro.com>, 
	"open list:KERNEL VIRTUAL MACHINE FOR RISC-V (KVM/riscv)" <kvm-riscv@lists.infradead.org>, KVM General <kvm@vger.kernel.org>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2024 at 5:49=E2=80=AFPM Anup Patel <apatel@ventanamicro.com=
> wrote:
> > We have one additional fix for 6.10 to take care of
> > the compilation issue in KVM selftests.
>
> Friendly ping ?

Getting there. :) Pulled now, thanks.

Paolo


