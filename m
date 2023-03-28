Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899706CC8B4
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 19:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231730AbjC1RBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 13:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjC1RBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 13:01:17 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889A79ECF;
        Tue, 28 Mar 2023 10:01:16 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SGuCj5020227;
        Tue, 28 Mar 2023 17:01:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ygXJ+bAfsvBTup8gyNESlCjdd9TB8mShFEv7UJPB6cs=;
 b=bSvtnBREW4KbtDTfQvGog6unLGSGub8cWElbL10usJYTCD13TTUVS30cVrWIx+UVMLVw
 inHf7B/vD6MTBuMb6Zv//fMjdDtUu1CJqNVBCvcNcAu/h60zbc3uj9z/kNTsZDKrR8PL
 UKY1MZx4KyxoxqO9/4RS7oKRvNC6olMBbVp9VWrDWzeM/Cv5y/iNxaHUtqRyo7w0mAJm
 hDJpaU+bgW2wyNDgH6jsKGGddIwsl2lnJXk5R9GYxtHc7bDhytMhN7oeo0HBFcKfA1JE
 BKdcjTHerk56iKuekKsDN5J8jGrqh6zqa/FX5VlW8VeQjKMljoLxZsRb2uhq7fz4PYvm iA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm46hr3dd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 17:01:15 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32SGv4fA027040;
        Tue, 28 Mar 2023 17:01:14 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm46hr3cj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 17:01:14 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32S2TJLk017934;
        Tue, 28 Mar 2023 17:01:13 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3phrk6bjf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 17:01:13 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32SH18XE14156510
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 17:01:08 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4AFE52006C;
        Tue, 28 Mar 2023 17:01:08 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2130C2004F;
        Tue, 28 Mar 2023 17:01:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Mar 2023 17:01:08 +0000 (GMT)
Date:   Tue, 28 Mar 2023 19:01:06 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 3/4] s390x: lib: sie: don't reenter
 SIE on pgm int
Message-ID: <20230328190106.6ea977ee@p-imbrenda>
In-Reply-To: <20230327082118.2177-4-nrb@linux.ibm.com>
References: <20230327082118.2177-1-nrb@linux.ibm.com>
        <20230327082118.2177-4-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PYmeCd2TmhPicG5QheN4hWL0qjsmN7Fk
X-Proofpoint-ORIG-GUID: _GJEKbynsSrKKiPeF5o810MxIBgdjyFY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 mlxscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280130
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 27 Mar 2023 10:21:17 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> At the moment, when a PGM int occurs while in SIE, we will just reenter
> SIE after the interrupt handler was called.
> 
> This is because sie() has a loop which checks icptcode and re-enters SIE
> if it is zero.
> 
> However, this behaviour is quite undesirable for SIE tests, since it
> doesn't give the host the chance to assert on the PGM int. Instead, we
> will just re-enter SIE, on nullifing conditions even causing the
> exception again.
> 
> Add a flag PROG_PGM_IN_SIE set by the pgm int fixup which indicates a
> program interrupt has occured in SIE. Check for the flag in sie() and if
> it's set return from sie() to give the host the ability to react on the
> exception. The host may check if a PGM int has occured in the guest
> using the new function sie_had_pgm_int().
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  lib/s390x/interrupt.c |  6 ++++++
>  lib/s390x/sie.c       | 10 +++++++++-
>  lib/s390x/sie.h       |  1 +
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index eb3d6a9b701d..9baf7a003f52 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -106,10 +106,16 @@ void register_ext_cleanup_func(void (*f)(struct stack_frame_int *))
>  
>  static void fixup_pgm_int(struct stack_frame_int *stack)
>  {
> +	struct kvm_s390_sie_block *sblk;
> +
>  	/* If we have an error on SIE we directly move to sie_exit */
>  	if (lowcore.pgm_old_psw.addr >= (uint64_t)&sie_entry &&
>  	    lowcore.pgm_old_psw.addr <= (uint64_t)&sie_exit) {
>  		lowcore.pgm_old_psw.addr = (uint64_t)&sie_exit;
> +
> +		/* set a marker in sie_block that a PGM int occured */
> +		sblk = *((struct kvm_s390_sie_block **)(stack->grs0[13] + __SF_SIE_CONTROL));
> +		sblk->prog0c |= PROG_PGM_IN_SIE;
>  		return;
>  	}
>  
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index 22141ded1a90..5e9ae7115c47 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -44,6 +44,11 @@ void sie_handle_validity(struct vm *vm)
>  	vm->validity_expected = false;
>  }
>  
> +bool sie_had_pgm_int(struct vm *vm)
> +{
> +	return vm->sblk->prog0c & PROG_PGM_IN_SIE;
> +}
> +
>  void sie(struct vm *vm)
>  {
>  	uint64_t old_cr13;
> @@ -68,7 +73,10 @@ void sie(struct vm *vm)
>  	lowcore.io_new_psw.mask |= PSW_MASK_DAT_HOME;
>  	mb();
>  
> -	while (vm->sblk->icptcode == 0) {
> +	/* clear PGM int marker, which might still be set */
> +	vm->sblk->prog0c &= ~PROG_PGM_IN_SIE;
> +
> +	while (vm->sblk->icptcode == 0 && !sie_had_pgm_int(vm)) {
>  		sie64a(vm->sblk, &vm->save_area);
>  		sie_handle_validity(vm);
>  	}
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 0b00fb709776..8ab755dc9456 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -37,6 +37,7 @@ struct kvm_s390_sie_block {
>  	uint32_t 	ibc : 12;
>  	uint8_t		reserved08[4];		/* 0x0008 */
>  #define PROG_IN_SIE (1<<0)
> +#define PROG_PGM_IN_SIE (1<<1)

please align the body of the macros with tabs, so they are more readable

>  	uint32_t	prog0c;			/* 0x000c */
>  union {
>  		uint8_t	reserved10[16];		/* 0x0010 */

