Return-Path: <kvm+bounces-6357-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE2382F512
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 20:12:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7C69285A65
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 19:12:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697471D521;
	Tue, 16 Jan 2024 19:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="ItfqZO4L"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE301D520;
	Tue, 16 Jan 2024 19:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705432314; cv=none; b=uwJu7fwEVYdpVn3G4zeMHYyX8gt50Ro+MxeVOLP/nvmmSCApYrKW0E+tUZrnTLgs0J4kASp2U5e/ezr1LauCPrXx4/euyQ/ALe25iaqT3Umv9lkTJNZ+3y88Ibenmr9o9Lqm4lDpmECGrtGsft9eX9PUONM/sQZq2ZZujeo6naQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705432314; c=relaxed/simple;
	bh=u1IUBFcalqyRnOi6bz+nbv3wrQMj04Gv0FNZmNzobLk=;
	h=Received:DKIM-Signature:Received:Received:Received:Received:
	 Received:Received:Received:Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-TM-AS-GCONF:X-Proofpoint-GUID:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details; b=SJXHWn5K2gx7QfM0LRVWxicZ/Y6u9Eg5SN8aGxM7z0IhKKDDOYmksa8qduwG1El9NT0xcsZenop0cJVDg6MvT22iMMcJ1qoeAigv66LW3tx3bCPfcH9CdLv2vfTD+057Q3bs+2p6fhrBYngwwUKiTtyteWPEwZvs7jJfySory9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=ItfqZO4L; arc=none smtp.client-ip=148.163.158.5
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40GJBmLc001621;
	Tue, 16 Jan 2024 19:11:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=CufhlA43xSEHBT1+yTf9o3PrWgMnByKAx9Qe06+Wuzk=;
 b=ItfqZO4L/yk9kH7CT3YmATr+bs/vvy166JS8QiBOeAMvEc2Nt475+O2CslHH424Ue8Qs
 YVRaR4kyggLT/z0WjFt9uGFfFE6dmFx9x5aDnCq9IuOieI52FlrPhk1igbQ18/gdbODc
 VwyP3Nt0EYyfWON5QdpnrmuMEpHHQR7jBghEXWum7CNC6ezIimTKs/FQNnfObO+y1qLK
 Dxc/k2occ3SyQvsWPY1Nf169HhVuQXI5iXxHV0HNYBV9j+BJGYTMqW3IMILlGhutdW+0
 gCf1T+mpy9BLy3yOFrd3A2z719iF/hnTV//9yqn82ovNGey2kHpxbMurTmPcWbraOpfY aw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnyd4rhuq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:11:49 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40GJBmSw001666;
	Tue, 16 Jan 2024 19:11:48 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnyd4rhhs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:11:48 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40GJ73Nk003722;
	Tue, 16 Jan 2024 19:07:47 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vm4usrsed-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 19:07:47 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40GJ7kUm47907284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 19:07:46 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E67758056;
	Tue, 16 Jan 2024 19:07:46 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 97A0958063;
	Tue, 16 Jan 2024 19:07:40 +0000 (GMT)
Received: from [9.61.48.5] (unknown [9.61.48.5])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 16 Jan 2024 19:07:40 +0000 (GMT)
Message-ID: <fbe8e10a-355b-4a04-86b4-0dfe959f18a7@linux.ibm.com>
Date: Tue, 16 Jan 2024 14:07:37 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/6] s390/vfio-ap: let 'on_scan_complete' callback
 filter matrix and update guest's APCB
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, gor@linux.ibm.com
References: <20240115185441.31526-1-akrowiak@linux.ibm.com>
 <20240115185441.31526-4-akrowiak@linux.ibm.com>
 <ZaY/fGxUMx2z4OQH@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
 <4eb35fab-eb85-487d-90cd-c4b10b8410ec@linux.ibm.com>
 <ZaamkyuOET+1rOSm@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <ZaamkyuOET+1rOSm@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wRuFnXYXC7qAa3dH0BPNzhB46OXj9BER
X-Proofpoint-ORIG-GUID: cV9CcM1z1tBiELyLaed6OLH7U24yz32J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_11,2024-01-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxscore=0 suspectscore=0 clxscore=1015 malwarescore=0
 bulkscore=0 phishscore=0 impostorscore=0 adultscore=0 spamscore=0
 mlxlogscore=631 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401160152


On 1/16/24 10:53 AM, Alexander Gordeev wrote:
> On Tue, Jan 16, 2024 at 09:57:25AM -0500, Tony Krowiak wrote:
>> This patch is more of an enhancement as opposed to a bug, so no Fixes.
> The preceding and rest of this series CCs stable@vger.kernel.org and
> would not apply without this patch. So I guess backporting the whole
> series would be difficult.
>
> Whether propagating the prevous patches' Fixes/stable makes any sense?


Let's put it this way; it doesn't not make sense to make this patch 
Fixes/stable. To make life easier to apply the whole series, go ahead 
and add the Fixes/stable tags.


>
> Thanks!

