Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85E5A1EA349
	for <lists+kvm@lfdr.de>; Mon,  1 Jun 2020 14:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728103AbgFAMBN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Jun 2020 08:01:13 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24803 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727772AbgFAMAV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Jun 2020 08:00:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591012820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=Xy30+OjpWBHGrOyuSl10nGmcpqXLCAMApAgxUDLE/UoBBFJ4m/mAuw8RGoZ596xcmarrSc
        hrovQLcrhKSmQj1rrWg3FMA9u9huwsvBXCr48g+d9evOg+uhOF1WiPhwCPmgjqtAIVRhJw
        5rCNubr2+CEjT4cptnZKJ+lCFk0rH8s=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-Po1TgslEPC6PRi5L2y7-xw-1; Mon, 01 Jun 2020 08:00:18 -0400
X-MC-Unique: Po1TgslEPC6PRi5L2y7-xw-1
Received: by mail-qv1-f70.google.com with SMTP id w3so8346936qvl.9
        for <kvm@vger.kernel.org>; Mon, 01 Jun 2020 05:00:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=jIks+Ih/kkCcTZ5/nismfN3Me6r908rPUWWYQTske4Iw9W7W8f5AssadBR5Z6wCITj
         xpg4p3+/+jA7EDhRnqfwnrhO1EHcFAe1xYGML7gLdEZjHAJRE/5GASvg/JRPyoX4cjNT
         mYqqu0byu6z3SKb9Z2qgqH6tLF5ZD5QTNhOA4uol0G5+/Yi7Xo1kJGK1p00SktjHEag2
         DQvOQyCFwcBh3K7Xsm/XCmQ82g8nvg92Me3hNglrC671iOus62BvvihuviFmGnEq/7mU
         D6fZC3sVWVAbyRNuqIt5IwKgjVizLb/5rnltr8DLoaj7SHN7VbVnO5JkmVufKj4xtz2m
         3OIA==
X-Gm-Message-State: AOAM532/34RjhwFKRYmpwW/p/hHbcVkVnblT/huVGvj5MBA8ec68lClW
        vK7cyIipdXt+of7yi4q5Gd1T9I7PV+tmikNdqBEZYyjG3e6GUM4BVs7YbKjV6fEVfVKo25cvjX2
        qSUIvZTE2cUo+
X-Received: by 2002:a37:812:: with SMTP id 18mr20383585qki.296.1591012818016;
        Mon, 01 Jun 2020 05:00:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzl3klJycwFuEZEHpAXxHeBS9I7YZxgbj0iq08iHaZTYo1YjLTWu1gRzD+mC6kfDz211XgKFA==
X-Received: by 2002:a37:812:: with SMTP id 18mr20383551qki.296.1591012817625;
        Mon, 01 Jun 2020 05:00:17 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id l9sm14474185qki.90.2020.06.01.05.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2020 05:00:16 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: [PATCH v10 08/14] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Mon,  1 Jun 2020 07:59:51 -0400
Message-Id: <20200601115957.1581250-9-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601115957.1581250-1-peterx@redhat.com>
References: <20200601115957.1581250-1-peterx@redhat.com>
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

Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.26.2

