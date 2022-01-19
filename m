Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48126493E89
	for <lists+kvm@lfdr.de>; Wed, 19 Jan 2022 17:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356218AbiASQpx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 11:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356215AbiASQpw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 11:45:52 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 541EEC061574
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 08:45:52 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id o20-20020a656a54000000b003441a994d60so1941445pgu.6
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 08:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/BijbWVuPGfDe5bzECq0SaWh1RFGQecgoREE5TmFYxI=;
        b=BnNnpQcwAectZUSK5KbIlwZdbZiBM6Kz9NdhD1cuhMgFphUsG+jbPBwrir8gKeboGu
         kwVYAlHV992igWe3u2X3h7Oii25LYSDljXLEXWJRTyaQHrtc3uK3ZVIKwf0rZklCyVrr
         gYWOn0/4BrZRulgDOaU3cZIxoig9z7pMvGqFtsE6kIcJVsV3Hd/ewb/TvmeyYsVCjFkx
         ICncSq554DVQdVYZzgIoB1Z3AsRjJYVGS4bPoUSubsnl5SKVAcmk2w6NWTLawGwALtxU
         MYEoplKJIOKH0OAAHADoFpbGqmzmv7cf2VSkqanyRAZ/Uja6+RhE4GZwmRnzRBgODOAK
         iXcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/BijbWVuPGfDe5bzECq0SaWh1RFGQecgoREE5TmFYxI=;
        b=27gh0PyNd+CgMF9+hdJYlASO7t1H4WaV6GYD4UTYSpj7b84AE0RQsfRa74TixftzOW
         qtL0IbdoEUF+dwkhNnUkEkgftUK/kteFTUhvSDG8DhEQnFPFVKUR9HzpIT03NL8bJpbO
         +Z9aOihF0XsfXLDEP7ZunIwtwLHgyWp5/u0hLHjvQuNN/57FZrfwNU+f2jkyV6aV7l+Y
         C1KxiSUX8fj4zzQCPXSstvu9c1WDRYTSS1aDcI1W0Jk4yRx1OyQusI9LymjU+VodJAvk
         vIUEKR1yk8oJAs7fzwPTKPIBbfR21s0bMFh78ksT+VLiwJ3xWbtxVKCEHccGv2Ah+LQp
         S+1g==
X-Gm-Message-State: AOAM532QPsO6+QKimcYUYYa44qAPFlxvNhCneHDGXh+ZaswH+OQp04Ls
        R0CUEGaSkTSiQ+9ZXapoGrbXuNosQMTY9uedLiY6j7QsfTaksOMZ0XatgEH7uqYfpnBpkY2wzpd
        wAuBIraPUTEwRgIWzWTNepBWD/tbh6E562G6NLo6kGuwFjWHDA46qY230y/qCLehyi86a
X-Google-Smtp-Source: ABdhPJzp8UffUcAih9mJLVBzHahrEM5F9ShWM8TNvXgAjcnh+lsqONAlxD8cjTyCetp+280ZPFx2oEJ0QNOaPdwV
X-Received: from aaronlewis.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2675])
 (user=aaronlewis job=sendgmr) by 2002:a17:90b:2406:: with SMTP id
 nr6mr2011176pjb.99.1642610751643; Wed, 19 Jan 2022 08:45:51 -0800 (PST)
Date:   Wed, 19 Jan 2022 16:45:39 +0000
In-Reply-To: <20220119164541.3905055-1-aaronlewis@google.com>
Message-Id: <20220119164541.3905055-2-aaronlewis@google.com>
Mime-Version: 1.0
References: <20220119164541.3905055-1-aaronlewis@google.com>
X-Mailer: git-send-email 2.34.1.703.g22d0c6ccf7-goog
Subject: [kvm-unit-tests PATCH v3 1/3] x86: Make exception_mnemonic() visible
 to the tests
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, jmattson@google.com, seanjc@google.com,
        Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

exception_mnemonic() is a useful function for more than just desc.c.
Make it global, so it can be used in other KUT tests.

Signed-off-by: Aaron Lewis <aaronlewis@google.com>
---
 lib/x86/desc.c | 2 +-
 lib/x86/desc.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/lib/x86/desc.c b/lib/x86/desc.c
index 16b7256..c2eb16e 100644
--- a/lib/x86/desc.c
+++ b/lib/x86/desc.c
@@ -91,7 +91,7 @@ struct ex_record {
 
 extern struct ex_record exception_table_start, exception_table_end;
 
-static const char* exception_mnemonic(int vector)
+const char* exception_mnemonic(int vector)
 {
 	switch(vector) {
 	case 0: return "#DE";
diff --git a/lib/x86/desc.h b/lib/x86/desc.h
index 9b81da0..ad6277b 100644
--- a/lib/x86/desc.h
+++ b/lib/x86/desc.h
@@ -224,6 +224,7 @@ void set_intr_alt_stack(int e, void *fn);
 void print_current_tss_info(void);
 handler handle_exception(u8 v, handler fn);
 void unhandled_exception(struct ex_regs *regs, bool cpu);
+const char* exception_mnemonic(int vector);
 
 bool test_for_exception(unsigned int ex, void (*trigger_func)(void *data),
 			void *data);
-- 
2.34.1.703.g22d0c6ccf7-goog

