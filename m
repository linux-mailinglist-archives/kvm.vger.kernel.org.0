Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF9C699434
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 13:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbjBPMWe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 07:22:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBPMWc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 07:22:32 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BC0359A;
        Thu, 16 Feb 2023 04:22:31 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31GAHEcF021092;
        Thu, 16 Feb 2023 12:22:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Atm6aCLZ5iKwcIIJpb+5ED5BPmQrD9wAXdpgFC4bOgc=;
 b=OD5PjhUvv9ExeXWaohudaTZSEeNVbs76HKO3qN+cJXkfTQiBl1YcX48HEau+10PDHCHu
 61wYP1UW/WMiz9o3hxkSF6e98STHQmVTktaa507rEukNJU4sdDuiIX8VHRdKiz0I8Y97
 t0QaaYA01D0xvLh62A5s1bVT+RXKMUtd672Q9t3vFE+vioR69KA6pJi7CQs0dGWtUCjY
 WidQzIDqyW4efy+sjHeUpoZxnGmedwn0hvkFXhEGVGJ4zUJmfrorQL1T6YzmJH9E6vwA
 t8VmJ1m9SMjS2StzHD06IVsd8FXl/6XumgxGzcLdwD91QLUWJzrf5pNrFeYDcsEWaton sQ== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nsg20pdxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 12:22:30 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31FMFBee032205;
        Thu, 16 Feb 2023 12:22:29 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma01fra.de.ibm.com (PPS) with ESMTPS id 3np2n6cws4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 16 Feb 2023 12:22:29 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31GCMPKe35455430
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 16 Feb 2023 12:22:25 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 45C432004B;
        Thu, 16 Feb 2023 12:22:25 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F08B120043;
        Thu, 16 Feb 2023 12:22:24 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 16 Feb 2023 12:22:24 +0000 (GMT)
Date:   Thu, 16 Feb 2023 13:22:23 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        agordeev@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 1/1] s390: nmi: fix virtual-physical address
 confusion
Message-ID: <20230216132223.43681bf7@p-imbrenda>
In-Reply-To: <20230216121208.4390-2-nrb@linux.ibm.com>
References: <20230216121208.4390-1-nrb@linux.ibm.com>
        <20230216121208.4390-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uCpFPhT1RjsKwjeK2WvclIGswQl0_A4p
X-Proofpoint-ORIG-GUID: uCpFPhT1RjsKwjeK2WvclIGswQl0_A4p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-16_09,2023-02-16_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 suspectscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 bulkscore=0 adultscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2212070000 definitions=main-2302160098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Feb 2023 13:12:08 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

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

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/kernel/nmi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kernel/nmi.c b/arch/s390/kernel/nmi.c
> index 5dbf274719a9..56d9c559afa1 100644
> --- a/arch/s390/kernel/nmi.c
> +++ b/arch/s390/kernel/nmi.c
> @@ -346,8 +346,7 @@ static void notrace s390_backup_mcck_info(struct pt_regs *regs)
>  	struct sie_page *sie_page;
>  
>  	/* r14 contains the sie block, which was set in sie64a */
> -	struct kvm_s390_sie_block *sie_block =
> -			(struct kvm_s390_sie_block *) regs->gprs[14];
> +	struct kvm_s390_sie_block *sie_block = phys_to_virt(regs->gprs[14]);
>  
>  	if (sie_block == NULL)
>  		/* Something's seriously wrong, stop system. */

