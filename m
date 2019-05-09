Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3921618906
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 13:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726797AbfEIL3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 07:29:31 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45792 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfEIL3b (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 07:29:31 -0400
Received: by mail-pf1-f196.google.com with SMTP id s11so1160725pfm.12;
        Thu, 09 May 2019 04:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QYuS0QZtStAtJNSUUAyhiyB4mexk/QCuRQ8hRYUX6sE=;
        b=hxSeIsahsQT4I0BeWTFl4UFrZrTJpIdIQ9r8U5bynKMnqCHBgA+KQpTuyPQJx9RrXR
         S5MgIoUFXonCozy+ObZivrRPdFTZGQnP2DuxxJTX7DdC9BBP7MVqfoWSiVVy/V+u3pCj
         9q9rgjPuBamuxkZpm8IeDFbZw8UQrf88FmjIddtF9ytioDxlr0TATMErH4LmOI8quOFr
         22fhCyO/WJj9lnJKAYBdR9voFMytps8ITXWzKqeV6cFLipaW8CpuqMIbh8JIJmXABiwr
         hPZJzmZ4HsTkILfxxOpGs1U/ysEAbUDnUaqWmSGUpf/q7NxRQUIr+XThjRnnrxxYh4Bz
         AFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QYuS0QZtStAtJNSUUAyhiyB4mexk/QCuRQ8hRYUX6sE=;
        b=XnnO6J6aGOA+AhYtw+zBWZqeb6wTK6MnEvqe+24KfpCgjzQ9uYNsxCUislU+xwfzg6
         QboabLTxtI7//Zbpjr1EG8x4zxFkzXQhOFwPqH+tfZIRne9qzB3B/Abog8LX9CwY1GXW
         kp3yb06WhW4kdUhtkkqTQ6HV6xS/oim4H70aV+IqDZCpoGfYBZbnf4ME7R4rzQUFdGG/
         kzULQIH2G9QOqoH702vyuf091gnOTHd1dhk8JjpChK1RUV51TSFXWsi5mp3IDRosvOzr
         oWYAz9Dnax9lpjvibmCJbSHNoGkBP+MkTs14ZaRVp/eaREGkIQDZyUi6LXO3o4rS1Iba
         q95A==
X-Gm-Message-State: APjAAAVQFs4WV9x5+oOT1M6EOOnUNZRhVU4EH+xrB7MTNWeAzdTnO0I/
        gWk1N9gkY0YpwUQO3mLjLBokMbim
X-Google-Smtp-Source: APXvYqy+lQ/LxK6sn7h5yOIEFke+3DOetFlVnPvoxfsRGGIxeMbMxnQWOcV8lviFP1VC5XWieR9TDA==
X-Received: by 2002:a63:6ac3:: with SMTP id f186mr4669196pgc.326.1557401370117;
        Thu, 09 May 2019 04:29:30 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id j10sm2762002pfa.37.2019.05.09.04.29.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 09 May 2019 04:29:29 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Liran Alon <liran.alon@oracle.com>
Subject: [PATCH 2/3] KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow
Date:   Thu,  9 May 2019 19:29:20 +0800
Message-Id: <1557401361-3828-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
References: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
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
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index d75bb97..1d89cb9 100644
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

