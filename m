Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD1A5ABBB3
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231799AbiICAZK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231612AbiICAYM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:24:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22738111AC4
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:53 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j11-20020a05690212cb00b006454988d225so1054570ybu.10
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=LdiXi7ZmRYWfAPERNLf/gz/Xml73VY2Moq9FlK1+JBc=;
        b=gVjWhAQcAI+bfNHz4uTVmIx3nAkEmZPbWE9B7vVyZy+8Tjn5vubmdisoN87VgqcXAU
         J/ZZFScLpXNbdE9gcLCv4qVgU4wyDTfEQR0rRpYqI4ySU1BJlDWuiEJdpHJQghuT7nC1
         78zCwkkBSnLluOvdD24yDgEGPzjYTqVqZgL8nNUfcpPKtKD2NuIfJXXHV3Q99qZgkfQA
         4AezuVeI6wEX9TexV0/N1o2EOwN9niYMB/rhYN9wZ00jYw3zkePsVEjvy5MrFeJG+pqV
         jTqlCJmphQU3DmJtdw983qzAhF39W+UclFY53a9GNg2fN/6uHQ1AhN+TGVAg/DAKHtpt
         iN1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=LdiXi7ZmRYWfAPERNLf/gz/Xml73VY2Moq9FlK1+JBc=;
        b=v6ZGnZ7lELwytzWAfDLOK2761J2WmslJPQ1dsViQJTsxBmUdPboGA6I1PV8aIEpAGD
         iRb7poQ1wC35LfJLL8C7BaItD00dinfTbah0Njkmdi2l7fT4XN5/60Y463O+gCe4DPS3
         iP+FzJ/KLN/NGrJpMR9kV+cInS7IOZPrurE+CZiXzA3jpnwrZEMNrLD7cU1PFIJwrrbw
         TYxY9ccBrUSqpHn/sAsOTAQEdAsbbPI9U84bxUYINqs/BTWJzrl4czGPNzacnugj7Y+9
         sT8RORFH59TPNLFsXVwBXOda5pcSSkHE4admtP8p2MXPt4X4ecvHwBvxZViWPNY7i2gN
         iqaw==
X-Gm-Message-State: ACgBeo06q4rc5Qe56cpJe3xUUqQ16h7DfKujO0nSqYk+kKTcgRJ5rwGi
        sTYmgZJQSLxKIfd4ngs9Imj2PqdgKsM=
X-Google-Smtp-Source: AA6agR4Wlh7daQ+R0dhwpkQy+xCElmTBe/vKQcUjkr8uz9o2uhmDKQhgDfFFicXMqktQ8vLCwNZ3KrpAEPE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:df92:0:b0:340:b90d:fb75 with SMTP id
 i140-20020a0ddf92000000b00340b90dfb75mr28814158ywe.149.1662164616127; Fri, 02
 Sep 2022 17:23:36 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:53 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-23-seanjc@google.com>
Subject: [PATCH v2 22/23] KVM: SVM: Ignore writes to Remote Read Data on AVIC
 write traps
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
index 39b367a14a8c..17c78051f3ea 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -658,6 +658,9 @@ static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
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
2.37.2.789.g6183377224-goog

