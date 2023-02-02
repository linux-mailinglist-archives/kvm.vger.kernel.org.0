Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBE0687379
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 03:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbjBBC66 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 21:58:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBBC64 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 21:58:56 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4E02123
        for <kvm@vger.kernel.org>; Wed,  1 Feb 2023 18:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675306676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=HdpU60uGODCiujpdBOsN+Kh+qKnp2UXQWGhbbl0HOEM=;
        b=Cg9+8bOGuS6k8mdvxcI4t/FbpPCRetsQBeD8IAQZF9qVR0dpROEiOxg4zjOuvoh1PRIjb0
        k+bkj664tzIhgXZV4c/sdYvv9oE5elDHm320RxJbxChLirBiZGsNu9j3rfnQgJc9HjgD4r
        vBWMmOBZuialJZLSI9y0BDVvzsa2mKg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-n7rAfGScOdGYNxKU-ZGmOw-1; Wed, 01 Feb 2023 21:57:52 -0500
X-MC-Unique: n7rAfGScOdGYNxKU-ZGmOw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 86E6918E5280;
        Thu,  2 Feb 2023 02:57:52 +0000 (UTC)
Received: from q.redhat.com (unknown [10.66.61.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CB9AF404BEC0;
        Thu,  2 Feb 2023 02:57:49 +0000 (UTC)
From:   shahuang@redhat.com
To:     kvm@vger.kernel.org
Cc:     Shaoqin Huang <shahuang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2] selftests: KVM: Replace optarg with arg in guest_modes_cmdline
Date:   Thu,  2 Feb 2023 10:57:15 +0800
Message-Id: <20230202025716.216323-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Shaoqin Huang <shahuang@redhat.com>

The parameter arg in guest_modes_cmdline not being used now, and the
optarg should be replaced with arg in guest_modes_cmdline.

And this is the chance to change strtoul() to atoi_non_negative(), since
guest mode ID will never be negative.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>

---
Changes from v1:
  - Change strtoul() to atoi_non_negative(). [Vipin]

---
 tools/testing/selftests/kvm/lib/guest_modes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/lib/guest_modes.c b/tools/testing/selftests/kvm/lib/guest_modes.c
index 99a575bbbc52..1df3ce4b16fd 100644
--- a/tools/testing/selftests/kvm/lib/guest_modes.c
+++ b/tools/testing/selftests/kvm/lib/guest_modes.c
@@ -127,7 +127,7 @@ void guest_modes_cmdline(const char *arg)
 		mode_selected = true;
 	}
 
-	mode = strtoul(optarg, NULL, 10);
+	mode = atoi_non_negative("Guest mode ID", arg);
 	TEST_ASSERT(mode < NUM_VM_MODES, "Guest mode ID %d too big", mode);
 	guest_modes[mode].enabled = true;
 }
-- 
2.39.0

