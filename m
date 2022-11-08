Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EEE62116A
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 13:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234244AbiKHMus (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 07:50:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234229AbiKHMuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 07:50:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46713B38;
        Tue,  8 Nov 2022 04:50:46 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A8BN9G4020165;
        Tue, 8 Nov 2022 12:50:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=xpbVy2Xdw6dkaofnePr8pEsAXDgp1oFsAnah/EYilNQ=;
 b=qVUSesUO+uOU3HhWOdcPJjNuZ7hnpwreWqHnmz2y7qGFdeDI4hACGZsIVhdslPwjsu9K
 vLxrN1Ro5IKqupOGyu9cFtCqfyl+3IogDz/8JIJ6h8texWYZ/efLWIV2T5eyx6idNaW3
 3Gfg2JfBzOIn3hIe5jIh9TBfi+B7q5w4uP+FWr9OmON+ZxmTSQ/gWF+yohwNwHSX4feO
 Gma+UKOq5RdvC40VRZaHQhG70TDMfwk3ooCFuAvsk5wZqKGZEI3ZS+4n13/XoMf+fL6q
 KKzApeNQ39DO8Y7UFaj0AZLuonVgKno42x1rt4CWJ3PLGBnbxjpw5eO7SbK//vlAhx06 2Q== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kqkhkyenj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 12:50:45 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2A8Cb9Uq000992;
        Tue, 8 Nov 2022 12:50:43 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06ams.nl.ibm.com with ESMTP id 3kngncc5ht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Nov 2022 12:50:43 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2A8Coef327853404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Nov 2022 12:50:40 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 456F652051;
        Tue,  8 Nov 2022 12:50:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id CEB245204E;
        Tue,  8 Nov 2022 12:50:39 +0000 (GMT)
Date:   Tue, 8 Nov 2022 13:50:38 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        pasic@linux.ibm.com, akrowiak@linux.ibm.com, jjherne@linux.ibm.com,
        mimu@linux.ibm.com, vneethv@linux.ibm.com, oberpar@linux.ibm.com
Subject: Re: [PATCH v1] KVM: s390: GISA: sort out physical vs virtual
 pointers usage
Message-ID: <20221108135038.4b6300e4@p-imbrenda>
In-Reply-To: <20221107085727.1533792-1-nrb@linux.ibm.com>
References: <20221107085727.1533792-1-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: vIFSmw-PDeLZZJpO7tDT-ac6xEyn5GHH
X-Proofpoint-GUID: vIFSmw-PDeLZZJpO7tDT-ac6xEyn5GHH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211080072
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  7 Nov 2022 09:57:27 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> Fix virtual vs physical address confusion (which currently are the same).
> 
> In chsc_sgib(), do the virtual-physical conversion in the caller since
> the caller needs to make sure it is a 31-bit address and zero has a
> special meaning (disassociating the GIB).
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kvm/interrupt.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index ab569faf0df2..ae018217eac8 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -3104,9 +3104,9 @@ static enum hrtimer_restart gisa_vcpu_kicker(struct hrtimer *timer)
>  static void process_gib_alert_list(void)
>  {
>  	struct kvm_s390_gisa_interrupt *gi;
> +	u32 final, gisa_phys, origin = 0UL;
>  	struct kvm_s390_gisa *gisa;
>  	struct kvm *kvm;
> -	u32 final, origin = 0UL;
>  
>  	do {
>  		/*
> @@ -3132,9 +3132,10 @@ static void process_gib_alert_list(void)
>  		 * interruptions asap.
>  		 */
>  		while (origin & GISA_ADDR_MASK) {
> -			gisa = (struct kvm_s390_gisa *)(u64)origin;
> +			gisa_phys = origin;
> +			gisa = phys_to_virt(gisa_phys);
>  			origin = gisa->next_alert;
> -			gisa->next_alert = (u32)(u64)gisa;
> +			gisa->next_alert = gisa_phys;
>  			kvm = container_of(gisa, struct sie_page2, gisa)->kvm;
>  			gi = &kvm->arch.gisa_int;
>  			if (hrtimer_active(&gi->timer))
> @@ -3418,6 +3419,7 @@ void kvm_s390_gib_destroy(void)
>  
>  int kvm_s390_gib_init(u8 nisc)
>  {
> +	u32 gib_origin;
>  	int rc = 0;
>  
>  	if (!css_general_characteristics.aiv) {
> @@ -3439,7 +3441,8 @@ int kvm_s390_gib_init(u8 nisc)
>  	}
>  
>  	gib->nisc = nisc;
> -	if (chsc_sgib((u32)(u64)gib)) {
> +	gib_origin = virt_to_phys(gib);
> +	if (chsc_sgib(gib_origin)) {
>  		pr_err("Associating the GIB with the AIV facility failed\n");
>  		free_page((unsigned long)gib);
>  		gib = NULL;

