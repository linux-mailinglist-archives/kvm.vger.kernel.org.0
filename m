Return-Path: <kvm+bounces-67743-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A74D12C60
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:26:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 642E730240B0
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 767B335A923;
	Mon, 12 Jan 2026 13:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="c2j8GsUQ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="oM7ckuJp"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65FF935B15F
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224249; cv=none; b=lFu0f7kOLs1WzAuaXfY7lslTI3ZlM8RiOxbLsg0ukZQb1UXX03oFsxWvlxfA+o7vlPWnI9XBD/6dfcH+t8fTKcRJjF/FZqpJlsw3FYJej2AWqn/+XFPduceZOjj4qHVqGur3L2aRqLQhRYJ0e9HAONVzsYrUWiKS8bSNl0On6IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224249; c=relaxed/simple;
	bh=JvWFfAXt4aLAWE0AzGPaqLmozoyBwKtrDxcFRmqHf4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+fCEI1//jrWQaqbR81JleqA7PsD7+D6cJ+ffLSuqi8OBZ7xkCyfx1zxvtzmKz/NbUbAodfY/tGxMHjdG1sbN7ICnZ9IyvkbxEiFLz6gLUe0A/GmAo8IljzEcB3UKesCxZsLIHp8M8jx13dAVih3xxKQ6EOvh1VVEUMtCruSHds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=c2j8GsUQ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=oM7ckuJp; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224247;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wfYJ54PW7pNrLwK/eJ6cKC4iLcc2du5UIuKp3Xkn/CI=;
	b=c2j8GsUQmM28DWUTCrkNcic942aNDPJ+zVGkthAD8H4skeYemeyLBGT35+PTpBOrR/7vEn
	potquRJQTw9I7+J9542XvC3jfDHGcjdz20nKHDaAC4j1X7zisCPF9JWr4vNxfJq2aDXed8
	i7JHUaKnt1jifcGSBe4zihY5EBOSGxo=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-lcJrimpwO9Sm_umpmy_qig-1; Mon, 12 Jan 2026 08:24:06 -0500
X-MC-Unique: lcJrimpwO9Sm_umpmy_qig-1
X-Mimecast-MFC-AGG-ID: lcJrimpwO9Sm_umpmy_qig_1768224245
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-c552d1f9eafso4718761a12.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224245; x=1768829045; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wfYJ54PW7pNrLwK/eJ6cKC4iLcc2du5UIuKp3Xkn/CI=;
        b=oM7ckuJp/L2WR6YiwFTBn5VNdxX0tBr/Q90pQt1tkOcc6mRtHaIKLsKVVqKYJxauiU
         OnoW4eGN2ZuCbLBkRbgI5OBWkLKt9uv7t3mjGG/bBeRHe2+mWQ21PhUnwEnuBiLFQ8QR
         L5EqB5ZruYBCaVirRCj0z0A2fHCj0BpzHSBDiulJGX7izOef2Skfy7ERnRWqXRktyjbB
         GINshQzFQI7s7Z+pQQ3qWiDogf47Zlb9sob1BaVdYr8oRU/8hvjNk/s7jOwArmpV4duf
         jjqu4JQGf59jN1I2sSlKLoD2D/ER6zLm0d7iRUKMui7p4mfNv0FbMmg3ksJeiYcnFoTm
         ZNYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224245; x=1768829045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wfYJ54PW7pNrLwK/eJ6cKC4iLcc2du5UIuKp3Xkn/CI=;
        b=iLEY3b6cggsFt1nxKnBcbBFVn3G2u3ITSXzQ+woOsJAH8KiSljY347xwlblHPxdZbS
         h9Ea0+tYVMECzqfQozTFjeKcdnppe5CVNLdf6FjuyGaaLd5TDZTQIPvYKiEjEkIQU/Bz
         adoxk4mqlS/zKJcVEpxHoKhCw1j6333y6hVESC6UnHW/FCaojBQDhV9JefeLOrU3nTha
         WWDYq0t56ui0AMFTeUF9BMQabB6mhFO6Qc5KIWjMWsoougGqqcipgB1qSzdeAZY7dAbE
         bDaUsdl7t2Epo3CDk7tMzjEL8qZac++igavKPmybFt4EuFdvIW4EV6fhDHIaQKcjUi1H
         JaNA==
X-Forwarded-Encrypted: i=1; AJvYcCVyMSy64dm/J1Fed2EhrIaRCb3AfLrqAwVFUvLajZiv6MYr7uapH+iwP+JPmP1d5+I7+sA=@vger.kernel.org
X-Gm-Message-State: AOJu0YxVO4SRgU1nfjKfZ0+dkgp5wW+Bj0IT/wI2nRln4nAQp4H6szW/
	/evidYKlf1IQe3cp9k0ZNgaIX58W1jqAfBrt2HgwAMoHQ/HpLGTlSxJmx5jSqedvJY5qBwxQTSc
	0e9yhdNwbQHqz2CsnigKKAx/QDRseuTJYncYdsDX/P6Ez3agO7DScBg==
X-Gm-Gg: AY/fxX476d4CHXfEnr8cUrm0+bVoPgnujTk8KGO8KLCF7NG+XgSECiX+OZ5nhkCTelt
	ISTIXkqmq/EZjhsDy0TW0J8f2Zh+ecleXvNf2BjCw1rCi+SivN1f/IQ93iJ3WKd1rU+Znzpobdg
	/oGoIhDxy1tWZ/w8TWz4ntIz6fS4GvTXXvx4dmcHzB4zmQrmxwE4vBhAFO1mAXgr0xdUrUdIzxc
	Dfx7ci9Mr+qet+iBiElFPCcZi97132d/7a1U3syE5ld02LNpuVf0pdBU7TObj+NcydWQEFbr02Y
	5SywdU0M0FFz50KrbzeBDHrhQYUHseX+gruts4EdvBE4aJi+LbcZXKc8R06pbwpD72pSLIo+bLj
	CdF9kXmnKn1K8SoTu88VAnlSgerT1b5HdQc1lrAZh6Yc=
X-Received: by 2002:a05:6a21:999c:b0:389:8e40:a13a with SMTP id adf61e73a8af0-3898f997771mr17078807637.52.1768224245216;
        Mon, 12 Jan 2026 05:24:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH0M9fBY78q5fVf662RSaHGPAIXPHYNm4v5HjXRd4PiEkcc2Xs4274yy5o7YPnuQ5jB86LeyQ==
X-Received: by 2002:a05:6a21:999c:b0:389:8e40:a13a with SMTP id adf61e73a8af0-3898f997771mr17078790637.52.1768224244802;
        Mon, 12 Jan 2026 05:24:04 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:24:04 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 15/32] i386/tdx: add a pre-vmfd change notifier to reset tdx state
Date: Mon, 12 Jan 2026 18:52:28 +0530
Message-ID: <20260112132259.76855-16-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260112132259.76855-1-anisinha@redhat.com>
References: <20260112132259.76855-1-anisinha@redhat.com>
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
index cba07785f7..314d316b7c 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -405,6 +405,32 @@ static void tdx_handle_reset(Object *obj, ResetType type)
     trace_tdx_handle_reset();
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
 /*
  * Some CPUID bits change from fixed1 to configurable bits when TDX module
  * supports TDX_FEATURES0.VE_REDUCTION. e.g., MCA/MCE/MTRR/CORE_CAPABILITY.
@@ -1549,6 +1575,7 @@ static void tdx_guest_init(Object *obj)
 
     tdx->event_notify_vector = -1;
     tdx->event_notify_apicid = -1;
+    kvm_vmfd_add_pre_change_notifier(&tdx_vmfd_pre_change_notifier);
     qemu_register_resettable(obj);
 }
 
-- 
2.42.0


