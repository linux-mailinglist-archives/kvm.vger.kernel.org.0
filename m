Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AD7508E88
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 19:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381145AbiDTRiK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 13:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381135AbiDTRiH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 13:38:07 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0A113FB8
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:20 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id m12-20020a170902d18c00b001589ea4e0d6so1203556plb.12
        for <kvm@vger.kernel.org>; Wed, 20 Apr 2022 10:35:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=3hrVtKxiHbpz+NEaukEgKfo35soXVBenGEmfstwEEVg=;
        b=c92/D0tTK6mgxclzC4mkN1Z+Dd4UUec5FITmwETokYfH34YQTRAExgqJy+oRv9Pb4b
         8Ldc2CH8j9nSF0gp0ESyVcrLTmHaTW5PjLbVcz/oN7BPsys5tV812WIkE/UNWy1hPE7Y
         bsi/C7MuVkLPq36Qqrna2QjXXnw2Ry/n9IwElWKuH1NElZ8V/l/4shEQPx8KHe4TxVdK
         ACmcYmLYeulOT57i0J0MnYLGkb9MCL7JjziqLaroH00w4dud63DQ48ZIaksYK1dmFrD1
         m4Pm3IOVa7QG3GBhXfgAhCLvUQMMACNLzeJjuHqu6H32A7dOZd2L8dXcaJBsxLw7W+jw
         h46g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3hrVtKxiHbpz+NEaukEgKfo35soXVBenGEmfstwEEVg=;
        b=qTofSIpPnE7UzaOsWoHfs94qk7CeHHKQi/9TXAMJ3c2z8msNakGuzsGxPLCuLOh8s3
         risv69WGOWOZrFDvlZpPNaxe6O84eUqYUe4ABLUDyL4xjTyQ9qEP74Ub5e1gQTad/+RG
         hajgaBM0huaronKXRjkfY8kHu9R2B3uaXRx1kvoZtIOIq0oK4tG2Om3t3cVnUTG2/rbO
         97GOXgutvR1Su4CfpjN8IyrCpdJLmOdSVZTGxnOTQjiPA+CE2/zG2PnFSxsS4ECgsagp
         lEuNB/YT0zAfHMWFAehXSynIUrOA8Y4T13+RRuzby0VIaUjGELeqXZ2EewOE+9t8pGXo
         t+Gg==
X-Gm-Message-State: AOAM533Zj173bUfmljxMjZTMOOSPGiOU6ZfEdqDn7BxCwciHNycscyM0
        sYgQZdQKj8GL4pxjpkAG88Cnrr3W7JrY
X-Google-Smtp-Source: ABdhPJw7eHr1qhn7c2BfQ+hyrDFgTWTh4w8N0NJRzArOEZocpnHXiaEqecWXU2fQT+mTQNFgzLoKZno2S7x4
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:6ea6:489a:aad6:761c])
 (user=bgardon job=sendgmr) by 2002:a05:6a00:884:b0:4fe:134d:81cc with SMTP id
 q4-20020a056a00088400b004fe134d81ccmr24602772pfj.57.1650476120419; Wed, 20
 Apr 2022 10:35:20 -0700 (PDT)
Date:   Wed, 20 Apr 2022 10:35:05 -0700
In-Reply-To: <20220420173513.1217360-1-bgardon@google.com>
Message-Id: <20220420173513.1217360-3-bgardon@google.com>
Mime-Version: 1.0
References: <20220420173513.1217360-1-bgardon@google.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
Subject: [PATCH v6 02/10] KVM: selftests: Read binary stats header in lib
From:   Ben Gardon <bgardon@google.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>,
        Ben Gardon <bgardon@google.com>
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

Move the code to read the binary stats header to the KVM selftests
library. It will be re-used by other tests to check KVM behavior.

No functional change intended.

Reviewed-by: David Matlack <dmatlack@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 .../selftests/kvm/kvm_binary_stats_test.c     |  4 ++--
 tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++++++
 3 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 92cef0ffb19e..749cded9b157 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -400,6 +400,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
+void read_stats_header(int stats_fd, struct kvm_stats_header *header);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index dad34d8a41fe..fb511b42a03e 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -33,8 +33,8 @@ static void stats_test(int stats_fd)
 	struct kvm_stats_desc *pdesc;
 
 	/* Read kvm stats header */
-	ret = read(stats_fd, &header, sizeof(header));
-	TEST_ASSERT(ret == sizeof(header), "Read stats header");
+	read_stats_header(stats_fd, &header);
+
 	size_desc = sizeof(*stats_desc) + header.name_size;
 
 	/* Read kvm stats id string */
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index 1665a220abcb..1d75d41f92dc 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2556,3 +2556,24 @@ int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid)
 
 	return ioctl(vcpu->fd, KVM_GET_STATS_FD, NULL);
 }
+
+/*
+ * Read binary stats header
+ *
+ * Input Args:
+ *   stats_fd - the file descriptor for the binary stats file from which to read
+ *
+ * Output Args:
+ *   header - a binary stats metadata header to be filled with data
+ *
+ * Return: void
+ *
+ * Read a header for the binary stats interface.
+ */
+void read_stats_header(int stats_fd, struct kvm_stats_header *header)
+{
+	ssize_t ret;
+
+	ret = read(stats_fd, header, sizeof(*header));
+	TEST_ASSERT(ret == sizeof(*header), "Read stats header");
+}
-- 
2.36.0.rc0.470.gd361397f0d-goog

