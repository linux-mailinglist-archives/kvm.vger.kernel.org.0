Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D72B1C46B6
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 21:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbgEDTFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 15:05:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50728 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727855AbgEDTFc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 15:05:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588619131;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qIVg0JQeyCu7kn+dY+lPaTgPQT/NdBxPgGWYbUJIIXA=;
        b=RNKVBW/kf7N18LPuDJNpGkbK9WE5VtNg0xVlxj1q4mBz8Z2Wwy39VN83wxFqrrwh0omSZ+
        +lX7zlbBu6BogIXPURUhAtkGJ42z5lfG0DO7TA7Vml21aMeDDRxoJFpOmN/OGgCIBMV3LW
        LErSltT83vlvN/kmg1Fu9Iu4abS1L8Y=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-149-A86VbsMsN5e0KR8N3EXGaQ-1; Mon, 04 May 2020 15:05:30 -0400
X-MC-Unique: A86VbsMsN5e0KR8N3EXGaQ-1
Received: by mail-qv1-f72.google.com with SMTP id fe18so485186qvb.11
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 12:05:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qIVg0JQeyCu7kn+dY+lPaTgPQT/NdBxPgGWYbUJIIXA=;
        b=DrBLiADI4/OqYd3k/jQ5CzMRLwN8DEYi1O8aaG9xa/YTXoz8vjU3GHMHU7xPgVnIJ2
         gI9rPu8B+2K+k8Ba0PLUBjPByc8T0HFF/BAcTWf1DYXwCLVvNZxcAQ8UqZOvSJsHvPTb
         ePaRp5rVvVe+WcBTRcMr8pSa0698Ev6KFQGFEPQli5Im3zNEeTgCO+ymxxhJMSC6pVcN
         0CFibp3v6Ga00fvFEilQv3Hvi53f0WWVNGtlo1h2chJgGxbY4j6jnmv67aBJr0pwvhV7
         znybitykfD4MCR7SY6WbS0PxzGEdrEJ7TLntqbBlkZrgdrTFsrtDDrKzpI7nPMevUoJ0
         5K5Q==
X-Gm-Message-State: AGi0PubK0jw+HDHenEarjxV1E5U4ZkSlCQsARaKGgdER+cVTI2md/wGH
        eNcAynBubx/YRKzUA0t9eRolsh+8yTvbsQy7ef+WzV9M1Awh2t42OsfUn5GJPHl6Ih1lF4SfcL6
        ZKf8UN7TThMj8
X-Received: by 2002:ac8:44d6:: with SMTP id b22mr640167qto.366.1588619128935;
        Mon, 04 May 2020 12:05:28 -0700 (PDT)
X-Google-Smtp-Source: APiQypICFt1DWmxwrFZqvsi6oraH8Ztk1a0hOa6r+UUKVpePo5HU+yUDiugMPSKG00KJ7y+T26omxQ==
X-Received: by 2002:ac8:44d6:: with SMTP id b22mr640146qto.366.1588619128682;
        Mon, 04 May 2020 12:05:28 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id p22sm12111549qte.2.2020.05.04.12.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 12:05:27 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, peterx@redhat.com
Subject: [PATCH] KVM: Fix a warning in __kvm_gfn_to_hva_cache_init()
Date:   Mon,  4 May 2020 15:05:26 -0400
Message-Id: <20200504190526.84456-1-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

GCC 10.0.1 gives me this warning when building KVM:

  warning: ‘nr_pages_avail’ may be used uninitialized in this function [-Wmaybe-uninitialized]
  2442 |  for ( ; start_gfn <= end_gfn; start_gfn += nr_pages_avail) {

It should not happen, but silent it.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 74bdb7bf3295..2da293885a67 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2425,7 +2425,7 @@ static int __kvm_gfn_to_hva_cache_init(struct kvm_memslots *slots,
 	gfn_t start_gfn = gpa >> PAGE_SHIFT;
 	gfn_t end_gfn = (gpa + len - 1) >> PAGE_SHIFT;
 	gfn_t nr_pages_needed = end_gfn - start_gfn + 1;
-	gfn_t nr_pages_avail;
+	gfn_t nr_pages_avail = 0;
 
 	/* Update ghc->generation before performing any error checks. */
 	ghc->generation = slots->generation;
-- 
2.26.2

