Return-Path: <kvm+bounces-62763-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D198AC4D62B
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 12:24:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CAF954F90FA
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 11:19:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 081A135581F;
	Tue, 11 Nov 2025 11:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rxnPq/ZE"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5333557F4;
	Tue, 11 Nov 2025 11:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762859969; cv=none; b=EItFS2csFCX3gxQmHk8buV/xH08wvvt3BdqG0pB6W8c5lgpT/DYfKj6Dz7zdWKb+u7fx/R2SJbpUsi856p/zH6Oz3RU3D37/3yJyzY1FGxPvRrhKxqeunmjW8VV9ql48cviMIiXUvF2zMhx5aJW0ZmthIjmVPFNCLqhGax8iHOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762859969; c=relaxed/simple;
	bh=ZCkrLrdtl/TJK7P9GqgfOJ7Yn+ztUjdaPcoi6gbBTGk=;
	h=Mime-Version:Content-Type:Date:Message-Id:From:Cc:To:Subject:
	 References:In-Reply-To; b=u8QXmGn/WrkmKNXDAlfi37ChtlQcGJLPkqLua3rQqVf6OUilkMmyuYBkk2SQkULlpIRFwdfcUXmRzI9Z1WfwabMEljDary/Tl9Qh4GfIn2kCB+kSmsSpsLAiloJZ1C6bg5t8tPAkFMgTTFrykUjWb2h6HYxY3cY7ztgti+MVuak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rxnPq/ZE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AAMWobD003733;
	Tue, 11 Nov 2025 11:19:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ISidRw
	HOdCxNCu4Mw4ATtHZgbgXoK5yMiXFsFpp75N4=; b=rxnPq/ZEdeanfo2PE2HFYt
	ndk5EgL81hX0uRKPzI+HTKHh17YK21TZzCGMiNlM/5VNZVEB/qMp4czR1hIQS3WM
	RlMkGKk4UuNRrvBHtqVq4hincMleZ/cSEagwUnGUsy86sVQxrqhos5pZidVHWpgw
	TVI/EKprBdsGWShLmAXpJQhg/typCgYnrz5dX3PQPAUpwdHh0g9l/7dqCcAoabtj
	I0/125nIsYtq3JdZYZe8MRevGaOOW99bWb/co78UZUEyjxPGpWPcIjEsQdjgETNu
	2GuiOwD+TGKjUF3zzSF/w94sVEggTYJQy67COILy/7uqsYPjoCoPsfiRDd+uZpfA
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4aa5cj3kf1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 11:19:25 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AB9ZXxv007313;
	Tue, 11 Nov 2025 11:19:24 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4aajdja96q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Nov 2025 11:19:24 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5ABBJKgW44564754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Nov 2025 11:19:20 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AE62A20043;
	Tue, 11 Nov 2025 11:19:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8735920040;
	Tue, 11 Nov 2025 11:19:20 +0000 (GMT)
Received: from darkmoore (unknown [9.111.33.212])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Nov 2025 11:19:20 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 11 Nov 2025 12:19:15 +0100
Message-Id: <DE5TP7CFG19D.14EK6NZT344MT@linux.ibm.com>
From: "Christoph Schlameuss" <schlameuss@linux.ibm.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <borntraeger@de.ibm.com>, <frankja@linux.ibm.com>, <nsg@linux.ibm.com>,
        <nrb@linux.ibm.com>, <seiden@linux.ibm.com>, <hca@linux.ibm.com>,
        <svens@linux.ibm.com>, <agordeev@linux.ibm.com>, <gor@linux.ibm.com>,
        <david@redhat.com>, <gerald.schaefer@linux.ibm.com>
To: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, <kvm@vger.kernel.org>
Subject: Re: [PATCH v3 01/23] KVM: s390: Refactor pgste lock and unlock
 functions
X-Mailer: aerc 0.20.1
References: <20251106161117.350395-1-imbrenda@linux.ibm.com>
 <20251106161117.350395-2-imbrenda@linux.ibm.com>
In-Reply-To: <20251106161117.350395-2-imbrenda@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Ss+dKfO0 c=1 sm=1 tr=0 ts=69131bbd cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=apF0X0kuH7Hmyh56T0oA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDA5NSBTYWx0ZWRfX1zN8aePvQJjK
 urU8X8tNzgWz5bpPaLIH/XwCQt+hpg6qN5v2i1JuCeTwNnuOxNicbzQr1ebLfSJ6kvwrEycwcig
 Wu0Mjxpd472g5YeWOwJfvO4q6+mCWQfC+leKFxlp1spTxC/umlfAUFPpWwIiu5sYHo392Ln3kXX
 bLodYv1UXQ/Hvof7qjRCb37LxMp4tPlrnfPYZ1rmfSa7jgrFsstAPmzHfVMeHDoDCxEeYryzJdX
 /cB6mUIOo/6sTbQYv0EBnwc1vKyAww8CAKzsYCT6CEtcyTs9mL8Kzr5N5cmJ7AIrN/I8G3wwdy2
 c9/fh/9ilXLnem/PVpu4w6PxgII/bC/MrbLg5VTxO8TZN/H3nTKuZNo7U2Z9qyyNNCp/pK351zs
 yc6zcqeNUAXtc25gsXeCibBpPEoHXw==
X-Proofpoint-GUID: uEzukqOUA2tEvm3hHI7uvKNO2iuxUedZ
X-Proofpoint-ORIG-GUID: uEzukqOUA2tEvm3hHI7uvKNO2iuxUedZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-11_02,2025-11-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 suspectscore=0 impostorscore=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511080095

On Thu Nov 6, 2025 at 5:10 PM CET, Claudio Imbrenda wrote:
> Move the pgste lock and unlock functions back into mm/pgtable.c and
> duplicate them in mm/gmap_helpers.c to avoid function name collisions
> later on.
>
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

Reviewed-by: Christoph Schlameuss <schlameuss@linux.ibm.com>

> ---
>  arch/s390/include/asm/pgtable.h | 22 ----------------------
>  arch/s390/mm/gmap_helpers.c     | 23 ++++++++++++++++++++++-
>  arch/s390/mm/pgtable.c          | 23 ++++++++++++++++++++++-
>  3 files changed, 44 insertions(+), 24 deletions(-)

