Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E591F405CE5
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:32:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237493AbhIISda (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:33:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237355AbhIISd3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:33:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56CBC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:32:19 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j9-20020a2581490000b02905897d81c63fso3491722ybm.8
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:32:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=spLnCQZlIbcUrxFiVIendQ1pC9hVNZvWQSDOA+UvjVk=;
        b=r89daTy9fPBGaiG18IWOgrY8O/RLfpzpsRAl3PYo1wUW+pQB2k0WXbisQH/HPVFbyA
         3ijOaHq3+fV3wfV8sv0fmOEUczsU8IHZsvTIeuIb/+LDSlRpbBnngnFUxKYAhWanceN7
         WE7SCImQQdIS5FkHSNlVqu0ch2awg6SekdS/9pP/tcSV9ZSuTcwXe5J0VuvQgARg0m+o
         q+huQWk+9AjPDHePQekZPVE0C6Te42MsrTlynGUCUaRagTq29qVc2mOoseVzH+C54Lhe
         reLKJV3Of4fltLBA6Y2c06yxzVUIccEsbhU2Xvlx14VK4T8Ism/2aGW0AP7ZiLRxkBzX
         CGhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=spLnCQZlIbcUrxFiVIendQ1pC9hVNZvWQSDOA+UvjVk=;
        b=YJahCJ0WgNWnceub+FzIZrQQy9Au6F6V28whSt362k/ABnDjgv41oCvS50nAB2nf2f
         Jb42g4kDCRnV/tJFkgadxqstHgn3eAsC8v1vsEm8cGATeJfwDdL2L4+/uke4zPdU2bRj
         vv2GbiS00QLUppWNsUKkb4RKN/Jx9kVcWp6mfFobdPPGLqaFZ/dEhgPPF5s3b23L+R3l
         9ICv15DvbWspCTojKAR1NuaLJ0ZZR4q3eCOOf8nbhtBRL5EEpREcNx1di+5g26RRHJwm
         m3cW6Q+oMu75rLuhYI/MwTKDTQVg6yqnRHNPknuOtaapbGLoC9QcIDfDLJzLZ4AGCXmR
         Oa1Q==
X-Gm-Message-State: AOAM533chQPAzl2DjF0KZBk4rBCzEbW9/BE/baPqQB3ixe2MDOhhOCom
        Izdd2yhyt2Y7Thhsk1ZqJfRevrLJG1g=
X-Google-Smtp-Source: ABdhPJxgv1/TcTrDKtQU1S40mOmbQeXj+stLDWFBcNt5Da6kRYRw02tOuz2wVs3L+XOQnHzyUUe/qScNN0I=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:295c:3114:eec1:f9f5])
 (user=seanjc job=sendgmr) by 2002:a25:a522:: with SMTP id h31mr6166818ybi.355.1631212339151;
 Thu, 09 Sep 2021 11:32:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Sep 2021 11:32:04 -0700
In-Reply-To: <20210909183207.2228273-1-seanjc@google.com>
Message-Id: <20210909183207.2228273-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210909183207.2228273-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v3 4/7] x86: realmode: mark exec_in_big_real_mode
 as noinline
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Bill Wendling <morbo@google.com>

exec_in_big_real_mode() uses inline asm that defines labels that are
globally. Clang decides that it can inline this function, which causes the
assembler to complain about duplicate symbols. Mark the function as
"noinline" to prevent this.

Signed-off-by: Bill Wendling <morbo@google.com>
[sean: use noinline from compiler.h, call out the globally visible aspect]
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/realmode.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/x86/realmode.c b/x86/realmode.c
index b4fa603..7a4423e 100644
--- a/x86/realmode.c
+++ b/x86/realmode.c
@@ -1,3 +1,5 @@
+#include <linux/compiler.h>
+
 #ifndef USE_SERIAL
 #define USE_SERIAL
 #endif
@@ -178,7 +180,7 @@ static inline void init_inregs(struct regs *regs)
 		inregs.esp = (unsigned long)&tmp_stack.top;
 }
 
-static void exec_in_big_real_mode(struct insn_desc *insn)
+static noinline void exec_in_big_real_mode(struct insn_desc *insn)
 {
 	unsigned long tmp;
 	static struct regs save;
-- 
2.33.0.309.g3052b89438-goog

