Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE4F635F95
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 14:29:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237438AbiKWN3L (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 08:29:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236070AbiKWN2c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 08:28:32 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E6915713;
        Wed, 23 Nov 2022 05:07:48 -0800 (PST)
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANBo0SB035921;
        Wed, 23 Nov 2022 13:07:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=b6qT2Vv3sbVzGrxLYwjWoau0u1TuIlIR0E1NVCe+GZ8=;
 b=nHCJfzP2ENww5kXUjVWilJ4Z85lH8UJ6pX4LJkh+AwUU8pCC1c0nGZBQKQNnIXxzU8UB
 isNDxnc9r5Qu/axSZxChPvOrc7bKbgLQWbomzBvuQ7kBANKNcQQb/FK/E7rT2E2RNA6V
 6yuOL03x1opMxxUY4/Rn9DzbVlAIGeOTcgCYUXSqcOsDN1w09wjt+NpRz+/dbh166p3i
 i/VZhr9OATLMWhyG0j9ZLATJrnluEctxAB4I8Dfrb1VbJZmGiqUomPUKOLsj3bBkVtoL
 ApqXvK6z6GvlY7oe3kEdiWtlcdQWF9QvylxvfYEH3XOnH2zjonZ0V/oReMxeKjIHh3p+ oQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x1da3k5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:47 +0000
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2AND7khb016117;
        Wed, 23 Nov 2022 13:07:46 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x1da3hy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:46 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2AND5QYU001260;
        Wed, 23 Nov 2022 13:07:45 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8v6nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 13:07:44 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2AND1Rb049217992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 13:01:27 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD1D6A405B;
        Wed, 23 Nov 2022 13:07:41 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C7A2A4054;
        Wed, 23 Nov 2022 13:07:41 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 13:07:41 +0000 (GMT)
Date:   Wed, 23 Nov 2022 13:47:48 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 4/5] s390x: Clear first stack frame and
 end backtrace early
Message-ID: <20221123134748.13f6c4c1@p-imbrenda>
In-Reply-To: <20221123084656.19864-5-frankja@linux.ibm.com>
References: <20221123084656.19864-1-frankja@linux.ibm.com>
        <20221123084656.19864-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P5zWB8ie_YnSuUfp264TWIjwEkeGp2jL
X-Proofpoint-ORIG-GUID: IQU6YUH9DskPg0B0hG8LD7vbvPPQsLC5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_06,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 impostorscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 suspectscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Nov 2022 08:46:55 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> When setting the first stack frame to 0, we can check for a 0
> backchain pointer when doing backtraces to know when to stop.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/stack.c | 2 ++
>  s390x/cstart64.S  | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/lib/s390x/stack.c b/lib/s390x/stack.c
> index e714e07c..9f234a12 100644
> --- a/lib/s390x/stack.c
> +++ b/lib/s390x/stack.c
> @@ -22,6 +22,8 @@ int backtrace_frame(const void *frame, const void **return_addrs, int max_depth)
>  	for (depth = 0; stack && depth < max_depth; depth++) {
>  		return_addrs[depth] = (void *)stack->grs[8];
>  		stack = stack->back_chain;
> +		if (!stack)
> +			break;
>  	}
>  
>  	return depth;
> diff --git a/s390x/cstart64.S b/s390x/cstart64.S
> index 666a9567..6f83da2a 100644
> --- a/s390x/cstart64.S
> +++ b/s390x/cstart64.S
> @@ -37,6 +37,8 @@ start:
>  	sam64				# Set addressing mode to 64 bit
>  	/* setup stack */
>  	larl	%r15, stackptr
> +	/* Clear first stack frame */
> +	xc      0(160,%r15), 0(%r15)
>  	/* setup initial PSW mask + control registers*/
>  	larl	%r1, initial_psw
>  	lpswe	0(%r1)

