Return-Path: <kvm+bounces-7583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D494F843EE4
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 12:56:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C09A9B219B0
	for <lists+kvm@lfdr.de>; Wed, 31 Jan 2024 11:56:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71FCD7691C;
	Wed, 31 Jan 2024 11:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Ttl/lIlk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094E669E08;
	Wed, 31 Jan 2024 11:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706702190; cv=none; b=Ng1QBXJFhkFbN6geCB7jO4ZGO9uxr/DX5uq+wtCdZl+bnxVY6tMav4LBHnMLVpMRGeeOYyeZjkBs+g/3v7LwvE3fkcj7rDftzNoRSKwLsCWLRhyXKwgFsHVHnMEZ1M0Ui4RkGL7q1OrJjzlGTfmVf65457Cr7dP3LidStzdJiy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706702190; c=relaxed/simple;
	bh=HvAWl3m+e4Gp5RD0giZkeFkHz48a4wDEu/02LY9+n8E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bv7DbB9wUTb3indzDPmhUFswNhGd+K3nba1OGf/SUpDjq7NHzHPxWnAjYcJTS/nVQwKA1YcsG9c2DRz2LvYNFZyCS36jRMiWgic5V1Djt6kld/C70Y8TvJsja8wmRIvnLfWYdETH0x7g5KDgDhK+0ZzQ4sNmMyN3/9hPjrRhQkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Ttl/lIlk; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40VBWfQr009217;
	Wed, 31 Jan 2024 11:56:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=FwAAHjb3KVZy0zuYvj+e5c6YoUq5mS9ryZulRk9CZIA=;
 b=Ttl/lIlk9bfYeaGNX+nNR2h6zvjv0uulgVO0xu1AunwXuwDwFp9bXu8Q44fajcrU6XlW
 O4WvzhpG6+jZU4dSb4iRBeeCpW5UJycokRlINIm58Nadzp2Aw0b3SClB09kkykjcZ5tc
 4s4iUg6PA4yckYe7sE74f4Hgixl7ebu1QVlYacgOInucekpzhLzWtOENaikLngVId7Vj
 6E6xUUOADWg8Sk6hdxfd0KPEdJNPauMn/u2plDIav4GPJ+nLqtSX1U2vTjqbOnuEwZIs
 omq3W4/bqd9DdcfafdgXVpu4UwYIF11eFP2gpQX0UDDk82MK2dSSQwJ7k9fNJ5GTHa2t Yw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyndw8h6k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 11:56:27 +0000
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40VBXI6u010648;
	Wed, 31 Jan 2024 11:56:26 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3vyndw8h69-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 11:56:26 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 40V9u08x010862;
	Wed, 31 Jan 2024 11:56:25 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3vweckmuu4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 31 Jan 2024 11:56:25 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 40VBuN2q40894798
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 31 Jan 2024 11:56:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0A34320043;
	Wed, 31 Jan 2024 11:56:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2AE120040;
	Wed, 31 Jan 2024 11:56:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 31 Jan 2024 11:56:22 +0000 (GMT)
Date: Wed, 31 Jan 2024 12:50:41 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        david@redhat.com, nsg@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/5] lib: s390x: uv: Dirty CC before
 uvc execution
Message-ID: <20240131125041.5abff114@p-imbrenda>
In-Reply-To: <20240131074427.70871-3-frankja@linux.ibm.com>
References: <20240131074427.70871-1-frankja@linux.ibm.com>
	<20240131074427.70871-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: oqahJCLGHxLObGJoh2MKwn3E7rV66BKA
X-Proofpoint-ORIG-GUID: kuoUKhmPL3XEy7DP-93lmTHDVpyZXYqb
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-31_06,2024-01-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 mlxlogscore=974 clxscore=1011 priorityscore=1501
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401310091

On Wed, 31 Jan 2024 07:44:24 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Dirtying the CC allows us to find missing CC changes.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/uv.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index e9fb19af..611dcd3f 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -216,14 +216,16 @@ struct uv_cb_ssc {
>  
>  static inline int uv_call_once(unsigned long r1, unsigned long r2)
>  {
> +	uint64_t bogus_cc = 1;
>  	int cc;
>  
>  	asm volatile(
> +		"	tmll    %[bogus_cc],3\n"
>  		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],0,0\n"
>  		"		ipm	%[cc]\n"
>  		"		srl	%[cc],28\n"
>  		: [cc] "=d" (cc)
> -		: [r1] "a" (r1), [r2] "a" (r2)
> +		: [r1] "a" (r1), [r2] "a" (r2), [bogus_cc] "d" (bogus_cc)
>  		: "memory", "cc");
>  
>  	if (UVC_ERR_DEBUG && cc == 1)


