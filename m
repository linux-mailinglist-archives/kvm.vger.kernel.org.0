Return-Path: <kvm+bounces-55237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AE80BB2ECD0
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 06:30:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECC2EA23AFA
	for <lists+kvm@lfdr.de>; Thu, 21 Aug 2025 04:29:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6E922D7806;
	Thu, 21 Aug 2025 04:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HR/g7Zf6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646B227A465
	for <kvm@vger.kernel.org>; Thu, 21 Aug 2025 04:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755750567; cv=none; b=abhMLJ8Izwr3PGrp/zzDhBw7AU7x4r2h2VON4Y7u6gCE1TSS/qRF0UUIz54XdKkeW8OmABYKb37ycxKIPRwZH9rYBVV2UR+KFZ+O4I2xtw4nkGCpUPpcDUGmwVr/121Sj/Yhk1bn1U0OdO0KZmswPrNogYwUx5qInCJlANDhmIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755750567; c=relaxed/simple;
	bh=CNyH3iLKYyXM2PucLKJJexKys2GtwF+RYJ7BGDIxHvI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LvP3XxGAuKD29h0H3fA+4oBMMFw1HzCWkJmaQnTRRCzmBLnFHwBxpBIeIL1YAvmh1gdVsVyBSTcWugC8lH6aIkXJlA+vQxds5uCQiywIt12jyhgbXqsst9QVi3H2CkO3QIgtfa4guZTMPf28W+9nH5r0YAxODyiYj2DlTTkMpYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HR/g7Zf6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sagis.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326e2f184so1309881a91.3
        for <kvm@vger.kernel.org>; Wed, 20 Aug 2025 21:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755750565; x=1756355365; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SBEsUjopqWPQAb2i5kfB0Dt1bw+I4tk4XbZtWvO+5Q0=;
        b=HR/g7Zf6lVjDWjBvejs8wa0gs8fo7FozKRZGsTvlHW9cRa/dnEXMfwB8BjOlYW7oE4
         7XOKS3MVd/dkEyG2ha38LXnIhITqlcFDM6NAtKS5VX6r66Tu52P1Lry8iANe4HGslbw1
         KFXr+B5mcyU8hcOIOBCv9V0LPXFY0+KNB6blH/NVIEXvMUN3uuAR2cPYRH0Yk3TNy5a9
         TAk6nrhkNz7Hx0oxegPFthhMGla+LmP68IumEYzT5zQuEVDa1t59rmJtQwCJjNSW8X/u
         encJUlHm5vmWbMDiOb1DWiBPJ8R/rpTc3p+jmEXIpnyzGVJI/wwIG1u61GunE8QWQ4L1
         Dt8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755750565; x=1756355365;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SBEsUjopqWPQAb2i5kfB0Dt1bw+I4tk4XbZtWvO+5Q0=;
        b=umFh03KggsgMD7xPtYt73oAutajPlmmdJVHeXVq1aHFu0cR7f9TgqAIB/Vm/VtwowN
         uKlLQV/MJ7BPIO3DJ23WCymOb8WZSLHbfqLVl/72xK/d5X/xWh00NjPQletDUoA00urN
         flOO5GbsHy2vhYs+Nu4X0wfRdyi2mo4NjIeOa9mJ4FmLR8sRKGRgONa7s8IvWPLTbTBO
         qQpF/AuaaaoZfUNF3YRv1bhJJXd2scba+rkc3Z4/M/Obvq75Ay2mA/WrU3Gm1moru8+9
         FPwIT2m5PZqF3QI9FK5eRwO0Ap6hInGimOiPa51gBpjAxxZlJrIlOFyFicgIFy1E+gV6
         aoxw==
X-Forwarded-Encrypted: i=1; AJvYcCXPzktsPIeKmqrSajXdY/BcBpvJWJJfVWneZZ5tZtRFvg8JRHyE32qsFl0H9BK3ejdDjhs=@vger.kernel.org
X-Gm-Message-State: AOJu0YxmDiUqvHDKace5LtI8ioEdvWftvLO9bijlr42OUNCNZkSGhICp
	tKvn6j7FciAyjFl+kvGGGm3Rznd5DmoFiPvkeNfxGPxiB7txDXb17zYpaWUM6Dgs2OJLpTOe8P0
	15Q==
X-Google-Smtp-Source: AGHT+IFYWwfWRedCl4TaEHt8DsZOpI9aKhsO1LVwtOPR4LokBo0OPUYbdS7T4gGWHlqrRzQ2RYeoQBN9pA==
X-Received: from pjbqx8.prod.google.com ([2002:a17:90b:3e48:b0:321:b354:6b5c])
 (user=sagis job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:53c7:b0:312:1ae9:152b
 with SMTP id 98e67ed59e1d1-324ed114c90mr1478574a91.23.1755750565556; Wed, 20
 Aug 2025 21:29:25 -0700 (PDT)
Date: Wed, 20 Aug 2025 21:28:54 -0700
In-Reply-To: <20250821042915.3712925-1-sagis@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250821042915.3712925-1-sagis@google.com>
X-Mailer: git-send-email 2.51.0.rc1.193.gad69d77794-goog
Message-ID: <20250821042915.3712925-2-sagis@google.com>
Subject: [PATCH v9 01/19] KVM: selftests: Include overflow.h instead of
 redefining is_signed_type()
From: Sagi Shahar <sagis@google.com>
To: linux-kselftest@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Ackerley Tng <ackerleytng@google.com>, Ryan Afranji <afranji@google.com>, 
	Andrew Jones <ajones@ventanamicro.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	Erdem Aktas <erdemaktas@google.com>, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Sagi Shahar <sagis@google.com>, Roger Wang <runanwang@google.com>, 
	Binbin Wu <binbin.wu@linux.intel.com>, Oliver Upton <oliver.upton@linux.dev>, 
	"Pratik R. Sampat" <pratikrajesh.sampat@amd.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Chenyi Qiang <chenyi.qiang@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Redefinition of is_signed_type() causes compilation warning for tests
which use kselftest_harness. Replace the definition with linux/overflow.h

Signed-off-by: Sagi Shahar <sagis@google.com>
---
 tools/testing/selftests/kselftest_harness.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 2925e47db995..a580a0d33c65 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -56,6 +56,7 @@
 #include <asm/types.h>
 #include <ctype.h>
 #include <errno.h>
+#include <linux/overflow.h>
 #include <linux/unistd.h>
 #include <poll.h>
 #include <stdbool.h>
@@ -751,8 +752,6 @@
 	for (; _metadata->trigger; _metadata->trigger = \
 			__bail(_assert, _metadata))
 
-#define is_signed_type(var)       (!!(((__typeof__(var))(-1)) < (__typeof__(var))1))
-
 #define __EXPECT(_expected, _expected_str, _seen, _seen_str, _t, _assert) do { \
 	/* Avoid multiple evaluation of the cases */ \
 	__typeof__(_expected) __exp = (_expected); \
-- 
2.51.0.rc1.193.gad69d77794-goog


