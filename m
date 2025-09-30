Return-Path: <kvm+bounces-59156-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20400BAC979
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 13:00:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D684F1C131A
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 11:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A92C248F57;
	Tue, 30 Sep 2025 11:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xKBOP4yR"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A12042FB0B7
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 11:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759230009; cv=none; b=JnLTdj9zgv5eOwf4OGV5TDWksxMmfwxOAI+vJjkpdkujHXWaJPAzgs5KTLwb0aburIAIHe5H3jS27KyaT6O/BW5V17f7g/U6IfTej9+RhY/kcVY0LP/ExJ8NO+c9J2F8ZhF6EnE/Qxp/qn0iUEenOCFjBwoVa8Fsykncxlozfow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759230009; c=relaxed/simple;
	bh=wFnoy4QXjxAmYJyA1+5t7l0ikN0i8PEuNczTcDuAws4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rZei607N8kLC18Fx64grYgPrbuS/tQMvQetYC27SdQ1grMRdgmsejVYlyEnqy09lSVLLfW+ngI4kOtjByZNgY7nKAmgtUl8rIXKfOap/IBPv0rD5xjdI7UIm8dHDSYpfwmhWXSWNNXDZ/VAwGRRFV0tV+zBMHE//wOtFXutDL2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xKBOP4yR; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b4ee87cc81eso5065648a12.1
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 04:00:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759230007; x=1759834807; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BW2Qtj+KVSZo32MbcvWapFjwhM8eljdM2/EMaeJKXfU=;
        b=xKBOP4yRxXeQil4xoiFV+ATZKn67HZHAjxJfuvQGgoRXgpCMdYKCA3S3w43F/bqs31
         NYQcTDCvo43m1wkVYVNiR+VuX+kGghzsyEsFZJyL8jFvektUCnmjYluMrvzL7lEZFZ2C
         uwgtkLshxchhEWbdowqd2bh/lEuxRgumxZZCTQDOg5w8A601g9qQyVLRczBrWRGr8gUt
         Kn9/M+jJ9lkyVhAjmxm6khjaq2EerP4nvaOG/A0j1BpQYkZw1vXmL5+/tBH/+4H7v2ts
         HdLh3I977Ot2w2S3S/DoFgB3Dmacp8unEUH3rE9pZ2i5yUi5bhd6BRQljyQ5WOGTvFYJ
         8WnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759230007; x=1759834807;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BW2Qtj+KVSZo32MbcvWapFjwhM8eljdM2/EMaeJKXfU=;
        b=oWbpb5pqD6MWN5qDU03/bLzbDbPAeqSnkMc+kR7rhIgfWvXGIICVWgpdzz1lunHRQG
         0rK3XtzeW2B5XX1aOaDWZRf9ISzZVASc2Gas6QKNseIs0PsoflTg4VL8lUrwtpVy+3yw
         F7WrgAeorkiKCNOF28MHXEw0ETpinM9uaR5SHZC2BnkB40oRyGGg/OIfL4ZgFmgtpnc0
         owsT+zITAZ+c1bItxkwgiVWoMT2p4ddUlQSD9bcahNgsK1E+Q9omGjDIJ0SoQT5ragSl
         /IaxLmdRbae3TAazfJUrvrd4s6fZJk8d71CLeLYf6vzrm+qKvkRmU2VdXfnQ5GOeaYG8
         2KLA==
X-Gm-Message-State: AOJu0Yxz9Yl7J48jC5Ka3Nfjd88eqtg8VseCyK0hAbuLOyVMrFtGVjk9
	RC+8YeSFIou0pXbxNs2s2ojj4BMT1nznwjGChdZ/OBDzHrgWDBDkNO7GXbuKQEyHeuiPcfz9Hjg
	mRkynkFD3J91/LAdKoFiGhs8VhE1T0QO3hiinQGYBpA==
X-Gm-Gg: ASbGncsaC0kqNap8pycKQ64VtCg0X2uDH6626M+J5R5CQyVW5G0nL1FrCJ+1JaB38mx
	dc2IVYaINmaOHtI3giaEgsX9xzptj4SKw0tA+dHaIoMpHu6lf8yB8Vu/LzfVUAyCVVlhQpg7A1d
	FbRmOJ9CYg2TUb5vn89PG2i+gkl1BGpyvwTCUUGmwXvcrx5qJxWOYtE1WBwz6KG40pn+xk8Cvej
	XK0iC+QTBQNt82TxcbiOEwAiDzgILYr5ioAPtSYdNES7LtZ4n6+4iwT6pSpx+SNiNSJa/p4Wodl
	hIDdb01lX7KBF36BvGKn1+vK9Kipsg==
X-Google-Smtp-Source: AGHT+IHtPuZgSVMGlUzaI5vj/KwcQ6zTwdUWSWUwa6mgNiKsVgXu8raJbRpSbZR/+jnNv3jtSjo9LDhitaHxBXunC00=
X-Received: by 2002:a17:902:e809:b0:24e:3cf2:2453 with SMTP id
 d9443c01a7336-27ed4a89ac5mr212915705ad.61.1759230006932; Tue, 30 Sep 2025
 04:00:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 30 Sep 2025 16:29:54 +0530
X-Gm-Features: AS18NWA_909avJZvTE7jLbzzAOBb2Sb9YrnKfuZvYcjUAeZSImH28wlpR68IqJ4
Message-ID: <CA+G9fYuUcs_-SKWSbiAgyzuhE9-oqSAGDQOU6pTPfwq57+cWSw@mail.gmail.com>
Subject: selftests: kvm: irqfd_test: KVM_IRQFD failed, rc: -1 errno: 11
 (Resource temporarily unavailable)
To: "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, kvmarm@lists.linux.dev, 
	open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org, 
	Linux Regressions <regressions@lists.linux.dev>
Cc: kvm list <kvm@vger.kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

The selftests: kvm: irqfd_test consistently fails across all test platforms
since its introduction in Linux next-20250625. The failure occurs due to
a KVM_IRQFD ioctl returning errno 11 (Resource temporarily unavailable).
This has been observed from day one and is reproducible on all test runs.

Reproducibility: 100% failure on all test platforms since
next-20250625..next-20250929

Test fails on the below list
 * graviton4
 * rk3399-rock-pi-4b

## Initial Observations:
The test is attempting to register an IRQFD but fails with EAGAIN (errno 11).
This likely indicates resource exhaustion or unsupported behavior on
affected ARM-based platforms.

Could you please advise on the way forward for this test?
Should we treat this as an unsupported case on ARM platforms,
or is there a missing implementation/configuration that needs to be addressed?

## Test log
selftests: kvm: irqfd_test
Random seed: 0x6b8b4567
==== Test Assertion Failure ====
  include/kvm_util.h:527: !ret
  pid=721 tid=721 errno=11 - Resource temporarily unavailable
     1 0x000000000040250f: kvm_irqfd at kvm_util.h:527
     2 0x000000000040222f: main at irqfd_test.c:100
     3 0x0000ffffbd43229b: ?? ??:0
     4 0x0000ffffbd43237b: ?? ??:0
addr2line:      5 0x000000000040206f: DWARF error: mangled line number
section (bad file number)
addr2line: DWARF error: mangled line number section (bad file number)
_start at ??:?
  KVM_IRQFD failed, rc: -1 errno: 11 (Resource temporarily unavailable)
not ok 4 selftests: kvm: irqfd_test exit=254

## Links
   * https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250929/testrun/30048394/suite/kselftest-kvm/test/kvm_irqfd_test/log
   * https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20250929/testrun/30048394/suite/kselftest-kvm/test/kvm_irqfd_test/details/

