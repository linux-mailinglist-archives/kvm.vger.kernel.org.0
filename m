Return-Path: <kvm+bounces-39128-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1C2CA445F7
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 17:26:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CEAB3A303B
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2025 16:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 036E318DB3F;
	Tue, 25 Feb 2025 16:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k7Pnd9rj"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26DF4315F
	for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 16:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740500527; cv=none; b=DbUGhFqslRYG8qM5M+NdQeDUSsUqRADWSQIr7XeUuUrSJVJHP4LPDTgdfKjBYsMzmbu/ohVGQXcHwtITdqP70ijo6UNwET84ZdPUi+BjlNEDU57ro8lwidrJIYs9Y0lnK+5YwSGo0fu8x+e6zPt/XvjZBkx9zK2hnPntBEhuetI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740500527; c=relaxed/simple;
	bh=jM5sQZeJ8NG2PUq6xbOumgp5f1nJYudVynbtXZmZVOM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cpmWD+r8n4/Ixpw9TdGz+gjn5imG0EwCv6KmvkYB79kMLAWgGDFyCxWiA6ykPoVMnYajH8+xgfr/VZdLbEX8NuaSBqsNguGv6i43xuqPzLaAgSXWVDJU/6j6J0+GFRLVaAqRKFB6qopRMKwwil2Bvg27LEnknRom7Z3Lcy8zjJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k7Pnd9rj; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-220cd43c75aso187149005ad.3
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2025 08:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740500525; x=1741105325; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=srEHHPJ1gbuHEqVaJLaXK3crvBH+hHlIUvswV7lRBmM=;
        b=k7Pnd9rjA+148lq/gxPqt0SFXUlmJr0pUTeg+M2a3IDhHkGtw7cqeSMjRx8BsurWrM
         9xtake6Q9lST2G4axByK2hsPxxi0evpTBCpGkU0WhZmY9NnnJQ3u1c6KS1Gy7ThH2JJ4
         BaS7ZIOtJphchBH/eYt5gsOchwPu6qfI28ZqSY89aGNu0yfk3XYqA2QPTwlBbe6sh4ac
         IUSiDua/S3JM+0A23bXBZBDyAV+2vzSgiofGP7ICh1NHJkAznSUGWY523vXNLedC8it5
         OKZfQp5ItNDcUYJvOS+97m+IeE8Uihx1VqepkonLPDmxmKO5iZcDCHD8DI5bF4tFMaU2
         tZ0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740500525; x=1741105325;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=srEHHPJ1gbuHEqVaJLaXK3crvBH+hHlIUvswV7lRBmM=;
        b=GwchKcFMaM8Qt1SGb8QHJ70FqiQC9oCK/EY5z0uzDfYieFLNVa2lP8NiL4h0/ui4tE
         vzsfKHIb+LQ8FmsvapeU1AS+0ob1LRILzl7bimQrQgFbzok9lv0vVBOz9oMR4bzSGPG8
         fYchPxMl/VihvHPgmotE6eDuhRqzG6/XsVJtV+j/eOKwpM0xDU8+XGWW0LPu7GhHQ3Cp
         IpwNeD19PjBC0Ywu7iJOJ0G8x2wKNUeJbtmJh/UnvrsgqgO/BlwVWZ6FnTfAvXILcVSK
         2fW7sGDPBwHJh9/YljYzDvkoHFRV7mXw0ZkddmdHNLeqra8fG+9B/PSyuT0c8akjyC7f
         PvGA==
X-Gm-Message-State: AOJu0YwIwq7IDWVCJf9mAi8XWq6cBHi6xobIA8zsZFuFia4xtgRr4RGK
	Sj88mOcBHEowQiJGf8sIaU4DsaUL4E6Jkozy3ub1xR/WZ4SmRN2m9XmXbT7zErDS7/Pr4Jn17oH
	78Q==
X-Google-Smtp-Source: AGHT+IH27/HQuhUl4nm8ASPw7CT4Y/JWCbdYuVCqkOCpy822McQQGOmUejPqAig7S/UmITePMhyGuWHT7Sg=
X-Received: from plog7.prod.google.com ([2002:a17:902:8687:b0:216:6463:1a1f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d50c:b0:220:e5be:29c8
 with SMTP id d9443c01a7336-223201f7ecfmr1037415ad.32.1740500525271; Tue, 25
 Feb 2025 08:22:05 -0800 (PST)
Date: Tue, 25 Feb 2025 08:22:03 -0800
In-Reply-To: <20241001050110.3643764-25-xin@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241001050110.3643764-1-xin@zytor.com> <20241001050110.3643764-25-xin@zytor.com>
Message-ID: <Z73uK5IzVoBej3mi@google.com>
Subject: Re: [PATCH v3 24/27] KVM: nVMX: Add a prerequisite to existence of
 VMCS fields
From: Sean Christopherson <seanjc@google.com>
To: "Xin Li (Intel)" <xin@zytor.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, pbonzini@redhat.com, corbet@lwn.net, 
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, luto@kernel.org, 
	peterz@infradead.org, andrew.cooper3@citrix.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 30, 2024, Xin Li (Intel) wrote:
> Add a prerequisite to existence of VMCS fields as some of them exist
> only on processors that support certain CPU features.
> 
> This is required to fix KVM unit test VMX_VMCS_ENUM.MAX_INDEX.

If making the KVM-Unit-Test pass is the driving force for this code, then NAK.
We looked at this in detail a few years back, and came to the conclusion that
trying to precisely track which fields are/aren't supported would likely do more
harm than good.

https://lore.kernel.org/all/1629192673-9911-4-git-send-email-robert.hu@linux.intel.com

