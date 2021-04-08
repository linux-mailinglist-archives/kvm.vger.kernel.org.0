Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACE1B3581A3
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 13:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhDHLXd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 07:23:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhDHLXc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 07:23:32 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C74F1C061760;
        Thu,  8 Apr 2021 04:23:19 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id f2-20020a17090a4a82b02900c67bf8dc69so2985007pjh.1;
        Thu, 08 Apr 2021 04:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=xN23vtsUui78zFVIDa0Dk7gGB3uEJ15TDF6m5eb0sa4=;
        b=BGgrcLiojG0/5XAY5tjzrhoIggAjsF2yCnAsgSPeqsE8U76tc1oE9CuR0NZuRwoGyv
         UX4xfumImuwq5NGSO2I46/jC2ST+jTj44RJz+k5ROa5vjctjQSeZBt0cjy/cnnxPRhBc
         UERyBONKc2PrIWZzWvlfcj2TBR2QkItdl7XhOl17k+ApxHZ4qteZ536yOjUvD7Y2sTcX
         gpT/SYh6Ol9Gp9BzR/kVNpnIH8UYxz/G3JLOWav1q5EAoJom/pDIJ7PYfIRsFt7Ktkqv
         aOecs3P13VuD8jK/KWkqoRHEzVwhfyiZZLVWFyXhSvMm/UfoXjJoWjvh70LbXp0V8Z+t
         Yc3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=xN23vtsUui78zFVIDa0Dk7gGB3uEJ15TDF6m5eb0sa4=;
        b=bdqtNJhibSxUm61YzNIQodxxiJ3AWrtvuCIbO9HRamAMlPWSN5AabJ3bmRJivekiyH
         nkQbTj2YHqi5IRrEHy/keJShrV4rv+xSHlEHhhRDl4P8Mx2vuJOv5sZAYxepiRMDMeim
         8pget4yUK+7hZlRi1WWhExJx8hW6EXRcAqE02TFaKnBYG8pkiEVzZHP3GIGCi4BfF6Jj
         vrrk2kFIzDTV9h2uvEjVk4grLkXjqACI2Cm+mvwiuGYsIFNJabG70nBGnZwxFybrtf0o
         kHkahTMQTG4nX2cVApSZMCfXa74s/ilPtjR3jSHWniMv6GAFLGfpNyfGf7FfNRLByHVB
         1X7w==
X-Gm-Message-State: AOAM532BkwcuBM/YXSH4UoxLZ8vjs4FeEol1k9Tu0XsIoUKoz8SQjUJE
        YaKoYUh8BkLL5nIGThHhxa97ot7D4qg=
X-Google-Smtp-Source: ABdhPJzRJVZc05Oz40yXMNEf6v8DsOolGdsV41bBXXPCQWk2d4bJZxJ5JyOJSiDfBMJqLb2HhkY5eA==
X-Received: by 2002:a17:902:e8cf:b029:e7:1db1:e7e4 with SMTP id v15-20020a170902e8cfb02900e71db1e7e4mr7237422plg.81.1617880999132;
        Thu, 08 Apr 2021 04:23:19 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id a13sm23961055pgm.43.2021.04.08.04.23.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Apr 2021 04:23:18 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH] KVM: X86: Do not yield to self
Date:   Thu,  8 Apr 2021 19:23:09 +0800
Message-Id: <1617880989-8019-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

If the target is self we do not need to yield, we can avoid malicious 
guest to play this.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
Rebased on https://lore.kernel.org/kvm/1617697935-4158-1-git-send-email-wanpengli@tencent.com/

 arch/x86/kvm/x86.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 43c9f9b..260650f 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8230,6 +8230,10 @@ static void kvm_sched_yield(struct kvm_vcpu *vcpu, unsigned long dest_id)
 	if (!target)
 		goto no_yield;
 
+	/* yield to self */
+	if (vcpu->vcpu_id == target->vcpu_id)
+		goto no_yield;
+
 	if (!READ_ONCE(target->ready))
 		goto no_yield;
 
-- 
2.7.4

