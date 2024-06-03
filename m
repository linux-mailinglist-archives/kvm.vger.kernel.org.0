Return-Path: <kvm+bounces-18697-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02BFB8FA65D
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 01:22:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B56CC286399
	for <lists+kvm@lfdr.de>; Mon,  3 Jun 2024 23:22:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFF6E84A24;
	Mon,  3 Jun 2024 23:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="GAqKdLum"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DC4F1E49B;
	Mon,  3 Jun 2024 23:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717456930; cv=none; b=nqj7MYH8N3we7ftJgF4KP7GlpWJxMwGIWebv7gyOO3nfrvQF5sZk0fPcgOTewF6ZmPsGOb6K8dzlVripfNY0nWFsMyC4dcy1zzfWfbFEF8Z0w8ViPQKkpQQfEef00xBjOYwL7NNe1Z/UmC43japykATzSw4VjybSfs13Eca8lKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717456930; c=relaxed/simple;
	bh=3BvPeKQe5a05MFgsaDP+dEEwoRS2G62azHt+NDky8Sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=bUu+ndpuffAuafQliw1fIC7st6p83WOIxPoJvAlKDbxENOQempUkovCERVWQ+HBYUTILo5eAAxHBeuD7Ml/++2z7P8hxbwGRS6NqHk4zQ3paxDCaDEyUMulnPqFDqCPcbmHgjo/Y0WzwENCPueOxJIrFXsLQoCb5izSQLuAxI4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=GAqKdLum; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 453JI9Ph020432;
	Mon, 3 Jun 2024 23:21:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kLdqMdDOIQnOzb4FG912hEb7C0NlaDeafqYv15akPZE=; b=GAqKdLumxtkfX/d4
	h4lqDf8at3ejw5MM5z0XWPPTbVHeLBtWQszOgStCY+al5hnBURUHIIWxY7rw80gI
	FTvXbzEAgC11zbs6JvU5TpE7HdcsQhSQOGgjsSXizg4fbUSbto2iTwenIX5l7dsz
	Wlx69N6lIGq0yYFr2RrZljZvCP8JRTov0jScgvJ5/h36jijTqMWpx62K58o0a7m0
	Xu0pJ2yo+0bX+QKraY4PCuQslYKE4nvALJkPDNIXsES0pgIEC9NH1gqi5YgOFQ3T
	k2ugFTfs/In9sXG0NXxJnbjg+nCq+VvFejVOMAFjsiAksB6/WymYCwg8K65IMIQ4
	yyOTWg==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yfw5kne7q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Jun 2024 23:21:31 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 453NLUl9026335
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 3 Jun 2024 23:21:30 GMT
Received: from [10.48.241.139] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Mon, 3 Jun 2024
 16:21:28 -0700
Message-ID: <022bf315-9ec2-4cc9-b007-922d7b95d5dd@quicinc.com>
Date: Mon, 3 Jun 2024 16:21:28 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: add missing MODULE_DESCRIPTION() macros
Content-Language: en-US
To: Sean Christopherson <seanjc@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H. Peter Anvin"
	<hpa@zytor.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20240528-md-kvm-v1-1-c1b86f0f5112@quicinc.com>
 <Zl5NM5S4Trrqog_t@google.com>
From: Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <Zl5NM5S4Trrqog_t@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nalasex01a.na.qualcomm.com (10.47.209.196) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: g4_lv3xrzoGy6bSJykiagsBV1Ptow3CT
X-Proofpoint-ORIG-GUID: g4_lv3xrzoGy6bSJykiagsBV1Ptow3CT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-03_17,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 impostorscore=0 suspectscore=0 malwarescore=0 clxscore=1015 phishscore=0
 mlxscore=0 priorityscore=1501 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=818 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406030189

On 6/3/2024 4:09 PM, Sean Christopherson wrote:
> On Tue, May 28, 2024, Jeff Johnson wrote:
>> Fix the following allmodconfig 'make W=1' warnings when building for x86:
>> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-intel.o
>> WARNING: modpost: missing MODULE_DESCRIPTION() in arch/x86/kvm/kvm-amd.o
>>
>> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
>> ---
>>  arch/x86/kvm/svm/svm.c | 1 +
>>  arch/x86/kvm/vmx/vmx.c | 1 +
>>  virt/kvm/kvm_main.c    | 1 +
>>  3 files changed, 3 insertions(+)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index c8dc25886c16..bdd39931720c 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -53,6 +53,7 @@
>>  #include "svm_onhyperv.h"
>>  
>>  MODULE_AUTHOR("Qumranet");
>> +MODULE_DESCRIPTION("KVM SVM (AMD-V) extensions");
> 
> How about "KVM support for SVM (AMD-V) extensions"?
> 
>>  MODULE_LICENSE("GPL");
>>  
>>  #ifdef MODULE
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index 6051fad5945f..956e6062f311 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -74,6 +74,7 @@
>>  #include "posted_intr.h"
>>  
>>  MODULE_AUTHOR("Qumranet");
>> +MODULE_DESCRIPTION("KVM VMX (Intel VT-x) extensions");
> 
> And then a similar thing here.
> 
>>  MODULE_LICENSE("GPL");
>>  
>>  #ifdef MODULE
>> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
>> index 14841acb8b95..b03d06ca29c4 100644
>> --- a/virt/kvm/kvm_main.c
>> +++ b/virt/kvm/kvm_main.c
>> @@ -74,6 +74,7 @@
>>  #define ITOA_MAX_LEN 12
>>  
>>  MODULE_AUTHOR("Qumranet");
>> +MODULE_DESCRIPTION("Kernel-based Virtual Machine driver for Linux");
> 
> Maybe "Kernel-based Virtual Machine (KVM) Hypervisor"?  I personally never think
> of KVM as a "driver", though I know it's been called that in the past.  And having
> "Hypervisor" in the name might help unfamiliar users.

Thanks for the suggestions since my first past was just gleaned from existing
code headers and Kconfig help text. Will spin a v2 after waiting for any
further comments.

/jeff

