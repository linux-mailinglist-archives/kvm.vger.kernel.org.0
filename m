Return-Path: <kvm+bounces-67746-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E449D12CC6
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 14:29:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7000D3085879
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 13:24:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E0883596EA;
	Mon, 12 Jan 2026 13:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bwChIUKk";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lxYIWjfo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A24358D09
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 13:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768224257; cv=none; b=QM0H3rhu3Rm5Vz/rO+1Zejb2WJpHLzvvTKAw40JaNXzZLBmq/GhWg4b5OHpGB0zZ/SSRGqp3O8mKDSOLjlPamT4U7ikBRQc01bNLn0aOOcr1pjg8VqsJrrRokS9fQTViLQB7RB/PxJiMWzkVAGerRytOVZ6KcFYI9E3uhKEHab8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768224257; c=relaxed/simple;
	bh=esJHWdlPBt4FgYZAIhRpyStuSv8bZGoHW3gRMxmO1IM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WfbZ/HBwnT/8UHfP1cuJ9qe9iYzmIrZkHfNAjzNkU/28ZLXm1ePCB50RX4zIGLtJrDKWZlOg0Rj2F4Gn7z+2sfjDQNmN80mfo5YQ71BlqCEG0yKgRenPte9Mnk0WM8+Rg3R9XH1hyHL0Uvnud2Ma7w+h0nRz7/MJHU2wPkKYw9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bwChIUKk; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lxYIWjfo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768224255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WbSNbKmTexfLzSNcOAGGTpME53mT2JoY4BGZ0NYwZQc=;
	b=bwChIUKkrWQyCCfRt3j16+QwZOY4VEvboD5JUNNpeIZ0No8EDpz6in5Z8sGVhqUw1cJcbS
	krDBOxuMRdImbjJcL/Qu/nKT+Q8SLYjvolNPScuqDniEPY9tiIys800WuWbodTjhj1r7GY
	95u+uby2QLjft3Feca65qHJmXTyJ6Nw=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-323-67iiYcvCOxev9sGUfd2vbQ-1; Mon, 12 Jan 2026 08:24:14 -0500
X-MC-Unique: 67iiYcvCOxev9sGUfd2vbQ-1
X-Mimecast-MFC-AGG-ID: 67iiYcvCOxev9sGUfd2vbQ_1768224253
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c5659f40515so4728360a12.2
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 05:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768224253; x=1768829053; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WbSNbKmTexfLzSNcOAGGTpME53mT2JoY4BGZ0NYwZQc=;
        b=lxYIWjfoLwPMjKa7DEBscnXVt84BRflelf7UdDwck4zSY+1f6VlGJcypAvnx+ZxFcA
         0/4gqNEl2neDm5izVOZIt+E2vp5VvZXZf8yNn0POqH19Pryc/1gJqtwFjEbIzIEzsxMh
         woX0lRsTkoxepsJcEkIR8b9OYL2ebKMnpU6ZFL4fWDtqjpE6KgikLpkd9vzpj3yNxXJL
         iArUewPVbsjPKWJwh7OriwVpaRWdWisio6C+u8eX1s3MCFICoa419wsN+vOSZuwlhOQO
         x+lTQpy3OhC/0dWJyKgNPpx4kU6/sA066VoXWG6Y7TLK0jlvQy2P3g0BvT3X/twGP60p
         2eRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768224253; x=1768829053;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WbSNbKmTexfLzSNcOAGGTpME53mT2JoY4BGZ0NYwZQc=;
        b=CTUC0SLALbNYcLm0zigo59lOQxFCamunlqLaoQLcUTQ+9cCJB9e943C8hYGxfJydn3
         NY/pI9eSMKjD9JlAm9sST51h9DCevMos7gVNqIoWj/clDlWpC0EdDqIduxFmSqi9c5aa
         vRspghuWIHMxRE5r5J1pksAI/UempJww0LGIHxekfYOlpLyAAZzcNDDSAhb6o4IvLjOS
         5M16Ckf/VENwDLBPRaVOyJxMNm5ptCK/os9uuBf8myGSL5A8CtC6fuSzd40AO4Q1uUtP
         wzddWboJAvVF72cs8lJY+UNelsLO1fCXvRGuar+0SJPqfKRj9+NbYQbvGwWYcgtFci6Q
         go/w==
X-Forwarded-Encrypted: i=1; AJvYcCUv1ncI8pvljccjHqWAjjBp/4uyNu+ze1jE8wZZvrXqGypaJ5C4id/DhTWA4KTzWeVMDBA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGwqxHusTTmUPahfTHtzIsS5K6KWvpVgOtdkLMOKjk4t2T3CxM
	TYB83EPwaIsNlseNDaC4Dej1ml02sorM/6laoY44sKUbar7FO1eB/HkgXcIIBMgyQp4E83/mMIt
	W5vfuHlmQkYt8b2x9s/rOcclhTrR/s7ZkNKR3+Z26OVkSw0QcXGxUmg==
X-Gm-Gg: AY/fxX4k/vK9cO9CkRn7Kn11k1oXFJSjS9WYew5ihlUpX70ipNjeGS9RP0E8sKu8JgP
	LhJN4web8vltdCmgxrRFt+XHHTYOH6n3I6JXhZMaFXdrGbc7MPaptGPOFP+ad0SL0MuLszoPpWW
	SCZzBc1lA/+lMeWSaZitmzr5/o4p+9ixXTtzywJRrnBRA6X7Wt6hVb8uljDA8PkXTxqRQNmWGDM
	f+IUFTH7BfxdkQY7bJeed4KjY1hAJe5reaWlvmv0RCVA/3eWJjjImKv51RJ5DPmDg2HSusL6PdE
	me3Zd1B0fAASQqfK+VzAWEyJVSd1THkH5KPCHKM3ixX7qAGrmIY8SpMSw2Tpa0CjwDcSKmGpp5L
	rxhfIuZ91Fh/Gb8lbbp/izE91ZozofFdzsLgdwXcLMxg=
X-Received: by 2002:a05:6a21:3381:b0:35e:b995:7098 with SMTP id adf61e73a8af0-3898f8d0267mr15548748637.9.1768224253123;
        Mon, 12 Jan 2026 05:24:13 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH2OK+gMC6fAaYfSLI0gqpQ6KfWfNIPVV4x1e2pkcK2ja8trgOCdiiDYappareAuAFJ5KU3LQ==
X-Received: by 2002:a05:6a21:3381:b0:35e:b995:7098 with SMTP id adf61e73a8af0-3898f8d0267mr15548727637.9.1768224252679;
        Mon, 12 Jan 2026 05:24:12 -0800 (PST)
Received: from rhel9-box.lan ([110.227.88.119])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-c4cc05cd87asm17544771a12.15.2026.01.12.05.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 05:24:12 -0800 (PST)
From: Ani Sinha <anisinha@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Zhao Liu <zhao1.liu@intel.com>
Cc: Ani Sinha <anisinha@redhat.com>,
	kvm@vger.kernel.org,
	qemu-devel@nongnu.org
Subject: [PATCH v2 18/32] i386/sev: free existing launch update data and kernel hashes data on init
Date: Mon, 12 Jan 2026 18:52:31 +0530
Message-ID: <20260112132259.76855-19-anisinha@redhat.com>
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

If there is existing launch update data and kernel hashes data, they need to be
freed when initialization code is executed. This is important for resettable
confidential guests where the initialization happens once every reset.

Signed-off-by: Ani Sinha <anisinha@redhat.com>
---
 target/i386/sev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index cb2213a32a..d7425dde96 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -1768,6 +1768,7 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
     uint32_t ebx;
     uint32_t host_cbitpos;
     struct sev_user_data_status status = {};
+    SevLaunchUpdateData *data, *next_elm;
     SevCommonState *sev_common = SEV_COMMON(cgs);
     SevCommonStateClass *klass = SEV_COMMON_GET_CLASS(cgs);
     X86ConfidentialGuestClass *x86_klass =
@@ -1775,6 +1776,11 @@ static int sev_common_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 
     sev_common->state = SEV_STATE_UNINIT;
 
+    /* free existing launch update data if any */
+    QTAILQ_FOREACH_SAFE(data, &launch_update, next, next_elm) {
+        g_free(data);
+    }
+
     host_cpuid(0x8000001F, 0, NULL, &ebx, NULL, NULL);
     host_cbitpos = ebx & 0x3f;
 
@@ -1961,6 +1967,8 @@ static int sev_snp_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
 {
     MachineState *ms = MACHINE(qdev_get_machine());
     X86MachineState *x86ms = X86_MACHINE(ms);
+    SevCommonState *sev_common = SEV_COMMON(cgs);
+    SevSnpGuestState *sev_snp_guest = SEV_SNP_GUEST(sev_common);
 
     if (x86ms->smm == ON_OFF_AUTO_AUTO) {
         x86ms->smm = ON_OFF_AUTO_OFF;
@@ -1969,6 +1977,10 @@ static int sev_snp_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
         return -1;
     }
 
+    /* free existing kernel hashes data if any */
+    g_free(sev_snp_guest->kernel_hashes_data);
+    sev_snp_guest->kernel_hashes_data = NULL;
+
     return 0;
 }
 
-- 
2.42.0


