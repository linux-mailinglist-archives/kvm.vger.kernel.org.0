Return-Path: <kvm+bounces-60435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 90AB4BEC826
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 07:34:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32C461A6714F
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 05:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD238265CDD;
	Sat, 18 Oct 2025 05:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Hlj7lB/k"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3BF1F418D;
	Sat, 18 Oct 2025 05:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760765657; cv=none; b=EL0pjAja8Erm+cybtxbaSV6lnkNDWEgBAzXIMwDwPwz1l/cXFWvCNMoaz0OL++HIAidcCrrBj9G/I8j61sMD+95YIJZIFHxQnjOUV7mkn5r5lA04Dlq6ovfVh/1ZXXW9XmsIUFZBOGuuZIpV/DbW3PrNxNkQCyaKDiJd49pNefg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760765657; c=relaxed/simple;
	bh=Ha79fgP7jDg4l6s4AMFftjxeFlVOrxj3LWX1xuE9TUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JwPvciKb09yLLJ5fqMIFaDgU4M1oeN1nWooM4QG9mci1DMyz6XKd1aNAd6FHSh1G15+7OhbGkxCXc2ymzh4f1/pDFgL1nryv/2hkLNrlHu2osQ9sZ1kVxdF72Ywy/+gnnbwm5tnsKW9ZCkkzcz3rzaO87JgE20HURD0UX7BSThM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Hlj7lB/k; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59I3U295014014;
	Sat, 18 Oct 2025 05:33:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NeeUes
	nrcqkMWegJSjwueFiedvybxeTlIsj/sTYadVw=; b=Hlj7lB/kBSBAgiCDAUP3Ko
	5DpvCRzILttHfdcj0bCJEJ+peyTyqnaFjC/JHkccUZj5pgwxwBhd6DiG6CiS1XQq
	I7X2evWTj06tWJw6PwEwShjorf/T6MylXZAEzKErSOF+CGHF4VtU+ohl0YG3v0SI
	ypp/q9E+EJzfE6A5rBlFwxxOJfNWsAPJXA95By9xbY8Gun01+6uI1IcWcw5xB6kR
	7fk7JnNG/VoBk3138DnN9coAde4ni5SHO+WW5KBMqulvSAjHOzVIDV8xnkT6FnfM
	33+2OJFt2QgAPwHzutcUjg95dKypAJyPCK6VMibAALOlJv3h2npOQH/ogH1/XPVg
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31rgbkj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Oct 2025 05:33:56 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59I5XtqF026030;
	Sat, 18 Oct 2025 05:33:55 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31rgbkg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Oct 2025 05:33:55 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59I3hSXc018862;
	Sat, 18 Oct 2025 05:33:54 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r2jn8wrc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 18 Oct 2025 05:33:54 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59I5XpiX49086902
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 18 Oct 2025 05:33:51 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2684E20043;
	Sat, 18 Oct 2025 05:33:51 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D6A3420040;
	Sat, 18 Oct 2025 05:33:47 +0000 (GMT)
Received: from li-c439904c-24ed-11b2-a85c-b284a6847472.ibm.com (unknown [9.43.69.229])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 18 Oct 2025 05:33:47 +0000 (GMT)
From: Madhavan Srinivasan <maddy@linux.ibm.com>
To: Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Andrew Donnellan <ajd@linux.ibm.com>, Nam Cao <namcao@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Subject: Re: [PATCH] powerpc, ocxl: Fix extraction of struct xive_irq_data
Date: Sat, 18 Oct 2025 11:03:46 +0530
Message-ID: <176076456873.59904.12854719764174051235.b4-ty@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251008081359.1382699-1-namcao@linutronix.de>
References: <20251008081359.1382699-1-namcao@linutronix.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 0Gs6clxS-3DH47ngsQVduJL7VwCY74hP
X-Proofpoint-GUID: np-mCPSN0CaaIbi8GK3cb3614DONbjBG
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX7XSNL00Cx9Vk
 +Q1sgQnbCuzL78fAkyvIw/L8k4ze2STv0gM+/BYTiNNaHI/EEJ8LJ3VUQ/sXXp93aToOxee6F/k
 62crA2Qt3MYGCtB0+cWvOkf/fjCSLdTpsIA6MHOpBsWZWkUVolF/83rm0uFZd3yR7Eo37he+ORe
 o67L11GIxkX5Xvj0lahojlofYIPZR7MxXXm6dLMOwP6bYp+gTw0jqdcJcb3K4mwGJNCR7oGQM7R
 FIbY0mfiU/O2R6CNJmjzq+8wRtRN72FIlEvqy3Flc4ZLh1VBRnm5HRjxBLyNehxo0+/K+YLWWxZ
 Ans0NfvNE/lLqL6JbKZqHGC8u3DqthQlXBy1mGrs3Yy2rdqQWBSP7JG4bL/oT25nhd4mknpeDFQ
 plk3PO/b+d11Gwmhw3dSgN2gBFnkcQ==
X-Authority-Analysis: v=2.4 cv=IJYPywvG c=1 sm=1 tr=0 ts=68f326c4 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=24m1D_QoUu3p9LEs7a4A:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-18_01,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022

On Wed, 08 Oct 2025 08:13:59 +0000, Nam Cao wrote:
> Commit cc0cc23babc9 ("powerpc/xive: Untangle xive from child interrupt
> controller drivers") changed xive_irq_data to be stashed to chip_data
> instead of handler_data. However, multiple places are still attempting to
> read xive_irq_data from handler_data and get a NULL pointer deference bug.
> 
> Update them to read xive_irq_data from chip_data.
> 
> [...]

Applied to powerpc/fixes.

[1/1] powerpc, ocxl: Fix extraction of struct xive_irq_data
      https://git.kernel.org/powerpc/c/2743cf75f7c92d2a0a4acabd7aef1c17d98fe123

Thanks

