Return-Path: <kvm+bounces-45873-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C14FAAFBB4
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 15:41:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7C6F13B9855
	for <lists+kvm@lfdr.de>; Thu,  8 May 2025 13:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA91522D9EC;
	Thu,  8 May 2025 13:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FZGpvfeW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEBF22D9E7
	for <kvm@vger.kernel.org>; Thu,  8 May 2025 13:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746711679; cv=none; b=u1piaDHGFjqplIuqMTlrpl1oyMjuQwPKESLiysHHv2ouVLzTTdnzuhFFEBWIh4OQmB0VtGdb0p4GSZG3N3wya73ilV76BY4nkNbX8BvZX3v28ZLbQeIiWjPJnI0i3305+KpIv2bT/2doHEQiimOPc4/kWFhtDyHjcr1Pfe8Li30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746711679; c=relaxed/simple;
	bh=NYzqMG2HzabFqlxc49i4QP2EWx2ei+hSADGVFfzS1tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YvHIKMMUy+7tru3T5VwMFal7sTKM9OltCDILN6Loxcd9mBbwLahVOfjpwLyB2zeQtEGWOXLdQ/AiPnLyaaE947EdlkHutOkGZlW51Ekd+r+OScwPDCVf8oAJzUSNlbFVJGLbBC04j2JtWO3dj0BXLlZ8MVCQc1LWmaUtR6Str1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=FZGpvfeW; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3081f72c271so1010998a91.0
        for <kvm@vger.kernel.org>; Thu, 08 May 2025 06:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746711676; x=1747316476; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GfnNMh8um2i71NVQR7Vo7AAo9gkZrP7mDUQkPEIxOEM=;
        b=FZGpvfeWakYoj72PpTHaOOMGiLvTCZWXMpSx7jZl0coNw2KlxceeKaxNY6JqACf5iA
         uWr6ap+VTB01XVO+IbHCw3AZr1rPMI/zI7FA+6lUK+NmREwW5L37PTuO8hm2G8SpZbm7
         RUPVEyM1QnXzvkpTSRv9QhifW96WF/CETs70rWyixtNMsFO5RAzWYb+tRNTf/lNhRwp0
         oO8am0h0oh581dvxNXuTmKikg2/HbFpc2TdAGAZatn1Eg+1nc5r5FiUguM38KiaNWqoH
         +wU3wrJsqZNFAu2t3bfoNhly6EHtinbSNJo5P/R42+50qcgxWnT9fOv+dvdU/YKQFDFf
         dMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746711676; x=1747316476;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GfnNMh8um2i71NVQR7Vo7AAo9gkZrP7mDUQkPEIxOEM=;
        b=S3M/GOP8cemS9oZQDq1o4B3VoRjZnB2J+VDyaZf6WQfhRLrwq79qf2RAjbKkzqNRtr
         L13usznV5uZrHu8hjB3AaLa4/DGMovQFiKBaFatvLM2CtXABeM//WLMCZHvatibZLM55
         9xI79i8KeGfdOWVJFgsQ+RA0pXwOMVUHH6lNttnN6wZEY28tiewwCLBQTS9rSepQEY+1
         /8MOfvgQe2EHcnwZt5EUSCgw8aOeKmRx+Lbt6iJjDCbpt6wOeiaOkxiW/UIqVM4ZWsVi
         /B95JhP1ZnhmwWAuhnPj2UrwJd3AFN2gpIztBIYdzmdMHe2iuWUrcrhS+cy55PWXHN4P
         HaTw==
X-Forwarded-Encrypted: i=1; AJvYcCVTZSo3qXF8pxE2rg02sTrfda0WuiLaJIi1oFFeIUfJH6LhFRDPUJ2utKQ6uA7s0ruUl2E=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7ClN7ratdV1wHoEDUmhSe4Jtw9JnmDbOLVz8tMOdpUPgzjTM1
	ALAuiy3Cpb70H9Bkmi8rhlakJh7lbf8/OKtP7cREw62Yg+DLbJz23O4BeMMWGJ8=
X-Gm-Gg: ASbGncvGnf0HuYaILT+Ij11+lnYyU3jqnrpDD8oJ61mPi5h7TmFWhqiM8XZ5md6pV88
	h2zp1YYh/l/4hZuHedqOeZ5GL/0ItdgVO7zm9NTyTZDcrl4u9Zmh3rnUW7w5/14zmY/g5wCBWjs
	VPXCqdx45rBXctEiLf28ZWfrnSu7bIjYnWbDxkWf34elikDcvGXxuwaPejunBOM7h1P/KKoeW1x
	HBkZ5m1+tHz9QIc7YJ2UT1/T/GoixgdE/eBswArg1fdupbGufMsQPcrDlybYMKfTBucf8gzdq4I
	PlFPkLXlwPilCsNmQg9ovTM0W5jYUArwH3nqnGJaWgX4gnZhbeIN8795VILFIzmWiFhQzMuX0Q8
	g3B8iaggMjxrNDLU=
X-Google-Smtp-Source: AGHT+IFQ8LW9RTSMx316iiBnCrKC++OfGZqWRTBj59NXdQh9cJmdJ08Q8za3gukxznk5+tstJeDxpA==
X-Received: by 2002:a17:90b:278e:b0:2fa:1a23:c01d with SMTP id 98e67ed59e1d1-30aac1b407amr10664017a91.21.1746711675615;
        Thu, 08 May 2025 06:41:15 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30ad4d56981sm2115127a91.28.2025.05.08.06.41.01
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 May 2025 06:41:15 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Sergio Lopez <slp@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Yi Liu <yi.l.liu@intel.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	qemu-riscv@nongnu.org,
	Weiwei Li <liwei1518@gmail.com>,
	Amit Shah <amit@kernel.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Helge Deller <deller@gmx.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Ani Sinha <anisinha@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Mark Cave-Ayland <mark.caveayland@nutanix.com>,
	Thomas Huth <thuth@redhat.com>
Subject: [PATCH v4 14/27] hw/intc/apic: Remove APICCommonState::legacy_instance_id field
Date: Thu,  8 May 2025 15:35:37 +0200
Message-ID: <20250508133550.81391-15-philmd@linaro.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250508133550.81391-1-philmd@linaro.org>
References: <20250508133550.81391-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The APICCommonState::legacy_instance_id boolean was only set
in the pc_compat_2_6[] array, via the 'legacy-instance-id=on'
property. We removed all machines using that array, lets remove
that property, simplifying apic_common_realize().

Because instance_id is initialized as initial_apic_id, we can
not register vmstate_apic_common directly via dc->vmsd.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Mark Cave-Ayland <mark.caveayland@nutanix.com>
Reviewed-by: Thomas Huth <thuth@redhat.com>
---
 include/hw/i386/apic_internal.h | 1 -
 hw/intc/apic_common.c           | 5 -----
 2 files changed, 6 deletions(-)

diff --git a/include/hw/i386/apic_internal.h b/include/hw/i386/apic_internal.h
index 429278da618..db6a9101530 100644
--- a/include/hw/i386/apic_internal.h
+++ b/include/hw/i386/apic_internal.h
@@ -188,7 +188,6 @@ struct APICCommonState {
     uint32_t vapic_control;
     DeviceState *vapic;
     hwaddr vapic_paddr; /* note: persistence via kvmvapic */
-    bool legacy_instance_id;
     uint32_t extended_log_dest;
 };
 
diff --git a/hw/intc/apic_common.c b/hw/intc/apic_common.c
index 37a7a7019d3..1d259b97e63 100644
--- a/hw/intc/apic_common.c
+++ b/hw/intc/apic_common.c
@@ -294,9 +294,6 @@ static void apic_common_realize(DeviceState *dev, Error **errp)
         info->enable_tpr_reporting(s, true);
     }
 
-    if (s->legacy_instance_id) {
-        instance_id = VMSTATE_INSTANCE_ID_ANY;
-    }
     vmstate_register_with_alias_id(NULL, instance_id, &vmstate_apic_common,
                                    s, -1, 0, NULL);
 
@@ -412,8 +409,6 @@ static const Property apic_properties_common[] = {
     DEFINE_PROP_UINT8("version", APICCommonState, version, 0x14),
     DEFINE_PROP_BIT("vapic", APICCommonState, vapic_control, VAPIC_ENABLE_BIT,
                     true),
-    DEFINE_PROP_BOOL("legacy-instance-id", APICCommonState, legacy_instance_id,
-                     false),
 };
 
 static void apic_common_get_id(Object *obj, Visitor *v, const char *name,
-- 
2.47.1


