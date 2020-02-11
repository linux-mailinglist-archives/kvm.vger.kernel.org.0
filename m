Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD6D159C94
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 23:51:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgBKWvd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 17:51:33 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45134 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727199AbgBKWvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 17:51:32 -0500
Received: by mail-wr1-f66.google.com with SMTP id g3so13519768wrs.12;
        Tue, 11 Feb 2020 14:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=IOMlbjfXWuE+0u1ners+vpffTKgzzJDssD1Ouo69X0c=;
        b=EqmHEL7y0QA2mqPEAqNBo3EgWQVzlqdF9y2t1wKN6PRG19ziObA6wDoKpFUh4SvKoW
         JIoBJOMevTGYbyetGQWgQuRDrtj2apJTSBrrgiKrUyT8ACmpgeyOyf05wGeThVJwQ8ra
         iEzwxO72XwKzR7K8P9+XUPv/0z9RWpsCtZF/sD1Zj8A0OHrJg14V/LLV8jKDkidNv+4u
         gzRtI6WebEcA75xwVcH5PdmA8LUkM2wrL8EtpHLePZBGhVspRCBbjOO/Yq4tEAcOVS2z
         M07L2pq6fKNMQ8JKIz/QhLY/pVehO3b95DspSwcM6KezGAsVEU2jVWwRSiIRMQDvpYcN
         CmTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=IOMlbjfXWuE+0u1ners+vpffTKgzzJDssD1Ouo69X0c=;
        b=NR+bnkvhu+o5ip+XoFPzXyP33BmQ+WzaTllKPxYs+wxo9CK1XImugHkrJ60xMZrNh2
         Vq+IN4GA6HqHA8ybKDn2fn6LvUv1mqVNR6JFbMoHmwKDgYx9FzLKJzraNHfjnSXV69U+
         YeBlTpP6FyQ+z4Wt8xi6Uq4ICTzelUuvlX08KgYlb9uJ4nwgTC1UQlpZllBiER22GtoO
         IzB/mPt1YuZOiHI/kaR2ckOcSxTsLZO6wqYoGN6DPWjy5KdcR5SoGX/hMtH97vYNgE4o
         meWVq1NTYjuboM+cdSuWVX0rkdMyrS/khFwtc6jRixoaxTL77fFf/JBp5RhFHrUbwBwl
         /9Hg==
X-Gm-Message-State: APjAAAXR5axWToRwjJ2d8my4MUtr3LTTYzYF2LD3rrYrc0a29PCukqzO
        cWm+3u+VqUlS3uJE8yRJ0vk=
X-Google-Smtp-Source: APXvYqx+93e8f6Snf8Nwn26W6HHkSao0doTNZ1FIT+zSN0DdE7/fhQjcDfKypFQyi4PFtnreFzPiRg==
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr11687705wrt.229.1581461491313;
        Tue, 11 Feb 2020 14:51:31 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id k16sm7418136wru.0.2020.02.11.14.51.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 11 Feb 2020 14:51:30 -0800 (PST)
Subject: [PATCH v17 QEMU 2/3] virtio-balloon: Add support for providing free
 page reports to host
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, david@redhat.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com,
        konrad.wilk@oracle.com, nitesh@redhat.com, riel@surriel.com,
        willy@infradead.org, lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, mhocko@kernel.org,
        mgorman@techsingularity.net, alexander.h.duyck@linux.intel.com,
        vbabka@suse.cz, osalvador@suse.de
Date:   Tue, 11 Feb 2020 14:51:25 -0800
Message-ID: <20200211225125.30409.98370.stgit@localhost.localdomain>
In-Reply-To: <20200211224416.29318.44077.stgit@localhost.localdomain>
References: <20200211224416.29318.44077.stgit@localhost.localdomain>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Add support for the page reporting feature provided by virtio-balloon.
Reporting differs from the regular balloon functionality in that is is
much less durable than a standard memory balloon. Instead of creating a
list of pages that cannot be accessed the pages are only inaccessible
while they are being indicated to the virtio interface. Once the
interface has acknowledged them they are placed back into their respective
free lists and are once again accessible by the guest system.

Unlike a standard balloon we don't inflate and deflate the pages. Instead
we perform the reporting, and once the reporting is completed it is
assumed that the page has been dropped from the guest and will be faulted
back in the next time the page is accessed.

This patch is a subset of the UAPI patch that was submitted for the Linux
kernel. The original patch can be found at:
https://lore.kernel.org/lkml/20200211224657.29318.68624.stgit@localhost.localdomain/

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

