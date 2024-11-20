Return-Path: <kvm+bounces-32183-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 33FC19D4023
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 17:34:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BD7EA1F230EF
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2024 16:34:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33FD11547FF;
	Wed, 20 Nov 2024 16:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WKysZ7xQ"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E1714C5B3;
	Wed, 20 Nov 2024 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732120440; cv=none; b=KBLbUjiezMSAmOajXfHTMyzn1zFuHKYaHtfsZRvNeYOLOymsBkTY/TIWNOBaYNSNKVqFTEIdv6St0zjelD4rvAowjf/41Qaf6UBgs/VgGjTVp6H0KC8mT7u9+aXiCYZmrmKOxuNL4fQHUpWFuHDYHJ8jkThsftonVka8n+VWyXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732120440; c=relaxed/simple;
	bh=Fg6pxotVoY3DQYQYblP98A3VJtH8QNKksBlJU3r3Ny0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GL6e+0XfC1V2keRhM77DGC0qj3OM23zhy0intY1KFlnySA86bW8kWrOIBP0QuLzbIecTbDtZ1jZtoxjGh2ZMNJoczP/v8z7njZOYPZixIqS7bRwYN1SFLHhIjuKx5TJpVsFIglCjeTtDW6dD2XQC+2QvxUnX0WcTb6w3mQG87v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WKysZ7xQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AKDX2uv008868;
	Wed, 20 Nov 2024 16:33:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=rmnZ1C
	CuZhnXJpfoK4eGliAjikEPdZf65dxmKTquabc=; b=WKysZ7xQ7XJXOuEd7yL6ax
	naEiOydTDeFRK5KsnRwvJ7mU5x93tKRd/2ubKM6Fx/9xQN0Jses5+wi3WKeD0osp
	ZMJ2EBONhYdypFGHi3rV2cebjXbLokB/mfFOJfzOU51DSDRb6MvFTGJfoBSkZLeU
	cylWqCX7K+QKIiuvsgN5uP3puDKik2yV83nk4S9XXdm5m5vCUFTvkJye2JHwcOUq
	w086ZUzV0G6CB0UQJSCSen0qPc7vk7v6DH51CG3MMnSpj6GxfpfVXRkZy5W8EqRO
	xo9KU3iK+w3TUSdWlGWJ6Iv5CPiB3gEkXwws6g+0UTXl3N9VAB3LUXJd+fQS1y+Q
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xk2w77qx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Nov 2024 16:33:55 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AK9t35E011994;
	Wed, 20 Nov 2024 16:33:54 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42y7xjpwar-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 Nov 2024 16:33:54 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AKGXnxE65012116
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Nov 2024 16:33:49 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 359762004B;
	Wed, 20 Nov 2024 16:33:49 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA75A20043;
	Wed, 20 Nov 2024 16:33:48 +0000 (GMT)
Received: from [9.171.95.47] (unknown [9.171.95.47])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 Nov 2024 16:33:48 +0000 (GMT)
Message-ID: <1ae6d8ef-fde6-4673-9727-4117a08dfe46@linux.ibm.com>
Date: Wed, 20 Nov 2024 17:33:48 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: pv: Add test for large host
 pages backing
To: Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc: nrb@linux.ibm.com, borntraeger@de.ibm.com, thuth@redhat.com,
        david@redhat.com, schlameuss@linux.ibm.com, linux-s390@vger.kernel.org
References: <20241111121529.30153-1-imbrenda@linux.ibm.com>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20241111121529.30153-1-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 1SANL0QIWEVeyNdrETztM5PPW1e8s7CI
X-Proofpoint-GUID: 1SANL0QIWEVeyNdrETztM5PPW1e8s7CI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 phishscore=0 clxscore=1015 suspectscore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411200112

On 11/11/24 1:15 PM, Claudio Imbrenda wrote:
> Add a new test to check that the host can use 1M large pages to back
> protected guests when the corresponding feature is present.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/Makefile               |   2 +
>   lib/s390x/asm/arch_def.h     |   1 +
>   lib/s390x/asm/uv.h           |  18 ++
>   s390x/pv-edat1.c             | 463 +++++++++++++++++++++++++++++++++++
>   s390x/snippets/c/pv-memhog.c |  59 +++++
>   5 files changed, 543 insertions(+)
>   create mode 100644 s390x/pv-edat1.c
>   create mode 100644 s390x/snippets/c/pv-memhog.c
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 23342bd6..c5c6f92c 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -48,6 +48,7 @@ tests += $(TEST_DIR)/sie-dat.elf
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   pv-tests += $(TEST_DIR)/pv-icptcode.elf
>   pv-tests += $(TEST_DIR)/pv-ipl.elf
> +pv-tests += $(TEST_DIR)/pv-edat1.elf
>   
>   ifneq ($(HOST_KEY_DOCUMENT),)
>   ifneq ($(GEN_SE_HEADER),)
> @@ -137,6 +138,7 @@ $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/icpt-loop.gbin
>   $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/loop.gbin
>   $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-vir-timing.gbin
>   $(TEST_DIR)/pv-ipl.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-308.gbin
> +$(TEST_DIR)/pv-edat1.elf: pv-snippets += $(SNIPPET_DIR)/c/pv-memhog.gbin
>   
>   ifneq ($(GEN_SE_HEADER),)
>   snippets += $(pv-snippets)
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 745a3387..481ede8f 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -249,6 +249,7 @@ extern struct lowcore lowcore;
>   #define PGM_INT_CODE_REGION_FIRST_TRANS		0x39
>   #define PGM_INT_CODE_REGION_SECOND_TRANS	0x3a
>   #define PGM_INT_CODE_REGION_THIRD_TRANS		0x3b
> +#define PGM_INT_CODE_SECURE_PAGE_SIZE		0x3c
>   #define PGM_INT_CODE_SECURE_STOR_ACCESS		0x3d
>   #define PGM_INT_CODE_NON_SECURE_STOR_ACCESS	0x3e
>   #define PGM_INT_CODE_SECURE_STOR_VIOLATION	0x3f
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 611dcd3f..7527be48 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -35,6 +35,7 @@
>   #define UVC_CMD_CONV_TO_SEC_STOR	0x0200
>   #define UVC_CMD_CONV_FROM_SEC_STOR	0x0201
>   #define UVC_CMD_DESTR_SEC_STOR		0x0202
> +#define UVC_CMD_VERIFY_LARGE_FRAME	0x0203
>   #define UVC_CMD_SET_SEC_CONF_PARAMS	0x0300
>   #define UVC_CMD_UNPACK_IMG		0x0301
>   #define UVC_CMD_VERIFY_IMG		0x0302
> @@ -74,6 +75,11 @@ enum uv_cmds_inst {
>   	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
>   	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
>   	BIT_UVC_CMD_ATTESTATION = 28,
> +	BIT_UVC_CMD_VERIFY_LARGE_FRAME = 32,
> +};
> +
> +enum uv_features {
> +	BIT_UV_1M_BACKING = 6,
>   };
>   
>   struct uv_cb_header {
> @@ -312,6 +318,18 @@ static inline int uv_import(uint64_t handle, unsigned long gaddr)
>   	return uv_call(0, (uint64_t)&uvcb);
>   }
>   
> +static inline int uv_merge(uint64_t handle, unsigned long gaddr)
> +{
> +	struct uv_cb_cts uvcb = {
> +		.header.cmd = UVC_CMD_VERIFY_LARGE_FRAME,
> +		.header.len = sizeof(uvcb),
> +		.guest_handle = handle,
> +		.gaddr = gaddr,
> +	};
> +
> +	return uv_call(0, (uint64_t)&uvcb);
> +}

I don't understand why you added this to the lib if you're not using it 
even once since you have your own function that returns more data.

Are you expecting other tests to regularly need this UVC?
The attestation test for instance added the constants but no function 
since the call is basically only used for one test.




