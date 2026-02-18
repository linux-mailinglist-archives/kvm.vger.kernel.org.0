Return-Path: <kvm+bounces-71227-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id EP+eM/KllWkQTAIAu9opvQ
	(envelope-from <kvm+bounces-71227-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 34EC3155F94
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 12:43:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 18750303DD70
	for <lists+kvm@lfdr.de>; Wed, 18 Feb 2026 11:43:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E709B30DD37;
	Wed, 18 Feb 2026 11:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L6yQ8cRn";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="toKJAv9A"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 127B430DEA2
	for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 11:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771414995; cv=none; b=C25noNgydZojGNoFS5sReX2CmWZi1FJ11G4oYexmTlGVriZMUaOTg9u2IhHSFqP8dYYtKK4Wq+8iUUzknfuPpn7W4p8nLbkMIF1XORYhIwU/qgc4wes74BVgvBoQh2+Xlh0L+rn6oK1qRjQqLER2tW9ZNK4Z3fiXxmO2y2Rr2cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771414995; c=relaxed/simple;
	bh=/gIbbcKgxWdr7eBzoy0XcHaaGB3YufY6LBqU6GukYiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m383gNL2TN++285LgbW6cTUgP+TojQpppbOVn5tPADgR33rfLJnErppOZKyKHPz1U70v6DoMrIHQuTFIlNfnkoyRT7Yjc2rXquUohN75IyAjNSXcYr43M7oZNsM6X+6tNLu6hS9Vt6M/Tkuc/zhs7gAehs86fy0fSntRPkNHHrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L6yQ8cRn; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=toKJAv9A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771414993;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eq6qLXbyXLJc54ZDJbb9jP08uxtrOMIUIN9nTu5R5VE=;
	b=L6yQ8cRnnTzIMP24fhwHyAUuq97qo7Xmk7MJ0vLzZrSLUrfCh6uUChlD5tbC3wKefCSU5g
	LwyMCTT6nRSmCIsJNpdFRDKOxYneGd1ANr6M4hGwlwXkS9lGu7sob1Aif5sW6m9iam/0BQ
	05+Ha8JMU3Ke/QzdNMHaq58lHeZaFgA=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-359-1Bn9EYfUNoqeuSPV0xfykw-1; Wed, 18 Feb 2026 06:43:11 -0500
X-MC-Unique: 1Bn9EYfUNoqeuSPV0xfykw-1
X-Mimecast-MFC-AGG-ID: 1Bn9EYfUNoqeuSPV0xfykw_1771414991
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2a8fc061ce1so300739635ad.0
        for <kvm@vger.kernel.org>; Wed, 18 Feb 2026 03:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771414991; x=1772019791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eq6qLXbyXLJc54ZDJbb9jP08uxtrOMIUIN9nTu5R5VE=;
        b=toKJAv9AT8L87NmdamYgDgTDM4Rp37TS8nEhxCftTqiiJO0Gz6fpKxv8IpEe+VpSdE
         s9ULV8WPzsWAtqLRL7UWyuVpAEDZ1F4EjxsgD+do+eOqLlBRWfDo1I9ScYhHErCL3L0Z
         82lbjWbdh7emBGL4ykgzw61Ou6F7vd4176ByWN+PaOHEhpIh8fU9l8ci++zw+A+5uvON
         zBw4o9WU3C4Uh+2SPeL876Tr5Nj+1WzCl4Px34lZCFw8apGEc1PMZR4Msffz5KtU5FDq
         mu0/pHyzGy2+f8iOyAuuq575W+V2GhJcJC5zVpNy4eIojT/7wzZe0tc9iJzhWK778Tiv
         fLrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771414991; x=1772019791;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eq6qLXbyXLJc54ZDJbb9jP08uxtrOMIUIN9nTu5R5VE=;
        b=YMkQQ7CtUCdlgfExehe2wkqGVErHCK2MCG7Ylkb9CMRYxowZbgsIeP1UGW6NL5y6oS
         UvwOlLct8GjS0iaAlyilThHlV/GhMEUwtW6FNVyUgbrazN9jKnHsHel0110mM5mCYQvp
         v5NaOqpkyZYS8UbGpn1+Yh24URQKdkpMrrl6zdSnodBxDG8nPK1CdAvQhGSp2bHM7Tze
         fGN/vY6Qj5YUAdb+DsTB1n1tfuZI4tMXvdwDdYSJu8Apza6dj+lX8ss27DoVGBIWl5QL
         Hh0jemk9uBkR16lnEBxc75qjB5CZK9LY03N8mGE98C4GjjWT9ZZ8VGG/6ELH0mOOjv5O
         nPfQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUGk+zOMxwtquPYvBzabCoHjMs7EByZaOZgJh6xFcagoKdV/NFg7vtdMJLMkmoOnmolCU=@vger.kernel.org
X-Gm-Message-State: AOJu0YzyN7uR2XSu/6tV9mk0SEBNZuIrzsmKg3JnBhSxv30/BoDclSQL
	XwBWRAAeYknalQmMbZDFqaDphoB6sRG04ggQU9jKWnMf4hoVMWxaDBeugaFHcAI/7iSJ5CMw2KL
	Jmakoh1ORnujst1136WSFkRmlqiIjNsAwwkg3zezRh7ia4T60Lls/mA==
X-Gm-Gg: AZuq6aKupWQJv8qYME4QMCrFHOgN3aRfUPPjZnEToCFEEcl+h1y7BC86Dur4fdrS5bF
	RVjN+kTPqGFtdjhi3+15i5sCJmZRSSNF5fBd/LuRm4aKAYfng6Af4OabqX9bi4tDTJthHcm7t/2
	ng4J6jrLiLOe3ow3IH8S/DQ0hlxKB5CYMmALttPYLro4UG62AwHTq+MzpmmubuaHvTXX7i3ZoZf
	ZkwljgUltCZM9NvpPvf/QGUdHoATVcPwpjUoosje1lfOyMFsvI7Cs8579y9pzg87J+l6fLB+V3w
	qTsO7YAmWTI6DXKM0i79SlcS4FrcPcwCegtz97J0h1UQR/IYtmMDbiq+0YfusUDQJ3MWPksCn5q
	e7e/QluYmWlyriMvPMuGxIp9ebXveqZi4/Cvh6edMxSwSSAxpmZD9
X-Received: by 2002:a17:903:2282:b0:2aa:e238:e219 with SMTP id d9443c01a7336-2ab4d0b2e48mr167750715ad.58.1771414990742;
        Wed, 18 Feb 2026 03:43:10 -0800 (PST)
X-Received: by 2002:a17:903:2282:b0:2aa:e238:e219 with SMTP id d9443c01a7336-2ab4d0b2e48mr167750475ad.58.1771414990343;
        Wed, 18 Feb 2026 03:43:10 -0800 (PST)
Received: from rhel9-box.lan ([117.99.83.54])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-2ad1aaeab38sm127803425ad.82.2026.02.18.03.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 03:43:10 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kraxel@redhat.com,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v5 08/34] i386/kvm: unregister smram listeners prior to vm file descriptor change
Date: Wed, 18 Feb 2026 17:12:01 +0530
Message-ID: <20260218114233.266178-9-anisinha@redhat.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260218114233.266178-1-anisinha@redhat.com>
References: <20260218114233.266178-1-anisinha@redhat.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71227-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[anisinha@redhat.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 34EC3155F94
X-Rspamd-Action: no action

We will re-register smram listeners after the VM file descriptors has changed.
We need to unregister them first to make sure addresses and reference counters
work properly.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/kvm/kvm.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index a4e18734b1..83657fe832 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -112,6 +112,11 @@ typedef struct {
 static void kvm_init_msrs(X86CPU *cpu);
 static int kvm_filter_msr(KVMState *s, uint32_t msr, QEMURDMSRHandler *rdmsr,
                           QEMUWRMSRHandler *wrmsr);
+static int unregister_smram_listener(NotifierWithReturn *notifier,
+                                     void *data, Error** errp);
+NotifierWithReturn kvm_vmfd_change_notifier = {
+    .notify = unregister_smram_listener,
+};
 
 const KVMCapabilityInfo kvm_arch_required_capabilities[] = {
     KVM_CAP_INFO(SET_TSS_ADDR),
@@ -2885,6 +2890,17 @@ static void register_smram_listener(Notifier *n, void *unused)
     }
 }
 
+static int unregister_smram_listener(NotifierWithReturn *notifier,
+                                     void *data, Error** errp)
+{
+    if (!((VmfdChangeNotifier *)data)->pre) {
+        return 0;
+    }
+
+    memory_listener_unregister(&smram_listener.listener);
+    return 0;
+}
+
 /* It should only be called in cpu's hotplug callback */
 void kvm_smm_cpu_address_space_init(X86CPU *cpu)
 {
@@ -3538,6 +3554,7 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
     }
 
     pmu_cap = kvm_check_extension(s, KVM_CAP_PMU_CAPABILITY);
+    kvm_vmfd_add_change_notifier(&kvm_vmfd_change_notifier);
 
     return 0;
 }
-- 
2.42.0


