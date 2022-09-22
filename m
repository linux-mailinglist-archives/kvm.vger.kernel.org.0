Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5FA85E5B5A
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 08:25:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbiIVGZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 02:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiIVGZ2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 02:25:28 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFF0B0289
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 23:25:07 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id a16-20020a170902ecd000b001782ec09870so5365111plh.12
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 23:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=4iDTJKECWO4rLxGzUkSO8Tu4v7lUzS0hGoOt1ut+waY=;
        b=ZThArlHV86jb7ZLKTGuuP8Sun6MJjKi6O4E8rRQiC4zgtbAru/Gwg1VKTbuvRAjMrd
         HL6s6tU5RDEKVqYeEPLIKORM8+MQNLBL1boFJ4wzYTbQ+axr7vlfxpbYv6bFx3uBOgdZ
         cc/VREPIcD5zeyF1ztUqitrhwnYAWBLp46BMIfUgsLzYuXJm+eXqEoBzuN1kneb2NPhb
         ncTQI8TzNarOqhSM7cAAmAOX6VqCidv8PjY+yza/9gzxdINAXr75MybfWmS2w1Gh31+x
         JjZIBdmW7SFxZIObthVxQz7bQ0tFs5X95ejRhAsgyg/lfS9JPa0+KlPmNef+p75kmONl
         B9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=4iDTJKECWO4rLxGzUkSO8Tu4v7lUzS0hGoOt1ut+waY=;
        b=TN7V+OPo+f8U1eQASWqg9fIrc5z4USu/wtte0UK3RifWXZD7W7bCNk6bN6bzQWKVK4
         y9d08eq8yUj72bfmgz8XcpC/ecTOvMZkKxE9CMjPv1OsTbjW/kjzE2921CSeu1GtrUAN
         8MBcA9jflEtXlgCaySbh9eYFlQIYLBPmFSF3mQZZRv4fCihbQ4uNLirFdTUl4ZrgawVy
         tjhGsR4PTykiCz91M1u2fx2tShFSguRVjV4D5aBh8NEZXbLPkEWf3N9XYtOkqlWlzkDI
         9ipd+Y2kMf2dW13bzY/wg4EnEiobzezthGfUNKfkodiRdpOhsnuuofCpqWHa4uqhCKLZ
         ho8g==
X-Gm-Message-State: ACrzQf1l7S9CFbtKbsYbVExpQJ81s1WwVVHp6eks3E+FkoA0BZT7eNW8
        yzVrR6pv7dRTFZYCDIBgcYmJzIgUZVR9
X-Google-Smtp-Source: AMsMyM7LkCIJiDXFkMKd8X8V0haWPoZgTq8xxgvoqq74Mp+EE5kjLgQPzc+N/0nicqiKveHP3DDhaU25yaf8
X-Received: from vipin.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:479f])
 (user=vipinsh job=sendgmr) by 2002:a17:90a:64c8:b0:202:6d4a:90f8 with SMTP id
 i8-20020a17090a64c800b002026d4a90f8mr2110134pjm.11.1663827906415; Wed, 21 Sep
 2022 23:25:06 -0700 (PDT)
Date:   Wed, 21 Sep 2022 23:24:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.3.968.ga6b4b080e4-goog
Message-ID: <20220922062451.2927010-1-vipinsh@google.com>
Subject: [PATCH v2] KVM: selftests: Check result in hyperv_features.c test
 only for successful hypercalls
From:   Vipin Sharma <vipinsh@google.com>
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     jmattson@google.com, vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
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

Commit cc5851c6be86 ("KVM: selftests: Use exception fixup for #UD/#GP
Hyper-V MSR/hcall tests") introduced a wrong guest assert in guest_hcall().
It is not checking the successful hypercall results and only checks the result
when a fault happens.

  GUEST_ASSERT_2(!hcall->ud_expected || res == hcall->expect,
                 hcall->expect, res);

Correct the assertion by only checking results of the successful
hypercalls.

This issue was observed when this test started failing after building it
in Clang. Above guest assert statement fails because "res" is not equal
to "hcall->expect" when "hcall->ud_expected" is true. "res" gets some
garbage value in Clang from the RAX register. In GCC, RAX is 0 because
it using RAX for @output_address in the asm statement and resetting it
to 0 before using it as output operand in the same asm statement. Clang
is not using RAX for @output_address.

Load RAX with some default input value so that the compiler cannot
modify it or use it for anything else. This makes sure that KVM is
correctly clearing up return value on successful hypercall and compiler cannot
generate any false positive.

Fixes: cc5851c6be86 ("KVM: selftests: Use exception fixup for #UD/#GP Hyper-V MSR/hcall tests")
Signed-off-by: Vipin Sharma <vipinsh@google.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

---

Jim's Reviewed-by is only for the code change and not shortlog message
of v1. Also, there is one change in asm which was not present in v1 and
not reviewed by Jim. But I am writing his name here so that it is not missed
when patch is merged.

v2:
- Updated the shortlog message.
- Using RAX register in hypercall asm as input operand also and
  initializing it with -EFAULT

v1:
https://lore.kernel.org/lkml/20220921231151.2321058-1-vipinsh@google.com/

 tools/testing/selftests/kvm/x86_64/hyperv_features.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 79ab0152d281..4d55e038c2d7 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -26,7 +26,8 @@ static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
 		     : "=a" (*hv_status),
 		       "+c" (control), "+d" (input_address),
 		       KVM_ASM_SAFE_OUTPUTS(vector)
-		     : [output_address] "r"(output_address)
+		     : [output_address] "r"(output_address),
+		       "a" (-EFAULT)
 		     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
 	return vector;
 }
@@ -81,13 +82,13 @@ static void guest_hcall(vm_vaddr_t pgs_gpa, struct hcall_data *hcall)
 	}
 
 	vector = hypercall(hcall->control, input, output, &res);
-	if (hcall->ud_expected)
+	if (hcall->ud_expected) {
 		GUEST_ASSERT_2(vector == UD_VECTOR, hcall->control, vector);
-	else
+	} else {
 		GUEST_ASSERT_2(!vector, hcall->control, vector);
+		GUEST_ASSERT_2(res == hcall->expect, hcall->expect, res);
+	}
 
-	GUEST_ASSERT_2(!hcall->ud_expected || res == hcall->expect,
-			hcall->expect, res);
 	GUEST_DONE();
 }
 
-- 
2.37.3.968.ga6b4b080e4-goog

