Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 657D25BF150
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231564AbiITXeq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231588AbiITXeP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:34:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F403B796BC
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:42 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id k126-20020a253d84000000b0068bb342010dso3575607yba.1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=xUOdAjq4HghazHAVl8uNVyB4YOKA/waPzXFg86fSMzY=;
        b=GNllrm4L9CZmpMD9pUmTSbbWaQ2LqdS5FhgNQXlKhue1ouCs813O4ecTeppy5hzlD8
         DXlt249g1xAabM9LHj6lHJw1NSEnmBtvT2lrw/qIhnxx6TS57AQ2Ps6gzvHKqOtxemnJ
         pHosztHMSzde6gStbqA+/7DuWZTDzvsxi/MA6RK+b/2cw35l1oqFqcnt+9Evp194dyy7
         Frs3Lt3dM2Z8nnQXyjenPltVU4RhtZ4gZpIorxiAHT1qJenMswhN9md8+CgDl/VEPKiC
         acxyEM9ftA3rcvzVcVaFM4+r+GWYTWyBoqOQO3ccaRpdBmea5lemgrfmgTbzkCqTCt75
         l+zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=xUOdAjq4HghazHAVl8uNVyB4YOKA/waPzXFg86fSMzY=;
        b=lp5j13WuUtW8oZHIYsCmncDnQegBO8hTrsgqyYgriFOETB9AuxpI1q4qkwrvpWxKJr
         78nF7HvVQhX82T+z2VUco2tRE1PMYEpZF6qdoT3ks6pwZz+2PSghfG/9MyeLVv+H5dM6
         4GOY2DXSZFhWOy8w3M1MjKTdQwOMXQ6maQmTnxYwmE7GQ6c/0SabLvc8rQoBc7fhMrKX
         mjmijhUSIsKTE0Amct30I4pwGx0oPH1CWqyzuV15e96ckaX+sfrpKQ1/o5hdytnMzJ3H
         kKvpORAWhlyNNA+c6YhJf5adkWZbtH3+yOZ6oiwYIn1/Jp/yYAZ2iBh8O1OHt6IiaGal
         e2Mg==
X-Gm-Message-State: ACrzQf0W17FwROr/PwGcsqv3Us7RzqjjHUcKzpxmrpfOCTjCIzwXk/tk
        FZMWIRaW0EmI+b+lb8WOofAjBrstRIE=
X-Google-Smtp-Source: AMsMyM4445S/CUA4Jiq0RDx3o58oHuxBMaDY5o5srIKAlusEo6GR3leX7sjWCZQbW23SxbfuEamg6P+BCKc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:4c45:0:b0:345:4178:1805 with SMTP id
 z66-20020a814c45000000b0034541781805mr22344482ywa.114.1663716742852; Tue, 20
 Sep 2022 16:32:22 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 20 Sep 2022 23:31:33 +0000
In-Reply-To: <20220920233134.940511-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220920233134.940511-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220920233134.940511-28-seanjc@google.com>
Subject: [PATCH v3 27/28] KVM: SVM: Ignore writes to Remote Read Data on AVIC
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
2.37.3.968.ga6b4b080e4-goog

