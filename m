Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13EE04F8B78
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 02:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiDHAnj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 20:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233053AbiDHAne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 20:43:34 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F23E176D06
        for <kvm@vger.kernel.org>; Thu,  7 Apr 2022 17:41:32 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id m3-20020a633f03000000b00385d8711757so3873827pga.14
        for <kvm@vger.kernel.org>; Thu, 07 Apr 2022 17:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gARM1z8TWPcLta8zngl9X4Eb51iL3uDEv2L7Sujnzmc=;
        b=fw0w/2HTVE3GHwYT1kKkJB7GGiQbxbK9jPoy5eWfwEScRi0F0XDRRYUhcnPlZ/PSoi
         WY+2sNSJC2ulW6fEg9q4lijTezcdTH0uVN9GxUZxP9rhLf2LFJl8tw4nAV/fN/0tHoiP
         ghyC34QypLmnPRiEVcckksMmnDFrzt19JZjE566PTMCPd6IbrTXCAhN9pSH4/d7ncPnL
         zEU6m1GWInfU1cMZ/EN056sjlcONS2cKuviDNJ3kzwZib5Mtu9aaXVoL5jaHFNjAIR+v
         Oiju7dlEh2c+CJRn/LmPNijfh7XJ8R+FSxj/LMoFbteb9iFeJE66Jo7O3NsR2uxRCEXd
         ESIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gARM1z8TWPcLta8zngl9X4Eb51iL3uDEv2L7Sujnzmc=;
        b=Nsvrkcq5AQ77lb8olVX3xxkTPVPCeL9hNJlQQ19ZCuNeCGsheDN/YLfnVYciTRwCRH
         67hFFCFihWmsWXfkPe9q6PY3GaaNyabCcFIqvFlrMWjtOUSuGEKkNR6WmeK56czWJp8l
         BZ0mNjcZ0TJNByGmxhyT+OoW3JbUIEr/W+KG9B2+NTaMQSgtFbb8kdgw8iCnsycLZgzf
         FZwpeSl8YylKzQG9n2yM8oExOsv4TbMueIdNUJuixldGIUO9hK5p4ff6kmh3GPtxDXT7
         6NKuS1I9ESSHA6F9fChyRSe+0iQjABShn/YQx+/fwSY0keiLP0pRzVv6YZ2XZYs23U5z
         NRYA==
X-Gm-Message-State: AOAM533dkwknWc183ejUYUT/vyFYN+p8FSi3FgFyIROj5f8vYXjL/8py
        wi7rovB/lmfALG32VxQqYKuRLq3YRZNkN3TZdSohTZOlCfpbghrP2487QWZm2z8CfSMSEtChZAM
        56E/4WLHcBslBJkz62CsiX25hs0RQIbQkFvUuR03XXBUQ7AHCIAO/VS/9CcHqCyk=
X-Google-Smtp-Source: ABdhPJzRgN+sMT9MhT0Mu86l71agS8/aGmuvBBJg8sMMx2/UHmcc2ZsWJo6jNZwn4d6Nf44QLSwyUyjz26442A==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:db48:b0:1ca:ab67:d75 with SMTP id
 u8-20020a17090adb4800b001caab670d75mr36135pjx.1.1649378491209; Thu, 07 Apr
 2022 17:41:31 -0700 (PDT)
Date:   Thu,  7 Apr 2022 17:41:12 -0700
In-Reply-To: <20220408004120.1969099-1-ricarkol@google.com>
Message-Id: <20220408004120.1969099-6-ricarkol@google.com>
Mime-Version: 1.0
References: <20220408004120.1969099-1-ricarkol@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v3 05/13] KVM: selftests: Add missing close and munmap in __vm_mem_region_delete
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com
Cc:     pbonzini@redhat.com, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, oupton@google.com, reijiw@google.com,
        rananta@google.com, bgardon@google.com, axelrasmussen@google.com,
        Ricardo Koller <ricarkol@google.com>
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

Deleting a memslot (when freeing a VM) is not closing the backing fd,
nor it's unmapping the alias mapping. Fix by adding the missing close
and munmap.

Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 tools/testing/selftests/kvm/lib/kvm_util.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
index e18f1c93e4b4..268ad3d75fe2 100644
--- a/tools/testing/selftests/kvm/lib/kvm_util.c
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c
@@ -679,6 +679,12 @@ static void __vm_mem_region_delete(struct kvm_vm *vm,
 	sparsebit_free(&region->unused_phy_pages);
 	ret = munmap(region->mmap_start, region->mmap_size);
 	TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+	if (region->fd >= 0) {
+		/* There's an extra map shen using shared memory. */
+		ret = munmap(region->mmap_alias, region->mmap_size);
+		TEST_ASSERT(ret == 0, "munmap failed, rc: %i errno: %i", ret, errno);
+		close(region->fd);
+	}
 
 	free(region);
 }
-- 
2.35.1.1178.g4f1659d476-goog

