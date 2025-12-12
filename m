Return-Path: <kvm+bounces-65837-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 30DB8CB90F1
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 16:09:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C7016309D030
	for <lists+kvm@lfdr.de>; Fri, 12 Dec 2025 15:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBBBF31BC95;
	Fri, 12 Dec 2025 15:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XI9tb+Lr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BCTL8xSF"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF5D31A54F
	for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 15:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551918; cv=none; b=hCsgdLXvxXZLxRMGLHjT5dxCRZiG8nBn2EiuDTSEj+LZJhwoJmmn3tQulZCJQJcW/IZSib2SbGTpZciCXWrLAUQlH2uDhYK3Z21NLlasiYk+e4zQIozhADoTOUBBwB/qVt44TpnvZEKv3lQAjTVKAtvHyA3my4nhh208t3i0R3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551918; c=relaxed/simple;
	bh=wnnU//bn3uu1xbKVPHEmm7hwBL5y4yjun06rt767/BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVJnWwkRiCGD4HcoHpgZigZxZJLpPDkm2HyfpLo2zYZtjfmVZfvgp2pmVkVuysYJ1b7NAfCh7I5qWFrmJdRZfJVNl8GXqXj43GImlvz/vlVZBmaOoBKqAg9JcYpsF8SLHLeOn26EVqIj9wXO8cuItbzuDH7myHRKXXUKEseNYHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XI9tb+Lr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BCTL8xSF; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765551912;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=moaOxubZcgOMwtmXzfQMaVBqmlmt2o6MG1/+E7uthig=;
	b=XI9tb+LrRpITTGSaPDhiN3iEN0jmBf9U17gzDqlE6YbW/fWIZd3H2bEX+MY+lKEE0iKJQ8
	OX0UjYZfhtPkxbYZeosgOzH3MmkMp2J8PlQemqCEUnHQt3ATWkEQsQQuJe1S4CR+Px/au1
	wotLHFq04J8FZDApDKJ2FSyUDpwmjoc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-5cNaMzQUONOL0tJ9gx795w-1; Fri, 12 Dec 2025 10:05:10 -0500
X-MC-Unique: 5cNaMzQUONOL0tJ9gx795w-1
X-Mimecast-MFC-AGG-ID: 5cNaMzQUONOL0tJ9gx795w_1765551909
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-299d221b749so25911335ad.3
        for <kvm@vger.kernel.org>; Fri, 12 Dec 2025 07:05:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765551909; x=1766156709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=moaOxubZcgOMwtmXzfQMaVBqmlmt2o6MG1/+E7uthig=;
        b=BCTL8xSFwP0u4EofXiE3EpZFyb3ywVR1T3Xf3/wjQDRRxw5U9o09w9GVVgGGQfY9Jv
         12uW564qi3WKsufDeq4H/22BfRBDBOTkXzWLWajPVUg/c33sM2T+ZDQKWu0T7rvLsmzl
         en8pKejyozddG+P46H1CLzdbI/jzWjP2z+SCGRi7QnXeFZdkZpa4a0x3sODqg67qPyyt
         +pe+OGdpz252aHhR4i+7MBBLByGDcoutuvqKgeAngAD/AiBsO2TlO6pq1T0hyvmVNfx8
         qPxto22BnMwWdmISWgB9nMHNjOONtyQer9Xt7Tdygdgr/IKrjSVFrW8iKhI3WL9WDKNn
         5VRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765551909; x=1766156709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=moaOxubZcgOMwtmXzfQMaVBqmlmt2o6MG1/+E7uthig=;
        b=j3+3h7ijVsJ8fk0NRgY79HHM3f0qi2BEjDv9E3AmeLhKec1roI7zZ0r4JTDrLjm9gp
         2zGkUXee9cumiZkDUD2ypBwqJZhyo8VaPKS13QJxBX39AOhtelTPNP0SZlST8Wwhelnc
         FMSgcsj6EScFIu4fEvVyERwr/vT1tyMImnLbA+pQnY8e4zIHL3bv4Ow6RDrPHaTIOvdx
         8J3oIzADdLoQmyTfEzluAh7nCTuqJMRZXrxAkqnibmXNiw6B27sRlClhTgb8813vjXJ5
         2FLS8bripwMGTpdjogThIM0X6ndQEo0nnylBiM/uHWFHtBPFZ4NqRU0mzpug46a0DbP5
         L/xQ==
X-Forwarded-Encrypted: i=1; AJvYcCWuQ3kUndBDw/TX84tAFBb284gS8PvhrSmZeOfdRzdXUgGa9Yv6voLjdmDyGCa4uwZpxUY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyMpFIA3dHEcqA7/u1vSaGPM5nzw5n5g+YsS3MdMHHCK5BCDWUV
	m/Q64VjPoFLnBcJedG9rf2c7S4axxARx4wQl5b7pkJs9bMfNtqgkg9kRf2Dab0EkM9kaatcHH8J
	wlO44qBJ6eXay7Ytfu5nj0DP8DStyvBmR/rzIuBU+/P2FwXGHlFAvzw==
X-Gm-Gg: AY/fxX75lLUpak+ejQi68Uz8tlalq4novW6Daq46heFI5/PT+VAMjnP/yc5LBxvJHQZ
	tPzd9L8UOGTZyS2Mm0J+QxR+cJI4fftfE+FCDnSseb/WEB3EiuyYUZ/UIG24y8p4o0+7T67X9fY
	n/OJhr0cmdUohHBYTAnpQD0Iew2sq97RTrBPbU3+8+hbswLHy8XZGlY0D6E9khZ5YJz82hdiOz7
	kuiRwU+IIVBElrZ61UVDzx7jgij6T1sibDUoZhif5ENkSz+4D2xLXC6dJwMsXdAsFnNTMy9opa8
	YgAngIWDOBInBVefjAt3RFXkMXPa6MD/Lal7LQXhWRdjkORoPr5mo/J1Zes47hXW88eMUj/fpI7
	AlSx205+djnCrCpjVoqAuIbqXtIJR7hLBexlbqP35iz0=
X-Received: by 2002:a17:902:ef46:b0:294:f711:baa with SMTP id d9443c01a7336-29f23b13d60mr27391365ad.2.1765551909059;
        Fri, 12 Dec 2025 07:05:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHC3l5KfoTIzBOvCIgz4vOJbuTkx8ffSsBoioMNy7dyeW+kG8f/r8DTTvFFJOZadKbmgFTs8Q==
X-Received: by 2002:a17:902:ef46:b0:294:f711:baa with SMTP id d9443c01a7336-29f23b13d60mr27390725ad.2.1765551908487;
        Fri, 12 Dec 2025 07:05:08 -0800 (PST)
Received: from rhel9-box.lan ([122.172.173.62])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-29ee9d38ad1sm57046655ad.29.2025.12.12.07.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Dec 2025 07:05:08 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: vkuznets@redhat.com,
	kraxel@redhat.com,
	qemu-devel@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org
Subject: [PATCH v1 14/28] i386/tdx: add a pre-vmfd change notifier to reset tdx state
Date: Fri, 12 Dec 2025 20:33:42 +0530
Message-ID: <20251212150359.548787-15-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20251212150359.548787-1-anisinha@redhat.com>
References: <20251212150359.548787-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During reset, when the VM file descriptor is changed, the TDX state needs to be
re-initialized. A pre-VMFD notifier callback is implemented to reset the old
state and free memory before the new state is initialized post VM-fd change.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/tdx.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 1903cc2132..b6fac162bd 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -403,6 +403,32 @@ static void tdx_handle_reset(Object *obj, ResetType type)
     tdx_finalize_vm(NULL, NULL);
 }
 
+/* TDX guest reset will require us to reinitialize some of tdx guest state. */
+static int set_tdx_vm_uninitialized(NotifierWithReturn *notifier,
+                                    void *data, Error** errp)
+{
+    TdxFirmware *fw = &tdx_guest->tdvf;
+
+    if (tdx_guest->initialized) {
+        tdx_guest->initialized = false;
+    }
+
+    g_free(tdx_guest->ram_entries);
+
+    /*
+     * the firmware entries will be parsed again, see
+     * x86_firmware_configure() -> tdx_parse_tdvf()
+     */
+    fw->entries = 0;
+    g_free(fw->entries);
+
+    return 0;
+}
+
+static NotifierWithReturn tdx_vmfd_pre_change_notifier = {
+    .notify = set_tdx_vm_uninitialized,
+};
+
 static Notifier tdx_machine_done_notify = {
     .notify = tdx_finalize_vm,
 };
@@ -753,6 +779,7 @@ static int tdx_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 
     if (!notifier_added) {
         qemu_add_machine_init_done_notifier(&tdx_machine_done_notify);
+        kvm_vmfd_add_pre_change_notifier(&tdx_vmfd_pre_change_notifier);
         notifier_added = true;
     }
     tdx_guest = tdx;
-- 
2.42.0


