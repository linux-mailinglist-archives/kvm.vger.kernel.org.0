Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A78F6605AF7
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiJTJSk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229909AbiJTJSh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:18:37 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74F9B1BE43A
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:18:34 -0700 (PDT)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K8TfKG019989
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:18:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=SrpWG8bvxSJWCv8kjHFkQ7jid1eG0G0ax8iO3rfj68Q=;
 b=HWiuKj6qItQbUUnXGGL9A6yqOofK7AdhFLyZS2NwHJEPVqhfoYKbTeMwGZJl4ui18CPt
 z2uF1O0xOAzwH8Hy+lbQWge0kmXkCsMhTtMQ3ORV0t5cB4p7SjbSwf0gpLJST0oZNP9/
 7470WflI8nXGEd6mLTAMns1qE4u3hwUEyCim1yyO0ynhnJf3QS1gUa4QO2V8kz/dMwj1
 dl3jFteUNHNC+yedBsxY8fYwv7+AE7F8IXQmyNClsFhIERJWs6/yAYXGKCyFWCOfhU5Y
 KRFnNX0sRUxtXep73R/Y5V7qrozVVzaNCk8zYB4PNBdYEbBlez91yl8cAvGX9fC543Fh Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3katy3x75t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:18:33 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K8b6am026891
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:18:33 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3katy3x753-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:18:33 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K96Fi8010697;
        Thu, 20 Oct 2022 09:18:31 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03fra.de.ibm.com with ESMTP id 3k7mg9efgu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:18:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K9ISF22228756
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 09:18:28 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 214CD52051;
        Thu, 20 Oct 2022 09:18:28 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id BBCA95204F;
        Thu, 20 Oct 2022 09:18:27 +0000 (GMT)
Date:   Thu, 20 Oct 2022 11:18:23 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 4/7] lib: s390x: sie: Improve validity
 handling and make it vm specific
Message-ID: <20221020111823.0ed95d51@p-imbrenda>
In-Reply-To: <20221020090009.2189-5-frankja@linux.ibm.com>
References: <20221020090009.2189-1-frankja@linux.ibm.com>
        <20221020090009.2189-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZCt8L_7QtnVXm7jSGpk7NFFW7lVS3G-6
X-Proofpoint-GUID: r9oA-siaxoOFeC8ayRlUgP7kbooFDC10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=869 adultscore=0
 impostorscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 mlxscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200053
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Oct 2022 09:00:06 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The current library doesn't support running multiple vms at once as it
> stores the validity once and not per vm. Let's move the validity
> handling into the vm and introduce a new function to retrieve the vir.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.c | 27 ++++++++++++++-------------
>  lib/s390x/sie.h |  6 ++++--
>  2 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 00aff713..3fee3def 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -15,19 +15,22 @@
>  #include <libcflat.h>
>  #include <alloc_page.h>
>  
> -static bool validity_expected;
> -static uint16_t vir;		/* Validity interception reason */
> -
> -void sie_expect_validity(void)
> +void sie_expect_validity(struct vm *vm)
>  {
> -	validity_expected = true;
> -	vir = 0;
> +	vm->validity_expected = true;
>  }
>  
> -void sie_check_validity(uint16_t vir_exp)
> +uint16_t sie_get_validity(struct vm *vm)
>  {
> +	assert(vm->sblk->icptcode == ICPT_VALIDITY);
> +	return vm->sblk->ipb >> 16;
> +}
> +
> +void sie_check_validity(struct vm *vm, uint16_t vir_exp)
> +{
> +	uint16_t vir = sie_get_validity(vm);
> +
>  	report(vir_exp == vir, "VALIDITY: %x", vir);
> -	vir = 0;
>  }
>  
>  void sie_handle_validity(struct vm *vm)
> @@ -35,11 +38,9 @@ void sie_handle_validity(struct vm *vm)
>  	if (vm->sblk->icptcode != ICPT_VALIDITY)
>  		return;
>  
> -	vir = vm->sblk->ipb >> 16;
> -
> -	if (!validity_expected)
> -		report_abort("VALIDITY: %x", vir);
> -	validity_expected = false;
> +	if (!vm->validity_expected)
> +		report_abort("VALIDITY: %x", sie_get_validity(vm));
> +	vm->validity_expected = false;
>  }
>  
>  void sie(struct vm *vm)
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index de91ea5a..320c4218 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -233,14 +233,16 @@ struct vm {
>  	struct vm_uv uv;			/* PV UV information */
>  	/* Ptr to first guest page */
>  	uint8_t *guest_mem;
> +	bool validity_expected;
>  };
>  
>  extern void sie_entry(void);
>  extern void sie_exit(void);
>  extern void sie64a(struct kvm_s390_sie_block *sblk, struct vm_save_area *save_area);
>  void sie(struct vm *vm);
> -void sie_expect_validity(void);
> -void sie_check_validity(uint16_t vir_exp);
> +void sie_expect_validity(struct vm *vm);
> +uint16_t sie_get_validity(struct vm *vm);
> +void sie_check_validity(struct vm *vm, uint16_t vir_exp);
>  void sie_handle_validity(struct vm *vm);
>  void sie_guest_sca_create(struct vm *vm);
>  void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len);

