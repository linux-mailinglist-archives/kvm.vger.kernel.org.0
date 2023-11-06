Return-Path: <kvm+bounces-755-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E94117E25DF
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 14:43:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 32856B21020
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 13:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B78725107;
	Mon,  6 Nov 2023 13:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JI1Cnh1z"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863021A71D
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 13:43:36 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D430CBF;
	Mon,  6 Nov 2023 05:43:34 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6Coo77004819;
	Mon, 6 Nov 2023 13:43:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=YZp4oLK5iXzn4ExIqPYZzqPlL5iac2fpiMqDfzauBNw=;
 b=JI1Cnh1z60/7ibR0HLg0C1sizeHkW7P6MMfA41O44AsEOLIOGhMOo7UjkZdbbqEgm+ch
 gA+w0VG+W6EFKEpGbN5xM2yGwqyvOarhKbozg/MHMnhEJ9OLuxEACAMszzR9b0N7j3LH
 IuzDOwd0JFhLJ5BvTVhUxX1Dtw+TzWJpbQFbALvXYn/JNb4uekYBFD2uvIYrFNpiPjJT
 mOsX7hEKSfAfWxjmswi3upL0UlF9k/xHmA4ZGs6GlLwx2Ftbajs5bEnkh78v1vL+1a49
 EeCANwkynoJX3etP9e+GrnlbtrRUehFI4+bylFnlhYzgWaexFjEOIAzK5yZ/TFJ1sYsU 2A== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u705rj62t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 13:43:34 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6DC43r026866;
	Mon, 6 Nov 2023 13:43:33 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u705rj62b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 13:43:33 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6D4vQQ016958;
	Mon, 6 Nov 2023 13:43:33 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u6301h1bp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 13:43:32 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6DhRSP11076212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 13:43:27 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F245120040;
	Mon,  6 Nov 2023 13:43:26 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5070B20043;
	Mon,  6 Nov 2023 13:43:26 +0000 (GMT)
Received: from osiris (unknown [9.171.27.3])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  6 Nov 2023 13:43:26 +0000 (GMT)
Date: Mon, 6 Nov 2023 14:43:24 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-s390@vger.kernel.org,
        Sven Schnelle <svens@linux.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michael Mueller <mimu@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4] KVM: s390: vsie: Fix length of facility list shadowed
Message-ID: <20231106134324.12197-B-hca@linux.ibm.com>
References: <20231103173008.630217-1-nsg@linux.ibm.com>
 <20231103173008.630217-3-nsg@linux.ibm.com>
 <c05841de-d1d9-406b-a143-f1e3662d99b9@redhat.com>
 <c78b345b9b59197cad89a661095f5f3d1e0d0718.camel@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c78b345b9b59197cad89a661095f5f3d1e0d0718.camel@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VWtgHUFx8d9AAqCwkp6KIM0A5_ZH2oUJ
X-Proofpoint-ORIG-GUID: N8lA1Ldrmw2cU4pgGuYc8wa-U2l_4O0z
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 malwarescore=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 mlxlogscore=404 clxscore=1011 phishscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060110

On Mon, Nov 06, 2023 at 02:06:22PM +0100, Nina Schoetterl-Glausch wrote:
> > > +unsigned int stfle_size(void)
> > > +{
> > > +	static unsigned int size = 0;
> > > +	u64 dummy;
> > > +
> > > +	if (!size) {
> > > +		size = __stfle_asm(&dummy, 1) + 1;
> > > +	}

Please get rid of the braces here. checkpatch.pl with "--strict" should
complain too, I guess.

> > Possible races? Should have to use an atomic?
> 
> Good point. Calling __stfle_asm multiple times is fine
> and AFAIK torn reads/writes aren't possible. I don't see a way
> for the compiler to break things either.
> But it might indeed be nicer to use an atomic, without
> any downsides.

Please use WRITE_ONCE() and READ_ONCE(); that's more than sufficient here.

