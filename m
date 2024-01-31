Return-Path: <kvm+bounces-7613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DEEB8844CB5
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 00:27:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7326A1F2901F
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 23:27:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D15EB47F46;
	Wed, 31 Jan 2024 23:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SS0x9QY3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B784779F
	for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 23:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706742553; cv=none; b=e+HMvR+FgR8zIxh8C1MxmFZzVcpmlnr88zIURde1dJwrNl/wPpLu+0Z37h2hNYFVcnGl2takYYGPmNt5My7VHaBcmF/5e9Jk0AdQ258CaYsS8HAxQw+xKzAotLV52OHdL3UdA9AE1jcMpq9c4LOi9ZBvFuEXOegGpLWDBy5OAGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706742553; c=relaxed/simple;
	bh=AITC0g6KpE00MHHi4gqzkoS6GaRfFWD8G+vwLdrjOPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SqtKTAOwaFdWEh3Eh/rR4C6NRgKbCe0U9dICRNzVGbT6SbM/ZKQzabnzdBOhRQk7DxUp8rz9hlOTz6A08lNsRGbN8bKWL6WwPiSAs4w5z1RVJzw8e4rzaXqnjuqVLX/vArK5w31q8VdvRbdKTh/XgECId14lh5rQOtdIOqTnM9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SS0x9QY3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706742549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6tcUd6aqQBTGujreDUlh09+Wd/lkDDTLdTqmcFaCI+4=;
	b=SS0x9QY3wFco+YJWHeBeN78CIfWxhigd/5bJrMKItiaClLP3fAOnyjvECQ2f2TrkY/PgQr
	xmf7V/yErX5p+7B1TcEsoD/gz80Hjsd8xANwgdQcaMeKJ/A8eM3y/eb5rC2wuNqmtw8whz
	WAH68Xnsla9J25SaXMNmwXV2AgzOE9g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-509-_SE6PFjhOxmBGyAnwcc3nw-1; Wed, 31 Jan 2024 18:09:08 -0500
X-MC-Unique: _SE6PFjhOxmBGyAnwcc3nw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-33b14a51901so5455f8f.2
        for <kvm@vger.kernel.org>; Wed, 31 Jan 2024 15:09:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706742547; x=1707347347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6tcUd6aqQBTGujreDUlh09+Wd/lkDDTLdTqmcFaCI+4=;
        b=rsgUOJwNHDRzCNHVLfUTVQJeeLfghICbSlgyiBjuU37XjUbLL9AfsuG+nsqphlJNwW
         hAmRdOAjyFlnt/ZgYdOYc5I1Wm5Vl/KlxBF0adA8UXLOEl8DXDCW6JmWg5DJvKwyVMnr
         tZ2tMtVAvbi9IcPb5DJYL5jVBR1lDn+u0edPFeXeJTVxyifbhNG4kBrGAiu93lUhwpjY
         UU4QYQIhJcysPTEilf8tXn2TO9vnHPrqILFrO9g6naNMJlCIu3MjEU5w2sox9HKYgHWI
         b/tN8/8orQlPE/UTOv+2VotbKi0I+BKiQDjHQI6WfuARiIJDWIeyPDkkJ813urT8IGYE
         5fJw==
X-Gm-Message-State: AOJu0YxxDrHWX07FYfEEHfTHODhFbgneDzUaEHH1xSYByU22q8NuNgCa
	mKDO7QzLdp9hWgmYwQiT4IjFbJFAMnPOitKFdCB3/jc50IcgObyPkaFbR4YlZ8K6rKrR1si4Pyu
	vLTxNxgV57zqouVgak8gAOKR/E/VbZLSfDQVWmIkJsubNfq9+WQ==
X-Received: by 2002:adf:e2c5:0:b0:33a:fe3b:b2ae with SMTP id d5-20020adfe2c5000000b0033afe3bb2aemr1897576wrj.66.1706742547299;
        Wed, 31 Jan 2024 15:09:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHAzHcFMYzZ1Fjt1TKLWmURRBot7v+72esHPyNaiZPiNsBBgagAdfrkSX8NfQy6730BbzqiyA==
X-Received: by 2002:adf:e2c5:0:b0:33a:fe3b:b2ae with SMTP id d5-20020adfe2c5000000b0033afe3bb2aemr1897565wrj.66.1706742547097;
        Wed, 31 Jan 2024 15:09:07 -0800 (PST)
Received: from [10.10.0.32] ([213.214.41.32])
        by smtp.gmail.com with ESMTPSA id a2-20020a5d4d42000000b0033afe816977sm3900965wru.66.2024.01.31.15.09.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 15:09:05 -0800 (PST)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Zixi Chen <zixchen@redhat.com>,
	Adam Dunlap <acdunlap@google.com>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Kai Huang <kai.huang@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	x86@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 1/2] x86/cpu: allow reducing x86_phys_bits during early_identify_cpu()
Date: Thu,  1 Feb 2024 00:09:01 +0100
Message-ID: <20240131230902.1867092-2-pbonzini@redhat.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240131230902.1867092-1-pbonzini@redhat.com>
References: <20240131230902.1867092-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

In commit fbf6449f84bf ("x86/sev-es: Set x86_virt_bits to the correct
value straight away, instead of a two-phase approach"), the initialization
of c->x86_phys_bits was moved after this_cpu->c_early_init(c).  This is
incorrect because early_init_amd() expected to be able to reduce the
value according to the contents of CPUID leaf 0x8000001f.

Fortunately, the bug was negated by init_amd()'s call to early_init_amd(),
which does reduce x86_phys_bits in the end.  However, this is very
late in the boot process and, most notably, the wrong value is used for
x86_phys_bits when setting up MTRRs.

To fix this, call get_cpu_address_sizes() as soon as X86_FEATURE_CPUID is
set/cleared, and c->extended_cpuid_level is retrieved.

Fixes: fbf6449f84bf ("x86/sev-es: Set x86_virt_bits to the correct value straight away, instead of a two-phase approach")
Cc: Adam Dunlap <acdunlap@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Kai Huang <kai.huang@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: x86@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kernel/cpu/common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 0b97bcde70c6..fbc4e60d027c 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1589,6 +1589,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 		get_cpu_vendor(c);
 		get_cpu_cap(c);
 		setup_force_cpu_cap(X86_FEATURE_CPUID);
+		get_cpu_address_sizes(c);
 		cpu_parse_early_param();
 
 		if (this_cpu->c_early_init)
@@ -1601,10 +1602,9 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
 			this_cpu->c_bsp_init(c);
 	} else {
 		setup_clear_cpu_cap(X86_FEATURE_CPUID);
+		get_cpu_address_sizes(c);
 	}
 
-	get_cpu_address_sizes(c);
-
 	setup_force_cpu_cap(X86_FEATURE_ALWAYS);
 
 	cpu_set_bug_bits(c);
-- 
2.43.0


