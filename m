Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67AF7605B85
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 11:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbiJTJu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 05:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbiJTJuw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 05:50:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27D01119ED
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 02:50:20 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K9c6rJ032406
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:50:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=IZ0bX6Ggw112suPUDZlx+zroTQUnqpZBf6zdNMgNlsk=;
 b=hXwop3uXW5WUwHLmwevGIj1WXrMC8rBSHhyMwS3yUkqksjnQ7PFy5iCyXX5A05TG8WUz
 Hl5CAwVJ+p8WlFbtSD7ezcdlWZQ9PPRVe1SVVVQ+55oKMbBNJO5PZDUHsHftTJR0bNXz
 vI5F+w/wbwUJcLWMdUxmEmlKZOY6A3JkGCg6/t0dUof1JMpqb5MlKq3IrVvYg4fiA5lR
 LPdOVszs6s7zj1/9NO+8aqbHBe5seBMIVzsyy2wCpIfDC6Vd6nG5bCNBVn1RTblOKiUq
 UMUUC0UiIKKoGYynIUv5KbC78qDV4KNZi8PewCMvg9IoTGHLNSHEnnUHG2mIjVpTV+fx 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb32hsr8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:50:19 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K9cEoc001524
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 09:50:18 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb32hsr7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:50:18 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K9b4hd020833;
        Thu, 20 Oct 2022 09:50:17 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma01fra.de.ibm.com with ESMTP id 3k99fn4186-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 09:50:16 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K9oDW86423078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 09:50:13 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C1F3C5204F;
        Thu, 20 Oct 2022 09:50:13 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.239])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 566435204E;
        Thu, 20 Oct 2022 09:50:13 +0000 (GMT)
Date:   Thu, 20 Oct 2022 11:50:11 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 7/7] lib: s390x: sie: Properly
 populate SCA
Message-ID: <20221020115011.1952efac@p-imbrenda>
In-Reply-To: <20221020090009.2189-8-frankja@linux.ibm.com>
References: <20221020090009.2189-1-frankja@linux.ibm.com>
        <20221020090009.2189-8-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: eaDXttOzDF8aBqDe1IcA0huL8XU3DD0h
X-Proofpoint-ORIG-GUID: 5uikApUfe9532spqr18mOT_oAJ41OuEM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_03,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 mlxscore=0 lowpriorityscore=0 bulkscore=0
 impostorscore=0 adultscore=0 phishscore=0 clxscore=1015 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210200056
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Oct 2022 09:00:09 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> CPU0 is the only cpu that's being used but we should still mark it as
> online and set the SDA in the SCA.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.c |  8 ++++++++
>  lib/s390x/sie.h | 35 ++++++++++++++++++++++++++++++++++-
>  2 files changed, 42 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 6efad965..a71985b6 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -9,6 +9,7 @@
>   */
>  
>  #include <asm/barrier.h>
> +#include <bitops.h>
>  #include <libcflat.h>
>  #include <sie.h>
>  #include <asm/page.h>
> @@ -72,6 +73,13 @@ void sie_guest_sca_create(struct vm *vm)
>  	vm->sblk->scaoh = ((uint64_t)vm->sca >> 32);
>  	vm->sblk->scaol = (uint64_t)vm->sca & ~0x3fU;
>  	vm->sblk->ecb2 |= ECB2_ESCA;
> +
> +	/* Enable SIGP sense running interpretation */
> +	vm->sblk->ecb |= ECB_SRSI;
> +
> +	/* We assume that cpu 0 is always part of the vm */
> +	vm->sca->mcn[0] = BIT(63);
> +	vm->sca->cpu[0].sda = (uint64_t)vm->sblk;
>  }
>  
>  /* Initializes the struct vm members like the SIE control block. */
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 3e3605c9..a27a8401 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -202,6 +202,39 @@ union {
>  	uint64_t	pv_grregs[16];		/* 0x0380 */
>  } __attribute__((packed));
>  
> +union esca_sigp_ctrl {
> +	uint16_t value;
> +	struct {
> +		uint8_t c : 1;
> +		uint8_t reserved: 7;
> +		uint8_t scn;
> +	};
> +};
> +
> +struct esca_entry {
> +	union esca_sigp_ctrl sigp_ctrl;
> +	uint16_t   reserved1[3];
> +	uint64_t   sda;
> +	uint64_t   reserved2[6];
> +};
> +
> +union ipte_control {
> +	unsigned long val;
> +	struct {
> +		unsigned long k  : 1;
> +		unsigned long kh : 31;
> +		unsigned long kg : 32;
> +	};
> +};
> +
> +struct esca_block {
> +	union ipte_control ipte_control;
> +	uint64_t   reserved1[7];
> +	uint64_t   mcn[4];
> +	uint64_t   reserved2[20];
> +	struct esca_entry cpu[256];
> +};
> +
>  struct vm_uv {
>  	uint64_t vm_handle;
>  	uint64_t vcpu_handle;
> @@ -230,7 +263,7 @@ struct vm_save_area {
>  struct vm {
>  	struct kvm_s390_sie_block *sblk;
>  	struct vm_save_area save_area;
> -	void *sca;				/* System Control Area */
> +	struct esca_block *sca;			/* System Control Area */
>  	uint8_t *crycb;				/* Crypto Control Block */
>  	struct vm_uv uv;			/* PV UV information */
>  	/* Ptr to first guest page */

