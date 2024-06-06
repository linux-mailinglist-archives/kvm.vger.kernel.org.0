Return-Path: <kvm+bounces-18994-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DFA48FDE52
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 07:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0B4ECB24135
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 05:48:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3D5D3FB87;
	Thu,  6 Jun 2024 05:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QtJGZlhg"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442A63BB59;
	Thu,  6 Jun 2024 05:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717652921; cv=none; b=OQZHTwoWUH/xH1FhoT6OKfZCcU8SUkRqZpZhlGFQulAfYYW6dOgRKfLGNnOYtXVP3U+u0QFeAWlmu7t7W/ZZG5vRWoL0OBaTTxdydxwVtP+xqC8qnxpO1x9ypvRxDwucw/5USylt93ZK4VeqvJAjei0Er/xEsIGWaVJMhbxG5PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717652921; c=relaxed/simple;
	bh=S9BRO1CiBzd0Cxt3mGbAHDhzFMKInH76sn7ppWFxmPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hZNVBsFwyDFY2R0C/o9eJi4MmfNwxhbQMiBwSEqM80I8pTq9+ht1SgRVzOEvges7/5D9qT4oj0PGNM5cjdy+yLR+SPDnwje0FZujNva80NYVfXVo7mB7ZzcejZoI4u2OjyKHDZ52MFwGjWJeGVg1+9P/ALsxNkgNCq+utL0UaQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QtJGZlhg; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4564fQ1l031562;
	Thu, 6 Jun 2024 05:48:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc : content-type : date
 : from : in-reply-to : message-id : mime-version : references : subject :
 to; s=pp1; bh=F1QxdnanM0DI+xMmZuQK1XU1kD0sRkv46FM+ALv8/RY=;
 b=QtJGZlhgqgx4YR8FKPwgMLc7QHJXCg1ncKiGb8ewrAUZYkfnr6a4dxPLnWAg13NWNePA
 vGZudAhNawb/e7bGe0QaJ/Pldlz+cuaBQ4Nr86ua8HjDUu1Kxx4By4nAV4JJ4+4Vj4AN
 tNXmeQDcTecG7/V5UjT0gVg+ypwNw1npXaZW8rtiIYTD0rgCPLqmKWybQEdrMixGqrNH
 Gv/bgOpJvacHCgUAfcu24rFbOSZ4Gm/3v5PNswzqqp7HTUa0fnpc0winUYwuXwJ0Z+Mn
 iOeM9Fw1zdPWbAOhZiMxJio+X2IevmzNgnr7ShIRk78MnLVf9qKTobWdKDA4ALwx8M6u 0w== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yk4n18bee-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Jun 2024 05:48:24 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4565mNsq004930;
	Thu, 6 Jun 2024 05:48:23 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yk4n18be9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Jun 2024 05:48:23 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 4564gXQW008458;
	Thu, 6 Jun 2024 05:48:22 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3ygec10xc1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 06 Jun 2024 05:48:22 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4565mIDC25559620
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 6 Jun 2024 05:48:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 75F6F20956;
	Thu,  6 Jun 2024 05:46:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 365242093B;
	Thu,  6 Jun 2024 05:46:12 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.43.32.207])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  6 Jun 2024 05:46:11 +0000 (GMT)
Date: Thu, 6 Jun 2024 11:16:08 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, corbet@lwn.net
Cc: linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Fix doorbell emulation for v2 API on PPC
Message-ID: <yzixdicgdqcten6eglcc4zlhn3sbnqrax3ymzzqvdmxvdh63zx@xymyajel3aoh>
References: <20240605113913.83715-1-gautam@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605113913.83715-1-gautam@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: EblB2tKXDq9detrDQrwOMaMKSlbJs6rb
X-Proofpoint-GUID: -G_Cdwm-ls8YhJt_YOO4Dh9rKtQGZgs8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-06_01,2024-06-06_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 mlxlogscore=583 mlxscore=0 malwarescore=0 phishscore=0 impostorscore=0
 spamscore=0 adultscore=0 lowpriorityscore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406060040

On Wed, Jun 05, 2024 at 05:09:08PM GMT, Gautam Menghani wrote:
> Doorbell emulation for KVM on PAPR guests is broken as support for DPDES
> was not added in initial patch series [1].
> Add DPDES support and doorbell handling support for V2 API. 
> 
> [1] lore.kernel.org/linuxppc-dev/20230914030600.16993-1-jniethe5@gmail.com
> 
> Changes in v2:
> 1. Split DPDES support into its own patch
> 
> Gautam Menghani (2):
>   arch/powerpc/kvm: Add DPDES support in helper library for Guest state
>     buffer
>   arch/powerpc/kvm: Fix doorbell emulation for v2 API
> 
>  Documentation/arch/powerpc/kvm-nested.rst     | 4 +++-
>  arch/powerpc/include/asm/guest-state-buffer.h | 3 ++-
>  arch/powerpc/include/asm/kvm_book3s.h         | 1 +
>  arch/powerpc/kvm/book3s_hv.c                  | 5 +++++
>  arch/powerpc/kvm/book3s_hv_nestedv2.c         | 7 +++++++
>  arch/powerpc/kvm/test-guest-state-buffer.c    | 2 +-
>  6 files changed, 19 insertions(+), 3 deletions(-)
> 
> -- 
> 2.45.1
> 


Hi Michael,

This patch series is to be backported for all kernels >= 6.7. So the tag
should be 
Cc: stable@vger.kernel.org # v6.7+

and not
Cc: stable@vger.kernel.org # v6.7

Should I send a new version of this series or can you please make this 
change when pulling in your tree?

Thanks,
Gautam

