Return-Path: <kvm+bounces-3330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8ABB5803233
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 13:11:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4C975280F39
	for <lists+kvm@lfdr.de>; Mon,  4 Dec 2023 12:11:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 391BF23772;
	Mon,  4 Dec 2023 12:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eKX8zC9f"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EFFE5;
	Mon,  4 Dec 2023 04:10:54 -0800 (PST)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4BrJMB012672;
	Mon, 4 Dec 2023 12:10:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=AsOqQXAR0gQhB26871PoX5uPp0Ak4aLDT3tNkVI0gA8=;
 b=eKX8zC9fFcvaGzMHZLW87SY3X6m9qnLxjuWXplZiyycVBaZI0Ho5oOVpLFpx4DM94RpL
 2SUOTW1SjBnD7Jl2lB85iXnHrE4DCU+72kR2hRCLZQzdQ5YFHwHmPlqXwLiLcxp/Cg8G
 ewxwSc2QX+eE9UplY62eZ+Nz2j6Cehl+Ncqf9iRECiwCP0cQX+cbOULpLg93Szp0NRNk
 oId4+Ww8jpg8KipYyvA3c2lteV/ShtLMNI4mGLOhmagt3UIdtEV9+uNK4F0dW+RJ0gf4
 yplCBc9aBWCCBwNYikZfslxdKtDSeU2Rm8DK6xqL8YLwShCZE0o8sOf1OJI3SOpCHPem 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3use9p8n4k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 12:10:52 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3B4C7s6f015706;
	Mon, 4 Dec 2023 12:10:52 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3use9p8n3e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 12:10:51 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B4AmwEh012807;
	Mon, 4 Dec 2023 12:10:50 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3urv8dmrms-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 04 Dec 2023 12:10:50 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B4CAl9c5177860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 4 Dec 2023 12:10:47 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B900220040;
	Mon,  4 Dec 2023 12:10:47 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F17F92004B;
	Mon,  4 Dec 2023 12:10:46 +0000 (GMT)
Received: from li-ce58cfcc-320b-11b2-a85c-85e19b5285e0 (unknown [9.171.42.250])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  4 Dec 2023 12:10:46 +0000 (GMT)
Date: Mon, 4 Dec 2023 13:10:45 +0100
From: Halil Pasic <pasic@linux.ibm.com>
To: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, alex.williamson@redhat.com,
        borntraeger@linux.ibm.com, kwankhede@nvidia.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, david@redhat.com,
        Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH] s390/vfio-ap: handle response code 01 on queue reset
Message-ID: <20231204131045.217586a3.pasic@linux.ibm.com>
In-Reply-To: <20231129143529.260264-1-akrowiak@linux.ibm.com>
References: <20231129143529.260264-1-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: udFSVoH8M4s5xBiha-8LsNCuMHQ464hu
X-Proofpoint-GUID: qo-3VEq_SYMOh_Hi6ddOdqDiV-VjbLZH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-04_10,2023-11-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=974 clxscore=1011 mlxscore=0 bulkscore=0 adultscore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 malwarescore=0
 priorityscore=1501 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2311060000 definitions=main-2312040092

On Wed, 29 Nov 2023 09:35:24 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> In the current implementation, response code 01 (AP queue number not valid)
> is handled as a default case along with other response codes returned from
> a queue reset operation that are not handled specifically. Barring a bug,
> response code 01 will occur only when a queue has been externally removed
> from the host's AP configuration; nn this case, the queue must
> be reset by the machine in order to avoid leaking crypto data if/when the
> queue is returned to the host's configuration.

s/if\/when/at latest before/

I would argue that some of the cleanups need to happen before even 01 is
reflected...

The code comments may also require a similar rewording. With that fixed:
Reviewed-by: Halil Pasic <pasic@linux.ibm.com>

Regards,
Halil

> The response code 01 case
> will be handled specifically by logging a WARN message followed by cleaning
> up the IRQ resources.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>

