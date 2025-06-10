Return-Path: <kvm+bounces-48862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 97FEEAD4313
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 21:44:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6020A166746
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 19:44:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DEBE264A60;
	Tue, 10 Jun 2025 19:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GpsKr7dz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231BB264634
	for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 19:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749584636; cv=none; b=tP8WNTHHdtihDIyLLBT8LBdmjgSO2deVxY15DlXQvRw4w95k7whMX59OYUM0Ve+h5cn0SMo4h6uQiR61hOJQ50W/q3AJcM8eY1HjnqMRwvk73k55HNuE37K3Nkat/XFKAVroZefBcFkxeASNq7nOpu+Wcye6hkCWZl+9DRa4Xm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749584636; c=relaxed/simple;
	bh=d/S4l8NRFZubHK2bbwldReNQ+x8O0dhV5XxQH52TLUc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=qqGfzuTxeAF9vEcogMosYF9UPlsT/GFG565FH9/CVc2Iiq2vuicafXb+svP/6QqRxf9zzjYPxEV1xrbqtZtYd1pQOeE+AhksYR9tpDaMRw924IGxMS2awEcMSmr20KlUhtzZf8L6pV2AHq3hIv+Xem84Le/TfuTFQSMHdcwc3ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GpsKr7dz; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3138e65efe2so2173428a91.1
        for <kvm@vger.kernel.org>; Tue, 10 Jun 2025 12:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749584631; x=1750189431; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VkxUQPnC0c4yKyg5H9reMot7NU3ERAJJu2HK3pajbe4=;
        b=GpsKr7dzR/yNuJjcdTFggDQshY9tiVuGBIoJCAZXzFjbn1WYbWKbmEROtxQADsTqNC
         nsFPPDSMRvmSPzcmYZucrBFMiDnvK0/t4xqIHIAUpMTiQQayncJhJ6bKdlyfvS2xtmg8
         It/IuN5HEWD/rnq1hv9Hn/KNjL0BmCottt4uyR0ay4P1/kqz89eGVGLZi98HAL8lmxI6
         pa/8XwPN0uCQmpttveiBMXZh41U2X7zpPW6+urt8k1b8fQuV7PwsZiUrWPasYvstPgT1
         IJGEu6qh7yR65OVr4HnA+jnonXx30zTY7UhlHG6eOeKn3IREKrAWKIaw2OGCwEknXatz
         MUpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749584631; x=1750189431;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VkxUQPnC0c4yKyg5H9reMot7NU3ERAJJu2HK3pajbe4=;
        b=wxJ8Hp/2A90ud8XlCxRm4ffw2vtuXXZvCmfWz8rdi3OahFhM/vBK4WvVdyfciW8D2z
         6FCc52yPanHnPAYQzQsnNVPjUKMT80Q/NFKti2q7lL32Ul2U0EiCWSX6ZSej42tkKc6K
         IITan0G++VDA7WcceuWqep8OLd8/GJVPkDdcUdw6/2dpiGq4S1uFGEVWReihy07WAF6n
         o2YwZiu9N3XT49j3Y+2d4afxRV85MC8mARKBlEhsGLe8Zax0dlJRKh/jYIAsIKZADQrl
         al/L15jsx7rh9aYm9iHPmJUBo5UaTgl6KHWOdBkXohVQc5YtmdPIvolEpXKhendmmbJI
         V/ew==
X-Gm-Message-State: AOJu0YxCMOCYrkRxtqK3Gww2m4C0p3qR8/yQh2VolozUb1Mr8hGc7wPE
	dfDmisQy7WTrc/1PwIyILYgEKh31HKMPSsyhue5SVVEd92QYMT8PpqBLkFAIaCDv/faggwi46W7
	/wTljcw==
X-Google-Smtp-Source: AGHT+IHX96onRl/rR1h3lfOZjSeyYXfiz8fA6oeKfsNSXo+9XBdY9RfJf9xN2ri76Qq6ztkfp8YtxvPOECY=
X-Received: from pjm3.prod.google.com ([2002:a17:90b:2fc3:b0:313:2213:1f54])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:524c:b0:313:271a:af56
 with SMTP id 98e67ed59e1d1-313af21a1cbmr1029433a91.30.1749584631416; Tue, 10
 Jun 2025 12:43:51 -0700 (PDT)
Date: Tue, 10 Jun 2025 12:42:32 -0700
In-Reply-To: <20250304211348.126107-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250304211348.126107-1-seanjc@google.com>
X-Mailer: git-send-email 2.50.0.rc0.642.g800a2b2222-goog
Message-ID: <174958161682.102634.16332760679178907715.b4-ty@google.com>
Subject: Re: [kvm-unit-tests PATCH] x86: ioapic: Expand routing
 reconfiguration => EOI interception testcase
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 04 Mar 2025 13:13:48 -0800, Sean Christopherson wrote:
> Expand the testcase that verifies KVM intercepts EOI for in-flight level-
> triggered interrupts across routing changes to test multiple interrupts,
> e.g. to ensure KVM isn't processing only the highest priority interrupt,
> and to test both in-service (ISR) and pending interrupts (IRR).

Applied to kvm-x86 next, thanks!

[1/1] x86: ioapic: Expand routing reconfiguration => EOI interception testcase
      https://github.com/kvm-x86/kvm-unit-tests/commit/3149cc1274b8

--
https://github.com/kvm-x86/kvm-unit-tests/tree/next

