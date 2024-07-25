Return-Path: <kvm+bounces-22249-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 32E9693C495
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 16:41:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BBFF8B23B72
	for <lists+kvm@lfdr.de>; Thu, 25 Jul 2024 14:41:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C99B19D89F;
	Thu, 25 Jul 2024 14:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="f6z0jud+"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A5219D06D;
	Thu, 25 Jul 2024 14:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918456; cv=none; b=Ffj7/JJgExpp7m+8SCAAaSGqxDWsHCpG4HVaCQsMreSJC3ir8u98ynn9/6tO/lv+KyUtF2uWT4sQqTj4ikSmpaBPRZh6sxEJvqo0VbMKzFhcB+SDCQWwReDSakFiOelzHDi2q58O6uRGditRqeFT000bD38eQOQqJrdNzs6u5+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918456; c=relaxed/simple;
	bh=Du5LvK+FxnT1KXGNanTFtPTO69mts5ESD5G3fKS/rs8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kfdx7IOm4qp7HV5xa9aZF+umUp98ad2r/E4mwB25ez2K0JjpyIQRssKtNQ2IASYmpN38TIqbf14ptNSKbANfx2nnZe4WSz4bOQM8cuZ93eBM5cw7DHsgUbYfg20PFKxWcoSjDv87SHEhYxOizC0h7KE1SJYgwuglhwuGJ8cGUi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=f6z0jud+; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46PCujgQ026581;
	Thu, 25 Jul 2024 14:40:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date
	:from:to:cc:subject:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=pp1; bh=
	vlUbg4yMj4pX14SUZjdwsmAAv1lrwPAdpxRwNqLyrfQ=; b=f6z0jud+MVwqc95F
	wWDZBnicF9mJN0QxoFPzRoYA5oEJC346vglYcDtCSbNilfUO1DcWE7SYcS+P2A7f
	Mlbw7ZJwrcUt5+HlV/ohDa5SnHkzjBiIvR4oKxHDz/yQO5STQl9guXXDBsCk6ejo
	5X2RJASQ4qXeGET+u1SKG1IH11CCQcszVTyFsaOsInN3u89B+X0E82pG3Y3z6/ej
	IpT6bgFei2MbYFKCOzEA2fGvV2PKF7O3zXiXEz/P2P7DhKlXWoHTn3XE71BcH05g
	WGg6RoTZ4FCqqE7zkNjrOULvzProv+kTbacXlCVS2qAKNHkDeuFtY+ESKvU8RZSN
	rRQWrA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kmj3rmn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:40:53 +0000 (GMT)
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 46PEerYk013509;
	Thu, 25 Jul 2024 14:40:53 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 40kmj3rmn3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:40:53 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 46PDP5Lu007136;
	Thu, 25 Jul 2024 14:40:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 40gx72x81a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 25 Jul 2024 14:40:52 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 46PEekAn24249064
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jul 2024 14:40:48 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C24172004B;
	Thu, 25 Jul 2024 14:40:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C17520040;
	Thu, 25 Jul 2024 14:40:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.15.236])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 25 Jul 2024 14:40:46 +0000 (GMT)
Date: Thu, 25 Jul 2024 16:34:55 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, nrb@linux.ibm.com,
        npiggin@gmail.com, nsg@linux.ibm.com, mhartmay@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 2/4] s390x/Makefile: Add more comments
Message-ID: <20240725163455.3a978545@p-imbrenda>
In-Reply-To: <20240718105104.34154-3-frankja@linux.ibm.com>
References: <20240718105104.34154-1-frankja@linux.ibm.com>
	<20240718105104.34154-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ho3FPNltXRt_CAxRgSIvYJrKxXWYY5wu
X-Proofpoint-GUID: osaXNtXap_VFttyNnv3xL0kyRZKj9bFu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-25_13,2024-07-25_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 phishscore=0
 adultscore=0 mlxscore=0 clxscore=1015 priorityscore=1501 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2407110000 definitions=main-2407250099

On Thu, 18 Jul 2024 10:50:17 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> More comments in Makefiles can only make them more approachable.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/Makefile | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 2933b452..457b8455 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -50,12 +50,15 @@ pv-tests += $(TEST_DIR)/pv-icptcode.elf
>  pv-tests += $(TEST_DIR)/pv-ipl.elf
>  pv-tests += $(TEST_DIR)/pv-edat1.elf
>  
> +# Add PV host tests if we're able to generate them
> +# The host key document and a tool to generate SE headers are the prerequisite
>  ifneq ($(HOST_KEY_DOCUMENT),)
>  ifneq ($(GEN_SE_HEADER),)
>  tests += $(pv-tests)
>  endif
>  endif
>  
> +# Add binary flat images for use in non-KVM hypervisors
>  tests_binary = $(patsubst %.elf,%.bin,$(tests))
>  ifneq ($(HOST_KEY_DOCUMENT),)
>  tests_pv_binary = $(patsubst %.bin,%.pv.bin,$(tests_binary))
> @@ -142,6 +145,7 @@ $(TEST_DIR)/pv-icptcode.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-icpt-vir-timin
>  $(TEST_DIR)/pv-ipl.elf: pv-snippets += $(SNIPPET_DIR)/asm/pv-diag-308.gbin
>  $(TEST_DIR)/pv-edat1.elf: pv-snippets += $(SNIPPET_DIR)/c/pv-memhog.gbin
>  
> +# Add PV tests and snippets if GEN_SE_HEADER is set
>  ifneq ($(GEN_SE_HEADER),)
>  snippets += $(pv-snippets)
>  tests += $(pv-tests)
> @@ -150,6 +154,7 @@ else
>  snippet-hdr-obj =
>  endif
>  
> +# Generate loader script
>  lds-autodepend-flags = -MMD -MF $(dir $*).$(notdir $*).d -MT $@
>  %.lds: %.lds.S $(asm-offsets)
>  	$(CPP) $(lds-autodepend-flags) $(CPPFLAGS) -P -C -o $@ $<


