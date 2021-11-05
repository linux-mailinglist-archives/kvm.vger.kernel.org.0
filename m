Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226DC445EDB
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 04:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231927AbhKEDwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Nov 2021 23:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231627AbhKEDwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Nov 2021 23:52:38 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79BFC061714;
        Thu,  4 Nov 2021 20:49:59 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id k4so10293684plx.8;
        Thu, 04 Nov 2021 20:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TqMPoo1kUSiUVo3cNnEi6zuytFVpbUMxm1ejQKcH6w4=;
        b=MT/eZTmAae9ZJn80kntiBHYYCu73+UJ3Ob5saGuwItNVGe2giHo7hPAeKx0BS84yCt
         j5istB0R/t7gydVtNEh6zHA9aPLnD0YZBlMu+ptYPbLkp3O18iFki1rwIpa6pxJjMx+k
         Tz2rC/XMN7wyImNy+wI6qMfyFDvkuVxHLDY5Wf2BUK0iZXFBY/aSGQrWhCK6KjT9H3ld
         zVejrImLHAsdxxoyVSBd2BZODLJ8No/91BgwjbU43VfcFuhK4AQNWO0hKZpy2E34mEe0
         1VAiUTXchBtk1N3D7ZYMyv5BIEQJXGt8ogP/0RpZElFPM6+rQUepy6xMATyWI5ISt+ef
         2JEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TqMPoo1kUSiUVo3cNnEi6zuytFVpbUMxm1ejQKcH6w4=;
        b=AURAzWVe0shGNb4CmxAtmM3le1ZXtllclK0KW9LCLBajJFchiM3bXWc3Ssx6tRcD7b
         pj/Vo0WUKa9MEk6p//7lfZ6ceeUaEUUmjJMPoAy1nFk6oP1+qwaW/8IKJ+8gl5/hNqDJ
         x6P6t1P6MzWXgc4xmcA6By5syrrnS1gd+L8YI0s0SYXIb0taXXTP5gyvSpiVxlWBmqy7
         gRWhlDjOCnEXPOlOswuGBMx1ExtNqnYW7sc7CIhsi5xqK3y5tUk8Wk/7AQkb3e8drmx/
         YdYiiL22SW/UnGR1fL1nN8XdUR6G+Lh6dMuTL1eBOIjLY4lRpQD00R6GbNvgF2pTKgmb
         SN+Q==
X-Gm-Message-State: AOAM531lwStKS6cY6jCCVeCO3xA9IgdQ7nIsu+rPCd6mvPD0qrRIJVbZ
        RfeT41pmRtoDPAw/UjV8MWUrH8LwNV0=
X-Google-Smtp-Source: ABdhPJxUczS1Jjov+LBZ0a+AuFZUqmrBdu16zg5YKOREOJRsBUqW3avRPVF6QpQ8tcSHIr29i4tRFw==
X-Received: by 2002:a17:90b:1d0e:: with SMTP id on14mr27195572pjb.119.1636084199359;
        Thu, 04 Nov 2021 20:49:59 -0700 (PDT)
Received: from bobo.ozlabs.ibm.com (60-241-46-56.tpgi.com.au. [60.241.46.56])
        by smtp.gmail.com with ESMTPSA id mi3sm5807412pjb.35.2021.11.04.20.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Nov 2021 20:49:59 -0700 (PDT)
From:   Nicholas Piggin <npiggin@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Nicholas Piggin <npiggin@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: move struct kvm_vcpu * array to the bottom of struct kvm
Date:   Fri,  5 Nov 2021 13:49:49 +1000
Message-Id: <20211105034949.1397997-1-npiggin@gmail.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Increasing the max VCPUs on powerpc makes the kvm_arch member offset
great enough that some assembly breaks due to addressing constants
overflowing field widths.

Moving the vcpus array to the end of struct kvm prevents this from
happening. It has the side benefit that moving the large array out
from the middle of the structure should help keep other commonly
accessed fields in the same or adjacent cache lines.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---

It would next be possible to now make this a dynamically sized array,
and make the KVM_MAX_VCPUS more dynamic, however x86 kvm_svm uses its
own scheme rather than kvm_arch for some reason.

Thanks,
Nick

 include/linux/kvm_host.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0f18df7fe874..78cd9b63a6a5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -553,7 +553,6 @@ struct kvm {
 	struct mutex slots_arch_lock;
 	struct mm_struct *mm; /* userspace tied to this vm */
 	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
-	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 
 	/* Used to wait for completion of MMU notifiers.  */
 	spinlock_t mn_invalidate_lock;
@@ -623,6 +622,9 @@ struct kvm {
 	struct notifier_block pm_notifier;
 #endif
 	char stats_id[KVM_STATS_NAME_SIZE];
+
+	/* This array can be very large, so keep it at the bottom */
+	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
 };
 
 #define kvm_err(fmt, ...) \
-- 
2.23.0

