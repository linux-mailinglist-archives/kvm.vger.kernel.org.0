Return-Path: <kvm+bounces-6360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE53782F570
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 20:34:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 694272866E4
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 19:34:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AC5B1D541;
	Tue, 16 Jan 2024 19:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nQ2He1Hg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8C51D521;
	Tue, 16 Jan 2024 19:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705433659; cv=none; b=DnoDJ9qOs3aYv0gp+cFCwP2AUrp2X/0DWGxC8nz6PpzKgtBBq8dJBMAvbqM/pnfFWPgYwsMAStnx6VpEQJ5XeZU55SsEyT2S3Em5CcF/TpdPhzAFwqsktRIwJPj9dk1Xqy/LkWufy1VqUZ7z1u/Zoo4gM6vrA7QO66aC0FuWpMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705433659; c=relaxed/simple;
	bh=Mcd1b64Vm+CHXiONNdtt+LcCzFybfKPnMfbrChadFrU=;
	h=Received:DKIM-Signature:Received:Received:Received:Received:
	 Received:Received:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-TM-AS-GCONF:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details; b=UD8uk/J/d0TB2DRG8fjmXe/oY4Z6mNOmB39YC3uJhF+6ZYMmscM2gufU7F8gDjMPdKV8Flwbk+0/+A/+hqODFWkJXU6/PHohGf9e5jQlaZjzC7cpe0zOjKzjfZBDzIA6rz+JvwcKfww6L0fr1hAsaYflqZoB6av+F4GVBXk8rvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nQ2He1Hg; arc=none smtp.client-ip=148.163.156.1
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40GJS1au017967;
	Tue, 16 Jan 2024 19:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=Mcd1b64Vm+CHXiONNdtt+LcCzFybfKPnMfbrChadFrU=;
 b=nQ2He1Hge2Lmt1cSCZiK+88s/vslBaKgm9xjvKEUOkRKDK6M/aBFl0Ny+oHxurdqW5ET
 AphaptcgjC5Y+37zzs5YoHu2l4Az99qr9RKloqbAu87gW44EBp/EzVkUdl3+/GugpNsB
 +FiNLR2/BrGiGqRjUTvca+ccev0M3ZwPQ100Tj+7eww+hpG9jsIh/d75tNt0kzih0fX6
 ST54HSVnVNwWG/mr5Ula3WxvHyHeuzvyFQquvpA68N8qqZhD9vvuerdOl7i6oCt5DtuO
 F899gKEO1qtv9B9YFtkZANiQgs3IILdC7e37fEQMJYEWi11vd0YuNIhu0EM+dMEd+v9k wA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnykn8x95-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:34:13 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40GJ3CBo019046;
	Tue, 16 Jan 2024 19:34:13 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnykn8x86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:34:13 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40GJ1fRt010969;
	Tue, 16 Jan 2024 19:34:11 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vm57ygu86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:34:11 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40GJY61423134924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 19:34:06 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 84BF82005A;
	Tue, 16 Jan 2024 19:34:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 357CC2004B;
	Tue, 16 Jan 2024 19:34:05 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.88.12])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Jan 2024 19:34:05 +0000 (GMT)
Date: Tue, 16 Jan 2024 20:34:03 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Anthony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, gor@linux.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH v4 4/6] s390/vfio-ap: reset queues filtered from the
 guest's AP config
Message-ID: <ZabaK3DxABHiGh8V@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240115185441.31526-1-akrowiak@linux.ibm.com>
 <20240115185441.31526-5-akrowiak@linux.ibm.com>
 <ZabGAx5BpIiYW+b3@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <a54e223c-8965-480c-9361-b483b47502d0@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a54e223c-8965-480c-9361-b483b47502d0@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t7leTYHrFA54YdoXPwKrZjRvj_CSCmXn
X-Proofpoint-ORIG-GUID: -It2vX2kJvngxepizgDOPQRFRmwQwVXm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_12,2024-01-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 impostorscore=0
 phishscore=0 priorityscore=1501 mlxscore=0 clxscore=1015 bulkscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=550 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401160154

On Tue, Jan 16, 2024 at 02:21:23PM -0500, Anthony Krowiak wrote:
> > If this change is intended?
> Shall I fix this and submit a v5?

No, I will handle it.

