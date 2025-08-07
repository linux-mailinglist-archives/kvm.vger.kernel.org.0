Return-Path: <kvm+bounces-54214-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 898F4B1D1B3
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 06:45:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AC1CF7A6BC6
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 04:44:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28CAA1A23A0;
	Thu,  7 Aug 2025 04:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="pfBQhBnh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D675B198A2F
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 04:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754541938; cv=none; b=eQEulNaRRJIQCgKJLh93aZDBWIry1AOjDjvUkigc2SvQI1XFhs/odYeHqHu4ETvrmB8xcECqy+vlyFPdUFBw4REBIknwkMvM2NeZ2n9QZUSinLbX1/k6x8boKzjQz1fwa7U7hek4H0Yo1X2q/4pJwmPpmbPHLd9LR6CEgP70ARY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754541938; c=relaxed/simple;
	bh=ECttXsTWGqN8/EPSwotlkFJDpTqDvZScoXCidyvFRNE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:Cc:
	 In-Reply-To:Content-Type; b=XHe3TKMGxTCgX7PMNrGD56c72wA87NUTrMVMkSTcg4KGiDG6uZksYOL5GHtrwAcYAoxFMUsJJCaAPaBiqj4PfIZCSvDb1zf37vxMK7R2+kBEL9v057jPjMfItTVcfuz2KSSyi8MtRQgINp7dOXz/oJHT28oH1gJHYquEiRpCbmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=pfBQhBnh; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5773wdDd019459;
	Thu, 7 Aug 2025 04:45:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=H9CRSs
	te/NHsQRZw0qsq+5701S8wkfWLjHHrfuvfY2E=; b=pfBQhBnhtdRkBoPw0oDguj
	7yJImJrXZLxvKyW3kv4slgG2TNIXo2IsWgV6Yzz0l8t3x8hVEuPM4SGuklx6uoyE
	LI1mjRwiYQzpeIv1Nld+m8dxaXlz/nkeumwzYrpFCxzAet4etIOXRBUU9NivyZGs
	LJIiQLb6KAivVjVwxibtdg2HDed4ol3OopWVReF7EfJ7PhoxlgD236qBaTxB8MeG
	8n/eu8Y3WJh7T+40wN8MERqpjIbTN119EvUCH5hHXAj7a/rIJOK+Ay77zpbmjQbY
	l0A+2hP5wtr2SVDAwHazTI+g4Cbdzq4WdeQ8HR5MbuXTxOvmYrnXrrCwM9WTEVKw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48c26twd42-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 04:45:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5770f86r031321;
	Thu, 7 Aug 2025 04:45:29 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48bpwnexnt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Aug 2025 04:45:29 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5774jPZ115532306
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Aug 2025 04:45:25 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B9AE62004B;
	Thu,  7 Aug 2025 04:45:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C4F320040;
	Thu,  7 Aug 2025 04:45:25 +0000 (GMT)
Received: from [9.109.215.252] (unknown [9.109.215.252])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Aug 2025 04:45:24 +0000 (GMT)
Message-ID: <01d8e15b-5feb-4db0-beed-67bb5cc765de@linux.ibm.com>
Date: Thu, 7 Aug 2025 10:15:24 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: PPC: Fix misleading interrupts comment in
 kvmppc_prepare_to_enter()
To: Andrew Donnellan <ajd@linux.ibm.com>
References: <20250806055607.17081-1-ajd@linux.ibm.com>
From: Shrikanth Hegde <sshegde@linux.ibm.com>
Content-Language: en-US
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
In-Reply-To: <20250806055607.17081-1-ajd@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: SLsYH1L2uwvatNhfa8VqdcQ1OvFr4PKz
X-Authority-Analysis: v=2.4 cv=F/xXdrhN c=1 sm=1 tr=0 ts=68942f6a cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=x6bhQlrcOuA10pbQGD8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: SLsYH1L2uwvatNhfa8VqdcQ1OvFr4PKz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA3MDAyOSBTYWx0ZWRfX2b5LITlRTEI2
 e/ZZRIjyitRU3vqFVeNS10q6fh3GNvrZxEOZN0AzVfyd5ruf/1Iuz4jJyUgxLsM6a1fJWefP4L+
 jgm4+HQDSjUGYhibNiedqBEDbNTN4VcQ5lx4I6WzDm2AnwwA+2qrTNMKqNmqNU5KvLgpg/QrOyW
 JZqbguXcqPgksM8vUvlyyqkdhwyhRHs2Dbigcie3+mG4RfjMX/wsGcUmw/MhwBkuX4DZAS8iyIC
 kVRKWeSk5akhrCgQvxK9RNwjDKwO3qGUvGJqv+tUI1WzTxireoCXBR6S+XA/zYrR6eEQFVYK0i3
 22KMdNkzXjXg4rhde1QGSNEVA6B5gZQntecPI5HZykwhY0NWpOzmTk8JCwPUxoqOevXA1WFJeSb
 SZ3SPZU7se6wWBXzuZEXRpZOm4K9+PZSrZqg5j3pAuhcw1LfBxIFnHhCWZ4N1LO8+XtvAq5I
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_05,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 clxscore=1011 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=532
 malwarescore=0 phishscore=0 suspectscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508070029



On 8/6/25 11:26, Andrew Donnellan wrote:
> Until commit 6c85f52b10fd ("kvm/ppc: IRQ disabling cleanup"),
> kvmppc_prepare_to_enter() was called with interrupts already disabled by
> the caller, which was documented in the comment above the function.
> 
> Post-cleanup, the function is now called with interrupts enabled, and
> disables interrupts itself.
> 
> Fix the comment to reflect the current behaviour.
> 
> Fixes: 6c85f52b10fd ("kvm/ppc: IRQ disabling cleanup")
> Signed-off-by: Andrew Donnellan <ajd@linux.ibm.com>

Given that there is WARN_ON which would trigger if IRQ were disabled
and further we flip irq before calling schedule, indicates that IRQ must 
be enabled while calling it.

Reviewed-by:: Shrikanth Hegde <sshegde@linux.ibm.com>

