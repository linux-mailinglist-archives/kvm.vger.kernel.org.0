Return-Path: <kvm+bounces-1084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BDEC07E4A61
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 22:15:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B0F6B2107E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 21:15:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4B762A1BA;
	Tue,  7 Nov 2023 21:15:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h45ry+pU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A492A2A1A8
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 21:15:03 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DF810DB;
	Tue,  7 Nov 2023 13:14:33 -0800 (PST)
Received: from pps.filterd (m0353728.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7KgJ7B007108;
	Tue, 7 Nov 2023 21:14:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=TMhfvhA0X/u9TXZrMObivgO6mBs5hQRS9QvWQagTBio=;
 b=h45ry+pUzqbVguAvktWdj2dByrdV6LD7Afkihn+R95au9UE4Fb0lPp+4rILoWdl9lTeN
 aaCeRMJ0xN1X4uCNCtd5cboPaHsiBCiNJi3raaHjN0bte556t3MAdKo92TkGrRFoFotT
 A3Jtl9gkHjwyjZrVvbF+crUsH1Udi3Umsj985ehiaADva7z9Px+T2RP9XbIcuXj2viFw
 ujNsOb55/tkAUWs47hDaAdXI8vS+OYEpK9VbjUV+oEezgtdzn6AzNV7RfBxouB6hCTtk
 Sjf3R98YDC7cKscjVE/H65IVEct4SW+lVQyNZF3+QLOchESYD78uL9eI4XKaDikiIzK1 wg== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7vgs12s6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 21:14:32 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7KvbXn007930;
	Tue, 7 Nov 2023 21:14:31 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u61skkd98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 21:14:31 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A7LEScP46400248
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Nov 2023 21:14:28 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7E47C2004B;
	Tue,  7 Nov 2023 21:14:28 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCB4220043;
	Tue,  7 Nov 2023 21:14:27 +0000 (GMT)
Received: from localhost (unknown [9.171.71.57])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  7 Nov 2023 21:14:27 +0000 (GMT)
Date: Tue, 7 Nov 2023 22:14:26 +0100
From: Vasily Gorbik <gor@linux.ibm.com>
To: Vineeth Vijayan <vneethv@linux.ibm.com>
Cc: Halil Pasic <pasic@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 1/1] s390/cio: make sch->lock a spinlock (is a pointer)
Message-ID: <your-ad-here.call-01699391666-ext-4064@work.hours>
References: <20231101115751.2308307-1-pasic@linux.ibm.com>
 <b54e18a9-582d-3619-773e-695dcf19eaad@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b54e18a9-582d-3619-773e-695dcf19eaad@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: G5dCms-vtx56K441SPN4yNgy-HO017vq
X-Proofpoint-ORIG-GUID: G5dCms-vtx56K441SPN4yNgy-HO017vq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_13,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1011
 impostorscore=0 mlxlogscore=612 phishscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 lowpriorityscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070175

On Tue, Nov 07, 2023 at 01:39:00PM +0100, Vineeth Vijayan wrote:
> 
> 
> On 11/1/23 12:57, Halil Pasic wrote:
> > The lock member of struct subchannel used to be a spinlock, but became
> > a pointer to a spinlock with commit 2ec2298412e1 ("[S390] subchannel
> > lock conversion."). This might have been justified back then, but with
> > the current state of affairs, there is no reason to manage a separate
> > spinlock object.
> > 
> > Let's simplify things and pull the spinlock back into struct subchannel.
> > 
> > Signed-off-by: Halil Pasic<pasic@linux.ibm.com>
> > ---
> > I know it is a lot of churn, but I do believe in the end it does make
> > the code more maintainable.
> 
> You are right. Makes the code easy to read and a bit less complex.
> Looks good to me. Thanks
> 
> Reviewed-by: Vineeth Vijayan <vneethv@linux.ibm.com>

Applied, thank you.

