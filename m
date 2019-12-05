Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABF861144C0
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 17:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729956AbfLEQY1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Dec 2019 11:24:27 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:35199 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbfLEQY0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Dec 2019 11:24:26 -0500
Received: by mail-qk1-f194.google.com with SMTP id v23so3859742qkg.2;
        Thu, 05 Dec 2019 08:24:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=MoDAOdDLiXkd2mmrv89OI8/1XQi/spAoBOcO0B90RXtvWez6nZ2Vw/gw5fhMl6hy23
         tX7wmDr4PeDibNua9+HL3ONCbzZXQzsBPy/nVc1JEdHw74+q1h6/e3bk1WJfJ5sDH9Cz
         nC2XlOnYNdfjU3BNBE4Jd25qXkmn4Q97ryT5gKoxSMeojdRtJ7X6Hfc2l6/wj3UAqz2y
         XdZN2SduJvSVlGQ2oG9a0kPGzmshnNgkU6C2TnxkG3ado6v7whAS3xDKqQvqtf57HnTy
         gM51eMIcSVlXbhJyJUy7VYyErZbCCJb5EsWbecOoq/oaRirDWRXKDHrMlndpN0Fpj0tp
         EzFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=VitjQQFQG7H0A5JYqbYhHy/YWDiYO6QESupJyX3H62U=;
        b=hOUmk77pGUzGDGOll4Ws2IlBA/2i0QzC/YORbiOHJ7ty74omtnVpdi8RI5wv1If88X
         +lHbX/OXCrxn5h+ok486S1KkOk7LMxRhPd2LBe+qA83bZkGbv0PgGg4Pzjf8lM0O0/p8
         Qvi+h9iM4NP4EBH1tVd6qJHcv0jm6okdCZ4Ls1pNG2+TTvU+LYxK7TpxXZ6Q7eyfj+Y7
         j+Ftf+ScPpkQIm48PQtq/jwQUSOXLYarNVApqSwGR6oAEZsNPYYLGU4HScRgW7eYwd+5
         Is9wHToVMKvlmI/9n0HHwtekHXWb6W7Ear8L3w90TFWQYeV9htXaHrqb9P+cxYBnYOwn
         cUcw==
X-Gm-Message-State: APjAAAXNHY9jmMEcDFBjfdp+Yr1MhGT/gkci45bkcjqejMsqzjGY7Nay
        DEIGMH5UFo7LnqcB1QtcRqY=
X-Google-Smtp-Source: APXvYqwbhhV9N6SY1MyzCV7zGOyh0Ck15qjiRFB99mBVTj/3p1/lpntOgFfoR4xVFUGQs+b4j2ihug==
X-Received: by 2002:a05:620a:100d:: with SMTP id z13mr9428194qkj.475.1575563065667;
        Thu, 05 Dec 2019 08:24:25 -0800 (PST)
Received: from localhost.localdomain ([2001:470:b:9c3:9e5c:8eff:fe4f:f2d0])
        by smtp.gmail.com with ESMTPSA id 17sm5111246qkk.81.2019.12.05.08.24.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Dec 2019 08:24:25 -0800 (PST)
Subject: [PATCH v15 QEMU 2/3] virtio-balloon: Add bit to notify guest of
 unused page reporting
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
Date:   Thu, 05 Dec 2019 08:24:22 -0800
Message-ID: <20191205162422.19737.57728.stgit@localhost.localdomain>
In-Reply-To: <20191205161928.19548.41654.stgit@localhost.localdomain>
References: <20191205161928.19548.41654.stgit@localhost.localdomain>
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

