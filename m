Return-Path: <kvm+bounces-47712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E4E38AC3EFF
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 13:59:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3CDE16D617
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:59:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C5461FC0ED;
	Mon, 26 May 2025 11:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ikAI/jXo"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F891917F4;
	Mon, 26 May 2025 11:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748260783; cv=none; b=kevbb0M3rBbFwkuGD05rm/ZNzxbU4M0cwVkLw18XZ0tXvfHJl43Kpvv7lZdo9DMXfqVYN0G6rZM07OVbG5aa1VxOGLcT2lKsIStv+YIvR/1vGXhn0JpxvG3p9VhMAxxURK2dvNWhEuGQ8L9zyDhOZpPqHf3a8bU4cYM0xM8D1kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748260783; c=relaxed/simple;
	bh=MnHpRjPvW3aq1b/uS80zhdjWa9KR/tq+IPd/wUVedkE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GGsE/luxuYL2zQWiaUUvjJCwbbzZrCmFqSQBh1LjvrVrmCiopm0LmE1RUyxraJ2uHl4SGsAfpGfSQEYzDstEnbRYd1SVQnmHCVqXhksizchL9hzopWYSi7xLqVgX7UEuhOIF1l0k0GXYJfuq7syYa/zJS6Oi44Oncd7i0TgFwrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ikAI/jXo; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54Q94jqD003410;
	Mon, 26 May 2025 11:59:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=qEcsi4sugToy0puC4SQ6ejY5Nd4Qv8
	pEwggNDelhiwE=; b=ikAI/jXoBAXdrLhqfWEengQNog0rmVjRbsGUYtqo7gSyTh
	N6aMMiQqh6QzmYhAsKTyT/z+EJ+4T4egr2tdq5I7gCinwmk8zOSpNMLOGUVmBGst
	K3sxuPUoI+J7YgstD0YiaDB6UAQWGnx8qSH2li9kSuOXi6Fdt2xrt0q/IEA5/cNh
	EjO+/oACNA1ug7uwyX0qcfiKo820SSAYP6694P8GIcjaX1QUFoxQMYD/QY9+kthQ
	sxMl0DrxDk8OOz8lcJwrVRk5YRU24fVWaLzCsGDDNq2az4nNjRjkWtNp2F0Dkg+S
	xri9oEl0fSiYzmT/kseKTHa5sKqj3ukvdwVDPdLQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46u4hn938m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 11:59:38 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54Q7kSQZ010727;
	Mon, 26 May 2025 11:59:37 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46uru0e46n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 26 May 2025 11:59:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54QBxX2S29491904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 26 May 2025 11:59:33 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EC2520043;
	Mon, 26 May 2025 11:59:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DFEF220040;
	Mon, 26 May 2025 11:59:32 +0000 (GMT)
Received: from osiris (unknown [9.111.60.222])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 26 May 2025 11:59:32 +0000 (GMT)
Date: Mon, 26 May 2025 13:59:31 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@de.ibm.com, seiden@linux.ibm.com, nsg@linux.ibm.com,
        nrb@linux.ibm.com, david@redhat.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gor@linux.ibm.com, schlameuss@linux.ibm.com
Subject: Re: [PATCH v2 4/5] KVM: s390: refactor and split some gmap helpers
Message-ID: <20250526115931.13937Ce7-hca@linux.ibm.com>
References: <20250520182639.80013-1-imbrenda@linux.ibm.com>
 <20250520182639.80013-5-imbrenda@linux.ibm.com>
 <5e058fd1-ccee-43c3-92eb-ad72d2dbc1f3@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e058fd1-ccee-43c3-92eb-ad72d2dbc1f3@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=HvB2G1TS c=1 sm=1 tr=0 ts=683457aa cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=dt9VzEwgFbYA:10 a=M7XJmygFYX4lr_Cfcu8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 1pBigA7jbHTWY1yjCHMM0voVyFDbOolU
X-Proofpoint-ORIG-GUID: 1pBigA7jbHTWY1yjCHMM0voVyFDbOolU
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI2MDA5OCBTYWx0ZWRfX/3m1et90QLGw t/3b1/zXdsMNMmT0GOYTl/yn8WRsG0OBD9oRmDL9oe8Nf/ODe4sfpQ531OL1Ayfgt3ev3CpK/cN 34366jWsRR9yQF75ixyX6s0+JAJvv24I1lW/+3mWwBqg7JjrfpOA3b1M64MPYj6varTn1ETgtEP
 /ZFNrBBP7H20qrp7B9FQMqOuP6yGuym82vu2O/kwsrtIMU9yhehuLu3VE+8ebh200H76aw3dgJn IBZx7/jEE7UpbaFxwcH2ZM3ISadA63t8FR9KYUD9zJ0NripIxEcGDq277bUTWUXk3uMDJQ1WVwm mX69mhPP48LD4G8tCIg84xvshWd+LLwG7dq8Z1RvF15u/nhf/TjKjU+Cs46EnJ1WCadeagrMy16
 73NeUrkQna5arvegPGJH7TYHZsioeNH7IO/h3WThNcNkqJnBL8iY49y49JVi+7XTmj+UeaQf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-26_06,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 phishscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=730 impostorscore=0 spamscore=0
 mlxscore=0 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505260098

On Mon, May 26, 2025 at 01:17:35PM +0200, Janosch Frank wrote:
> On 5/20/25 8:26 PM, Claudio Imbrenda wrote:
> > +
> > +obj-$(subst m,y,$(CONFIG_KVM))	+= gmap_helpers.o
> 
> So gmap.o depends on PGSTE but gmap_helpers.o depends on KVM.
> Yes, PGSTE is Y if KVM is set, but this looks really strange.
> 
> @Heiko:
> Can we move away from CONFIG_PGSTE and start using CONFIG_KVM instead?
> Well, maybe this goes away with Claudio's rework anyway.

Sure, I'd appreciate if we can get rid of config options.

