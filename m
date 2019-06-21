Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F6CE4EAB9
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2019 16:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfFUOeN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jun 2019 10:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7925 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbfFUOeN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jun 2019 10:34:13 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 61B3FA101D;
        Fri, 21 Jun 2019 14:34:12 +0000 (UTC)
Received: from localhost (dhcp-192-192.str.redhat.com [10.33.192.192])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 79B7A60BFB;
        Fri, 21 Jun 2019 14:34:11 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Cornelia Huck <cohuck@redhat.com>
Subject: [PULL 05/14] vfio-ccw: Rearrange pfn_array and pfn_array_table arrays
Date:   Fri, 21 Jun 2019 16:33:46 +0200
Message-Id: <20190621143355.29175-6-cohuck@redhat.com>
In-Reply-To: <20190621143355.29175-1-cohuck@redhat.com>
References: <20190621143355.29175-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 21 Jun 2019 14:34:12 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Eric Farman <farman@linux.ibm.com>

While processing a channel program, we currently have two nested
arrays that carry a slightly different structure.  The direct CCW
path creates this:

  ccwchain->pfn_array_table[1]->pfn_array[#pages]

while an IDA CCW creates:

  ccwchain->pfn_array_table[#idaws]->pfn_array[1]

The distinction appears to state that each pfn_array_table entry
points to an array of contiguous pages, represented by a pfn_array,
um, array.  Since the direct-addressed scenario can ONLY represent
contiguous pages, it makes the intermediate array necessary but
difficult to recognize.  Meanwhile, since an IDAL can contain
non-contiguous pages and there is no logic in vfio-ccw to detect
adjacent IDAWs, it is the second array that is necessary but appearing
to be superfluous.

I am not aware of any documentation that states the pfn_array[] needs
to be of contiguous pages; it is just what the code does today.
I don't see any reason for this either, let's just flip the IDA
codepath around so that it generates:

  ch_pat->pfn_array_table[1]->pfn_array[#idaws]

This will bring it in line with the direct-addressed codepath,
so that we can understand the behavior of this memory regardless
of what type of CCW is being processed.  And it means the casual
observer does not need to know/care whether the pfn_array[]
represents contiguous pages or not.

NB: The existing vfio-ccw code only supports 4K-block Format-2 IDAs,
so that "#pages" == "#idaws" in this area.  This means that we will
have difficulty with this overlap in terminology if support for
Format-1 or 2K-block Format-2 IDAs is ever added.  I don't think that
this patch changes our ability to make that distinction.

Signed-off-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Message-Id: <20190606202831.44135-6-farman@linux.ibm.com>
Signed-off-by: Cornelia Huck <cohuck@redhat.com>
---
 drivers/s390/cio/vfio_ccw_cp.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_cp.c b/drivers/s390/cio/vfio_ccw_cp.c
index 5b98bea433b7..86a0e76ef2b5 100644
--- a/drivers/s390/cio/vfio_ccw_cp.c
+++ b/drivers/s390/cio/vfio_ccw_cp.c
@@ -635,7 +635,6 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 {
 	struct ccw1 *ccw;
 	struct pfn_array_table *pat;
-	struct pfn_array *pa;
 	unsigned long *idaws;
 	u64 idaw_iova;
 	unsigned int idaw_nr, idaw_len;
@@ -656,10 +655,14 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 
 	/* Pin data page(s) in memory. */
 	pat = chain->ch_pat + idx;
-	ret = pfn_array_table_init(pat, idaw_nr);
+	ret = pfn_array_table_init(pat, 1);
 	if (ret)
 		goto out_init;
 
+	ret = pfn_array_alloc(pat->pat_pa, idaw_iova, bytes);
+	if (ret)
+		goto out_unpin;
+
 	/* Translate idal ccw to use new allocated idaws. */
 	idaws = kzalloc(idaw_len, GFP_DMA | GFP_KERNEL);
 	if (!idaws) {
@@ -673,22 +676,15 @@ static int ccwchain_fetch_idal(struct ccwchain *chain,
 
 	ccw->cda = virt_to_phys(idaws);
 
-	for (i = 0; i < idaw_nr; i++) {
-		idaw_iova = *(idaws + i);
-		pa = pat->pat_pa + i;
-
-		ret = pfn_array_alloc(pa, idaw_iova, 1);
-		if (ret < 0)
-			goto out_free_idaws;
-
-		if (!ccw_does_data_transfer(ccw)) {
-			pa->pa_nr = 0;
-			continue;
-		}
+	for (i = 0; i < idaw_nr; i++)
+		pat->pat_pa->pa_iova_pfn[i] = idaws[i] >> PAGE_SHIFT;
 
-		ret = pfn_array_pin(pa, cp->mdev);
+	if (ccw_does_data_transfer(ccw)) {
+		ret = pfn_array_pin(pat->pat_pa, cp->mdev);
 		if (ret < 0)
 			goto out_free_idaws;
+	} else {
+		pat->pat_pa->pa_nr = 0;
 	}
 
 	pfn_array_table_idal_create_words(pat, idaws);
-- 
2.20.1

