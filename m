Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC55485626
	for <lists+kvm@lfdr.de>; Thu,  8 Aug 2019 00:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389631AbfHGWnU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Aug 2019 18:43:20 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35041 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389634AbfHGWnT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Aug 2019 18:43:19 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so1194000pgv.2;
        Wed, 07 Aug 2019 15:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=a5bFBq8dljd+KFQj8GsRoLSHGqJwQp1D5ijrMfnYKZTD6Bt+CaAUzJalWN7vPj8cwG
         pWIQHZeWlF01w9ODFOdx9z+f+AlMLp5FqwG2TA53NLFH8peXxKWTES629HP/akXRJg9n
         DJ4jY46AP3dbxMN0WsuHo/WqAxvhjf7UEESQNwx4G3HUYGxtjEoQXl58QUb/NYO66oVF
         3aabuZS4qG67Nxwzn84c+8qH9jDl5J0UQODHXlzenEHEQLM1eahgGf+upLYULSRlAiHW
         FaF3thHu2UqU5E+esQH85Bkzf9kbZTwMvNbp1I+Ebwv8CLfPptCXwrq0LMxDlQkwY/v6
         F5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=T+b80I3riA5M/EGj6bWhNeA9oGvJ5OYhtdRAwNl8/ftW3EHQ4wcc1w81JkRdf13Uhg
         /Wpk4EHyj3GS8Z8+/LdvnjaoKjCn3CAn+6Oyp1Cr8dsan6XQRxAjimxx5ZixD1NbhP7A
         d6KYn/AWLwVkqdBxzXyfGn+IYe6iFOsp/541Gptx78KS3T7lrWhTjY9EFMaM22AP3wZA
         j32JZOIZNPIolY7jbhOyc4EQ+wgnFmvu/anciadk5BTG7SNhouG8/3i4HBDu+aXmChbU
         TzJULpdABna1lylZX9bUvoMLt/7DMKu14bshNt2lLPH5qj6OAc28lO/Hq11PvdG/LZiP
         mn7w==
X-Gm-Message-State: APjAAAW2HsIH8DLDvWXJ+YW+yxAveP0ZaZ1iKHYCEDJ2mPjhDXlu55MF
        qg5feVv98S297GIwDIJWsIo=
X-Google-Smtp-Source: APXvYqyW8MKXNJvVuax/guRo5BBwLkQSLi3lLIO/meHglhLBkCaN+RruEG3XpplsxDaBU/3G1+9j0Q==
X-Received: by 2002:a65:5a8c:: with SMTP id c12mr9521695pgt.73.1565217798671;
        Wed, 07 Aug 2019 15:43:18 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id n128sm47421037pfn.46.2019.08.07.15.43.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 15:43:18 -0700 (PDT)
Subject: [PATCH v4 QEMU 2/3] virtio-balloon: Add bit to notify guest of
 unused page reporting
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     nitesh@redhat.com, kvm@vger.kernel.org, david@redhat.com,
        mst@redhat.com, dave.hansen@intel.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
Cc:     yang.zhang.wz@gmail.com, pagupta@redhat.com, riel@surriel.com,
        konrad.wilk@oracle.com, willy@infradead.org,
        lcapitulino@redhat.com, wei.w.wang@intel.com, aarcange@redhat.com,
        pbonzini@redhat.com, dan.j.williams@intel.com,
        alexander.h.duyck@linux.intel.com
Date:   Wed, 07 Aug 2019 15:43:17 -0700
Message-ID: <20190807224317.7333.84787.stgit@localhost.localdomain>
In-Reply-To: <20190807224037.6891.53512.stgit@localhost.localdomain>
References: <20190807224037.6891.53512.stgit@localhost.localdomain>
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

