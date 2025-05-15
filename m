Return-Path: <kvm+bounces-46683-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F6ACAB84C2
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 13:27:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EF097ADE69
	for <lists+kvm@lfdr.de>; Thu, 15 May 2025 11:25:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79F0A2989A4;
	Thu, 15 May 2025 11:26:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Fnd72aBb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CFB29898B;
	Thu, 15 May 2025 11:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747308414; cv=none; b=r/Y3tRaxsvk9xisSFtwdUsATYFnzxNbFQYTP6kANml4R4541T0o53GnwVIj67eSyRVcbD2nQOaeMlAwlXRJcvcNNbeXTfqSsdwswHX4jyK/vIqaEXDy/zsEq2Hk9TREJTU4aPEgIc9gmmKpciLesT/RJoad0IVPREHq0bw/Duk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747308414; c=relaxed/simple;
	bh=URCNf7LBa8+HC7hTnz5rpq5Zz8ITvmLPV1WxaN7jpE8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PkKjZZMqIfWFps/AyZ+QFewGMXXAxjqIpsAmagalPhf6Y5nY6OG5AyrMqallRjt+TVSgy+9oI2kfMoV9vIfav74zDe76TMcNAoCaOR2ujr8inhPEOcWW7h7dO9XmIBSqYQMZEWw6esY8WRR7yIAfgBMtPzW134xjCb9vY6XrzoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Fnd72aBb; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54F9Eu7U017311;
	Thu, 15 May 2025 11:26:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9T3mmm
	fS2GMMQFYQZNX7KXkCn+Txfdh5/JZR/gjSS3M=; b=Fnd72aBbno5yyiw+46j65I
	3eyi2WYmuhTmR8dJ3+paX5n3XOuGKjy3Mo/PbrsyaoI0e3sZ60srYbgB/ed5fTaR
	WZxdeASoIs4NxntZsfCnVedGAe2iIWjZs7qMqp0lpJIoSNo6G6bNFaY006zedYXG
	WLYQr5XuXDxZ08svR0TyEu43PEc376GkKMwCZGI1t0stbHZh7eILnPJgFvuWOurI
	MENpnEkSaghodyW2CQLlpUdY28y4DAVJQNJ2FxykCIul7i8N55aBuK2yMO9+HwuC
	ZIy5xxT66b2kCR3eHoBjWbKuwp/uw1d9F9SBDtdq40H5X8ulCm5TnFI4i3mx8M9w
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46ndfjrkuh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 11:26:50 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54FAlGcK026939;
	Thu, 15 May 2025 11:26:50 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 46mbfphvfq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 May 2025 11:26:50 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54FBQkEx50332014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 May 2025 11:26:46 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9C35520085;
	Thu, 15 May 2025 11:26:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 41B6820086;
	Thu, 15 May 2025 11:26:46 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 May 2025 11:26:46 +0000 (GMT)
Date: Thu, 15 May 2025 13:26:34 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: kvm@vger.kernel.org, Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand
 <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
 <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven
 Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH 0/3] KVM: s390: Use ESCA instead of BSCA at VM init
Message-ID: <20250515132634.5965f2df@p-imbrenda>
In-Reply-To: <20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com>
References: <20250514-rm-bsca-v1-0-6c2b065a8680@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KCexytTHxVa3j9rZ6Ip980lkHMyqTip0
X-Authority-Analysis: v=2.4 cv=ecg9f6EH c=1 sm=1 tr=0 ts=6825cf7b cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=XdaNJP3T_A1EuQW8jZgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: KCexytTHxVa3j9rZ6Ip980lkHMyqTip0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTE1MDEwOSBTYWx0ZWRfX3VHQALQnJcqv iGtE5Po8/rHTYanUcCbO3931k0gRkMnWkEvV7/Q2J0iAXPSTCZ+NnZ1nZrKn5nsAUFElzW81vho qHo4uOPL3Xq00kz1thS/pneuE3kc7QMPwyoNIHduh6YwRcM/jIpUzdK+5QjlwM7yf5T9hSPn2Sy
 Mx0oO7rbTVInEOq1tFEd2RRJJadahR8OJZbNZFAPV+57N5EACnxyWidoWGrXhPZ0H/uW/gdzel7 p8NnD0btR/iU8TUqaZw7W8zrBEtltOZL7Et632aPKu5Bxg+mh6pVmATepVVYLvZzJSV3yLzWaCR 1Unt7Yq/NaPsmm/626H0Pa1cB2YpGoAlukEv/iWwPwLyIhLNTHgfHjCCb2eWSs1pb4bOldwMNlq
 AnxzmG3eDeC3RiocFq3Q32Hgx+PM9wbBASD+2wO0GnBYmPTlSfgQwDdWlJBc9TfuB1JD2xRE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-15_05,2025-05-14_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=532
 impostorscore=0 spamscore=0 clxscore=1015 malwarescore=0 mlxscore=0
 lowpriorityscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 suspectscore=0 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505070000
 definitions=main-2505150109

On Wed, 14 May 2025 18:34:48 +0200
Christoph Schlameuss <schlameuss@linux.ibm.com> wrote:

> All modern IBM Z and Linux One machines do offer support for the
> Extended System Control Area (ESCA). The ESCA is available since the
> z114/z196 released in 2010.
> KVM needs to allocate and manage the SCA for guest VMs. Prior to this
> change the SCA was setup as Basic SCA only supporting a maximum of 64
> vCPUs when initializing the VM. With addition of the 65th vCPU the SCA
> was needed to be converted to a ESCA.
> 
> Instead we will now allocate the ESCA directly upon VM creation
> simplifying the code in multiple places as well as completely removing
> the need to convert an existing SCA.
> 
> In cases where the ESCA is not supported (z10 and earlier) the use of
> the SCA entries and with that SIGP interpretation are disabled for VMs.
> This increases the number of exits from the VM in multiprocessor
> scenarios and thus decreases performance.
> 
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
> Christoph Schlameuss (3):
>       KVM: s390: Set KVM_MAX_VCPUS to 256
>       KVM: s390: Always allocate esca_block
>       KVM: s390: Specify kvm->arch.sca as esca_block
> 
>  arch/s390/include/asm/kvm_host.h       |   7 +-
>  arch/s390/include/asm/kvm_host_types.h |   2 +
>  arch/s390/kvm/gaccess.c                |  10 +-
>  arch/s390/kvm/interrupt.c              |  74 +++++----------
>  arch/s390/kvm/kvm-s390.c               | 161 ++++++---------------------------
>  arch/s390/kvm/kvm-s390.h               |   9 +-
>  6 files changed, 57 insertions(+), 206 deletions(-)

I really like that you are removing more lines than you are adding :)

> ---
> base-commit: 82f2b0b97b36ee3fcddf0f0780a9a0825d52fec3
> change-id: 20250513-rm-bsca-ab1e8649aca7
> 
> Best regards,


