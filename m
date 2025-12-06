Return-Path: <kvm+bounces-65454-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 63A1DCA9D4F
	for <lists+kvm@lfdr.de>; Sat, 06 Dec 2025 02:17:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E257F32082EB
	for <lists+kvm@lfdr.de>; Sat,  6 Dec 2025 01:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E12E28CF7C;
	Sat,  6 Dec 2025 01:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Gp/Cgt9X"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729EE26E6E1
	for <kvm@vger.kernel.org>; Sat,  6 Dec 2025 01:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764983481; cv=none; b=gpxjE7FTkwXe+d3dmXLheYKBDiatzhZ2NqCslHJoCIbXWpgN0Yj41yCdQ6NVFIw0VX+drUN6++o6eP9D9+6znViimOcsGyLIvn/QIhfzrfJjxkvhXgrzRdi30wUOJ/HL6RAjOo5Y/kiFLN3+fq5/qLlhapGOO+UU36YCiUBjdtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764983481; c=relaxed/simple;
	bh=dD0zdMBxcirbZcOCLQPI4IDX7thvsilC04qKPz4Ct6Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j/OcARz7YIeQYOwh345oBCmrokYUaU6QS7u6G1HsiYvXynl4mWbAwi0lo6SwEx99bkWpLljJhB3K9cU1T7gCFbbnoNDi+O3vIm9HP6+0C1kIy3OqtWuO3p0sLBB9u5g9CpVJR0BlmbS81GJhwJrKkRyI7Qu1VBl6QGC/bOBiIf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Gp/Cgt9X; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-3438744f12fso6721649a91.2
        for <kvm@vger.kernel.org>; Fri, 05 Dec 2025 17:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764983479; x=1765588279; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rVtJBDhchDrLagfgGom7nKilzuyDMEWeeU45x47h0PI=;
        b=Gp/Cgt9XPNKT3gYaJlFTPCgPX5qxP0Zee1SlEuQ2NP/wIR5QTdhxXgWjqKj3FJZjZ5
         aevEP9M2jTsduiQFyyaa90J54F5r0XWx3vsK5RItojEvrjXLe9IO/zOe0TijsyaNpzxX
         lH5HYdRbSS1Ek7xqdRpIz/NfpYNFM19Nantxyd1QwuOUdu79AkRqjEwWCqB4MMMMkN9n
         9W6C8+z0z49J/k6HZ1Tzh28UNstxNyfzBk+QW+20CjeWlXe2Butuo4xitNzNZxXobJrp
         1KXjvsj8/tt9jU0tUZx4zskTb4ew5NJNrb+ex0yv7cMcc/0WQN6TvIbMwQmULIPg1GfP
         4gtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764983479; x=1765588279;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rVtJBDhchDrLagfgGom7nKilzuyDMEWeeU45x47h0PI=;
        b=K0RDUnCVjFlyhF6N75WtSupZV+7crcFgt8dih60GoTkYgi1IYGbgNB1Xe3XxC8Nv6t
         CcFu0dGDKezhEGeAd8Xjc/vdS+5JTYvqTL2r4JnPNOn1f2yTEDI2tZlbsDeIyEPGoX5A
         YVSjYYcGK3OwZvPO98S2/INKjni1HFV6y6VR4hRb0exFlptPT4GfEg77EoXIGR0lW7pG
         EJd6sr1Ho25wUUGrjxZMgaVKcQG0nZTlzMy1ll8y1V5mLee/kopYmIJRHDK/5DdaD+xk
         XgnpnqLM1YNaRp/OoE3FZPmqB3ksXgzaw/200a4aJ7V9WYF7L2QuBOcG2av7DNBr24OK
         woUQ==
X-Forwarded-Encrypted: i=1; AJvYcCX2p1j6GtAYKoiYqos+XzEjRZoy23yXjf3ac3ERtMTOWZ7m1WQLQ64LifL/sWOYbfwEuog=@vger.kernel.org
X-Gm-Message-State: AOJu0YzWNHd7JPB6tRqIPmbZ5Acp505QOOHL955y2dW3ucrtDRMFoSy8
	i2ZTx8OduIf3KS9lGn66WvoLI0ADEcql+9ADjNRvqU7TwaXX68dvZGSJ2eu69SBXCNNub/xamKc
	Pvw4zmQ==
X-Google-Smtp-Source: AGHT+IERf67I/KSjwUV4VBGzOV5LWpvLTz4kgH2qJZnW3MJYfCI+Tp3EG4cQDFHBfXE9LirgMVmyzwQKLSk=
X-Received: from pjbfz21.prod.google.com ([2002:a17:90b:255:b0:340:4910:738f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2f08:b0:339:ec9c:b275
 with SMTP id 98e67ed59e1d1-349a253dc8emr794762a91.6.1764983478902; Fri, 05
 Dec 2025 17:11:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri,  5 Dec 2025 17:10:53 -0800
In-Reply-To: <20251206011054.494190-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20251206011054.494190-1-seanjc@google.com>
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251206011054.494190-7-seanjc@google.com>
Subject: [PATCH v2 6/7] x86/virt/tdx: Use ida_is_empty() to detect if any TDs
 may be running
From: Sean Christopherson <seanjc@google.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-coco@lists.linux.dev, 
	kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset="UTF-8"

Drop nr_configured_hkid and instead use ida_is_empty() to detect if any
HKIDs have been allocated/configured.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 5cf008bffa94..ef77135ec373 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -58,8 +58,6 @@ static LIST_HEAD(tdx_memlist);
 static struct tdx_sys_info tdx_sysinfo __ro_after_init;
 static bool tdx_module_initialized __ro_after_init;
 
-static atomic_t nr_configured_hkid;
-
 typedef void (*sc_err_func_t)(u64 fn, u64 err, struct tdx_module_args *args);
 
 static inline void seamcall_err(u64 fn, u64 err, struct tdx_module_args *args)
@@ -195,7 +193,7 @@ static int tdx_offline_cpu(unsigned int cpu)
 	int i;
 
 	/* No TD is running.  Allow any cpu to be offline. */
-	if (!atomic_read(&nr_configured_hkid))
+	if (ida_is_empty(&tdx_guest_keyid_pool))
 		goto done;
 
 	/*
@@ -1542,22 +1540,15 @@ EXPORT_SYMBOL_GPL(tdx_get_nr_guest_keyids);
 
 int tdx_guest_keyid_alloc(void)
 {
-	int ret;
-
-	ret = ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
-			      tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
-			      GFP_KERNEL);
-	if (ret >= 0)
-		atomic_inc(&nr_configured_hkid);
-
-	return ret;
+	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
+			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
+			       GFP_KERNEL);
 }
 EXPORT_SYMBOL_GPL(tdx_guest_keyid_alloc);
 
 void tdx_guest_keyid_free(unsigned int keyid)
 {
 	ida_free(&tdx_guest_keyid_pool, keyid);
-	atomic_dec(&nr_configured_hkid);
 }
 EXPORT_SYMBOL_GPL(tdx_guest_keyid_free);
 
-- 
2.52.0.223.gf5cc29aaa4-goog


