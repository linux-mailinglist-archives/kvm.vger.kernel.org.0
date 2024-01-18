Return-Path: <kvm+bounces-6430-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D5221831E92
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 18:40:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 75A521F224F0
	for <lists+kvm@lfdr.de>; Thu, 18 Jan 2024 17:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 578922D60B;
	Thu, 18 Jan 2024 17:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="olk/jPcO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AA32D04A
	for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 17:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705599640; cv=none; b=UcLfyG1X3GTeEHId7hVaAMGu21Qt+k2mq4cRkIULVgLwN6lpyeelFj2/vBuxL7B9Ma/HFIIsdCqeROsmVxuX0DsoBFFX+tXoHVwray+XHjQBu4mW8TuNGgRK/mZjHbSKnyF4TSHlg5YS0Y8B6beVjZTHkZkFikd3v01v8nvWbhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705599640; c=relaxed/simple;
	bh=ltTdpIF83mD4FLWoP8ES+hjgX7H5akmsbH+KpszV1Tw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gDyJJ88zAMbUq+FPmU0MGRIAxm5pQRCVW9kIJlaBlFpxge9CZeGYqw4FCHXcOKDxJNhlQ3toJvfgteIAHKpWyHJ1sk7WGXN8mWn4Xeo6jQknWQUKF2DV3SwNzEmVbdZUNzIx+BwFrmbQ1Q4CQA0ud8WWGWj1s9Jch1ll/b1zFi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=olk/jPcO; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-5cdfd47de98so7455450a12.1
        for <kvm@vger.kernel.org>; Thu, 18 Jan 2024 09:40:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1705599637; x=1706204437; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5Q3C3WGrieoJdAKFaeIZlXobOygHM9XDpw7BX2KbOhI=;
        b=olk/jPcOL4P18CmMZSUtVuZLS1/hmMykvKVXtE47UIUdOVpEC43luKhwfj9E/nsUGX
         syyfL4xpvdeuuSQTA7VZ6oem8PxUpEMwLzj3+7biCEhfkdZR+XMqFfK6FGoyhhu67y3r
         26q9AfNAgS2BkoqzObqM78oMFvm3n/+OYBcUOXguw5reox20j8ZIM7lgj/82kpoX3raa
         Wm2iIwLJjpNp2XCGM0MpPVO+2v5SeUhohXFKvaHD8noAunKUwzUDKGJBK7u62lwoT6r1
         okP6bJyvaTrIPoJYYoDIwae7f0RatLauOG0sdKEXuIoyguvDMxuEXYeeKIeaTiWNADae
         4YfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705599637; x=1706204437;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5Q3C3WGrieoJdAKFaeIZlXobOygHM9XDpw7BX2KbOhI=;
        b=Oq7zbyXagdmn15gwmxe2LjedebZ+3ICPB8BNfnF2jfRWHrzwkqEmM2wsM7G/KIt2TB
         iEiijvpcwEGTLem0DdiDf06Mj+XK8g2NOeMhU7jGZ4vZAAuD+o5LRlByk8UZ1T9qLwWg
         mWfxnHY1oP5veyNRBAr8HqIkkZ6fRQj3yqupqFL/2S0jJYCnNtVbYNoOS6iFjsWjqE3N
         YJclOYYK+tRsXfP/vljmJXw9Pre1PRs+VA7LB1MJxOB31LGr2uqK4bjN9QywfwuUSutp
         90RFOxnbHGiN6PD/z5wZjmOdhDyIMDgnl1hfrbNWjm9C+rJv+VBmzHTmwtHXt5GIiXp7
         193A==
X-Gm-Message-State: AOJu0YzQXqvLPgLSWWtC/+Z6a5q3HygDbG5aItE55IP9mFmlOkV6zoJH
	qtus7pf4KU/ZylYzK4NMKXCXAkbm687ucGqKoE6dhJLLwOrlO2kz580OWk8JywJC5gstVJwAkPd
	h2g==
X-Google-Smtp-Source: AGHT+IHQno7PAwboCP87bGIkYG2fH+s8EoDNQ4sFTOlwoU3XmXeAa1RkI+vnnDxRDet8Cr9UHVnWumLJcOM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a65:63c3:0:b0:5ce:1891:dfac with SMTP id
 n3-20020a6563c3000000b005ce1891dfacmr6154pgv.4.1705599637554; Thu, 18 Jan
 2024 09:40:37 -0800 (PST)
Date: Thu, 18 Jan 2024 09:40:36 -0800
In-Reply-To: <CAAhSdy0SxZWdCHQVW0Bki+bHpg4qrHWV0aFzJq8V2xYtwsMWhw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240104123727.76987-2-ajones@ventanamicro.com> <CAAhSdy0SxZWdCHQVW0Bki+bHpg4qrHWV0aFzJq8V2xYtwsMWhw@mail.gmail.com>
Message-ID: <ZalilFSHBa_XHolD@google.com>
Subject: Re: [PATCH -fixes v2] RISC-V: KVM: Require HAVE_KVM
From: Sean Christopherson <seanjc@google.com>
To: Anup Patel <anup@brainfault.org>
Cc: Andrew Jones <ajones@ventanamicro.com>, linux-riscv@lists.infradead.org, 
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	kvm-riscv@lists.infradead.org, paul.walmsley@sifive.com, palmer@dabbelt.com, 
	aou@eecs.berkeley.edu, atishp@atishpatra.org, rdunlap@infradead.org, 
	sfr@canb.auug.org.au, alex@ghiti.fr, mpe@ellerman.id.au, npiggin@gmail.com, 
	linuxppc-dev@lists.ozlabs.org, pbonzini@redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 18, 2024, Anup Patel wrote:
> On Thu, Jan 4, 2024 at 6:07=E2=80=AFPM Andrew Jones <ajones@ventanamicro.=
com> wrote:
> >
> > KVM requires EVENTFD, which is selected by HAVE_KVM. Other KVM
> > supporting architectures select HAVE_KVM and then their KVM
> > Kconfigs ensure its there with a depends on HAVE_KVM. Make RISCV
> > consistent with that approach which fixes configs which have KVM
> > but not EVENTFD, as was discovered with a randconfig test.
> >
> > Fixes: 99cdc6c18c2d ("RISC-V: Add initial skeletal KVM support")
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Closes: https://lore.kernel.org/all/44907c6b-c5bd-4e4a-a921-e4d3825539d=
8@infradead.org/
> > Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
>=20
> Queued this patch for Linux-6.8

That should be unnecessary.  Commit caadf876bb74 ("KVM: introduce CONFIG_KV=
M_COMMON"),
which is in Paolo's pull request for 6.8, addresses the EVENTFD issue.  And=
 the
rest of Paolo's series[*], which presumably will get queued for 6.9, elimin=
ates
HAVE_KVM entirely.

[*] https://lore.kernel.org/all/20240108124740.114453-6-pbonzini@redhat.com

