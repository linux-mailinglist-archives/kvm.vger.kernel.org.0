Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB185F17C0
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbiJABAE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232820AbiJAA7n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 20:59:43 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE7801AF93F
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:29 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id h62-20020a636c41000000b0043cc1874c79so3671485pgc.5
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 17:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=8hjNN4ZUEN5yzik4GPF3QAZ7pjpHHwe9e1YFPhWs1LA=;
        b=SIdS+5vPcTQNjxx4yGp9zInt5YLI9mNbsajk/Kjz6DaKHbUcbWXpnWO+4xcrAF+FKX
         0rWyTzutNFnlzc6Wjdjd7CA9UB5BXFmvU1l9NzrkfUPULK2cToPuD2s1b/y8BnHgTU44
         5lBIEOXG9r6aJDOT5CRSS3r2daKqbe1w99hLwrYNvm8K5yLYxsMYqt7DLRk7eOoW4D3r
         cokAGbNfnrauW2Ybi1ge9WXGNwOZGj5Z+Cj61Htd1CGlgL7d3EVTMnCQaKAMIFfuI9aI
         KXM+URI4SopAbSbrEQfG7Oj4eg/6+VgVLUApEVFTtsizjGt97K91FEYbrdRg9+bwJ7tE
         iLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=8hjNN4ZUEN5yzik4GPF3QAZ7pjpHHwe9e1YFPhWs1LA=;
        b=nHIvOUw6x5bjyXgpLUk/Fe7ySS3oJg6AaKk8HWrA3Top168OdXnx2GkVbLfOzNh5Kd
         2CkcBTvEKwv4IKmui3EWalgO9TYMjC1LXQMkpIE2mWQslVf7EfXeUq+ma/y6OpM0X4tp
         OjiZbuPlejppoTktZQD8iuz8HuhfLeOAN0YYfy1fp3eWdYDN81V7RkNKDSPDWzSlYtsE
         9+0PeLtY46k5SRJPLvlvwWm181fwPaMPWtQHewbKJpCpWgjpBnisUKI/29H7s37KHR9u
         YPDt37xNnzN3S3Re28pokCjpqXUBSqb/I9DmYGoP9AzC8DVqlB70goBheg3nIgn9nS0L
         f/ZQ==
X-Gm-Message-State: ACrzQf2hnVhZoyo5OrPc60llRbbC9dVyXPt0Suagakkts3UJuux7j4O5
        VzA76qgixdRzguXTPzq6SmPlzrySr8o=
X-Google-Smtp-Source: AMsMyM5Kh33iYKUenf6bs7uDWTk/lZmL5SkrwARVzir64Qx02mDoVhzCQO8zCsKQBcJyQ14l13qBAjtWaAw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:cccc:b0:178:a9b3:43e6 with SMTP id
 z12-20020a170902cccc00b00178a9b343e6mr11264194ple.92.1664585968932; Fri, 30
 Sep 2022 17:59:28 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:58:49 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-7-seanjc@google.com>
Subject: [PATCH v4 06/32] KVM: x86: Track xAPIC ID only on userspace SET,
 _after_ vAPIC is updated
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Track potential changes to a vCPU's xAPIC ID only for KVM_SET_LAPIC, i.e.
not for KVM_GET_LAPIC, and process the update after the incoming state
provided by userspace is copied to KVM's in-kernel vAPIC.  The latter bug
is the most problematic issue, as processing the update before KVM's
vAPIC is actually updated can result in false positives, e.g. due to the
APIC holding an x2APIC ID (wrong format), and false negatives, e.g. due
to KVM failing to detect an xAPIC ID "mismatch".

Processing an "update" in KVM_GET_LAPIC is likely a benign bug now that
the update helper ignores mismatches, but prior to that fix, invoking
KVM_GET_LAPIC while the APIC is disabled could effectively cause KVM to
consume stale state, e.g. if the APIC were in x2APIC mode before being
hardware disabled.

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Reported-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 67260f7ce43a..251856ba0750 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2720,8 +2720,6 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
 			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 		}
-	} else {
-		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
 	}
 
 	return 0;
@@ -2757,6 +2755,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	}
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
+	if (!apic_x2apic_mode(vcpu->arch.apic))
+		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
+
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	kvm_recalculate_apic_map(vcpu->kvm);
 	kvm_apic_set_version(vcpu);
-- 
2.38.0.rc1.362.ged0d419d3c-goog

