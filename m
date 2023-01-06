Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E919965F8F7
	for <lists+kvm@lfdr.de>; Fri,  6 Jan 2023 02:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbjAFBR3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 20:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjAFBQa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 20:16:30 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FE965AF4
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 17:14:23 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id v9-20020a259d89000000b007b515f139e0so397491ybp.17
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 17:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=0PXIy8RA30k82n5MqadBULMYpw3jcQQNxAI0MLkfm2o=;
        b=ARYzhqPubKAcUMlq5dSBX0xvRbkdMD3Z7If0ag7prbjxIne2GkJ8lAhHrtaEOpMtq7
         wIIAhYz1/Ajx9d5Cslo0C4NAiwSy8WApA2ndyhaXFs6IngyBWHUw8/RvgrKmAvHUhpkO
         cyOgu6KCI3mBFPHHb5Py5lPdjDvIYKL4PgTbXDJoeb9G5AmvTkBPp7JhJ96D5XJeOmNF
         H71WGUwe4Z9AK+ykt/tiEyDRK2He33wLTdGnjX2xFBC78IVPGeo7k2WIXLG0DcCUuoTc
         xxOGpURmrBMBR/Kj4dorDzcHumIWTMXaSANO4lHr0MkNbDkcual08RTxiy0tgP3OCVKT
         4hUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0PXIy8RA30k82n5MqadBULMYpw3jcQQNxAI0MLkfm2o=;
        b=1s7/ZIcTk3+KT+VAJJpItSGDByS+6cCMUHD0QXwT8HmnW1C043VfYoensHZhaSwUm1
         DeKjFXb5C3UCuBCnSDKuUjblONCa2GzjyWWYKJ4enjKimNvMG7ESX+ZXbn1BH/6N13lz
         /wwzxMn9dmT6XqkZASQ9cUZKBeNi3thhxhhonWzsfGj1m5TiH1/0DAt67t/Zr5+9myKx
         iSMb095+MgS9Q9pNokxBQ7hFLViSrmCz03CqVzdcZf7ljDHZNssImpuNWiwvothcgunF
         Vk1CTgB1PKGQG4Gl8gKImLRg7qQIIZ+/LC6RC6su97phVy2ImBSW4Al1DA0o0e3t1VxX
         FyIg==
X-Gm-Message-State: AFqh2kp6iqrE8oGCze3j2As8rXILqwfXeLpeRf79N56tYPmZanLYYfRB
        Isy9kGVlYeCdwHIOLdbswTaL8fGukOQ=
X-Google-Smtp-Source: AMrXdXt4VBg4zaH9HqqIlH27H/G6sq0m1dLXG6txeQ75uTMkvGpBIpTSTbajtVV7xXJrKV//LkmnjgWpK6g=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d095:0:b0:7b6:daae:ad50 with SMTP id
 h143-20020a25d095000000b007b6daaead50mr235713ybg.89.1672967643231; Thu, 05
 Jan 2023 17:14:03 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  6 Jan 2023 01:13:02 +0000
In-Reply-To: <20230106011306.85230-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230106011306.85230-1-seanjc@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230106011306.85230-30-seanjc@google.com>
Subject: [PATCH v5 29/33] KVM: SVM: Ignore writes to Remote Read Data on AVIC
 write traps
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>,
        Greg Edwards <gedwards@ddn.com>
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
index 2c6737f72bd4..ff08732469cb 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -628,6 +628,9 @@ static int avic_unaccel_trap_write(struct kvm_vcpu *vcpu)
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
2.39.0.314.g84b9a713c41-goog

