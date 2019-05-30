Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 010F33042B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2019 23:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbfE3Vxp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 May 2019 17:53:45 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:34795 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726590AbfE3Vxp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 May 2019 17:53:45 -0400
Received: by mail-ot1-f68.google.com with SMTP id l17so7198425otq.1;
        Thu, 30 May 2019 14:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=sJuZdrZ6VMk79b1ZhahuZrudd0+Kp6YlC0eBwgdHqtI=;
        b=PsxZY9cXHZU3UHhQbhmWYsY+UJaHm8siNxxjBiful25kOQ+QKikMo6MgAVTCdgUVRf
         HjBxf/inGy+2U2z+5S+aaxGx2eUrk6bqqatAILgaaLwR1X4LkQlo7YDmx157FhcBU5Dh
         SKPTMz5awBl/iOy0G0otyV+PrTYLeu7JgLh7vznhqdFmuP7VyNkvH+QRBD6mjV8dj0ac
         VsIz6MtfFh0yXHkuy6sjpNia/mdmJuFWmSloJd2uK3Gf8a3fao/2BY0tS567OpBezrz+
         nyjzchNz30eSf80CDrDHUso4ILvcPw8/p2r5zT3iwCzx5MLu0IwOQEdUzi8g7aVFn/P6
         dHzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=sJuZdrZ6VMk79b1ZhahuZrudd0+Kp6YlC0eBwgdHqtI=;
        b=URjpjlp9ma0HFnGHE3B6qRf40A+ig1F/Wy/tj/0oj3SCtaQuY3a8J7tIOCU54ION1S
         EJJUkGmFloOQFJFo5jvZ9wPJuPVVk0jevkbCVpTwuh/fOpmG7jdkpXRPeaCR4dru07k6
         rmRBP4lt95C1QMSFljbAeJZOKP64mQ5jyS7tf9DRRb7vH+6gWK81t2XXBxk58o1lk5AI
         bwVW5LKnkjW1rOJrZ6QJGHJ2timATdCU9Su4WOOO0Pp/U0G53RnMiEPwinslmB40FrTG
         46MwrEuHvuyaKTH3l8XPqqy6qhUsa5lPzoomOqIbkH0F2qtt+t57xcMQGYdWQglwYpdh
         ZkBg==
X-Gm-Message-State: APjAAAXLne4hpfrKcTUpGqsRknbiFwWNJz0AJO/6uBKmpur38I2mLOs/
        vQMT+2e55DgTSeNTy8+w/eFCvepA9YY=
X-Google-Smtp-Source: APXvYqxMsojOf0egOxfGWLBhthd5R18VJ7E3zUiMlsMMhMaEmJH88aU+eNQTsegxUV9DbttxV/LJgw==
X-Received: by 2002:a9d:1b6d:: with SMTP id l100mr4256814otl.15.1559253224151;
        Thu, 30 May 2019 14:53:44 -0700 (PDT)
Received: from localhost.localdomain (50-126-100-225.drr01.csby.or.frontiernet.net. [50.126.100.225])
        by smtp.gmail.com with ESMTPSA id v89sm1441749otb.14.2019.05.30.14.53.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 14:53:43 -0700 (PDT)
Subject: [RFC PATCH 01/11] mm: Move MAX_ORDER definition closer to
 pageblock_order
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, lcapitulino@redhat.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com
Date:   Thu, 30 May 2019 14:53:41 -0700
Message-ID: <20190530215341.13974.19456.stgit@localhost.localdomain>
In-Reply-To: <20190530215223.13974.22445.stgit@localhost.localdomain>
References: <20190530215223.13974.22445.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

The definition of MAX_ORDER being contained in mmzone.h is problematic when
wanting to just get access to things like pageblock_order since
pageblock_order is defined on some architectures as being based on
MAX_ORDER and it isn't included in pageblock-flags.h.

Move the definition of MAX_ORDER into pageblock-flags.h so that it is
defined in the same header as pageblock_order. By doing this we don't need
to also include mmzone.h. The definition of MAX_ORDER will still be
accessible to any file that includes mmzone.h as it includes
pageblock-flags.h.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/linux/mmzone.h          |    8 --------
 include/linux/pageblock-flags.h |    8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 70394cabaf4e..a6bdff538437 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -22,14 +22,6 @@
 #include <linux/page-flags.h>
 #include <asm/page.h>
 
-/* Free memory management - zoned buddy allocator.  */
-#ifndef CONFIG_FORCE_MAX_ZONEORDER
-#define MAX_ORDER 11
-#else
-#define MAX_ORDER CONFIG_FORCE_MAX_ZONEORDER
-#endif
-#define MAX_ORDER_NR_PAGES (1 << (MAX_ORDER - 1))
-
 /*
  * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
  * costly to service.  That is between allocation orders which should
diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index 06a66327333d..e9e8006ccae1 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -40,6 +40,14 @@ enum pageblock_bits {
 	NR_PAGEBLOCK_BITS
 };
 
+/* Free memory management - zoned buddy allocator.  */
+#ifndef CONFIG_FORCE_MAX_ZONEORDER
+#define MAX_ORDER 11
+#else
+#define MAX_ORDER CONFIG_FORCE_MAX_ZONEORDER
+#endif
+#define MAX_ORDER_NR_PAGES (1 << (MAX_ORDER - 1))
+
 #ifdef CONFIG_HUGETLB_PAGE
 
 #ifdef CONFIG_HUGETLB_PAGE_SIZE_VARIABLE

