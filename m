Return-Path: <kvm+bounces-14993-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3EF48A88D9
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 18:28:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E71DA1C22588
	for <lists+kvm@lfdr.de>; Wed, 17 Apr 2024 16:28:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7B001494A1;
	Wed, 17 Apr 2024 16:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qsDQIDHE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F0414884C
	for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713371323; cv=none; b=TZloCsPnTmGlGiEX1jCZGKTEJ8QvBlngY8GnxDmIlAN1GAjiS/y2rDQ7vZOsuLMJx5aJvdv+G3P/tgiVpIOokrrSRvujVKUYbg0JgXvsCAnZlvMkq8Fwb2VXZf1zhZADP1dz3e9ZknJoGvlavtXlejsuAt2v3b82Qh0ShCVne20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713371323; c=relaxed/simple;
	bh=X/2wyR5QFnKJv9CHWGLy/KeIik7k8S1sCmLQsbcRwn0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XMr2PBdHb3oToRO1XCWKMrjNN5GfFM2p8c210EMogR607kfJdtNAzQya20Le1Sj2kdw7sqm5D4qMSGOISYtXEv/DnBanCGS5o/u1WZmwtO7ksu0hj1Uw2c51J/oKgjL93oncTNA6tKq9BHQHgdTFfuMa5GeXIpQLSkcpK8AapWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qsDQIDHE; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dced704f17cso9847171276.1
        for <kvm@vger.kernel.org>; Wed, 17 Apr 2024 09:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713371320; x=1713976120; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s3lSOPR1lJsJJv/WhiimhduGO7QJh32oOx8WBkgJ9ow=;
        b=qsDQIDHE+fdDEzpFvD+G9S/DgtZ/Xx0BE12q62Y8IIh9DJ5SGs9TV446UvEUigUJl6
         MLi4ebF5UXUpF/RkBmOe3KijaJ1sz7Gs9V1GJ8mUlqSgldlte3PliQwfiqDEy9yqRlY5
         0iXXhgmuRR50YSGD8sdxyiQhFKXog9qiK0OkUCK8CKc4KsWVkJZ7IYoe4Z9fyf+iGYL+
         keVH5YQ+vwsExrY/dyHEAFMiDJ2uROvTaVdSGEBCd5oqLbMzk3zKC8jnut2sGqcZB1Iu
         HtDizPw5Kg7XeFZyFvtyKNCww5PKG9UAV3+lJj8OBcLdrx6V/gQaGiSalaDutkhYcU8O
         NIWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713371320; x=1713976120;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=s3lSOPR1lJsJJv/WhiimhduGO7QJh32oOx8WBkgJ9ow=;
        b=Yw8/163VlD34kKpk8q6ly6gejF2cEdJOK7ABSe8y6IFE9YYIihhdT5Ym5jd76CNPaL
         2ov7Mlwjh7zpUcdQC8ihil+ydYz3Vknc5j9PZJj7V8QCnfbFE8GuX0WmKa9oOLPOGRG3
         QORq+iG+iQoQXhgM3DFzJLCf/rHdMfxTIuCNiMfDKLuFy1kA949dIame7vMDwdFYrHXr
         oy1G4Yc9i65mB95i7W1l3uLmpCpHalhsvnM/gELEfCJm6wWv6smP+8xCff1Zqqayjydu
         B9QahC7ozCnj0quyjijNh7PAHyLaP08RPeLj9swSxKNQdteaf2Mc4yJZjubib8XnXFq3
         7Upw==
X-Forwarded-Encrypted: i=1; AJvYcCUfGhgMSTW3eeh4o4AESqNPVAMnVNfDU0E2rDHNlgNoj7KSCL4DHo49NpVFqVZ+t9w5feqGVsaHnzK5IOj0dFtult7h
X-Gm-Message-State: AOJu0YyNDD9ucxq4XOaFcVjgJo8VjvLOUpiCyPbHNlbSw1JckV15/BGk
	IeD4jzbFyUc769hmOJ6GbS28mbpe9mGORBYo4ulIsmyD6XHCthHgKa7P72W3hGcRCM676RXzr+n
	K4w==
X-Google-Smtp-Source: AGHT+IFEPyww4qTNqCfQgyiXR0C7OpclMKKGFrgTa/+wBHlpnkWfaJEwKO+yVT5t5Zack6qO6n1xwvGwFcw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:9cf:0:b0:dc7:4af0:8c6c with SMTP id
 y15-20020a5b09cf000000b00dc74af08c6cmr1692451ybq.6.1713371319876; Wed, 17 Apr
 2024 09:28:39 -0700 (PDT)
Date: Wed, 17 Apr 2024 09:28:38 -0700
In-Reply-To: <Zh_0sJPPoHKce5Ky@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
 <Zh6MmgOqvFPuWzD9@google.com> <ecb314c53c76bc6d2233a8b4d783a15297198ef8.camel@cyberus-technology.de>
 <Zh6WlOB8CS-By3DQ@google.com> <c2ca06e2d8d7ef66800f012953b8ea4be0147c92.camel@cyberus-technology.de>
 <Zh6-e9hy7U6DD2QM@google.com> <adb07a02b3923eeb49f425d38509b340f4837e17.camel@cyberus-technology.de>
 <Zh_0sJPPoHKce5Ky@google.com>
Message-ID: <Zh_4tsd5rAo4G1Lv@google.com>
Subject: Re: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4
 during a signal
From: Sean Christopherson <seanjc@google.com>
To: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Cc: "pbonzini@redhat.com" <pbonzini@redhat.com>, "x86@kernel.org" <x86@kernel.org>, 
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, 
	Julian Stecklina <julian.stecklina@cyberus-technology.de>, 
	"tglx@linutronix.de" <tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"mingo@redhat.com" <mingo@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 17, 2024, Sean Christopherson wrote:
> On Wed, Apr 17, 2024, Thomas Prescher wrote:
> > On Tue, 2024-04-16 at 11:07 -0700, Sean Christopherson wrote:
> > > Hur dur, I forgot that KVM provides a "guest_mode" stat.=C2=A0 Usersp=
ace can do
> > > KVM_GET_STATS_FD on the vCPU FD to get a file handle to the binary st=
ats,
> > > and then you wouldn't need to call back into KVM just to query guest_=
mode.
> > >=20
> > > Ah, and I also forgot that we have kvm_run.flags, so adding
> > > KVM_RUN_X86_GUEST_MODE would also be trivial (I almost suggested it
> > > earlier, but didn't want to add a new field to kvm_run without a very=
 good
> > > reason).
> >=20
> > Thanks for the pointers. This is really helpful.
> >=20
> > I tried the "guest_mode" stat as you suggested and it solves the
> > immediate issue we have with VirtualBox/KVM.
>=20
> Note,=20

Gah, got distracted.  I was going to say that we should add KVM_RUN_X86_GUE=
ST_MODE,
because stats aren't guaranteed ABI[*], i.e. relying on guest_mode could pr=
ove
problematic in the long run (though that's unlikely).

[*] https://lore.kernel.org/all/CABgObfZ4kqaXLaOAOj4aGB5GAe9GxOmJmOP+7kdke6=
OqA35HzA@mail.gmail.com

