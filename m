Return-Path: <kvm+bounces-60326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8AABE91DE
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 16:13:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A24231AA1DF4
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 14:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C115632C92A;
	Fri, 17 Oct 2025 14:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UJI0PaDU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD31393DF1
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 14:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710380; cv=none; b=bxIHCrI2Z0QGlbT3hIPTR6VnZr7PuSeVMQgk1IpHEfAjrOtkVZ8FUpJCC3421TCbWNt8vXjcZE3w1J6bJfyt07gh2wmTccAz+UPDlKa7aiq9rQGEMLeHnijBz/1j2uSxL7dd2aqOEfKDF38OIBzg2dSSW+JWLSl8QVWqGgnK+lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710380; c=relaxed/simple;
	bh=G7zh2SwKpFnddZOBKyMR0LkcgKDr9eKNzrdRrWrd7dE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+798HeoGCmHQ2EQtZMNWNZ/yr+mlw80FaioObG+/fW30x4m7xumC+0d2fYDJiGPUg8LfbbTtsGYYMbgNHb+1IvwwCIPWVAT/feYsMqL3Wm/DIQKpXf7r2ojTmVqzM5a9M1IWVjayiubqkR+dmhiDNZRg5baqpvKRhKI9Z+xilw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UJI0PaDU; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-46e6a6a5e42so11117275e9.0
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 07:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710377; x=1761315177; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gteGWnMF2R6W+vB6CRlq0+Co1hdivkhTuMvbx2i6MfQ=;
        b=UJI0PaDUudUWA8LrZZnBX12jcrc6mo/ZgGO61TgKUjFWgcQ59e1KmuhNdb+1ky1y4U
         xMIUjWof20roQjeUJj73JS8WO5ua6Wmk994+Yhn4fwaiIsW4lpeYDa5EohryBU5GzcOe
         5CcpWMZiKBp4lksurAzJprCRmb3PJhhHAVmbnTlx3SsrSLxhTueDuy0ZgnUTpivWkUrA
         FE1+jJN6FgM9oqWz30GdKg0NwiUECMLJILJeaoP0oT5lKYbctiJCdr+u0ioNXjwpipTq
         r19Fu3GrDsjbk2Vb6PBT/4zry+0aGY3FZOad3Jd2ijlF1FfgdYyNXtd7jSpfobmXvEIf
         VIBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710377; x=1761315177;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gteGWnMF2R6W+vB6CRlq0+Co1hdivkhTuMvbx2i6MfQ=;
        b=vM3Xs9VekcQWpxGFCmo/rTJcIX9SsrOmo9VxBrXvSGz+zUNyLdg0rTnMdjnsoAdfKV
         cuAQtfBpufbCWt+yljO/wN5LVEQeoQ23ga8BTbyufXESzQVBK7Ekfh1Nb8PxQjG1DR/i
         pZ/WtUhjUj5rZnUGv22trijZJdGCMj77QpdGRYqcbcr+ON18i3hxBRlxvLHfAEFtLIdw
         a4dcS3EEMPdikJ4Tf8wW/AsB0qPkvkhCT3jGlgsWb47AzyDC/xgO1fYmDesGpJLYR2bf
         rjJBmGxMtpLWQTRUY6sOtxKrRRy+shBIjpCmklGmgc/dyVPPfgzogMiAFbVKQAdhbLWz
         exsA==
X-Forwarded-Encrypted: i=1; AJvYcCXmA/jWoJXZHKMVtTFogApnXnwkStJ8q97FEawXvcWGGGN1fErhaVE1F/gjMI9hLeZsRfM=@vger.kernel.org
X-Gm-Message-State: AOJu0YxN6TL4Ade/NEcI98WhXrR48xtYaPUypoLMU3YHAm2pndPqahzo
	jkFpaPgmjq8ZSsGxeAY0yE6vMtLmenXKilXSNpKQAV+wPfSEJaMRLoRy
X-Gm-Gg: ASbGnctz31pVvkU1KhLlPG/NemkXH0g4xmU+834JaLpTx2uWi9XCT3Sajv4W3FJ/Dae
	JfF6SIcBQX96qa4dQSPp4SsvZ2+bw34YyS/eNwpLXWcYdacm1+6lMrVMgknwEpQEty2cfaB1R9e
	mdD/wKveGCWy68KzBmDMAxrJDFoRBsCBGpYU51XpP5Js5qQUpYlnGVALb0Jlqy4fSkrVarEf8PG
	2ZHJ9AYHHfuN+QHpYYdVaI6ghPOdTyuYjaB3L+gbxCJKVdMbvoP6Q7NuFrPG11VCwiG3Aunnbve
	yjdHqXTUxqfQeALuQ2e+LLaefq7J7TghVfGsx0pDslCF4oOc+1Xqe9azl05DyQY7s3hdH25hlhW
	IbWptwPqKBsDMvjGUaghLK2qdg2xpT8MkfCDDthFSgrCWgL4fECkuCISCRVtp3Z6O0PNeDKiHvD
	aO7NCzIOaG5ugzr16/9AfuNVTS2Ww3ZhYiK20sVeew1fk=
X-Google-Smtp-Source: AGHT+IF0gmmFJZZWMtm31nH8oxPWJUvDxjlKcg/T2Pi9eXPhQiM4NczNuxSbXUqG5YCCifXib1OY9A==
X-Received: by 2002:a05:600c:3541:b0:46d:a04:50c6 with SMTP id 5b1f17b1804b1-4711791934dmr28602455e9.30.1760710376471;
        Fri, 17 Oct 2025 07:12:56 -0700 (PDT)
Received: from archlinux (pd95edc07.dip0.t-ipconnect.de. [217.94.220.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cb36e7csm51359675e9.2.2025.10.17.07.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Oct 2025 07:12:56 -0700 (PDT)
From: Bernhard Beschow <shentey@gmail.com>
To: qemu-devel@nongnu.org
Cc: Roman Bolshakov <rbolshakov@ddn.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Eduardo Habkost <eduardo@habkost.net>,
	Cameron Esfahani <dirty@apple.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	qemu-trivial@nongnu.org,
	Gerd Hoffmann <kraxel@redhat.com>,
	qemu-block@nongnu.org,
	Phil Dennis-Jordan <phil@philjordan.eu>,
	Michael Tokarev <mjt@tls.msk.ru>,
	John Snow <jsnow@redhat.com>,
	kvm@vger.kernel.org,
	Laurent Vivier <lvivier@redhat.com>,
	Bernhard Beschow <shentey@gmail.com>
Subject: [PATCH v2 10/11] hw/i386/x86-cpu: Remove now unused cpu_get_current_apic()
Date: Fri, 17 Oct 2025 16:11:16 +0200
Message-ID: <20251017141117.105944-11-shentey@gmail.com>
X-Mailer: git-send-email 2.51.1.dirty
In-Reply-To: <20251017141117.105944-1-shentey@gmail.com>
References: <20251017141117.105944-1-shentey@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No users are left for cpu_get_current_apic(), so remove it.

As a further benefit, it removes one use of the `current_cpu` global.

Signed-off-by: Bernhard Beschow <shentey@gmail.com>
---
 include/hw/i386/apic.h |  3 ---
 hw/i386/x86-cpu.c      | 10 ----------
 2 files changed, 13 deletions(-)

diff --git a/include/hw/i386/apic.h b/include/hw/i386/apic.h
index 6a0933f401..1b0b26e4c5 100644
--- a/include/hw/i386/apic.h
+++ b/include/hw/i386/apic.h
@@ -23,7 +23,4 @@ int apic_msr_read(APICCommonState *s, int index, uint64_t *val);
 int apic_msr_write(APICCommonState *s, int index, uint64_t val);
 bool is_x2apic_mode(APICCommonState *s);
 
-/* pc.c */
-APICCommonState *cpu_get_current_apic(void);
-
 #endif
diff --git a/hw/i386/x86-cpu.c b/hw/i386/x86-cpu.c
index 1a86a853d5..86a57c685b 100644
--- a/hw/i386/x86-cpu.c
+++ b/hw/i386/x86-cpu.c
@@ -85,13 +85,3 @@ int cpu_get_pic_interrupt(CPUX86State *env)
     intno = pic_read_irq(isa_pic);
     return intno;
 }
-
-APICCommonState *cpu_get_current_apic(void)
-{
-    if (current_cpu) {
-        X86CPU *cpu = X86_CPU(current_cpu);
-        return cpu->apic_state;
-    } else {
-        return NULL;
-    }
-}
-- 
2.51.1.dirty


