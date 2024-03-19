Return-Path: <kvm+bounces-12112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A43FB87F969
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 09:21:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5EAFE282E9C
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 08:21:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B2B54673;
	Tue, 19 Mar 2024 08:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HA0IY5vi"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D168A537FC;
	Tue, 19 Mar 2024 08:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710836489; cv=none; b=ttnP2mzwgyNE3hOGonTTDLz88eLqbjnWBZZJnnNAOZiyPtMGfdpfDqCoMqAHREP9mmCYvjMPrEOhuFfFW6rcRyQitInkEzpKuHSsbcgZROsWqcO7+Jt3UI7Wdv8M1Dtm/EnfIJaSOtrAob8Ur0XNvTAAcfbSZsW+rrKJGNzT8XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710836489; c=relaxed/simple;
	bh=e0pdBeO1iiZJZEKGf4UbBf3Uueakdasz1WepIx5UL7w=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=lct/NtK46xXJOqDmkhNE7BE4qejNyv3fbav5LGJwKGQ6Qh+zusK9eHcsoa3FV8oadzjYvbLnLfD8nvqYR+wwSxbimJWzXDV7LhNWh6hh1lt21Zr+sEWuJ0diYfzy6Bir/yAy0DByJpDd33EnTEZP9I+xjgvNBIdAppvg1zQNrgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HA0IY5vi; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 42J6lFaA018876;
	Tue, 19 Mar 2024 08:21:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=o0Up1ECIWPuqBEYQxD+roChsrUjzqz2f0FpU8KrXGUc=;
 b=HA0IY5viNP0VXX5AGrtX5anQKFbXrtSPd/3BjWvIK8v4llBEuA0ne9za5BQToJh5LZFT
 xRmDLzWVktwMrDP3WttaaqQhVuMTD456uO1Iwdu+NP/DvlFlnKnsbaCCdX1WsfgpseMT
 nsH8LiQFVWeH7qO+FV3B28km0DoslnwjmBILknTt/4JC9suiAVQyu9VdPUeir7a+wLtU
 Iv+G0ewYTLJyZ0WRuOOvyfp1OL+uzQSNzomvucjVn70wKNgVjxzb42Sr2+MEiAbJ0Kaf
 8E8E+8LSN9zZlWgRhMWV89YAiXOvbQYEFKYhyXhWfMLUDUp3pShVZSMJlG5LBVOFPPwA qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wy5ra0fcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 08:21:11 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 42J8LBhu029372;
	Tue, 19 Mar 2024 08:21:11 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wy5ra0fcs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 08:21:11 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 42J5wVfg019861;
	Tue, 19 Mar 2024 08:21:10 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wwqykdub7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Mar 2024 08:21:10 +0000
Received: from smtpav02.dal12v.mail.ibm.com (smtpav02.dal12v.mail.ibm.com [10.241.53.101])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 42J8L7Ra24576478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Mar 2024 08:21:09 GMT
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 386BA58068;
	Tue, 19 Mar 2024 08:21:07 +0000 (GMT)
Received: from smtpav02.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE79658051;
	Tue, 19 Mar 2024 08:21:06 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav02.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 19 Mar 2024 08:21:06 +0000 (GMT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 19 Mar 2024 09:21:06 +0100
From: Tobias Huschle <huschle@linux.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Luis Machado <luis.machado@arm.com>, Jason Wang <jasowang@redhat.com>,
        Abel Wu <wuyun.abel@bytedance.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        virtualization@lists.linux.dev, netdev@vger.kernel.org,
        nd <nd@arm.com>
Subject: Re: EEVDF/vhost regression (bisected to 86bfbb7ce4f6 sched/fair: Add
 lag based placement)
In-Reply-To: <20240315062839-mutt-send-email-mst@kernel.org>
References: <92916.124010808133201076@us-mta-622.us.mimecast.lan>
 <20240121134311-mutt-send-email-mst@kernel.org>
 <07974.124020102385100135@us-mta-501.us.mimecast.lan>
 <20240201030341-mutt-send-email-mst@kernel.org>
 <89460.124020106474400877@us-mta-475.us.mimecast.lan>
 <20240311130446-mutt-send-email-mst@kernel.org>
 <cf813f92-9806-4449-b099-1bb2bd492b3c@arm.com>
 <73123.124031407552500165@us-mta-156.us.mimecast.lan>
 <20240314110649-mutt-send-email-mst@kernel.org>
 <84704.124031504335801509@us-mta-515.us.mimecast.lan>
 <20240315062839-mutt-send-email-mst@kernel.org>
Message-ID: <b3fd680c675208370fc4560bb3b4d5b8@linux.ibm.com>
X-Sender: huschle@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ig_8hUMQ62rKjIW6cFJGHLt5KlvIVVhe
X-Proofpoint-ORIG-GUID: oITQulY1q7P3fcJ97zGvdqWMwMGoRiQd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-03-18_12,2024-03-18_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 clxscore=1015 spamscore=0
 adultscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=724 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2403140000 definitions=main-2403190063

On 2024-03-15 11:31, Michael S. Tsirkin wrote:
> On Fri, Mar 15, 2024 at 09:33:49AM +0100, Tobias Huschle wrote:
>> On Thu, Mar 14, 2024 at 11:09:25AM -0400, Michael S. Tsirkin wrote:
>> >
> 
> Could you remind me pls, what is the kworker doing specifically that
> vhost is relying on?

The kworker is handling the actual data moving in memory if I'm not 
mistaking.


