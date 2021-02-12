Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8153197CF
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 02:07:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbhBLBHA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 20:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhBLBGt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 20:06:49 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2841EC06121C
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:06:20 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id c12so7995276ybf.1
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=Y67LULj4Vit9d/qVGY5s43+v1n+wHLvy3C+5YsJH90A=;
        b=Fytt+DKAjecPvEF52pkEHtGEevMU2fMASC/WkmnrC9upf3i0sHXnDJZVK+a5L4+bLn
         nRR0ypVQy+3giJt/LDuKQQiK0uo/Y57HHC47ElOryxPXct9nb7NmcNnEfC1DmANFrFxV
         meSh14TwQ5FdEERq453r6pAPFvTMiy18Wr66leLoHbu6I/GE/sHTHKjJ0HP3MdMhfDkP
         zz0Buwa/hGWJSo4mNutskl0sKCXvKoHOMGmfR+s/5VxBtaxrxdVf5s/hXYJ4AM9n6c/y
         1QFsANpMOFiZsqjfAelZllccbGDBTdCzrlMnRftw2kiRa8JvdpCE56GdGNskprsyeden
         YhXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=Y67LULj4Vit9d/qVGY5s43+v1n+wHLvy3C+5YsJH90A=;
        b=HtmtXsOM8iVMbaofGG9sqDCSfpnUw4zNSr7REhwcJ/ParS/CSY+otpSFGo+Paqd+nH
         lSPPd3urthqbthRBB16V1hSJOEL6y9l5GupFDB7LDzPDarNSBEJ66zGGOpW/LDKLBxFK
         husvzCFI0xt7SIniZvTD23CfI8/Yf8lJeXsDXs2axiJwNDQmvOAIcp2Fa0T8AI13TomT
         5+jgtolzoCOVqd+SInD4sf083jvIdJvctoKZG00UAcoFpEZY0c7sF83eGbkGj0a1zzhc
         D91IuoE54AB/PfntC67jBKiHIDUV5Xxx83sgwiv6saVHQOhQMD6EtHqldNx8LTScihu8
         7fsQ==
X-Gm-Message-State: AOAM533q5OgjD+vJ5wfb9rFxzhHtDTzGGEIuXoLo1gRbJ7Mdo0FLZRUM
        ZrGMh11IutrVOHx0FtXG+dGDTY5d2rw=
X-Google-Smtp-Source: ABdhPJx7/o/ro7Frg69y6RXlpoGaTs+tQKO/6wykqxh8rniGmBgnmS1frYM1Wo8ojF784ZzxRZHUgFK4sfo=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f588:a708:f347:3ebb])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1025:: with SMTP id
 x5mr832686ybt.21.1613091979443; Thu, 11 Feb 2021 17:06:19 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Feb 2021 17:06:06 -0800
In-Reply-To: <20210212010606.1118184-1-seanjc@google.com>
Message-Id: <20210212010606.1118184-5-seanjc@google.com>
Mime-Version: 1.0
References: <20210212010606.1118184-1-seanjc@google.com>
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 4/4] x86: Add a 'pcid' group for the various
 PCID+INVPCID permutations
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename the 'pcid' test to 'pcid-enabled' and add a 'pcid' group to allow
easily running all three tests.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/unittests.cfg | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index d8ef717..0698d15 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -242,20 +242,23 @@ file = kvmclock_test.flat
 smp = 2
 extra_params = --append "10000000 `date +%s`"
 
-[pcid]
+[pcid-enabled]
 file = pcid.flat
 extra_params = -cpu qemu64,+pcid,+invpcid
 arch = x86_64
+groups = pcid
 
 [pcid-disabled]
 file = pcid.flat
 extra_params = -cpu qemu64,-pcid,-invpcid
 arch = x86_64
+groups = pcid
 
 [pcid-asymmetric]
 file = pcid.flat
 extra_params = -cpu qemu64,-pcid,+invpcid
 arch = x86_64
+groups = pcid
 
 [rdpru]
 file = rdpru.flat
-- 
2.30.0.478.g8a0d178c01-goog

