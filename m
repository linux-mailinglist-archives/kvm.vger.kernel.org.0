Return-Path: <kvm+bounces-71761-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YMBrGelxnml0VQQAu9opvQ
	(envelope-from <kvm+bounces-71761-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:52:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D39F8191560
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 04:52:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id AA9E130F59F8
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 03:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 449F1257845;
	Wed, 25 Feb 2026 03:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eIUX1RAs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="QrKi4kAG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A08879CD
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 03:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771991473; cv=none; b=Rb31aGastqBOy2rCXxo6tvL4mR+2akp99c3OwRBcVlFsSVwergSRQU5H360E86OoMtKRhCL9JSUepRFBX+WtS+wale8z5CCl/ECucGDh6LgYFpFPqkEZwDWELAmLYIOE1nSDTAybTWdO5WAzgpb+9AL0eh3k+hXKAz+MQH0gcOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771991473; c=relaxed/simple;
	bh=mYHykGSeRol6qPb0O2RCz5WVhoAbFlEQQPuIWA8vy2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kwZXci7wHR89uXRS5QlD1b6ztFYo82qYgzY3rjHfisNVMnLYXX0+NQIJ0tzFTp1USIJeJWFNcDsB0D9i+M2G/o85fTcnvkE4SUyUk+0TZ6ktxzBhHGCZ0cUNNUTUbta2+90hH/ZvgQYs61j8JxlQN1qWGnIyDk2Px1BCpehpJk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eIUX1RAs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=QrKi4kAG; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771991471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
	b=eIUX1RAsPMQzLuBgKcqe3gwRzcabsHXq8yM+NEWLQaCOT8+ztuHHK7QuZ8xDdf98SJ7Y7y
	ipEGkjtYl3kbQ8BdAt3CPs8Ur8YNvk7zTcryTjoj06O/IwajsC3oXThlzVwf28fMP0OqMM
	XXFLOz1Qx9GP5eJKdcu3X2hfGz+xRd4=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-629-U9AzsiCZPHWSoV5W7jx09g-1; Tue, 24 Feb 2026 22:51:09 -0500
X-MC-Unique: U9AzsiCZPHWSoV5W7jx09g-1
X-Mimecast-MFC-AGG-ID: U9AzsiCZPHWSoV5W7jx09g_1771991469
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-354c7febaefso26524839a91.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 19:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771991468; x=1772596268; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
        b=QrKi4kAGik1i2T8qoKfcrOEFALfkl3El4nWBbFOyFAMuCo5ETWvDbHnNLRwVQ8FRWx
         kYBJmbZSAXcPtqI3A4nz2tWhfjJngSuFmAFxHvoxt515djdV+K9OtU0R4Bm2PzQMnDDf
         nGDaVM445zGFexfCOjF2pL3LJ6Qp8P3RSy66j6m5Yz1kZUWIGfuKZH6HPjQ4mxJTNwE1
         hNB87Z2Xi5tBe618bo3yK8WEErA1AtnzOT0ASFEpFVwlHqoJjw73aJWfvAqh6K8Lsnxk
         Bm+BhsgXE9m/ciWGvFmHNwEzj/KoyuIoNKsqLi64oeHDx9NqPsE7VUPnbUSWqF0aJllN
         OV/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771991468; x=1772596268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bPhZf11AJ6OznTneTjtivFAiVtwbcW8pDml41uWPO3Y=;
        b=L4DKPAIsiB+0o47z7cpqea5JwnqCcZ3aiAkpDOaQS4+9C4mTuKXZocE1Gk3mbgjWMZ
         LuQ1fpSdOZi0Zkz9UupVgjhj1ydq79RSoQ7lu6/FbzsgD5HF1Y0EMmbddRDjE4C+iqed
         8BudXzcyY73+hHKBrT4CNrgPqmkF6ON/4GwaoQx/BZ1XO+cecMKviGOtCq4tRxpB3h7l
         Yq1cHYqBPiUjkAiEoD/k+zSegq9z4QlSHECLv7iah+9r7JhUW64KAZ7YJ3xbh5Ws6du3
         lzBpU8Q8SBvZ2HHRxpcmXZIxUwB/+bgPqN4VtdqbXBDBHh2EbVBkV2dsNJu5+QC+MmsT
         YmNw==
X-Forwarded-Encrypted: i=1; AJvYcCWtKz/6AgUivYCiuzvM6RuyrkEwMEhOUn+duKczwJlgDAFG9XtywkEDT6t4noHqrxwpOCI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzbHb/cvHx1YnQzRoE9rqYH5iqDYN3dtB5oxjJmczJgbUJbqarH
	jfz+VceBz6KcYP0RJTCLBlsx//5vOu9BoMMe0xKNwhRvB9v9dnDxhyAysgdbA2wVFzyL8jAxXyh
	oyHrqjoETzZBZXoBlppVHnxW87f///0nn8f30qWa0dLM0X7tnH8ZZuhvlOj2lbw==
X-Gm-Gg: ATEYQzymSFw2cK6eb5HxFyuZgReUIeum1fPMuMv+Yn227+FUjhANq8dusdjEjdC73c6
	xeMpplGyx1MPn35XCJ+WdE7QsKa2gnOf6OfuOIAabS+dkivZb65z4GVO+taGisdn8rZHb+eRpyA
	qDXDIxz6CK9lqeBEieoLps/Nv+0i8Hh6WDXZPZzJ5ee18pqkKvoWDMZn1ZNqRq+u670AWzOnNtN
	PAZ9hGALv2iiJEItuu0ZRTZCI0to5DgpcRTPpwKEflJD0D+ytV8BbQ/rdb7mZgjXwFQ22JoTRjQ
	8XOohLhoFR28PmfEaZO3QpQcrn7KQhjPc6QXVZNivvdQ9UVFV1uLmaS9hIV8xAGCEjm6MeFVj+g
	/pvKeohyGKjCvKcSdRHe/r8k4JRiIFZmshmmhfXB4Jd38vnHsS5z3ioQ=
X-Received: by 2002:a17:90b:5687:b0:33b:be31:8194 with SMTP id 98e67ed59e1d1-358ae902e84mr11052152a91.34.1771991468535;
        Tue, 24 Feb 2026 19:51:08 -0800 (PST)
X-Received: by 2002:a17:90b:5687:b0:33b:be31:8194 with SMTP id 98e67ed59e1d1-358ae902e84mr11052135a91.34.1771991468243;
        Tue, 24 Feb 2026 19:51:08 -0800 (PST)
Received: from rhel9-box.lan ([122.176.129.56])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-359018838b2sm1186006a91.5.2026.02.24.19.51.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 19:51:07 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	ani@anisinha.ca,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v6 18/35] i386/tdx: add a pre-vmfd change notifier to reset tdx state
Date: Wed, 25 Feb 2026 09:19:23 +0530
Message-ID: <20260225035000.385950-19-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260225035000.385950-1-anisinha@redhat.com>
References: <20260225035000.385950-1-anisinha@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[redhat.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71761-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[6];
	RCPT_COUNT_SEVEN(0.00)[7];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: D39F8191560
X-Rspamd-Action: no action

During reset, when the VM file descriptor is changed, the TDX state needs to be
re-initialized. A notifier callback is implemented to reset the old
state and free memory before the new state is initialized post VM file
descriptor change.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/tdx.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
index 37e91d95e1..4cae99c281 100644
--- a/target/i386/kvm/tdx.c
+++ b/target/i386/kvm/tdx.c
@@ -405,6 +405,36 @@ static void tdx_handle_reset(Object *obj, ResetType type)
     trace_tdx_handle_reset();
 }
 
+/* TDX guest reset will require us to reinitialize some of tdx guest state. */
+static int set_tdx_vm_uninitialized(NotifierWithReturn *notifier,
+                                    void *data, Error** errp)
+{
+    TdxFirmware *fw = &tdx_guest->tdvf;
+
+    if (!((VmfdChangeNotifier *)data)->pre) {
+        return 0;
+    }
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
+static NotifierWithReturn tdx_vmfd_change_notifier = {
+    .notify = set_tdx_vm_uninitialized,
+};
+
 /*
  * Some CPUID bits change from fixed1 to configurable bits when TDX module
  * supports TDX_FEATURES0.VE_REDUCTION. e.g., MCA/MCE/MTRR/CORE_CAPABILITY.
@@ -1549,6 +1579,7 @@ static void tdx_guest_init(Object *obj)
 
     tdx->event_notify_vector = -1;
     tdx->event_notify_apicid = -1;
+    kvm_vmfd_add_change_notifier(&tdx_vmfd_change_notifier);
     qemu_register_resettable(obj);
 }
 
-- 
2.42.0


