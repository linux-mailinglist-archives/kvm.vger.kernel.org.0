Return-Path: <kvm+bounces-59674-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BC6BC7046
	for <lists+kvm@lfdr.de>; Thu, 09 Oct 2025 02:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 81EC04E7240
	for <lists+kvm@lfdr.de>; Thu,  9 Oct 2025 00:41:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CC3B199252;
	Thu,  9 Oct 2025 00:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ilzzWjVG"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F00534BA2F;
	Thu,  9 Oct 2025 00:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759970487; cv=none; b=WzTS+beZCQW0zrDyqexLuQPKOztdha99XlXLK2dxBsyTurjCV5DM4o9WMxwpNbuNfhS4OPyPbMLtFiv/7MPUpYHCbxGOv9Joi+Yzt2mog/OcpaV1iGkiyno+UOEZ1JxYyANMFbyd6EWh6GR0UksQ7Y35HWxYrv0NLejoSqVW5H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759970487; c=relaxed/simple;
	bh=ImDcmRbMJW5k9N0PCKWCYENsFOdNDPl5737Zk155Cb0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=gIWxVEpExTfpw6y5ApzyCmdn7qw0F5xnViA4KnjMCi8r4HHcmDegHV+7IHcbYlnhq1RdnY6o2GxcgqVYTK2QmR/yqaSocsCYGC7hBjjteZ0Ov7wPjK42eVIiqPeKqBxATeXv6hw8wZLHIcD2+4E/m133NQ22PwP+TO1Qs0I4QHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ilzzWjVG; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 598HIG4J014342;
	Thu, 9 Oct 2025 00:41:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=X1uEAU
	o9Wl+a6bB3iejTxXaXf2cfXqGB4eT/Jgnc1b0=; b=ilzzWjVG8shBBOmqPtOtde
	ffbCTT+hU5za5QivClVwRTqv35cCALKeMJPel/8iZoddfT0vfkUkje6yfmKVbcQS
	5C5uyRxyXd0h7bh/yDJPHrLmRZ+OjDqZ7UXtNO15Rsm2vJpZqLoLP/H+/I8MHc8S
	ecilEond6nPMcOUYD8FEqTvo0Xo/Gvu2XavZ/4VRUx5C0eDuKBQm5eAjEInTVQ6p
	4rd2BH11KG/9eupeW73mulkXYODjXtrWHWNRLA5EgpKkLM8XTTzPki615W8iBruy
	jMPq55rx5fyO4ICdm6OEW0ySlzSyspRdV/BZ4Fu/9N2JAlnkGktiuf+UHPtgxMyw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv84hm0m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 00:41:05 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5990d4cT005253;
	Thu, 9 Oct 2025 00:41:05 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49nv84hm0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 00:41:05 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 598L0RDw020966;
	Thu, 9 Oct 2025 00:41:04 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49nv9mskam-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 09 Oct 2025 00:41:04 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5990f3CQ24707826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 9 Oct 2025 00:41:03 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F054158056;
	Thu,  9 Oct 2025 00:41:02 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A808758052;
	Thu,  9 Oct 2025 00:40:57 +0000 (GMT)
Received: from jarvis.ozlabs.ibm.com (unknown [9.150.21.155])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  9 Oct 2025 00:40:57 +0000 (GMT)
Message-ID: <19ffe9eeb8703656285cab6f0d819602860bb28b.camel@linux.ibm.com>
Subject: Re: [PATCH] powerpc, ocxl: Fix extraction of struct xive_irq_data
From: Andrew Donnellan <ajd@linux.ibm.com>
To: Nam Cao <namcao@linutronix.de>, Madhavan Srinivasan
 <maddy@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael
 Ellerman <mpe@ellerman.id.au>,
        Christophe Leroy	
 <christophe.leroy@csgroup.eu>,
        Frederic Barrat <fbarrat@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman	
 <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ritesh Harjani (IBM)"	
 <ritesh.list@gmail.com>
Date: Thu, 09 Oct 2025 11:40:55 +1100
In-Reply-To: <20251008081359.1382699-1-namcao@linutronix.de>
References: <20251008081359.1382699-1-namcao@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HKPO14tv c=1 sm=1 tr=0 ts=68e704a1 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=ORaXvX-jSRnqCH-k56AA:9 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: qc41LZ5LRnou00jqr-qzsnTD1f3s1L5B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA4MDEyMSBTYWx0ZWRfX+AiqY55t6yVt
 WkA5/FNZiY0LVjd/uT6RSzioj0FQal/yJIwS9t+LRVcHY81T/QPAVkreq0692NRukSOtfS43Aly
 wtL+cyieojn+lukv3ur34R8wBiDE4ASh/0q0Ge2WrPXBwDi4EMTv5JkZEZOOT02FHjpDR38QDtt
 BAnzmg/Ne7ZrlETNWTBYKhvTxnUxOGue9f5UAIn8Rbp3J9gSsXurbeC8kvPHeGkdBAQvqQU5v9U
 aAcGwVoXm6MzhcuSIkvj8gRZQERCV6NXEsoPUIOfR/rlsFQ6UQtYhD0//ioC2UR2Z0doRjgeZPl
 CDhVPfGEJn4nKAIS2Kf1ltdeS/IJGJVGjjEdNzbeTZVkjemNTH0mjGFXsjz3w5oNVVPBgz4tbFt
 yW85omm8KpnYqxsekaNtEc98nEyy2Q==
X-Proofpoint-ORIG-GUID: 5rcrvfIYB7kqsqOT9o5GxnxQPaRznZJu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_08,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0
 adultscore=0 clxscore=1011 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510080121

On Wed, 2025-10-08 at 08:13 +0000, Nam Cao wrote:
> Commit cc0cc23babc9 ("powerpc/xive: Untangle xive from child interrupt
> controller drivers") changed xive_irq_data to be stashed to chip_data
> instead of handler_data. However, multiple places are still attempting to
> read xive_irq_data from handler_data and get a NULL pointer deference bug=
.
>=20
> Update them to read xive_irq_data from chip_data.
>=20
> Non-XIVE files which touch xive_irq_data seem quite strange to me,
> especially the ocxl driver. I think there ought to be an alternative
> platform-independent solution, instead of touching XIVE's data directly.
> Therefore, I think this whole thing should be cleaned up. But perhaps I
> just misunderstand something. In any case, this cleanup would not be
> trivial; for now, just get things working again.

ocxl has always done quite a few weird things...

>=20
> Fixes: cc0cc23babc9 ("powerpc/xive: Untangle xive from child interrupt
> controller drivers")
> Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Closes:
> https://lore.kernel.org/linuxppc-dev/68e48df8.170a0220.4b4b0.217d@mx.goog=
le.com/
> Signed-off-by: Nam Cao <namcao@linutronix.de>

Acked-by: Andrew Donnellan <ajd@linux.ibm.com>  # ocxl

> ---
> VAS and OCXL has not been tested. I noticed them while grepping.

Unfortunately I don't have convenient ocxl hardware on hand to test with an=
y
more (I'm sure the cards are floating around *somewhere* in the company...)=
, but
this looks like a straightforward change.

--=20
Andrew Donnellan    OzLabs, ADL Canberra
ajd@linux.ibm.com   IBM Australia Limited

