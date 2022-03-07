Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618DA4D0303
	for <lists+kvm@lfdr.de>; Mon,  7 Mar 2022 16:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243821AbiCGPfo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Mar 2022 10:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243816AbiCGPfm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Mar 2022 10:35:42 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200015C373;
        Mon,  7 Mar 2022 07:34:46 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 227EonEC013109;
        Mon, 7 Mar 2022 15:34:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=QGM+yqhdKHtbTG+/66I+DTOp6TBqe/SRi5/4WabC61c=;
 b=D8I9dJDJuwnbpufY7MbhCkUxKiYwjEwlZsjBKiPD04QcmZGyq4R/jJjFkmCuxBucXUbW
 w8VjrlPdukYsnPjLtN6uOA7CkGx47HXkdX/MZbtmfI9ZN/4cSjUP8IaOjS0v2HJtndCd
 JLBv6xcOZfYn10ZsbdYelUJheRjQpIjSGL1Hdt3Z7Sf924lbwg5JR5CnRDEb03f9znwQ
 B1mmOfLWDfDC76Z9PjniKYtbAaZ1feNOuFIUMs14erloVW/rdMRkBirLs1KGwL4SREyU
 GsO06/FC0x+E7+ow/iZoqCemHmhZ6knJ3Z0gZwxSVgOqstKkMMpLjqGNpmhlt7R+IgSX jQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enm60h0mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:45 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 227FCIgO017787;
        Mon, 7 Mar 2022 15:34:44 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3enm60h0me-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:44 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 227FIfr6027007;
        Mon, 7 Mar 2022 15:34:43 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 3ekyg8vax7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Mar 2022 15:34:42 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 227FYdOI55312646
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Mar 2022 15:34:39 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA284A405B;
        Mon,  7 Mar 2022 15:34:39 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6417EA4054;
        Mon,  7 Mar 2022 15:34:39 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.106])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Mar 2022 15:34:39 +0000 (GMT)
Date:   Mon, 7 Mar 2022 16:20:43 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests v1 1/6] lib: s390x: smp: Retry SIGP SENSE
 on CC2
Message-ID: <20220307162043.7b6213ff@p-imbrenda>
In-Reply-To: <20220303210425.1693486-2-farman@linux.ibm.com>
References: <20220303210425.1693486-1-farman@linux.ibm.com>
        <20220303210425.1693486-2-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bMnkG-It2Ogvqc-LoiwdgbaeZDoyN1KZ
X-Proofpoint-GUID: WtQHUpDmOEjRjPlR1uuqHd-diamik5Jw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-07_05,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 mlxscore=0
 lowpriorityscore=0 suspectscore=0 impostorscore=0 malwarescore=0
 adultscore=0 bulkscore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203070090
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Mar 2022 22:04:20 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> The routine smp_cpu_stopped() issues a SIGP SENSE, and returns true
> if it received a CC1 (STATUS STORED) with the STOPPED or CHECK STOP
> bits enabled. Otherwise, it returns false.
> 
> This is misleading, because a CC2 (BUSY) merely indicates that the
> order code could not be processed, not that the CPU is operating.
> It could be operating but in the process of being stopped.
> 
> Convert the invocation of the SIGP SENSE to retry when a CC2 is
> received, so we get a more definitive answer.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/smp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/smp.c b/lib/s390x/smp.c
> index 46e1b022..368d6add 100644
> --- a/lib/s390x/smp.c
> +++ b/lib/s390x/smp.c
> @@ -78,7 +78,7 @@ bool smp_cpu_stopped(uint16_t idx)
>  {
>  	uint32_t status;
>  
> -	if (smp_sigp(idx, SIGP_SENSE, 0, &status) !=
> SIGP_CC_STATUS_STORED)
> +	if (smp_sigp_retry(idx, SIGP_SENSE, 0, &status) !=
> SIGP_CC_STATUS_STORED) return false;
>  	return !!(status &
> (SIGP_STATUS_CHECK_STOP|SIGP_STATUS_STOPPED)); }

