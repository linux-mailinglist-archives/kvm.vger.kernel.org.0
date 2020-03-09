Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3C1917EBF6
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 23:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbgCIWZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 18:25:14 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:50672 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727255AbgCIWZO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 18:25:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583792713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v+zy2FHQw9KFVxtHaLqa0r2t8FDa4q1KvvQqvnAapvQ=;
        b=PQGvMJGTBaYcs0rW0oLvdJ0EGdgYekssdg1jPHo8JfqnLldI+k0sebEtrFfqFGIKp1bGTa
        2sUn7hojVr2BgKYK7Iu1bETQoY2DBFQL+3ahKXEuqHi6FPl3ou2wvLwudP/GhxZmAHQgIm
        klSsZz2AOTo4X6n/8cYR93swscaAksE=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-lcmyqMFvMvuUMg3ny2tE4Q-1; Mon, 09 Mar 2020 18:25:11 -0400
X-MC-Unique: lcmyqMFvMvuUMg3ny2tE4Q-1
Received: by mail-qv1-f72.google.com with SMTP id u5so7723029qvj.10
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 15:25:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v+zy2FHQw9KFVxtHaLqa0r2t8FDa4q1KvvQqvnAapvQ=;
        b=hVUlddEmiJm1Z1gC4Mh3LDMvo8IXHVFHZoYqTskxuNMhwvzZyMQrLdgRCbKASudfb5
         ODCGyrNT6VYWiVtC3xMFN+b8lvxUNxlqUfIW2Awo8R/JKZFwteg9/4MeLcC9WRhbweST
         Fc6JwO94SQ95cVooYXMfwOW+sQ5BA3R/tdoqHowkhEF2N+e64kgHCeJrTqBoFWxEEQQf
         W9tVT0Xu1OaHIKfj5x3sVeVy8Z07y2EmJs/4mJEsy2RWWuWuvg1MJKIZewDnlzPUA1sq
         SEFFSSXGRWHjIVqbUV239Ab6AWp9gY/+NbRgyAtgI+2Q4LD3I/wqR4tkuNaaxlmD75wc
         Z1kA==
X-Gm-Message-State: ANhLgQ0XOonEvh1RW0iiKGqB3NHmV4fQDMegrc70QBdJTRKDSxqfoYY0
        Sngtk6i6rnb3H+v4YL2tGNNflB9aNmpn8bI0Wh9UzVNjXBeILF3IW3VysRZFxyLuvdPg7aPfnRD
        3rmD2EBITG/Fp
X-Received: by 2002:ac8:48cf:: with SMTP id l15mr9587164qtr.234.1583792711334;
        Mon, 09 Mar 2020 15:25:11 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvR8HfHsn5t5n2MA4zPw5mx1lMcYtkK1WmmuD1HcoGfkiSxIp9vInOidMMrxX+bzf4bJvhv4w==
X-Received: by 2002:ac8:48cf:: with SMTP id l15mr9587138qtr.234.1583792711121;
        Mon, 09 Mar 2020 15:25:11 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id d185sm23652354qkf.46.2020.03.09.15.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 15:25:10 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Peter Xu <peterx@redhat.com>, Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH v6 08/14] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Mon,  9 Mar 2020 18:25:08 -0400
Message-Id: <20200309222508.345499-1-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309214424.330363-1-peterx@redhat.com>
References: 
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

