Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D234943AC
	for <lists+kvm@lfdr.de>; Thu, 20 Jan 2022 00:09:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357870AbiASXJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Jan 2022 18:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344287AbiASXIR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Jan 2022 18:08:17 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E51C06176A
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:17 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id j28-20020a637a5c000000b00344d66c3c56so2482049pgn.21
        for <kvm@vger.kernel.org>; Wed, 19 Jan 2022 15:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1mwS8UFzPeGHbHB3oNsb9qE1Tl9VmXoGSH+niC6z9fo=;
        b=SnlhlOMX8OV6lr19uJ20DDApqPmv3JqDhwEBgkvu7RY8vwYrrqnKTu5YmrShxQfei3
         XiE0ju5a2v3/RkAtIUT57inttXeESzg2YPZkURkmLe7J4IrqJKCh7fehi657X2Fhyf9M
         7FYWeOy2YjZrv53Q3q7b3RDn0DZCFOqinKdDjXqq+U0uXHQ1NaEeY594vvLhattfijkf
         IfL9aCCcRW8j5z2ayf01yZYoPAhZyrDPfs0rdEfHHrqok2V4XEYLE1mAa0jr3VJKl6ty
         HX7s2uQVDs3cwGtf49WYTC7yEUVkcrhrYztS0r++r3hgqmkE4pI0F1KePHH2EaJ+XdRz
         w9Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=1mwS8UFzPeGHbHB3oNsb9qE1Tl9VmXoGSH+niC6z9fo=;
        b=pyq7zPF+fF1yd/5O5H+nFCKBa9UhzIH2PRGwez9FQVmlqz1/LehL5jolSHIvRoDju+
         XoxNrHSSOWdoO5tCaLOo7BF3Xn8s/TAoZICYYkJETZfBhuB8ARDw8Dkwx7hHyd6EpV8g
         X3WFsAL9tybMPkXpTgBZwXgjQM08D4WkAn0IqY/Upto5zhoU2nBHNywE//xMFsHJ1Cy8
         jJeGV/aAv8pdmhD72YF4UnE1ta+aPT1jxgpbySEe+GKfznyF+1iEbYqL6e/SdPtSPWiH
         wxXjA5mhoAxz+uzZ+WPttLEw28kOQVcKSnGiySvAk4cx7GPwgE/BAeznWspg+rka60NV
         YBDg==
X-Gm-Message-State: AOAM533MziOoRJZCQeUR0rLro7r64A/Rpnw3zIilThyazZfzqI5/fLcg
        Wnv8Z18aSUreOw9iF6kOMLs7YMqGUK00HA==
X-Google-Smtp-Source: ABdhPJyG3e5WSJTPDMLJOh9AIB118lYazD2h2vEPy+XXFKnesLILNWoLQYBFQ0qo4wdcWg6RT65Iy1BxLni5xQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a17:902:6a89:b0:149:732e:d335 with SMTP
 id n9-20020a1709026a8900b00149732ed335mr35509433plk.136.1642633697066; Wed,
 19 Jan 2022 15:08:17 -0800 (PST)
Date:   Wed, 19 Jan 2022 23:07:39 +0000
In-Reply-To: <20220119230739.2234394-1-dmatlack@google.com>
Message-Id: <20220119230739.2234394-19-dmatlack@google.com>
Mime-Version: 1.0
References: <20220119230739.2234394-1-dmatlack@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH v2 18/18] KVM: selftests: Add an option to disable
 MANUAL_PROTECT_ENABLE and INITIALLY_SET
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        "Nikunj A . Dadhania" <nikunj@amd.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an option to dirty_log_perf_test.c to disable
KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE and KVM_DIRTY_LOG_INITIALLY_SET so
the legacy dirty logging code path can be tested.

Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/kvm/dirty_log_perf_test.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
index 1954b964d1cf..101759ac93a4 100644
--- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
@@ -298,12 +298,18 @@ static void run_test(enum vm_guest_mode mode, void *arg)
 static void help(char *name)
 {
 	puts("");
-	printf("usage: %s [-h] [-i iterations] [-p offset] "
+	printf("usage: %s [-h] [-i iterations] [-p offset] [-g]"
 	       "[-m mode] [-b vcpu bytes] [-v vcpus] [-o] [-s mem type]"
 	       "[-x memslots]\n", name);
 	puts("");
 	printf(" -i: specify iteration counts (default: %"PRIu64")\n",
 	       TEST_HOST_LOOP_N);
+	printf(" -g: Do not enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2. This\n"
+	       "     makes KVM_GET_DIRTY_LOG clear the dirty log (i.e.\n"
+	       "     KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE is not enabled)\n"
+	       "     and writes will be tracked as soon as dirty logging is\n"
+	       "     enabled on the memslot (i.e. KVM_DIRTY_LOG_INITIALLY_SET\n"
+	       "     is not enabled).\n");
 	printf(" -p: specify guest physical test memory offset\n"
 	       "     Warning: a low offset can conflict with the loaded test code.\n");
 	guest_modes_help();
@@ -343,8 +349,11 @@ int main(int argc, char *argv[])
 
 	guest_modes_append_default();
 
-	while ((opt = getopt(argc, argv, "hi:p:m:b:f:v:os:x:")) != -1) {
+	while ((opt = getopt(argc, argv, "ghi:p:m:b:f:v:os:x:")) != -1) {
 		switch (opt) {
+		case 'g':
+			dirty_log_manual_caps = 0;
+			break;
 		case 'i':
 			p.iterations = atoi(optarg);
 			break;
-- 
2.35.0.rc0.227.g00780c9af4-goog

