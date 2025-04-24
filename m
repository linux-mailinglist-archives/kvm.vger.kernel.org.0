Return-Path: <kvm+bounces-44198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C6DE4A9B39D
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 18:14:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8728E1BA41A6
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 16:14:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DC4D280CCE;
	Thu, 24 Apr 2025 16:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="G8d5amNz"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B1927FD6A;
	Thu, 24 Apr 2025 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745511201; cv=none; b=k81VwJTk+wsgOrGQEJJMxf+LquTb8hBSbIbX2eCrybVIuejTvX9pXsZk5YxuA/mGxuUA08ACz0f1hP1Wqe/I08ynkrU/0BJtAhbVZ2GfML9DbuC1e/IBik7Iz5zUarrRW0pu4qAbkhMHjC8T4FYKUEwXuslla5p5mYAs0vUT4/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745511201; c=relaxed/simple;
	bh=v1UxVa+PI6U3L36c4JFEJmFX8DLDGp5S2URvKxvrUsY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=cb6hqraL1pWAJLbEfczfgU8zZaZPUddf77+iQMvYf6Js2kfVzIQvsnssHxr8CH/Zur7K1//P6Zhx3QgH67pYCiqut7uRPTCkD+IZEO7LVZ2GWuMkdYupp0QrxRDscmDAlRav/VfvLrRM016+kpG6/Ai1mQmNfMymPnpehQwm1QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=G8d5amNz; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53OC3FRs016629;
	Thu, 24 Apr 2025 16:12:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	m2fYm5cJk3mUwObfRwx9NEss8EiojDmyTGH8I1ncS7w=; b=G8d5amNzs21FxE6y
	KWrAAsMNFAZbDf1kD/BAVZQd58v6X9k5w0VnaewapXrwQwlU5YGvK0WYnnTWQHKU
	1Ez2LwtU3XWJfpPD8Utex/RBvmdJnwyCZYLRfKtP+3sXybiBBPMfLpiMc4gwAdNN
	HZjI/G4/U85auTHg1WQU46gXDR3rVYIXLDZg2o0FD2JDpIfCzH5HBglaK4omJMbh
	co5blnxRbVHVKIqxBlgUj1zyrB8rzBCeijVc58jGgdbVs6xOeo67Rinh8pIidWvg
	cjmPuonkguSsQLMHORRbeVP1Jlk5blsS/9+3AMCXPaPmFBQUcyRP6YsZKse/zV+g
	AK5MeQ==
Received: from nasanppmta02.qualcomm.com (i-global254.qualcomm.com [199.106.103.254])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 466jh269h4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Apr 2025 16:12:52 +0000 (GMT)
Received: from nasanex01a.na.qualcomm.com (nasanex01a.na.qualcomm.com [10.52.223.231])
	by NASANPPMTA02.qualcomm.com (8.18.1.2/8.18.1.2) with ESMTPS id 53OGCpa7014068
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 24 Apr 2025 16:12:51 GMT
Received: from [10.110.125.18] (10.80.80.8) by nasanex01a.na.qualcomm.com
 (10.52.223.231) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 24 Apr
 2025 09:12:50 -0700
Message-ID: <75478fa1-77b9-4e1a-94e1-6907da7b03b8@quicinc.com>
Date: Thu, 24 Apr 2025 09:12:49 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 00/34] Running Qualcomm's Gunyah Guests via KVM in EL1
To: Oliver Upton <oliver.upton@linux.dev>,
        Karim Manaouil
	<karim.manaouil@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
        Alexander Graf <graf@amazon.com>, Alex Elder
	<elder@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Fuad Tabba
	<tabba@google.com>, Joey Gouly <joey.gouly@arm.com>,
        Jonathan Corbet
	<corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
        Mark Brown
	<broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Paolo Bonzini
	<pbonzini@redhat.com>,
        Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
        Quentin Perret <qperret@google.com>, Rob Herring <robh@kernel.org>,
        "Srinivas
 Kandagatla" <srini@kernel.org>,
        Srivatsa Vaddagiri
	<quic_svaddagi@quicinc.com>,
        Will Deacon <will@kernel.org>,
        Haripranesh S
	<haripran@qti.qualcomm.com>,
        Carl van Schaik <cvanscha@qti.qualcomm.com>,
        Murali Nalajala <mnalajal@quicinc.com>,
        Sreenivasulu Chalamcharla
	<sreeniva@qti.qualcomm.com>,
        Trilok Soni <tsoni@quicinc.com>,
        Stefan Schmidt
	<stefan.schmidt@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
 <aApaGnFPhsWBZoQ2@linux.dev>
Content-Language: en-US
From: Trilok Soni <quic_tsoni@quicinc.com>
In-Reply-To: <aApaGnFPhsWBZoQ2@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Authority-Analysis: v=2.4 cv=EtLSrTcA c=1 sm=1 tr=0 ts=680a6304 cx=c_pps a=JYp8KDb2vCoCEuGobkYCKw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17 a=GEpy-HfZoHoA:10 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=Is-ihHZF1yIjBAXmSsYA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 55dCfyNhftS-2YWHt7GAvMiwMYPx2D9y
X-Proofpoint-ORIG-GUID: 55dCfyNhftS-2YWHt7GAvMiwMYPx2D9y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI0MDExMSBTYWx0ZWRfX61Lzpnir4GvW a7cJmVamFUabluoXWJ6BK2jcPXgg8kFSeQB7lNLcwVqiipHU5Zf0tYtXokJQrxkGd6vdibMRhB3 +yjk7k61b5guLM61T85iaBo6G8cV2sUcJJOx7fUBr3SCwMlvuhr3GtFB9p4BavDvZ8/YNxl7Pv4
 kfSNAiRreWxvN172yqBYFAfnV1754cBD99jrHuegQ0jkI4Ll84JPhMmfPNDb7VVHApmwosGglCl xBBSC5iniMlR9SNTAbpJ3ohBJMtK/0GXLGUIGr2vorM8E1q++3zIhhvn11yTx7nRa7KbRc8hX+c lWN1fbyqbymnzA/mBEFdz2TS9Ip+QCaA1Cg7nRj5clGzbIcoft9O7IRhVQE9n+xBr8XxAtoNhXj
 Z7AsCEHlqKWVM+yCKYEEBCT9nrP330P7C1RUDo2Wrp9PNiQSdx4OQpMhXJR5Yj35/lSyy5S6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-24_07,2025-04-24_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxscore=0 clxscore=1011 spamscore=0 mlxlogscore=862
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 impostorscore=0
 adultscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504240111

On 4/24/2025 8:34 AM, Oliver Upton wrote:
> On Thu, Apr 24, 2025 at 03:13:07PM +0100, Karim Manaouil wrote:
>> This series introduces the capability of running Gunyah guests via KVM on
>> Qualcomm SoCs shipped with Gunyah hypervisor [1] (e.g. RB3 Gen2).
>>
>> The goal of this work is to port the existing Gunyah hypervisor support from a
>> standalone driver interface [2] to KVM, with the aim of leveraging as much of the
>> existing KVM infrastructure as possible to reduce duplication of effort around
>> memory management (e.g. guest_memfd), irqfd, and other core components.
>>
>> In short, Gunyah is a Type-1 hypervisor, meaning that it runs independently of any
>> high-level OS kernel such as Linux and runs in a higher CPU privilege level than VMs.
>> Gunyah is shipped as firmware and guests typically talk with Gunyah via hypercalls.
>> KVM is designed to run as Type-2 hypervisor. This port allows KVM to run in EL1 and
>> serve as the interface for VM lifecycle management,while offloading virtualization
>> to Gunyah.
> 
> If you're keen on running your own hypervisor then I'm sorry, you get to
> deal with it soup to nuts. Other hypervisors (e.g. mshv) have their own
> kernel drivers for managing the host / UAPI parts of driving VMs.
> 
> The KVM arch interface is *internal* to KVM, not something to be
> (ab)used for cramming in a non-KVM hypervisor. KVM and other hypervisors
> can still share other bits of truly common infrastructure, like
> guest_memfd.
> 
> I understand the value in what you're trying to do, but if you want it
> to smell like KVM you may as well just let the user run it at EL2.

I agree, this is not the approach Qualcomm would like to use. Our approach
will be similar to Elliot Berman's patches (v17). We will revive
that series once Faud's patches are accepted on guest_memfd. 

-- 
---Trilok Soni

