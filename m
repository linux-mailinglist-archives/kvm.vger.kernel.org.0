Return-Path: <kvm+bounces-25719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EEDD96965E
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 10:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 085551F24BDA
	for <lists+kvm@lfdr.de>; Tue,  3 Sep 2024 08:00:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81493200133;
	Tue,  3 Sep 2024 08:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XjQUp6ql"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13191AB6C3
	for <kvm@vger.kernel.org>; Tue,  3 Sep 2024 08:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725350421; cv=none; b=ZjMwGeWuzjvfY280SZq0DBkFFn2o7/ZNt/C3+Sf8fPBy0TiE4GL12zRm4m3jnr/+/hPTpibsZWjd+k/WoDB2wBTIDv/XT1HYNnshReldTMXNyc6lX6IXs1qlQ71621IOuvHjdKtzi6G+dPbqH1XV4s0vyNoATBs9T9eVCdmpn8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725350421; c=relaxed/simple;
	bh=X/ybF8of5ZWw6NonSsxmmRBddtuOKe/CozbIFrk9nTE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JcuwyYZwpKa8b7Vz6D3aftrbqDFzoUy/FK6o7uh2I8Olw4+3qvoN4D1h6MWUSWaQVkYj/n4IIeHdyRfJG3gjU/bYF6hZrTU1hD2ejuSCeqyiufibDCJRmZ4c22bo5RVoJP+BndKGP5gB0yktp6kfssvLZns3Roc3za2EUCP1QtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XjQUp6ql; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725350418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=g9gMF5nZosX4YpZl1BMI7RIZtJmjwIKTODTm+IlxJgU=;
	b=XjQUp6qlmNFX2BnDUjDJks+RLlE9RPFD6CU4dmerU/HbY41Ip3VHRFXIG9bJyP4di9S+6/
	yVvGi2vup2bap+eJGy/yF+RZAFf3DqwIbiDFiQSSjM9jEZVsvpFaBCIqEXJgwlX91N0K6q
	jOHDYvt2+fkeIa1FZnk0q5U1CMH2hog=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-TRCzLp2PNMqfTgp5E0T6Uw-1; Tue, 03 Sep 2024 04:00:17 -0400
X-MC-Unique: TRCzLp2PNMqfTgp5E0T6Uw-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2d8b7c662ccso2613213a91.0
        for <kvm@vger.kernel.org>; Tue, 03 Sep 2024 01:00:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725350415; x=1725955215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g9gMF5nZosX4YpZl1BMI7RIZtJmjwIKTODTm+IlxJgU=;
        b=EMhN9Nxcoygf1PLuO3GoElfPWQTLtdSYArQ1bkOm/c0ww8lx3z9mW+BUb0g/5mOqgp
         D67y74FpItnS0QFFVlft1EA8GY8IHwydxme3bXezzGyG0gTZ2rvTaUpasb+5mh1YjLm5
         +pFdEulGceSRBARuhGJVn3dxiEnPG4VgYn2YHhn3NK5vEzUC2gTdf8XWFd2K2SOZX1dv
         WYXDYi0W7t324/73VlOzEjFBIq6yNNj1ZMd1AKIDr2STjXj7gOHvyjoDOWeVJRZuk5ON
         6HEc7iPRSYss54jPKhSScxyOQh2SBsZg1VEb6vG5XfWAOKkEhGhwY3uuP37fe+BZFRdm
         m+CA==
X-Forwarded-Encrypted: i=1; AJvYcCXv/5p0LxdobgsuFgN7ujA5SE5wBhrDSUWGSR9eo4MdXfgWW2msvdz8rJNuisGvjjA1XoU=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJDKm3hvVe0GJl3JLHS1HJ5D0ap2J9cnPtugxKDYziHv/9TPgl
	hZJKCCn5A3bdw+YzhvZuva2zk3GGP+ms1kJzkSaWGcCDyFGrqGJAZIv8pIpKu7FO7tao9/p29LR
	HhsN2QRvOPiO1XO5WwY7fN2eKN8p82cZO/vT0WXK6LuOrW16BaTIUyXkpAAE5
X-Received: by 2002:a17:90a:1c17:b0:2c9:6f06:8005 with SMTP id 98e67ed59e1d1-2d856383fdemr18245907a91.26.1725350415409;
        Tue, 03 Sep 2024 01:00:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFgp3jyb0JRyqdYlU153uTlOouysm2/8u5v4zt+2XiMXPK739+XzYYL6QlH7ASSM6+7XmH0JA==
X-Received: by 2002:a17:90a:1c17:b0:2c9:6f06:8005 with SMTP id 98e67ed59e1d1-2d856383fdemr18245877a91.26.1725350415002;
        Tue, 03 Sep 2024 01:00:15 -0700 (PDT)
Received: from localhost.localdomain ([115.96.207.26])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2d8edadf788sm2998821a91.15.2024.09.03.01.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 01:00:14 -0700 (PDT)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2] kvm/i386: fix return values of is_host_cpu_intel()
Date: Tue,  3 Sep 2024 13:30:04 +0530
Message-ID: <20240903080004.33746-1-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

is_host_cpu_intel() should return TRUE if the host cpu in Intel based, otherwise
it should return FALSE. Currently, it returns zero (FALSE) when the host CPU
is INTEL and non-zero otherwise. Fix the function so that it agrees more with
the semantics. Adjust the calling logic accordingly. RAPL needs Intel host cpus.
If the host CPU is not Intel baseed, we should report error.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c         | 2 +-
 target/i386/kvm/vmsr_energy.c | 4 ++--
 target/i386/kvm/vmsr_energy.h | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)
 
changelog:
v2: fix comparison logic in is_host_cpu_intel so that it returns
boolean TRUE for Intel host CPU and false otherwise.

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 11c7619bfd..503e8d956e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -2898,7 +2898,7 @@ static int kvm_msr_energy_thread_init(KVMState *s, MachineState *ms)
      * 1. Host cpu must be Intel cpu
      * 2. RAPL must be enabled on the Host
      */
-    if (is_host_cpu_intel()) {
+    if (!is_host_cpu_intel()) {
         error_report("The RAPL feature can only be enabled on hosts\
                       with Intel CPU models");
         ret = 1;
diff --git a/target/i386/kvm/vmsr_energy.c b/target/i386/kvm/vmsr_energy.c
index 7e064c5aef..ce7eecb02d 100644
--- a/target/i386/kvm/vmsr_energy.c
+++ b/target/i386/kvm/vmsr_energy.c
@@ -27,14 +27,14 @@ char *vmsr_compute_default_paths(void)
     return g_build_filename(state, "run", "qemu-vmsr-helper.sock", NULL);
 }
 
-bool is_host_cpu_intel(void)
+gboolean is_host_cpu_intel(void)
 {
     int family, model, stepping;
     char vendor[CPUID_VENDOR_SZ + 1];
 
     host_cpu_vendor_fms(vendor, &family, &model, &stepping);
 
-    return strcmp(vendor, CPUID_VENDOR_INTEL);
+    return g_str_equal(vendor, CPUID_VENDOR_INTEL);
 }
 
 int is_rapl_enabled(void)
diff --git a/target/i386/kvm/vmsr_energy.h b/target/i386/kvm/vmsr_energy.h
index 16cc1f4814..97045986b7 100644
--- a/target/i386/kvm/vmsr_energy.h
+++ b/target/i386/kvm/vmsr_energy.h
@@ -94,6 +94,6 @@ double vmsr_get_ratio(uint64_t e_delta,
                       unsigned long long delta_ticks,
                       unsigned int maxticks);
 void vmsr_init_topo_info(X86CPUTopoInfo *topo_info, const MachineState *ms);
-bool is_host_cpu_intel(void);
+gboolean is_host_cpu_intel(void);
 int is_rapl_enabled(void);
 #endif /* VMSR_ENERGY_H */
-- 
2.42.0


