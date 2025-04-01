Return-Path: <kvm+bounces-42384-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 94D3DA78121
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 19:09:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BC9F188E528
	for <lists+kvm@lfdr.de>; Tue,  1 Apr 2025 17:08:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51427213240;
	Tue,  1 Apr 2025 17:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dYNLkqgL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE9D20E005
	for <kvm@vger.kernel.org>; Tue,  1 Apr 2025 17:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743527182; cv=none; b=IOOPMIvui9K1jaePrOZRcKvMBqFLin14HPophRLfUGRu/L/CV42H48L0B5AnHH5NdjXRJrKDlOsZK7Ulm4U+78/de3mlMkXlIZ4Gz35quDJeqagpV8X+JI4DXavAv5xiZ07yTqlJBrbadQHd7ZezKkL+zb7Zrw+NTPFLVim6Xas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743527182; c=relaxed/simple;
	bh=oa79efjOKM9SRXURi1BaVT0pmfHaFaEt9V3KsZ4Q6nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5rLFYq2c1GAFL5f8xUXHx0EGZd5bXuDsqq2nCFFZR/qKZFoajAWyWTqSMfxPg6ueH1wwXOw2KWv/j6gPXGxIyDeRFBDRLCFXxovQgxfyNCYwcwlKo3dwidnvU1jjLqeG1GNmJbAcC/ok2gLqIkG1EmvPwjzY93dr6rvCaIDHY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dYNLkqgL; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-22548a28d0cso156830345ad.3
        for <kvm@vger.kernel.org>; Tue, 01 Apr 2025 10:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743527180; x=1744131980; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FqoSwIUEkmAFZzDF1jp7biKBQ9RqCAjci7v8QaNjgL0=;
        b=dYNLkqgLxq6iyQGBDVRkVtH11w/to2SlOE4LjkFa9YMY9w/Q+7u4mdfgUurxElZg24
         C+bHTIBXupOpRBsuJbRN+JrkjJKdpYQR3oUrMXyIoFBfjMSJ31POn3UYBrS0pvMZmy3/
         keuAky+yxse1HhUyhwkQ6OSr2kNkxRP++ezZ/yyHb2VU2HovF+0n65gNUDwfoC2KBs12
         VZOihX5hrVMJQi6ZLxU33VbXc3DFeHTz2jzFUy2ZHhO3X65vYxZOu7Ut4TxJQIjOvwMm
         h2YqPDKUsbQEKwfFZV2r7aFU3SjTfhRvjgBBHF9MuEYWn9Jb5VR2iddntlyTmyz5WR/G
         1YtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743527180; x=1744131980;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FqoSwIUEkmAFZzDF1jp7biKBQ9RqCAjci7v8QaNjgL0=;
        b=at0mhmDVAsV6yknoDoVKOZpwherOK4loC+JveGgJ5r6SC4Kea8hP2qNR58sr8QIlV0
         MGeJnHvqKJjoo3B+urBOem7VhZ2DKW/8HcCsNpYivAc6vaAi7qIo2xoSeM/O4PosTckp
         htfWjti7/AFBXV37VX3JyeQQmUxFEQ1ighJr/7CQNYmHe+o341qtki0wM//dhfbaObUo
         OGoJvvq6Ix1b4/S20bNmqGXqj35E0JIqu96VMDieYR9v/+YdliGfThb74/s96alg4sNK
         yreqdUrEsrwqCiMA/wM0hthPDkWvuDngUf1b7kXEpdoNilca4p5mn9NspU2wnQBY97IC
         /iyA==
X-Forwarded-Encrypted: i=1; AJvYcCUu3R4JGUJjWU0mYvkyEIOUKW+PSqqGcf69FRUvuJiBVw0bH81KiUssp5m1kHqz9MCchzc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyApdnX/5AiyABK3KFcow20Y8Q1vrUWStYAln2gvl65oziau7+5
	kCC2bAb3n5jocJHk8CfSs0vywND72NcQRxlpOcf/RLrf6WoO0nXwB3t5AA==
X-Gm-Gg: ASbGncuFFtBFZT5Z7/MhJU6aVX9vBywAxsbpmyHf2OlA+L+0VTBLCNmyVAnIlVNNW6o
	gX26MVoL2o7Y/soiV5zmdF4uBBcPMG6a/Aj0/oDWCny/uEpfIPdVc2OR0b6/qoRwZeT6VWsY2HH
	YA/mnTG5wOKe+S3ZEyyleL8fmzSH6tl3LpH2SpDMWcJFhkDKmEYLoX3QXylf1iCaU9G93JCdm62
	Cd/1yl18cjnZWDZHR0Z+oR8I+qrdjtRjMCxCp1FOcKN2BK9oyfaYuvcK6+XPWzhP0j8DLVbnp6e
	bnUR1mvyUW7pLYx2bYzj5yO0Ms3Nrc6mT6CM97W8
X-Google-Smtp-Source: AGHT+IHMLcW/UgSU+B9QLYjzegvhSUSQLiYd7WdSUYNTNPJYM4iVdsXCx+9AUOlAl0q1OhIHYB2AXw==
X-Received: by 2002:a17:902:f544:b0:21f:6bda:e492 with SMTP id d9443c01a7336-2292f9ee9e8mr226767855ad.35.1743527180233;
        Tue, 01 Apr 2025 10:06:20 -0700 (PDT)
Received: from raj.. ([103.48.69.244])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7398cd1cc3dsm5902926b3a.80.2025.04.01.10.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 10:06:19 -0700 (PDT)
From: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
To: kvmarm@lists.linux.dev,
	op-tee@lists.trustedfirmware.org,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	jens.wiklander@linaro.org,
	sumit.garg@kernel.org,
	mark.rutland@arm.com,
	lpieralisi@kernel.org,
	sudeep.holla@arm.com,
	pbonzini@redhat.com,
	praan@google.com,
	Yuvraj Sakshith <yuvraj.kernel@gmail.com>
Subject: [RFC PATCH 5/7] tee: optee: Add OPTEE_SMC_VM_CREATED and OPTEE_SMC_VM_DESTROYED
Date: Tue,  1 Apr 2025 22:35:25 +0530
Message-ID: <20250401170527.344092-6-yuvraj.kernel@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
References: <20250401170527.344092-1-yuvraj.kernel@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

OP-TEE when compiled with NS-Virtualization support expects NS-Hypervisor
to notify events such as guest creation and destruction through SMCs.

This change adds two macros OPTEE_SMC_VM_CREATED and OPTEE_SMC_VM_DESTROYED.

Signed-off-by: Yuvraj Sakshith <yuvraj.kernel@gmail.com>
---
 drivers/tee/optee/optee_smc.h | 53 +++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/tee/optee/optee_smc.h b/drivers/tee/optee/optee_smc.h
index 879426300821..988539b2407b 100644
--- a/drivers/tee/optee/optee_smc.h
+++ b/drivers/tee/optee/optee_smc.h
@@ -452,6 +452,59 @@ struct optee_smc_disable_shm_cache_result {
 /* See OPTEE_SMC_CALL_WITH_REGD_ARG above */
 #define OPTEE_SMC_FUNCID_CALL_WITH_REGD_ARG	19
 
+/*
+ * Inform OP-TEE about a new virtual machine
+ *
+ * Hypervisor issues this call during virtual machine (guest) creation.
+ * OP-TEE records client id of new virtual machine and prepares
+ * to receive requests from it. This call is available only if OP-TEE
+ * was built with virtualization support.
+ *
+ * Call requests usage:
+ * a0	SMC Function ID, OPTEE_SMC_VM_CREATED
+ * a1	Hypervisor Client ID of newly created virtual machine
+ * a2-6 Not used
+ * a7	Hypervisor Client ID register. Must be 0, because only hypervisor
+ *      can issue this call
+ *
+ * Normal return register usage:
+ * a0	OPTEE_SMC_RETURN_OK
+ * a1-7	Preserved
+ *
+ * Error return:
+ * a0	OPTEE_SMC_RETURN_ENOTAVAIL	OP-TEE have no resources for
+ *					another VM
+ * a1-7	Preserved
+ *
+ */
+#define OPTEE_SMC_FUNCID_VM_CREATED		13
+#define OPTEE_SMC_VM_CREATED \
+	OPTEE_SMC_FAST_CALL_VAL(OPTEE_SMC_FUNCID_VM_CREATED)
+
+/*
+ * Inform OP-TEE about shutdown of a virtual machine
+ *
+ * Hypervisor issues this call during virtual machine (guest) destruction.
+ * OP-TEE will clean up all resources associated with this VM. This call is
+ * available only if OP-TEE was built with virtualization support.
+ *
+ * Call requests usage:
+ * a0	SMC Function ID, OPTEE_SMC_VM_DESTROYED
+ * a1	Hypervisor Client ID of virtual machine being shut down
+ * a2-6 Not used
+ * a7	Hypervisor Client ID register. Must be 0, because only hypervisor
+ *      can issue this call
+ *
+ * Normal return register usage:
+ * a0	OPTEE_SMC_RETURN_OK
+ * a1-7	Preserved
+ *
+ */
+
+#define OPTEE_SMC_FUNCID_VM_DESTROYED	14
+#define OPTEE_SMC_VM_DESTROYED \
+	OPTEE_SMC_FAST_CALL_VAL(OPTEE_SMC_FUNCID_VM_DESTROYED)
+
 /*
  * Resume from RPC (for example after processing a foreign interrupt)
  *
-- 
2.43.0


