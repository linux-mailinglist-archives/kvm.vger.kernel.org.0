Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 809B6112A02
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 12:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfLDLUS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 06:20:18 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:34650 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbfLDLUS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 06:20:18 -0500
Received: by mail-wm1-f65.google.com with SMTP id f4so4599045wmj.1;
        Wed, 04 Dec 2019 03:20:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=H33X4AK+u43gUnhB1O2fMOEJjx19wp0DYd+Rf48fRQA=;
        b=pHnQ75nqMQUj1Idg8y+ZdY1KcmPx6nqGQxnOGR/QcMRyLiHYKfdEj1ke5yQ/IkLbDT
         dFBvQrbFgk5v0GajNDVSsYtO5oKaW2cSVSQ/GyKBYp/raOWVXQqB2NPPkWJa86xd/L1h
         2ex+i7D9+VKq+7dyCFQMDECnwxYMePPLth2iJZfR9dZ09v8XZFtmuEIZqHBsuxZd5Xhh
         ZPicdGxQmS6b+47dkvCkBOItW6o9Zdps+snIQsyWqOk2lUFNSEkxKFxCus4PeM+zG4gr
         SpjON49YzWFFzNetDesRpBFwWioDykVupisiI0w2WSHUZWEGPdKi4gKMT/IjP29WsHWv
         qPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=H33X4AK+u43gUnhB1O2fMOEJjx19wp0DYd+Rf48fRQA=;
        b=hO2JJJrIMEwM7k1lsqng4oCHR/bKP4in9ahbTMTFycdeE0MPrrlefqZEwm6HAEmp7L
         8T9fms70s8uWryd13yl5+ydMq3kFQyygw2OW1UAOkoVJYl79EcLuIYr2WvBTF7dR77U+
         8udoGeoR5DeTWWNG3FGspLDxc8hyfkkP4H7iffi0O+EF+sPjqyB/Hd3R20SZ1FQr6wOX
         huL/nHpuNrAq7o7zf5ZnwIg1puTSyPR6t2f+0zck3qtkQRmMoUE6s8As3nL2Y8ArfMv4
         7NlFSvvJbmqCDvE7H/HukONK+rhT+WCdscJ6opj6YiVK01xXN20r9YWuMTKQvhoChj+d
         3pkQ==
X-Gm-Message-State: APjAAAXbhemyRiYSXwnvZ8TrasV/hIPnnuVcaLW0pxV6rYaLJPbtrCRn
        BAeh+phKJw+dV4diq5i0OB53xRt5
X-Google-Smtp-Source: APXvYqx3sfx7h6wlSw+Zba7Lzr+rEDFkJ3LR55qcg6m9TLRL50Y7jecyIWXGAsuY7uEkIcwsZvWnkg==
X-Received: by 2002:a7b:ce19:: with SMTP id m25mr20006752wmc.6.1575458415389;
        Wed, 04 Dec 2019 03:20:15 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id z13sm6595440wmi.18.2019.12.04.03.20.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Dec 2019 03:20:14 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     bp@alien8.de
Subject: [PATCH] KVM: x86: fix out-of-bounds write in KVM_GET_EMULATED_CPUID (CVE-2019-19332)
Date:   Wed,  4 Dec 2019 12:20:12 +0100
Message-Id: <1575458412-10241-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The bounds check was present in KVM_GET_SUPPORTED_CPUID but not
KVM_GET_EMULATED_CPUID.

Reported-by: syzbot+e3f4897236c4eeb8af4f@syzkaller.appspotmail.com
Fixes: 84cffe499b94 ("kvm: Emulate MOVBE", 2013-10-29)
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/cpuid.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 813a4d2e5c0c..cfafa320a8cf 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -504,7 +504,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 
 	r = -E2BIG;
 
-	if (*nent >= maxnent)
+	if (WARN_ON(*nent >= maxnent))
 		goto out;
 
 	do_host_cpuid(entry, function, 0);
@@ -815,6 +815,9 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
 static int do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 func,
 			 int *nent, int maxnent, unsigned int type)
 {
+	if (*nent >= maxnent)
+		return -E2BIG;
+
 	if (type == KVM_GET_EMULATED_CPUID)
 		return __do_cpuid_func_emulated(entry, func, nent, maxnent);
 
-- 
1.8.3.1

