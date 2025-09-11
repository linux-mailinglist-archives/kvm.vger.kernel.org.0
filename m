Return-Path: <kvm+bounces-57295-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 481BDB52E2D
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 12:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 040551651CA
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 10:19:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6B6B30FC03;
	Thu, 11 Sep 2025 10:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="USvcot4F"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86AFE23BD02
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 10:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757585949; cv=none; b=Z1zBHnCd6JPBzh3+H6pnD3Snc2DiHIv1g59jSV8uVszPz7iEE0VWtq93agWh1YWVlLVwnb1D4HkJs5cXqwUsgAgjEjrudFnpCJdOVoBHfyeXLWHM4Q98xajyNBGsnBRDvRUd1vMcx/HK3aQ2tNhO9ZEir0fGRxWrisCvlqq11dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757585949; c=relaxed/simple;
	bh=N4cqtZAkOriiJJsE/py4jfm522e2J2e/XT+699Q18KM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=MKiUUVtsOBfSkmC7KI6iF51Bovf+gPpgje+fd3Dk7yYVSpR8TMskJwmALZuvFExTRE1sKIP4EHqHBPhn7BoHdU/DG1UfFlYU5hAbaDPwFH20u+htqCQJQDBQsMxSODgnLm07N4cjgmvktCIHCUi3bgZZ4mU93eRLQVzBu5I5hsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=USvcot4F; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58B0Ms8M025770;
	Thu, 11 Sep 2025 10:18:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=7ySQTtsuqBD+MBd+vb7LAwCNY3tlSJ
	SknVHSNQcMGTc=; b=USvcot4FdasQ4yH0/IP5ANaskUy1YyCWj4oKbYKvtJ0DFo
	jMtv0ZGZABg+LdwPImlw4uU8N0U52x/ivB8TWwwA8OmjAteT33CpktdPf9C9ttLz
	YA4ohyAmtQ3vnxmi7cWofpJYk6qM7UAfZK6346RLT/qT6b7VdYBc74I5Zg18o+i8
	4UhRB3DAwSuRnZ3LT+tbGXxYoYONhNsyBUcExtZXjo5dplzGidn0MgMQEPeWxfy3
	/EJ/3TIHUgvQ/dpTsMYOH0g4N8P93tt9JvIi2y7L0uTUegux8Kz3tC+dwhJprqNy
	QDrNmg+5Fo63r2rJaPCRNbSkJPLzuZXnWGP0F+2w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmx3yhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 10:18:50 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58BAInj2005238;
	Thu, 11 Sep 2025 10:18:49 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 490cmx3yhp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 10:18:49 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58B7KJiT001198;
	Thu, 11 Sep 2025 10:18:48 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 491203n0nr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 11 Sep 2025 10:18:48 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58BAIiMZ31195468
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 11 Sep 2025 10:18:44 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D12E52005A;
	Thu, 11 Sep 2025 10:18:44 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D9362004B;
	Thu, 11 Sep 2025 10:18:41 +0000 (GMT)
Received: from vaibhav?linux.ibm.com (unknown [9.43.85.18])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 11 Sep 2025 10:18:41 +0000 (GMT)
Received: by vaibhav@linux.ibm.com (sSMTP sendmail emulation); Thu, 11 Sep 2025 15:48:40 +0530
From: Vaibhav Jain <vaibhav@linux.ibm.com>
To: Gautam Menghani <gautam@linux.ibm.com>, npiggin@gmail.com,
        danielhb413@gmail.com, harshpb@linux.ibm.com, pbonzini@redhat.com
Cc: Gautam Menghani <gautam@linux.ibm.com>, qemu-ppc@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2] hw/ppc/spapr_hcall: Return host mitigation
 characteristics in KVM mode
In-Reply-To: <20250417111907.258723-1-gautam@linux.ibm.com>
References: <20250417111907.258723-1-gautam@linux.ibm.com>
Date: Thu, 11 Sep 2025 15:48:40 +0530
Message-ID: <87ikhpz3zz.fsf@vajain21.in.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: z0P8yeGa2Y41eqBrMR2vM8YI4Vkej0qW
X-Proofpoint-ORIG-GUID: OzC6_Z2bEia6nzn6rV_0McFwdclb5q1T
X-Authority-Analysis: v=2.4 cv=J52q7BnS c=1 sm=1 tr=0 ts=68c2a20a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=yJojWOMRYYMA:10 a=voM4FWlXAAAA:8 a=VnNF1IyMAAAA:8 a=Qpf7MMjoylcV1AdVgqMA:9
 a=IC2XNlieTeVoXbcui8wp:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA2MDAyNSBTYWx0ZWRfXwuQjFB5PfJuN
 j7j1QBU+CVLZ02MpYKtkfbRfXFr9lTl3v8xTV1ZRcfLft/J9oXyHdoL0yKp+r3ueQPmC8aGpAcN
 8OsO848xGLL4GQZVhDokvkinPFKvyJkVAXzuGKMVBZCJMAvm7YDPEIccP5D5F8vUIyA/F4fG1vJ
 c6fZyq0srVkOyhWq++1NrAR62s35qC4t4oIL+hPu4UpPs4Yg6JiKLigkdz1nQ5+PSrcOlHxPv+q
 bVtUBi+96qO5Azd5ASirmL+Qwl2cPRh9xpibvWshdXXy7fXarnVyRZcp/c7tqNsSUp8dNLbb/t1
 ZDZdouUsebw5KhPKU5JVaQJOW/d+zWFhxEB7f5b+Z0UZf0tZ7VsbbqJW87hUqbHjLwDwS3hMfYb
 8mMfbi/c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-10_04,2025-09-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2509060025

Gautam,

Thanks for this patch

Gautam Menghani <gautam@linux.ibm.com> writes:

> Currently, on a P10 KVM guest, the mitigations seen in the output of
> "lscpu" command are different from the host. The reason for this
> behaviour is that when the KVM guest makes the "h_get_cpu_characteristics"
> hcall, QEMU does not consider the data it received from the host via the
> KVM_PPC_GET_CPU_CHAR ioctl, and just uses the values present in
> spapr->eff.caps[], which in turn just contain the default values set in
> spapr_machine_class_init().
>
> Fix this behaviour by making sure that h_get_cpu_characteristics()
> returns the data received from the KVM ioctl for a KVM guest.
>
> Perf impact:
> With null syscall benchmark[1], ~45% improvement is observed.
>
> 1. Vanilla QEMU
> $ ./null_syscall
> 132.19 ns     456.54 cycles
>
> 2. With this patch
> $ ./null_syscall
> 91.18 ns     314.57 cycles
>
> [1]: https://ozlabs.org/~anton/junkcode/null_syscall.c
>
> Signed-off-by: Gautam Menghani <gautam@linux.ibm.com>
> ---
<snip>

LGTM,

Reviewed-by: Vaibhav Jain <vaibhav@linux.ibm.com>

-- 
Cheers
~ Vaibhav

