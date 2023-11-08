Return-Path: <kvm+bounces-1212-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 449387E5A7D
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 16:52:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33753B20F38
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 15:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E4413064E;
	Wed,  8 Nov 2023 15:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VFfWVN50"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FCEEECC
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 15:52:12 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EE91BC3;
	Wed,  8 Nov 2023 07:52:12 -0800 (PST)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8FeaMC011786;
	Wed, 8 Nov 2023 15:52:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=M2q8vwHaki+jn0C1mY1Z/X+t7bLixbQI5D79jPq2rpc=;
 b=VFfWVN505WRmgApN3tci+BCEbV5eX+pwNqmKiFuH0Sdoi+KwiNvVyvfdoYeEk0wOFWhP
 HZ1FykCgTuBXlkT/96eW3x9GtngCbVxBl7/F+s41VelWxfiKazQ6a0bv5Q6W6kTH0FRy
 gXNxmhPRFNwff7XcVzCuJD2wovC9USXjCgtjIVCu5tvVA5rpoxRdup8gs3p4eI0y3prh
 OQMOn7tKq6FHyw7sZVG7hjMegt3Hu9wxx68GpY1xJC6QpuFvPu2cePH/CsIe4iqNf61d
 P3FaSFYa4Q4Hx4wXpfZi1XlEZgz7P/zmBPByF4STyiCHgR0GBYlRejKlejORfk99WFPf qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8d65recx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 15:52:11 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A8FegTh012095;
	Wed, 8 Nov 2023 15:52:10 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u8d65rech-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 15:52:10 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8EMZFx028371;
	Wed, 8 Nov 2023 15:52:10 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u7w22dsh8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Nov 2023 15:52:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A8Fq6Xu15401508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Nov 2023 15:52:07 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D95A420043;
	Wed,  8 Nov 2023 15:52:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D53C20040;
	Wed,  8 Nov 2023 15:52:06 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  8 Nov 2023 15:52:06 +0000 (GMT)
Date: Wed, 8 Nov 2023 16:52:04 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>
Subject: Re: [PATCH v2 2/4] KVM: s390: vsie: Fix length of facility list
 shadowed
Message-ID: <20231108155204.7251-C-hca@linux.ibm.com>
References: <20231107123118.778364-1-nsg@linux.ibm.com>
 <20231107123118.778364-3-nsg@linux.ibm.com>
 <20231108122338.0ff2052e@p-imbrenda>
 <2c15b9a6b97666805491a06deee4bac497ed88cd.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c15b9a6b97666805491a06deee4bac497ed88cd.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ER2F6Keo-RvyQSYBOB9RtbMA6mh2fDxD
X-Proofpoint-ORIG-GUID: bl7-Gh1NH-mOcO90T6dNiSyfDdwY_RLL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_04,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0
 spamscore=0 priorityscore=1501 mlxlogscore=457 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311080130

On Wed, Nov 08, 2023 at 12:49:21PM +0100, Nina Schoetterl-Glausch wrote:
> On Wed, 2023-11-08 at 12:23 +0100, Claudio Imbrenda wrote:
> > On Tue,  7 Nov 2023 13:31:16 +0100
> > Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
> > 
> > [...]
> > > +unsigned int stfle_size(void)
> > > +{
> > > +	static unsigned int size;
> > > +	u64 dummy;
> > > +	unsigned int r;
> > 
> > reverse Christmas tree please :)
> 
> Might be an opportunity to clear that up for me.
> AFAIK reverse christmas tree isn't universally enforced in the kernel.
> Do we do it in generic s390 code? I know we do for s390 kvm.
> Personally I don't quite get the rational, but I don't care much either :)
> Heiko?

We do that for _new_ code in s390 code, yes.

