Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9D1D8A971
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 23:35:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbfHLVel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 17:34:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44626 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfHLVel (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 17:34:41 -0400
Received: by mail-pl1-f194.google.com with SMTP id t14so48347242plr.11;
        Mon, 12 Aug 2019 14:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=LqnVlh5qwXJFuAES6AvqFxLV+HOJVvsMnunOc+a0bV4Yi1JKqAumYDprRdSCLepkMd
         7nX3R1JUVKI5IZNxd009+DcXEyNmcKrXLSGgHn1onPvgXFAytzu45ihmZu6nXGZjcsdE
         TcQlMZYpHJtPzNSbEXPle/C+NHykz0SwEZ6+JZSfGVKycsEW7KSZ6xnaPFangu3mAiAN
         T5IeWvWvrvIVjIuIWThjSuBqur0Qy7ft54j21bboL40n/Ggonb3DvHz/J9n2M0cKl46+
         uhjo9S8iIE9NPZ9PvXe/mQAyIGkrcviO1jDjU0fg9l0JSgIwKDa6TAxq1vXddbn9Ioe2
         hpmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=Yupan0FteRfi/91yTx5Kw4GTmDprghTt3LqD74hkVyd06aXNSOY29TqRorTqghz9sa
         U7A3kAdskyQgY4Fj8xm6dvGzIu06F8evalU6HnEBoX7oxb+tRhpoGu9DYXS2v2ggCOEm
         BSwwA9XfbFz0nuxokICuJAsYHO4KE69drc0qja0y0zLTNjWCYr4C+SJIFdO9FwosEAj6
         dVeCoM7BXWMvYvVt8eK3tnGZW6b/5dcpZ/ELu5gu26xHukstnKtpZz5bPb/Tr7gLGqka
         CwG/1M4MlLl+QR4eIYPZSLr7aEQM/ACnQxdyb6XhdetLUNMCEfnK7HQNEZlL0rnAjriK
         b7Hw==
X-Gm-Message-State: APjAAAUGl6DdQNPhvvNYOeSoUka1BNle/f7x4+nUPrBydXE2lYcOc7+u
        5V0xASrtzL1B3rph3GaPq6I=
X-Google-Smtp-Source: APXvYqwXhOtrHg3dp0PNbSaVXSKNK/u6uHt5QRfcWxzex+pgpfmAcc/zMxe56yONs1VRm8Cl7HMK1A==
X-Received: by 2002:a17:902:8205:: with SMTP id x5mr35210808pln.279.1565645680733;
        Mon, 12 Aug 2019 14:34:40 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 131sm129598899pfx.57.2019.08.12.14.34.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 14:34:40 -0700 (PDT)
Subject: [PATCH v5 QEMU 2/3] virtio-balloon: Add bit to notify guest of
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
Date:   Mon, 12 Aug 2019 14:34:39 -0700
Message-ID: <20190812213439.22552.44254.stgit@localhost.localdomain>
In-Reply-To: <20190812213158.22097.30576.stgit@localhost.localdomain>
References: <20190812213158.22097.30576.stgit@localhost.localdomain>
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

