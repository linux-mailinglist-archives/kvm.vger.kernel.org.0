Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B67EC152506
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 03:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgBEC7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Feb 2020 21:59:35 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:35195 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727966AbgBEC66 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Feb 2020 21:58:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580871536;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v+zy2FHQw9KFVxtHaLqa0r2t8FDa4q1KvvQqvnAapvQ=;
        b=P+MuElQeZ1SNjpDfg0uhBongTItWT2GdAluzOpQ2B4d0vqgoH87gL8i3TYDoIEpXx4r5yt
        BPtXzHmf3ZFZtOwIXPJE4ojh2qwb+VM6fuQFVFnHn6DJ3LwezETsOB4vlY60IVsCqxve7U
        +eQY7IdY74F4jA/4DivlDKWZmqBmAtA=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-26-GoLHuFzANmKNUCqhhRtSTw-1; Tue, 04 Feb 2020 21:58:55 -0500
X-MC-Unique: GoLHuFzANmKNUCqhhRtSTw-1
Received: by mail-qk1-f200.google.com with SMTP id i11so399186qki.12
        for <kvm@vger.kernel.org>; Tue, 04 Feb 2020 18:58:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v+zy2FHQw9KFVxtHaLqa0r2t8FDa4q1KvvQqvnAapvQ=;
        b=C3Hl9TIKQh92WV8WmQcUBwLBlenBbtwWYw3lHVtYAkl52mtvKaeWjxXzT/+jSBYENF
         L4MV7f0qWZKBp3qDeKk4+pC2V8HuITOI+eDHX879sbahqVgfTHw+bhKbvsEN6U7KwSz/
         oOQrtM4ucXCUovCT/6N4V+RRvrXZI6YhmMdhfUF8Y3IklBvGiF92uFOpR43vUs+Nt77y
         Loal6a9ptUnDA846cXA8a2cK76gjDmc4W1AENNWhYN/cz+uie8BnrbsfG8chp8cLGUuf
         XH45dO69PyqJ/frpBsAZ5ySt1Yx8YRnKa22O561FmFGnU0gqBWgC7v0xWTLajVjM9M8x
         YgLA==
X-Gm-Message-State: APjAAAWConV1PxsZRMivjtOn/IYWkUSerE1dTX1fCQEfrGU12zAf6BTp
        XALvk2zLNfMx2tdAqH98FfUADswhbCaZYA+hvDjhDWzZ53KcKhfyz8G4E8U7LRCUCWVst2pSJuw
        kVbOvgr5Aidzc
X-Received: by 2002:ac8:8e7:: with SMTP id y36mr31638489qth.26.1580871534556;
        Tue, 04 Feb 2020 18:58:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqwBrtfjh/WegxUDnL0gSdyIHl6hW1ZsZRs5d/otM4voagMpbjCc/TQ+O2fujc/H2QcwMgpFTA==
X-Received: by 2002:ac8:8e7:: with SMTP id y36mr31638473qth.26.1580871534337;
        Tue, 04 Feb 2020 18:58:54 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id e64sm12961649qtd.45.2020.02.04.18.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2020 18:58:53 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     dinechin@redhat.com, sean.j.christopherson@intel.com,
        pbonzini@redhat.com, jasowang@redhat.com, yan.y.zhao@intel.com,
        mst@redhat.com, peterx@redhat.com, kevin.tian@intel.com,
        alex.williamson@redhat.com, dgilbert@redhat.com,
        vkuznets@redhat.com
Subject: [PATCH 08/14] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Tue,  4 Feb 2020 21:58:36 -0500
Message-Id: <20200205025842.367575-5-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205025842.367575-1-peterx@redhat.com>
References: <20200205025105.367213-1-peterx@redhat.com>
 <20200205025842.367575-1-peterx@redhat.com>
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
index 5614222a6628..3c0ffd34b3b0 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -197,7 +197,7 @@ static void vm_dirty_log_verify(unsigned long *bmap)
 				    page);
 		}
 
-		if (test_bit_le(page, bmap)) {
+		if (test_and_clear_bit_le(page, bmap)) {
 			host_dirty_count++;
 			/*
 			 * If the bit is set, the value written onto
-- 
2.24.1

