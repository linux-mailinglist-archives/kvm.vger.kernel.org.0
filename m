Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BBDD6A5E0F
	for <lists+kvm@lfdr.de>; Tue, 28 Feb 2023 18:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjB1RQr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 12:16:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229750AbjB1RQp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 12:16:45 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98672234CF;
        Tue, 28 Feb 2023 09:16:42 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31SHFHvi025344;
        Tue, 28 Feb 2023 17:16:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=23CITkS+vOY/tO63Ko0pAqDDmHW0is9M5qvP2I7xTdM=;
 b=jkngCc5n0j2IpxiUAIz8/RQXPVi1Q2XBeUBfAf8/xOsE6asrY6ONMnwHgm2+BtO0KHkR
 or+l0dbXdSQWYb9A0OyIkmSqH1JzYtIns8O+/Z84p/zMjK/NTPBKOxXzNyQzUgYxu8St
 NpdzqGNXqrtZXL163vsunwPL6P1dw68AHYinxs/vnldwmz8bieBpNizn4oMgRjlQPdVu
 pQ/bgnNx7UsZJ9Jet87u0ANDC/VMOhbeYHHW/yMC5tM5UJRYu/kMMzHpGMYCCs6D72jP
 5skcn7HWCJD6krejsbdjynETEuxcohbWfJYht/DDDMrQLHMGa5seMf3DEqDz2j6awHcP Ow== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1ka3wd8c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 17:16:41 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31SEM48T027477;
        Tue, 28 Feb 2023 17:16:41 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3p1ka3wd7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 17:16:41 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31RNoET7032266;
        Tue, 28 Feb 2023 17:16:39 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3nybab2emn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Feb 2023 17:16:39 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31SHGZ6049348916
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Feb 2023 17:16:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9E5F820040;
        Tue, 28 Feb 2023 17:16:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 18DAB20043;
        Tue, 28 Feb 2023 17:16:35 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.17.91])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
        Tue, 28 Feb 2023 17:16:35 +0000 (GMT)
Date:   Tue, 28 Feb 2023 18:16:33 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        mimu@linux.ibm.com, agordeev@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 1/1] KVM: s390: interrupt: fix virtual-physical
 confusion for next alert GISA
Message-ID: <20230228181633.1bd8efde@p-imbrenda>
In-Reply-To: <20230224140908.75208-2-nrb@linux.ibm.com>
References: <20230224140908.75208-1-nrb@linux.ibm.com>
        <20230224140908.75208-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K-kwHA6OkPgdO2-46o1e-hLDPYLgmH8E
X-Proofpoint-ORIG-GUID: sImCB1BQAcExqQfQzsdlWoHE1IbmOpew
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-02-28_13,2023-02-28_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 priorityscore=1501 phishscore=0 mlxscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302280141
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Feb 2023 15:09:08 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

> The gisa next alert address is defined as a host absolute address so
> let's use virt_to_phys() to make sure we always write an absolute
> address to this hardware structure.
> 
> This is not a bug and currently works, because virtual and physical
> addresses are the same.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/kvm/interrupt.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index ab26aa53ee37..20743c5b000a 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -305,7 +305,7 @@ static inline u8 gisa_get_ipm_or_restore_iam(struct kvm_s390_gisa_interrupt *gi)
>  
>  static inline int gisa_in_alert_list(struct kvm_s390_gisa *gisa)
>  {
> -	return READ_ONCE(gisa->next_alert) != (u32)(u64)gisa;
> +	return READ_ONCE(gisa->next_alert) != (u32)virt_to_phys(gisa);

is gisa always allocated below 4G? (I assume 2G actually)
should we check if things are proper?
the cast to (u32) might hide bugs if gisa is above 4G (which it
shouldn't be, obviously)

or do we not care?

>  }
>  
>  static inline void gisa_set_ipm_gisc(struct kvm_s390_gisa *gisa, u32 gisc)
> @@ -3167,7 +3167,7 @@ void kvm_s390_gisa_init(struct kvm *kvm)
>  	hrtimer_init(&gi->timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
>  	gi->timer.function = gisa_vcpu_kicker;
>  	memset(gi->origin, 0, sizeof(struct kvm_s390_gisa));
> -	gi->origin->next_alert = (u32)(u64)gi->origin;
> +	gi->origin->next_alert = (u32)virt_to_phys(gi->origin);

same here

>  	VM_EVENT(kvm, 3, "gisa 0x%pK initialized", gi->origin);
>  }
>  

