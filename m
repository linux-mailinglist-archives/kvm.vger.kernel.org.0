Return-Path: <kvm+bounces-35584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 73F40A12A7F
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 19:10:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 885D4163BC9
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2025 18:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 038261D5AC0;
	Wed, 15 Jan 2025 18:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VxChtGMM"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5CE14A630
	for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 18:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736964631; cv=none; b=V1+FkGA6FUz2V/o0gxm5cG8/MhO0e1/JxX4jHS9ZeNC27Tkft+b39v53suLsbdyDeh+iiR4DgXB8Tkm1xDp59VA9HUDGyQ1itCtBqCjS2lLlcl9ndTCcXPvZ96CxNsHeptzqVCBY5zWE7X6kViifS6Fvl1jetpEtEpJiR/OEehY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736964631; c=relaxed/simple;
	bh=yQ/sw9wRMFaarqcRa9DR96lwFaiZR3HU9sR4NGAmQo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j+pPGwHgYffoI5ofgcZ5tjsQdIG7WxWrhvAQZUZmV4pPaecHGJ0z0cSmJubqEK+MR2pqZZsi76ThJiug7bWPkKiTXD6Q6WBEj4OSKivovt0lb/WP8IFhdeI0HMzZVx0XMOt9uRFcGVszwTIrNCWtoQno9WoAfwE8oXPATz07bTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VxChtGMM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736964628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W72gn/X43iSEWHwc8vF+OcjzKNW4pEeZuQNi+6C4SJg=;
	b=VxChtGMMclFrtapoA4l6Jfzf4WJHvfEBBj+KQ39EfB3FDXmsVRMcgYFggZe89G61qtrWqX
	D7eOxhpYQw6HrmN7etQ6uxD06g6ZRiwjddjQpup5MLVtZVeMqps4Wp+gsPGhqv9MacNfvX
	JIP92g48XNysP3R/cJ3j/tUPgITNsVw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-302-zRtRW8NIMcOxaO0iVgh3zg-1; Wed, 15 Jan 2025 13:10:26 -0500
X-MC-Unique: zRtRW8NIMcOxaO0iVgh3zg-1
X-Mimecast-MFC-AGG-ID: zRtRW8NIMcOxaO0iVgh3zg
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-436723bf7ffso32477515e9.3
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2025 10:10:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736964625; x=1737569425;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W72gn/X43iSEWHwc8vF+OcjzKNW4pEeZuQNi+6C4SJg=;
        b=YGvv/nT5rCUdx1hszLeb3nZB712xmQDll27xQbMVN5uVIq9qeu2M9hKuSbFalT5Snt
         ANyXN5G9odlL70oX8oJhADY271h87ZwgZedZURKPzNn4OyZ17A3OLb+HNxCKqM7Kmf0U
         gnimwrLi7qDS9BDSvXwHBNLUxX8Cf0QQLcOa11YYkUzZAh5yiCQpP5H+cyQHZWkLi3nC
         6nckfaQNC4gdmMIdODfgQ0RFlKok4z58cKkzbjGmsmNbZEaeeuLHmUgfjv4gyfEKn5/4
         rW2GYdArQkDieNhen6MfcxJvAgd/no18iEEqOvMJh1H+FcrJF+DcAjLogVGznnSp5czC
         61AA==
X-Forwarded-Encrypted: i=1; AJvYcCXZE9F2/hpSosLz5xMa8kZpv56Gg8szlZ8LwEgYhfDufmJKkG7f6vUle9+n+LgbJWfdsI4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUc6P7MThBlOzxmGR4ejpJzh6Ven+k3S9VQFpzj0t+nVsn6Jn0
	B86duPsILZB3B7PhmvvsxuDKKPwh8iZjSj1lztIYLB9ffj5qNcTWbyitmEqrMLb2tNddBcaIeXi
	HJ+ujgok8FayUczNGdoY1IkXXktB9gB0zL50tRCdAXyJk3L0dBg==
X-Gm-Gg: ASbGncu4oksHTmF0AnJsmC8RdnHyKSGow/eGFYcuyoEY5IJCWypdCNVHJmwymebHvYI
	mhfXvN5OkcVpC4tX223H16D1WByFh7Nz5157q+/Mfo9Zcq8R0xmwq3M0XaoVJ1GhjpfYCtg/Bqc
	5her0NhY8V1XpQqb+/51zZi8f2SSBUblKo7R3rBaB6Z/KO8nUlsy5hy9a/HDhWCt9A81nWJYv8z
	cwyG6lTCJLM3pdo2y3ICfbqPTFT2mu754hFjqYU3cyEgVyjEAq9
X-Received: by 2002:a05:600c:4586:b0:434:f817:4492 with SMTP id 5b1f17b1804b1-436e26f47f9mr300718005e9.31.1736964625036;
        Wed, 15 Jan 2025 10:10:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGQBbQ/ucVqe/1aRLFuXcnKDdErlW+RXJrbuNeDn0+FcDJpY3P4Ms2jbcdoT38rACpbOJjs1A==
X-Received: by 2002:a05:600c:4586:b0:434:f817:4492 with SMTP id 5b1f17b1804b1-436e26f47f9mr300717745e9.31.1736964624696;
        Wed, 15 Jan 2025 10:10:24 -0800 (PST)
Received: from redhat.com ([2a0d:6fc7:342:db8c:4ec4:322b:a6a8:f411])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a8e38bf78sm18082767f8f.48.2025.01.15.10.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 10:10:23 -0800 (PST)
Date: Wed, 15 Jan 2025 13:10:21 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Igor Mammedov <imammedo@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ani Sinha <anisinha@redhat.com>,
	Dongjiu Geng <gengdongjiu1@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
	kvm@vger.kernel.org
Subject: [PULL 36/48] acpi/ghes: better name GHES memory error function
Message-ID: <d32028a54000db671eb2d0b6b28bbf15acc2e5f9.1736964488.git.mst@redhat.com>
References: <cover.1736964487.git.mst@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1736964487.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

The current function used to generate GHES data is specific for
memory errors. Give a better name for it, as we now have a generic
function as well.

Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Message-Id: <35b59121129d5e99cb5062cc3d775594bbb0905b.1736945236.git.mchehab+huawei@kernel.org>
Reviewed-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 include/hw/acpi/ghes.h | 4 ++--
 hw/acpi/ghes-stub.c    | 2 +-
 hw/acpi/ghes.c         | 2 +-
 target/arm/kvm.c       | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/hw/acpi/ghes.h b/include/hw/acpi/ghes.h
index 8859346af5..21666a4bcc 100644
--- a/include/hw/acpi/ghes.h
+++ b/include/hw/acpi/ghes.h
@@ -74,15 +74,15 @@ void acpi_build_hest(GArray *table_data, GArray *hardware_errors,
                      const char *oem_id, const char *oem_table_id);
 void acpi_ghes_add_fw_cfg(AcpiGhesState *vms, FWCfgState *s,
                           GArray *hardware_errors);
+int acpi_ghes_memory_errors(uint16_t source_id, uint64_t error_physical_addr);
 void ghes_record_cper_errors(const void *cper, size_t len,
                              uint16_t source_id, Error **errp);
-int acpi_ghes_record_errors(uint16_t source_id, uint64_t error_physical_addr);
 
 /**
  * acpi_ghes_present: Report whether ACPI GHES table is present
  *
  * Returns: true if the system has an ACPI GHES table and it is
- * safe to call acpi_ghes_record_errors() to record a memory error.
+ * safe to call acpi_ghes_memory_errors() to record a memory error.
  */
 bool acpi_ghes_present(void);
 #endif
diff --git a/hw/acpi/ghes-stub.c b/hw/acpi/ghes-stub.c
index 2b64cbd281..7cec1812da 100644
--- a/hw/acpi/ghes-stub.c
+++ b/hw/acpi/ghes-stub.c
@@ -11,7 +11,7 @@
 #include "qemu/osdep.h"
 #include "hw/acpi/ghes.h"
 
-int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
 {
     return -1;
 }
diff --git a/hw/acpi/ghes.c b/hw/acpi/ghes.c
index 6f40cd35a9..66bd98337a 100644
--- a/hw/acpi/ghes.c
+++ b/hw/acpi/ghes.c
@@ -415,7 +415,7 @@ void ghes_record_cper_errors(const void *cper, size_t len,
     return;
 }
 
-int acpi_ghes_record_errors(uint16_t source_id, uint64_t physical_address)
+int acpi_ghes_memory_errors(uint16_t source_id, uint64_t physical_address)
 {
     /* Memory Error Section Type */
     const uint8_t guid[] =
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index a9444a2c7a..da30bdbb23 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -2387,7 +2387,7 @@ void kvm_arch_on_sigbus_vcpu(CPUState *c, int code, void *addr)
              */
             if (code == BUS_MCEERR_AR) {
                 kvm_cpu_synchronize_state(c);
-                if (!acpi_ghes_record_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
+                if (!acpi_ghes_memory_errors(ACPI_HEST_SRC_ID_SEA, paddr)) {
                     kvm_inject_arm_sea(c);
                 } else {
                     error_report("failed to record the error");
-- 
MST


