Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605DD698CBB
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 07:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjBPGRQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 01:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbjBPGRP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 01:17:15 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E02E3770D;
        Wed, 15 Feb 2023 22:17:14 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31G4TYbk016020;
        Thu, 16 Feb 2023 06:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=dwYvXklkQPC6Q+eIG8bMSC+KKu07S+NZwABvL1rqCUI=;
 b=MffWi8qpNCFIyvBUTfnoGGYxr82brVe3h68QvpfRrhUnjpXWaBvDVvzu4Uq2fU7J3oLV
 oAnf6Z/r3XDGyX9jhJ1BqwjkID9O8dpthh+bUNtCbICKhJEK4osOVKYJScHfEqeHxubp
 iGqEMg+Eespm6xKXuc7lLSGN8VvZ5vCFxIc41rLHdSPCSPJP5MN8ZX9qBqQ5bjSIol/K
 rLdbr+z8HOcM53WuvWgyQzcxSnCzP1CVANRtLqMt8x8fVfN1ln/MlqzrspWUT19CIqbl
 7h6zSislRyjWMvih5qfc+tSjAZ5P6naznrABqtfeL7AotL8XDhjlU+EUf4qqhG7K8YBQ ig== 
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsdgsa244-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 06:17:13 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31G5k3ne031329;
        Thu, 16 Feb 2023 06:17:11 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3np29fp8v3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 06:17:11 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31G6H7qq44171632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 06:17:07 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDC1C2004D;
        Thu, 16 Feb 2023 06:17:07 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59A3120040;
        Thu, 16 Feb 2023 06:17:07 +0000 (GMT)
Received: from li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com (unknown [9.171.28.250])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
        Thu, 16 Feb 2023 06:17:07 +0000 (GMT)
Date:   Thu, 16 Feb 2023 07:17:05 +0100
From:   Alexander Gordeev <agordeev@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v1 1/1] s390: nmi: fix virtual-physical address confusion
Message-ID: <Y+3KYSnJsznJEX4v@li-4a3a4a4c-28e5-11b2-a85c-a8d192c6f089.ibm.com>
References: <20230215160252.14672-1-nrb@linux.ibm.com>
 <20230215160252.14672-2-nrb@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215160252.14672-2-nrb@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KzHwTlKRbVxEUMabM7UXhfEIDReZekPY
X-Proofpoint-ORIG-GUID: KzHwTlKRbVxEUMabM7UXhfEIDReZekPY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_04,2023-02-15_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 suspectscore=0 mlxlogscore=944 clxscore=1011
 malwarescore=0 adultscore=0 phishscore=0 spamscore=0 lowpriorityscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302160050
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 15, 2023 at 05:02:52PM +0100, Nico Boehr wrote:
> When a machine check is received while in SIE, it is reinjected into the
> guest in some cases. The respective code needs to access the sie_block,
> which is taken from the backed up R14.
> 
> Since reinjection only occurs while we are in SIE (i.e. between the
> labels sie_entry and sie_leave in entry.S and thus if CIF_MCCK_GUEST is
> set), the backed up R14 will always contain a physical address in
> s390_backup_mcck_info.
> 
> This currently works, because virtual and physical addresses are
> the same.
> 
> Add phys_to_virt() to resolve the virtual-physical confusion.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> ---
>  arch/s390/kernel/nmi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
> index 5dbf274719a9..322160328866 100644
> --- a/arch/s390/kernel/nmi.c
> +++ b/arch/s390/kernel/nmi.c
> @@ -347,7 +347,7 @@ static void notrace s390_backup_mcck_info(struct pt_regs *regs)
>  
>  	/* r14 contains the sie block, which was set in sie64a */
>  	struct kvm_s390_sie_block *sie_block =
> -			(struct kvm_s390_sie_block *) regs->gprs[14];
> +			(struct kvm_s390_sie_block *)phys_to_virt(regs->gprs[14]);

Casting to (struct kvm_s390_sie_block *) is not superfluous,
since phys_to_virt() returns (void *).

>  
>  	if (sie_block == NULL)
>  		/* Something's seriously wrong, stop system. */

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
