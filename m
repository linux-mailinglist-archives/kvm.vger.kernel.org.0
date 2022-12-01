Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CAC63F898
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 20:53:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbiLATxA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 14:53:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbiLATw5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 14:52:57 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20266275F6
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 11:52:56 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id u10-20020a17090a400a00b00215deac75b4so2970981pjc.3
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 11:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BbXv6r/HFkUw2Q8SN/R2Yw4sxw4SDqaIbsUg2TQCSQk=;
        b=oMYCnUSVTkEufD+qGGr/q89kXw8Fskasw/xETPbAvoU1KOSp8ivG8+KgudaIFcNPuS
         F4J9O4BCnqebvQMCJGVmm0u5Z1r85Z9FTP64iGbJ+EUGgCAmGWw0S+N0qjTUiV++a5Yg
         Z3HXe+exXPB7kt5fcJsrEhAL/zvkzUBgNHOyp9O+jg0vIBB+G3PPcxO6GCTyy557Qia6
         zztHNLmLkl+IU7NLUhUF6GMLqwMxn9kP2bABMW56LkFCEcS3OwIIcHSoDgLwFsehqo3z
         nPtZ5SLtQPeo0I+3N98oCp+oSTnTuejWXeCgX/KujnowAIKiNTLK6qgv+6HdVEIbzuD7
         ad0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BbXv6r/HFkUw2Q8SN/R2Yw4sxw4SDqaIbsUg2TQCSQk=;
        b=tnf7qjp98FFgKYTJtuNqBbM1e5qP1j+txQ+OK7sTk9Yjw52zx9EuUkcsT50d4GA7k7
         eTFK5eLnUfxVZ51Tq8oZfgweUcyGIUaIdCzv1+KDZhuSuBylFBFw+2c5bFEkzoA2fctP
         m1dt4fQCz3FHbIwgeuSH3xiyE8Sg78DBk551E6YBdqsk/P+9PWuSe80HPuBRN0MmnGpz
         vXNZqsJr/FcuZlS2CfXUazPF3GBk0nH/Md1dTVK/Wrh2nzz4460OW2mdnGEe3qaBibFj
         RjTY6UiBofLXUFMkf/LGuRqaDo93jR4XgybHi4IQb3kqcD1HmBh3YB/31A0Dm+9o+3Qc
         DVqg==
X-Gm-Message-State: ANoB5pn57fip6khvNE4q0KbHrDQHGYFo1+oloc+iSDI4mq6J2Fd5ce7X
        vklTxWiQ+BGrPd7VEDb9V8DCZ9rieX7h+w==
X-Google-Smtp-Source: AA0mqf6L60+bnphYyvdfxaz030HyQ7FOsQEFqQgXctWIsuCiWwEwlNriaoNQ/NgqJWpHs4ZWwBszbOX1+TyqIw==
X-Received: from dmatlack-n2d-128.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1309])
 (user=dmatlack job=sendgmr) by 2002:aa7:9892:0:b0:576:4aef:f1e7 with SMTP id
 r18-20020aa79892000000b005764aeff1e7mr1095161pfl.18.1669924375584; Thu, 01
 Dec 2022 11:52:55 -0800 (PST)
Date:   Thu,  1 Dec 2022 11:52:49 -0800
In-Reply-To: <20221201195249.3369720-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20221201195249.3369720-1-dmatlack@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221201195249.3369720-3-dmatlack@google.com>
Subject: [PATCH 2/2] KVM: Document the interaction between KVM_CAP_HALT_POLL
 and halt_poll_ns
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        Yanan Wang <wangyanan55@huawei.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
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

Clarify the existing documentation about how KVM_CAP_HALT_POLL and
halt_poll_ns interact to make it clear that VMs using KVM_CAP_HALT_POLL
ignore halt_poll_ns.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/virt/kvm/api.rst          | 15 +++++++--------
 Documentation/virt/kvm/halt-polling.rst | 13 +++++++++++++
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eee9f857a986..896914e3a847 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7213,14 +7213,13 @@ veto the transition.
 :Parameters: args[0] is the maximum poll time in nanoseconds
 :Returns: 0 on success; -1 on error
 
-This capability overrides the kvm module parameter halt_poll_ns for the
-target VM.
-
-VCPU polling allows a VCPU to poll for wakeup events instead of immediately
-scheduling during guest halts. The maximum time a VCPU can spend polling is
-controlled by the kvm module parameter halt_poll_ns. This capability allows
-the maximum halt time to specified on a per-VM basis, effectively overriding
-the module parameter for the target VM.
+KVM_CAP_HALT_POLL overrides the kvm.halt_poll_ns module parameter to set the
+maximum halt-polling time for all vCPUs in the target VM. This capability can
+be invoked at any time and any number of times to dynamically change the
+maximum halt-polling time.
+
+See Documentation/virt/kvm/halt-polling.rst for more information on halt
+polling.
 
 7.21 KVM_CAP_X86_USER_SPACE_MSR
 -------------------------------
diff --git a/Documentation/virt/kvm/halt-polling.rst b/Documentation/virt/kvm/halt-polling.rst
index 4922e4a15f18..3fae39b1a5ba 100644
--- a/Documentation/virt/kvm/halt-polling.rst
+++ b/Documentation/virt/kvm/halt-polling.rst
@@ -119,6 +119,19 @@ These module parameters can be set from the debugfs files in:
 Note: that these module parameters are system wide values and are not able to
       be tuned on a per vm basis.
 
+Any changes to these parameters will be picked up by new and existing vCPUs the
+next time they halt, with the notable exception of VMs using KVM_CAP_HALT_POLL
+(see next section).
+
+KVM_CAP_HALT_POLL
+=================
+
+KVM_CAP_HALT_POLL is a VM capability that allows userspace to override halt_poll_ns
+on a per-VM basis. VMs using KVM_CAP_HALT_POLL ignore halt_poll_ns completely (but
+still obey halt_poll_ns_grow, halt_poll_ns_grow_start, and halt_poll_ns_shrink).
+
+See Documentation/virt/kvm/api.rst for more information on this capability.
+
 Further Notes
 =============
 
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

