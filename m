Return-Path: <kvm+bounces-47876-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 00DD6AC6836
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 13:14:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B593B17E92D
	for <lists+kvm@lfdr.de>; Wed, 28 May 2025 11:14:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21E8F27AC59;
	Wed, 28 May 2025 11:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VKZjC7P7"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46D82798EB;
	Wed, 28 May 2025 11:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748430836; cv=none; b=e2Ii3hBei75OjInuFIfKRuoQljLOw5GWHqxGyYp9hPQZou0fTwtzDHoPWPTyBaJaVP+tlOpmddYfB6ubYXbpyrvf8SIompp890ry49JldZEBt0CGIXAK7MIIj+W9tDgtZvbhBGUt/ExX1E4f6ID4pdgcy9rnmu5aIjVeLbbP++k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748430836; c=relaxed/simple;
	bh=q4pDeqvmknk6BUyvDqV/gDKkrIjPTaEHjTTd/qByT+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VK0IJKAkC1PqksSbT43EoaAO2mgPwPasqPUDA6t/cDKW1rOBIeWkxRdktPQmqLzRNSy9/rAAKhF7lq7bY8ZKvyXQfplBye+MIF0dU3DeAmL7ZNN+oHlQc39cmBNcYgpudSM70pkE1BoGdm1FZlxd7xyoO3V7fMbu3hTW/4E4GUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=VKZjC7P7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S8el6u003502;
	Wed, 28 May 2025 11:13:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1Lx/4C
	jKYtiNRDZNQd3z50mB61o1eTDgqgasjndZiW8=; b=VKZjC7P7Bf8C3lgDWaz7vK
	Acr1Ehg7oy3VnpnIDCJjteh7IH5YISywCAKysRcZ4DtV5KUTA9DehpfOaTartEU9
	KwpblqwaYZ+kd+Zrlwe+CDkzRtsGm6187+GGBBqKAGk5OtF6ilryHPC7lx2UzUCZ
	GqPCjiuHLdCLA7kd34YbZ4u2uwkjxAdCTSxVf4Lvso2ErblJizMSkQBPbRTSolgT
	sUG3PPO7MiqLqeTNtUEha+FEfO5n3n7niQmcIYmk3DZjC4E7z6oRPRavr5Iff+Nq
	Cvog5NlubVk+3R9/6c3boJ71ATT/pQhFTpNZtP5yTpvmkJ/QLBpSvVFYLv75mQWQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46wy690p9d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 11:13:51 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54SAsLNY028941;
	Wed, 28 May 2025 11:13:50 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 46usepy7g8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 28 May 2025 11:13:50 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54SBDkkZ55509304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 11:13:46 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7B1BD20043;
	Wed, 28 May 2025 11:13:46 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F47420040;
	Wed, 28 May 2025 11:13:46 +0000 (GMT)
Received: from [9.87.152.254] (unknown [9.87.152.254])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 28 May 2025 11:13:46 +0000 (GMT)
Message-ID: <2706494c-a033-4956-bf72-d9acf3b6d89b@linux.ibm.com>
Date: Wed, 28 May 2025 13:13:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: diag10: Fence tcg and pv
 environments
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nrb@linux.ibm.com
References: <20250528091412.19483-1-frankja@linux.ibm.com>
 <20250528091412.19483-2-frankja@linux.ibm.com>
 <20250528114102.569905dd@p-imbrenda>
Content-Language: en-US
From: Janosch Frank <frankja@linux.ibm.com>
Autocrypt: addr=frankja@linux.ibm.com; keydata=
 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
In-Reply-To: <20250528114102.569905dd@p-imbrenda>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=UP3dHDfy c=1 sm=1 tr=0 ts=6836efef cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=bWdG-pU3ksr55fOdNFsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: gF05PaDXzrlMg6k03s1beb7sV2P9D8Oo
X-Proofpoint-ORIG-GUID: gF05PaDXzrlMg6k03s1beb7sV2P9D8Oo
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDA5NyBTYWx0ZWRfX4pUc7FEW1/0G zmMhwrQK1D5D1bgzRRuxI31XVfIqqK4T+pnz7MSwSKYLcBASBHblvvCx8imvj4JGQ+2r3d+KtjK WXAXd2HibQYA14cZMUws0/lh3ueHHXDFQRqOtpsWqrfpmEzXOQ4QI9ONRjspX/jRs8YtAVOvrOD
 GMjSDA05Q3LGhYf80vLHbocpbE1mndDfrwVPXD8AeZ+hYP6OrRkKOfHVoC+THiyLA9yEukcrT1g IGXWz5jhy1cx+Kcz7R/SNy29+PsILdAWMg9o/WkXjqsyP/xfFbmLrZ9pBVHmjhCzCeCpeRltehR AiKfggWVQVrNQpTarE/6spCUGMV7cv9P5HK0m8wx1avX+FczYUoADALKCkqZ6lIdn5Q78jjbRsF
 4xrwt+LBig6qyL+WycxSBWWs+E/NDP3Zyt0w0OUT5e+ls259Wn61aEMk9r3BIYM0vml7HzaQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-28_05,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 malwarescore=0 impostorscore=0
 mlxlogscore=999 clxscore=1015 priorityscore=1501 bulkscore=0 phishscore=0
 spamscore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505160000
 definitions=main-2505280097

On 5/28/25 11:41 AM, Claudio Imbrenda wrote:
> On Wed, 28 May 2025 09:13:49 +0000
> Janosch Frank <frankja@linux.ibm.com> wrote:
> 
>> Diag10 isn't supported under either of these environments so let's
>> make sure that the test bails out accordingly.
> 
> does KVM always implement diag10?

It was introduced October of 2011 and there's no way of disabling it 
that I can see.

> 
> is there no other way to check whether diag10 is available?

The z/VM CP programming services doesn't specify a feature bit or any 
other way to check as far as I can see.

> 
> we could, for example, try to run it "correctly" and see whether we get
> a Specification exception, and then fence.

We could move the content test to the top and bail out if there's a 
spec. That would allow us to handle the addition of diag10 support for 
TCG without a test change.

But:
How likely is it that we want to implement diag10 in TCG?
My guess is that adding it to PV is even less likely.
Not running them under PV and TCG gives us back some CI time although 
it's likely minuscule.

