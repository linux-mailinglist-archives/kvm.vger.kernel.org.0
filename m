Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FFA4AA273
	for <lists+kvm@lfdr.de>; Fri,  4 Feb 2022 22:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244093AbiBDVmQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Feb 2022 16:42:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243640AbiBDVmO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Feb 2022 16:42:14 -0500
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281F7C061748
        for <kvm@vger.kernel.org>; Fri,  4 Feb 2022 13:42:13 -0800 (PST)
Received: by mail-pj1-x104a.google.com with SMTP id f2-20020a17090a4a8200b001b7dac53bd6so4272619pjh.4
        for <kvm@vger.kernel.org>; Fri, 04 Feb 2022 13:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=TdH95enMzJJtQ2GBUCNs/cXCeWPtOzD0p9PqnB4JpY4=;
        b=e8F5y4+zCpfLkf3ITn/fKXeG/MnU2wzed6XAI/1vnBN0IyKDVi5Ur8Ka4lIs/xw+Ye
         SnJaBqh1ZIvsiZmW4iiyI5f60WVpXtXiGl8RFEw/NdrsIj4zI/Xt6XcZjMEZW5VyBseI
         gQOASiGWEF0K1EyygeBP6iNRzZnIiLQCS3q3Tmr6pnvjXMcIYL1oCRqC5C0bZCAG5hG5
         fWBwYjCZmB84El+8G5WCIFep5LB8G8/Oy78fc/WRDo94hH4J2TyH+8dtk+TeETM3DpBo
         GeDjejtXeSg3ohWAFymxUlnXCwZhWTGVZrl9+nThlTWNpcsljofJJ47WYF2v0yZ5CxFd
         AQmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=TdH95enMzJJtQ2GBUCNs/cXCeWPtOzD0p9PqnB4JpY4=;
        b=ecoH02lOQOt9hMFmfEOPBS5IVlwhNvwW+/cAm8exify0eqQgH7EZrKlKYYU+tDlO+w
         fH4z1nfkRKzwErPv7r2t/Tzaz1I/q8jUUqUF6loSxKiFhOGyTdI9Gcwt6bn9iXM1qew9
         +N1VlYqDvEKabGJkd/CQ3wyAxbnNI5E9QHPMyjWXbBQJMh3YYwBqQk0daEYq4vbZfL3U
         3uJhmbpufhQSPizqhK2GPONasIi4FRl8uZGUCvsNCiGIwjV6gP3aOc9n1wLv4ZkffOQj
         e4OM8E9yhrh+qO3W9Cpb87BG/+LvZTbIpLZOxOYty6sp2yARKEi9U/jN4sNafsejJ9RW
         z7BQ==
X-Gm-Message-State: AOAM530XvtfUrATSzeZg8WJldyrx665gCDk7RmwhD8Po8DITKKlwwq5f
        4RozkmrgIivcXNIWgRcfKgOQ472KmU8=
X-Google-Smtp-Source: ABdhPJwnnfJh8326UurBNxqNtN00zf9kHpWCIxoTekltxMVnjj1SgV8TA0ZRNUkuLuhzB8/J+H0x7OkaQ00=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:6f10:: with SMTP id
 w16mr5054914plk.142.1644010932639; Fri, 04 Feb 2022 13:42:12 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  4 Feb 2022 21:41:57 +0000
In-Reply-To: <20220204214205.3306634-1-seanjc@google.com>
Message-Id: <20220204214205.3306634-4-seanjc@google.com>
Mime-Version: 1.0
References: <20220204214205.3306634-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
Subject: [PATCH 03/11] KVM: x86: Use "raw" APIC register read for handling
 APIC-write VM-Exit
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeng Guang <guang.zeng@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use the "raw" helper to read the vAPIC register after an APIC-write trap
VM-Exit.  Hardware is responsible for vetting the write, and the caller
is responsible for sanitizing the offset.  This is a functional change,
as it means KVM will consume whatever happens to be in the vAPIC page if
the write was dropped by hardware.  But, unless userspace deliberately
wrote garbage into the vAPIC page via KVM_SET_LAPIC, the value should be
zero since it's not writable by the guest.

This aligns common x86 with SVM's AVIC logic, i.e. paves the way for
using the nodecode path to handle APIC-write traps when AVIC is enabled.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index fbce455a9d17..2c88815657a9 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2186,9 +2186,7 @@ EXPORT_SYMBOL_GPL(kvm_lapic_set_eoi);
 /* emulate APIC access in a trap manner */
 void kvm_apic_write_nodecode(struct kvm_vcpu *vcpu, u32 offset)
 {
-	u32 val = 0;
-
-	kvm_lapic_reg_read(vcpu->arch.apic, offset, 4, &val);
+	u32 val = kvm_lapic_get_reg(vcpu->arch.apic, offset);
 
 	/* TODO: optimize to just emulate side effect w/o one more write */
 	kvm_lapic_reg_write(vcpu->arch.apic, offset, val);
-- 
2.35.0.263.gb82422642f-goog

