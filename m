Return-Path: <kvm+bounces-70909-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qFN5CL1yjWk+2wAAu9opvQ
	(envelope-from <kvm+bounces-70909-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CBAA912A9D4
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:27:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B8FCA30D2ACC
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD66D295DBD;
	Thu, 12 Feb 2026 06:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F5XtN9y3";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="h+ygbqJY"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 180EE1EB9FA
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877578; cv=none; b=kTT62DfGhWN3wOsxyNys9VJGUug1J812Mw2D7V3piFxuMbXqiNpAlamOut/nYQ03Mvng3zqL2FLk7dUw1Z2ti3v8kjGdXud2MoQZxyN99BY/twDHXnAK3i22ostb2c6qdnzigUTA3mDjiCJ2jaudDqduolFX34AgvZCc3XdXcIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877578; c=relaxed/simple;
	bh=Kw8n4l0WSuO3qIzYbvF0dvPTzIMT+Gi3x1q+DnRRO0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVgJXRptR58Rsf66D+65pKqX64UHsElZ0y8Dhg7iVaA8554Jn/F1Tlxsdm3l1I7z01mn8oh1bpwAv+Z5Y3F2Rz+huwzv8uGqjgOjgnz/hEG8fSKcz5qlcClG1LmCXCAJI0g7BIw56GJQoFPu/Ri5g429A6oGviCSFq3ZssfZKUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F5XtN9y3; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=h+ygbqJY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3B3ktj7wTRZtGaUxqIgngJ0a4ysK1is7v0SePu1Te4o=;
	b=F5XtN9y35bYLgHaPIkb7kxwQtrjfzgmv5ZPSHtmawSAp5JEq2ziRjB0clyBzdtfXF1ArRQ
	4FWhx1As/3Cur14B4/qww9FsvK/jEje7ukleekLKLukruwXnrFjFFZerfCdz7oB6zXLnlV
	+VlsP6Qd0FtzH+FShb+QYUBs6vjepqs=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-5QHiNxOkN1q_VaTw2bQXGA-1; Thu, 12 Feb 2026 01:26:14 -0500
X-MC-Unique: 5QHiNxOkN1q_VaTw2bQXGA-1
X-Mimecast-MFC-AGG-ID: 5QHiNxOkN1q_VaTw2bQXGA_1770877574
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3561f5bd22eso2400930a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:26:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877574; x=1771482374; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3B3ktj7wTRZtGaUxqIgngJ0a4ysK1is7v0SePu1Te4o=;
        b=h+ygbqJYgarBQyw5X+s4Svu0OlBSmZCZkPbFNnTq+Jhjv6CNnrK2skpjnKDg91WaEg
         OHn/1Hbk0Y2PIWuyR+gC1H7HUADT0ywuFwyINUugGTYw2x1VXPLPWk8ynyxweAijW5gu
         +SiZhWO2VDhOW4q2VYbru2yCF0OO9W8nJLoHeaxWEG3EwDGwYFfJeGBdE17EXk1YoVsb
         7PsGjwh3cMzPINSOCm9+vuLa3sOWv7QxxWVHF0skm9M2v8XYt6eDRioMcbAuUL133HgW
         yRZrbOs6k+1SmzQUAYT4mN31kDvplBPM+Jdv838YkBlbO6NSiHkBLLxWh/d9bxGbxhnU
         JBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877574; x=1771482374;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3B3ktj7wTRZtGaUxqIgngJ0a4ysK1is7v0SePu1Te4o=;
        b=AYEmNWyp+U6Zcm4aV5jj+jHcwF0kbxdIjrm0hdjOOE7GO47moVCYa2dYr2X6OXbpOk
         qX/y6FGciApZ8xVOq4v9QHIEhtxlR6o91d//2LFRLDHXCsVNNsVTM19tTWgjs7b28EI7
         gzQDs12oCgYFwxMZv+juMaoJEc6B8Q/cO1mTHN1Ru4N1aOf2cW2Pg7ZgyZrFOS0xdAQK
         z+giIWaSgkwONjJ8Noa3h+YyGRudYkb8q9SZu9SFrnOYinZsjMOpjXiKIPbGCjffLJkC
         am56qeXaiZEHk1tYI3UYoHDxib4eTKkA8S486uhO9XZRrj0davXcow6wQ8UkmYRZAR5I
         JHVQ==
X-Forwarded-Encrypted: i=1; AJvYcCWDV4NCrCFr7+eBo0AoQD3an1IsFtbKE1OY03YSOQvTAZHIPHW2Tm8t3qzrfqVmERqnmjo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4UF9sBOHgDaRNfjAyt4+op6RnKn7FaaHO0yr55BxS9v7sq3p9
	8MLcwzPbNIE9TTroCMwPfTlbiZsPWOx3q/qzUyRk1/netXZhzPInsxAOb9BGUr0wNM4jio+ZYSC
	DPnQVaO+rUqCuenb6I11ixjDKiSU/IeLNTT/tjwGSGRJTxLtzWE5+bg==
X-Gm-Gg: AZuq6aKY5dlrJ6KhPNd1pa7gBf1WiWnNv1JAzWmZJjfhFR3xnZfedjm2Z85x2Wq41O7
	CezNPz3nG7xnyyVGkc/NSoYV7cz7oZ84PqM60f3qNBss0GOXA8uOF9TrhW5V7U+w4kLklvUzrOe
	x6TAYiyKIRSUZWpqi1fdy6ubcOFojEjnyn/KY4bAirDsNxN76R8oRNPitYDd6hWNVz5dcSnxAmJ
	2MYrLpsqm4ufRQlG7xQV3YsZoVT5wy0xfmUgj6sJAwaLDfHTMFyi08xLmKjkFRjVHwo+olMKY67
	BY17/N8g5d4ZhAhu+CmZgC7BnLBKG6DMSxwQEWgQYMB5LQjwvXyy0alfVgpx3rx1DXmiPnc4X00
	4vjFIIeH6uqkRN6soI3eZbSmEysNM/jSKl3hhtLyQ5oP9vAl6SEY020s=
X-Received: by 2002:a17:90b:5287:b0:356:22ef:57ba with SMTP id 98e67ed59e1d1-35693cbd17bmr1186773a91.7.1770877573696;
        Wed, 11 Feb 2026 22:26:13 -0800 (PST)
X-Received: by 2002:a17:90b:5287:b0:356:22ef:57ba with SMTP id 98e67ed59e1d1-35693cbd17bmr1186763a91.7.1770877573345;
        Wed, 11 Feb 2026 22:26:13 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:26:13 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 12/31] kvm/i386: reload firmware for confidential guest reset
Date: Thu, 12 Feb 2026 11:54:56 +0530
Message-ID: <20260212062522.99565-13-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260212062522.99565-1-anisinha@redhat.com>
References: <20260212062522.99565-1-anisinha@redhat.com>
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
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70909-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CBAA912A9D4
X-Rspamd-Action: no action

When IGVM is not being used by the confidential guest, the guest firmware has
to be reloaded explicitly again into memory. This is because, the memory into
which the firmware was loaded before reset was encrypted and is thus lost
upon reset. When IGVM is used, it is expected that the IGVM will contain the
guest firmware and the execution of the IGVM directives will set up the guest
firmware memory.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index e82a6e9eda..eec2f27a0f 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -3281,7 +3281,14 @@ int kvm_arch_on_vmfd_change(MachineState *ms, KVMState *s)
 
     if (object_dynamic_cast(OBJECT(ms), TYPE_X86_MACHINE)) {
         X86MachineState *x86ms = X86_MACHINE(ms);
-
+        /*
+         * For confidential guests, reload bios ROM if IGVM is not specified.
+         * If an IGVM file is specified then the firmware must be provided
+         * in the IGVM file.
+         */
+        if (ms->cgs && !x86ms->igvm) {
+                x86_bios_rom_reload(x86ms);
+        }
         if (x86_machine_is_smm_enabled(x86ms)) {
             memory_listener_register(&smram_listener.listener,
                                      &smram_address_space);
-- 
2.42.0


