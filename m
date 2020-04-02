Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57EBB19C919
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 20:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389923AbgDBSsz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 14:48:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:55806 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389925AbgDBSsf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 14:48:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585853315;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/TA1qIm6g7bOjJwF/S4q/AnUgMbYOhvn3awtkZe9/dU=;
        b=hkKARblDfnEQkJBePTHDiQ9rjQswJz+rEBl0rVMkgR8pF9qnf1f/ssu0+SIBAjjHRGugoe
        ESymxc7xA/SYhptFhcoUljMfjaLKZvira1n1czPz2AyJC+qNChfMdX8hv+jw4+o6cIgjOg
        FX8gggI0Ab2eXzebaI0x+OqVajhXUPI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-w-A29iO4NzGTkB53sIYlYw-1; Thu, 02 Apr 2020 14:48:33 -0400
X-MC-Unique: w-A29iO4NzGTkB53sIYlYw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 046971926DA0;
        Thu,  2 Apr 2020 18:48:32 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-114-29.ams2.redhat.com [10.36.114.29])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1E3E860BF3;
        Thu,  2 Apr 2020 18:48:29 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 3/5] KVM: s390: vsie: Fix possible race when shadowing region 3 tables
Date:   Thu,  2 Apr 2020 20:48:17 +0200
Message-Id: <20200402184819.34215-4-david@redhat.com>
In-Reply-To: <20200402184819.34215-1-david@redhat.com>
References: <20200402184819.34215-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We have to properly retry again by returning -EINVAL immediately in case
somebody else instantiated the table concurrently. We missed to add the
goto in this function only. The code now matches the other, similar
shadowing functions.

We are overwriting an existing region 2 table entry. All allocated pages
are added to the crst_list to be freed later, so they are not lost
forever. However, when unshadowing the region 2 table, we wouldn't trigge=
r
unshadowing of the original shadowed region 3 table that we replaced. It
would get unshadowed when the original region 3 table is modified. As it'=
s
not connected to the page table hierarchy anymore, it's not going to get
used anymore. However, for a limited time, this page table will stick
around, so it's in some sense a temporary memory leak.

Identified by manual code inspection. I don't think this classifies as
stable material.

Fixes: 998f637cc4b9 ("s390/mm: avoid races on region/segment/page table s=
hadowing")
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/mm/gmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index f3dbc5bdde50..fd32ab566f57 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -1844,6 +1844,7 @@ int gmap_shadow_r3t(struct gmap *sg, unsigned long =
saddr, unsigned long r3t,
 		goto out_free;
 	} else if (*table & _REGION_ENTRY_ORIGIN) {
 		rc =3D -EAGAIN;		/* Race with shadow */
+		goto out_free;
 	}
 	crst_table_init(s_r3t, _REGION3_ENTRY_EMPTY);
 	/* mark as invalid as long as the parent table is not protected */
--=20
2.25.1

