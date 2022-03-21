Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 963684E3509
	for <lists+kvm@lfdr.de>; Tue, 22 Mar 2022 01:07:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbiCUXvN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 19:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233558AbiCUXu5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 19:50:57 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7FA18CD31
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:05 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id x9-20020a5b0809000000b00631d9edfb96so13137606ybp.22
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 16:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=vceLiNWOfgM+5bZss9O1SDm7c/HCij832g8/4XdcLhY=;
        b=gOUf58e0daRwmwx8DRK2eUSK5+zZf9GQPSJOfKC67oaYE3xePJFLGmdzaNCesrM9eE
         rEJPaBHcY1L6gbvJz/09zE+1rtp90gQsxFXPgpDGak3SWNV7Wds38W2rjqqpLe0hM56Y
         DDxgBag+C57xsgqih9yYR9isCG1GSWLkDrff1HMjU9JDb+DSq8Q2CtH4ppJl1dY85CLh
         3SfIbroo9mTvlYS4CwdBB6yBzi7bgfGAcE+6JWeehG5eRR6ilb9al2Jqdy4Crv8alUsD
         KjQxttR8idAMjjKExSlWDaeXQfp2p3Cmh4lyvGy9ql/5wwCHX6YycP1/wAB6eHbOiRNT
         GF7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=vceLiNWOfgM+5bZss9O1SDm7c/HCij832g8/4XdcLhY=;
        b=6lQjkitk8EvAKXnF27TsYck1bPV8A+xSfvvH1fpq4xzWJPNsJqYZc0Va/4QhnISYdH
         gRYAXa4PbC50mZ/cXIHkSMRr8u6noKNQL072Z7O9pI771p0TolUjPI/NPJtc84n8dpAb
         89sXI2XssL+1Kz2ynwsQJfI/FH4UjKu1eAXNuXinN5BS3DbA4IJ/t0ykaE7RreCxG0il
         n+AHA/zDyf7VxF5IKGHilCEQ+rkreJ83qJXqwXsQTzmePEom6JNKDptXqmGvoI3F4WU5
         8KJsRp0YXNweRjr/WR4VCbez5mG1qimB2EWi15nTCwwOJuv6O+ielQk4ycxVpSjgJkFd
         Hb0w==
X-Gm-Message-State: AOAM5312VW5izmg3KUOmSM/asjfjKdtOcQ19SzJQAfsX2d2uLynDl2j+
        AX58sxB9uirbc7YMmJw0/7yhdBzt0G8K
X-Google-Smtp-Source: ABdhPJwp6mKWHvC5KkJiAGAUreZqPBolqE6R4CCzsrGMI3tmoNjZ8+PbBAjZu74u75MGdRTrAX4AySpVF8aC
X-Received: from bgardon.sea.corp.google.com ([2620:15c:100:202:b76a:f152:cb5e:5cd2])
 (user=bgardon job=sendgmr) by 2002:a81:784b:0:b0:2e5:9f35:a90f with SMTP id
 t72-20020a81784b000000b002e59f35a90fmr27076925ywc.278.1647906538729; Mon, 21
 Mar 2022 16:48:58 -0700 (PDT)
Date:   Mon, 21 Mar 2022 16:48:36 -0700
In-Reply-To: <20220321234844.1543161-1-bgardon@google.com>
Message-Id: <20220321234844.1543161-4-bgardon@google.com>
Mime-Version: 1.0
References: <20220321234844.1543161-1-bgardon@google.com>
X-Mailer: git-send-email 2.35.1.894.gb6a874cedc-goog
Subject: [PATCH v2 03/11] KVM: selftests: Test reading a single stat
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Retrieve the value of a single stat by name in the binary stats test to
ensure the kvm_util library functions work.

CC: Jing Zhang <jingzhangos@google.com>
Signed-off-by: Ben Gardon <bgardon@google.com>
---
 .../selftests/kvm/include/kvm_util_base.h     |  1 +
 .../selftests/kvm/kvm_binary_stats_test.c     |  3 ++
 tools/testing/selftests/kvm/lib/kvm_util.c    | 53 +++++++++++++++++++
 3 files changed, 57 insertions(+)

diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
index 4783fd1cd4cf..78c4407f36b4 100644
--- a/tools/testing/selftests/kvm/include/kvm_util_base.h
+++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
@@ -402,6 +402,7 @@ void assert_on_unhandled_exception(struct kvm_vm *vm, uint32_t vcpuid);
 int vm_get_stats_fd(struct kvm_vm *vm);
 int vcpu_get_stats_fd(struct kvm_vm *vm, uint32_t vcpuid);
 void dump_vm_stats(struct kvm_vm *vm);
+uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name);
 
 uint32_t guest_get_vcpuid(void);
 
diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
index afc4701ce8dd..97bde355f105 100644
--- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
+++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
@@ -177,6 +177,9 @@ static void vm_stats_test(struct kvm_vm *vm)
 
 	/* Dump VM stats */
 	dump_vm_stats(vm);
+
+	/* Read a single stat. */
+	printf("remote_tlb_flush: %lu\n", vm_get_single_stat(vm, "remote_tlb_flush"));
 }
 
 static void vcpu_stats_test(struct kvm_vm *vm, int vcpu_id)
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index f87df68b150d..9c4574381daa 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -2705,3 +2705,56 @@ void dump_vm_stats(struct kvm_vm *vm)
 	close(stats_fd);
 }
 
+static int vm_get_stat_data(struct kvm_vm *vm, const char *stat_name,
+			    uint64_t **data)
+{
+	struct kvm_stats_desc *stats_desc;
+	struct kvm_stats_header *header;
+	struct kvm_stats_desc *desc;
+	size_t size_desc;
+	int stats_fd;
+	int ret = -EINVAL;
+	int i;
+
+	*data = NULL;
+
+	stats_fd = vm_get_stats_fd(vm);
+
+	header = read_vm_stats_header(stats_fd);
+
+	stats_desc = read_vm_stats_desc(stats_fd, header);
+
+	size_desc = stats_desc_size(header);
+
+	/* Read kvm stats data one by one */
+	for (i = 0; i < header->num_desc; ++i) {
+		desc = (void *)stats_desc + (i * size_desc);
+
+		if (strcmp(desc->name, stat_name))
+			continue;
+
+		ret = read_stat_data(stats_fd, header, desc, data);
+	}
+
+	free(stats_desc);
+	free(header);
+
+	close(stats_fd);
+
+	return ret;
+}
+
+uint64_t vm_get_single_stat(struct kvm_vm *vm, const char *stat_name)
+{
+	uint64_t *data;
+	uint64_t value;
+	int ret;
+
+	ret = vm_get_stat_data(vm, stat_name, &data);
+	TEST_ASSERT(ret == 1, "Stat %s expected to have 1 element, but has %d",
+		    stat_name, ret);
+	value = *data;
+	free(data);
+	return value;
+}
+
-- 
2.35.1.894.gb6a874cedc-goog

