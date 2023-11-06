Return-Path: <kvm+bounces-663-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D7497E1F14
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 12:00:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CDC0D2811A7
	for <lists+kvm@lfdr.de>; Mon,  6 Nov 2023 11:00:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BEA31805F;
	Mon,  6 Nov 2023 11:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Zh4DMfpA"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A341818035
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 11:00:30 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8287CB7;
	Mon,  6 Nov 2023 03:00:29 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A6AFPVk009474;
	Mon, 6 Nov 2023 11:00:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=D1iKgU8MaxGuAanmiVdwjL8M+qWemCsbQIouJx2h9no=;
 b=Zh4DMfpAf8sU/IEX6RreKH5+teAiKdvNVAGDQjZPSYFwImhqXGDfncUy0v/ce7vIk1hr
 VvvhZ9QYLon0jq/vlgLL9vc1OjbACiSv8pv5fAF7Kq/oF2JLemwv+vJXH5Z9P9v8vhfG
 dL03OXBP1cW4rILzfyci5C5FkXet8T7wXtSOMngwTRkfhNpS5dbhkmF6mXeXtQDauVrI
 pkU3FWXkl1nlGLD4hpEFxChn4zffd6TxjvO29RR5UhFWvAZF1qSWyNr82fyDS4EbSjoJ
 B/RLWnCMfHjDCLfVnSvNfI9hVwMzzoPDpjSwMb+jmyN/hFhN3T9EQPkDWBUu/UVPXuG8 JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6wcnu0m4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 11:00:28 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A6AGs2e015022;
	Mon, 6 Nov 2023 11:00:27 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u6wcnu0jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 11:00:27 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A69doPm028237;
	Mon, 6 Nov 2023 11:00:26 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u62gjrbj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 06 Nov 2023 11:00:26 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A6B0K4x17367604
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 6 Nov 2023 11:00:20 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 25DA92004B;
	Mon,  6 Nov 2023 11:00:20 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7024320040;
	Mon,  6 Nov 2023 11:00:19 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.179.20.192])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  6 Nov 2023 11:00:19 +0000 (GMT)
Message-ID: <5cfee0930c4665481480d00bcb334b8c8c161426.camel@linux.ibm.com>
Subject: Re: [PATCH 3/4] KVM: s390: cpu model: Use previously unused constant
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>,
        Alexander Gordeev
 <agordeev@linux.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Michael
 Mueller <mimu@linux.vnet.ibm.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio
 Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>
Cc: linux-kernel@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date: Mon, 06 Nov 2023 12:00:19 +0100
In-Reply-To: <47d18f06-13b2-4ec5-b601-eb9a2738f06b@redhat.com>
References: <20231103173008.630217-1-nsg@linux.ibm.com>
	 <20231103173008.630217-4-nsg@linux.ibm.com>
	 <4c3cec3c-da81-426c-815b-afee1de68947@redhat.com>
	 <47d18f06-13b2-4ec5-b601-eb9a2738f06b@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0Ddf0zaDIOqePaT9AAAdgOVroaXugE7k
X-Proofpoint-ORIG-GUID: TujqQAYWG4kRhei_sFweFZhNDJRux6Q6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-06_09,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 mlxscore=0 mlxlogscore=375 spamscore=0
 clxscore=1015 malwarescore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311060091

On Fri, 2023-11-03 at 19:41 +0100, David Hildenbrand wrote:
> On 03.11.23 19:36, David Hildenbrand wrote:
> > On 03.11.23 18:30, Nina Schoetterl-Glausch wrote:
> > > No point in defining a size for the mask if we're not going to use it=
.
> >=20
> > I neither understand the patch description nor what the bug is that is
> > being fixed (and how that description relates to the patch
> > subject+description).
> >=20
> > Please improve the patch description.
> >=20
>=20
> Should this be
>=20
> "
> KVM: s390: cpu model: use proper define for facility mask size
>=20
> We're using S390_ARCH_FAC_LIST_SIZE_U64 instead of=20
> S390_ARCH_FAC_MASK_SIZE_U64 to define the array size of the facility=20
> mask. Let's properly use S390_ARCH_FAC_MASK_SIZE_U64. Note that both
> values are the same and, therefore, this is a pure cleanup.
> "
>=20
> I'm not convinced there is a bug and that this deserves a "Fixes:".

Oh yeah, sorry, purely a cleanup. S390_ARCH_FAC_MASK_SIZE_U64 wasn't
used anywhere. I also considered just getting rid of it and using one
constant for both list and mask.

