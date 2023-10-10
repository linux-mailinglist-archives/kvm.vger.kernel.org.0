Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 057737BFF2A
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 16:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233088AbjJJO0B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 10:26:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233080AbjJJOZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 10:25:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724B5A9
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696947911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TApefxjm2WEaxEHFO8rc1HF2nVhBHdzR5dt4+KLCQJ0=;
        b=N4sccOY9txyP4BwSWUyFvepDbmkEI1otVnzfIKLJQUJa/vUdzwgc1yDOqA3zKC+Bgaopx8
        IY1ulwBPw9gSmk0FBhsuFfbg2ELqySo5pMMc+Gpl8K5gXbk2JjD1EoKc2pf7+QZwWCNTJf
        Ysc71pJ+77LPJRjM7KVryH1VkDg6884=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-622-tPeLB-doNmavXo4SrMnqTw-1; Tue, 10 Oct 2023 10:25:02 -0400
X-MC-Unique: tPeLB-doNmavXo4SrMnqTw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BB18581DA0F;
        Tue, 10 Oct 2023 14:25:00 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0DDF21CAC76;
        Tue, 10 Oct 2023 14:24:59 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Gavin Shan <gshan@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 3/3] arm/kvm: convert to read_sys_reg64
Date:   Tue, 10 Oct 2023 16:24:53 +0200
Message-ID: <20231010142453.224369-4-cohuck@redhat.com>
In-Reply-To: <20231010142453.224369-1-cohuck@redhat.com>
References: <20231010142453.224369-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We can use read_sys_reg64 to get the SVE_VLS register instead of
calling GET_ONE_REG directly.

Suggested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 target/arm/kvm64.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
index 558c0b88dd69..d40c89a84752 100644
--- a/target/arm/kvm64.c
+++ b/target/arm/kvm64.c
@@ -500,10 +500,6 @@ uint32_t kvm_arm_sve_get_vls(CPUState *cs)
             .target = -1,
             .features[0] = (1 << KVM_ARM_VCPU_SVE),
         };
-        struct kvm_one_reg reg = {
-            .id = KVM_REG_ARM64_SVE_VLS,
-            .addr = (uint64_t)&vls[0],
-        };
         int fdarray[3], ret;
 
         probed = true;
@@ -512,7 +508,7 @@ uint32_t kvm_arm_sve_get_vls(CPUState *cs)
             error_report("failed to create scratch VCPU with SVE enabled");
             abort();
         }
-        ret = ioctl(fdarray[2], KVM_GET_ONE_REG, &reg);
+        ret = read_sys_reg64(fdarray[2], &vls[0], KVM_REG_ARM64_SVE_VLS);
         kvm_arm_destroy_scratch_host_vcpu(fdarray);
         if (ret) {
             error_report("failed to get KVM_REG_ARM64_SVE_VLS: %s",
-- 
2.41.0

