Return-Path: <kvm+bounces-34101-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 83C3F9F72CC
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 03:42:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C8A131677AD
	for <lists+kvm@lfdr.de>; Thu, 19 Dec 2024 02:42:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFF278F44;
	Thu, 19 Dec 2024 02:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YWbCxTAY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4F554727
	for <kvm@vger.kernel.org>; Thu, 19 Dec 2024 02:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734576130; cv=none; b=tlm43tKCYWmZ81wOIpIxtajyaaphAKTQbN12wOyaRi7o2pOoauqvtLeTDXn87nAUetItY629Td+2/8cclXWX/Rtq0mRAkqyhIs9TsZyRnSUnZpoKq+OM16Gz3ZXQxYuiR1mEP7MbBBQJkTaWTvK6ssJlxOxuSVaJRNdnn6Dqx7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734576130; c=relaxed/simple;
	bh=+0YB1wnZO+N4Mgt+2ULmShqZq3rw6HcIFLVbUH2eZuw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t8YvYPN9n3fNTUaBfCmrAJcH5EAE2TvQiL2+dgMKnQP+Fv3cR09aWLZJ+BNiM3kWD72wb8GasiPiFCTPDWXQGzR/tobITE78z/ZVBwjuhMQa+xelDx7yeqG50QKrpgMre71eGkFxx/gCg3Sn4ew8iR06qMUN4+bjoY0KKQIBJlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YWbCxTAY; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2efc3292021so437405a91.1
        for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 18:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734576129; x=1735180929; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m0Cubv7YLSSEZBcbcu/q09glZ18XxGHJ6dVd9FcHtzc=;
        b=YWbCxTAYzCw3rL0VtmJprR2WLwkCsLQS/+LIa/g9XDenXlJIn3Za7I/i9r8eWT9PL7
         dUvOWIoAUkZkPEWEDaXPVV9yKlwyD11VB20AnU9Isde704rZgBJVOCYofEeFqkq+gukk
         RVs6Jrbb91XMR0fP1EhxKc9rqV5wJad8daZhhO8BW5tQyqal3LR1H2v2H2DNDyeJmAw+
         XTZZe3LzRwlD1i7Iud9HpTxKn0PS7L/M6fD2boj9w7rGIqzIS9Q/LxkWgmWN1EphAFJZ
         1yNVDu9yInr6z2jpu2NM8gbnX1/MyEW6GupHk1Dikf3kirISp2QYx99Jnom/aScoEGO2
         QtxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734576129; x=1735180929;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m0Cubv7YLSSEZBcbcu/q09glZ18XxGHJ6dVd9FcHtzc=;
        b=b4tBZC8Lb/8K4A7/lI2ioBLxHdBI8d5JgFwuDU8CR7/m6AEU/cBJdurh6Faw5WQSWy
         yE7rLZYtHnnFY2/2zCzdtVpthJTxIGWVnj49Gn0sJw4u4U9PrZOpNKxHHk61MkSQYRlU
         rvJZcMWBEdaLqAeSZX7q8pJ7ZRhoTWxyHtnV3hnEYPzYqyLCtL/yPdfWQeCIMAGZ6x8z
         VPT3e2oEe3KxlqicNJ773MLoPzjUEK+9G6AiYbqkGcQUHhkSBC7pOoM+6PJoZd07Rq6/
         dtOTFAyGW7ozJ+LOgmVl8O3jLIFV+uF4J980/VEw7VCzH2h8Pa9glUpdhvQrmBHc4Fk6
         QnHg==
X-Forwarded-Encrypted: i=1; AJvYcCXDZCLE9myNcfVjDLM+Xxv3sFcpGGVG4wmEGmrh+lv8mXHFYSSYW3uOPDdkt/bdkquTDVk=@vger.kernel.org
X-Gm-Message-State: AOJu0YxAuQocvAUqz9ZdJCDfZG3XGaMZN+Q4h8Mtys/Xd/VMOLzDe06e
	rk1abOG0e19YKSEI1YIDbddw/KaZMkROzok+7gUtxgmtIJHPfnCaj25Khf8bxLfd0w3yoq/pb2t
	S6Q==
X-Google-Smtp-Source: AGHT+IEnYzmbvfGN7/B6ViEtGfWEw0anaTCEutqaOfeDitWi6EveqXP0+98dhgD6pETsbyq/KQ5AnaRCuh4=
X-Received: from pjbso12.prod.google.com ([2002:a17:90b:1f8c:b0:2ef:85ba:108f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d648:b0:2ee:9b2c:3253
 with SMTP id 98e67ed59e1d1-2f443d45292mr2198688a91.30.1734576128828; Wed, 18
 Dec 2024 18:42:08 -0800 (PST)
Date: Wed, 18 Dec 2024 18:40:46 -0800
In-Reply-To: <20241217181458.68690-1-iorlov@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241217181458.68690-1-iorlov@amazon.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <173457555486.3295983.11848882309599168611.b4-ty@google.com>
Subject: Re: [PATCH v3 0/7] Enhance event delivery error handling
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, pbonzini@redhat.com, shuah@kernel.org, tglx@linutronix.de, 
	Ivan Orlov <iorlov@amazon.com>
Cc: hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, dwmw@amazon.co.uk, 
	pdurrant@amazon.co.uk, jalliste@amazon.co.uk
Content-Type: text/plain; charset="utf-8"

On Tue, 17 Dec 2024 18:14:51 +0000, Ivan Orlov wrote:
> Currently, the unhandleable vectoring (e.g. when guest accesses MMIO
> during vectoring) is handled differently on VMX and SVM: on VMX KVM
> returns internal error, when SVM goes into infinite loop trying to
> deliver an event again and again.
> 
> This patch series eliminates this difference by returning a KVM internal
> error when KVM can't emulate during vectoring for both VMX and SVM.
> 
> [...]

Applied to kvm-x86 misc, thanks!  If you get a chance, please double check that
I didn't fat-finger anything.

[1/7] KVM: x86: Add function for vectoring error generation
      https://github.com/kvm-x86/linux/commit/11c98fa07a79
[2/7] KVM: x86: Add emulation status for unhandleable vectoring
      https://github.com/kvm-x86/linux/commit/5c9cfc486636
[3/7] KVM: x86: Unprotect & retry before unhandleable vectoring check
      https://github.com/kvm-x86/linux/commit/704fc6021b9e
[4/7] KVM: VMX: Handle vectoring error in check_emulate_instruction
      https://github.com/kvm-x86/linux/commit/47ef3ef843c0
[5/7] KVM: SVM: Handle vectoring error in check_emulate_instruction
      https://github.com/kvm-x86/linux/commit/7bd7ff99110a
[6/7] selftests: KVM: extract lidt into helper function
      https://github.com/kvm-x86/linux/commit/4e9427aeb957
[7/7] selftests: KVM: Add test case for MMIO during vectoring
      https://github.com/kvm-x86/linux/commit/62e41f6b4f36

--
https://github.com/kvm-x86/linux/tree/next

