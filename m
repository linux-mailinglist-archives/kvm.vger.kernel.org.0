Return-Path: <kvm+bounces-32732-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D3BCE9DB3B8
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 09:26:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9485F281F39
	for <lists+kvm@lfdr.de>; Thu, 28 Nov 2024 08:26:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C020914EC4B;
	Thu, 28 Nov 2024 08:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qfJT/mqS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7446314A639;
	Thu, 28 Nov 2024 08:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732782381; cv=none; b=E9yR7C7ZGuem3LiqFwyZr/n/e+RT0gc0/1VkFA4uarGgpWZ1DO772CPsr6hwuPinmepWVcbb7T76rRHdVEI9kH0UFTT/UryjCjbXIRY/Fw5+41DqmtaqfwrC4DqB4QbOfPISTRy8w3rneAR/Ot2uX4ffOlpjltXVcidoQIkGf9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732782381; c=relaxed/simple;
	bh=SEOf9b59rsVAnvw0F0BMCgnxDQ08vBA2KkFh016Tq2E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j1jnLtCvhKFazuZloe8p2y8UUGW+janSh2fx5NnyZa/3N0ca5yLPTf97i6Qid4w6q4eQptniZgCrN/WVJOND+g4ZBIMaVKo0qBHprVZu/P0+bmbBJsHH0bl5OoSsmGPY1oQEtChR7wiuaweY5mLMfz/Asbz1XyjmCLsvvlP7a5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qfJT/mqS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AS7oRRb014074;
	Thu, 28 Nov 2024 08:25:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=/Bh0GF
	51mC3o/RxYgNmHcCehmfBpXZNARIu36UpCSGk=; b=qfJT/mqSqclkYS88OL1Z9u
	OJfo4rI/sKiXoNlnPvAhWRx2co9rtgllLGb/dgYZlAMmeB3k85bbj345AmRSgOuG
	Jezp8CFT/Ih7OWAGWv1Fc8Iy/z0pWNBsCVFWfYaz/Bn/MEY/mOYgFEBnw2EwYtpQ
	IykaDWgV66XQVfdWszKxlrde+ThTHf0ISDftG9u+Vt4uSfW7tfT+Z1ZlIpAZTIyZ
	nES0OtBNwkOiGexGjlKpgwFsJpZ5f6RRgaOd2yBjMiDDs+QX6ex+/tbgIHIDidst
	9MDXsbcvTDafoRJyBc4XjFr6v6JfFAxox6kzbznGs6NNQgg+BZPduRUrmOA5GZug
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4366yybgx4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Nov 2024 08:25:53 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4AS8LGMs028952;
	Thu, 28 Nov 2024 08:25:53 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4366yybgwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Nov 2024 08:25:53 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AS8MrcJ009800;
	Thu, 28 Nov 2024 08:25:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43672f7xsm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 28 Nov 2024 08:25:52 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AS8PmOn21233924
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 28 Nov 2024 08:25:48 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E3BA82005A;
	Thu, 28 Nov 2024 08:25:47 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 937B22004F;
	Thu, 28 Nov 2024 08:25:47 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 28 Nov 2024 08:25:47 +0000 (GMT)
Date: Thu, 28 Nov 2024 09:25:46 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Jones
 <ajones@ventanamicro.com>,
        James Houghton <jthoughton@google.com>,
        Muhammad
 Usama Anjum <usama.anjum@collabora.com>
Subject: Re: [PATCH v4 15/16] KVM: selftests: Use canonical $(ARCH) paths
 for KVM selftests directories
Message-ID: <20241128092546.7a5b3f30@p-imbrenda>
In-Reply-To: <20241128005547.4077116-16-seanjc@google.com>
References: <20241128005547.4077116-1-seanjc@google.com>
	<20241128005547.4077116-16-seanjc@google.com>
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
X-Proofpoint-GUID: Q7ii93V04uamfY0V88_h7z7HgwyWCuzA
X-Proofpoint-ORIG-GUID: HGem8ab_9QMRCJIRWqhAFghUEX4Ggu5a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 clxscore=1015 mlxscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 adultscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2411280063

On Wed, 27 Nov 2024 16:55:46 -0800
Sean Christopherson <seanjc@google.com> wrote:

> Use the kernel's canonical $(ARCH) paths instead of the raw target triple
> for KVM selftests directories.  KVM selftests are quite nearly the only
> place in the entire kernel that using the target triple for directories,
> tools/testing/selftests/drivers/s390x being the lone holdout.
> 
> Using the kernel's preferred nomenclature eliminates the minor, but
> annoying, friction of having to translate to KVM's selftests directories,
> e.g. for pattern matching, opening files, running selftests, etc.
> 
> Opportunsitically delete file comments that reference the full path of the
> file, as they are obviously prone to becoming stale, and serve no known
> purpose.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---

just one minor nit

[...]

> diff --git a/tools/testing/selftests/kvm/include/x86_64/svm_util.h b/tools/testing/selftests/kvm/include/x86/svm_util.h
> similarity index 94%
> rename from tools/testing/selftests/kvm/include/x86_64/svm_util.h
> rename to tools/testing/selftests/kvm/include/x86/svm_util.h
> index 044f0f872ba9..b74c6dcddcbd 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/svm_util.h
> +++ b/tools/testing/selftests/kvm/include/x86/svm_util.h
> @@ -1,8 +1,5 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
> - * tools/testing/selftests/kvm/include/x86_64/svm_utils.h

this line clearly has to go ^

> - * Header for nested SVM testing

but I think this one can stay? ^


regardless, for the s390 part:

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> - *
>   * Copyright (C) 2020, Red Hat, Inc.
>   */
>  

[...]

