Return-Path: <kvm+bounces-496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D9DF87E0479
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 15:14:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 51040B214B6
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 14:14:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD1EA1BDCC;
	Fri,  3 Nov 2023 14:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cyNfcVjI"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9D11A70A
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 14:14:28 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C753F1B9;
	Fri,  3 Nov 2023 07:14:27 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3Dkvlt002012;
	Fri, 3 Nov 2023 14:14:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=2dHkwY0ZexrWZfQ46gqbOMiqCKtCgsoqLD7Omyhjzfo=;
 b=cyNfcVjImx+4VTVWpi1qnjq2Da7Z/auk/dL8tQtT81w074ys+3BYlSZitKEi3gJR1fKi
 hZVlc2NLAKTr3mIckFQIcEWr+LFqhA4N6T00z4XRMC/Z73jRVNeOSJJ5C6OlNBxtGANO
 4EmlAw1OuXrmgb9+FtY+kjQ4GVCGR4eZ8l2QrBeWVrQrNb4VaqKyWz8iOJmjumDUhuYx
 +OhyCvOnGmb9F2/bJJ8qe+rT3PB9SPS9zBlW2X72lB3PYSXiX8cDeqndOjswV3k10/k2
 E+Gn+HVQiZ1TUqHaTjG70GeAOehl1oe9738Y+10f9JeKH/g7Is/zNKc4qAR/yMHZbtIo Qg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u522295wc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 14:14:26 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3E5ata004124;
	Fri, 3 Nov 2023 14:14:25 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u522295sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 14:14:24 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3Dm2VY011291;
	Fri, 3 Nov 2023 14:14:16 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3u1eukp23y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 14:14:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3EEDCd16253674
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 14:14:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C4AEB20043;
	Fri,  3 Nov 2023 14:14:13 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A31B020040;
	Fri,  3 Nov 2023 14:14:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 14:14:13 +0000 (GMT)
Date: Fri, 3 Nov 2023 14:35:55 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v7 1/8] lib: s390x: introduce bitfield
 for PSW mask
Message-ID: <20231103143555.1b6d35ff@p-imbrenda>
In-Reply-To: <20231103092954.238491-2-nrb@linux.ibm.com>
References: <20231103092954.238491-1-nrb@linux.ibm.com>
	<20231103092954.238491-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3IKmUVE54MK5x9qlX9UAMOYKUrYgciJK
X-Proofpoint-ORIG-GUID: gv8ITapMpfGOdE-_6m1vL8OMXqu8MOAg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_13,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxscore=0 priorityscore=1501
 lowpriorityscore=0 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015
 mlxlogscore=855 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030120

On Fri,  3 Nov 2023 10:29:30 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Changing the PSW mask is currently little clumsy, since there is only the
> PSW_MASK_* defines. This makes it hard to change e.g. only the address
> space in the current PSW without a lot of bit fiddling.
> 
> Introduce a bitfield for the PSW mask. This makes this kind of
> modifications much simpler and easier to read.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 25 ++++++++++++++++++++++++-
>  s390x/selftest.c         | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 58 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index bb26e008cc68..f629b6d0a17f 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -37,9 +37,32 @@ struct stack_frame_int {
>  };
>  
>  struct psw {
> -	uint64_t	mask;
> +	union {
> +		uint64_t	mask;
> +		struct {
> +			uint64_t reserved00:1;
> +			uint64_t per:1;
> +			uint64_t reserved02:3;
> +			uint64_t dat:1;
> +			uint64_t io:1;
> +			uint64_t ext:1;
> +			uint64_t key:4;
> +			uint64_t reserved12:1;
> +			uint64_t mchk:1;
> +			uint64_t wait:1;
> +			uint64_t pstate:1;
> +			uint64_t as:2;
> +			uint64_t cc:2;
> +			uint64_t prg_mask:4;
> +			uint64_t reserved24:7;
> +			uint64_t ea:1;
> +			uint64_t ba:1;
> +			uint64_t reserved33:31;
> +		};
> +	};
>  	uint64_t	addr;
>  };
> +_Static_assert(sizeof(struct psw) == 16, "PSW size");
>  
>  #define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
>  
> diff --git a/s390x/selftest.c b/s390x/selftest.c
> index 13fd36bc06f8..92ed4e5d35eb 100644
> --- a/s390x/selftest.c
> +++ b/s390x/selftest.c
> @@ -74,6 +74,39 @@ static void test_malloc(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_psw_mask(void)
> +{
> +	uint64_t expected_key = 0xf;
> +	struct psw test_psw = PSW(0, 0);
> +
> +	report_prefix_push("PSW mask");
> +	test_psw.mask = PSW_MASK_DAT;
> +	report(test_psw.dat, "DAT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_DAT, test_psw.mask);
> +
> +	test_psw.mask = PSW_MASK_IO;
> +	report(test_psw.io, "IO matches expected=0x%016lx actual=0x%016lx", PSW_MASK_IO, test_psw.mask);
> +
> +	test_psw.mask = PSW_MASK_EXT;
> +	report(test_psw.ext, "EXT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_EXT, test_psw.mask);
> +
> +	test_psw.mask = expected_key << (63 - 11);
> +	report(test_psw.key == expected_key, "PSW Key matches expected=0x%lx actual=0x%x", expected_key, test_psw.key);
> +
> +	test_psw.mask = 1UL << (63 - 13);
> +	report(test_psw.mchk, "MCHK matches");
> +
> +	test_psw.mask = PSW_MASK_WAIT;
> +	report(test_psw.wait, "Wait matches expected=0x%016lx actual=0x%016lx", PSW_MASK_WAIT, test_psw.mask);
> +
> +	test_psw.mask = PSW_MASK_PSTATE;
> +	report(test_psw.pstate, "Pstate matches expected=0x%016lx actual=0x%016lx", PSW_MASK_PSTATE, test_psw.mask);
> +
> +	test_psw.mask = PSW_MASK_64;
> +	report(test_psw.ea && test_psw.ba, "BA/EA matches expected=0x%016lx actual=0x%016lx", PSW_MASK_64, test_psw.mask);
> +
> +	report_prefix_pop();
> +}
> +
>  int main(int argc, char**argv)
>  {
>  	report_prefix_push("selftest");
> @@ -89,6 +122,7 @@ int main(int argc, char**argv)
>  	test_fp();
>  	test_pgm_int();
>  	test_malloc();
> +	test_psw_mask();
>  
>  	return report_summary();
>  }


