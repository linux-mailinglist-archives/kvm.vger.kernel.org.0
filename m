Return-Path: <kvm+bounces-6086-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 03EDB82B07A
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 15:18:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 93DE11F24CEA
	for <lists+kvm@lfdr.de>; Thu, 11 Jan 2024 14:18:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8376E3D3AB;
	Thu, 11 Jan 2024 14:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aTWSFowT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D7DD29CFA;
	Thu, 11 Jan 2024 14:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40BDUnAQ019952;
	Thu, 11 Jan 2024 14:18:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=mTSColWjPxMy5hFmeWj7zZt2o1PCif6a70FoRgHVrZQ=;
 b=aTWSFowTkjelJhZBVITSLaXkzq3HRXeI5eTrgg3uwZCeXNIyg0mve+dUxrQpx6kNUy6c
 mwXJi7oh+C1zpGEj6Rwt1EK7DILkw8G9EO+J090O43zfnWHD5J36oVKdSCZ9qzRMR2ym
 THXeqNr3rpmaqZZQ0354vRxve7flgMSxLfxXcpXd13h9eBhy4nsgz064P0OpWKQbSNmO
 0bOfgu+Xau/ePlskVXhWWGkt+2BiHj7lPKDutU2XZGJRDRR3KtVzTC3r7JR/WpYVfyRh
 zLwCjpAhHWVOLoP5MCQhfHtQXr/n3wJ7QhWTUJ7mPjlE1DnI/Cj3lquQrCWj8NAlaCuN 3g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vjh2yhgtr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:18:02 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40BDYLoM001569;
	Thu, 11 Jan 2024 14:18:01 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vjh2yhgt2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:18:00 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40BE1gOo027421;
	Thu, 11 Jan 2024 14:17:59 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vfkw2bd00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Jan 2024 14:17:59 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40BEHsvW61342140
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Jan 2024 14:17:54 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 974B42004D;
	Thu, 11 Jan 2024 14:17:54 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6CB1920043;
	Thu, 11 Jan 2024 14:17:54 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.152.224.212])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 11 Jan 2024 14:17:54 +0000 (GMT)
Date: Thu, 11 Jan 2024 15:17:18 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        pbonzini@redhat.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        stable@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH v2 6/6] s390/vfio-ap: do not reset queue removed from
 host config
Message-ID: <20240111151718.5d32e747.pasic@linux.ibm.com>
In-Reply-To: <20231212212522.307893-7-akrowiak@linux.ibm.com>
References: <20231212212522.307893-1-akrowiak@linux.ibm.com>
	<20231212212522.307893-7-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oNnj3N06fsAPsUgWGBMUGXTJnQ03Nntt
X-Proofpoint-ORIG-GUID: yS9H-1cmFgokDSIXfEidxa7IeLBvAi34
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-11_07,2024-01-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 bulkscore=0 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=999 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401110113

On Tue, 12 Dec 2023 16:25:17 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> When a queue is unbound from the vfio_ap device driver, it is reset to
> ensure its crypto data is not leaked when it is bound to another device
> driver. If the queue is unbound due to the fact that the adapter or domain
> was removed from the host's AP configuration, then attempting to reset it
> will fail with response code 01 (APID not valid) getting returned from the
> reset command. Let's ensure that the queue is assigned to the host's
> configuration before resetting it.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

