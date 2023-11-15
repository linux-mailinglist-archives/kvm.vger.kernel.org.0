Return-Path: <kvm+bounces-1810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 289847EC03B
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 11:07:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFADD2813C9
	for <lists+kvm@lfdr.de>; Wed, 15 Nov 2023 10:07:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B7D4C2EE;
	Wed, 15 Nov 2023 10:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Xsv4uvfV"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B315946F
	for <kvm@vger.kernel.org>; Wed, 15 Nov 2023 10:07:26 +0000 (UTC)
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11622C2;
	Wed, 15 Nov 2023 02:07:24 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AFA4hoO004916;
	Wed, 15 Nov 2023 10:07:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=RZrIIkGaAtl81QDB9c1wbYZafzw8AFUDCqnj2zs0/3k=;
 b=Xsv4uvfVVKx26gP875au9Hex91+Zp5HKCv66xI+IpZD12wSsL/6yTPPrLhj4Yh19kDIO
 9teVwNAfIsxaEdqh2thg6XxFxTa7oM+vWbQesVKnHAOQzytYVdqUe1HEmjIBAOmK+mL1
 8JRTFY8z1wJFAMev7CX6kKiYp/fQsSi6TQ8WGSRbjAJcl1ohr+0k22Kbyz5J1cm4gsej
 sYEe0rnmEOsHlM+1bWcbUwy9XlOG/8BNhC4rh5pgakktty4IylwlOJh4C8RSRuawGV5O
 e0MrQvq+R7va4Ajff/qN6+wa0SUD3pUxcFEu7X9ytD2o2Vaq7Y7QPhyf8CIg7fnw6kpB 9Q== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ucuwr846b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 10:07:23 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3AFA55G1006959;
	Wed, 15 Nov 2023 10:07:23 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ucuwr845k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 10:07:23 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3AF815h4023942;
	Wed, 15 Nov 2023 10:07:23 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3uamayekes-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 15 Nov 2023 10:07:22 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3AFA7JwG22479530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 15 Nov 2023 10:07:19 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7945C20070;
	Wed, 15 Nov 2023 10:07:19 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 51CC120071;
	Wed, 15 Nov 2023 10:07:19 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 15 Nov 2023 10:07:19 +0000 (GMT)
Date: Wed, 15 Nov 2023 11:07:17 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] s390x: cmm: test no-translate bit
 after reset
Message-ID: <20231115110717.7d0f29a9@p-imbrenda>
In-Reply-To: <20231115083848.17803-1-nrb@linux.ibm.com>
References: <20231115083848.17803-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: YHnXllp4kzfw5AJerKyzi3P62MHo0Fxp
X-Proofpoint-ORIG-GUID: 3_zRYtv7WDW5_VDkAnGdBIU24Re6ctg3
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-15_08,2023-11-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311150076

On Wed, 15 Nov 2023 09:38:32 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> KVM did not properly reset the no-translate bit after reset, see
> https://lore.kernel.org/kvm/20231109123624.37314-1-imbrenda@linux.ibm.com/
> 
> Add a test which performs a load normal reset (includes a subsystem
> reset) and verify that this clears the no-translate bit.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  s390x/cmm.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/s390x/cmm.c b/s390x/cmm.c
> index af852838851e..8f10c107d81b 100644
> --- a/s390x/cmm.c
> +++ b/s390x/cmm.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <libcflat.h>
> +#include <bitops.h>
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
>  #include <asm/page.h>
> @@ -16,6 +17,8 @@
>  
>  static uint8_t pagebuf[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
>  
> +extern int diag308_load_reset(u64);
> +
>  static void test_params(void)
>  {
>  	report_prefix_push("invalid ORC 8");
> @@ -35,6 +38,26 @@ static void test_priv(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_reset_no_translate(void)
> +{
> +	unsigned long state;
> +	const uint64_t mask_no_translate = BIT(63 - 58);

reverse Christmas tree, please :)

also, maybe it's easier to read with just a numeric constant? i.e. 0x20 


with the Christmas tree fixed (with or without numeric constant):

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Tested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>


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
> @@ -47,6 +70,7 @@ int main(void)
>  
>  	test_priv();
>  	test_params();
> +	test_reset_no_translate();
>  done:
>  	report_prefix_pop();
>  	return report_summary();


