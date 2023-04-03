Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9FA6D4375
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 13:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjDCL1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 07:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjDCL1R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 07:27:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D745BAD
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 04:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680521189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KjvQo++GUpRsiqMqaOkdEqUBea6legc//2a0ZWxAXCI=;
        b=T8/svauPLC4zffvtK61RVOLAHrLE09Hso8ZV9+PDoXegIxeKc+dP4N08QQaJG6fkog++Ct
        uX+w0PkcXVo4leck5VU4J2aELH0l2E+S2YSAXvfuEhhgaN28JCGz4hoZV/CaSzlGoLyVL6
        BxjMpwizZQwN9K8LKj6D6bFq4Ej6yLU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-472-ieWfMVstMUGBHee8vk523Q-1; Mon, 03 Apr 2023 07:26:28 -0400
X-MC-Unique: ieWfMVstMUGBHee8vk523Q-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F9C2185A78F;
        Mon,  3 Apr 2023 11:26:28 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6561DC15BA0;
        Mon,  3 Apr 2023 11:26:27 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [kvm-unit-tests PATCH] ci/cirrus-ci-fedora.yml: Disable the "memory" test in the KVM job
Date:   Mon,  3 Apr 2023 13:26:25 +0200
Message-Id: <20230403112625.63833-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two of the sub-tests are currently failing in the Fedora KVM job
on Cirrus-CI:

FAIL: clflushopt (ABSENT)
FAIL: clwb (ABSENT)

Looks like the features have been marked as disabled in the L0 host,
while the hardware supports them. Since neither VMX nor SVM have
intercept controls for the instructions, KVM has no way to enforce the
guest's CPUID model, so this test is failing now in this environment.
There's not much we can do here except for disabling the test here.

Signed-off-by: Thomas Huth <thuth@redhat.com>
---
 ci/cirrus-ci-fedora.yml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/ci/cirrus-ci-fedora.yml b/ci/cirrus-ci-fedora.yml
index 918c9a36..c83aff46 100644
--- a/ci/cirrus-ci-fedora.yml
+++ b/ci/cirrus-ci-fedora.yml
@@ -35,7 +35,6 @@ fedora_task:
         ioapic
         ioapic-split
         kvmclock_test
-        memory
         pcid-asymmetric
         pcid-disabled
         pcid-enabled
-- 
2.31.1

