Return-Path: <kvm+bounces-49575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 61847ADA91B
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 09:16:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E48DF16F5E5
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 07:16:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CB4C1E2307;
	Mon, 16 Jun 2025 07:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qAY4VVpi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE613208;
	Mon, 16 Jun 2025 07:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750058208; cv=none; b=CKXYvY0oB8K/i5+3fRELydwvXsM2L01G6uHTOjq2OtPzi7Ealqa1n5kID+wAdhS2UrJ+7cfkLRhBMpb18Qnjk2P+znLbA2OB6q7So39hS8QBKw7UjPXA8PISK5Lj7gOzKZqjnNRN5O1WjNlky5PCxiD9WqO3SgXkqVo4zsqiz34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750058208; c=relaxed/simple;
	bh=8oS9W40Kxi3jCDLjbplhmNHApFzpmxWBjEyHqggrd0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mKrUH8VKJzYbc7rHTSK8qkSKCxa8bXD1BIKeZoHy1DNKK3RNagnca7zDpG3SshBwWEEk74HEUdPPbp3BtUY5fd0sUZ8enBcNTMFlxHW3u+5ycZFirDpDt975wp56TTlttNpOvQkzs/aPlbgSQtQIHKEcaIJyWxInHW96nAhVqFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qAY4VVpi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55FLRHHr025161;
	Mon, 16 Jun 2025 07:15:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=8oS9W40Kxi3jCDLjbplhmNHApFzpmx
	WBjEyHqggrd0A=; b=qAY4VVpinI2Rbjtg6/cTxb0ByK9Dpzpf/aO3yY9XM5UF4d
	fU78j65QpJ3TapkNS/xL3vWbPV5/pklD1FE7kjijxU/XLyukt6XZ3WfcR4gFH81+
	UFdauXXxcaqtHqvoucUPRYWnY4bL4ogy5OumG75AWe2BeYdsMVMYJOpOVg665ANi
	VWvgBCKH/JyZisb5vUa4CL8qgECUwjCm3TRR4ZUf58M9gln0exc5pR4IRrjSC6+f
	ZkrajO9adrWRsa38pwUBB5r4ztMCHddjRWJusLpI5uP3qlP55wkLVB/N8+UcqUCc
	LCE/mDDOWLEmLtUGpgpcmyaSwGoUdK3hRWsyQEfA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790r1qypc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Jun 2025 07:15:36 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 55G6uksv023490;
	Mon, 16 Jun 2025 07:15:36 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790r1qyp8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Jun 2025 07:15:36 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55G3BxpK011236;
	Mon, 16 Jun 2025 07:15:35 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 479kdt56ah-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 16 Jun 2025 07:15:35 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55G7FVZd43385168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Jun 2025 07:15:31 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB3CA2004D;
	Mon, 16 Jun 2025 07:15:30 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B03A2004E;
	Mon, 16 Jun 2025 07:15:26 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.204.206.66])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 16 Jun 2025 07:15:26 +0000 (GMT)
Date: Mon, 16 Jun 2025 12:45:22 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
        Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
        Huacai Chen <chenhuacai@kernel.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anish Ghulati <aghulati@google.com>,
        Colton Lewis <coltonlewis@google.com>, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH 6/8] KVM: PPC: Stop adding virt/kvm to the arch include
 path
Message-ID: <etqfg3dvpr4tabk3lysnvelpb5k3pyuuhhkfxsd4oyxlmgwnit@rducsforanaj>
References: <20250611001042.170501-1-seanjc@google.com>
 <20250611001042.170501-7-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611001042.170501-7-seanjc@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pA27UQdSoFi7fENYAbcClrvtInowwnUB
X-Proofpoint-ORIG-GUID: TmHFGtZ04KPLB6esid1G6CYOB7tVt6Vr
X-Authority-Analysis: v=2.4 cv=AqTu3P9P c=1 sm=1 tr=0 ts=684fc498 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=90UzZmcSQ78tuVnzBuAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE2MDA0NCBTYWx0ZWRfX7cOmaIrOSqpw SXLMPZuCWSZBCBLE3FL1xYcVW8X8KK0s74UvFuWZnCI71S5bsha1iy0u8LbyZa/+82oTUgv81jB 8/dlb4z7C/9S1qOfR7ocu1ICPZlI2cR3jyDHY3OeqfHz4UFQa3Rmzgnyh3GV1P+TxeqAcXYuNcf
 QEN1U+QFmMf+lloYVcQjizKufdVGBS01u2hgxtp3bvDWMeYFm65yaoSob0KnI8NZ2r/UggduiwU ZI3aZ9HSz+pCtgy2G1LIxS18dF8Y3fx6iFj5NS4G1C1cP4XiHgt73JfFH9LrR8JcXlRfTcEju3e eeU8dw7b1BrKJERMYaXJKC8cF2yDollkevHHuOIz2ofPC4iO7YXWdRjLohoPeN5pLWHoOr65LX/
 hSQl2MRrPAQ08Y2Uc3A15BdBi0qU/CKs2ILqAsxRoOrQErs71PyFk7tko/eh6IYJbN/lDZCI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-16_02,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011
 lowpriorityscore=0 suspectscore=0 adultscore=0 impostorscore=0
 priorityscore=1501 phishscore=0 mlxlogscore=478 mlxscore=0 spamscore=0
 bulkscore=0 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506160044

Reviewed-by: Gautam Menghani <gautam@linux.ibm.com>

