Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99EA3A8960
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731433AbfIDPLw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 11:11:52 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:34220 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731279AbfIDPLw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 11:11:52 -0400
Received: by mail-pl1-f193.google.com with SMTP id d3so9733314plr.1;
        Wed, 04 Sep 2019 08:11:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=g/vi+t15qU05IbfH7f9reEH9yxdol9aOOQ4XHr0/aA7/TFCQM1b5/WOo9ApO+j4UO8
         6zHTfLJrCRgc/PRbLuwmwt7AgO8Li2zVeayIjrPHGLVtuvmfLy05Ebxskv/jEsFKXreT
         PU1YxQJFu1KtTW4aXpFBLy2Wp/SlTrcpGKFwkcSPe/yVdbP54eXYeeB/yNM1sO1CF0Ft
         X3i42sxpn6OhzdN5Oi17iH+Pxv2Yyzw228YDIeRYnaggU+hm0GIV4Od0cj3QoN0ozyM5
         7Ne4cZIs5v8tbBvJd6IdKBXcTKOqHiDarRP+9/o6pofrBQholFrcv7aIxP7g5tq4bdag
         JR1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=mypZfBst0ATadj4/4/CVF3+aGGNw2FzmGQsENTAnTledEz3PfqgADY+PPLB8Hpr7wS
         rU0aiHWRKTYucGINrXDKCWzXaVJlBPZNDHbHydMjAuhrKlkk15JGpHkCtVGRAwD4AmVU
         nGR4TZ8havThYG5TdFueXLSFvV7pPJnUYg6XzsWAlGeiEcUiq1IkRdrvqO0l3Beh3Sem
         OX85WitlTFf3WNswHWahTzE72vcfrOV29wUFnGEKycED4nmEpSv+TB8eTiBUwyfc9RQo
         sG2oJNFAbKNm+TLLQRhJZ2oDqw2c9E0e96dyRqNFhThx0ZjARLHN0w8Eil+lxBytIPHw
         E4KA==
X-Gm-Message-State: APjAAAVNxipkdq61i+C75cGVVbXQoe54XPt08gwSAl1Htu1UyGJZ4YWR
        ibWJFxpEaAVVGkhxPUtz4aQ=
X-Google-Smtp-Source: APXvYqxMHRJHJTYla/YgyQdu59bO6u5k5GGEbaAYb15QMGK3Ubb3XU1FJ5AaU/7ayJ0tPcue3siLXA==
X-Received: by 2002:a17:902:7085:: with SMTP id z5mr41400977plk.102.1567609911224;
        Wed, 04 Sep 2019 08:11:51 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 69sm25681682pfb.145.2019.09.04.08.11.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Sep 2019 08:11:50 -0700 (PDT)
Subject: [PATCH v7 QEMU 2/3] virtio-balloon: Add bit to notify guest of
 unused page reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, mst@redhat.com,
        david@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, virtio-dev@lists.oasis-open.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, willy@infradead.org,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com, mhocko@kernel.org,
        alexander.h.duyck@linux.intel.com, osalvador@suse.de
Date:   Wed, 04 Sep 2019 08:11:50 -0700
Message-ID: <20190904151150.14270.41018.stgit@localhost.localdomain>
In-Reply-To: <20190904150920.13848.32271.stgit@localhost.localdomain>
References: <20190904150920.13848.32271.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add a bit for the page reporting feature provided by virtio-balloon.

This patch should be replaced once the feature is added to the Linux kernel
and the bit is backported into this exported kernel header.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 include/standard-headers/linux/virtio_balloon.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/standard-headers/linux/virtio_balloon.h b/include/standard-headers/linux/virtio_balloon.h
index 9375ca2a70de..1c5f6d6f2de6 100644
--- a/include/standard-headers/linux/virtio_balloon.h
+++ b/include/standard-headers/linux/virtio_balloon.h
@@ -36,6 +36,7 @@
 #define VIRTIO_BALLOON_F_DEFLATE_ON_OOM	2 /* Deflate balloon on OOM */
 #define VIRTIO_BALLOON_F_FREE_PAGE_HINT	3 /* VQ to report free pages */
 #define VIRTIO_BALLOON_F_PAGE_POISON	4 /* Guest is using page poisoning */
+#define VIRTIO_BALLOON_F_REPORTING	5 /* Page reporting virtqueue */
 
 /* Size of a PFN in the balloon interface. */
 #define VIRTIO_BALLOON_PFN_SHIFT 12

