Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8402F1DFB77
	for <lists+kvm@lfdr.de>; Sun, 24 May 2020 00:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388263AbgEWW5b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 23 May 2020 18:57:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:47036 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2388241AbgEWW53 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 23 May 2020 18:57:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590274647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=LEIg3Q09+ZkJkC8nDipaFnoZKQLw8J2dz4Z8mIORqVzUfg13j5cOSKaSBuLv+SrR5JakpV
        DmO8vXDxxbm0twTa1DbCyyS9/5moh8BH3dMskXnDbzLc8X5kon2O8pxhY52Iu/5rIZ9fcr
        emShSQCdU6N/F1NPw8poeUY1l1hY/08=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-291-REqzb07xNVKn4RBOywBtIA-1; Sat, 23 May 2020 18:57:26 -0400
X-MC-Unique: REqzb07xNVKn4RBOywBtIA-1
Received: by mail-qk1-f199.google.com with SMTP id r124so14843619qkf.1
        for <kvm@vger.kernel.org>; Sat, 23 May 2020 15:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=VrBE0ldeOA4IRU8BthKJOLDcEAwxvoiRYjSGQ/ainTW29lHNBbcU4CvpszSk+gHXyT
         W0z4ieJPG34or2537l5xJ9ql12yzsI+KGvmv/jCENVrWKkZTlNrjW10nBs0YhtivwjFU
         cv2usLoi7jdJ/DSn/AYFOfHagIeGc3adBTEgknOxFyPoc3L9nZsQ07rNbdAcK/woErEE
         h/3pUubw+RpPBZRrk2ZeIBY1SbMkpzIbK9TPlooDPScNwE3dbqeHCKIP61UaNYQpJc6B
         F+w9NbHGIEUTOsJLtBZZ2/krUGMxQT+764lhKspK3Gcpv2SnlVIVdJR58MWXneCC2cak
         IETw==
X-Gm-Message-State: AOAM5315fD4Fmx4kuCJqgTm8BFgKtVtYnpuoCdNS03BhSuf6+RfWbhyj
        /125ckZAjl41HWn7Y1EyEstQN/JL2IHpj6Cp3Mqfzwsm3yoXjPtdDiOvolKBc2omaUZbmNktcbf
        aySut1OPA3VkA
X-Received: by 2002:a05:620a:2019:: with SMTP id c25mr20834524qka.320.1590274646078;
        Sat, 23 May 2020 15:57:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk0/uC8B8a7Tq4U8ojXgv1fjB5zAYPcx4kog7r+EwTz8hARNAN5kGXcMOQMIw85wA3tAKlkQ==
X-Received: by 2002:a05:620a:2019:: with SMTP id c25mr20834511qka.320.1590274645857;
        Sat, 23 May 2020 15:57:25 -0700 (PDT)
Received: from xz-x1.hitronhub.home (CPEf81d0fb19163-CMf81d0fb19160.cpe.net.fido.ca. [72.137.123.47])
        by smtp.gmail.com with ESMTPSA id w14sm11630979qtt.82.2020.05.23.15.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2020 15:57:25 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>, peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Andrew Jones <drjones@redhat.com>
Subject: [PATCH v9 08/14] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Sat, 23 May 2020 18:56:53 -0400
Message-Id: <20200523225659.1027044-9-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200523225659.1027044-1-peterx@redhat.com>
References: <20200523225659.1027044-1-peterx@redhat.com>
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

