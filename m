Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D10B19DA23
	for <lists+kvm@lfdr.de>; Fri,  3 Apr 2020 17:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404323AbgDCPbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Apr 2020 11:31:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41715 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404311AbgDCPbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Apr 2020 11:31:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585927871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o9+iQkDrjMDPGfCAP/TxUctBQwhHf6q/sd2P4Ro4S4c=;
        b=MgG92rfStsvdHo/aT5/hI1lSjdqHbIoTRaccHa7AMdOTBnK66kLapOXGMOPNrUqBx1DLZr
        ScdEx6Xadu2uC8h/xkPzavNk7xx3DDjH7ktCoXWhO5lvOAQzPl2R2gA8zuPJZEqSXb6Qrg
        T426Xdbe/OmdSwFCyZ4nqZ6FTyDaTW0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-282-f7XVJwvaPGuR86Le5qU1SQ-1; Fri, 03 Apr 2020 11:31:10 -0400
X-MC-Unique: f7XVJwvaPGuR86Le5qU1SQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDC4D8017CE;
        Fri,  3 Apr 2020 15:31:08 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-112-213.ams2.redhat.com [10.36.112.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D633626DC4;
        Fri,  3 Apr 2020 15:31:06 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vasily Gorbik <gor@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 5/5] KVM: s390: vsie: gmap_table_walk() simplifications
Date:   Fri,  3 Apr 2020 17:30:50 +0200
Message-Id: <20200403153050.20569-6-david@redhat.com>
In-Reply-To: <20200403153050.20569-1-david@redhat.com>
References: <20200403153050.20569-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Let's use asce_type where applicable. Also, simplify our sanity check for
valid table levels and convert it into a WARN_ON_ONCE(). Check if we even
have a valid gmap shadow as the very first step.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/s390/mm/gmap.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index 24ef30fb0833..a2bd8d7792e9 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -788,19 +788,19 @@ static inline unsigned long *gmap_table_walk(struct=
 gmap *gmap,
 					     unsigned long gaddr, int level)
 {
 	const int asce_type =3D gmap->asce & _ASCE_TYPE_MASK;
-	unsigned long *table;
+	unsigned long *table =3D gmap->table;
=20
-	if ((gmap->asce & _ASCE_TYPE_MASK) + 4 < (level * 4))
-		return NULL;
 	if (gmap_is_shadow(gmap) && gmap->removed)
 		return NULL;
=20
+	if (WARN_ON_ONCE(level > (asce_type >> 2) + 1))
+		return NULL;
+
 	if (WARN_ON_ONCE(asce_type !=3D _ASCE_TYPE_REGION1 &&
 			 gaddr & (-1UL << (31 + (asce_type >> 2) * 11))))
 		return NULL;
=20
-	table =3D gmap->table;
-	switch (gmap->asce & _ASCE_TYPE_MASK) {
+	switch (asce_type) {
 	case _ASCE_TYPE_REGION1:
 		table +=3D (gaddr & _REGION1_INDEX) >> _REGION1_SHIFT;
 		if (level =3D=3D 4)
--=20
2.25.1

