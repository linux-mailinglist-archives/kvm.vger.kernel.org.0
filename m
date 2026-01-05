Return-Path: <kvm+bounces-67056-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 10672CF4A0F
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 17:19:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2B2BC301DE2C
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 16:16:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3536732E736;
	Mon,  5 Jan 2026 15:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WQPb3Zlz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2C353093DF;
	Mon,  5 Jan 2026 15:46:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628021; cv=none; b=AR3E9hK6vhkOTMufwFji+InGIh8QMDbGUfo2OkB9NcSa9sm33pvpnkehtCU/IhF/L7RxaUsPvbzoVfltkmubuwAGKV/pjcboDyaCNTs8YSTZefI3ndx9/+z1NJr4GNmqlNa+uZBOqmHBq9SjEEDWAC9ceJpS3mtAVbzErma7Zsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628021; c=relaxed/simple;
	bh=BmhWnRdV1//W+yz/prpbZpVqO6K2wh5PgjWlBcxE/s0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=l6TEPYSdkIL8Bal9XFvuk8DCd1sTvWJ7x8bzW5dx4MXLiYUmJvQsSJiGkm6pG5wE1gwiPCYPjEgi08bXa+I8hEjdLXVqQbHvFtW6Lb2wyOn32+GtgxiUMD6y0z4qzkalxARhidGEvpAiOfRLe7F/sV6i42HtVbKp/tyeVmplfCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WQPb3Zlz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 605EC86A023995;
	Mon, 5 Jan 2026 15:46:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=BmhWnR
	dV1//W+yz/prpbZpVqO6K2wh5PgjWlBcxE/s0=; b=WQPb3ZlzOePhJ21xLsFHQP
	d3FLDjNyvEBiI56XMBKhLuGzj8vzRwu4wfMKx6AxKBD2nLOH+sibjO7DGKIoERxc
	0PqCtb3a7t7XnRmaDWVbK/Jeff0kl/uWa8UeisVjSRQI+uihnUAxsR43flSF2TiT
	rFL4JHauUc+DsQpvSQJlAiaNB6hAwSDn0FTDLxX9nUvHXSL/310W4FBwAOErUcH/
	pJEfOFCqtI0ZSTvgkpfta0LBpOSzwBWgESyDn6VpaYCBelScm56W1Ko0LQ4GI78S
	Fnp+GwpcZF/QoEEpdT5Jur7J2wNdMHNgQnyL3TWgy1mGK9yGUVgPMxTL4Gts8k0Q
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm700g9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 15:46:57 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 605E21if014511;
	Mon, 5 Jan 2026 15:46:56 GMT
Received: from smtprelay04.wdc07v.mail.ibm.com ([172.16.1.71])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bfeempk7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 15:46:56 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay04.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 605FksrQ33555120
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Jan 2026 15:46:54 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A277458062;
	Mon,  5 Jan 2026 15:46:54 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDF8158054;
	Mon,  5 Jan 2026 15:46:53 +0000 (GMT)
Received: from li-479af74c-31f9-11b2-a85c-e4ddee11713b.ibm.com (unknown [9.61.132.176])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  5 Jan 2026 15:46:53 +0000 (GMT)
Message-ID: <f34d767b2a56fb26526566e43fa355235ee53932.camel@linux.ibm.com>
Subject: Re: [PATCH] KVM: s390: vsie: retry SIE when unable to get vsie_page
From: Eric Farman <farman@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>,
        Christian Borntraeger
	 <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand
	 <david@kernel.org>,
        Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
Date: Mon, 05 Jan 2026 10:46:53 -0500
In-Reply-To: <8334988f-2caa-4361-b0b9-50b9f41f6d8a@linux.ibm.com>
References: <20251217030107.1729776-1-farman@linux.ibm.com>
	 <8334988f-2caa-4361-b0b9-50b9f41f6d8a@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OdmVzxTY c=1 sm=1 tr=0 ts=695bdcf1 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VnNF1IyMAAAA:8 a=z8VN1rYgAN99UVL_zB0A:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: fge0qkrr_gzHPYucxGm1UQxwC_FWEqth
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDEzOCBTYWx0ZWRfX/eJi50nVy0nn
 0vDas1ofd2fy0/N1Q7FTxEixo/nPoGx9f9QWqCVsc0cHpxUvwLwVTxOVsz80WxXN766jBi7S/zp
 nvMSZClT+aayQcNSfLPvhzediU4AfUpsd8PDyHVr6v0hkwbacrkLSUBaEf8YZ/FySYcH0OVRYkh
 037I2IEuPKmwG6kEeZ6xU/hhcIyyZL78wMLwnT3LFx9BVq95uaUwqHMRRo5v8xFqTzvgY5SD50M
 JSjXhskd9aXQiUrexHejCdfgL0htWgjVTazyRmrXJeckpNMWvzK+R/bzcbW5b+kQYqY+PNK3C4I
 crbpNE1FaRrdZzsAd6DQDjVGhjkZmyb+Z76t7mQz4hOhaVo45omdk5MgPdS3FBQtOv0UcMPtkBK
 BDXYYF8GyZtS+n2ysIhJ+RCb2bjoNlQQuHTupyMXfi6420L0HqvIyFnASRD2h7mOAAyhz1cLONC
 pC84JxmmuaShf+FqlNw==
X-Proofpoint-ORIG-GUID: fge0qkrr_gzHPYucxGm1UQxwC_FWEqth
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2026-01-05_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601050138

On Mon, 2026-01-05 at 13:41 +0100, Janosch Frank wrote:
> On 12/17/25 04:01, Eric Farman wrote:
> > SIE may exit because of pending host work, such as handling an interrup=
t,
> > in which case VSIE rewinds the guest PSW such that it is transparently
> > resumed (see Fixes tag). There is still one scenario where those condit=
ions
> > are not present, but that the VSIE processor returns with effectively r=
c=3D0,
> > resulting in additional (and unnecessary) guest work to be performed.
> >=20
> > For this case, rewind the guest PSW as we do in the other non-error exi=
ts.
> >=20
> > Fixes: 33a729a1770b ("KVM: s390: vsie: retry SIE instruction on host in=
tercepts")
> > Signed-off-by: Eric Farman <farman@linux.ibm.com>
>=20
> This is purely cosmetic to have all instances look the same, right?

Nope, I can take this path with particularly high I/O loads on the system, =
which ends up
(incorrectly) sending the intercept to the guest.

