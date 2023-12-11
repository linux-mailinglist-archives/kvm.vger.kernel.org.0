Return-Path: <kvm+bounces-4082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F32980D31A
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 18:01:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 281541F216A1
	for <lists+kvm@lfdr.de>; Mon, 11 Dec 2023 17:01:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AE384CE15;
	Mon, 11 Dec 2023 17:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V7EHsr2O"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFBEFB4
	for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 09:01:45 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-334af3b3ddfso4478004f8f.3
        for <kvm@vger.kernel.org>; Mon, 11 Dec 2023 09:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702314104; x=1702918904; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lWK2LlwCifXuctnRg+xMKHZBJ8byXCXekix4o2vqaXU=;
        b=V7EHsr2OZB/rcJwuH3Wex5oaGDK8yn4cHIVfcxRVdFUshACBEOUE3P4h/D6Isr5Ms0
         pxMYyg8ekWCE1CuYG9pOq/1HEPxBjNIvhB9g8RRQObsUUwPpluRjNNjaVIa9oe0JVdG5
         QpTJZDtqHiREt4vUKGBbDEVyV8NMVxuv7Zf4oWsDC6o2ZqpeQFj2YDoRpdCCKTZ+fXaJ
         1WCp8bqK3Qnlom+xMBczX5CvQttOFPbqVngLh1RO5AmoXISLA+N567wa6SU0hVVAFpsH
         zYikUqUArEk9ykjhFJjeUuUC+QRVOQ1Ub+oKBw7ngrSHr76WJJWY1iPi1QN+VrVLSn9h
         20Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702314104; x=1702918904;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lWK2LlwCifXuctnRg+xMKHZBJ8byXCXekix4o2vqaXU=;
        b=jVMoxrHVf8nwZpUI5ki+2gKR++AeQsdOvwKCFrYYd1J4yBHXLMovURZJuN6pPlXegQ
         Yj4u7DbSx1+mndvr3Yj1M0UnJhIYOh9f0HxT8Gm7VUTmE4MptS5y/daaePGYf2FLnFrq
         ms46msIb4VRNYnJDAtb4VM8s1Kzhgasp4WO6mK5Ib5GKs1/v9Sq9Wc0IAfKgalCBXi+q
         xDiJj+RoxrDIX9A+zXBtyhPgOj1bdNZ4g1x67Tm0vL3SB4zbFLdbjWUv4Faug6blRMa0
         TfxZAUrrqH2o9oEBMtqMcDqOW/EumKIDSSVunBzO0i3vx2jPGwc9VE3hGlAIXkAYl8Fd
         JWlA==
X-Gm-Message-State: AOJu0YyocnD2HHDHvmNx50W/FMY9RVshwmiMpvWMSXsHDo3EsysjmQkA
	zb9b/+pk/6kyOl2RPgNLyx/MQg==
X-Google-Smtp-Source: AGHT+IGUs8y3ooVZf55L1O6rZwWTQHdSQQCj0YIswKwihTIgwU8egbDgviUbCMkajaobuux0v6j7Mg==
X-Received: by 2002:adf:ef82:0:b0:336:97c:4764 with SMTP id d2-20020adfef82000000b00336097c4764mr2178819wro.57.1702314104397;
        Mon, 11 Dec 2023 09:01:44 -0800 (PST)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id p16-20020a5d48d0000000b0033616ea5a0fsm5974099wrs.45.2023.12.11.09.01.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 09:01:44 -0800 (PST)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id B29E95FBC6;
	Mon, 11 Dec 2023 17:01:43 +0000 (GMT)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Cleber Rosa <crosa@redhat.com>
Cc: qemu-devel@nongnu.org,  Jiaxun Yang <jiaxun.yang@flygoat.com>,  Radoslaw
 Biernacki <rad@semihalf.com>,  Paul Durrant <paul@xen.org>,  Akihiko Odaki
 <akihiko.odaki@daynix.com>,  Leif Lindholm <quic_llindhol@quicinc.com>,
  Peter Maydell <peter.maydell@linaro.org>,  Paolo Bonzini
 <pbonzini@redhat.com>,  kvm@vger.kernel.org,  qemu-arm@nongnu.org,
  Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,  Beraldo Leal
 <bleal@redhat.com>,  Wainer dos Santos Moschetta <wainersm@redhat.com>,
  Sriram Yagnaraman <sriram.yagnaraman@est.tech>,  Marcin Juszkiewicz
 <marcin.juszkiewicz@linaro.org>,  David Woodhouse <dwmw2@infradead.org>,
 Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH 03/10] tests/avocado/intel_iommu.py: increase timeout
In-Reply-To: <20231208190911.102879-4-crosa@redhat.com> (Cleber Rosa's message
	of "Fri, 8 Dec 2023 14:09:04 -0500")
References: <20231208190911.102879-1-crosa@redhat.com>
	<20231208190911.102879-4-crosa@redhat.com>
User-Agent: mu4e 1.11.26; emacs 29.1
Date: Mon, 11 Dec 2023 17:01:43 +0000
Message-ID: <8734w8fzbc.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Cleber Rosa <crosa@redhat.com> writes:

> Based on many runs, the average run time for these 4 tests is around
> 250 seconds, with 320 seconds being the ceiling.  In any way, the
> default 120 seconds timeout is inappropriate in my experience.

I would rather see these tests updated to fix:

 - Don't use such an old Fedora 31 image
 - Avoid updating image packages (when will RH stop serving them?)
 - The "test" is a fairly basic check of dmesg/sysfs output

I think building a buildroot image with the tools pre-installed (with
perhaps more testing) would be a better use of our limited test time.

FWIW the runtime on my machine is:

=E2=9E=9C  env QEMU_TEST_FLAKY_TESTS=3D1 ./pyvenv/bin/avocado run ./tests/a=
vocado/intel_iommu.py
JOB ID     : 5c582ccf274f3aee279c2208f969a7af8ceb9943
JOB LOG    : /home/alex/avocado/job-results/job-2023-12-11T16.53-5c582cc/jo=
b.log
 (1/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu: PASS (44=
.21 s)
 (2/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu_strict: P=
ASS (78.60 s)
 (3/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu_strict_cm=
: PASS (65.57 s)
 (4/4) ./tests/avocado/intel_iommu.py:IntelIOMMU.test_intel_iommu_pt: PASS =
(66.63 s)
RESULTS    : PASS 4 | ERROR 0 | FAIL 0 | SKIP 0 | WARN 0 | INTERRUPT 0 | CA=
NCEL 0
JOB TIME   : 255.43 s

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

