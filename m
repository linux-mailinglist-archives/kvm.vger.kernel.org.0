Return-Path: <kvm+bounces-55055-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C404B2CFAE
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 01:15:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7038E626EEC
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 23:15:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA1127933E;
	Tue, 19 Aug 2025 23:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hS/8rA0e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D15E24C669
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 23:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755645242; cv=none; b=oxTBf/BDP8zV3IFNWO5HIPocBapMhbqJ94jAH7CwOSulzRFIkAICyEb8b7HkZyw6pairjT+B4UDtIqO6OxY1Xf6FIWP/wf3tzvjOjne9cF3LeLz+dzt4mIKAtE0KBLss8TOO7HwlR+zbvX8GZfDiANlOIrv4MxVPKqUF8h61HfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755645242; c=relaxed/simple;
	bh=BscqRSuqlz6evC0gBvdrI40lPlwU7QYtRZGh/zKJNk4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nqPICBolpKFFBUp5dPRE9tW0N+Q445mjPdZaYZBcvUAomDg8YElUCZ9GtyboWjpCz4vbD2f0O9K5j4Ah6ee6ufTU3QdsOCtokFUsnKWd2L2oqwXyU5hNSWlh1hLBeVf+Bm8CkmHC3jasFg0W/Lj7vIu+WIgMiGlEhOvP5K8XGzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hS/8rA0e; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326bd7502so5214216a91.2
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 16:14:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755645241; x=1756250041; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z68cqsmoG9AHIoM+FC5zPMssxNvG4vU5VkPcD/bxa6Q=;
        b=hS/8rA0eQA5eUMhlNsC//Q8ogWsgU32FGFRp4tA7crXO93ToZbf/Jer7Tlg3RyStlG
         qcmkBzbtKrlpq80ZXXeNY3UXe2ZwjPfLJQm2EWadpt45Ue+td3vwv2ET7rwM8HTx5zdK
         +Xm2UI/pnqg37bbPPKYE7j4vGh+sSaRKpgjE2U0iRtYxiK4dFIHGmgFrpb/QMu8SsPwP
         XW6OuaiKzJBqPnCO4b4DuZF3k4t/jToRZlBE6E3y7jseVTMeixpRuhU3dpHhcxYNN4xU
         5iStPsdvP81wu0MoR0BPEOlGYCXz5VXaHxUgkt6A7E0J0um1bEyU4OrNJ4UbiOPyfuXk
         c/4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755645241; x=1756250041;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z68cqsmoG9AHIoM+FC5zPMssxNvG4vU5VkPcD/bxa6Q=;
        b=RjJ+RUb4EupX2ZNJjfdOiOgFpLv5o8/kzsTG9ppMI6HrJUK6+UAqUu/ZWCXH+1rZS8
         44iJqdMe7ynl24Wb9iOk66y88CWZKv1Cyqo5yJquY3aD6gq0dGlDsTdO2rqSmbHkWfMZ
         4+R8SeVAK11jTBVSfBOVuf0m7/JYejUdb1nRDngNWHUGlmXZ5jXT30ILP5LJv+LIE4dE
         4zeyCuW8GpwbWjwDE32rf29ziwG/E8t/sdMC49Tz8e4p5uE/BQgFs4SQB5oVi8n+gq4V
         CEHxCM8N6j8PJGWxW89BkF7616IC3GVWhnBD782cTUN4m0hDUkm8OgDXH8xk5QqC0IyT
         mxdA==
X-Forwarded-Encrypted: i=1; AJvYcCXOXhi5kGYm2FEv/9yX6CAbV94Q6ezHbmlMHdvv3C/e+8O/3hfKNMIka2vE55lRaKdmrlQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxT7tat15kIAayPR00X658Y972KYYahThLm+6sywKXQo6asBRMy
	SqZBXdVAUOUoM3e/nqykVCzN0K5P33B1GkXMv0gHTIC1OsNlv59fhLGx5CKYWwy74pvZZCRiE7m
	na527CQ==
X-Google-Smtp-Source: AGHT+IEqNJsIq5Liw9qDu5WPmlcYNAlr/ODudB/x5SzADoBq9u4dVRGhcr3oNvyWVNra2lcBkBBfuevz/eA=
X-Received: from pjc14.prod.google.com ([2002:a17:90b:2f4e:b0:31e:d9dc:605f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5748:b0:324:df5d:e694
 with SMTP id 98e67ed59e1d1-324e12e28bamr1044307a91.11.1755645240913; Tue, 19
 Aug 2025 16:14:00 -0700 (PDT)
Date: Tue, 19 Aug 2025 16:11:57 -0700
In-Reply-To: <20250818083034.93935-1-ewanhai-oc@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250818083034.93935-1-ewanhai-oc@zhaoxin.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <175564446520.3064288.7316885414458356151.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86: allow CPUID 0xC000_0000 to proceed on
 Zhaoxin CPUs
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ewanhai@zhaoxin.com, cobechen@zhaoxin.com, leoliu@zhaoxin.com, 
	lyleli@zhaoxin.com
Content-Type: text/plain; charset="utf-8"

On Mon, 18 Aug 2025 04:30:34 -0400, Ewan Hai wrote:
> Bypass the Centaur-only filter for the CPUID signature leaf so that
> processing continues when the CPU vendor is Zhaoxin.

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: allow CPUID 0xC000_0000 to proceed on Zhaoxin CPUs
      https://github.com/kvm-x86/linux/commit/1f0654dc75b8

--
https://github.com/kvm-x86/linux/tree/next

