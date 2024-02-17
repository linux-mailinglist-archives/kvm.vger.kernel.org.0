Return-Path: <kvm+bounces-8927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75784858C34
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:01:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 99B041C2163D
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:01:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E29A20328;
	Sat, 17 Feb 2024 00:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="doaN3ZFq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B431E889
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 00:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131518; cv=none; b=uYbKwDdDRYWPoppZbJBhlCRcYpTJc+xBrGaGd9s8Jz1FfZkSFtKfKq43daP9IHoVBJb24vog8KtBLSSDiFUkhqK1tfOQlA71LLP6/mCeOSOK7Yu1igeUDOmlEuEEbFP+Hl71zEPfk8ULA4mZKO5aGyXFXhodyI31RSeZsFK9Gd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131518; c=relaxed/simple;
	bh=ZkEzmULeXONmJmTlSVdM43i0xvCHwPJmXvRYjE51UxE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HtWuaMJagh3cXlnB2vOJ2VVedcIgfDG8VEgPROSh5eCTIiL3qIjS2+rmcr60/xoKz8zndSzvY3h5QOsxWswTTmgw3Da4Njt325SBSy5pjBTz7UC/1DXcmYwIWYkCTXJdI8233D/aV7iJTQkzPEvhoTm66zEPMoE2jcM/nv6rx7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=doaN3ZFq; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7c7229e85b5so35603739f.0
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 16:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708131514; x=1708736314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zM1FhW7Qr3v0FtC5FiOLqFulLhlj/jL3zhy6p8GYU3U=;
        b=doaN3ZFqN3DtDDU7dn+1l0cb7l95xbybca8oAT8r8UAmJrtoAPSHQu8PuMNCAS+SmE
         Z3wKLQQ4SV64aGbTdxeZz72MzyHeeG8Kwm9ZTh99C/aZWWJdeDC5kKCGsX7RNwijxq/I
         ky65dI8qsQDokzNWVAEnNAJno/lxthCmTx88xgzx8EC64Z4azp2HNLbPrItvHymI9rdF
         H2agcA2NrGQMNt966twkhu+14SjfRFukwXtkJOCypWcO2orDbzIKxc4q6ywqiv3dqUN2
         uTNX0xbhVpjbwkP1ipn1T+BMj7ChOv8Z7gcdZkq2WyKEmqzLVR4No/QtfrT7YtxMEQug
         j2KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708131514; x=1708736314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zM1FhW7Qr3v0FtC5FiOLqFulLhlj/jL3zhy6p8GYU3U=;
        b=HEvHAMZtkLbc4h/UXL2ZwcKgbtd+uv0DYMPoAG7v6Ao3ppoOete/jn2qqKy4VjEQVq
         tmgni8Lcn9u2QsZn7oDR5iuTtW4DouNX4BqYr1Y0ZlIT/MAKsZRT1axIzx0cBl6F9/cE
         2VtO+UCutCLR4ZfK2mKSbhsEPqq7j+gC4eyNb/YVznbjewVbsy1MZb9eXbc5RG/DkXCF
         4ZLI/mR+/hb9apCCOfQyexk1dxNINfYzaN2KgDpNLniefzm56aAb7jeMJdkPrlOu3mne
         cLk4QwP7ejOhOoCYIks2NJ/IdvFIqiVIZjNA4oAsJV13KsJ+A72t3L4qfHu1BzucPNu/
         0+Tw==
X-Forwarded-Encrypted: i=1; AJvYcCUuQ8/uFeMc3oaVrnWRObKoohodyFdLDy5ubefaq02iOINb7UyNkCMyPyl769sqjk5T8w1YrQRtw7xiqZGjZw+aNCqG
X-Gm-Message-State: AOJu0Ywn0RQdEBhj5jCe3hiGb8PvERQDEf/zDPHBtM9Ebaxw+CL5c5B7
	/j2PPezi5jSUyEEMnU0ZN5Nb/FF9HNyw0Dhrc4G1z2im4VyWyhorytZ7ZM5tvWk=
X-Google-Smtp-Source: AGHT+IG/18cu0XQrzjjkqrWO02cvxzc2sKclTHZn6KgjzARvIp50etYjTOykyTJQBV988xbbQes5Kw==
X-Received: by 2002:a6b:7018:0:b0:7c4:2254:8e59 with SMTP id l24-20020a6b7018000000b007c422548e59mr6880303ioc.5.1708131514686;
        Fri, 16 Feb 2024 16:58:34 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b005dc89957e06sm487655pga.71.2024.02.16.16.58.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 16:58:34 -0800 (PST)
From: Atish Patra <atishp@rivosinc.com>
To: linux-kernel@vger.kernel.org
Cc: Atish Patra <atishp@rivosinc.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <anup@brainfault.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Atish Patra <atishp@atishpatra.org>,
	Christian Brauner <brauner@kernel.org>,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Conor Dooley <conor@kernel.org>,
	devicetree@vger.kernel.org,
	Evan Green <evan@rivosinc.com>,
	Guo Ren <guoren@kernel.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ji Sheng Teoh <jisheng.teoh@starfivetech.com>,
	John Garry <john.g.garry@oracle.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kan Liang <kan.liang@linux.intel.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	Ley Foon Tan <leyfoon.tan@starfivetech.com>,
	linux-doc@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rob Herring <robh+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Will Deacon <will@kernel.org>,
	kaiwenxue1@gmail.com,
	Yang Jihong <yangjihong1@huawei.com>
Subject: [PATCH RFC 08/20] dt-bindings: riscv: add Ssccfg ISA extension description
Date: Fri, 16 Feb 2024 16:57:26 -0800
Message-Id: <20240217005738.3744121-9-atishp@rivosinc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240217005738.3744121-1-atishp@rivosinc.com>
References: <20240217005738.3744121-1-atishp@rivosinc.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add description for the Ssccfg extension.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 .../devicetree/bindings/riscv/extensions.yaml       | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index 77a9f867e36b..15adeb60441b 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -128,6 +128,13 @@ properties:
             changes to interrupts as frozen at commit ccbddab ("Merge pull
             request #42 from riscv/jhauser-2023-RC4") of riscv-aia.
 
+	- const: smcdeleg
+	  description: |
+	    The standard Smcdeleg supervisor-level extension for the machine mode
+	    to delegate the hpmcounters to supvervisor mode so that they are
+	    directlyi accessible in the supervisor mode. This extension depend
+	    on Sscsrind, Zihpm, Zicntr extensions.
+
         - const: smstateen
           description: |
             The standard Smstateen extension for controlling access to CSRs
@@ -154,6 +161,12 @@ properties:
             interrupt architecture for supervisor-mode-visible csr and
             behavioural changes to interrupts as frozen at commit ccbddab
             ("Merge pull request #42 from riscv/jhauser-2023-RC4") of riscv-aia.
+	- const: ssccfg
+	  description: |
+	    The standard Ssccfg supervisor-level extension for configuring
+            the delegated hpmcounters to be accessible directly in supervisor
+            mode. This extension depend on Sscsrind, Smcdeleg, Zihpm, Zicntr
+            extensions.
 
         - const: sscofpmf
           description: |
-- 
2.34.1


