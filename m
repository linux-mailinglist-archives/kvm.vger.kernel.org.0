Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE84102EB3
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 22:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfKSVyz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 16:54:55 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39914 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727500AbfKSVyy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 16:54:54 -0500
Received: by mail-pl1-f195.google.com with SMTP id o9so12645593plk.6;
        Tue, 19 Nov 2019 13:54:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=fHm7T911iuia4NWlna2f+ICDTlTFMBViffmv/N4fKbXiMAx0VLFWmqcy2EPwKuCVWC
         RO8FCNazc+/cfp0fiNhrBlFN4Swtz1bZpj1YVwDC7TQTk0Pxp1cXHPnSVLVREkQTjCCN
         modsdNlBkkiTMJQaCiXqKWuP4tlgdSHiP678Ti9EM3Jpxmy+YxniKe3myWoE5FcHVbj+
         k/lp8Fxsv6nSiz6iIauPS1BGoTW5D4OJpLOfD1GNslML1YWIWcwl7tM2Vs2q18U/y20K
         ZzvObpP7yrbjNG5PeHX5nYf7bs5mdEnVQaiajS2fReyJs4hBrF+eWpF6N88piGzc25h0
         URcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=K4qZFHAyCn4Jd1GY4HehhFdk858KcOnZjGsVxtt4vr5as9z0iEHspxRSmMaTXtkvcf
         f9OGSeeo1pn7K5VgJ1B16R9T6spDJhGujER7zTBxXrF2NT1xXhE+K9pnQMDTr8ULMA7R
         fF8pp8izRiGp4SgexL1ZO0F4mFAeFhRcHeANod4ZKMx+8Am4EZjvLlPf7KmYgJJ2ddla
         0O175JZqbhUHEyFkyy9iS8nsXbvSKs1qAsoPlKI3LPYZ1RJKvNo6rZGe1dCx4R4XlOND
         K+Ug227bLH79ZaklTZBy/S/vSzgx/45ZQvZ7PCyWueyuI2QI94PxZHNhpiZgSwVryGvv
         A60Q==
X-Gm-Message-State: APjAAAWIs9VvnrNURJGe2x9ZUcpDiflnmzk4SWJWHkLONl0gLQ2TzgKC
        DQfiQunlBZc6nT6oMurDILw=
X-Google-Smtp-Source: APXvYqyC5xLpOP/FxM+YgfX1DpMOUcDtkh0mBcdjGHfcBzd3uzEPJxY4V1VMWwmNI/ag51fWQw8+lQ==
X-Received: by 2002:a17:902:6846:: with SMTP id f6mr34328288pln.77.1574200493642;
        Tue, 19 Nov 2019 13:54:53 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id d25sm27826091pfq.70.2019.11.19.13.54.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Nov 2019 13:54:53 -0800 (PST)
Subject: [PATCH v14 QEMU 2/3] virtio-balloon: Add bit to notify guest of
 unused page reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     kvm@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org,
        willy@infradead.org, mhocko@kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, mgorman@techsingularity.net,
        vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Date:   Tue, 19 Nov 2019 13:54:52 -0800
Message-ID: <20191119215452.25688.88059.stgit@localhost.localdomain>
In-Reply-To: <20191119214454.24996.66289.stgit@localhost.localdomain>
References: <20191119214454.24996.66289.stgit@localhost.localdomain>
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

