Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8FA4B6A87
	for <lists+kvm@lfdr.de>; Tue, 15 Feb 2022 12:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbiBOLSb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Feb 2022 06:18:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236988AbiBOLS3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Feb 2022 06:18:29 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F42107D0A;
        Tue, 15 Feb 2022 03:18:20 -0800 (PST)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21FArYKp025895;
        Tue, 15 Feb 2022 11:18:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=GGM9upgp0UOt2V4XyedxcgkQATuRzYV+EU7siHZoo3M=;
 b=JtsgrUt5Fay1eDYWA6nrwvo76xCr50B57xcNVUwR1CrWq4HwTbc6C3SKiQaHRMV5xuwY
 +6XCT+7g0BUwLpGOfcBI7EvlNGjxCNOiSxbadEGbPuNWY/Pj9RPZGYOyQMNaodsb4dHs
 G60+c8/e4XKAbwsRzHK+8R1wXHUgS4RrGocNSg3dVhfG5OdpuNxwq+QeWUeVQg0X4zvj
 KfZThwRJ08EsRF5MJu4ifbsy5kJYfzqBYnXPunTYTSjf/CGhWnhNPahhylP5El6uqI6G
 DEP2wY3+YThwgNyxmC84nurCdGeV4k9v0F+iVlFCyWV56fSZEHT+1ZmPtFjKjrldCzKx rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8ats8ghu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:18:19 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 21FB62bT006352;
        Tue, 15 Feb 2022 11:18:19 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e8ats8ghc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:18:19 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 21FBBxBS025189;
        Tue, 15 Feb 2022 11:18:16 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03fra.de.ibm.com with ESMTP id 3e64h9w66n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Feb 2022 11:18:16 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 21FBIDvs48890298
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Feb 2022 11:18:13 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5E8F111C06E;
        Tue, 15 Feb 2022 11:18:13 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F05D911C05C;
        Tue, 15 Feb 2022 11:18:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.54])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Feb 2022 11:18:12 +0000 (GMT)
Date:   Tue, 15 Feb 2022 12:18:10 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, frankja@linux.ibm.com,
        thuth@redhat.com, kvm@vger.kernel.org, cohuck@redhat.com,
        david@redhat.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v4 2/4] s390x: stsi: Define vm_is_kvm to
 be used in different tests
Message-ID: <20220215121810.4e6cc5be@p-imbrenda>
In-Reply-To: <20220208132709.48291-3-pmorel@linux.ibm.com>
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
        <20220208132709.48291-3-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -JEoCzpSxFW5ZOBPnYxA5_gpJkVQwzQ3
X-Proofpoint-GUID: lLSN7EL-GPcQC_CU7hdYirN8AT8Tnauw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-15_04,2022-02-14_04,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 phishscore=0 spamscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202150063
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  8 Feb 2022 14:27:07 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We need in several tests to check if the VM we are running in
> is KVM.
> Let's add the test.
> 
> To check the VM type we use the STSI 3.2.2 instruction, let's
> define it's response structure in a central header.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> ---
>  lib/s390x/stsi.h | 32 +++++++++++++++++++++++++++
>  lib/s390x/vm.c   | 56 ++++++++++++++++++++++++++++++++++++++++++++++--
>  lib/s390x/vm.h   |  3 +++
>  s390x/stsi.c     | 23 ++------------------
>  4 files changed, 91 insertions(+), 23 deletions(-)
>  create mode 100644 lib/s390x/stsi.h
> 
> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
> new file mode 100644
> index 00000000..9b40664f
> --- /dev/null
> +++ b/lib/s390x/stsi.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + * Structures used to Store System Information
> + *
> + * Copyright IBM Corp. 2022
> + */
> +
> +#ifndef _S390X_STSI_H_
> +#define _S390X_STSI_H_
> +
> +struct sysinfo_3_2_2 {
> +	uint8_t reserved[31];
> +	uint8_t count;
> +	struct {
> +		uint8_t reserved2[4];
> +		uint16_t total_cpus;
> +		uint16_t conf_cpus;
> +		uint16_t standby_cpus;
> +		uint16_t reserved_cpus;
> +		uint8_t name[8];
> +		uint32_t caf;
> +		uint8_t cpi[16];
> +		uint8_t reserved5[3];
> +		uint8_t ext_name_encoding;
> +		uint32_t reserved3;
> +		uint8_t uuid[16];
> +	} vm[8];
> +	uint8_t reserved4[1504];
> +	uint8_t ext_names[8][256];
> +};
> +
> +#endif  /* _S390X_STSI_H_ */
> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
> index a5b92863..38886b76 100644
> --- a/lib/s390x/vm.c
> +++ b/lib/s390x/vm.c
> @@ -12,6 +12,7 @@
>  #include <alloc_page.h>
>  #include <asm/arch_def.h>
>  #include "vm.h"
> +#include "stsi.h"
>  
>  /**
>   * Detect whether we are running with TCG (instead of KVM)
> @@ -26,9 +27,13 @@ bool vm_is_tcg(void)
>  	if (initialized)
>  		return is_tcg;
>  
> -	buf = alloc_page();
> -	if (!buf)
> +	if (!vm_is_vm()) {
> +		initialized = true;
>  		return false;
> +	}
> +
> +	buf = alloc_page();
> +	assert(buf);
>  
>  	if (stsi(buf, 1, 1, 1))
>  		goto out;
> @@ -43,3 +48,50 @@ out:
>  	free_page(buf);
>  	return is_tcg;
>  }
> +
> +/**
> + * Detect whether we are running with KVM
> + */
> +
> +bool vm_is_kvm(void)

I think this is too messy

I think a cleaner approach would be to have one "detect_environment"
function to call stsi and find out which environment we are running on.

then the various vm_is_* would just be something like

bool vm_is_kvm(void)
{
	return detect_environment() == VM_IS_KVM;
}

obviously the detect_environment function would call stsi only once and
then cache the result.

bonus, we could make that function public too, so e.g. a testcase could
do a switch, instead of having to do a series of nested ifs

> +{
> +	/* EBCDIC for "KVM/" */
> +	const uint8_t kvm_ebcdic[] = { 0xd2, 0xe5, 0xd4, 0x61 };
> +	static bool initialized;
> +	static bool is_kvm;
> +	struct sysinfo_3_2_2 *stsi_322;
> +
> +	if (initialized)
> +		return is_kvm;
> +
> +	if (!vm_is_vm() || vm_is_tcg()) {
> +		initialized = true;
> +		return is_kvm;
> +	}
> +
> +	stsi_322 = alloc_page();
> +	assert(stsi_322);
> +
> +	if (stsi(stsi_322, 3, 2, 2))
> +		goto out;
> +
> +	/*
> +	 * If the manufacturer string is "KVM/" in EBCDIC, then we
> +	 * are on KVM.
> +	 */
> +	is_kvm = !memcmp(&stsi_322->vm[0].cpi, kvm_ebcdic, sizeof(kvm_ebcdic));
> +	initialized = true;
> +out:
> +	free_page(stsi_322);
> +	return is_kvm;
> +}
> +
> +bool vm_is_lpar(void)
> +{
> +	return stsi_get_fc() == 2;
> +}
> +
> +bool vm_is_vm(void)

is it enough to call it vm? maybe zvm? I don't have a strong opinion,
though

> +{
> +	return stsi_get_fc() == 3;
> +}
> diff --git a/lib/s390x/vm.h b/lib/s390x/vm.h
> index 7abba0cc..3aaf76af 100644
> --- a/lib/s390x/vm.h
> +++ b/lib/s390x/vm.h
> @@ -9,5 +9,8 @@
>  #define _S390X_VM_H_
>  
>  bool vm_is_tcg(void);
> +bool vm_is_kvm(void);
> +bool vm_is_vm(void);
> +bool vm_is_lpar(void);
>  
>  #endif  /* _S390X_VM_H_ */
> diff --git a/s390x/stsi.c b/s390x/stsi.c
> index 391f8849..1ed045e2 100644
> --- a/s390x/stsi.c
> +++ b/s390x/stsi.c
> @@ -13,27 +13,8 @@
>  #include <asm/asm-offsets.h>
>  #include <asm/interrupt.h>
>  #include <smp.h>
> +#include "stsi.h"
>  
> -struct stsi_322 {
> -	uint8_t reserved[31];
> -	uint8_t count;
> -	struct {
> -		uint8_t reserved2[4];
> -		uint16_t total_cpus;
> -		uint16_t conf_cpus;
> -		uint16_t standby_cpus;
> -		uint16_t reserved_cpus;
> -		uint8_t name[8];
> -		uint32_t caf;
> -		uint8_t cpi[16];
> -		uint8_t reserved5[3];
> -		uint8_t ext_name_encoding;
> -		uint32_t reserved3;
> -		uint8_t uuid[16];
> -	} vm[8];
> -	uint8_t reserved4[1504];
> -	uint8_t ext_names[8][256];
> -};
>  static uint8_t pagebuf[PAGE_SIZE * 2] __attribute__((aligned(PAGE_SIZE * 2)));
>  
>  static void test_specs(void)
> @@ -91,7 +72,7 @@ static void test_3_2_2(void)
>  	/* EBCDIC for "KVM/" */
>  	const uint8_t cpi_kvm[] = { 0xd2, 0xe5, 0xd4, 0x61 };
>  	const char vm_name_ext[] = "kvm-unit-test";
> -	struct stsi_322 *data = (void *)pagebuf;
> +	struct sysinfo_3_2_2 *data = (void *)pagebuf;
>  
>  	report_prefix_push("3.2.2");
>  

