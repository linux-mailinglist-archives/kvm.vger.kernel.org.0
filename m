Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4541779923B
	for <lists+kvm@lfdr.de>; Sat,  9 Sep 2023 00:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343955AbjIHWaF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 18:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343924AbjIHWaE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 18:30:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4181FCA
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 15:29:59 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d7e4151d07aso2543394276.2
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 15:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1694212199; x=1694816999; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/sy4Cn1X3f23j6DJCKOvy7yO2KD//Ic8lCob4A9AHhQ=;
        b=SPvGi8cfQpE72ZhYi+iyXWu+RgrGBhEHwEoeJdQz9Lps9itG1QJe69doicBtoaFLbn
         QraV7PvVxV+GWmpPN/DS4PmBAx5u7MAVYxvUt0T7I/HB2XU24Ptg1VdCuhTd1oN+niIX
         WKWW+Bzc/ljh8GXy05oyNIOkXK7eJOzPRh/j6+iodAMTOj/Trm9TAxcdoxDk44wDeY0t
         3kBsWfdIwxXtwjVh/pFNWbCRbHKfepm7rKroDMoefs3W/PVRhx0NNj+GMdNpL5OBw8+E
         kmDR7KTGxk0sN3cPhPeoA/CfUAHUJr0gE6hP/B4NCdlClZ8zFYmJVgTHplSVA+TtNUOZ
         n2Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694212199; x=1694816999;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/sy4Cn1X3f23j6DJCKOvy7yO2KD//Ic8lCob4A9AHhQ=;
        b=syWrA+wjgm8GSrdwRCAGxInXTbSplxEE9DlwzOFNoBBBtxGGQ9iHFW3e8nsDcyh4yR
         SodbrBV5bIGlR0YcOult9SMJ+Mx66fsdhBoY69hH2hZoFwuGvG0ypgWnA7Tu8dmpkyvN
         NkIbjKT+f2h/fw9xfOCF1SyEJx2Ga5TJiTKLAaZJ0T61iohPJHosL4sYpKd9rzMwZzL6
         Ip1ElfWSFX7t39Fe1I/N3hCikS2aRDyvXHAMLVO5+nOVwxwiui4tsgwpIoj2TD9IIWEr
         MPqrt9fLu6CGuaTs7ONtRnrqEhiqWXxQSIyFoomliZ3H6viHVluhArx9wV+HM2FoxWGg
         SupA==
X-Gm-Message-State: AOJu0YwQPfEQkXoTOuaS+VQKDQKssu507N89iSh5r4ljvqdBYtPpAnon
        xdMGHzkKgesIx8F5BbRjWaMmM7L55fxY7g==
X-Google-Smtp-Source: AGHT+IHfZ0/H1S0KyKpbxmbTxxAv4PkI43WgGvDpPDRHv30smv/EmWxfKi0rHwtfKXYTF2yg50kBD8Rw7qxr2g==
X-Received: from laogai.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:2c9])
 (user=amoorthy job=sendgmr) by 2002:a05:6902:98d:b0:d7a:bd65:18ba with SMTP
 id bv13-20020a056902098d00b00d7abd6518bamr89404ybb.3.1694212199283; Fri, 08
 Sep 2023 15:29:59 -0700 (PDT)
Date:   Fri,  8 Sep 2023 22:28:58 +0000
In-Reply-To: <20230908222905.1321305-1-amoorthy@google.com>
Mime-Version: 1.0
References: <20230908222905.1321305-1-amoorthy@google.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Message-ID: <20230908222905.1321305-12-amoorthy@google.com>
Subject: [PATCH v5 11/17] KVM: x86: Enable KVM_CAP_USERFAULT_ON_MISSING
From:   Anish Moorthy <amoorthy@google.com>
To:     seanjc@google.com, oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     pbonzini@redhat.com, maz@kernel.org, robert.hoo.linux@gmail.com,
        jthoughton@google.com, amoorthy@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
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

The relevant __gfn_to_pfn_memslot() calls in __kvm_faultin_pfn()
already use MEMSLOT_ACCESS_NONATOMIC_MAY_UPGRADE.

Signed-off-by: Anish Moorthy <amoorthy@google.com>
---
 Documentation/virt/kvm/api.rst | 2 +-
 arch/x86/kvm/Kconfig           | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index c2eaacb6dc63..a74d721a18f6 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7788,7 +7788,7 @@ error/annotated fault.
 7.35 KVM_CAP_USERFAULT_ON_MISSING
 ---------------------------------
 
-:Architectures: None
+:Architectures: x86
 :Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
 
 The presence of this capability indicates that userspace may set the
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index ed90f148140d..11d956f17a9d 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -49,6 +49,7 @@ config KVM
 	select INTERVAL_TREE
 	select HAVE_KVM_PM_NOTIFIER if PM
 	select KVM_GENERIC_HARDWARE_ENABLING
+        select HAVE_KVM_USERFAULT_ON_MISSING
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent
-- 
2.42.0.283.g2d96d420d3-goog

