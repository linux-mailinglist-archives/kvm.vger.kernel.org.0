Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85F163C74F1
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbhGMQip (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235538AbhGMQig (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:36 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3219CC05BD2D
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:56 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id c17-20020ac87dd10000b0290250fd339409so14043386qte.6
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=ruF9NeysJG8YlLwDSa8NGDxOHgaZRuCfs6bt3ZWAhqU=;
        b=q/QtnyQ9oosp7aP3q8zCPx1rbONx4piEuNDTe5YQXzXRg7B3QsfVOcDOUrjXpAfZ80
         rUMkNbVNonq5w6AWR16/QUr487h5VRHwruFBiRrptKAaDx/pT3JeWaWN4clj6AKxK7xC
         r022arb8lhLRWVLSlgIt/w7FQmIElKHrLHkQratxTBJTdeCvMEmwt6ZV+m/3BikSZ5wf
         lxWIf/tGWw2e8h/bCuvjojg6z0dfF9T7gqY0C2T7Ub5Ayp0nNsseS5hyH7MzbMDDrh4S
         1gB7by08qF06UvRUJgS6IXMbGLQbKO4qZCtrmWWFO8R4th4LMvFeOSVW1O6cAGvE8VlR
         nOjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=ruF9NeysJG8YlLwDSa8NGDxOHgaZRuCfs6bt3ZWAhqU=;
        b=K69sBwYxPrX+uzTi+9pKA+a9JCfUX8kjQZmFIDCZ0/uTIYFljE+Ehae4Rjj2W3rAjP
         YFfXLPWuSQBsSOFM0tIL+gKIbYXW9ZKeMfiT/QXUfaVUGX4rKIGGne+bodlVWHcpn21y
         aWQxdZ3mjJHv42UCXMG8Q4mUROq6VpyQdU1nZ6iOH5xk4Kz9D6ls9I6kAqEjjowKSbuS
         yzTQVj7PDot9eP+r56BTG/M5VnV0Wzk2EdxrjC8I6YSFENh3vYLrtXarSpcQAAGeJGvL
         984BsZaoxRt6FNPpol0HsqQGQIf4vzvBWRBS9SkONIP9oJbC3NcxB6lYY00WulbZbQwU
         Gs2A==
X-Gm-Message-State: AOAM533+VKzM/UB7/U4TA75gKe5es+Q+oFCCutoloaFIDANt9spnogDQ
        RunW75yasd8/h6K6mBSQhHRt5Lt1fYM=
X-Google-Smtp-Source: ABdhPJzVU9yW2GAGD/nTjgmJlL07BIkZt8qPLIe2eCv6L8Db/53PtthwwLzzlQYczyhtkjPQksbVWmB+MNI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a05:6214:4b2:: with SMTP id
 w18mr5659848qvz.5.1626194095368; Tue, 13 Jul 2021 09:34:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:20 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-43-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 42/46] KVM: VMX: Remove redundant write to set vCPU as
 active at RESET/INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop a call to vmx_clear_hlt() during vCPU INIT, the guest's activity
state is unconditionally set to "active" a few lines earlier in
vmx_vcpu_reset().

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cdde1dfaa574..4acfb2f450e6 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4465,8 +4465,6 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	vpid_sync_context(vmx->vpid);
-	if (init_event)
-		vmx_clear_hlt(vcpu);
 }
 
 static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
-- 
2.32.0.93.g670b81a890-goog

