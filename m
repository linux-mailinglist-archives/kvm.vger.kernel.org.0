Return-Path: <kvm+bounces-6386-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23C778303C9
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 11:41:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 32D9D1C24967
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 10:41:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95F291DA4C;
	Wed, 17 Jan 2024 10:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="W8njSpKI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E021D550;
	Wed, 17 Jan 2024 10:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705488088; cv=none; b=btklVCe+vzHOKQ4cNpEoikk6h0cFd1K808wYu7czRIA8CRNTpqt1BWIeKN/u9WN6uA3FoJPXONoj5B3uPf7wTYFEGOE5UuF96azodaOtF0jnovkXqTYrPgMoQuxG6srOQbzKzpDQ8diMOT/DKrDw3Nkf7k+ti3A2rWYDrUu1Jss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705488088; c=relaxed/simple;
	bh=E3rwFhaOl2j+zeAfDeJ2luuN6OVjKJV3WlO+QINndKM=;
	h=Received:DKIM-Signature:Received:Received:Received:Received:
	 Received:Received:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-TM-AS-GCONF:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details; b=PleJi30lWxtijR04BntWI50NeYLiTebvWtC3yxisKm1Tc02odk03zNix/1SiustUiZm/eWRwMJLEZStb9ywA3Cif1qUylYk+0DRWoEfF30Y7kRt3OtSjvv9XWZb+2rj7QeRyID9ZyGQdrZLkscwj9pAqndpTT+zBrqR12QS9TJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=W8njSpKI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40HA7DHs015455;
	Wed, 17 Jan 2024 10:41:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=YHdck/Ra38gjgZwkdUhVLlxKWwPrh4c3UuG1hGT5OpQ=;
 b=W8njSpKIL/nBQLJyZtQ1x8Iy982B3uxg+9t8ay4kxBeQZj4wUnrmHcgSkevlS6NcCMyy
 mp5BuWGZ131/NSCbcxFALgv788yKAT6dPcvgpFsqMstLxoulqeOlCqYUIXaVA87D5y9U
 n+wGl/H7oHF34TaF9VvJ2+YHsYAQiSAh3/aFNbZzSlcce+T9FhAnVA6gZWxFfSYnQetS
 myK3WWROwmuiE/gvgJ2ttF3zVX8qGG67DL8NJCeznz+3HghfonbSjZclX3fw37lYRPDl
 ROzwMmhgLrXO1IOxLr6co/gEPv/eIbQfKVTKFqGN1uv9VrMnhLh3VBPVpiAFitCIQrhQ 5w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vpcuy913d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jan 2024 10:41:20 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40HA86NG018155;
	Wed, 17 Jan 2024 10:41:19 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vpcuy912p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jan 2024 10:41:19 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40H8a3sP004908;
	Wed, 17 Jan 2024 10:41:18 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vm7j1v74m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 17 Jan 2024 10:41:18 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40HAfDIv27787934
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 17 Jan 2024 10:41:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8287020043;
	Wed, 17 Jan 2024 10:41:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BBD612004B;
	Wed, 17 Jan 2024 10:41:12 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.88.12])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 17 Jan 2024 10:41:12 +0000 (GMT)
Date: Wed, 17 Jan 2024 11:41:11 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, gor@linux.ibm.com
Subject: Re: [PATCH v4 0/6] s390/vfio-ap: reset queues removed from guest's
 AP configuration
Message-ID: <Zaeuxz6+3eqg84+H@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240115185441.31526-1-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115185441.31526-1-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q-VG3TmEKG8OUGkj0jJx4uRmquyQhxs9
X-Proofpoint-GUID: KmINsdUnpHFeaTKRaqBd64el_x2kS-X-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-17_05,2024-01-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 priorityscore=1501 clxscore=1015 bulkscore=0 phishscore=0 suspectscore=0
 mlxlogscore=728 adultscore=0 lowpriorityscore=0 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401170075

On Mon, Jan 15, 2024 at 01:54:30PM -0500, Tony Krowiak wrote:
...
>  drivers/s390/crypto/vfio_ap_ops.c     | 268 +++++++++++++++++---------
>  drivers/s390/crypto/vfio_ap_private.h |  11 +-
>  2 files changed, 184 insertions(+), 95 deletions(-)

Applied with fixups to patches 4 and 5.

Thanks!

