Return-Path: <kvm+bounces-56862-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 49D81B45025
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 09:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00E1E3A72DF
	for <lists+kvm@lfdr.de>; Fri,  5 Sep 2025 07:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A763726E16A;
	Fri,  5 Sep 2025 07:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="R6+/mzxT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A8F25949A;
	Fri,  5 Sep 2025 07:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757058232; cv=none; b=nvw1V7Bs57Fz2xfV9zOzktvLL4BYP0+HFs8JmiHwP7IGl+y2INZcd1CWI+bHJRqhTS/QXKLTOXzidK/yJIUAePcpt6jYkVV9r1hV+KzEgnsUUrqL2yJk1rIiCJArV+NCyS4kB8/ZqPIPfoJAEVxOI6HH+4YjB5n3ItnEgqxcWrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757058232; c=relaxed/simple;
	bh=0bYal7A9Mfw6l1Bu4l5MRelfZ2+XaanKsRudGT0g5yA=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=P70JEBBN70zzzoabeEbnnRTwJNAv4p+MauGUAWUvWJXu4pA3JkhygzidjoDFWkXkvi+GBofHcpdW1wS3hsnrEMFus1QxfYrw6d0SDgVAlIjflh9L2sYCWaAZUQhyJSyno3qKN7sIjuYKPWqLO22q4fSIQQLNGfYxGWpFg8LnoT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=R6+/mzxT; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5852055h011765;
	Fri, 5 Sep 2025 07:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=oEEJJd
	SczH4IodCLqW3BvAlvdxXVvb+j3d/Km2UYC9A=; b=R6+/mzxTnQ1ImHbu0TfqIo
	jCmOq1jKMrpHlBKD2n38BZhqxQ1/Cz+g6CNmiK95cXjGwolmP7YdmouVLUjwFlCq
	WaMj49z+cSl5tAtG80Lku9m3iFraQk4bCZxohSbOzmb9ce6btPsQY6oyrJ46qyGM
	6tsku+wRniY/VXRE9zzlcGgst7p0gZnVAo35mw0O7wALU91MehnIb5XbY5FHIXxN
	GqJq7NKuWvAhMxeBAAG/mBJETvmEauLzY2vUQ2BInhmzPmq5EIyouAQ1EbLW4p4F
	MEvrwj2OXtE9qr5JTUfWgzeBdNWIcXGa64uO3EBBH0XHw/dDdkjFBzbYTngHQ5Ow
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usurey0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 07:43:48 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58567HXo014052;
	Fri, 5 Sep 2025 07:43:47 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48veb3r4ht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 07:43:47 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5857hhSe20906270
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Sep 2025 07:43:43 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EA03C2004B;
	Fri,  5 Sep 2025 07:43:42 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B561420043;
	Fri,  5 Sep 2025 07:43:42 +0000 (GMT)
Received: from darkmoore (unknown [9.111.83.127])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  5 Sep 2025 07:43:42 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 05 Sep 2025 09:43:37 +0200
Message-Id: <DCKP5LT1UP4K.U48HFEEP8Y9J@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: "KVM" <kvm@vger.kernel.org>, "David Hildenbrand" <david@redhat.com>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Vasily Gorbik" <gor@linux.ibm.com>,
        "Alexander Gordeev" <agordeev@linux.ibm.com>,
        "Sven Schnelle"
 <svens@linux.ibm.com>, <linux-s390@vger.kernel.org>
To: "Christian Borntraeger" <borntraeger@linux.ibm.com>,
        "Janosch Frank"
 <frankja@linux.vnet.ibm.com>,
        "Claudio Imbrenda" <imbrenda@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: improve interrupt cpu for wakeup
X-Mailer: aerc 0.20.1
References: <20250904113927.119306-1-borntraeger@linux.ibm.com>
In-Reply-To: <20250904113927.119306-1-borntraeger@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMCBTYWx0ZWRfX14r5aih/Splu
 72cMGFmY03GlsgO06eB44uaB+h4uCcHm77ygZdodtKwAl37sv75w9hDgMNVNIyrehJ22OvrIT0X
 w/fSI4uLCGzTatBVeS9pVLcW+8F9eXIPubbaknN03O/z4js9VnjI1UWwUMUXiaEnlvNXGeTf0EK
 M1lT+qs++5m/I/yXT+TALB9G+tGuhowSYjSwKXe0Alz9jHaI0nzF88VeMFZh6YXU53Ip17Pp5vf
 ZCTam5spswRIqH6/fEBXIVNIf+hmR/hKx7I49/6g3pT5tAJPPbZhEr5/vep/bObsEo1yYeqUncF
 pNm2oYTVqUJl9yhW/vbyaTCch46PglTKP4mGR887keAdv1BbZC/bTqKxBtxA04ukNxtZU8gIX+e
 011tR7wH
X-Proofpoint-GUID: QN5TsIlycp35FCTzzGvr0tUFfbUV62Dz
X-Proofpoint-ORIG-GUID: QN5TsIlycp35FCTzzGvr0tUFfbUV62Dz
X-Authority-Analysis: v=2.4 cv=Ao/u3P9P c=1 sm=1 tr=0 ts=68ba94b4 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=nicAsf1XB8fbJ-_zqUgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_02,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300030

With nit fixed.

Reviewed-by: Christoph Schlameu=C3=9F <schlameuss@de.ibm.com>

On Thu Sep 4, 2025 at 1:39 PM CEST, Christian Borntraeger wrote:
> Turns out that picking an idle CPU for floating interrupts has some
> negative side effects. The guest will keep the IO workload on its CPU
> and rather use an IPI from the interrupt CPU instead of moving workload.
> For example a guest with 2 vCPUss and 1 fio process might run that fio on
----------------------------------^
nit: vCPUs

> vcpu1. If after diag500 both vCPUs are idle then vcpu0 is woken up. The
> guest will then do an IPI from vcpu0 to vcpu1.
>
> So lets change the heuristics and prefer the last CPU that went to
> sleep. This one is likely still in halt polling and can be woken up
> quickly.
>
> This patch shows significant improvements in terms of bandwidth or
> cpu consumption for fio and uperf workloads and seems to be a net
> win.
>
> Signed-off-by: Christian Borntraeger <borntraeger@linux.ibm.com>
> ---
>  arch/s390/include/asm/kvm_host.h |  2 +-
>  arch/s390/kvm/interrupt.c        | 20 +++++++++-----------
>  2 files changed, 10 insertions(+), 12 deletions(-)

