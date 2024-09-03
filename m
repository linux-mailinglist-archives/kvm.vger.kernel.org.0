Return-Path: <kvm+bounces-25747-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBBC996A0E1
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 16:40:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 877AC288EFA
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 14:40:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86282181CE1;
	Tue,  3 Sep 2024 14:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vHoflyVp"
X-Original-To: kvm@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E083817DFF4
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 14:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725374400; cv=none; b=nj/Atr1fepokyzZSCTECwfXZhrixkIA726CBwWyhtK+Bix4ABRHJ8Vo5rWuHG/YRmPJ4odBsAvAUkWpHREKE62607eAjg61a9eM4l+ApOJPc8AwvmVLe8KekGTNJu45ZRU/Jm4F8PpF/GJxVxu0J2haMinxr1xYs7JlHQJWUWJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725374400; c=relaxed/simple;
	bh=7r3q/OA4JOn6gDyQoxbuK/DlZbC7pbU4kuOIDChyxuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XUQG000FFFMRBIZDGqi6tJKscL3g9b//1YNLHiXEydUx+tgEQaUvAP2eiAWGo1M88yJpdVs0hB2ry7WhV+S6G7MpXQtKk2dgPzVRGB7oBJC9Y+eALDe5YH0/ffPIGvR7v+k7/vcAZiYOHJNWTbTPSuBAZL5u/W0QFAFFCW47cZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vHoflyVp; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1725374396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=acROeX4wqHQCBibnKLGyiTpwL0vS0RTu/8rh/TC4rLI=;
	b=vHoflyVpKDBL64vOUcRFDZgtoMnMqr7rwaRFtKEoQMfwFLEhKq5tk7LEfCwXEynItLVdq6
	tjakOD0DyfhDsmpS74rXU2Hp/uMw/gF1zkwEDUs0P8OCRQYTNbjiXiwxKSFkzxTUgxYXk3
	vK98MhaeymL1QkoxovGVAv1Na1ChSP8=
From: Andrew Jones <andrew.jones@linux.dev>
To: kvm@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-s390@vger.kernel.org
Cc: pbonzini@redhat.com,
	thuth@redhat.com,
	lvivier@redhat.com,
	frankja@linux.ibm.com,
	imbrenda@linux.ibm.com,
	nrb@linux.ibm.com,
	atishp@rivosinc.com,
	cade.richard@berkeley.edu,
	jamestiotio@gmail.com
Subject: [kvm-unit-tests PATCH 2/2] riscv: Make NR_CPUS configurable
Date: Tue,  3 Sep 2024 16:39:49 +0200
Message-ID: <20240903143946.834864-6-andrew.jones@linux.dev>
In-Reply-To: <20240903143946.834864-4-andrew.jones@linux.dev>
References: <20240903143946.834864-4-andrew.jones@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Unit tests would like to go nuts with the number of harts in order
to help shake out issues with hart number assumptions. Rather than
set a huge number that will only be used when a platform supports
a huge number or when QEMU is told to exceed the recommended
number of vcpus, make the number configurable. However, we do bump
the default from 16 to 2*xlen since we would like to always force
kvm-unit-tests to use cpumasks with more than one word in order to
ensure that code stays maintained.

To override the default for NR_CPUS to, e.g. 256, testers should use
--add-config. For example,

  $ cat <<EOF > 256.config
  #undef CONFIG_NR_CPUS
  #define CONFIG_NR_CPUS 256
  EOF
  $ ./configure --arch=riscv64 --cross-prefix=riscv64-linux-gnu- --add-config=256.config

Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
---
 configure             | 3 ++-
 lib/riscv/asm/setup.h | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/configure b/configure
index 7a1317d0650d..5ed0c28fcaea 100755
--- a/configure
+++ b/configure
@@ -508,7 +508,8 @@ EOF
 elif [ "$arch" = "riscv32" ] || [ "$arch" = "riscv64" ]; then
 cat <<EOF >> lib/config.h
 
-#define CONFIG_UART_EARLY_BASE 0x10000000
+#define CONFIG_NR_CPUS			(__riscv_xlen * 2)
+#define CONFIG_UART_EARLY_BASE		0x10000000
 
 EOF
 fi
diff --git a/lib/riscv/asm/setup.h b/lib/riscv/asm/setup.h
index a13159bfe395..43b63c56d96f 100644
--- a/lib/riscv/asm/setup.h
+++ b/lib/riscv/asm/setup.h
@@ -2,9 +2,10 @@
 #ifndef _ASMRISCV_SETUP_H_
 #define _ASMRISCV_SETUP_H_
 #include <libcflat.h>
+#include <config.h>
 #include <asm/processor.h>
 
-#define NR_CPUS 16
+#define NR_CPUS CONFIG_NR_CPUS
 extern struct thread_info cpus[NR_CPUS];
 extern int nr_cpus;
 extern uint64_t timebase_frequency;
-- 
2.46.0


