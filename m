Return-Path: <kvm+bounces-18262-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BE18D2BE0
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 07:01:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4F5AE1F25A6A
	for <lists+kvm@lfdr.de>; Wed, 29 May 2024 05:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC6A15B572;
	Wed, 29 May 2024 05:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s6Mkm2O/"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44D815B54F;
	Wed, 29 May 2024 05:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716958876; cv=none; b=VVX8BpV3/xJ02KP+Sz0vX6rvSSADCGXxXbClZbq8J09Uyhbkv3b6jF8oOCt9cMizjWBgVK66MR2yP4DJWmoh88pBkePMPKn4ZsRqk48UqhgEkbxun5Qe/8VSCFIbLMPTfg/FOfwLTkM/EFWmUg3nBCbaqlp1e+re3/xa/8mXcoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716958876; c=relaxed/simple;
	bh=xSqHcKYEDaxxJfuUNzVrGGQy133EFKDCw6O99I9og2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ov5ENeWj7+ed/6LzF6cO2+HQlvKMLuqOLhw/VeOjpEM+mKEGprnMQVfTNSW5W1HSx6/B26E1MNIONHU0gMZLW5i2hlFvGFwQ0xW7CqhHmVhGAb7cF3VC1jP6HlhCMvXlBMnTgAo4CdiXm5WMH15Nodu3hQcEgm8YfYTib4LAhR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=s6Mkm2O/; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44T4blX1000523;
	Wed, 29 May 2024 05:01:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc : content-type : date
 : from : in-reply-to : message-id : mime-version : references : subject :
 to; s=pp1; bh=xSqHcKYEDaxxJfuUNzVrGGQy133EFKDCw6O99I9og2M=;
 b=s6Mkm2O/+HQigUNXpRnK8pes1dELq1cJKBxJ+Ivkal+KJORumKieXjuIlim7BpvC02/B
 4be1g97rPaRVo7ywQjVNOtyT93MuPUUVyA5FS5G5xOz6/speW6sG8JTYcETZ9KsIsauN
 pHMJneV5H7X1ZeChqEUmIJ9Oe/MlWqjPlsQ9SQ7fWp7TJ07nNjyxr29J7MvYq77ggYLC
 QTXIqgAhIx8xUvSWw4ZqQ7QMInnug2N/LyLadaUdb4a+A+DX+e6R+I80rCzJ/NCoO91p
 OHg9+tSPEVgkregiDw+gqM2veYySpFspZzk4llM4ZZsC6NrEGetqU/gcD5Wm6M6Fswi5 lw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ydwgj0222-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 05:01:00 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44T4qvHN022363;
	Wed, 29 May 2024 05:01:00 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ydwgj021x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 05:01:00 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44T4PG6T009811;
	Wed, 29 May 2024 05:00:59 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ydpbbhwb3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 29 May 2024 05:00:59 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44T50tTB46137728
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 May 2024 05:00:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C10752004B;
	Wed, 29 May 2024 05:00:55 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E7EE20040;
	Wed, 29 May 2024 05:00:54 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.204.206.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 29 May 2024 05:00:53 +0000 (GMT)
Date: Wed, 29 May 2024 10:30:51 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        naveen.n.rao@linux.ibm.com, clg@kaod.org
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 0/3] XICS emulation optimizations in KVM for PPC
Message-ID: <oj3kgyo7erm23w5jg4bsik5zzyaknmezurm3i67iy4duxg4jwm@aaqussro73bm>
References: <20240520082014.140697-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240520082014.140697-1-gautam@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iYKXO3KBcQdCEOP_c_8ZoDjnrZyBGoF2
X-Proofpoint-ORIG-GUID: vZxMD4m2KcMZnEI-ezQ6ohrIEzAaxK-X
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_14,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=352 phishscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405290029

Hello,

Please review this series and let me know if any changes are needed.

Thanks,
Gautam

