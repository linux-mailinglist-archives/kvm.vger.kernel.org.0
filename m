Return-Path: <kvm+bounces-38351-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BA95A37F7D
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 11:11:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC042164BF3
	for <lists+kvm@lfdr.de>; Mon, 17 Feb 2025 10:08:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44BCD217F42;
	Mon, 17 Feb 2025 10:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hl9UMODj"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B4B217655;
	Mon, 17 Feb 2025 10:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739786815; cv=none; b=XMiBAvgX25/TY1xNPbD1zafZ4Bzu+ZV3J9gPj9QxWBhTHEIJHbtENOCxW+ypNeUtC34sEE/WMonKlFb0vgtck4AymPLx455TD/xtreDE08+YjXEC+0eY06OTYmnoMat1l5VUj7uo9d6e08/GwrI1DJ3YlEwE4vHLGHYuGxDuOME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739786815; c=relaxed/simple;
	bh=j5VHs6nDo+LErC7+EGV3O5FcqHXIOoqXibrmzd3Mv6U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=U/9SWHqIF72xbAM3qgJABtpjLlMvkMwAvHCFEnnO47vKb7vJouoJoOvvNL9IxrSJERyT6lnvNL5VE0K3HOJK+NyDP8qH35LeydGf2ADF3f9D0jYjSfh90YaHQh1RRWsy+PmsiGt4t0mbXBJBOL0DVUNkIBcOE2PDONgvIXhC7ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hl9UMODj; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51GMntZi029270;
	Mon, 17 Feb 2025 10:06:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=ZEkPVW7faAJDCVj+aAjWOoLetezE44LciwkUaS9Ah
	f0=; b=hl9UMODj9I7q/X8W+Tah58Er2066/x+KoclWaxO/ulkK1ztCP1x6zNJvv
	GHfsuLHcmpNJRSHsrvIW+qNwnJK+5r1TynqsI4rEwGK6ESSHUN3pWyxf5paHgj0u
	/W6a5u1WZz2JF2yVA9D1HgeQ9di7dIbtKJQjvbgcguh9zHiKrThaev+f2Kl4xuEx
	fBBoVSqlrqmFMngKlN0wcRr2bZ+kf8nQamExtC8ITEHerS7j7UsJxe9hDDYEz/hl
	vrbv/j4Tke0+/i60OaU5lNYoBrgNOi/xJeypXv8j2WWjuWrVJ48n5uSIAHMDrPK5
	Rg3y0QZ/8yu1EezApEp7Wyv0aN7RA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44us5a2gfx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Feb 2025 10:06:28 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 51H9hKod013270;
	Mon, 17 Feb 2025 10:06:27 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 44u7fkdad0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Feb 2025 10:06:27 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 51HA6N1k60293482
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Feb 2025 10:06:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4040B2004E;
	Mon, 17 Feb 2025 10:06:23 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB6162005A;
	Mon, 17 Feb 2025 10:06:22 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Feb 2025 10:06:22 +0000 (GMT)
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
Subject: [PATCH 0/2] s390/vfio-*: make mdev_types unlike a fake flex array
Date: Mon, 17 Feb 2025 11:06:12 +0100
Message-ID: <20250217100614.3043620-1-pasic@linux.ibm.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: o6s14Dm0SU4F77j-7qARPX2v38sLMj2V
X-Proofpoint-GUID: o6s14Dm0SU4F77j-7qARPX2v38sLMj2V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-17_04,2025-02-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 mlxlogscore=409 suspectscore=0 phishscore=0 impostorscore=0 bulkscore=0
 spamscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2501170000
 definitions=main-2502170088


One sized trailing array members can look like fake flex arrays and
confuse people. Let us try to make the mdev_types member of the parent
devices in vfio-ap and vfio-ccw less confusing.


Halil Pasic (2):
  s390/vfio-ap: make mdev_types not look like a fake flex array
  s390/vfio-ccw: make mdev_types not look like a fake flex array

 drivers/s390/cio/vfio_ccw_drv.c       | 6 +++---
 drivers/s390/cio/vfio_ccw_private.h   | 2 +-
 drivers/s390/crypto/vfio_ap_ops.c     | 4 ++--
 drivers/s390/crypto/vfio_ap_private.h | 2 +-
 4 files changed, 7 insertions(+), 7 deletions(-)


base-commit: 0ad2507d5d93f39619fc42372c347d6006b64319
-- 
2.45.2


