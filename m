Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7101312FE52
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2020 22:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbgACVVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jan 2020 16:21:17 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:34226 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728657AbgACVVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Jan 2020 16:21:16 -0500
Received: by mail-pf1-f196.google.com with SMTP id i6so17193111pfc.1;
        Fri, 03 Jan 2020 13:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=S67ROGEQCcp+6ozGSJjGTXgu/nEqa4BuBwrMv8wLSMo=;
        b=IReGa2gpjzbzT0DsrzpVX4qSADu6S+wBF/3HbzQ38dE/yvPaRm79BSAATDSruM5kwO
         TIidBoo1i73CWujrF0OeIRZd0YQ5WzAE3H2eyU+sju2ugoESBnpg4FOJxoh0meQNodz/
         QPcpExtgV33WERambn2oj57Od9YVHVuq7jaHpYiC6rgRkn6APMqmI/wmzYgrqBl5Xuq7
         zKMLN8iW1k2J2PMzgPPULqG/EQE/bOebpzRdeS7szwKV25U74c2SJp/gBGw/GxANc14N
         QxzER9uQWzXPYKgg6YT4iT7rKGg+mGn7QnNvHGOvmZF32Avp366kDbZd1vb/B2XVHuJF
         o1+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=S67ROGEQCcp+6ozGSJjGTXgu/nEqa4BuBwrMv8wLSMo=;
        b=MZpjzqg4ZiZXTlTi3Y+AthhdXmlNs1+nxD/BKunhky9tebXqXx/9hlZM2NPSYRP3rS
         w2w+a05Jt9J1nz+SAyPodjZo6vi7ZPtXyRxOPTB2xFDGf9BpodXxaIkRXCID91AU/feU
         b6uXFn41tp8RHbKlgnZ4+1AwsKi5J8p1uxT23uydTXQEWXGj5m8uD8YjLDPfC4jkQOS2
         gxjPxCJq5R2DqeMKuaCcdCICPDWsT+rHXVsn0VA4BQ4cod5clszcgSYOVgbEjAJ8ylIY
         dc+kpLzDIWhTISjZRIKDlyoOwEMyyzgcxb4ZzEYgp3geLCfEZBuLzjbv2x3yiruuKppm
         nbpg==
X-Gm-Message-State: APjAAAUscAhDLueAWZ592wdSGG7qF9Y1SYzHHHuhqVEuZrClETVemyrc
        MLvO1A6IhoFJytb/vZIhb2I=
X-Google-Smtp-Source: APXvYqzpGZPeSqmK+zMTQ5LdDqI3o5o9Ha0+h7iu+L/6VZ89kc7BfukT01TLxUdVF4Ok/9jq0oZijg==
X-Received: by 2002:aa7:951c:: with SMTP id b28mr94501152pfp.97.1578086475886;
        Fri, 03 Jan 2020 13:21:15 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id q63sm46101348pfb.149.2020.01.03.13.21.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 13:21:15 -0800 (PST)
Subject: [PATCH v16 QEMU 2/3] virtio-balloon: Add support for providing free
 page reports to host
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     virtio-dev@lists.oasis-open.org, kvm@vger.kernel.org,
        mst@redhat.com, linux-kernel@vger.kernel.org, willy@infradead.org,
        mhocko@kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org,
        mgorman@techsingularity.net, vbabka@suse.cz
Cc:     yang.zhang.wz@gmail.com, nitesh@redhat.com, konrad.wilk@oracle.com,
        david@redhat.com, pagupta@redhat.com, riel@surriel.com,
        lcapitulino@redhat.com, dave.hansen@intel.com,
        wei.w.wang@intel.com, aarcange@redhat.com, pbonzini@redhat.com,
        dan.j.williams@intel.com, alexander.h.duyck@linux.intel.com,
        osalvador@suse.de
Date:   Fri, 03 Jan 2020 13:21:14 -0800
Message-ID: <20200103212114.29681.69388.stgit@localhost.localdomain>
In-Reply-To: <20200103210509.29237.18426.stgit@localhost.localdomain>
References: <20200103210509.29237.18426.stgit@localhost.localdomain>
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
https://lore.kernel.org/lkml/20200103211651.29237.84528.stgit@localhost.localdomain/

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

