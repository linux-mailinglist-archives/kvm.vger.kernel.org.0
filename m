Return-Path: <kvm+bounces-70902-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EEJtNnZyjWn42gAAu9opvQ
	(envelope-from <kvm+bounces-70902-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:25:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5613712A950
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 07:25:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 6F866305F4AB
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 06:25:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8030A295DBD;
	Thu, 12 Feb 2026 06:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DVBc2Yw1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="D9Ybbaqw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 456691F5834
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 06:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770877543; cv=none; b=Hg4In85weLQQ7rsXcHUjPqmA+s4dodKsdAKFwm9eTcKDzGSObVQNHQxaKqJ5EzYffn1OzWU1Sh0A1o7iNwOT7R9ie9mnzELvNdsy3BPnvqe6x7SdPLkmOqFtc+3+Zr2Pa4SEOLdhqqFTXsL0GJO4iRqZnVfTw8y+vNpm/YsV/jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770877543; c=relaxed/simple;
	bh=4EGWnSa0ih9PCEjSusQ0B4xiXXqgwJ/YbhIffvFFLzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HMpYzlo7FZN+Exq40wpQFsOGhRb4Kl9BE7ggjeEFExzt5GphqKnexVVvm80dLc3rIgJMyRWPPNhejzY8d7cUjVDE3wPxoMOLU4tRxwPnI3ULYfXT8V0oZaEWdoHoNkE5d4cNE//Fed/bct2SkK5Zc0zAWELJxT/l9JLqmpaZq8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DVBc2Yw1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=D9Ybbaqw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770877541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u8BwHOpnoiGVi9W+T3Y/yleQ5+CcGtx7LvYvltU6aAQ=;
	b=DVBc2Yw1wk57S8yw5G26E8Dqz1ygHBIdy9eM6+YRQYPX04/HhkXKjVS9Qk9QAzctwra5RE
	NtSpeAgp1YcaP7dUimKyiSNKzTERbEGvymi1mbYTJ/yCcQHqpqqIE903hBRFRyBENnHU1v
	aPbG6U/wNj+OC8SWVD4fpkNeD9mMZA4=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-COD3dKeJMcKJRiRTZj82NQ-1; Thu, 12 Feb 2026 01:25:39 -0500
X-MC-Unique: COD3dKeJMcKJRiRTZj82NQ-1
X-Mimecast-MFC-AGG-ID: COD3dKeJMcKJRiRTZj82NQ_1770877539
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-354c72d23dfso7835988a91.2
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 22:25:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770877539; x=1771482339; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u8BwHOpnoiGVi9W+T3Y/yleQ5+CcGtx7LvYvltU6aAQ=;
        b=D9YbbaqwfjFKTdbBXi1iPQoci/NUnGypYZylVFk5kJGORnGJhO3cnGyNUYakMraIGH
         72McwOWLKmFfHb7MhUYeuflKO5ZBJNa5MI+M/OLixySWWXakP8txvG71WmniPBbWaCcg
         eO4+nUMxpQZksJet9jv67kHH9IdI+wWlJomOjLGv0sKHGGudRHFdUwqziWGuAqOxLX81
         cZ6OUHs4zYVuzonpBDVA8xzBTRUDA9F6/8KpZ6h/i5uZKbICTUtX9R+1VtfBVbEOovPy
         niFDaKwWZQr/Az9yJvY/2o2ppeVtAnZ0G2aXmcCBPFKqUPKlqpqYi7xEANAF9jSO3pjM
         UngQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770877539; x=1771482339;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u8BwHOpnoiGVi9W+T3Y/yleQ5+CcGtx7LvYvltU6aAQ=;
        b=BzD0TgjTzU36mZGbhvk0I3TY5tA97nWBENqmfOnsIH7e9DYj1UYHVeayfYJXMhYP6j
         xalkFI3jnctuW0vr2ca7wmxNkzWbG511OXuTZe/RuTdg0s1BSmKeCsrdyaACHNSsymZq
         Cm3GUnim9YZPtWUaFxkmN1KupZMkcdCTvdDf73A44jTHuwZC0rvG+ejRwFKO9xoZbk8L
         KEZNGsU3/aj/QPj7VH8FHkoO5P/Q5D+dJ81gF3G5Rf4ZBPZrJ2bnaQO/MXlTKZSB3rTK
         5lA5lkOhBjU//cbBi7EXBzb4mPrEBR7Em36/9S3uIzDmnsj+jgTmQFxkr2IkGzqe7FfJ
         +vyA==
X-Forwarded-Encrypted: i=1; AJvYcCUSckWoi9YG9bAiV0AWyzUzxYhz1qz/1L4ohWcWW1t9u2HNRynG4lB80e1XK+DfGSbHLiY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw8nyLAEQa+alC5zDMpkv0jgthU5efCKWGUKU9pOG0b5nOOFLrX
	kqmj9uOnmybEFJ+mncWN4GTaCi49P8guKQDzrXhc/0s/vHuE2fThQbo21zsF8wbAZsY67CBKmvj
	kHD15urA7Y943jd3tnN8InXv1W5x2i06pyRLKh7a5s1GUUjN6e4Fcpg==
X-Gm-Gg: AZuq6aIMS9BKuRTIsw3HXm8T/D9j5AZr55gd8WEbH15129pNBOvJOjUUc/psJ3seuPY
	ZveAmp+5/wMHq6wrrOcYJkRtil/w0UErWj1HFuyXxJSQbOCuo0oPn8R92p8SlgMab8/fYj8PUH/
	4M7ETP4obEG7SU3O09IsDGiGAQFgx45wfC5tuCmiJo3LhhcyGqPqJe+vIguRSuZUrdgGXgG6Tj9
	WZRn3pJ0Bz/qqQLKFdkGimYn1P26hHHl0P+MOvEGFzsUnqgPRTTyk+ZNZG/SEPiA484SYOYTw6/
	ZyTAN6Anya9QYumlsgP9Mm2xJBbJnaD8uMWox7Pp8xugx628yFdyT/e5MsqitB3xzesfOhfqN8k
	L58a9czm3Lcv1N70DZtFHnpqGsj+VuayrcP9UoLjMwuc9AZfAaNFySfY=
X-Received: by 2002:a17:90b:1f8b:b0:356:41c2:897d with SMTP id 98e67ed59e1d1-35693cbd055mr1186991a91.8.1770877538767;
        Wed, 11 Feb 2026 22:25:38 -0800 (PST)
X-Received: by 2002:a17:90b:1f8b:b0:356:41c2:897d with SMTP id 98e67ed59e1d1-35693cbd055mr1186983a91.8.1770877538479;
        Wed, 11 Feb 2026 22:25:38 -0800 (PST)
Received: from rhel9-box.lan ([122.164.27.113])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-3567e7d95d8sm4894122a91.2.2026.02.11.22.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 22:25:38 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: kraxel@redhat.com,
	Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v4 01/31] i386/kvm: avoid installing duplicate msr entries in msr_handlers
Date: Thu, 12 Feb 2026 11:54:45 +0530
Message-ID: <20260212062522.99565-2-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-70902-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 5613712A950
X-Rspamd-Action: no action

kvm_filter_msr() does not check if an msr entry is already present in the
msr_handlers table and installs a new handler unconditionally. If the function
is called again with the same MSR, it will result in duplicate entries in the
table and multiple such calls will fill up the table needlessly. Fix that.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 0c940d4b64..da1ed3b62a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -6042,27 +6042,33 @@ static int kvm_install_msr_filters(KVMState *s)
 static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                           QEMUWRMSRHandler *wrmsr)
 {
-    int i, ret;
+    int i, ret = 0;
 
     for (i = 0; i < ARRAY_SIZE(msr_handlers); i++) {
-        if (!msr_handlers[i].msr) {
+        if (msr_handlers[i].msr == msr) {
+            break;
+        } else if (!msr_handlers[i].msr) {
             msr_handlers[i] = (KVMMSRHandlers) {
                 .msr = msr,
                 .rdmsr = rdmsr,
                 .wrmsr = wrmsr,
             };
+            break;
+        }
+    }
 
-            ret = kvm_install_msr_filters(s);
-            if (ret) {
-                msr_handlers[i] = (KVMMSRHandlers) { };
-                return ret;
-            }
+    if (i == ARRAY_SIZE(msr_handlers)) {
+        ret = -EINVAL;
+        goto end;
+    }
 
-            return 0;
-        }
+    ret = kvm_install_msr_filters(s);
+    if (ret) {
+        msr_handlers[i] = (KVMMSRHandlers) { };
     }
 
-    return -EINVAL;
+ end:
+    return ret;
 }
 
 static int kvm_handle_rdmsr(X86CPU *cpu, struct kvm_run *run)
-- 
2.42.0


