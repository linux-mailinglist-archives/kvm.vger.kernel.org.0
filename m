Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5899417972C
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 18:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbgCDRvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Mar 2020 12:51:16 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:41436 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388360AbgCDRuU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Mar 2020 12:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583344219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v+zy2FHQw9KFVxtHaLqa0r2t8FDa4q1KvvQqvnAapvQ=;
        b=VjGSTxdJkNRfaYHMhJK9e6wdVINA4puvENChs+jRM49KOZcL9nSqLsVkxiR6Sdb1JPSL1z
        Ai9eBFOJX+CcgG6f8VL7PeE/LJhyIV6qHPGhUXmUJsAlwODsx8XvzGJHLv+iDR4X14kvAY
        AWnqF9shw7vuAPiCkgsJzLoVYPQNWXY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-oQ5fF7GmOxOhDO2ARzHLtg-1; Wed, 04 Mar 2020 12:50:18 -0500
X-MC-Unique: oQ5fF7GmOxOhDO2ARzHLtg-1
Received: by mail-qt1-f197.google.com with SMTP id i25so1957770qtm.17
        for <kvm@vger.kernel.org>; Wed, 04 Mar 2020 09:50:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v+zy2FHQw9KFVxtHaLqa0r2t8FDa4q1KvvQqvnAapvQ=;
        b=BH3XicRuenxwdSKVoJgFh/Fq8Gf/+IsnaY8HV/NvvIE0B1CLR4oNUyoUif0WDFPtEu
         mRyQRRMEuRoe0rdt4woa/OJbLcFy3hJFX5JndSeCEZ6h1Xh11UUt58/hNbnX/b/rUEVo
         26J2o2JqbH94FjEpHiAcXfUk6GCwjQ2QF8XvUgNkwBes+xDIKrPVATidp4vXvvqpBR1J
         Y809aixcuqt5YCXsDut1Xn/duLi4VqK6lx8p2gP94/D0aYnGlV/zN7WndBKCoQv49Y3I
         EERNGLrh5lLDwaR+u+tg2RqOstsGLti6707bYkCj3lDZM56qZV95GqiTT0M7XlDMgNM/
         20Ig==
X-Gm-Message-State: ANhLgQ2E2G4fZw9pofKfTmXVXoDkMBGMucerr4DAQ6+jLp2602Km44M8
        ozamNgzyeuJYbG51GAS60JroVTPxSb+LBhfd5ISrycFJ8ppfqFpgKK+Ga+CXSaJ6Tkcusd2JWKl
        0orZgHh7HakWf
X-Received: by 2002:a37:9f41:: with SMTP id i62mr2368527qke.494.1583344217745;
        Wed, 04 Mar 2020 09:50:17 -0800 (PST)
X-Google-Smtp-Source: ADFU+vv/meqIN9VvRgDGaOSnYRmOfW3WetEnPx5O2ltnwdaLHNa8jtllNzbEA8f3VK/mpez14DTlpQ==
X-Received: by 2002:a37:9f41:: with SMTP id i62mr2368502qke.494.1583344217516;
        Wed, 04 Mar 2020 09:50:17 -0800 (PST)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id i1sm9033276qtg.31.2020.03.04.09.50.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 09:50:16 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Yan Zhao <yan.y.zhao@intel.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>
Subject: [PATCH v5 08/14] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Wed,  4 Mar 2020 12:49:41 -0500
Message-Id: <20200304174947.69595-9-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200304174947.69595-1-peterx@redhat.com>
References: <20200304174947.69595-1-peterx@redhat.com>
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

