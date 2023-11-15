Return-Path: <kvm+bounces-1829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3565B7EC552
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 15:30:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E438F280E79
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 14:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 909972E62E;
	Wed, 15 Nov 2023 14:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G8eCvNFF"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD3D2D042
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 14:30:01 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D5E127;
	Wed, 15 Nov 2023 06:29:58 -0800 (PST)
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AFEQi3O029077;
	Wed, 15 Nov 2023 14:29:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=US9zv12lGioUA6y3gUFsuEhdS9xvFgifGW5KNI8SMos=;
 b=G8eCvNFFmNRZufcYveqq8hXnYavhKfnyoXY55j8SOwtcQHTnj4JyaY6q1YESgIcvM1u1
 q4X+/9IQQPH5td/BPafiwt8r/0Cfk5XvHVLhvadwbSQQTkd5fwQqmlRJgl6ndmKVwGbB
 LRz/TvO9iOWCGH5qgxi+sN3xdb1YeuDLWTYxUf2f2aqCZtUWtwp1G6WgJc+YOT5mnrwW
 sjsdoNpSL+9v7jsa20RsW2XxzZkVRzfuRY5S+l2Vk4sj3lkElwNtqAK1jtyfdSHTDruA
 iWrRFLMWaVy14+g5l/2hHKey+B29KiREM47BL/H1/KAg88QciUFhXM5src78Ln8+PWL8 +g== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ucyrk02hb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 14:29:57 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AFERdF0031403;
	Wed, 15 Nov 2023 14:29:57 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ucyrk02gr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 14:29:56 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AFDn6rP031622;
	Wed, 15 Nov 2023 14:29:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3uapn1q800-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 14:29:56 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AFETr0f3670638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Nov 2023 14:29:53 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5910B20040;
	Wed, 15 Nov 2023 14:29:53 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 27A0B2004B;
	Wed, 15 Nov 2023 14:29:53 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.155.204.135])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 15 Nov 2023 14:29:53 +0000 (GMT)
Date: Wed, 15 Nov 2023 15:29:51 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, pasic@linux.ibm.com,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com
Subject: Re: [PATCH v3 0/3] s390/vfio-ap: a couple of corrections to the IRQ
 enablement function
Message-ID: <ZVTV37wqwu8cDmK7@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20231109164427.460493-1-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231109164427.460493-1-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: kC2EzW4Z3rmaEjNTgnHdfJe61LQiG1Bv
X-Proofpoint-ORIG-GUID: jNrMZyKUpeGzijisLF2RKK8DdBJofZSk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-15_13,2023-11-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 phishscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=648 malwarescore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311150111

On Thu, Nov 09, 2023 at 11:44:19AM -0500, Tony Krowiak wrote:
> This series corrects two issues related to enablement of interrupts in 
> response to interception of the PQAP(AQIC) command:
...

Hi Tony!

Via which tree this series is to be pulled?

Thanks!

