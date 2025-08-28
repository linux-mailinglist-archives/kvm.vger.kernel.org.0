Return-Path: <kvm+bounces-56030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4BE40B393D0
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 08:33:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 65BA21BA367D
	for <lists+kvm@lfdr.de>; Thu, 28 Aug 2025 06:33:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34DA626AAA3;
	Thu, 28 Aug 2025 06:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cjlKlhnV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D706D207A26
	for <kvm@vger.kernel.org>; Thu, 28 Aug 2025 06:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756362787; cv=none; b=qPmmB/VzNNiVsvrehL/pjqqS+Hy4w6FjjykrSdamyx85Ic5KMXO4ec9rPnCMlslcmDded/MWoDg0YNAVTTV7fzTEvwCTn4BLX1vek763sLb/HHvIxkPUjSAWEYo/RHpOKuN+ZNm9M+58aiZ58YYGXhVZi5OGc6d1b9yoJ6CLuu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756362787; c=relaxed/simple;
	bh=EBEAf2Vgp+KLS8jTcf3dR8TLoUmsUmR+f8eP0hyhd/Q=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B3CtX7XMxQ1fG1O6avYoK/ncGh3cfnosTsyuvI4eWyc/fxwnbzFmSApL9MgQmyewQ/dNyG/2tAb612YVVNEoUvXatwArtRw9BAQyFgok1oLDey3kgEUoqmJfx8dgjA7/fkv8k0pR+w7bbuPHBo42Dvb4Qbv2Z+9o7VQxQpBeuno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cjlKlhnV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57S2QtIP008995;
	Thu, 28 Aug 2025 06:33:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UF3gRz
	BamEQVarWzhWw/EArZOFxd2J8P6xFYpNaOWbc=; b=cjlKlhnV9EnvzIFVQ2DgFz
	wIi0wIQjNf2O9AoTriG7Awn3sHuBKA5NHUW1KJFP52T0AAyOrGixSwBeAiCJ/HwU
	NZSzvmNZMwfv/qCTLAvTyFpXaCsff0TQ9x3/PzRuBBxxKaP4e82AzpgbPbeIsx4Q
	jDK+2a+dKDZWxyQkoiCLFGGhHMK1Q2Nn/vabnOlnOCs4qoqIljzw2msuhqJnXFbu
	TVSF1SicxL/jgKzp7aGyQQ+coSjUdJpRer6gZlZYVZNUSdpoOhF/9wTQmvYhHJwu
	c9+4hDZYE0OVI1xmG+W3tWOpxCK/Apfpoq2UQMyMzeUgQapYU1XXu56Y4skd1ViA
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48q975ff5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Aug 2025 06:33:01 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57S4UDA4007443;
	Thu, 28 Aug 2025 06:33:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48qqyuktv9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Aug 2025 06:33:00 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57S6WuV631523196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Aug 2025 06:32:56 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8AAB920043;
	Thu, 28 Aug 2025 06:32:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0AD0820040;
	Thu, 28 Aug 2025 06:32:55 +0000 (GMT)
Received: from li-c439904c-24ed-11b2-a85c-b284a6847472.ibm.com.com (unknown [9.43.64.161])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 28 Aug 2025 06:32:54 +0000 (GMT)
From: Madhavan Srinivasan <maddy@linux.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        Andrew Donnellan <ajd@linux.ibm.com>
Subject: Re: [PATCH] KVM: PPC: Fix misleading interrupts comment in kvmppc_prepare_to_enter()
Date: Thu, 28 Aug 2025 12:02:53 +0530
Message-ID: <175635911048.1554354.16394188093362755086.b4-ty@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250806055607.17081-1-ajd@linux.ibm.com>
References: <20250806055607.17081-1-ajd@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: I6-36I66aaVCd5tuA9T6n620E6BC7pJu
X-Proofpoint-ORIG-GUID: I6-36I66aaVCd5tuA9T6n620E6BC7pJu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIzMDA3MSBTYWx0ZWRfX0xWTW+d1M7Ui
 9jfjF6sx1gXxg9u8fknQDX2T1NCf/mj47zrjtDINQuVPOEsuteVAue3wI/wgaNbPIqpPkRuM7Nt
 5ZoIcRgzIE2swnLWmDjjHJzNbhpHKW6J0YTbgll5ZiM+IwDConSNhE9iO4hncE1/Vn5YnDCTA4E
 ZylE3b67s7IDXoB0E/JLPcfuyzQ+dhBdKoyiPhL7Cxsmk74LQhYtE2BE+f7lbAtci4myDiA4l67
 AhCS0wMCTYxx5KEv2PrWInF6/p81mzlVXbSUcPoHKMGrxSJ03FJ/zsvEEFGowU2MymkuJGHSPfb
 qd9dU0PL+MOuVzebTRLaU3sym+oFIq7uxZePn2iHSmn4NKinPhAHosdbANKDmSqPSU0OIvS80RA
 3JWXh6Fc
X-Authority-Analysis: v=2.4 cv=RtDFLDmK c=1 sm=1 tr=0 ts=68aff81d cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=x6bhQlrcOuA10pbQGD8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-28_01,2025-08-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 clxscore=1011 phishscore=0 adultscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508230071

On Wed, 06 Aug 2025 15:56:07 +1000, Andrew Donnellan wrote:
> Until commit 6c85f52b10fd ("kvm/ppc: IRQ disabling cleanup"),
> kvmppc_prepare_to_enter() was called with interrupts already disabled by
> the caller, which was documented in the comment above the function.
> 
> Post-cleanup, the function is now called with interrupts enabled, and
> disables interrupts itself.
> 
> [...]

Applied to powerpc/fixes.

[1/1] KVM: PPC: Fix misleading interrupts comment in kvmppc_prepare_to_enter()
      https://git.kernel.org/powerpc/c/02c1b0824eb1873b15676257cf1dc80070927e1e

Thanks

