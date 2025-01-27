Return-Path: <kvm+bounces-36641-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A564A1D193
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 08:37:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BB7D188216B
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2025 07:37:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FC351FC0F1;
	Mon, 27 Jan 2025 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="coHUWty3"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBB418D;
	Mon, 27 Jan 2025 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737963422; cv=none; b=PR8Z+vHIljskQQVgtK6Xmnq6pq+HR/Kbe441bbbaSc8XA9lJ15kvS++N9mqrPRu7seHZMMrjx6UPh5NKmzSoMdkIO/l/oGxVGy5MLaMU3kYxiXN4qsbqZRajFWM6/dm06C1nMIWFbpJ6S4kmGBDbVhEYNJjq74JP0yrkEFkxoAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737963422; c=relaxed/simple;
	bh=Y1sCtAisinjgsZyYOat3ARot9XjKhREXWr4KiHU+0OY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Glm145AdYOG92u6xyxvMSfjIRXSHa+2VgUpy3sLXY11qrN8bnXnlTb0g20KV5lSTF8cqULrYT/AMnXsetwDMBNCZWjiqhU/eDTZ4ZMkXPPd/yoW4OppSAPU+ACRUkl9hPjaXudvsj88PkMTyV715+nS2R/QROmh0eBPtfSq6Vrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=coHUWty3; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50R5NnXf030643;
	Mon, 27 Jan 2025 07:36:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Y1sCtA
	isinjgsZyYOat3ARot9XjKhREXWr4KiHU+0OY=; b=coHUWty3XwTvwx0miFXP+A
	ewVsB02bZltWrDPDtjvnjSZEDGZeanOsevj7SPEb2ZsjjpqPMXmCJwI8vPCUjBMA
	Tz7jA/liTOC/ci6J0OYDjyw27xUyUec/AXDoW3d3A0xkC2OkqXnI0KC4XXblE9yi
	lcJaP98p1sMkV6lhjIV73r3fpzoXoimZmS2qaVIEmJj0ftapdax7W9mq8FZTw9Ly
	LPeaJ9PtPjxGrs4j8Zf/+nFCvYbVi9L0bnzTF9MNtbmXswLBnnyK987aWxRb1/km
	0hjn9avuCSWMxC+QWaaE8u6k4Lq67UXs1pkQyAt9H0/hXC9UFVSJdP+LSdiuopNA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e3y7rgtj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 07:36:43 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 50R7YLg7010750;
	Mon, 27 Jan 2025 07:36:43 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 44e3y7rgtf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 07:36:43 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 50R6wmgB003957;
	Mon, 27 Jan 2025 07:36:42 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 44da9s5djr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jan 2025 07:36:42 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 50R7ac1X64291200
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jan 2025 07:36:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8966E200BF;
	Mon, 27 Jan 2025 07:36:38 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA11A200BC;
	Mon, 27 Jan 2025 07:36:34 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.39.30.253])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon, 27 Jan 2025 07:36:34 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Mon, 27 Jan 2025 13:06:33 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin
 <npiggin@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        sbhat@linux.ibm.com, gautam@linux.ibm.com, kconsul@linux.ibm.com,
        amachhiw@linux.ibm.com
Subject: Re: [PATCH v3 4/6] kvm powerpc/book3s-apiv2: Introduce kvm-hv
 specific PMU
In-Reply-To: <40C19755-ABE4-4E23-A75A-1F6F6DDC505A@linux.vnet.ibm.com>
References: <20250123120749.90505-1-vaibhav@linux.ibm.com>
 <20250123120749.90505-5-vaibhav@linux.ibm.com>
 <40C19755-ABE4-4E23-A75A-1F6F6DDC505A@linux.vnet.ibm.com>
Date: Mon, 27 Jan 2025 13:06:33 +0530
Message-ID: <87y0ywu2ri.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WI0OYns2V5mRYoL7l6EzBfFQYPMiVpt5
X-Proofpoint-GUID: OWa1752MrPhAEkRGy4X2WucZV5eKwoKE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-27_03,2025-01-27_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 bulkscore=0 mlxscore=0 mlxlogscore=616 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501270059

Hi Athira,

Thanks for reviewing this patch series. My responses to your review
comment inline below:


Athira Rajeev <atrajeev@linux.vnet.ibm.com> writes:

>> On 23 Jan 2025, at 5:37=E2=80=AFPM, Vaibhav Jain <vaibhav@linux.ibm.com>=
 wrote:
>>=20
>> Introduce a new PMU named 'kvm-hv' to report Book3s kvm-hv specific
<snip>
>
> Hi Vaibhav
>
> All PMU specific code is under =E2=80=9Carch/powerpc/perf in the kernel s=
ource. Here since we are introducing a kvm-hv specific PMU, can we please h=
ave it in arch/powerpc/perf ?

Is it common convention to put PMU specific code in
arch/powerpc/perf across ppc achitecture variants ? If its there can you
please mention the reasons behind it.

Also the code for this PMU, will be part of kvm-hv kernel module as it
utilizes the functionality implemented there. Moving this PMU code to
arch/powerpc/perf will need this to be converted in yet another new
kernel module, adding a dependency to kvm-hv module and exporting a
bunch of functionality from kvm-hv. Which looks bit messy to me

<snip>

--=20
Cheers
~ Vaibhav

