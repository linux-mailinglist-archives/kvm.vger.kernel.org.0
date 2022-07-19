Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3C7579FCF
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 15:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239244AbiGSNib (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 09:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238249AbiGSNiK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 09:38:10 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A11F2CCB
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:52:46 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o13-20020a17090ab88d00b001f1ef2109aaso1451193pjr.2
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 05:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=2320Ig5icURFP0x/uiGuZgEkAZF2o/dqif1NVrlsO0M=;
        b=plI1WuauVJ3wpB8y5Fpb4B/mKlR6aOUqhONZ0F2K5ZJqxlCgvx4daDd9qbJBRyXrze
         4weKVw97pA3X/6bGp1KgoRLJ5fLFDpNxYfC/Fnrw0wpgRSmezINYtSZ0oLJj0waLhw3v
         G9e15x/9P0j47SNAizJWNGVxlfMOf7KVPCfqCxdyn9jzuHMeNKJF0X/Pb/L3UXPURvyW
         ljpcNEQtXUAYluea+KGvwZHWwoLJBe9q1Wd8VfI8ZgiqZVpZ4lc0KXmdszyxAXDCQz8u
         yG7lc5Xxt+HN+r7IaAbt2BibaJRJI6SW6uxun9dE6nqo66sJlg3CDuBDWRAvOPtuJClQ
         i6SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=2320Ig5icURFP0x/uiGuZgEkAZF2o/dqif1NVrlsO0M=;
        b=k0fFBVunwzAY0bphB2Q80Twrb8M8Vg4GzGVAxqQ2nO1b/CKsd8eJMaK8Crc/57jIZn
         WqYPwbG3NgEN0SAiBGiOwxpJllAsOLfz6wX/3g8j1Kf9jf4xPEZ8mEDvveJhAqswgex1
         bq9Qr17FVsOv+Y92wP8RodSPi+Dn1BaTsKm2s/Hj+5RExl6+HiGeZ+t/8f3mb2DWe2J4
         cd8tse2jBSTPVltEgQC9ls9ig41HuSvCapDCkh6HginM5byUdoo4lS0ORizSW6gK5DG4
         VipMwfKE05uqE/vUcQ5R02AH2NyRrYuQYOT2bvI6YeSoB10uyPY5wdSTfhs5sqEhPFmK
         plYA==
X-Gm-Message-State: AJIora+WgaH3KjV3Sn0g+LSTUt/Dudi9wTBwWpb+IzDzm3/iF3ky0DCD
        iRzBYipuh+OWQBq7PC/5m60SZwvbhd8eY+jMQKo0eVxDjPenrZNrmTiMh25L9hK/lC9+ZXFoQSt
        IEtYESM8B3Dg5NsEWgRqPlPJ4YXi+kosVmw4q5uteO5nDk7S/fBNsDDYcag==
X-Google-Smtp-Source: AGRyM1t+gNaHTcaAQXE6ghC6tCI0sPvOgpy6JYCBu0oj2UmdtOXVztOxJlkWBp8VtxTn3N9LNXXTkHHZlJI=
X-Received: from oupton3.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90a:ff17:b0:1ef:8b4b:8cc0 with SMTP id
 ce23-20020a17090aff1700b001ef8b4b8cc0mr39032562pjb.155.1658235165673; Tue, 19
 Jul 2022 05:52:45 -0700 (PDT)
Date:   Tue, 19 Jul 2022 12:52:29 +0000
Message-Id: <20220719125229.2934273-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [PATCH] KVM: stats: Fix value for KVM_STATS_UNIT_MAX for boolean stats
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, jingzhangos@google.com,
        Oliver Upton <oupton@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

commit 1b870fa5573e ("kvm: stats: tell userspace which values are
boolean") added a new stat unit (boolean) but failed to raise
KVM_STATS_UNIT_MAX.

Fix by pointing UNIT_MAX at the new max value of UNIT_BOOLEAN.

Fixes: 1b870fa5573e ("kvm: stats: tell userspace which values are boolean")
Reported-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Signed-off-by: Oliver Upton <oupton@google.com>
---

Tested with kvm_binary_stats_test, which now passes.

Sending out a few improvements to assertions in kvm_binary_stats_test
separately.

 Documentation/virt/kvm/api.rst | 2 +-
 include/uapi/linux/kvm.h       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 6e090fb96a0e..98a283930307 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5658,7 +5658,7 @@ by a string of size ``name_size``.
 	#define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
 	#define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
 	#define KVM_STATS_UNIT_BOOLEAN		(0x4 << KVM_STATS_UNIT_SHIFT)
-	#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
+	#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_BOOLEAN
 
 	#define KVM_STATS_BASE_SHIFT		8
 	#define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 811897dadcae..860f867c50c0 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -2084,7 +2084,7 @@ struct kvm_stats_header {
 #define KVM_STATS_UNIT_SECONDS		(0x2 << KVM_STATS_UNIT_SHIFT)
 #define KVM_STATS_UNIT_CYCLES		(0x3 << KVM_STATS_UNIT_SHIFT)
 #define KVM_STATS_UNIT_BOOLEAN		(0x4 << KVM_STATS_UNIT_SHIFT)
-#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_CYCLES
+#define KVM_STATS_UNIT_MAX		KVM_STATS_UNIT_BOOLEAN
 
 #define KVM_STATS_BASE_SHIFT		8
 #define KVM_STATS_BASE_MASK		(0xF << KVM_STATS_BASE_SHIFT)

base-commit: 79629181607e801c0b41b8790ac4ee2eb5d7bc3e
-- 
2.37.0.170.g444d1eabd0-goog

