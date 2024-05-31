Return-Path: <kvm+bounces-18503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DEB98D5B18
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 09:02:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D1BBD1F273B8
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 07:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EF64811E6;
	Fri, 31 May 2024 07:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mQe5nKxT"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3AB17E9;
	Fri, 31 May 2024 07:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717138913; cv=none; b=ZplfrKDdVzYFSA6HdQx3YYRAmB7UF57PJNIRimNITBZ1cwe5+MnZb9VSvV+2AOTrxyn2BcteS0W4j6i/1n3X0yhg0uyHROHtImH74P1RPhtpPUew8KVGzXPgf8Qfn1PC/+o7Qh3d1KHsXdpNjTIQK2krDGWG1ftIsYJbPsIzNv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717138913; c=relaxed/simple;
	bh=ZmP0QtArttdJbguIhN02o6hMyhO1HzCXd/u5SVJDrp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=u2tAtiRf4pGpFE29yKPwpGtcSP1REdtal2+GFLqxF4hGZ+GoRUiAQPv66ul9oxDC947cw7eqRUm+4dnaP19ZGkbFajHNXLLdbLUhLfv0cvRYD5mjcNDeLlSIkzb3IvKT4procVaaNLtlcADIRnlfVaeTshdqLoFCFTgeckcWqhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mQe5nKxT; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44V6Urwa021365;
	Fri, 31 May 2024 07:01:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc : content-type : date
 : from : in-reply-to : message-id : mime-version : references : subject :
 to; s=pp1; bh=aaBvNxIquJs2EzYvuRrhC1j6ewLwD9KjNMpikXuKNzg=;
 b=mQe5nKxTT+CdpzPbrS0jeeIw8W86Si3gUj3MCUqv6SUYQK4TnE4x2qQhkiI5lI8s0vrC
 PxloZHBfHWVVS7KyS00P1EzjBhGwJUWXQLmocR1wdtE254o3ENnIB6awvuMnGIP4Ocem
 21l85NgYf7UgtV3VrHCbQaKW3SHVei1IPWGuam8E9DNKXsZJ53aoSGrzv+K+FCu5Pi2+
 Kmexz032cTkhctsAC7zA259bumoMkYbEqyPeyMiXfau7vVoxd9qWwtJRtf70BgjpWlxv
 WEvgSjeENx0QfOWHMNls4URTcqNKGv86WYOtc1pqXyLe7+yEIdBOcRWOTurSu+S36hlH tw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yf8sp04pk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 07:01:35 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44V71ZAo003390;
	Fri, 31 May 2024 07:01:35 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yf8sp04pg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 07:01:35 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 44V5O4nh026740;
	Fri, 31 May 2024 07:01:34 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3ydpd2xgwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 May 2024 07:01:34 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 44V71UZM21561822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 May 2024 07:01:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8575B2004E;
	Fri, 31 May 2024 07:01:30 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6AAF920043;
	Fri, 31 May 2024 07:01:28 +0000 (GMT)
Received: from li-c6426e4c-27cf-11b2-a85c-95d65bc0de0e.ibm.com (unknown [9.204.206.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 31 May 2024 07:01:28 +0000 (GMT)
Date: Fri, 31 May 2024 12:31:26 +0530
From: Gautam Menghani <gautam@linux.ibm.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: mpe@ellerman.id.au, npiggin@gmail.com, christophe.leroy@csgroup.eu,
        aneesh.kumar@kernel.org, naveen.n.rao@linux.ibm.com, corbet@lwn.net,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] arch/powerpc/kvm: Fix doorbell emulation by adding DPDES
 support
Message-ID: <35ek73rjziiolk3zja3i5qayjzvjruuro72co74nc4a6ljvhhf@5tus3qlcb522>
References: <20240522082838.121769-1-gautam@linux.ibm.com>
 <rrsuqfqugrdowhws2f7ug7pzvimzkepx3g2cp36ijx2zhzokee@eitrr6vxp75w>
 <2024053143-wanted-legible-ca3f@gregkh>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024053143-wanted-legible-ca3f@gregkh>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9BAPae-QWeiZiE9h7wdQgwkjUoJxgrhI
X-Proofpoint-ORIG-GUID: Qrx9-h68gqIaI3Q_bqAX6RVcT_WIuh1d
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-31_03,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=673 bulkscore=0 adultscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 spamscore=0 phishscore=0 clxscore=1011
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405310051

On Fri, May 31, 2024 at 08:09:13AM GMT, Greg KH wrote:
> On Fri, May 31, 2024 at 10:54:58AM +0530, Gautam Menghani wrote:
> > Hello,
> > 
> > Please review this patch and let me know if any changes are needed.
> 
> There already was review comments on it, why ignore them?

Sorry I pinged on the wrong thread, I had already addressed the stable
tag issue in a resend - https://lore.kernel.org/linuxppc-dev/20240522084949.123148-1-gautam@linux.ibm.com/

Thanks,
Gautam

