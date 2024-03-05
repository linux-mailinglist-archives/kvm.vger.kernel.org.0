Return-Path: <kvm+bounces-11001-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 47DBF8720A4
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 14:44:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id CBAF9B28DA1
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 13:44:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 496E28612C;
	Tue,  5 Mar 2024 13:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="i20ngomX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12EA5676A
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 13:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709646267; cv=none; b=MnuMKWosIkWI6FrET2HuwFQ6Vu2QM9YvEYesmpYpK7t8Kxi+DIcRlY9oBmRZ0zikqSfam6DwraozTacuN055HCLlOyHEtRAogVWXSFjv86CpE30LKj7nuaA5pabxh5UE8SFxU8cBH96Z+pC64bQFVGGx0tMM+6Q5D93Lu9qdsmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709646267; c=relaxed/simple;
	bh=TS1qfUsbr3zr5dyF4FoePeYWk8hvJqJ2MfqoEW14ktM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mcwvvv3/0ZvAXs2mJPJEECcyRSOgUuMrRgV9Rk5s3FGg+3hbsbcY7t1zXnIKkQBf/2oQIYc3YFzxmTEdnchCkIYAagO9kBX+bKiQqcTrNxD9ekOFSKDxiqkCEgiw6D8LX4NdCwbtuwSMkD+FZngoKURYZfxUHm/Y7KGRlxrgBBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=i20ngomX; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-33e383546c1so1121055f8f.2
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 05:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709646264; x=1710251064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gi5x0OedtFiXYvl8cpQZIwBhtQ9Cn2QNkroxyToz+PA=;
        b=i20ngomXMzagJ00YFIdWwSmZue9laFHoMtg8FAcsojoZNFhQiCkdbzn6QF9shPuFHB
         QxZvzQt4jymV8YkhoZtXPw0DGOT3lBMQlWrkeFw7Xcuq5VY8s01PbmSCm6DYidTECceM
         T2luM3wWCJfhpxSjOjg9SI6kFAfDF+2+vhqzStvZPb3yLk31zN0Ug7bD21tzTJyHA2Lw
         ubwRWUqwbzBbvntJ3hzS7K/t4iZofh9BHCQkDcZ3hXc+EzhRKYjmtQiLFwa6eEFNP53n
         Pn8ZF+QNvW0FyK98Bl9o+iZQ5Eou4ZKeKTASMTtxMOZBjKa6nMCPFGE9MhBgtSoYm6VJ
         Gbgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709646264; x=1710251064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gi5x0OedtFiXYvl8cpQZIwBhtQ9Cn2QNkroxyToz+PA=;
        b=Lo7wPTaiIvJxI5qdGf2qLbagpFtTo+49iMS5ghl88ifCK5rhEEAV68p/i0dgezIyB8
         WnrMovQRnwoHAdhONsnQVSO7QoC01jLj3uHJcRpU3QRuxjkq6wOCgx8btt+WjX+Wu/zP
         WVxEscggMrwwfh9kCbMl1pKUotyzAlKM78rGVHTcMeKVfJ1AdyglOChY0lPMP2XVbzGf
         1ALqTBoT682Y3eidJmO8G78/mzyqa1lAgOjDYUAn91et+79DG6FpOWqBNbOyFqz3JpyN
         UXEUm+VNUB+5WdSYXy5esdbokkM/qs7rd7q85awq/D02hcEzyq0pAZleTzge2h2sPx+c
         lE0g==
X-Forwarded-Encrypted: i=1; AJvYcCUGV5GTt/yh72PT2jBTX77svmtcOCHwbaVvE+1zqlZjvsUeesKXYQ5u6l+sc1bJiqv6Al0wUC+rVedX/9e87bFXQdUi
X-Gm-Message-State: AOJu0YwwBCT5fUK1LaEk/rdnhI9S4s73EBhu3MJ5kcNerpKbR76RX948
	iIxcoqT/2UoSaxlEZu91JAJJgC9Y8dLTLj1pW7i1yEpf3ak1Ow+rCFkTrTKtxQ8=
X-Google-Smtp-Source: AGHT+IHolUnDHiaXONGNAEjHyoMbR0Z74o7ujBdQRH+ENiyhFcejbpl2YfJKfWkYeS75WpUtG+BnoQ==
X-Received: by 2002:adf:e5c5:0:b0:33d:274b:ffc7 with SMTP id a5-20020adfe5c5000000b0033d274bffc7mr9419456wrn.46.1709646264430;
        Tue, 05 Mar 2024 05:44:24 -0800 (PST)
Received: from m1x-phil.lan ([176.176.177.70])
        by smtp.gmail.com with ESMTPSA id v13-20020adfd04d000000b0033d202abf01sm14937659wrh.28.2024.03.05.05.44.22
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 05 Mar 2024 05:44:24 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org,
	Thomas Huth <thuth@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	devel@lists.libvirt.org,
	David Hildenbrand <david@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH-for-9.1 17/18] target/i386: Remove X86CPU::kvm_no_smi_migration field
Date: Tue,  5 Mar 2024 14:42:19 +0100
Message-ID: <20240305134221.30924-18-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20240305134221.30924-1-philmd@linaro.org>
References: <20240305134221.30924-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

X86CPU::kvm_no_smi_migration was only used by the
pc-i440fx-2.3 machine, which got removed. Remove it
and simplify kvm_put_vcpu_events().

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 target/i386/cpu.h     | 3 ---
 target/i386/cpu.c     | 2 --
 target/i386/kvm/kvm.c | 6 ------
 3 files changed, 11 deletions(-)

diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 952174bb6f..bdc640e844 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2018,9 +2018,6 @@ struct ArchCPU {
     /* if set, limit maximum value for phys_bits when host_phys_bits is true */
     uint8_t host_phys_bits_limit;
 
-    /* Stop SMI delivery for migration compatibility with old machines */
-    bool kvm_no_smi_migration;
-
     /* Forcefully disable KVM PV features not exposed in guest CPUIDs */
     bool kvm_pv_enforce_cpuid;
 
diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 2666ef3808..0e3ad8db2b 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -7905,8 +7905,6 @@ static Property x86_cpu_properties[] = {
     DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, true),
     DEFINE_PROP_BOOL("lmce", X86CPU, enable_lmce, false),
     DEFINE_PROP_BOOL("l3-cache", X86CPU, enable_l3_cache, true),
-    DEFINE_PROP_BOOL("kvm-no-smi-migration", X86CPU, kvm_no_smi_migration,
-                     false),
     DEFINE_PROP_BOOL("kvm-pv-enforce-cpuid", X86CPU, kvm_pv_enforce_cpuid,
                      false),
     DEFINE_PROP_BOOL("vmware-cpuid-freq", X86CPU, vmware_cpuid_freq, true),
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 42970ab046..571cbbf1fc 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -4344,12 +4344,6 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
             events.smi.pending = 0;
             events.smi.latched_init = 0;
         }
-        /* Stop SMI delivery on old machine types to avoid a reboot
-         * on an inward migration of an old VM.
-         */
-        if (!cpu->kvm_no_smi_migration) {
-            events.flags |= KVM_VCPUEVENT_VALID_SMM;
-        }
     }
 
     if (level >= KVM_PUT_RESET_STATE) {
-- 
2.41.0


