Return-Path: <kvm+bounces-63604-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C497EC6BDC7
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 23:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 6C6502C156
	for <lists+kvm@lfdr.de>; Tue, 18 Nov 2025 22:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7516C30F7EE;
	Tue, 18 Nov 2025 22:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TuZL1SYq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5A03002B4
	for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 22:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763504819; cv=none; b=Fra2Leh7A5gzpLnE2CavU9ln/HGL92WIhLXf2JDyfbgJKKnBFGy36xZdRL0yjlgzBkhjKxDOM1pn0lpKdZC3hdNdzwK7vAwwmCPVXm+TnoE5OQF/J9wWCGViAoc26Fc4KUenY54BoxvScGNHhDyl3cCACOXm8aBtx0MQkUaqNYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763504819; c=relaxed/simple;
	bh=chP/dYOZoKfyav3LyL3CbOJBvORidSHajmVuXJXSPJk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Zs+OtpxUMDkvPbnfnpffi4Hrwh9SdLoh4CHaHC2I48kWdybF/BREtwztjHkIX+ryVsake0bKJq96V3v4olIGcnv/WEqyWzr5EXCTh/JlPBWa3F5RfM3SDayX6vUSnRKWs/q0jSHkaS+LonnNfK7IDE1cgvTBD3XCVMypMhE+PSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TuZL1SYq; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-340ad9349b3so14976740a91.1
        for <kvm@vger.kernel.org>; Tue, 18 Nov 2025 14:26:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763504817; x=1764109617; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WSSIWdbpAs9WskNCBukfGECovi6f2UD2IRKuvRzzY0c=;
        b=TuZL1SYq8A8MD+XU9t7vQ86qrRNzhL+jML50KZuwzAMJPT3m+a45nOxED0V5K+CiPh
         neELnJniRENlWgJ+Fbtt9EBo/psmKfi4tGNGgbQQyezNRxleD09P2a7m2X2A9olnRXsh
         egJ5ArT+SOgqSA6yO8scvo4BTiIXe/qIz2mepJZOaa9n4HlyxCIHYGtUZ2xrTLD+j9Dx
         BB85ReCTr3gRaVwmYvdcSVt2qOpa7DU+3VUcFhCGJPjQnkzBkKgMBa6ePi0Is564ZkyJ
         8wNY9mX3/Vi4v9R9+mmyF3zJ/0mVR5qlKcxqB0VX5dH9+yCDdHlzBHModLCBL6Iv3qPL
         OVfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763504817; x=1764109617;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WSSIWdbpAs9WskNCBukfGECovi6f2UD2IRKuvRzzY0c=;
        b=OsyUim7mdoWRudh7pUHtmHX+96vm5vGz7kqQv+0930ykmSHNb3QbTAAUp8UFVyk/uN
         d+gn8AFdLbENTBEjniqwWn5M9no1esh/anFvOLWeE2WLgXOHzGgbkMQI+BiQM0dQtCa9
         7b37hoIRDShxRUIs/BQVGyOPuWWvqzC4YwxLS+jQG57Z4b8F3HEsXP0fn1nNz9Mtn8Do
         eZJscevIV17vzfPSpz9DnTnSbsZI4wLBmbH8q5KUf6NEyzZ6SNPENJbbmDU1Fbnk27hx
         x13itShrcWXX1v/Bhh18tYmZXhX67/nw4VcRQOIF8/MNlj2YtIJhhvtua6FAXbBgyxum
         bJtQ==
X-Gm-Message-State: AOJu0Yyf01pnTRsmk+nUoE+yw0hGQoa1yM0I92aAb8D+kDRDZf777igk
	gPh08mpkL6MNh6yLvx/y+RgK84PKid+aAkJ7TRHpFbrOPCoZ7k7FqMwYG0HUrAgr1Un9o80LQvf
	FVLtrpg==
X-Google-Smtp-Source: AGHT+IHwVq+jYyjz9uJphCpFxDNtKWcBgB8JhTRZ+ezmM0UzPtMRM3/r/w4uhVOa/xAbYnwM3xkE+UeRH5Y=
X-Received: from pjbmw9.prod.google.com ([2002:a17:90b:4d09:b0:33b:8aa1:75ed])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4e90:b0:340:a1a8:eb87
 with SMTP id 98e67ed59e1d1-343fa793c83mr21293467a91.35.1763504817394; Tue, 18
 Nov 2025 14:26:57 -0800 (PST)
Date: Tue, 18 Nov 2025 14:26:40 -0800
In-Reply-To: <20251113235416.1709504-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251113235416.1709504-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <176350467494.2266406.4722482173166263009.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86/emulator: Treat DR6_BUS_LOCK as
 writable if CPU has BUS_LOCK_DETECT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="utf-8"

On Thu, 13 Nov 2025 15:54:16 -0800, Sean Christopherson wrote:
> Mark DR6_BUS_LOCK as writable, i.e. not reserved, if the CPU supports
> BUS_LOCK_DETECT to fix a false failure that is largely hidden by
> x86/unittests.cfg running the test with the VMM's default virtual CPU
> model (i.e. because QEMU doesn't enable BUS_LOCK_DETECT by default).

Applied to kvm-x86 next, thanks!

[1/1] x86/emulator: Treat DR6_BUS_LOCK as writable if CPU has BUS_LOCK_DETECT
      https://github.com/kvm-x86/kvm-unit-tests/commit/de952a4bf26c

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

