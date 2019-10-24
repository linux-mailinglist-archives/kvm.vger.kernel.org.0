Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0522CE24A1
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 22:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391687AbfJWUcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Oct 2019 16:32:24 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:39517 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388677AbfJWUcY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Oct 2019 16:32:24 -0400
Received: by mail-pf1-f202.google.com with SMTP id b13so17090295pfp.6
        for <kvm@vger.kernel.org>; Wed, 23 Oct 2019 13:32:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=txjVxphi0JgMAhiXdu45Aboz+iV2caaNMJ4JRuuqpxE=;
        b=MDqELEo47/NaPNHQuqgkxJrOLAaVgO0yban7wY336qIsboI0+z5rOubRTnm3MnPffx
         0S0PN/N3RvgLK0s1XCK0FzBdTwHukXA6G0DEuC3FqHD2m981ZJEaV5Xif4xi4azuJlsS
         WRTLIho9mwz2E25N5SvZT5a9PATbZc/K7etAny1V8AsfUSfnj0sDOLsRGn050APUeK+2
         zbJExbp4Hy41U4wQVvHMIEzlpqyCOGPT5++0MTcMK6eRXnJdngsFP6x6AqmEZN5kyIyR
         7XBMtyBu8GlAJLUECGog5xBTbn/bfBUrFtX/6mLZkYTW2i/jCqKJs1tx8HwLYxxuT1BP
         7xpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=txjVxphi0JgMAhiXdu45Aboz+iV2caaNMJ4JRuuqpxE=;
        b=YUUm3KT1/Umrl7i3Z3CYXaosWX3P2h4ERcyQqLw4sJA0A7/rJoX5kcxx6ndatJc+Hj
         ccfFRVqRAJ3AbFlxXVvt4wSIysbkVPXH+Isz9TXuoy7s8PSauiyt+1zcAUlgqB2H+GYq
         rg1/JydOxpsuuVM97y6MnSj/Xt0p5oFmKCCz6CaTn/xE3Fb8nExNVzMkq31QGqqafna5
         TTyV9RdhlQr2J1qrrYTZllAxFwWH77e4PxgnZ988fFpUeTR3M365xJvxfAZ9myl04ksX
         VcGiyuugJESjIcRzlyiSwBiT1u+t0AfNfd7EGhPdB8zwjMNjb8EKirK+vwFQY1X/ETlq
         BQ0Q==
X-Gm-Message-State: APjAAAXzt58LZBBOocmv3ELiDV7BeTSPV9fuQqx7eqOI2/I1YMIlCQGR
        cYjwGA+7llCja25AmHu+dzP3QFKkpYt/D65stj763SC7L16LNJXLXB3P5IA231AseqsZPkD6Bqg
        3IwXzgCDm5KSns0ZI2kBAyRqh1FFtN5n6yj1sCOYgeeEvnAdBgIkVofiHHylnOhs=
X-Google-Smtp-Source: APXvYqx+xU0D9wXKBzKqRj8NkoyW4D9BV8hhAJgwCufWVNS/RVGae6b5w0uGKo6OJd6J8PtxS58t3BLowMNmtw==
X-Received: by 2002:a63:5d04:: with SMTP id r4mr8975223pgb.22.1571862743209;
 Wed, 23 Oct 2019 13:32:23 -0700 (PDT)
Date:   Wed, 23 Oct 2019 13:32:14 -0700
Message-Id: <20191023203214.93252-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2] kvm: call kvm_arch_destroy_vm if vm creation fails
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     John Sperbeck <jsperbeck@google.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: John Sperbeck <jsperbeck@google.com>

In kvm_create_vm(), if we've successfully called kvm_arch_init_vm(), but
then fail later in the function, we need to call kvm_arch_destroy_vm()
so that it can do any necessary cleanup (like freeing memory).

Fixes: 44a95dae1d229a ("KVM: x86: Detect and Initialize AVIC support")
Signed-off-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Jim Mattson <jmattson@google.com>
---
 v1 -> v2: Call kvm_arch_destroy_vm before refcount_set
 
 virt/kvm/kvm_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index fd68fbe0a75d2..c1a1cc2aa7a80 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -645,7 +645,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
 
 	r = kvm_arch_init_vm(kvm, type);
 	if (r)
-		goto out_err_no_disable;
+		goto out_err_no_arch_destroy_vm;
 
 	r = hardware_enable_all();
 	if (r)
@@ -697,11 +697,13 @@ static struct kvm *kvm_create_vm(unsigned long type)
 out_err_no_srcu:
 	hardware_disable_all();
 out_err_no_disable:
+	kvm_arch_destroy_vm(kvm);
 	refcount_set(&kvm->users_count, 0);
 	for (i = 0; i < KVM_NR_BUSES; i++)
 		kfree(kvm_get_bus(kvm, i));
 	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++)
 		kvm_free_memslots(kvm, __kvm_memslots(kvm, i));
+out_err_no_arch_destroy_vm:
 	kvm_arch_free_vm(kvm);
 	mmdrop(current->mm);
 	return ERR_PTR(r);
-- 
2.24.0.rc0.303.g954a862665-goog

