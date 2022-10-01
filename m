Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D51F25F17EA
	for <lists+kvm@lfdr.de>; Sat,  1 Oct 2022 03:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiJABD1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Sep 2022 21:03:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiJABCe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Sep 2022 21:02:34 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6776C16F873
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:28 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id z7-20020a170903018700b0017835863686so4253865plg.11
        for <kvm@vger.kernel.org>; Fri, 30 Sep 2022 18:00:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=m33xJ9pBizwrUhfQsmYman/PfJNtqiYZN3F07u+sy1s=;
        b=doAqyYMrLEzGmhnjgT6yRYK7FatZK4uscBSQzAbeNRy6MapfWpyqdXnFh3wypzCsOr
         TxoqSN1pxXYXVE9ZgnJD2PS/6pdikSa6RhfSwUtCmulZucCneYFMl1EimC0x9U5NfX9F
         2wMhWUgqLM1l+jWiTllRy8PRAMLyhps/RW7pbgQ9vhby954awA8PF9MzpzudnSjGXJjy
         ewti38RQOPTmHgRWxtymWTcb0W2e0d11sAI5rm4DiuQDCMHdrT1N17ltv+HfwTMDsJGA
         td6n4ndMZwTN2LEnEVXwvtwQKfxUKYAtfBiXtblqS8PsMxGIg/zL85mD54fFctwlWw/t
         pa/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=m33xJ9pBizwrUhfQsmYman/PfJNtqiYZN3F07u+sy1s=;
        b=lstuBxDykDMtMt87sKwinet9Pvb7xxY8StrlD/nXgIDLwa4L75jRP7Z6qv2K5LKXsm
         N4cjdgGT5WW+hh+J+WaVp0RDZGaHMDP0rz7BR7yUcKpk3qv2njHb/1KbstmEOy3yHvp+
         U8IivtLt3Zce3dT/cEKlxSIiwY0fXxB0wiLWc6jCxMyaVIfklPSqLclekFKUQgeJK287
         A3zLXMhu8CnRq6XNJ3h4g8A5lFElBR7RteIRRuck791zRyIl3yYPrcsTbIoN77pfaTD9
         s19IS1QnSbTz0UL970JX/VOLldzoxQ3xBMYDCHT6mqkXaFZBo87t7bLK5r3K4MM39ZCk
         Ht0w==
X-Gm-Message-State: ACrzQf0S5M0f5cHRNwiOP6EsY+BIDAm7rEqpfLmcFYi2PqUIOxvQDUxd
        kFE5eU5fgJ527tCtys4VA1O+BwEowJo=
X-Google-Smtp-Source: AMsMyM7UFxKVxA9e+lSlEe4vjVtsXH9VjJy9Tw0FAaHrLe0l+PQMiOkThtLnqVYDU9iOBTic3GqUzGrzkAQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1c8e:b0:205:783b:fe32 with SMTP id
 oo14-20020a17090b1c8e00b00205783bfe32mr1009086pjb.39.1664586009100; Fri, 30
 Sep 2022 18:00:09 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  1 Oct 2022 00:59:13 +0000
In-Reply-To: <20221001005915.2041642-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221001005915.2041642-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221001005915.2041642-31-seanjc@google.com>
Subject: [PATCH v4 30/32] KVM: SVM: Ignore writes to Remote Read Data on AVIC
 write traps
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
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop writes to APIC_RRR, a.k.a. Remote Read Data Register, on AVIC
unaccelerated write traps.  The register is read-only and isn't emulated
by KVM.  Sending the register through kvm_apic_write_nodecode() will
result in screaming when x2APIC is enabled due to the unexpected failure
to retrieve the MSR (KVM expects that only "legal" accesses will trap).

Fixes: 4d1d7942e36a ("KVM: SVM: Introduce logic to (de)activate x2AVIC mode")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/svm/avic.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 17e64b056e4e..953b1fd14b6d 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -631,6 +631,9 @@ static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
 	case APIC_DFR:
 		avic_handle_dfr_update(vcpu);
 		break;
+	case APIC_RRR:
+		/* Ignore writes to Read Remote Data, it's read-only. */
+		return 1;
 	default:
 		break;
 	}
-- 
2.38.0.rc1.362.ged0d419d3c-goog

