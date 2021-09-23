Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7994167CB
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 00:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234889AbhIWWCT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 18:02:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234737AbhIWWCS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Sep 2021 18:02:18 -0400
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32FDC061574
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 15:00:46 -0700 (PDT)
Received: by mail-io1-xd4a.google.com with SMTP id z14-20020a05660229ce00b005d616a6f35aso7033104ioq.23
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 15:00:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=f7vskvTE1f7g6j1G/9mcc6TBVgiYtYDQe3QIkQtPdlk=;
        b=XEkuJx54Rb2fmI8uJkqiTHQ2tWjkNQ24qlfvw6u7Ob8ElAf3Lc5eSH8CRLzb7f0tSt
         ZaCNiAa9jHEvvVKK+IfYG+plg1XoENH0epLflNzjsNxur8rFNJSS/ChXanxY29UxzBJv
         cDa+dEgx1vFHBYhiRGlvKnvd1C32EcB77qaRUu1Lu8mpZzcOerrElqnb2vyLQlaRDHXy
         a3NiADAsN/uZe4Htb5/PZ2X4NxHuNQ4e6LV5NkkAeGdhv202Ao3kt3KDoh4jSfadsz9v
         ARFJy0qtmIpQOykpuoV0CzdnTYzeH2B5Arb7Qb1mObyLfVqeaN5gQG12Ui+BvPtiiMls
         H7jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=f7vskvTE1f7g6j1G/9mcc6TBVgiYtYDQe3QIkQtPdlk=;
        b=VmhBPTnuuCOqb8jHpP24M7B/TbcTzSZDtpKw9w3UhQiVruyMN2/K5hCn3Oh4kjaL09
         dgbjuH8lR3+HuSd4ax5JG+7xR6pgu8jXzQMqfRBrE7+8XMTzJquFF9CD7SKBMKg1Np+w
         PoQ75btp2HcQfD+V1KPdBDw5FKn4BhLnHBGND0PFZJW0S6fYVqPPUfcgINREvOdHKI5S
         lEpbJ+i2+RkZQ8bb7gZdeF9KeMq23ifHV3yiQPDERo/2HkzigcobxmaafGNeSaopS3C6
         5HV4iHePCOVjNp78r4mJzwtcpPFEejrggBhvmC13jYzcW811rqU/aYKuPBMBue8eMgnn
         605Q==
X-Gm-Message-State: AOAM5336cYqmAv3Ov78pjl1E41PFDtnccQv3gVXTdrg9cHPLZYKBk8JV
        aeLdTAobd0uDFnEl9HWIoBEaB3zi5BChfoYjpbcAQsyLt+K+PI237MmZnntUXxQj0TbgOWIA2Gw
        dNurogq2hRJuB+O54mJqOW0CNCTPT/g/9Ny7MDv5IIlW4x/U7mlpxDHkOPg==
X-Google-Smtp-Source: ABdhPJw7/ZOpW6kzLm/q1fD4TCKb+A42nB2EL3IA5ogaxCUNjeLVhemJc4/cZc2z+VIUYwwPmzi81WOKliM=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a02:6666:: with SMTP id l38mr6063627jaf.146.1632434446142;
 Thu, 23 Sep 2021 15:00:46 -0700 (PDT)
Date:   Thu, 23 Sep 2021 22:00:33 +0000
Message-Id: <20210923220033.4172362-1-oupton@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH] selftests: KVM: Call ucall_init when setting up in rseq_test
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Oliver Upton <oupton@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

While x86 does not require any additional setup to use the ucall
infrastructure, arm64 needs to set up the MMIO address used to signal a
ucall to userspace. rseq_test does not initialize the MMIO address,
resulting in the test spinning indefinitely.

Fix the issue by calling ucall_init() during setup.

Fixes: 61e52f1630f5 ("KVM: selftests: Add a test for KVM_RUN+rseq to detect task migration bugs")
Signed-off-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/rseq_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/kvm/rseq_test.c b/tools/testing/selftests/kvm/rseq_test.c
index 060538bd405a..c5e0dd664a7b 100644
--- a/tools/testing/selftests/kvm/rseq_test.c
+++ b/tools/testing/selftests/kvm/rseq_test.c
@@ -180,6 +180,7 @@ int main(int argc, char *argv[])
 	 * CPU affinity.
 	 */
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
+	ucall_init(vm, NULL);
 
 	pthread_create(&migration_thread, NULL, migration_worker, 0);
 
-- 
2.33.0.685.g46640cef36-goog

