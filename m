Return-Path: <kvm+bounces-67737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 23504D12C39
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:25:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B0779301BDD2
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577F635B130;
	Mon, 12 Jan 2026 13:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ber94AYR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="EHEPjzjg"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34328359F84
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224234; cv=none; b=LtHmy14iFGONZOQpSqYf4g3fcAYrXht5vawMK28AfQtIQrzItbA1Wv2Y775sZEH64ILvK3OdDm/vhYA6zCOxuIH6M8jVw9gYlBsRuvLpZJGYt/YZnQXdeYpGiA3frsFXqEbdm1AAaEopiCgxKYtqgXe/ZDiMNNyJkHUS9Hqw9/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224234; c=relaxed/simple;
	bh=HFS/yepFFkAHegUlA2uKprY+IwcMao/SJiqJd/VTAVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVdJ8c88g9Al44qQO6e1sQkMDl9d155Ymubgeix8OanHze7+OsVoixaXFObnvI/avV7Ml4FyM9isTXen93FPt8lkExL8XwChdIuy4fMyQ7uawiiXDFIBlsk19c+x83IvCEgyE8ynVkfpr3/2XyRwA+LSKwKAraWr3hnah75W2GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ber94AYR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=EHEPjzjg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IcSPzaL3tdDhSxoArxuWvrysyc9k+MnXqGfZnJng8Z4=;
	b=Ber94AYRUY55HEPQJ3fTZ+4LQECKWnrZOjtHFDs9fe9HUbJfW21CBHycXgfepOc3q4XEYi
	YJpjDInpsI/ANjssV+APcmvs2FcR4iASKCDayXaxzshtB4egIDoC84eaXMF/k2JkSkGJzi
	4UTzalvi+n3tEHyGSaPGwP0kpkalWUU=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-Y4mcYwbvNeyfp8h-PGqzoA-1; Mon, 12 Jan 2026 08:23:49 -0500
X-MC-Unique: Y4mcYwbvNeyfp8h-PGqzoA-1
X-Mimecast-MFC-AGG-ID: Y4mcYwbvNeyfp8h-PGqzoA_1768224228
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c52779e9e65so1798022a12.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224228; x=1768829028; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcSPzaL3tdDhSxoArxuWvrysyc9k+MnXqGfZnJng8Z4=;
        b=EHEPjzjgQNmRWMV+6S0Sk/mjBVIRF5tolw7HbKkZQhkbtEPvOH/A4r6tel9Z3xxEaO
         wk6HkiGZ22isWCDXIu/zRm0ildDq7UBw6fOlt2JQSnfWq56aj7SgcwKm3/wvs+QhhN6Y
         5dsnZXna0pIzH8CIYUNe6Rx0llGblA4krFuvI57pJEOuT0Su1whR8iEvvKG0Gm5bofAl
         7Wfdx7ZmqY/A2IcAdKDfwUXSQIwJ3RgCAEMFC32qcm0Zi1SlASknDhnuAkg9OQzV4KLI
         PlpSAdHuMHAO/0+E4+MBZLvyLB6iUjLEUGaQBoE2T3pAcUprjc+lyM4xDzZLQSrwxTDN
         Zolg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224228; x=1768829028;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IcSPzaL3tdDhSxoArxuWvrysyc9k+MnXqGfZnJng8Z4=;
        b=a4qY/IGn4nCD3mVVv+Ogg0sAV1poehJEc+yWLfFCQoUgvsMju1pMt5PD9ruJWivG12
         dzEE4WKdrIHrSszv1k+iXMcP2UCNK6+KjPoLCcSc34Tp6KSwHyUykmx38knY4Ch+t+LS
         tRdD0OsQrINTybjksD3XDSuods+nQoZbNjDpTINGQAyZVTcEkR/aY0kJQkfiaAi04vgU
         SQW7SYCMn3IoPZOfe4t45+1ss+8sbA+rcc3zlgszo/MdwwSnmV1rbwyIL5zR32lbMJpA
         FZCVnAabA/Tilp4C3V+60Fa5tBLwAZeFzCHMkcZrMavNKcVO+IV4GpS/pWpB65z4q8uE
         e87w==
X-Forwarded-Encrypted: i=1; AJvYcCW3KPguTolHb6YkVytbmzDeYwsvh+5LgvgFvwpQYMajCU6I1pJR298oaluJl8oKJl9GERY=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqpp/li0ih4iNnLty4z0MCl0/l+ld3gH6vyP4lRGjA9UsleVrY
	jl7pKj9O19tbM9U/7V9QQLEUrfYklqleRomiYoBIxwfUnv9xbSJBeUHJyoJ43t/Y4BkY4KuKunZ
	RCfK1z5AtRUBGfEzMFXIm+4LlNP6lJzFr4X98RHyUvycAOykWEOZfKg==
X-Gm-Gg: AY/fxX5OQ1AKvM8dw53zdKjTTTJolYIYdT1uSJ7nkw0o28a+6F7EPovLdsjrVsprO3N
	4qL/tkZFFah/Glr/+SjIJ7Si5TrcLD3F1ua+0VCyyEQEW8PciGHGP3J+e8KcQ2OxjrMN5TaEyQi
	BJCb5FrYh4SXgTHfCpT+YDCZkw+OTo2fJ4HBtRZLpNFO9/XXX6C0H8pX8UotrSLan5ABT4+lz3e
	S9QYjGA1Xl2aUTAH8bl1s3p4MKxBTJiHbVvffYPaZ2h2CNKx9c0uTGozGTvtRMsDZTOM4AtjruE
	bvSJUkkPmMmGeL/dtvOuuJIUfTuUKLykok2IdOpqDq0VhIyKqNYBkcQDAEgNfvUBcgTkO6sXRIY
	lXWDgebJBV/h9A+fL2wmBzvOrHViV4dsMRCAlP452TWo=
X-Received: by 2002:a05:6a20:7f9a:b0:35d:b5a1:a61d with SMTP id adf61e73a8af0-3898f91b4c0mr17844580637.26.1768224228106;
        Mon, 12 Jan 2026 05:23:48 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGLoLDLLXWJii1UGy/1Y4n9jx/3GMA07Q3THZ5tL3NC3wN6HPLqvOEWGOm5zr8R6DDH6syVkg==
X-Received: by 2002:a05:6a20:7f9a:b0:35d:b5a1:a61d with SMTP id adf61e73a8af0-3898f91b4c0mr17844560637.26.1768224227677;
        Mon, 12 Jan 2026 05:23:47 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:23:47 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 08/32] i386/kvm: unregister smram listeners prior to vm file descriptor change
Date: Mon, 12 Jan 2026 18:52:21 +0530
Message-ID: <20260112132259.76855-9-anisinha@redhat.com>
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

We will re-register smram listeners after the VM file descriptors has changed.
We need to unregister them first to make sure addresses and reference counters
work properly.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 6aa17cecba..89f9e11d3a 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -113,6 +113,11 @@ typedef struct {
 static void kvm_init_msrs(X86CPU *cpu);
 static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                           QEMUWRMSRHandler *wrmsr);
+static int unregister_smram_listener(NotifierWithReturn *notifier,
+                                     void *data, Error** errp);
+NotifierWithReturn kvm_vmfd_pre_change_notifier = {
+    .notify = unregister_smram_listener,
+};
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(SET_TSS_ADDR),
@@ -2749,6 +2754,13 @@ static void register_smram_listener(Notifier *n, void *unused)
     }
 }
 
+static int unregister_smram_listener(NotifierWithReturn *notifier,
+                                     void *data, Error** errp)
+{
+    memory_listener_unregister(&smram_listener.listener);
+    return 0;
+}
+
 /* It should only be called in cpu's hotplug callback */
 void kvm_smm_cpu_address_space_init(X86CPU *cpu)
 {
@@ -3401,6 +3413,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
         }
     }
 
+    kvm_vmfd_add_pre_change_notifier(&kvm_vmfd_pre_change_notifier);
+
     return 0;
 }
 
-- 
2.42.0


