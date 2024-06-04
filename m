Return-Path: <kvm+bounces-18829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3092D8FC00A
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:40:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E203E28493D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:40:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0BA814F127;
	Tue,  4 Jun 2024 23:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yuMgg5vQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA40414D708
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717544376; cv=none; b=IxIVgRIcw0EfOJ8M/zBAFkBd+aeRW7F3Hft5WlAG4H2Ux2vuIOjTBhOW0stNCP/MyH1COKzCMJCtXvkHzfJwdu2LCz88V5ai1IMgvL3YJ4Yos33oEP/LsxG+L4R870kN45PehaNhc7PmO3AarLa8t43lY8QeoCDHqr/MGcxufFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717544376; c=relaxed/simple;
	bh=IQEVEtIxbfQM6ENckYvGL40F/W3ZSaC5jAvCGcvKzaE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Content-Type; b=gHfqIcJ6pzjhQesiAQiX/Q1w0liFUjK0kuzsMImRvJOX4ZLXe7g3gxTf3ZAG4Cu8+nSL+kGCBceRrKKzkLzOpK1hI6Zy/MQPGtuR0JBma79Se2t6EBdb8ic+t2+nc0EEu6UmuVwHEyDICwS4wqEszmplbDGYIBc/RLj9edIZFps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yuMgg5vQ; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-702543bf7bbso3946813b3a.2
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717544374; x=1718149174; darn=vger.kernel.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k06g+hYmhmCFGjGVcPlzYbiauQW9CrfWOrVFdOU10GE=;
        b=yuMgg5vQIgW93vh0rvhi8M1tEY4C0RF1ExWYP04UaSYSLFg7wCr58jyy8mUhHRt9Cl
         ek5B2LfjUE4A0EPjs5a6r/PIZgtIGZTAkK9I1TjIVCulZ7Ntvrs+MXdpLJNgpxH8aRxs
         stlFQEISBYJE1waNyXBgptW40t1kLn696217FqQe7wRK9JEA/jesfQGkgNzn9mzwCqff
         5vjjcdszi7JW22DB5TVGcS928m+WdAZVOG+rb517SAg0JuJGywQjGS/aJAZrsK951llu
         x5C4J5E8Vx+aniobWscwL6IvxZZ/eg0Z0Hk5KIxpEuZ22qQSAaUOqzMfpgvn9Fp3zgAp
         8hGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717544374; x=1718149174;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k06g+hYmhmCFGjGVcPlzYbiauQW9CrfWOrVFdOU10GE=;
        b=cYnBZJpFIYA/jYprmXIpEeRnKrvg7V2SzsZyxn8rvAgSUE8vvX8iqI9bRTSCUxN0ty
         ni3ByvDbpOYPXpJqxYH2gnCFbTjhwUqZ7qhVE+Ml10sTPJJVh1SpzRsR1s1pagmA4D7R
         b1n9Mp3/JvVf5XRAVU5RTmixeF1uGRNVJQ/4uqsRYfbRo5eZXoOzsESF/amSnZrewPCY
         7JT3PPAzTDTAOJc8iEB4/fvFVyvP7l3np2A0fUjx3qqaTGLEn718a5li5aVeqf3GEO3v
         e9nRiqZ0l4Uv6Kc1ISCiBPtSTj0FdjfK2LqgkVjeuNklRv0UEWmn7nmAxdf8NaXbm9EU
         kVzA==
X-Forwarded-Encrypted: i=1; AJvYcCUIg2MkpyyaFP9XuHGW5t0TJ4CobApOhrTuVO8KyvfIZBbywJdBM4kcdp3S9D9B82naTsr31AljNL58MPH67rdpSiGG
X-Gm-Message-State: AOJu0Yyn9UGyhBgGiiyxsFOv/zUuvGc8cVbzoZqJcMcYXDZaNQKGyfrM
	82HmejGuuk4vMiRFIo4sKIfvTMNHMib8b/mfj8QiKrSBOQHIXmP1lJElLPjY7IQWOBLoxHPV4jz
	wAA==
X-Google-Smtp-Source: AGHT+IGamQjOb0IZyRGbmB/EhtRFFW5qCMkNgngKqeoU/E0W+g9mnv1fH0Rl3UFyzO9QBNrXqH0BKn3aqqE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:2d1d:b0:6ea:8a0d:185f with SMTP id
 d2e1a72fcca58-703e596fbcdmr20834b3a.2.1717544374129; Tue, 04 Jun 2024
 16:39:34 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:49 -0700
In-Reply-To: <20231113184854.2344416-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231113184854.2344416-1-jmattson@google.com>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754334605.2779503.16864225158478390974.b4-ty@google.com>
Subject: Re: [PATCH] KVM: x86: Remove IA32_PERF_GLOBAL_OVF_CTRL from KVM_GET_MSR_INDEX_LIST
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	"'Paolo Bonzini '" <pbonzini@redhat.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 13 Nov 2023 10:48:54 -0800, Jim Mattson wrote:
> This MSR reads as 0, and any host-initiated writes are ignored, so
> there's no reason to enumerate it in KVM_GET_MSR_INDEX_LIST.

Applied to kvm-x86 pmu, time to find out the hard way if this makes QEMU
unhappy.  Thanks!

[1/1] KVM: x86: Remove IA32_PERF_GLOBAL_OVF_CTRL from KVM_GET_MSR_INDEX_LIST
      https://github.com/kvm-x86/linux/commit/ea19f7d0bf46

--
https://github.com/kvm-x86/linux/tree/next

