Return-Path: <kvm+bounces-1035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C2947E469C
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 18:14:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E84F028125E
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 17:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC3B3347B7;
	Tue,  7 Nov 2023 17:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ON/eHTtv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394A4335C0
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 17:13:56 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9456E101;
	Tue,  7 Nov 2023 09:13:55 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7GlwHj024268;
	Tue, 7 Nov 2023 17:13:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=J2sXMPy7YCpN3NzlE07fo1gvQe/TBf6KbHnhTydY8RY=;
 b=ON/eHTtvzsJpMG/OljG+XVN57PfOPfXjXWhn4C1lofjVkAF0M0wUyqgmAT3wwIA/TkRg
 xJEOp7w3Pg71PtlUDFD7uL9bqj8xYVFxO1//jmMQ4RBpDs3gTDctCfZEaGhnN1DLwtYA
 f3i1d9h16O2rEe3QbNS5yT/yUxx/u9ZH9vf7bZMVGkAeu3XlSHCRhjPhfRt8u0zTNnR+
 vrihsVpOZNuGDwLcx+j5hdFsxIbDt6JBu+DPXRMsRgMrt+6gtasm2jwP1Lhq4o98H6NX
 qLt53K4fv05EFB2Mv7C6FZUJKtcd/Q3VOTLsArianObscD5UOqcrIWlO/YHQUFlrX0Q1 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7s2p94wn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 17:13:55 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A7GmNQX026870;
	Tue, 7 Nov 2023 17:13:54 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u7s2p93u6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 17:13:51 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A7FNLjd007961;
	Tue, 7 Nov 2023 17:11:15 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u60nyjbft-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Nov 2023 17:11:14 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A7HBCrT51708286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Nov 2023 17:11:12 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1B742004D;
	Tue,  7 Nov 2023 17:11:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9D66E20049;
	Tue,  7 Nov 2023 17:11:11 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  7 Nov 2023 17:11:11 +0000 (GMT)
Date: Tue, 7 Nov 2023 17:41:01 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Heiko Carstens
 <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 3/4] KVM: s390: cpu model: Use proper define for
 facility mask size
Message-ID: <20231107174101.5fa42d06@p-imbrenda>
In-Reply-To: <20231107123118.778364-4-nsg@linux.ibm.com>
References: <20231107123118.778364-1-nsg@linux.ibm.com>
	<20231107123118.778364-4-nsg@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XuF0tZ1DtLSwrYeca6fRR6FX1g_WD8ny
X-Proofpoint-GUID: NbFqpfndV0B-S7GTYK1g5jwKFfRWgJpr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-07_08,2023-11-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0
 spamscore=0 clxscore=1015 priorityscore=1501 mlxlogscore=821 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311070142

On Tue,  7 Nov 2023 13:31:17 +0100
Nina Schoetterl-Glausch <nsg@linux.ibm.com> wrote:

> Use the previously unused S390_ARCH_FAC_MASK_SIZE_U64 instead of
> S390_ARCH_FAC_LIST_SIZE_U64 for defining the fac_mask array.
> Note that both values are the same, there is no functional change.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/kvm_host.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/include/asm/kvm_host.h b/arch/s390/include/asm/kvm_host.h
> index 427f9528a7b6..46fcd2f9dff8 100644
> --- a/arch/s390/include/asm/kvm_host.h
> +++ b/arch/s390/include/asm/kvm_host.h
> @@ -811,7 +811,7 @@ struct s390_io_adapter {
>  
>  struct kvm_s390_cpu_model {
>  	/* facility mask supported by kvm & hosting machine */
> -	__u64 fac_mask[S390_ARCH_FAC_LIST_SIZE_U64];
> +	__u64 fac_mask[S390_ARCH_FAC_MASK_SIZE_U64];
>  	struct kvm_s390_vm_cpu_subfunc subfuncs;
>  	/* facility list requested by guest (in dma page) */
>  	__u64 *fac_list;


