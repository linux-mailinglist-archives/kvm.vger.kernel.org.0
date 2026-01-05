Return-Path: <kvm+bounces-67034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 66330CF2C23
	for <lists+kvm@lfdr.de>; Mon, 05 Jan 2026 10:29:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2CC0E3058464
	for <lists+kvm@lfdr.de>; Mon,  5 Jan 2026 09:26:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EEFE32FA2E;
	Mon,  5 Jan 2026 09:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nWWxaK/j"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176A72E6CC7
	for <kvm@vger.kernel.org>; Mon,  5 Jan 2026 09:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767605189; cv=none; b=Zwx0iww83VrgIcp7VOXBDVWMeUlnGa41vhkC6hmb2jaCke/IyphAmvOfBr2nEdukuo4YCMS7mSGSI7a/IWBiwhKq0NMY3w6GGBALVgWnGPJsAlErzcVSuEg+wALXyQWY0OQreDkj+LBZAOP4eHWh6ZYS4x+gPX1wMV0UIq9kZ98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767605189; c=relaxed/simple;
	bh=0ru2QpTNAnfGHPKre0lNlt39cTcwcjdqnKZlRzmUEPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D5Qa87t8agu/VGBA6Bj5FB/Bh9UaWDp1ZHxexTqdaTfMS9ONUZCMNM5Z8Oo5g/U4f+qYcfZMwW4p5BQyM+zjLr7kst1+5eTJ4R08rrwnD2PfaJqgOnCpSoZnk6TaLBsFaJ3W3Sd94JbWTYum9jXqewXW4td0f4Ve6tTRMCpdUwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nWWxaK/j; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 604Bj6v5025190;
	Mon, 5 Jan 2026 09:26:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=G8AOz4
	UijTVIPiBlwKYmV4Gw6y2SvdhHLi/xnUwEXIc=; b=nWWxaK/jSvpaWDAJQi/qot
	wtL7VsWdDLl9YWWXNT0BYC2YC0WtE94abcrunLlv5RrlIKsadwE1r53yNfgGpm5K
	iyK3vuB2Mu/CRxPZK/3HujvoLSvn2ckjrmbL76Jezdk9id3/E5gVmIhkL5mmmm4l
	bWVWt22L10CfRIXZKR73KnAfe+G1xGaEZvF0K0tNSpSZq6HUkadq5UNsOE9oG2pg
	uMq4o+6x8S7HruJA1IJNioQaHzyx0QYVGu443ZYTh5xFgQ7CHYyokGZPZeGLpfpQ
	Dr1p4kWuaHBGLn2Z2KdlkEuUgsYubY00iNHKQgBh6CIJNj5Dhcy1OXUJ0J1kioBQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm6xfu5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 09:26:21 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 6059DbAv000952;
	Mon, 5 Jan 2026 09:26:21 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4betm6xfu3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 09:26:20 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60585INg019171;
	Mon, 5 Jan 2026 09:26:20 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bfg50vp7j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 05 Jan 2026 09:26:20 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6059QJsS19268342
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 5 Jan 2026 09:26:19 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9EF958057;
	Mon,  5 Jan 2026 09:26:18 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 551A058063;
	Mon,  5 Jan 2026 09:26:16 +0000 (GMT)
Received: from [9.109.216.92] (unknown [9.109.216.92])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  5 Jan 2026 09:26:16 +0000 (GMT)
Message-ID: <5b558ade-e712-417e-8d29-866144194454@linux.ibm.com>
Date: Mon, 5 Jan 2026 14:56:14 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] target/ppc/kvm : Use macro names instead of hardcoded
 constants as return values
Content-Language: en-GB
To: Gautam Menghani <gautam@linux.ibm.com>, npiggin@gmail.com,
        rathc@linux.ibm.com, pbonzini@redhat.com, sjitindarsingh@gmail.com
Cc: qemu-ppc@nongnu.org, kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20251202124654.11481-1-gautam@linux.ibm.com>
From: Harsh Prateek Bora <harshpb@linux.ibm.com>
In-Reply-To: <20251202124654.11481-1-gautam@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=OdmVzxTY c=1 sm=1 tr=0 ts=695b83bd cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=f7IdgyKtn90A:10
 a=VkNPw1HP01LnGYTKEx00:22 a=VnNF1IyMAAAA:8 a=mtlxwhp4t4fErtxsobUA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: EDhIu4lpWDkpH4EejumgfkQ2xmAZ4NDv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTA1MDA4MiBTYWx0ZWRfX2ZXImWrX1bxM
 BsJ6KCMZALRzR4YfUrqQtYtrmzfFhqb5MF7qqPh0rDF6pwD4SC1R1Ck3NeJAZuXPHxZPMCe/a51
 JPjWVtVbbw/Zqh0Bcissu7kS8noIVuFTY+l1SRFMmnInI+H5VahaCbscmjla3siUrEndWukiG/m
 +XnmvlIjvsbMcpBHGOZrsmt1DX5RmQ1C8FXnxWnoP2s2SQl0Fb4bUhX13/EJDna3izdrqdXl6v0
 E5CWoGBQgOkFNfjtpcqqnpVeFzl/0gdvIDfPEFcyDRCLA/36bHGTzp51ZEQCL3CeiwtCnS4RSjr
 BeLf0bO/pRwUIO3QeroGi3XEuMv3DVie+VkmxYY1ljm3DewUchozJCev0w6jeX4S/tTVj0qZTWp
 1/DPUUGwKm4aMHo4092m/kv6bxLGx4KGp1u+gpkejzFlwNmatgfxzFxMsf/9a5ShvYts84L8vZd
 vZqXmt+nbrgjhVSVQSQ==
X-Proofpoint-ORIG-GUID: XyRiKkCmh1xx_rxbZRxRPbpn4BoEd7El
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-05_01,2025-12-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2512120000
 definitions=main-2601050082



On 02/12/25 6:16 pm, Gautam Menghani wrote:
> In the parse_* functions used to parse the return values of
> KVM_PPC_GET_CPU_CHAR ioctl, the return values are hardcoded as numbers.
> Use the macro names for better readability. No functional change
> intended.
> 
> Signed-off-by: Gautam Menghani<gautam@linux.ibm.com>
> ---
>   target/ppc/kvm.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)

Queued.

