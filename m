Return-Path: <kvm+bounces-6327-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B355E82EAE9
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 09:34:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6325C28529D
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 08:34:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D225125AE;
	Tue, 16 Jan 2024 08:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="d44X7WCb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC8711C83;
	Tue, 16 Jan 2024 08:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40G7w0lc000737;
	Tue, 16 Jan 2024 08:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=2QthArlBLZq6aeSqRFl9tCpSTmPf13Utla69eVdn+G4=;
 b=d44X7WCbEmktfd055Y/6MkcyBX4EzoIm5/dVVtPiPEGJmKk+ivl9esnI9eBtA7KshRak
 BhhYASBpEd2Bw4m1Hk9fYgecJgLSn7yz3VO29PXxLGdsKc03j0LhKWiUp3xqOM4sMP8e
 izAJFADFgOdk8xlEAjDuBGYw5pHH/2/FgheAD98MDphGBECLVTHU6LI/8CK7BklOg9B/
 4PQckxHIufiLqmiernQXQcP8gzmxXpyCSgA6yDu2UeN7kQwTnwUy16sCGr6EmcUTgBQz
 Y1n06xTxPUaaoDKj+4wSkfJ0ZUuPO6qqjkXcNDVHRkXlv2LzTV3f25jb/w6mcaK2OpRS Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnnvd0wpb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 08:34:13 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40G7wiDu003371;
	Tue, 16 Jan 2024 08:34:13 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnnvd0wne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 08:34:13 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40G75leT008785;
	Tue, 16 Jan 2024 08:34:12 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vm57ydknv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 08:34:12 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40G8Y6nb18678426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 08:34:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A454620040;
	Tue, 16 Jan 2024 08:34:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C8DE320043;
	Tue, 16 Jan 2024 08:34:05 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.82.162])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Jan 2024 08:34:05 +0000 (GMT)
Date: Tue, 16 Jan 2024 09:34:04 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, gor@linux.ibm.com
Subject: Re: [PATCH v4 3/6] s390/vfio-ap: let 'on_scan_complete' callback
 filter matrix and update guest's APCB
Message-ID: <ZaY/fGxUMx2z4OQH@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240115185441.31526-1-akrowiak@linux.ibm.com>
 <20240115185441.31526-4-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115185441.31526-4-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: F-SuVrMPFcULgGLnlAYeUzH-KTeEzO3a
X-Proofpoint-ORIG-GUID: sPodZ57JKvrcl3Z3PKuYRtq9lqq8UU18
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_04,2024-01-15_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=695
 lowpriorityscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 adultscore=0 clxscore=1011 phishscore=0 impostorscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401160067

On Mon, Jan 15, 2024 at 01:54:33PM -0500, Tony Krowiak wrote:
Hi Tony,

> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

No Fixes tag for this patch?

Thanks!

