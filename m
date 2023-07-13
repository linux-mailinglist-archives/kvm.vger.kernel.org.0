Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB248751D58
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 11:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232323AbjGMJeo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 05:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232360AbjGMJej (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 05:34:39 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F400C1FD7;
        Thu, 13 Jul 2023 02:34:37 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36D8ADLj004586;
        Thu, 13 Jul 2023 08:20:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=T1+pM296lEkRW5+ljtkevZvdgn/CAJx6Pvtn8VqVMlk=;
 b=fHylhZtflHxt6JEiSTYxHbSqgvG1BHsz0ibPZr2H5t15wNZX5KVloyIMZ1KXCEfa11bm
 YsVT6L2BflobJoSK8u7l/N/xaTF7/PDhoXsrJblpa1zyx/Iehhr1/98r0tX92R1rn7YT
 YrsDxL98UoKQuSl/o0aRGW0GvvxIYA/knd1zp8YTYxadvGBOpsHH5i7lA51GHN0CZQiT
 5LQ90RAiterKD4k01z+M7Eqplt9WICRTziJa1BA944YOIIqbktFwNMhQdCGdbC44DIHD
 Xh9GqRAjWeJdOWidX2K1SpAhWHkNd8PbwlQXlvdv1I1v0gp6fJyKFGWM1sSJsnT20Tox 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtd8rgmm3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:20:21 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36D8AuD1007399;
        Thu, 13 Jul 2023 08:20:21 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rtd8rgmkf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:20:21 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36D0n5wg008577;
        Thu, 13 Jul 2023 08:20:19 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3rpy2e358c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Jul 2023 08:20:19 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36D8KF6920251178
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jul 2023 08:20:16 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CBF0E20040;
        Thu, 13 Jul 2023 08:20:15 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9CEC22004B;
        Thu, 13 Jul 2023 08:20:15 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jul 2023 08:20:15 +0000 (GMT)
Date:   Thu, 13 Jul 2023 10:20:13 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v5 1/6] lib: s390x: introduce bitfield
 for PSW mask
Message-ID: <20230713102013.586c737a@p-imbrenda>
In-Reply-To: <20230712114149.1291580-2-nrb@linux.ibm.com>
References: <20230712114149.1291580-1-nrb@linux.ibm.com>
        <20230712114149.1291580-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: fC8Qw4hwjTjFpwRrlmcM-clFCH-r61dq
X-Proofpoint-ORIG-GUID: nSFbOpCWHzxjGWV0hT6ljyHlNsGVOGVF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-13_04,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 priorityscore=1501 malwarescore=0 clxscore=1015 mlxlogscore=893
 impostorscore=0 lowpriorityscore=0 adultscore=0 phishscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307130069
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 12 Jul 2023 13:41:44 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> Changing the PSW mask is currently little clumsy, since there is only the
> PSW_MASK_* defines. This makes it hard to change e.g. only the address
> space in the current PSW without a lot of bit fiddling.
> 
> Introduce a bitfield for the PSW mask. This makes this kind of
> modifications much simpler and easier to read.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/asm/arch_def.h | 26 +++++++++++++++++++++++++-
>  s390x/selftest.c         | 40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 65 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index bb26e008cc68..53279572a9ee 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -37,12 +37,36 @@ struct stack_frame_int {
>  };
>  
>  struct psw {
> -	uint64_t	mask;
> +	union {
> +		uint64_t	mask;
> +		struct {
> +			uint8_t reserved00:1;
> +			uint8_t per:1;
> +			uint8_t reserved02:3;
> +			uint8_t dat:1;
> +			uint8_t io:1;
> +			uint8_t ext:1;
> +			uint8_t key:4;
> +			uint8_t reserved12:1;
> +			uint8_t mchk:1;
> +			uint8_t wait:1;
> +			uint8_t pstate:1;
> +			uint8_t as:2;
> +			uint8_t cc:2;
> +			uint8_t prg_mask:4;
> +			uint8_t reserved24:7;
> +			uint8_t ea:1;
> +			uint8_t ba:1;
> +			uint32_t reserved33:31;

since you will need to respin this anyway:

can you use uint64_t everywhere in the bitfield? it would look more
consistent and it would avoid some potential pitfalls of using
bitfields. In our case we're lucky because all fields are properly
aligned, but using uint64_t makes it easier to understand.

> +		};
> +	};
>  	uint64_t	addr;
>  };
> +_Static_assert(sizeof(struct psw) == 16, "PSW size");
>  
>  #define PSW(m, a) ((struct psw){ .mask = (m), .addr = (uint64_t)(a) })
>  
> +
>  struct short_psw {
>  	uint32_t	mask;
>  	uint32_t	addr;
> diff --git a/s390x/selftest.c b/s390x/selftest.c
> index 13fd36bc06f8..8d81ba312279 100644
> --- a/s390x/selftest.c
> +++ b/s390x/selftest.c
> @@ -74,6 +74,45 @@ static void test_malloc(void)
>  	report_prefix_pop();
>  }
>  
> +static void test_psw_mask(void)
> +{
> +	uint64_t expected_key = 0xF;

I think we prefer lowercase hex

> +	struct psw test_psw = PSW(0, 0);
> +
> +	report_prefix_push("PSW mask");
> +	test_psw.dat = 1;
> +	report(test_psw.mask == PSW_MASK_DAT, "DAT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_DAT, test_psw.mask);
> +
> +	test_psw.mask = 0;
> +	test_psw.io = 1;
> +	report(test_psw.mask == PSW_MASK_IO, "IO matches expected=0x%016lx actual=0x%016lx", PSW_MASK_IO, test_psw.mask);
> +
> +	test_psw.mask = 0;
> +	test_psw.ext = 1;
> +	report(test_psw.mask == PSW_MASK_EXT, "EXT matches expected=0x%016lx actual=0x%016lx", PSW_MASK_EXT, test_psw.mask);
> +
> +	test_psw.mask = expected_key << (63 - 11);
> +	report(test_psw.key == expected_key, "PSW Key matches expected=0x%lx actual=0x%x", expected_key, test_psw.key);
> +
> +	test_psw.mask = 1UL << (63 - 13);
> +	report(test_psw.mchk, "MCHK matches");
> +
> +	test_psw.mask = 0;
> +	test_psw.wait = 1;
> +	report(test_psw.mask == PSW_MASK_WAIT, "Wait matches expected=0x%016lx actual=0x%016lx", PSW_MASK_WAIT, test_psw.mask);
> +
> +	test_psw.mask = 0;
> +	test_psw.pstate = 1;
> +	report(test_psw.mask == PSW_MASK_PSTATE, "Pstate matches expected=0x%016lx actual=0x%016lx", PSW_MASK_PSTATE, test_psw.mask);
> +
> +	test_psw.mask = 0;
> +	test_psw.ea = 1;
> +	test_psw.ba = 1;
> +	report(test_psw.mask == PSW_MASK_64, "BA/EA matches expected=0x%016lx actual=0x%016lx", PSW_MASK_64, test_psw.mask);
> +
> +	report_prefix_pop();
> +}
> +
>  int main(int argc, char**argv)
>  {
>  	report_prefix_push("selftest");
> @@ -89,6 +128,7 @@ int main(int argc, char**argv)
>  	test_fp();
>  	test_pgm_int();
>  	test_malloc();
> +	test_psw_mask();
>  
>  	return report_summary();
>  }

