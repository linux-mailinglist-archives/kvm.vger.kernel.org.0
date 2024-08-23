Return-Path: <kvm+bounces-24955-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECAC995D92A
	for <lists+kvm@lfdr.de>; Sat, 24 Aug 2024 00:18:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AB6A8284471
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2024 22:18:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F69F1C8700;
	Fri, 23 Aug 2024 22:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="btE2sS+3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F24B192590
	for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 22:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724451517; cv=none; b=OkR3+BMkQm0mg0nT9AEbZHx/NdVqejQKL6qrHW8tHBsFUJjeIqpCXB8qr91qGR4GD0/x2OVvKJzTbc+V3im6W1pl4oxsarvDM6kyZIy0MMUBeoPioDLLapQ6v/I3j4qGuZK313Reh9TLKJ0Nm1ADqnStgEmq2MRL9Fl6dF++9N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724451517; c=relaxed/simple;
	bh=Jar3pLI7sHN6Jz5gn8qNq/l0cqyF22yAnELG1vqgKSM=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=PfounG/uER5UKWGPoaowsD+NCZ8Tn9tKj3iUZ/QUAqrWxYgxiZBiMEqkwKpWYwe+v0duTaL9OVQe5YjIbnLQTvpOMW5v9KyRrJqDIY6MblFzxz7u9OIvF2d7Q6bEz5/DF4PRhSY1jLspu5eAM/IrWMLaurke1OTuyLcjwANtOpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=btE2sS+3; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e13c3dee397so4097223276.3
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2024 15:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724451515; x=1725056315; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5i8K1y6thV1KH6Nu/Fbtqs/L8ScmNJ+aMBmj62kJxJY=;
        b=btE2sS+3fBPmm9D2XgRZl9G65R+JodF+yzXW0YwThQUAiU8aetpHhAlsaUOxhfI1uY
         a7PYs9+BviIn0dcAGpYyhA2OAPipJR1ohklDKuD65rPw+YUuCy5zuVq+Yajg5yFeZtZE
         eIayJdqq/gpFhxIVvz3yDcshaJSfve4jFvG/mkwEXEtehGn/iNuaFAe4wgP/AFrmiNh8
         NtuCKlzqgQG9vQnnXTOaQEUR3SAs9ABtY6S3ZWYtf2YIat6r2cGluyg5HVhPydqcR9Dq
         F6a6uauglK73Xz25nRLkOqODd14p2l6Jp4MpJDf+/nbE8fMk3JrqSwjetn0WExzFcB+P
         YfvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724451515; x=1725056315;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5i8K1y6thV1KH6Nu/Fbtqs/L8ScmNJ+aMBmj62kJxJY=;
        b=es8UVopaBiveWd202um83r8wdW/L3+R3z4MvHapBI8Wrj8pSCexUoLXiprW8MFC23x
         a5Bpwzpy0aZJyzlxsY0RZOVoHl/AUjYO0CjD7bbElajOiAs+JTDty6jpCTVEEkSBIRdm
         onpHkI+67YhCSUxjPRdliBd82XBPs8ua9u4e29g2Shlt9I1lliMYuYSARe1py0wCp0Fh
         bYI4fC9AbTq1RW5uJYdwH02hLZEWmsxIp18G67Tr1NjhuO2Dy08zLQpyTEEzvAiuUZi9
         gmpeb2pgopt7HzgDVzIzGgBdH4bzrwvnmhhHRtLJRaW1b0nv9oIQHPJiJsIpyT3ayQvM
         OFyg==
X-Gm-Message-State: AOJu0Yx7gDkAMEPYhDEv9iJ1XNGdYwnBYiCUPmTp5GnbTVeC8urWP8Ky
	ACBFw86wzuMz/J8e24jT+Rmxn2Xkeqx5HRCq2ikA4iqu23inT8wAcHhIik7mNuPX70qHfaJ2220
	voA==
X-Google-Smtp-Source: AGHT+IEAkGsNzKr1H7iLz5ZJXyYWcvEws1gm9vM0T9EuTsZR65SG+UXTMcD2HdsINzUsCj7u/MjzH8KaSqY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dd05:0:b0:e05:fc91:8935 with SMTP id
 3f1490d57ef6-e17a83ad4edmr164098276.3.1724451514949; Fri, 23 Aug 2024
 15:18:34 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 23 Aug 2024 15:18:32 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.46.0.295.g3b9ea8a38a-goog
Message-ID: <20240823221833.2868-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH] x86: Force host-phys-bits for normal
 maxphyaddr access tests
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Explicitly force host-phys-bits for the access tests that intends to run
with the host's MAXPHYADDR, as QEMU only forces host-phys-bits for "max"
CPUs as of version 6.0 (see commit 5a140b255d ("x86/cpu: Use max host
physical address if -cpu max option is applied")).

Running the access test with an older QEMU, e.g. 5.3, on a CPU with
MAXPHYADDR=52 and allow_smaller_maxphyaddr=N (i.e. with TDP enabled)
fails miserably as the test isn't aware that bit 51 is a legal physical
address bit.

Amusingly, the KVM-Unit-Test appears to pre-date the QEMU change by a few
months, which suggests that the KVM-Unit-Test change was made without
proper testing, and the QEMU change was made to fix the problem.

Fixes: 11cec501 ("x86: cover emulation of reduced MAXPHYADDR")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 7c1691a9..6a60bd11 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -126,12 +126,12 @@ groups = vmexit
 [access]
 file = access_test.flat
 arch = x86_64
-extra_params = -cpu max
+extra_params = -cpu max,host-phys-bits
 
 [access_fep]
 file = access_test.flat
 arch = x86_64
-extra_params = -cpu max -append force_emulation
+extra_params = -cpu max,host-phys-bits -append force_emulation
 groups = nodefault
 timeout = 240
 

base-commit: 6b801c8981f74d75419d77e031dd37f5ad356efe
-- 
2.46.0.295.g3b9ea8a38a-goog


