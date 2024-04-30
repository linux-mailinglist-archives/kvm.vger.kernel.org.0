Return-Path: <kvm+bounces-16263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DF4278B8088
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 21:31:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 561111F245CA
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 19:31:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E516199E86;
	Tue, 30 Apr 2024 19:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="FtBfdoph"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDEB7710B;
	Tue, 30 Apr 2024 19:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714505478; cv=none; b=mB59+FvZdzrn9fKgZ+nxAol5XPUWd47LDyVSTdN7aGRg9Wb7kJ6jVtc6/ouFuEfWfL6TKVwq/I0L/Ommns/NKH7/TpxCXnrTLPK+MpyUM+Bkj4xP8rwMwP/0q9lPb1UPVZT3V+4VzxRO2z0uETGJsZzEItYUUvNCzh9NVsz/kOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714505478; c=relaxed/simple;
	bh=NCkfdFfYPyv+cxw3YGXRQCLfnck0tkHnGZpWYoan5MQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=b3bJP84y7PZ3v3s2tDJpTmyC5uS88FjKARvUDDHktvKFJkOjnjuI8jucSfSVcWmUYIHWzuT1c7FSMOrWRgmp5YXffCtMtjJTCXnbBV7oHJl7eXpydJyxiCaaxHmYiPhiHWuHlXVl6sq6U1KR/Av/99mnz9ti++BKc2y4EaQwYD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=FtBfdoph; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43UJSXHM012934;
	Tue, 30 Apr 2024 19:31:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=NCkfdFfYPyv+cxw3YGXRQCLfnck0tkHnGZpWYoan5MQ=;
 b=FtBfdophn3v5VnKFI58xajgjWC6nphVsubfh3Yq0lHKX/IZPcPQzbvzTKKjKjMCSApUF
 1CrJ2iBRGbNwUaPeiDwYXVo+j2tmXokBNdnLFKxdg+tQpeupbADaoFA+vSgxJoAtiocw
 qFbjpGlsGYLHDxkGbKGak6yES2Hm5b0+UZNSXy3hQ8bFhh5xi4TVb5HDlQHvZxW3Trc6
 0SB1+OziqXJ4PzWdXN+tX5oYvDRjRxf3lJY527ZASPUXZfaM6w01z8pCKhAxlyRy8Z3A
 Y5F60CPlFaLTXQ3Xz+LeO1gScYBiT4bLzuutL1le6dSfmmjWAgSe1AQVG0nfM9qyXvC+ eA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xu6tx804h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 19:31:14 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43UJVE7X016586;
	Tue, 30 Apr 2024 19:31:14 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xu6tx804f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 19:31:13 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43UGnd0O002989;
	Tue, 30 Apr 2024 19:31:13 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xscppet9n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 Apr 2024 19:31:13 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43UJVA4t36766094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Apr 2024 19:31:12 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DD0805806D;
	Tue, 30 Apr 2024 19:31:08 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1FC0858070;
	Tue, 30 Apr 2024 19:31:08 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.85.173])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 30 Apr 2024 19:31:08 +0000 (GMT)
Message-ID: <0cfe41f08d89481125ddc1f0087af6bd6bcd1b39.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE instruction on host
 intercepts
From: Eric Farman <farman@linux.ibm.com>
To: Christian Borntraeger <borntraeger@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda
 <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens
	 <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev
	 <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
Date: Tue, 30 Apr 2024 15:31:07 -0400
In-Reply-To: <dceeac23-0c58-4c78-850a-d09e7b45d6e8@linux.ibm.com>
References: <20240301204342.3217540-1-farman@linux.ibm.com>
	 <338544a6-4838-4eeb-b1b2-2faa6c11c1be@redhat.com>
	 <1deb0e32-7351-45d2-a342-96a659402be8@linux.ibm.com>
	 <8fbd41c0fb16a5e10401f6c2888d44084e9af86a.camel@linux.ibm.com>
	 <dceeac23-0c58-4c78-850a-d09e7b45d6e8@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.4 (3.50.4-1.fc39) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uDnnbdN_dTEFkyRZhTcmu8ADGFKDn_5c
X-Proofpoint-ORIG-GUID: ly8BUBbMSAWihqa4Zm65oKhVkATqD_f3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-04-30_12,2024-04-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 malwarescore=0 suspectscore=0 priorityscore=1501 spamscore=0
 lowpriorityscore=0 clxscore=1011 impostorscore=0 mlxlogscore=398
 phishscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404300139

On Mon, 2024-04-29 at 12:18 +0200, Christian Borntraeger wrote:
> Am 04.03.24 um 16:37 schrieb Eric Farman:
> > On Mon, 2024-03-04 at 09:44 +0100, Christian Borntraeger wrote:
> > >=20
> > >=20
> > > Am 04.03.24 um 09:35 schrieb David Hildenbrand:
> > > > On 01.03.24 21:43, Eric Farman wrote:
> > > > > It's possible that SIE exits for work that the host needs to
> > > > > perform
> > > > > rather than something that is intended for the guest.
> > > > >=20
> > > > > A Linux guest will ignore this intercept code since there is
> > > > > nothing
> > > > > for it to do, but a more robust solution would rewind the PSW
> > > > > back to
> > > > > the SIE instruction. This will transparently resume the guest
> > > > > once
> > > > > the host completes its work, without the guest needing to
> > > > > process
> > > > > what is effectively a NOP and re-issue SIE itself.
> > > >=20
> > > > I recall that 0-intercepts are valid by the architecture.
> > > > Further,
> > > > I recall that there were some rather tricky corner cases where
> > > > avoiding 0-intercepts would not be that easy.
> >=20
> > Any chance you recall any details of those corner cases? I can try
> > to
> > chase some of them down.
> >=20
> > > >=20
> > > > Now, it's been a while ago, and maybe I misremember. SoI'm
> > > > trusting
> > > > people with access to documentation can review this.
> > >=20
> > > Yes, 0-intercepts are allowed, and this also happens when LPAR
> > > has an
> > > exit.
> >=20
> > =C2=A0From an offline conversation I'd had some months back:
> >=20
> > """
> > The arch does allow ICODE=3D0 to be stored, but it's supposed to
> > happen
> > only upon a host interruption -- in which case the old PSW is
> > supposed
> > to point back at the SIE, to resume guest execution if the host
> > should
> > LPSW oldPSW.
> > """
>=20
> Just re-read the architecture again and I agree, the SIE instruction
> should
> be nullified. So we should go forward with this somehow.
>=20
> Eric, can you maybe add this to devel for CI coverage so that we see
> if there
> are corner cases?=C2=A0

Sure thing.

> Maybe also try to do some performance things (how many IPIs
> can we get in guest2 when a guest3 is running and how many IPIs are
> possible
> in a guest3).
>=20

Fair enough. I'll see if I can come up with something and report back
here.

