Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D67537223CF
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 12:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbjFEKrf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 06:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjFEKre (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 06:47:34 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EE7F1;
        Mon,  5 Jun 2023 03:47:33 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355AStAr010277;
        Mon, 5 Jun 2023 10:47:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=XWGlW8qgdGJmU8E+7lgLh+iFYLGOxM2q/pVMYNxZkzM=;
 b=Kj5Jz+PSyKTmAxrVOZtUeugNx/cSGOg+wsPIm3530GnMO8z/4nmhSRyVcoylmUA0fFBr
 0DSfpv1YzXI752dK66PpAEdjJDx9T2XVWJUukInDnNwpnXG0aHTe2kbsRGmf7DqPz9j6
 /x4SILx3yYlu/AlDJ0SMqYbrq2EbsNnLL/n8EnzZABy+28Us3FcChtP7uSVliAYkNMwu
 ZuuBCfrBhd2wHlTD5F6IHAM0TwdgBoU3kpteTk88HtoOMu2ZuCPTu1W84B0iADjcu5ua
 cUPg09BMaLj0eQJN7G1q0wdlI6JVrw+MUlLskPg1E3jNxxhCxajFYfhP4llaou6S3Trn vA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1e08gdp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 10:47:32 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 355AUjks016334;
        Mon, 5 Jun 2023 10:47:31 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1e08gdnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 10:47:31 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3555SdkS014880;
        Mon, 5 Jun 2023 10:47:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3qyxbu914h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 10:47:29 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 355AlQKE6030018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 10:47:26 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55D3C2004F;
        Mon,  5 Jun 2023 10:47:26 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2D68820043;
        Mon,  5 Jun 2023 10:47:26 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 10:47:26 +0000 (GMT)
Date:   Mon, 5 Jun 2023 12:42:14 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 4/6] s390x: lib: don't forward PSW
 when handling exception in SIE
Message-ID: <20230605124214.46bc7f94@p-imbrenda>
In-Reply-To: <20230601070202.152094-5-nrb@linux.ibm.com>
References: <20230601070202.152094-1-nrb@linux.ibm.com>
        <20230601070202.152094-5-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 1d446GsDWAK-eW5TVHDIeIWHjZYnh8YB
X-Proofpoint-ORIG-GUID: 5wfrRndYQxatzTCFlCWNGi6EyuSl3G_B
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1011
 mlxlogscore=999 malwarescore=0 priorityscore=1501 suspectscore=0
 adultscore=0 bulkscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  1 Jun 2023 09:02:00 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> When we're handling a pgm int in SIE, we want to return to the SIE
> cleanup after handling the exception. That's why we set pgm_old_psw to
> the sie_exit label in fixup_pgm_int.
> 
> On nullifing pgm ints, fixup_pgm_int will also forward the old PSW such
> that we don't cause an pgm int again.
> 
> However, when we want to return to the sie_exit label, this is not
> needed (since we've manually set pgm_old_psw). Instead, forwarding the
> PSW might cause us to skip an instruction or end up in the middle of an
> instruction.
> 
> So, let's just skip the rest of the fixup in case we're inside SIE.
> 
> Note that we're intentionally not fixing up the PSW in the guest; that's
> best left to the test at hand by registering their own psw fixup.
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/interrupt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index d97b5a3a7e97..3f07068877ee 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -145,6 +145,7 @@ static void fixup_pgm_int(struct stack_frame_int *stack)
>  	if (lowcore.pgm_old_psw.addr >= (uint64_t)&sie_entry &&
>  	    lowcore.pgm_old_psw.addr <= (uint64_t)&sie_exit) {
>  		lowcore.pgm_old_psw.addr = (uint64_t)&sie_exit;
> +		return;
>  	}
>  
>  	switch (lowcore.pgm_int_code) {

