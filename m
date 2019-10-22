Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E17BE0E3A
	for <lists+kvm@lfdr.de>; Wed, 23 Oct 2019 00:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389299AbfJVW3d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 18:29:33 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41154 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731376AbfJVW3d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 18:29:33 -0400
Received: by mail-pf1-f194.google.com with SMTP id q7so11533198pfh.8;
        Tue, 22 Oct 2019 15:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=ub96VsE/aHpg9djCBphz/P7fdVY3n86o/XWb1FAYTGbSu3AwR4K9lBGmtTy/Wn7cq8
         pKmFbjXvCiAO/AnmPTA2xqH9ItqQ0QHW1e9m+fpikl/zoHAGuewJtMT+qYpkYU4d+sNB
         bRcwsxXm9qsjO4pPJRl9GrFQmmL7vyQVSjyqte3AigLrzhUm2sgR2QhetUXUFq1lw6Ms
         qK4rAZkMI7fL6gZSq06ke+W7yIVRWBRusrfPAujAVqlWXkE/ORuUZRRSsb/pqEPLL9kS
         4niZNMgMERqwHAwhWTfqEOfuvdAYHH2aBZ8LE+reCLeCfFrdukQ02pYjZs0F/UIQzwSa
         +3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=UzGM2dm3c07vimaWiyna6p69GopwNrdp5Q8tX5QOEp7cJ1ko5n1zX+lTO47APIU3JP
         lGE06AUPX0QOX23mwViogiyLD+Kz1SphRml1Xgia1qLLv+Mo5FFSO54CL62djs/+9lvm
         Scj2p5Q/kerkqlIyctBIpIcCjwixgzISmy8u+IxUtC0xA9DtMRFE1alntPEGUMI6eW21
         iG/LwLjREJ0OQleA8qEnyCqYv1fckrf5JL7jCDC1wel7T3ZR1Qglf0oXCSW8GKyctA8P
         fPoMv9PFl4pix/Gde2EEjvxEDSr/FqZjRV8XN5Q5rQzh7saxR4cXvkjojiKS7qNjVin8
         2Ymg==
X-Gm-Message-State: APjAAAUcBCNfULgW4//UwazZhOOkGFFhWJ49sYXjSmecS9k0a0lQMU1B
        qeU9HJtRY5AAh0+oGdhSQLA=
X-Google-Smtp-Source: APXvYqzOM4u5GmGbN/ocrgEqoziD4wWkt1Nwwr1fbqvYRLXfjz4D1ifewFxxUB9G7yy1bBtSvW1EJg==
X-Received: by 2002:a17:90a:b902:: with SMTP id p2mr7613515pjr.62.1571783372563;
        Tue, 22 Oct 2019 15:29:32 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id f89sm18661852pje.20.2019.10.22.15.29.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 15:29:32 -0700 (PDT)
Subject: [PATCH v12 QEMU 2/3] virtio-balloon: Add bit to notify guest of
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
Date:   Tue, 22 Oct 2019 15:29:31 -0700
Message-ID: <20191022222931.17594.85842.stgit@localhost.localdomain>
In-Reply-To: <20191022221223.17338.5860.stgit@localhost.localdomain>
References: <20191022221223.17338.5860.stgit@localhost.localdomain>
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

