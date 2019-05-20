Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF5F22E37
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 10:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731210AbfETISa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 04:18:30 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45049 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731176AbfETIS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 04:18:29 -0400
Received: by mail-pg1-f193.google.com with SMTP id z16so6407972pgv.11;
        Mon, 20 May 2019 01:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XPVS3XeAZxOZ/R/YBjfCO9pjR10Yp4ja3rYxAr4bJ7I=;
        b=bLPAqCrWH4iAaA6dIXAHFEtr1x/3NehkpnvfYv/xgpKRDueU6E7URbXjPgXE1SQ2Zo
         mk4lmjsYau41cUUn1Ce31OmN5cYtwrCLqd8i5QsuvLpu9/Q7FIF4Kr0q0RycCLDIqsm9
         VB79y5CPkaHlR525eBaoNaYkO9wM2zWpEGuEB9q+HCjaQfFW5EWI9EVOCBjY0WHB+clI
         ikijLIF6OIftK6A0z2CG5Kg2rh1P58J+zbyoQt1tf78Fax2vkhl399q/7wHXnjI8KNqK
         Neri0pi/fCp3On66dGFmHrbD9xfU/rmrMOlHyyqnNT2pBDXOMi15zMizoVYZBMpO+jMx
         Os2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XPVS3XeAZxOZ/R/YBjfCO9pjR10Yp4ja3rYxAr4bJ7I=;
        b=k0BdiOU5ObycLMw/4P9onA/gCf/Yo9joNDNKZnj6LwwxeujAPyv8oORo7phSCUdoL5
         8z/xTuJN5AMe3LiYct2p9W3UqCbSJccDKUNDyH/ntBW+hf6bKX3MeQ2ibDgFupp3IQMZ
         V2C7gio6m81JM3kVHg53rscrRHKzCqVNK/lL0yK8m7w4H74AlKSsHMvBaAH2lDAM0o5B
         IZUFOXuG3MFOekHhvxR5P/sHqQ24KvqqkMfCc4nQfMyJo5NSb0xdpThD6bo+3nsT6+7N
         2AhlUKkQaWu7/vvvzkMJa5q06wygv2q2NCzJOW99G/gGZ0x3VJuoPYe3vxc/N/qYHdAc
         aTrQ==
X-Gm-Message-State: APjAAAV0EzB1FHPL6W2CL4eqRCyw6Ce+0q7OXzo2tqVvxzke+QLofgnr
        95n/WEaONnKKWzZE6fuOtkj78kUu
X-Google-Smtp-Source: APXvYqz9PRwF4KXoky+x56Q1ytt29bWiZhQKgmd9ObS8ZXW2Kxh3saiJaNRJ2xBwPl14IzmvC7ahQw==
X-Received: by 2002:a63:18e:: with SMTP id 136mr45105122pgb.277.1558340308341;
        Mon, 20 May 2019 01:18:28 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id z9sm18522110pgc.82.2019.05.20.01.18.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 20 May 2019 01:18:27 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH v4 2/5] KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow
Date:   Mon, 20 May 2019 16:18:06 +0800
Message-Id: <1558340289-6857-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
References: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

After commit c3941d9e0 (KVM: lapic: Allow user to disable adaptive tuning of
timer advancement), '-1' enables adaptive tuning starting from default
advancment of 1000ns. However, we should expose an int instead of an overflow
uint module parameter.

Before patch:

/sys/module/kvm/parameters/lapic_timer_advance_ns:4294967295

After patch:

/sys/module/kvm/parameters/lapic_timer_advance_ns:-1

Fixes: c3941d9e0 (KVM: lapic: Allow user to disable adaptive tuning of timer advancement)
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Radim Krčmář <rkrcmar@redhat.com>
Cc: Sean Christopherson <sean.j.christopherson@intel.com>
Cc: Liran Alon <liran.alon@oracle.com>
Reviewed-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 784c953..3eb77e7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -143,7 +143,7 @@ module_param(tsc_tolerance_ppm, uint, S_IRUGO | S_IWUSR);
  * tuning, i.e. allows priveleged userspace to set an exact advancement time.
  */
 static int __read_mostly lapic_timer_advance_ns = -1;
-module_param(lapic_timer_advance_ns, uint, S_IRUGO | S_IWUSR);
+module_param(lapic_timer_advance_ns, int, S_IRUGO | S_IWUSR);
 
 static bool __read_mostly vector_hashing = true;
 module_param(vector_hashing, bool, S_IRUGO);
-- 
2.7.4

