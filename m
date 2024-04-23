Return-Path: <kvm+bounces-15662-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 812248AE727
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 14:58:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 38C60287E43
	for <lists+kvm@lfdr.de>; Tue, 23 Apr 2024 12:58:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0E3D12BE80;
	Tue, 23 Apr 2024 12:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cOV9PG3s"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 165028528B;
	Tue, 23 Apr 2024 12:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713877111; cv=none; b=u3lpBSjVw01q2hmYRNkkxsr4XcgRpytQ4Io/WYvuXKnnE7T/tc+8SI4PwTd7aAiXIBEX5NlL9faHVX4BIqfX5ZpKFpuD6gB+8OtFKdaePicgPNdWECikfr9PiNwuWG6DtuHjHPtn32H7Hl+2CHmPwisKhomfq9Qk2kcmV+C6qbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713877111; c=relaxed/simple;
	bh=F5n1rFXubAuYd6cBWkPk//PKxeqlAp6AECoQpFOQTNI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f2f7pTUWy6Voy9leTqZJH+Ec62pvnGuchnP5w8nAHE5+cLF21t7w+IcTpqstyHH8aL03jTIJuMJ0BB5eV/0fRBfl8Bxo8GNP7wUGvevNzq7JuGfZowPl3FhKbYgzI+dmcMwW9/AQvGvCX+p8AOU3KRhiLj1HNbcm2L4ppu1GVDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cOV9PG3s; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43NCMWpR028877;
	Tue, 23 Apr 2024 12:58:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=d5KCl+8ixX+/EoYCDbeBVUc03Ua5s0d1bJJq1n7BCjc=;
 b=cOV9PG3slMGGrTr/tVXJG++yKg2lxbYhv94lln6Gz1jRMYr2v4BeX++DMK1KD10CqI6o
 MQuKmqU0wT3s+SiERjGEHytJ3XS245UNyDSl+am6OtKyJa5rCmF1Ei8iRprQ38vcHRRu
 MGuixYuwRB4c/5XrqmvWgzgm8iOboz+bgomwX3gs/b33v/WRQ5+3t+068quu02or+oTM
 0n2ucskT/+pDUXpt0fQ9VbbTG8YNvnwnwHL5S6G9pMixBCo5zMTMKljRMwGfS8/DYllf
 goRSPQefW8bnQHjygsrLwSBmBBGBrq9RHYgFL9Da0bA1CvZMNQtxKpg/nKlUOJzkLyPm jg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpcxa82wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 12:58:27 +0000
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43NCwR5G024841;
	Tue, 23 Apr 2024 12:58:27 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3xpcxa82wa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 12:58:27 +0000
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 43NBB4JS023051;
	Tue, 23 Apr 2024 12:58:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3xms1nwmu2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 23 Apr 2024 12:58:25 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 43NCwK8B50463014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Apr 2024 12:58:22 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 44DCA2004B;
	Tue, 23 Apr 2024 12:58:20 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0926520040;
	Tue, 23 Apr 2024 12:58:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 23 Apr 2024 12:58:19 +0000 (GMT)
Date: Tue, 23 Apr 2024 14:57:31 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: cmm: test no-translate bit
 after reset
Message-ID: <20240423145731.65194864@p-imbrenda>
In-Reply-To: <20240423103529.313782-2-nrb@linux.ibm.com>
References: <20240423103529.313782-1-nrb@linux.ibm.com>
	<20240423103529.313782-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ct9FkvS-8c7xV_NkeTHxETDPdvzZEwCd
X-Proofpoint-GUID: WlftlrgCCXQzFtS5C0cETsUeRrY17sKf
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-23_11,2024-04-23_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 lowpriorityscore=0
 malwarescore=0 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2404010000 definitions=main-2404230033

On Tue, 23 Apr 2024 12:34:59 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> KVM did not properly reset the no-translate bit after reset, see
> https://lore.kernel.org/kvm/20231109123624.37314-1-imbrenda@linux.ibm.com/
> 
> Add a test which performs a load normal reset (includes a subsystem
> reset) and verify that this clears the no-translate bit.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/cmm.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
> 
> diff --git a/s390x/cmm.c b/s390x/cmm.c
> index af852838851e..536f2bfc3c93 100644
> --- a/s390x/cmm.c
> +++ b/s390x/cmm.c
> @@ -9,13 +9,17 @@
>   */
>  
>  #include <libcflat.h>
> +#include <bitops.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
>  #include <asm/page.h>
>  #include <asm/cmm.h>
> +#include <asm/facility.h>
>  
>  static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
>  
> +extern int diag308_load_reset(u64);
> +
>  static void test_params(void)
>  {
>  	report_prefix_push("invalid ORC 8");
> @@ -35,6 +39,35 @@ static void test_priv(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_reset_no_translate(void)
> +{
> +	const uint64_t mask_no_translate = BIT(63 - 58);
> +	unsigned long state;
> +
> +	if (!test_facility(147)) {
> +		report_prefix_push("no-translate unavailable");
> +		expect_pgm_int();
> +		essa(ESSA_SET_STABLE_NODAT, (unsigned long)pagebuf);
> +		check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +		report_prefix_pop();
> +		return;
> +	}
> +
> +	report_prefix_push("reset no-translate");
> +	essa(ESSA_SET_STABLE_NODAT, (unsigned long)pagebuf);
> +
> +	state = essa(ESSA_GET_STATE, (unsigned long)pagebuf);
> +	report(state & mask_no_translate, "no-translate bit set before reset");
> +
> +	/* Load normal reset - includes subsystem reset */
> +	diag308_load_reset(1);
> +
> +	state = essa(ESSA_GET_STATE, (unsigned long)pagebuf);
> +	report(!(state & mask_no_translate), "no-translate bit unset after reset");
> +
> +	report_prefix_pop();
> +}
> +
>  int main(void)
>  {
>  	bool has_essa = check_essa_available();
> @@ -47,6 +80,7 @@ int main(void)
>  
>  	test_priv();
>  	test_params();
> +	test_reset_no_translate();
>  done:
>  	report_prefix_pop();
>  	return report_summary();


