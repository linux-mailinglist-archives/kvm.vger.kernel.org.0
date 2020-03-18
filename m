Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E68118A0A4
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 17:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727331AbgCRQiW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 12:38:22 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:26306 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727283AbgCRQiW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Mar 2020 12:38:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584549501;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBeZgqbPS2/FWwO6pnXFu0eVYzKmasr03QOYT6AICyE=;
        b=BrvD+qe0hadDO8XJGCEXr3lp7yDQfvpJPVvA7FAoKI3Ykd8UcOCEVoVHHgwpEOODceHnCY
        3NvYQmz15EpUcpFaDGzXjB+YzIklZnvZy/7Ssh9u4YtfpB5g1t0F8NkIRn8WH1d7xEwdUc
        /EkgbnNKFeoxwvFXbYp1AfZooc7txig=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-243-mhX1i9EGNiOf3JUKdTmjYw-1; Wed, 18 Mar 2020 12:38:19 -0400
X-MC-Unique: mhX1i9EGNiOf3JUKdTmjYw-1
Received: by mail-wr1-f69.google.com with SMTP id v7so3185403wrp.0
        for <kvm@vger.kernel.org>; Wed, 18 Mar 2020 09:38:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mBeZgqbPS2/FWwO6pnXFu0eVYzKmasr03QOYT6AICyE=;
        b=C6X9az2HBkUEwH6dz1bBz9LlO2QwwIe94xgTU+uxPiJvH9aFqZVderFQHqWlh1hURJ
         8AkLNAZqMLE1vm/ieWBg4IOOSufk2Rfqa7p0yZ2c2+VxRCnl4ei2pWAUdNZIq7BUGa0J
         FFFVvmf9jDSr+NuUIw+iyYYlNDJh2wiX45xzRAoTq7MlCId9xKGrk7zZuCaT2PdOLEIB
         pWg4X2XEo6wacm4H9now/hmO3s7yEq4luleVAyBdEx2LUYELTMEG8pzY74de991YSch6
         H1RBMx0wlZvA+CnAD4zGxlNyYPxQlFHWFkOyhzFpxcmJtynlXTwvzm7don9zCVvcHH1Q
         FvUA==
X-Gm-Message-State: ANhLgQ0gKiiAGNeULpEYmxnyFidAJSeIVoVG/mwpUMQbpTWz4WIbevOc
        8yOXxcM38IaNGr1106zQ1/89vmkOCeWODYUMCxfGnjyEpg8LibqAmRrNyIIB4LBQclSu2gP7+D+
        CImL7jfz51OVK
X-Received: by 2002:a1c:1b0e:: with SMTP id b14mr6026854wmb.8.1584549498512;
        Wed, 18 Mar 2020 09:38:18 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtMbNQOZ8x4s2gAGCZo/Ub+NqkNSMuzSEwLKiCLLTztaQdqlgzxMsvPJzHW3MD5qsvUjUfoVQ==
X-Received: by 2002:a1c:1b0e:: with SMTP id b14mr6026767wmb.8.1584549497366;
        Wed, 18 Mar 2020 09:38:17 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id v26sm9889715wra.7.2020.03.18.09.38.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2020 09:38:16 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v7 08/14] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Wed, 18 Mar 2020 12:37:14 -0400
Message-Id: <20200318163720.93929-9-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200318163720.93929-1-peterx@redhat.com>
References: <20200318163720.93929-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't clear the dirty bitmap before because KVM_GET_DIRTY_LOG will
clear it for us before copying the dirty log onto it.  However we'd
still better to clear it explicitly instead of assuming the kernel
will always do it for us.

More importantly, in the upcoming dirty ring tests we'll start to
fetch dirty pages from a ring buffer, so no one is going to clear the
dirty bitmap for us.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 752ec158ac59..6a8275a22861 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -195,7 +195,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 				    page);
 		}
 
-		if (test_bit_le(page, bmap)) {
+		if (test_and_clear_bit_le(page, bmap)) {
 			host_dirty_count++;
 			/*
 			 * If the bit is set, the value written onto
-- 
2.24.1

