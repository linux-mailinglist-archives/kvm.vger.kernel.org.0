Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFAB2FBA52
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 15:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404935AbhASOvc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 09:51:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38124 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731792AbhASKZt (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 05:25:49 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JA1qu1108016;
        Tue, 19 Jan 2021 05:25:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=pgYnaDBcGzQvvTYzK7pOnwJ5e4+vRCWmcZJYVbWE1gs=;
 b=Ee1jaTQAhDYncy0A5+lAG5sS/RwP+fe4LLXC0re7iUKTRdpvhAP5iHmvjw1N1jh6zRnb
 muxkC6EcWSuR3ekExsgbQpfcddCRSqfp98KnOE0dAy7vXrPq622ZKzhArN8YMf5SRxdf
 a/pf1H/IfgmldiRRffYjh+4mSPDL0MSLRT6dZeItM/HgcNR8B8PfgMhMq42H3MdP1T/x
 Q98S5EqA5PTDg6eYwiSo4Fp16lLVJw6yw+Il5by55izkVyrqB4AbhJLRAgQR7mM/v7UZ
 sY2PO/RplTqpOTHGTQVg2sY+za+DyBbSYHkksIqGFOMS3sCpt7raIALJ+wgxkmyerRU9 lg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365w3xgypg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:25:08 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JA1rnE108029;
        Tue, 19 Jan 2021 05:25:08 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 365w3xgyna-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 05:25:08 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JAHTeJ021306;
        Tue, 19 Jan 2021 10:25:05 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 365s0e83y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 10:25:05 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JAOuR223396608
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 10:24:56 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7021E4C050;
        Tue, 19 Jan 2021 10:25:02 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E13C04C04E;
        Tue, 19 Jan 2021 10:25:01 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.35.184])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 10:25:01 +0000 (GMT)
Subject: Re: [PATCH 2/2] s390: mm: Fix secure storage access exception
 handling
To:     Janosch Frank <frankja@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com,
        mihajlov@linux.ibm.com
References: <20210119100402.84734-1-frankja@linux.ibm.com>
 <20210119100402.84734-3-frankja@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <3e1978c6-4462-1de6-e1aa-e664ffa633c1@de.ibm.com>
Date:   Tue, 19 Jan 2021 11:25:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210119100402.84734-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 clxscore=1015 mlxscore=0 mlxlogscore=999 bulkscore=0 priorityscore=1501
 spamscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101190058
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 19.01.21 11:04, Janosch Frank wrote:
> Turns out that the bit 61 in the TEID is not always 1 and if that's
> the case the address space ID and the address are
> unpredictable. Without an address and it's address space ID we can't
> export memory and hence we can only send a SIGSEGV to the process or
> panic the kernel depending on who caused the exception.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: 084ea4d611a3d ("s390/mm: add (non)secure page access exceptions handlers")
> Cc: stable@vger.kernel.org

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

some small things to consider (or to reject)

> ---
>  arch/s390/mm/fault.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index e30c7c781172..5442937e5b4b 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -791,6 +791,20 @@ void do_secure_storage_access(struct pt_regs *regs)
>  	struct page *page;
>  	int rc;
>  
> +	/* There are cases where we don't have a TEID. */
> +	if (!(regs->int_parm_long & 0x4)) {
> +		/*
> +		 * Userspace could for example try to execute secure
> +		 * storage and trigger this. We should tell it that it
> +		 * shouldn't do that.

Maybe something like
		/*
		 * when this happens, userspace did something that it
		 * was not supposed to do, e.g. branching into secure
		 * secure memory. Trigger a segmentation fault.
> +		 */
> +		if (user_mode(regs)) {
> +			send_sig(SIGSEGV, current, 0);
> +			return;
> +		} else
> +			panic("Unexpected PGM 0x3d with TEID bit 61=0");

use BUG instead of panic? That would kill this process, but it allows
people to maybe save unaffected data.
