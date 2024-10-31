Return-Path: <kvm+bounces-30237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44F3C9B83D8
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 20:57:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A68128208D
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 19:57:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD611D0157;
	Thu, 31 Oct 2024 19:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FEP9wUf8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D0A1CCB59
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 19:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730404596; cv=none; b=QFMdZSkumXk7ycZ+vlGwkXvev4OSzkKVowwXefhNgTA4tXOd0SptojWK+tA+KmHy4Y4huy4QOy0RKEnnbaGmNU4wQ2v861ijfd07UwfPdqITZLhJr1uorZ95FLCPTd8jmLkIEhG/UFitSKKJpl2TeKLbIakV7JI8+6nfDMBRXVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730404596; c=relaxed/simple;
	bh=scF15DBRDvh6LFM+yJGz6csw0YC4b82QxVRvUgcjjIU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tuBf3kjMfCS/UnSSl8+5rIr1BJ0ZRsXTbQVptaYiCvmpAVrdCrNmvXTVD45fCE6lHkFEjBc7UWUUbj5ct5W30sf5335+0Kn/snjaTHnXnylQlrqyT41MA3cf3Ewmr0VrwEXveoMlR4OSE1zdsho/rL2BllHjikwp1IN8UF3UVqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FEP9wUf8; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-e30cf48435fso2560972276.0
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 12:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730404593; x=1731009393; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=XJBNJUwhGy6IFJuYLeumtEE8caNJWotKSkO0EVZhaWc=;
        b=FEP9wUf8hnslC1NQFqAn9PxqzIrt8XTcRXc1CctzgifHR6xsfZ7Tw6bfHpZtOXZDoK
         mLH3Hoat99LsGt+sLhjvyh4XgfhVffNnfv0HWtqX3L2LcvKuGSl8byIMM1MEt/uQcTAk
         ltjm4/JD0dwDBlm83a3a5FPRDLr3blWvgkdMmtH6c7l5pHmtWz2uxEGFNDJo/fKznQrM
         ZhzQ6NKXCuhgXfu2aVMDgSUXcAh1duO2vC6EdZApAzbPjkhi6EWNGIxZIzMN55Go/g/a
         jHySlMve48YhzpuVG4Yq0vnI5aQELPaDKwkm4CXGhE9fCsHVK9TnYuWtxOCY5CAh1wNW
         Oz1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730404593; x=1731009393;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XJBNJUwhGy6IFJuYLeumtEE8caNJWotKSkO0EVZhaWc=;
        b=cAun1MxG+JUCDwGTmOvWLTT93VEsAYEXKEJOdZDLughjEHv4gBLDn1fn2rQksbVOef
         kGh58Yyu7U/tT88XJJiP4TRNCSY032qLSNJ8c6YxpvV+MlFXmueeUfHoumB84yvE50wI
         TlCgp1l5AQztmmv1gHrCw24Sjn2VocZeTxXdTlZ7XUxiZMX6Wqzu3lEq08X/UTPYIPxY
         dcktTZ0FdALOJpHa12QUNrm7Vchn1kOXZG+5uPPc3PcbZRLiaGloTry8HWJxYoIxkLy8
         fqJPugBI6s436OAoov9wF2oMyt+bsj2UiGmyE/u6MIrLvqpO8IJOHySDQsT3pjCgv/qv
         ec6Q==
X-Forwarded-Encrypted: i=1; AJvYcCV/KkSvLI2jyQf73ZJOLPHcYfg2T7AgwvctSxnPg3VeqXAynPIhM9MHnoXLyC7l23oMG6k=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywoz2g9FSKaL4yE5bM42t6KdZKlrmc6nFFF+qflXQaGq7t9cOXt
	r6MVHruHf1TDpJ2W96JZbHmOd20INvIlcwUEnvR+T+5Iv78XN4oW18f9KvSrMTpe1m2/nm4u7WQ
	SWw==
X-Google-Smtp-Source: AGHT+IF5mY8H8HWNIZUe92ntcTAhodfObTAzfmyjPW6IHcMnBhuTa1ixQoAbbew71W7KOu+g/mzrj4F22KI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a25:b28c:0:b0:e28:e97f:538d with SMTP id
 3f1490d57ef6-e30cf49bcc3mr5142276.6.1730404593224; Thu, 31 Oct 2024 12:56:33
 -0700 (PDT)
Date: Thu, 31 Oct 2024 12:51:52 -0700
In-Reply-To: <20240913054315.130832-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240913054315.130832-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.47.0.163.g1226f6d8fa-goog
Message-ID: <173039503050.1508303.8326452918836844664.b4-ty@google.com>
Subject: Re: [PATCH -next] KVM: selftests: Use ARRAY_SIZE for array length
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Abaci Robot <abaci@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"

On Fri, 13 Sep 2024 13:43:15 +0800, Jiapeng Chong wrote:
> Use of macro ARRAY_SIZE to calculate array size minimizes
> the redundant code and improves code reusability.
> 
> ./tools/testing/selftests/kvm/x86_64/debug_regs.c:169:32-33: WARNING: Use ARRAY_SIZE.

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Use ARRAY_SIZE for array length
      https://github.com/kvm-x86/linux/commit/f8912210eb21

--
https://github.com/kvm-x86/linux/tree/next

