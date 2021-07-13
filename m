Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1BC3C74F0
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235870AbhGMQio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:38:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234909AbhGMQia (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:38:30 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8652CC06178A
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:50 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id bi3-20020a05620a3183b02903b55bbe1ef9so17391658qkb.13
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=/kobFDO1v5kxfmrecOu9TTYWpLXIpef9EiaYGzHDjPQ=;
        b=gPT/NLx/hKtf2TiWbAi/D/oofKe74s5iRoN0Y2bdIZ3lwZnppiDA0osrA7VY3/M91x
         AhQQK1JCZnN0jw3nhBgB7FiJZVFYCT9JnQ4BXAWhGEpVpUf3fMekheoovaZi78dj0FKw
         xh8UYd0NbDDf4N90irX4TGpk1MKh5fLo/yV/dBf1y/rCO+1lptagV7Ay7Hagh6Mzv7bO
         m2pa5xmKIXIdKs3V+x0KsQEks25FClM+X0oNmuNI/hV3qliSxyVSwvXFe6E2HR748cpg
         MQhKQOZPlr+Sq4p4tbQ8C9MUasRSNpLD540b8+KhTjCnfCYOWymQt2ZX4AVNBkr6vAev
         avnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=/kobFDO1v5kxfmrecOu9TTYWpLXIpef9EiaYGzHDjPQ=;
        b=mmLH/mdWDfQpXlvHoJYM2aMYC9rFZb/tWF/HvnPk1dia4ne2WoxsKz0rKBBUsCwWq9
         OwZZG53NC0wdA21ocHHmnDCA8IhigCUYb1MD+ApdR0/Ui8H27WxQQRwlqcJuENeTXM01
         JeCctj/CP8vKC1yRKEwvOGr8W2HdDoZuTxIO6o9nmKYq4RdJQkfgnMRPqzQPQTYnbuCg
         J+wqSB+6aqLxpTvT5fzLg1cg1B07cUUBXWF8/CSUfetvl1zbfgTEooq84eaXn7xmRaHT
         oynkLICRJDXmQuAF1AFiOR0/PtiH1gzqAVBYb5OjbPYRkTLwBL/ckrdNkzbu+7yRCWqD
         xXIA==
X-Gm-Message-State: AOAM5335/8r0VZ84uv/1Uje5D3k8X61NGjoTjC5zL05nzWVQAL2PpLT7
        VE+bUXwZC0uE7KnUrjKwNN8AG32iUsk=
X-Google-Smtp-Source: ABdhPJwZDspm/v4ErGDdok/nXXI1lMusRSIDGXRWs4DBdv8SnhzOc4vqEiq0Bb16kx2wAN8QYhG6fV2JCiM=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a0c:9e6a:: with SMTP id z42mr5749421qve.37.1626194089669;
 Tue, 13 Jul 2021 09:34:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:17 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-40-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 39/46] KVM: VMX: Don't redo x2APIC MSR bitmaps when
 userspace filter is changed
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

Drop an explicit call to update the x2APIC MSRs when the userspace MSR
filter is modified.  The x2APIC MSRs are deliberately exempt from
userspace filtering.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f605b43d28e1..d5a174ff20f9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3936,7 +3936,6 @@ static void vmx_msr_filter_changed(struct kvm_vcpu *vcpu)
 	}
 
 	pt_update_intercept_for_msr(vcpu);
-	vmx_update_msr_bitmap_x2apic(vcpu, vmx_msr_bitmap_mode(vcpu));
 }
 
 static inline bool kvm_vcpu_trigger_posted_interrupt(struct kvm_vcpu *vcpu,
-- 
2.32.0.93.g670b81a890-goog

