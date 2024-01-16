Return-Path: <kvm+bounces-6341-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3838682F1ED
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 16:54:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 68F441C23360
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 15:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37AEE1CA85;
	Tue, 16 Jan 2024 15:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ihMJO76X"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D3C1C6BA;
	Tue, 16 Jan 2024 15:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40GFb9bl000351;
	Tue, 16 Jan 2024 15:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=97MHNMQvroPsQ7l3OcwOf2G2VgJ3sRCWBpF6Bp8pnCo=;
 b=ihMJO76X9sC7gXQ75gCE7ALl+v0NiMS7MG1VFOooSMQ0b1xynvW4PSoD2gjr+jLpUjW/
 RYOH41b55L6ngLbPb9sFTIVIEUqD+k2xSDs4QETqxgK3h3C60kEZgvIZ2Aj7w4qlYw47
 3Wc4V1PcL/dZi0ed5DSaFiRHxv137/Vpc3RBniwz7FjDQ7FtRpHjV4XbcXCQrA0HAJGs
 ZHkFUvD+bJwFwcLSoU/8mWrKizSBzAFqX7/RTmbkzkLTooUUJ/C3zkbxZRSLoLhIxJkA
 jkYLtCSqalTBj++VVWW0+sSFVjQ23c+fAFumCTPnDu2TVuT1VybZ1J1fxtI4+7EKJK1R bQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnvkn8j7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 15:54:04 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40GFblO9004401;
	Tue, 16 Jan 2024 15:54:04 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnvkn8j79-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 15:54:04 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40GDTMK6023421;
	Tue, 16 Jan 2024 15:54:03 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vm6bkfbu0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 15:54:03 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40GFrw7I42467798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 15:53:58 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0DE2F2004B;
	Tue, 16 Jan 2024 15:53:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0E80F20040;
	Tue, 16 Jan 2024 15:53:57 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.49.101])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Jan 2024 15:53:56 +0000 (GMT)
Date: Tue, 16 Jan 2024 16:53:55 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, gor@linux.ibm.com
Subject: Re: [PATCH v4 3/6] s390/vfio-ap: let 'on_scan_complete' callback
 filter matrix and update guest's APCB
Message-ID: <ZaamkyuOET+1rOSm@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240115185441.31526-1-akrowiak@linux.ibm.com>
 <20240115185441.31526-4-akrowiak@linux.ibm.com>
 <ZaY/fGxUMx2z4OQH@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <4eb35fab-eb85-487d-90cd-c4b10b8410ec@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4eb35fab-eb85-487d-90cd-c4b10b8410ec@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Qe49cQtLJH46-BX-ssslh2WAuKu3_Qae
X-Proofpoint-ORIG-GUID: L92aSjxdJRR6io0SwljeFoGIcqZgHe8d
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_08,2024-01-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 mlxlogscore=542 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401160125

On Tue, Jan 16, 2024 at 09:57:25AM -0500, Tony Krowiak wrote:
> This patch is more of an enhancement as opposed to a bug, so no Fixes.

The preceding and rest of this series CCs stable@vger.kernel.org and
would not apply without this patch. So I guess backporting the whole
series would be difficult.

Whether propagating the prevous patches' Fixes/stable makes any sense?

Thanks!

