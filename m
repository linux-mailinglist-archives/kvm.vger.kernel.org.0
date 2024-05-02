Return-Path: <kvm+bounces-16459-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0327E8BA436
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 01:52:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 97BCA1F2130E
	for <lists+kvm@lfdr.de>; Thu,  2 May 2024 23:52:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2695F159585;
	Thu,  2 May 2024 23:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ydy90oXN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D0954762
	for <kvm@vger.kernel.org>; Thu,  2 May 2024 23:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714693912; cv=none; b=SCiEN5JBDzgU1oXlZRVMDORwOCsNluy6mx6I0cBy77yojv8eT0KEO0Xe/Ri8sFVmFFV4BLDcr3a52+Y0ZV+gQY/8p5gf2RIEvn5rReVk8vvZyPva0h4c+Fc47Fv0r4B+YOFxUnT9o+VSzJW1T+LTgTxNapdyccGOghyeQMzolq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714693912; c=relaxed/simple;
	bh=IEO43tG+0hk6+5Tc8EnzU/Uo4g/lTxh4G9iLTbD7l6w=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iYIz+shuZvF27UBZzjS4UM4Nm6LlESgVoVSrnyxcGz2f15XQ7C6fZ8F0dbCQiLrL6+g9RIXlSj9fYo8VyavN4QxrRy+SDUw/+41L7x9s5cVOk0rjma367xN7dq/MIokrA1DY9STy8lTvv4eCcf2AJDegtBXBKpOdqwpqiEudxWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ydy90oXN; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5e4df21f22dso1944969a12.0
        for <kvm@vger.kernel.org>; Thu, 02 May 2024 16:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714693910; x=1715298710; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2AWkd9E5LF3IG4K9Jme+4V20v4efQDFl9igGSvO2EwQ=;
        b=ydy90oXNaYxmrcgfF41cGrghq6YHV7pk1mt+1AWoMDK+6OzX2YpBp4U0F/cKnhh19J
         kHhUkPfECXCgB1YGWuwN1/hmYvtCZFb3GqY7yeYZYaHWU/yBpJzzw6MIb/JT4egM7AhE
         oDl2WYbSsH0lIVhuL6gT2MwNTsjBhKUe/GmhzasA0uQE7mKEpA52uNtAKv9aGIW30cEa
         BjNtL/CrTu/l4D60dV+ZhJfHksFoG/8Brj47r+YSA1KuSEkj0SriuZV+TcM6uRkumZ9m
         LI2IY8P7kSpLSRwe3H99owB3LYflMKPoOdnxZbQkB7puhyyvngg5P4PBtDhIaiZbl386
         0eUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714693910; x=1715298710;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2AWkd9E5LF3IG4K9Jme+4V20v4efQDFl9igGSvO2EwQ=;
        b=JIh2VQ4BOYlUeuxq2Jy5Zg/zaojF5KrCyhQmH5C1JpY4MO9v032iwDwrisSggkzh5s
         7m2+kcv3MggHN+ozmJrAfAeJfH5dlVIEBpS4nqKzqQi88zvtLyMdCfcKZddaiO6+uUAc
         Js8w4/mTO9Jp+OpofE5a2cuZkazFQwyrZ7a1ZHXI2fRITTvj800EZ8ZksOIx6DL8/Ece
         Gmfr9o/7KjQCHtB++2+CvUEGVg9CBI5/D15IO1I4rBbgsAiJJZcXc8LRyRDdTEZQAfzF
         DSjbpD5Cfw1+9iGUgpr0wfzqzPR0t0F/ngsUtfV+tGtfLyrNKR4s2Q0Q2bIZUQZ4Vxuy
         kmfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXssHunIrygBC98uODjmpVvGcLtk4kkmCy0CXWCehGdfpFLIOIKGt0Qf+kKHUBZ9UpVzbLx/ahBFQHfJllSITnlm34f
X-Gm-Message-State: AOJu0YwTxgylaodvGkpoR7qZhEen6GE2j40tOhIa3rtl5K1VvlNQIeEc
	+ZrOUWugT/YL+cznoX15dFkMEc6NoYH7ftugTaFycZi5ZizSiJwMxFBp90wHL9MvQH4SiM/UFGh
	eSA==
X-Google-Smtp-Source: AGHT+IEcUXclhva+dFchBJJ3ObrS6+2fTWZx4///LxR/oQ9OV+KW6jlzyVoirRMkYWXqu6P6moflp77TRBs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:5a4:b0:603:34ee:334b with SMTP id
 by36-20020a056a0205a400b0060334ee334bmr20706pgb.1.1714693910205; Thu, 02 May
 2024 16:51:50 -0700 (PDT)
Date: Thu, 2 May 2024 16:51:48 -0700
In-Reply-To: <20240416050338.517-1-ravi.bangoria@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240416050338.517-1-ravi.bangoria@amd.com>
Message-ID: <ZjQnFO9Pf4OLZdLU@google.com>
Subject: Re: [PATCH v2] KVM: SEV-ES: Don't intercept MSR_IA32_DEBUGCTLMSR for
 SEV-ES guests
From: Sean Christopherson <seanjc@google.com>
To: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: pbonzini@redhat.com, thomas.lendacky@amd.com, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, michael.roth@amd.com, nikunj.dadhania@amd.com, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, santosh.shukla@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Apr 16, 2024, Ravi Bangoria wrote:
> Currently, LBR Virtualization is dynamically enabled and disabled for
> a vcpu by intercepting writes to MSR_IA32_DEBUGCTLMSR. This helps by
> avoiding unnecessary save/restore of LBR MSRs when nobody is using it
> in the guest. However, SEV-ES guest mandates LBR Virtualization to be
> _always_ ON[1] and thus this dynamic toggling doesn't work for SEV-ES
> guest, in fact it results into fatal error:
> 
> SEV-ES guest on Zen3, kvm-amd.ko loaded with lbrv=1
> 
>   [guest ~]# wrmsr 0x1d9 0x4
>   KVM: entry failed, hardware error 0xffffffff
>   EAX=00000004 EBX=00000000 ECX=000001d9 EDX=00000000
>   ...
> 
> Fix this by never intercepting MSR_IA32_DEBUGCTLMSR for SEV-ES guests.

Uh, what?  I mean, sure, it works, maybe, I dunno.  But there's a _massive_
disconnect between the first paragraph and this statement.

Oh, good gravy, it "works" because SEV already forces LBR virtualization.

	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;

(a) the changelog needs to call that out.  (b) KVM needs to disallow SEV-ES if
LBR virtualization is disabled by the admin, i.e. if lbrv=false.

Alternatively, I would be a-ok simply deleting lbrv, e.g. to avoid yet more
printks about why SEV-ES couldn't be enabled.

Hmm, I'd probably be more than ok.  Because AMD (thankfully, blessedly) uses CPUID
bits for SVM features, the admin can disable LBRV via clear_cpuid (or whatever it's
called now).  And there are hardly any checks on the feature, so it's not like
having a boolean saves anything.  AMD is clearly committed to making sure LBRV
works, so the odds of KVM really getting much value out of a module param is low.

And then when you delete lbrv, please add a WARN_ON_ONCE() sanity check in
sev_hardware_setup() (if SEV-ES is supported), because like the DECODEASSISTS
and FLUSHBYASID requirements, it's not super obvious that LBRV is a hard
requirement for SEV-ES (that's an understatment; I'm curious how some decided
that LBR virtualization is where the line go drawn for "yeah, _this_ is mandatory").

