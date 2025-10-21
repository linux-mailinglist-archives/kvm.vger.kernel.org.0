Return-Path: <kvm+bounces-60649-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C9C0ABF5547
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 10:44:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D8E1B4FA34C
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 08:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1481C3203BE;
	Tue, 21 Oct 2025 08:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iEmXwKV7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737B331DDB9
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761036285; cv=none; b=SRMPW00wjKU2HStKo8iGTyx7WLt5OHnkbuGEue8vvKBM63GCISODcyYjYpZG4AoJxkF+1uLAedx8i8jpRONik+ZMW06sWjNS+XTpwC/UdfhnbWXLc17+LV+Q206BLq7N1gBMEi17dotTv96y+5RDjIDk/J7EKpdeCIUtMZwVQEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761036285; c=relaxed/simple;
	bh=bU8OTM4Sva4azhk9zhngw3AYPaL0uJfCEkx5nSLW1oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XvYt/auAbbScOxA4ksp3HjNvejydZMa7XWwB48TzZewJWmTMhFMqjmJIrnazhMgXRMLDC/u3ETgtes9nyEiO7qKecZPwLTkxqVSAU983JdzHvLpAoexwwzdoZVhmGHfWt9C90MC87oZvJnXOKWwk/5RgCpwrHSsuy3hSijk7398=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iEmXwKV7; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47114a40161so10079115e9.3
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 01:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761036282; x=1761641082; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a6Urqf2BFQoz6tGL67HiUuAvlfebveNoSUnXOo9Qq+w=;
        b=iEmXwKV7XaHJjcZO7KiAFnXiPRreei8D1zkz9BDcMGKfvejQcO1adAcByUedRSOwvB
         ggXIY/I1kwNMR1yzq5p0OxSYrVyNMgGTFDg3vuTRDaa05MnJiX5j2k1w3lymlYX+5i8u
         RWb5gTequ0tz5FW2VdlL/eOoaqJiGqDAs6fJ2l0Z0K0s6RO6UiGDwXgnr2b8i/ykwZD5
         8f3EpQGffT+V6/G+QwlzoVzaBZcnU6XuFreOIzHI3hJeCkOdzFSa6FAqFCsHeMS/fGux
         bJn5uddTbfNxpWVGpV2scoaazcDXvppeIIb0WFvt9wVXFbY7rJlr5CntP9+hlcgk4maJ
         5nNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761036282; x=1761641082;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a6Urqf2BFQoz6tGL67HiUuAvlfebveNoSUnXOo9Qq+w=;
        b=C1PTPraw7kpbALD+H1vYPlDLv0P1C7BwecdMfuhWEigXLCmlS7t7ldx2a/1GXfTwJj
         MTUHzdib8sRXvqjMN5uxGbcD6V9yzfZFwJDUxHqW/Sz9//Lky0H1uJhyZ0/fSlDsmqWd
         ltCzgPfehZUqb6O0yBThOSWAv4fcZb8n5fJpmST9FD5ed0ldL2zhjOSYewtJUfODBtX2
         V0kmo0E1F6vvz8TZZ9prXomLZEdcJHHHLb+yL7G0iYxQr1hgwc4E6lEN91J3BXvLVTHs
         jT8gxC2hfPHql3r1pKJj70FlB11agUJ7JXQBxQclaTS6g2EK4J0XvJJhbemHQo4N9haY
         0ctA==
X-Forwarded-Encrypted: i=1; AJvYcCUJcT2kWm5Kz65L/CHBMbI7EtmKe9fJA7AcXqOU+kGL7dmTh/KgdiPbYvPzG04lMIJ/wb4=@vger.kernel.org
X-Gm-Message-State: AOJu0YyP0jszooy6I+gfmqvMvmSLpnCUu7rOfjckhrCAezMeEakCaFap
	EcJdj0XwgGKkNUnOpQNMMCcBF/R7pKWuowxyXi3+ACkxhnP91RuuFJilP2tukwt93pI=
X-Gm-Gg: ASbGncvvAzG/hsniOxD/HzlQC0slN5Vsl1aGpd+Aappw5OrgCkXbV9eVrTCmscmWtXp
	6xyxi+nYr09p0iKc7jFoXEpieYYc+RUD/rYl49bpak17rvDWrWX0AYkpoIeC45HQuBGTmuBA2m2
	C+iN0nuvYA6CLoGZv8q/Hki3Bcm6ryMBfNvZQ8nWEgt2CH7rzanhU5Y4KRbkx8cQIw7OmqZxu4m
	NpPXALC0wRh9+3hwXunZR4A+THpPa+gotN6Q+7KAtzmjDVofaKudxOWmRjtRcMSrnZTwQO3yvZM
	04qVb1VXXTzi3/vrlgwI4ofeuMboeaQTf1FA/SmhZoievtjrQgMofaZVwBl1qba90xzCXAH9xc5
	/tGnXYs7USqEECAw5kcAJNWYKwFJ/kTykDYaOCqly6DjXJgagTWvrMzxltS9T0lkddTLPP4eWqY
	OuD6NgbDYzTGwSIekx8P+ohQsAIGaX0FFnA4DOLrkoqantXjgqfQ==
X-Google-Smtp-Source: AGHT+IHH5GeVeaqK1SOYHRnV5hnEGg+hDnGH3BWGPiH6VG3b1oQcncz2qQzO9HI9FYrWzz+B7lIX0Q==
X-Received: by 2002:a05:600c:871a:b0:46f:b43a:aeef with SMTP id 5b1f17b1804b1-4711791d923mr96345475e9.38.1761036281808;
        Tue, 21 Oct 2025 01:44:41 -0700 (PDT)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47496c43f68sm11891395e9.5.2025.10.21.01.44.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 21 Oct 2025 01:44:41 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: Chinmay Rath <rathc@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Nicholas Piggin <npiggin@gmail.com>,
	kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@redhat.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 11/11] ppc/spapr: remove deprecated machine pseries-4.2
Date: Tue, 21 Oct 2025 10:43:45 +0200
Message-ID: <20251021084346.73671-12-philmd@linaro.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251021084346.73671-1-philmd@linaro.org>
References: <20251021084346.73671-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harsh Prateek Bora <harshpb@linux.ibm.com>

Remove the pseries-4.2 machine specific logic as had been deprecated and
due for removal now as per policy.

Suggested-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Harsh Prateek Bora <harshpb@linux.ibm.com>
Reviewed-by: Cédric Le Goater <clg@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/hw/ppc/spapr.h |  1 -
 hw/ppc/spapr.c         | 27 ---------------------------
 2 files changed, 28 deletions(-)

diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
index 60d9a8a0377..b9d884745fe 100644
--- a/include/hw/ppc/spapr.h
+++ b/include/hw/ppc/spapr.h
@@ -141,7 +141,6 @@ struct SpaprCapabilities {
 struct SpaprMachineClass {
     MachineClass parent_class;
 
-    hwaddr rma_limit;          /* clamp the RMA to this size */
     bool pre_5_1_assoc_refpoints;
     bool pre_5_2_numa_associativity;
     bool pre_6_2_numa_affinity;
diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
index a06392beff1..b6f151d7468 100644
--- a/hw/ppc/spapr.c
+++ b/hw/ppc/spapr.c
@@ -2729,7 +2729,6 @@ static PCIHostState *spapr_create_default_phb(void)
 static hwaddr spapr_rma_size(SpaprMachineState *spapr, Error **errp)
 {
     MachineState *machine = MACHINE(spapr);
-    SpaprMachineClass *smc = SPAPR_MACHINE_GET_CLASS(spapr);
     hwaddr rma_size = machine->ram_size;
     hwaddr node0_size = spapr_node0_size(machine);
 
@@ -2742,15 +2741,6 @@ static hwaddr spapr_rma_size(SpaprMachineState *spapr, Error **errp)
      */
     rma_size = MIN(rma_size, 1 * TiB);
 
-    /*
-     * Clamp the RMA size based on machine type.  This is for
-     * migration compatibility with older qemu versions, which limited
-     * the RMA size for complicated and mostly bad reasons.
-     */
-    if (smc->rma_limit) {
-        rma_size = MIN(rma_size, smc->rma_limit);
-    }
-
     if (rma_size < MIN_RMA_SLOF) {
         error_setg(errp,
                    "pSeries SLOF firmware requires >= %" HWADDR_PRIx
@@ -4913,23 +4903,6 @@ static void spapr_machine_5_0_class_options(MachineClass *mc)
 
 DEFINE_SPAPR_MACHINE(5, 0);
 
-/*
- * pseries-4.2
- */
-static void spapr_machine_4_2_class_options(MachineClass *mc)
-{
-    SpaprMachineClass *smc = SPAPR_MACHINE_CLASS(mc);
-
-    spapr_machine_5_0_class_options(mc);
-    compat_props_add(mc->compat_props, hw_compat_4_2, hw_compat_4_2_len);
-    smc->default_caps.caps[SPAPR_CAP_CCF_ASSIST] = SPAPR_CAP_OFF;
-    smc->default_caps.caps[SPAPR_CAP_FWNMI] = SPAPR_CAP_OFF;
-    smc->rma_limit = 16 * GiB;
-    mc->nvdimm_supported = false;
-}
-
-DEFINE_SPAPR_MACHINE(4, 2);
-
 static void spapr_machine_register_types(void)
 {
     type_register_static(&spapr_machine_info);
-- 
2.51.0


