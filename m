Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C474D1559
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 11:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346084AbiCHLA3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 06:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346069AbiCHLA0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 06:00:26 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17F5841F8A
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 02:59:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646737169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aqPCGU3/YxaZYETOn7Lp2yXhW5De7uTDNtK+spwoHhQ=;
        b=B8zRqxlj6tUvCIQEM0VATH5HXq17MrfwGV3ViUWOV4vl031ZRMEgGx5T9J+onLDN06Qxqb
        tHujEFEjhRHlDq5Gi44oTZjKbFxoJrD/wPVdnwDqMfcuVGKi5XaoETPb7eW3XD9uVssC6H
        iZwqU8SssokTdQuOtS9lzwlk7nsOnQw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-391-rc6sWkT3NxS1VHxqq63bzA-1; Tue, 08 Mar 2022 05:59:25 -0500
X-MC-Unique: rc6sWkT3NxS1VHxqq63bzA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6412C800050;
        Tue,  8 Mar 2022 10:59:23 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 82C976FB03;
        Tue,  8 Mar 2022 10:59:22 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org
Subject: [PATCH 2/3] mm: use vmalloc_array and vcalloc for array allocations
Date:   Tue,  8 Mar 2022 05:59:17 -0500
Message-Id: <20220308105918.615575-3-pbonzini@redhat.com>
In-Reply-To: <20220308105918.615575-1-pbonzini@redhat.com>
References: <20220308105918.615575-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of using array_size or just a multiply, use a function that
takes care of both the multiplication and the overflow checks.

Cc: linux-mm@kvack.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 mm/percpu-stats.c | 2 +-
 mm/swap_cgroup.c  | 4 +---
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/mm/percpu-stats.c b/mm/percpu-stats.c
index c6bd092ff7a3..e71651cda2de 100644
--- a/mm/percpu-stats.c
+++ b/mm/percpu-stats.c
@@ -144,7 +144,7 @@ static int percpu_stats_show(struct seq_file *m, void *v)
 	spin_unlock_irq(&pcpu_lock);
 
 	/* there can be at most this many free and allocated fragments */
-	buffer = vmalloc(array_size(sizeof(int), (2 * max_nr_alloc + 1)));
+	buffer = vmalloc_array(2 * max_nr_alloc + 1, sizeof(int));
 	if (!buffer)
 		return -ENOMEM;
 
diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
index 7f34343c075a..5a9442979a18 100644
--- a/mm/swap_cgroup.c
+++ b/mm/swap_cgroup.c
@@ -167,14 +167,12 @@ unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
 int swap_cgroup_swapon(int type, unsigned long max_pages)
 {
 	void *array;
-	unsigned long array_size;
 	unsigned long length;
 	struct swap_cgroup_ctrl *ctrl;
 
 	length = DIV_ROUND_UP(max_pages, SC_PER_PAGE);
-	array_size = length * sizeof(void *);
 
-	array = vzalloc(array_size);
+	array = vcalloc(length, sizeof(void *));
 	if (!array)
 		goto nomem;
 
-- 
2.31.1



