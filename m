Return-Path: <kvm+bounces-18066-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3AF048CD846
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 18:20:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E73B11F22BC8
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 16:20:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70F51179AD;
	Thu, 23 May 2024 16:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ett8p9lX"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F72FD304
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 16:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716481196; cv=none; b=KAsVdnD2XJHDdMj0S3gWTCJ2BlquISNH1rDQsMboQAm7Uk5PsUU/fFQBWMUJuhzQQ92F+2AO6DPmVkWMxBYOuKtIx7+YmHhwTeXHymTV5k+jgVkfCrxCksm7wlIgmuh2jsetAl9p7+5+kVz/5wWdDFTZjZ/+livM8N7jSaWH2a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716481196; c=relaxed/simple;
	bh=fFO7vRqhGpodbixKOQQ1NTt2loBWPV/fpJwavNb/gSA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bWaGoBKD7lGe+LjyDjTo36Ef/lLHiWEbhZR5MWT40aJCZjNsXfoxP66UGu/6SYV4RFopqFyYHqHXkB+ix/vj4QXUaX1E8rDgRaYw7FPMYO4+zs3MfkQ4TaE13Eke5srlZnq0PdXsiIs+YZ0OJa/5xkbPi3loZ0+SyFJZv8gySoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ett8p9lX; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NG1HGH015977;
	Thu, 23 May 2024 16:19:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=uceUKHHr/ZdJ5khnDC5HUV7NN0UBo8HI0PsI6JL7HYo=;
 b=ett8p9lXKKH7C1nK7lDvdi6uIbv6b4cYOAQCONYZcRUAAKWBAiAAPuRjY9MUHP967FEC
 3OP+Ib5GHyFECRx2+Sgj0Cjl1FRUG3qDdAr9oNy2SCZoLnXncYJMBbLFUbOnXCvSU07Q
 y9dHJNJYp5VB8Kf6nlwV2y2+QM9zSTCLB5XT9Mg3xyMzIXvdOBI+msOG5RyVmH9sTJIU
 bfdovpAjD1cUGejBv2Ye3NpwgxE1dH0Bg2j4BkBFlruv8opxmRBn2yST/4ood7Nf4hWd
 aHELlyrxHVpa+jq3dDQhIfa4NNMficA4cPXG5wTH75tesHamcgRe+NQOMpFOtHxu4olc LA== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya8u401ws-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 16:19:43 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44NGJgsu012762;
	Thu, 23 May 2024 16:19:42 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ya8u401wm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 16:19:42 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44NG5wnr008226;
	Thu, 23 May 2024 16:19:42 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3y78vmam92-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 23 May 2024 16:19:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44NGJcN553084416
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 16:19:40 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64B082004D;
	Thu, 23 May 2024 16:19:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3085E20040;
	Thu, 23 May 2024 16:19:38 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 23 May 2024 16:19:38 +0000 (GMT)
Message-ID: <678f6b8fe42f7a39eba4090a12a618cdbc710fa5.camel@linux.ibm.com>
Subject: Re: [PATCH v2 11/11] KVM: arm64: Get rid of the AArch32 register
 mapping code
From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        James Morse
 <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Andrew Scull
 <ascull@google.com>, Will Deacon <will@kernel.org>,
        Mark Rutland
 <mark.rutland@arm.com>,
        Quentin Perret <qperret@google.com>,
        David Brazdil
 <dbrazdil@google.com>, kernel-team@android.com
Date: Thu, 23 May 2024 18:19:38 +0200
In-Reply-To: <86le40ms5m.wl-maz@kernel.org>
References: <20201102164045.264512-1-maz@kernel.org>
	 <20201102164045.264512-12-maz@kernel.org>
	 <66a7077c5df86d0a541237996382ae583d690a14.camel@linux.ibm.com>
	 <86le40ms5m.wl-maz@kernel.org>
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
X-Proofpoint-GUID: WlJ9h5pC_ceKzTeriJQ8qzqN1wFwIUzZ
X-Proofpoint-ORIG-GUID: X30hMVZHljYac0FLyei1ow4NiLJTHAXc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_09,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405230112

On Thu, 2024-05-23 at 17:04 +0100, Marc Zyngier wrote:
> Hi Nina,
>=20
> On Thu, 23 May 2024 15:25:21 +0100,
> Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:
> >=20
> > On Mon, 2020-11-02 at 16:40 +0000, Marc Zyngier wrote:
>=20
> Wow, you're digging out the old dregs... But it is worth it!

[...]

> Amazing. Thanks for spotting this. This is indeed broken. I guess this
> was not spotted because userspace is not totally broken itself.

So it's an actual bug and not just doing more work than necessary?
Could corrupt the regs of a 64bit kernel?
>=20
> Do you want to submit a fix adding the masking back? or should I do it
> myself?

You go ahead and do it :)
>=20
> Thanks again,
>=20
> 	M.
>=20


