Return-Path: <kvm+bounces-7754-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EE33845EE6
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 18:50:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C17281C27DEB
	for <lists+kvm@lfdr.de>; Thu,  1 Feb 2024 17:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D11F7C6EA;
	Thu,  1 Feb 2024 17:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mSakt1gI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B61E865E04;
	Thu,  1 Feb 2024 17:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706809808; cv=none; b=XDTg7SLnRPCR8/nEzQAGk8njABJvWQZXpNXF5yybY48ALEHUS61fCpS8Xi+grPeXHTsgDfsdEVYoPbVfBlUcFfP3i1YnIaN9bP2chAwacyJYyXQWxOTLaBaLE52YUZQ9rvMIMDiINmE40MI4u3e07vnDTw8hEDDgNDmPiegZs3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706809808; c=relaxed/simple;
	bh=I5Llug4bljOZI+AIvV1xu5GW+6h9lHKaZ6IUi/+EuNk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ZxAsngxyJK9vUW9nNNftdYzltrRDcy4Hvx+jikAdGQa9XFEjoKH101EL2WbbIpvpDD9b8/S5OMFuyOkDeb8F0bBSC/64EoaB6h9/8B7ppvidfZSC5mKY8Kc/3dkfMpv2oxFXYT0oRwTRoAm0U11pz2v9ZMlh4M0Lkamv4gTU/XE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mSakt1gI; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411HDgs6017500;
	Thu, 1 Feb 2024 17:50:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=eT3CsuxRO37UWkDjeVwEz6uU60q56U2vcjaAs6triRo=;
 b=mSakt1gIov999BzaDMVJs7At8rUdggju7hFBSvVeeV3SKgmvXQNEaqB2Ei0l8tYnlLTA
 Ad9jyzj1r09dURVkWpJW6D/Tp+w+1GpssAv1NNdoDI0ab3BBPq8XCxgZTGwFxktJ1M0Z
 Gog3vPkEyHY2EpjQ9XEKylPjS1bLRIrdRFNqMOLu2ks/IQj/KR0/9ChU6mhYgAbh+6iF
 eNh6/LSwI/COk9162FiFZjfy6tkd+4m3MZafMkPjpWKejNwOMp+q3L3xyXLraoGC+UVW
 3xf7F9G99U+UgHQtzaSSCYJn3ByRSK2O7EZBdqkO019EDaH/bSaZytKrp4dlxd9Kh6GJ Eg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0fgrh08m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 17:50:05 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 411Hg3fK022096;
	Thu, 1 Feb 2024 17:50:05 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0fgrh087-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 17:50:04 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 411HiMn4017723;
	Thu, 1 Feb 2024 17:50:04 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwcj064nr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 17:50:04 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411Ho1Fg19399266
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 17:50:01 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F354120043;
	Thu,  1 Feb 2024 17:50:00 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 870D320040;
	Thu,  1 Feb 2024 17:50:00 +0000 (GMT)
Received: from p-imbrenda (unknown [9.179.24.180])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu,  1 Feb 2024 17:50:00 +0000 (GMT)
Date: Thu, 1 Feb 2024 18:49:58 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 0/5] s390x: Dirty cc before executing
 tested instructions
Message-ID: <20240201184958.4676917a@p-imbrenda>
In-Reply-To: <20240131074427.70871-1-frankja@linux.ibm.com>
References: <20240131074427.70871-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NAeGMm9H1dBtJfQ7XVuJ5eMk9F50JM_K
X-Proofpoint-ORIG-GUID: 3zTOJQKc5FiFGqIDUNkl65K92-oHLANl
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_04,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 bulkscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 malwarescore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0
 mlxlogscore=490 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402010138

On Wed, 31 Jan 2024 07:44:22 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> A recent s390 KVM fixpatch [1] showed us that checking the cc is not
> enough when emulation code forgets to set the cc. There might just be
> the correct cc in the PSW which would make the cc check succeed.
> 
> This series intentionally dirties the cc for sigp, uvc, some io
> instructions and sclp to make cc setting errors more apparent. I had a
> cursory look through the tested instructions and those are the most
> prominent ones with defined cc values.
> 
> Since the issue appeared in PQAP my AP test series is now dependent on
> this series.
> 
> [1] https://lore.kernel.org/kvm/20231201181657.1614645-1-farman@linux.ibm.com/

whole series:
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


> 
> v2:
> 	* Moved from spm to tmll (thanks Nina)
> 
> Janosch Frank (5):
>   lib: s390x: sigp: Dirty CC before sigp execution
>   lib: s390x: uv: Dirty CC before uvc execution
>   lib: s390x: css: Dirty CC before css instructions
>   s390x: mvpg: Dirty CC before mvpg execution
>   s390x: sclp: Dirty CC before sclp execution
> 
>  lib/s390x/asm/sigp.h |  6 +++++-
>  lib/s390x/asm/uv.h   |  4 +++-
>  lib/s390x/css.h      | 16 ++++++++++++----
>  s390x/mvpg.c         |  6 ++++--
>  s390x/sclp.c         |  5 ++++-
>  5 files changed, 28 insertions(+), 9 deletions(-)
> 


