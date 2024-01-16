Return-Path: <kvm+bounces-6352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A3B482F3B0
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 19:09:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 39C2D28654B
	for <lists+kvm@lfdr.de>; Tue, 16 Jan 2024 18:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5BFB21CD2A;
	Tue, 16 Jan 2024 18:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ve8Faakb"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA32F6ABA;
	Tue, 16 Jan 2024 18:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705428527; cv=none; b=SmNLEq0GY7bzhp92E+sIMQwHflG5zVfHKa65A65rtmYdjymCf5f0XV0mH36Q4j3wPxeDTpb1rtnX3fBcZDfY6i0urVC7biTSi0wk0yaMhZ2mWTcdZ8kQyctN/NxJ/qAhWPY7/Eg4jzLdUZvXpiQfXuUsGcQNz65n7yK9F4CtA3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705428527; c=relaxed/simple;
	bh=CGsnDROhCodxiCvYY3JgqSrViuyF9ZSQMhYlWQDj+aA=;
	h=Received:DKIM-Signature:Received:Received:Received:Received:
	 Received:Received:Received:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-TM-AS-GCONF:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-GUID:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details; b=u59nnEeHSGdssjaGoRXpvNs9Q/gUMe49AjVhlgyao06LayAa/WzZB95yC2gIL9Y9VoWS7jroIwhIUqLpYpQUNv8mf1nu7JWWXGJX11h5oBkvuB0eR1OenmqrQe0j6SZdH2Y2w0FCbVd6hKIeioV8k67x2s3ks9rTNNQsjZNttIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ve8Faakb; arc=none smtp.client-ip=148.163.156.1
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40GI79xW013088;
	Tue, 16 Jan 2024 18:08:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=VMRRoZGEbNDKMzcsIuD608LUrCeDX/CHVCbe+ZNWqug=;
 b=Ve8FaakbyzKYUs1fwZqy6sK8N2oaMzasCMvWb3IoNbY+vWWjmvXIPF+L/MaRnVL47vCY
 27Jige9DiFs99GqKmHrc2WSZF3pxvwJyrlWfesNHPN9ajoF6Hm4jv/LoNBp5Jl+trsZk
 yglL1b8wpGLYG7FwQi4xVXhlRnzKxHzexdu5pVW/scLhdnrUMo3g/NcV64ZTXXs6P6qj
 48yKPQZ2qxM3ZC2JNISKkiI3dglznLQSdZc7UaRHTuLBNguXCV8Cq/IsDF59mklX/vW1
 04x89KAzXbILEC4bkLKOG1wmBB9weeqfOroflNMUOznrPt8Gycx3ErT10TKcqan5Mcnf 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnxswr58v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 18:08:41 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40GI7NTO014282;
	Tue, 16 Jan 2024 18:08:27 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vnxswr431-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 18:08:26 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40GGSV6H019884;
	Tue, 16 Jan 2024 18:08:11 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vm72jyw89-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 16 Jan 2024 18:08:11 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40GI86sD18875094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jan 2024 18:08:06 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6BF1220043;
	Tue, 16 Jan 2024 18:08:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 53E5720040;
	Tue, 16 Jan 2024 18:08:05 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.88.12])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 16 Jan 2024 18:08:05 +0000 (GMT)
Date: Tue, 16 Jan 2024 19:08:03 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Tony Krowiak <akrowiak@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, borntraeger@de.ibm.com,
        pasic@linux.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, gor@linux.ibm.com, stable@vger.kernel.org
Subject: Re: [PATCH v4 4/6] s390/vfio-ap: reset queues filtered from the
 guest's AP config
Message-ID: <ZabGAx5BpIiYW+b3@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20240115185441.31526-1-akrowiak@linux.ibm.com>
 <20240115185441.31526-5-akrowiak@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240115185441.31526-5-akrowiak@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qr-HNzAfCi4ZJhU7UfWPkVpaO4WRdxRE
X-Proofpoint-GUID: KpFaRAXl_1zNmYew_c9e92rP3dK_QZU6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-16_10,2024-01-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 clxscore=1011 spamscore=0 phishscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 mlxlogscore=875
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401160143

On Mon, Jan 15, 2024 at 01:54:34PM -0500, Tony Krowiak wrote:
> From: Tony Krowiak <akrowiak@linux.ibm.com>
...
> diff --git a/drivers/s390/crypto/vfio_ap_private.h b/drivers/s390/crypto/vfio_ap_private.h
> index 88aff8b81f2f..20eac8b0f0b9 100644
> --- a/drivers/s390/crypto/vfio_ap_private.h
> +++ b/drivers/s390/crypto/vfio_ap_private.h
> @@ -83,10 +83,10 @@ struct ap_matrix {
>  };
>  
>  /**
> - * struct ap_queue_table - a table of queue objects.
> - *
> - * @queues: a hashtable of queues (struct vfio_ap_queue).
> - */
> +  * struct ap_queue_table - a table of queue objects.
> +  *
> +  * @queues: a hashtable of queues (struct vfio_ap_queue).
> +  */
>  struct ap_queue_table {
>  	DECLARE_HASHTABLE(queues, 8);
>  };

If this change is intended?

