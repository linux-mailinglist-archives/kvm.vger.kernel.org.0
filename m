Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C295F3B0F1F
	for <lists+kvm@lfdr.de>; Tue, 22 Jun 2021 23:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhFVVDZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Jun 2021 17:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhFVVDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Jun 2021 17:03:23 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC21C061766
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:07 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id w1-20020ac87a610000b02902433332a0easo600905qtt.0
        for <kvm@vger.kernel.org>; Tue, 22 Jun 2021 14:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SlZYndtBT6I+KaOifP/wRG5sSQAx1y6ctf87XCjbUJI=;
        b=OenfmcWZhtHt6LoEca8UzQBjCsgMnfErm5RIje7t6rCqEBE/Un126oBBPk3GOugkGS
         9SSn0hZ7gW+8tLjUh7w2N9byuynHj2goV5HbzizODSRjPppWKoL7ykYFJ3oJJKuGVeYO
         rTomsNJmqBKuBWCcAJU77Ngwq44k23Ycdck+aZfAUxLIcQxQSdWVrnVxX1+Dg/XOdZ4u
         STgK9l/znqb3AUnwCUCaL8YuUyCkIIneYaLsTXBVo2nNpPm94X1VLRlnqQ3k7NPIKLP0
         VeMIPsQQdC0KpVS8sI7txAbTGvpzWtyp44cQfCq9leowNShellfeNLHWnYfrbXv7/pj+
         Dsqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SlZYndtBT6I+KaOifP/wRG5sSQAx1y6ctf87XCjbUJI=;
        b=m2lHMq1tGV8jcKpCPUShSky7lscAe78tV5PAkLv2wQnVQtjx/cUiKn+HMlOKsnQgAf
         8oQgtwGaG5goZc09G3Cs8QoMvwgXdiPC/WuCA9dQPh89RdjFtIPPCD0q0xK0ub3uP1eq
         ynCg9UKnYhsM9F4FNbR4B5X0Sx77xb+T6U06y+EeLfZH0OYPA7CKvh70743QLdRiOlX/
         sVi5WNKfFzJjpbwKeaCROsZZS6foaSRpZGWqeSlMMKV4fZYw84l3DAZMx3uCQRAk95PC
         6Rd/Uc+CUP2/tNRlifOB+AXzAdxWdI3ujB4b6WuMYS8ILMTMcUFPLxl/2/zuZVZ9x+06
         sRdA==
X-Gm-Message-State: AOAM53312suChNrRds4Lt7FDvZwKajwHbJvtIWxpkAm0+Ck17FtobSNi
        oQkS7utIkAbHo1UTKqOOQ1OfGqurwDM=
X-Google-Smtp-Source: ABdhPJzWzoOAz1xTZ8FNDkJ7YZkwJPaZ1xvMc8YHE2mavTEllBUlsRXnlrlQ3ODuVuYtsBxKTC3OPd4cFCk=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:7d90:4528:3c45:18fb])
 (user=seanjc job=sendgmr) by 2002:a0c:e18c:: with SMTP id p12mr788183qvl.54.1624395666543;
 Tue, 22 Jun 2021 14:01:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 22 Jun 2021 14:00:42 -0700
In-Reply-To: <20210622210047.3691840-1-seanjc@google.com>
Message-Id: <20210622210047.3691840-8-seanjc@google.com>
Mime-Version: 1.0
References: <20210622210047.3691840-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [kvm-unit-tests PATCH 07/12] nSVM: Remove a superfluous modification
 of guest EFER.NX in NPT NX test
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove a bizarre modification of the guest's EFER.NX from the NPT NX
test.  For reasons unknown, the NPT NX test forces EFER.NX in the guest
_after_ running the test.  Now that the v1 infrastructure saves/restores
guest EFER across the test, the motivation, whatever thay may have been,
is moot because the forced EFER.NX value won't persist.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 x86/svm_tests.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/x86/svm_tests.c b/x86/svm_tests.c
index 96add48..b1783f8 100644
--- a/x86/svm_tests.c
+++ b/x86/svm_tests.c
@@ -718,8 +718,6 @@ static bool npt_nx_check(struct svm_test *test)
 
     *pte &= ~PT64_NX_MASK;
 
-    vmcb->save.efer |= EFER_NX;
-
     return (vmcb->control.exit_code == SVM_EXIT_NPF)
            && (vmcb->control.exit_info_1 == 0x100000015ULL);
 }
-- 
2.32.0.288.g62a8d224e6-goog

