Return-Path: <kvm+bounces-20712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FE8C91C979
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 01:11:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E8A401F2438E
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2024 23:11:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E88D7824A3;
	Fri, 28 Jun 2024 23:11:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="TbueYSR8"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B32278C8B;
	Fri, 28 Jun 2024 23:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719616261; cv=none; b=kQoSSn8HB3/xZl57d6dnDXj8/Yz+Ay7TGJuGhlKqHuzfTPYLS0+9RobVmursBoJHUXH/Hl3APn1HiAn1IoW7eEFCDeujIzdR5T+x6lgM/Z+15y0Kth9QIW0joIbExdQX8bB+v22B0euryr1zVHCqou58D33LlhEUCeJVrM7RLwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719616261; c=relaxed/simple;
	bh=diwPSGCQ/3is+Q9UM6pr9xoXIVN6+1oJq+sPJlLoIbc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=F4QSc2X+3OTefveg6peEG5Xz7fBTw83NguUTgQ7mooQ6Khd/bqDN/4lxVgvebaRn2McZSYzib9VH/iNHdwbtWassK+volnm05WYakqPHIF0hRn7Bb+0miLUBmOR8XDOiCYqlwhCZol1hdrOgUgzgtW27woc5YshuDw5JZQWUymM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=TbueYSR8; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45SL01f8012190;
	Fri, 28 Jun 2024 23:10:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	K4Vtj89JvpeHdJUXiXZIoDps+CGpgJrfhB1YQvFKDes=; b=TbueYSR8oMf7Qc+J
	J0e9jUIfzJ6gjbD+/ASULcPfK8I06RIm20GDB1+80USl2F3g1H4Wgab6rY/qdtwj
	l0mV9F8gRri17CPLBcOcWuqGaRwcofhEqZ7Lm4T2QUDW1iuPCtYHvrYvBN98hxH9
	ClW1mseUdKRbXpGnRb4QEaE0/DVUIEK05lv6zunXhXdJ6kTUtNJe4UlA+/5yKhzL
	uErQrhmIqpheiZwCyFi5Hp8uuX1HIdaBnOlDIDUF+P3t3VdrGUpX5XQ3kthRc3Kj
	MUnKKVD15YaEERPNjk4JHMyNioD7oayCukhSgRh2rizlSahEEclJ5AdkgviaABbS
	DIo6vQ==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 400f90rmqb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 23:10:33 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45SNAW5g032120
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 28 Jun 2024 23:10:32 GMT
Received: from [10.48.245.152] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Fri, 28 Jun
 2024 16:10:31 -0700
Message-ID: <75edb9c4-7fb9-4fea-9cd7-4a8565d1438e@quicinc.com>
Date: Fri, 28 Jun 2024 16:10:30 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: x86: add missing MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar
	<mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin"
	<hpa@zytor.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20240622-md-kvm-v2-1-29a60f7c48b1@quicinc.com>
 <171961376508.228791.6632768103700293303.b4-ty@google.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <171961376508.228791.6632768103700293303.b4-ty@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 9mpPY3iBAMr9mpi90jkW1Yq2AemO7L-D
X-Proofpoint-GUID: 9mpPY3iBAMr9mpi90jkW1Yq2AemO7L-D
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-28_16,2024-06-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 malwarescore=0 mlxlogscore=978 mlxscore=0 adultscore=0
 impostorscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406280175

On 6/28/2024 3:55 PM, Sean Christopherson wrote:
> On Sat, 22 Jun 2024 22:44:55 -0700, Jeff Johnson wrote:
>> Fix the following allmodconfig 'make W=1' warnings when building for x86:
>> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-intel.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-amd.o
> 
> I split this into two commits.  The x86 changes went to `kvm-x86 misc`, and the
> generic KVM one went to `kvm-x86 generic`.  I split them partly so that I could
> opportunistically delete the VT-x comment from kvm_main.c, which was comically
> stale.
> 
> Holler if anything looks wrong.  Thanks!
> 
> [1/1] KVM: x86: add missing MODULE_DESCRIPTION() macros
>       https://github.com/kvm-x86/linux/commit/8815d77cbc99
> 
> [1/1] KVM: Add missing MODULE_DESCRIPTION()
>       https://github.com/kvm-x86/linux/commit/25bc6af60f61
> 
> --
> https://github.com/kvm-x86/linux/tree/next
LGTM, thanks!

