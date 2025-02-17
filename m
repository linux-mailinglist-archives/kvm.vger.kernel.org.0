Return-Path: <kvm+bounces-38352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D6591A37F91
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:13:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DFA80189A9F3
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABA87218592;
	Mon, 17 Feb 2025 10:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XHsffdNj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4165121766A;
	Mon, 17 Feb 2025 10:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739786815; cv=none; b=YFINC+Nv1rV9+HnURn5HftcNY5PD3hcmPG1rFfy5uU/cnv7RpxnBki1QuaNYz+A5Sk1N2tcPUBdwdV3u/WAW7ENq8825yxqX2c2G2UjabYm8BfY1CzUrG6XmkYD6n2123+S/riZrYJEZWFenA9XWu3QUrHQtsK5tnhqvbMAueHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739786815; c=relaxed/simple;
	bh=558d9/IVBYnUtRILUcTAq7bt9vxz/+fiXDjqRWuB0eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmmkeZx+Tkk1L1QxO75ZoDfJzR2wNwVpFlzQ9gU3Xx+mP3qQ+M9zD/z7z6OzBA00naqvyLLy5NJKc0uRdayYtt7moY4oi1kX80ru+lkD6dctVEIlja8+NvCrcW6da0J7rVKeskw6lSB7BudoTxkysJJDFfGvMb/e6cMuw9z53rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XHsffdNj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51H18nQ3015205;
	Mon, 17 Feb 2025 10:06:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=hfJFI3kZ5VCZCB7Js
	iW1N0I9+4gi+bwnuBr+APbwOWM=; b=XHsffdNjZW9RU6XdKadUkM7y5zlbzMBE1
	FDBJ2nSkVyq/CBNy+m4vIPUp4c3sLDOxNWfeIUrjm5DNVbA6VQ/iJq06Ks3+0sMM
	3oVLBXF5+MSwMWmSIW4g3VET5imQNGDUP8UrKV0Uz9beE6aQimq8u3I0hr2Zj2FQ
	iLARE46GOFDZ4MbZqvwItbS+CrArxxhcXPqgUpEcjfhVET2ERBVdXwtT4oAmjdri
	3PceJXI72DYj7q7gI31sC2lyYO3j6FXMiB5wLL+5wjlVVnVP487NuN+852+Uao2d
	KFD6Cp6kSZpfHxBcjOxFfT1kFSQXcFChJEy6edICb7vuixn7AqSgA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44uu69a51n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Feb 2025 10:06:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51H8MxO4001633;
	Mon, 17 Feb 2025 10:06:29 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 44u5mynnna-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Feb 2025 10:06:29 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51HA6Pjg55443788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Feb 2025 10:06:25 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8465E20063;
	Mon, 17 Feb 2025 10:06:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 476F82006A;
	Mon, 17 Feb 2025 10:06:25 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Feb 2025 10:06:25 +0000 (GMT)
From: Halil Pasic <pasic@linux.ibm.com>
To: Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Thorsten Blum <thorsten.blum@linux.dev>
Subject: [PATCH 2/2] s390/vfio-ccw: make mdev_types not look like a fake flex array
Date: Mon, 17 Feb 2025 11:06:14 +0100
Message-ID: <20250217100614.3043620-3-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250217100614.3043620-1-pasic@linux.ibm.com>
References: <20250217100614.3043620-1-pasic@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Nisoc6HnoD0j1Gl5QcbaBTgUpqRHKjHX
X-Proofpoint-ORIG-GUID: Nisoc6HnoD0j1Gl5QcbaBTgUpqRHKjHX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-17_04,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 suspectscore=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0 mlxlogscore=888
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2501170000 definitions=main-2502170088

The vfio-ccw driver and the vfio parent device provided by it (parent)
support just a single mdev_type, and this is not likely to change any
time soon. To match the mdev interfaces nicely initially the choice was
made that mdev_types (which gets passed into mdev_register_parent())
shall be an array of pointers to struct mdev_type with a single element,
and to make things worse it ended up being the last member.

Now the problem with that is that before C99 the usual way to get
something similar to a flexible array member was to use a trailing array
of size 0 or 1. This is what I called fake flex array. For a while now
the community is trying to get rid of fake flex arrays. And while
mdev_types was not a fake flex array but an array of size one, because
it can easily be and probably was mistaken for a fake flex array it got
converted into a real C99 flex array with a compile time known constant
size of one.

As per [1] it was established that "only fake flexible arrays should be
transformed into C99 flex-array members". Since IMHO the entire point of
flex arrays is being flexible about the array size at run time, a C99
flex array is a poor fit for mdev_types.  But an array of a size one is
a poor fit as well for the reason stated above, let us try to get rid of
the flex array without introducing back the one sized array.

So, lets make mdev_types a pointer to struct mdev_type and pass in the
address of that pointer as the 4th formal parameter of
mdev_register_parent().

[1] https://lore.kernel.org/lkml/85863d7a-2d8b-4c1b-b76a-e2f40834a7a8@embeddedor.com/

Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Tested-by: Eric Farman <farman@linux.ibm.com>

---

I've also considered switching up the order in which the members
mdev_types and mdev_type are defined in struct vfio_ccw_parent but
decided against that because that could look to somebody like
well known mistake that can be made when using fake flex arrays.
---
 drivers/s390/cio/vfio_ccw_drv.c     | 6 +++---
 drivers/s390/cio/vfio_ccw_private.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/vfio_ccw_drv.c b/drivers/s390/cio/vfio_ccw_drv.c
index 914dde041675..6ff5c9cfb7ed 100644
--- a/drivers/s390/cio/vfio_ccw_drv.c
+++ b/drivers/s390/cio/vfio_ccw_drv.c
@@ -171,7 +171,7 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 		return -ENODEV;
 	}
 
-	parent = kzalloc(struct_size(parent, mdev_types, 1), GFP_KERNEL);
+	parent = kzalloc(sizeof(*parent), GFP_KERNEL);
 	if (!parent)
 		return -ENOMEM;
 
@@ -186,10 +186,10 @@ static int vfio_ccw_sch_probe(struct subchannel *sch)
 
 	parent->mdev_type.sysfs_name = "io";
 	parent->mdev_type.pretty_name = "I/O subchannel (Non-QDIO)";
-	parent->mdev_types[0] = &parent->mdev_type;
+	parent->mdev_types = &parent->mdev_type;
 	ret = mdev_register_parent(&parent->parent, &sch->dev,
 				   &vfio_ccw_mdev_driver,
-				   parent->mdev_types, 1);
+				   &parent->mdev_types, 1);
 	if (ret)
 		goto out_unreg;
 
diff --git a/drivers/s390/cio/vfio_ccw_private.h b/drivers/s390/cio/vfio_ccw_private.h
index b62bbc5c6376..0501d4bbcdbd 100644
--- a/drivers/s390/cio/vfio_ccw_private.h
+++ b/drivers/s390/cio/vfio_ccw_private.h
@@ -79,7 +79,7 @@ struct vfio_ccw_parent {
 
 	struct mdev_parent	parent;
 	struct mdev_type	mdev_type;
-	struct mdev_type	*mdev_types[];
+	struct mdev_type	*mdev_types;
 };
 
 /**
-- 
2.45.2


