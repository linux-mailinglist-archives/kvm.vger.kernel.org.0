Return-Path: <kvm+bounces-8935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02EB3858C5F
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 02:04:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27B591C2177D
	for <lists+kvm@lfdr.de>; Sat, 17 Feb 2024 01:04:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A57BA33082;
	Sat, 17 Feb 2024 00:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b="IgB1jEAv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2489E2DF9D
	for <kvm@vger.kernel.org>; Sat, 17 Feb 2024 00:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708131538; cv=none; b=iq8XZAWaRGGGLUzSbOSYnJFhbT8qiHjUIn1mxG8DuDRoWdNRCM+5x/QPxQgTUFhEMZXsH7U4W1YiLIRoroMbzEOhUM5CFg+vlFaFtE1uOYwX/tj9XE9sYnxtDxHC+r8wizT4rMeBM/dVnll4vRjJR4Vij5scf+2TMBqTaJPMXxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708131538; c=relaxed/simple;
	bh=54qScfthhEAuE+eosMKvOHGN/ixxPgbOd6VfF3jL3Tw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nDpACyTMxassJ+2u/2TMaSZ4sC3BWkpo1Zm2JiYVE/xKqJG79ZlUC39Z7HazcQQDIc/PjekqGbqc72l+YpRRcLwoLA1SLvwD6vpjhJ8vNzEaGNN+8cXgS0ZXP10zZoc9GbYm8rRj7OVDCE7dRF3WNdMTx8eXTRpHT5HGd6MEsEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com; spf=pass smtp.mailfrom=rivosinc.com; dkim=pass (2048-bit key) header.d=rivosinc-com.20230601.gappssmtp.com header.i=@rivosinc-com.20230601.gappssmtp.com header.b=IgB1jEAv; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=rivosinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rivosinc.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-214def5da12so746573fac.2
        for <kvm@vger.kernel.org>; Fri, 16 Feb 2024 16:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1708131536; x=1708736336; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UM8zssVewnxKekt4u8gJqVdaJ7ofC8o/V7nPW8x9v/k=;
        b=IgB1jEAvE7iziKe+kiL4G5rklZhg3WbbRBBwz4ZZG025TosNvCatOhacEuCwYZbbDv
         1/OIZ0YFWVO7/uytWcDkABOvZeIpc47ewmvGP51nsbyn5RcQteoyW3DPeETQr+BmZJ4/
         h1RKcwHZEs2mEyB/rpYav+dk/Qv7CN43JjuOwG+5lRD9PEhuqTwoPZxzXz3oNbu1Whnb
         Ao7T+RPeGC3Z/WDky5jnm8Qz7MdD9y78/JnrqYQgYkXMBZE/oav16ct1GHza/lJyVeJF
         ZmCFbxTAEKMyt111fBvI4dS1xyrutETKjgC/h7vZ492YLeysf0CJ+edkROLAe8e1t3KP
         XMcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708131536; x=1708736336;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UM8zssVewnxKekt4u8gJqVdaJ7ofC8o/V7nPW8x9v/k=;
        b=IBZ1HOiiEj2tT97x/1nvYaUVh0lsIkIoIGxFSasvggT9Dbb2ZfoVTlrfQtHkNtnXxQ
         nq5wxA0yqWcVC7CE/YeSD0zxy7OdMO2NQxo45KXRAdgLQJ+Yl/Keizcbzz5TXQBBnBh1
         FPE8xxfzdt33yqS+dhOvlA4CPBfXXvaPTye4HqF6OBVTQHFqzVqPNHTcTvtikKmuxRNg
         9D6o1xElksIAvYe4DPBl3Lc/l7wg+ufoH6BCjPm3HGxiDZ7OFt7eJmQ3MOAZQ7kMLprp
         aWyqCrRh5g6Ui32SgHp4FHRgx66R8urbOCYiraPO2Z2+Pw6fGVVeejJO8zfQ7HlXjVxE
         Lb4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUxPvwC0JGrkx9NTdjBH9LkeAOvuBJDiENZhm9fpg0FCi6AhW8XqyShj+I8KA9NPat52i2a21xKGli9uoj+I0LCeRNi
X-Gm-Message-State: AOJu0YyxGBpsuuwjQVBvgEImHE+iwCLb99CL6fBz37IKuHD3XzgkTNCR
	U76X+Ci7tfZyvhnHOPKkkuTWhuXDTiOBoyIAJaNN1h7CHnN1vqVf9G1I798+Kn8=
X-Google-Smtp-Source: AGHT+IHxQ/ohabidKPISMfSUq9m2exq/kzmKZJs/ZvDEyG8lUk4zXZLeanKyyRpfmzqm9XJNLg+WQw==
X-Received: by 2002:a05:6870:d88d:b0:218:df68:87b2 with SMTP id oe13-20020a056870d88d00b00218df6887b2mr6753520oac.44.1708131536206;
        Fri, 16 Feb 2024 16:58:56 -0800 (PST)
Received: from atishp.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d188-20020a6336c5000000b005dc89957e06sm487655pga.71.2024.02.16.16.58.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Feb 2024 16:58:55 -0800 (PST)
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
Subject: [PATCH RFC 16/20] tools/perf: Pass the Counter constraint values in the pmu events
Date: Fri, 16 Feb 2024 16:57:34 -0800
Message-Id: <20240217005738.3744121-17-atishp@rivosinc.com>
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

RISC-V doesn't have any standard event to counter mapping discovery
mechanism in the ISA. The ISA defines 29 programmable counters and
platforms can choose to implement any number of them and map any
events to any counters. Thus, the perf tool need to inform the driver
about the counter mapping of each events.

The current perf infrastructure only parses the 'Counter' constraints
in metrics. This patch extends that to pass in the pmu events so that
any driver can retrieve those values via perf attributes if defined
accordingly.

Signed-off-by: Atish Patra <atishp@rivosinc.com>
---
 tools/perf/pmu-events/jevents.py | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/tools/perf/pmu-events/jevents.py b/tools/perf/pmu-events/jevents.py
index 30934a490109..f1e320077695 100755
--- a/tools/perf/pmu-events/jevents.py
+++ b/tools/perf/pmu-events/jevents.py
@@ -278,6 +278,11 @@ class JsonEvent:
         return fixed[name.lower()]
       return event
 
+    def counter_list_to_bitmask(counterlist):
+      counter_ids = list(map(int, counterlist.split(',')))
+      bitmask = sum(1 << pos for pos in counter_ids)
+      return bitmask
+
     def unit_to_pmu(unit: str) -> Optional[str]:
       """Convert a JSON Unit to Linux PMU name."""
       if not unit:
@@ -401,6 +406,10 @@ class JsonEvent:
       else:
         raise argparse.ArgumentTypeError('Cannot find arch std event:', arch_std)
 
+    if self.counter:
+      bitmask = counter_list_to_bitmask(self.counter)
+      event += f',counterid_mask={bitmask:#x}'
+
     self.event = real_event(self.name, event)
 
   def __repr__(self) -> str:
-- 
2.34.1


