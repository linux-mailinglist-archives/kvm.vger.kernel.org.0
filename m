Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5BA2FEF3D
	for <lists+kvm@lfdr.de>; Thu, 21 Jan 2021 16:44:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733236AbhAUPm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Jan 2021 10:42:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39676 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733185AbhAUPmQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Jan 2021 10:42:16 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LFWRhs073514;
        Thu, 21 Jan 2021 10:41:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=LQEFsMUUTQDsJs61V/Z80GR7yZ2xEqRbbbkdvaivo6s=;
 b=IB86BBbqi6FwKtZvjABRgqtjhiJ9wx8Cp+WR/MsdVAK04OD0SUs3y73ShCej5yfoWoAZ
 qLdW/oxJ1+ds5fmgW5y1LZN5+v3lIUIZq1I6rlT3Ug4l82xjsmbv8nIkCUNuqokrQFAY
 W3UEPMItaz16ZjS+zPDqxpo93rmwYhzHC2wMY32hRWu7BAxP34fKaqAClsgIsYHD+eVq
 azOPG3orq27oihRUSxqg439+bbQDSOrIpKrKsldm6DbdrJojyvUJzwv7+VLF9iVamOcK
 Emiylx1zsP8RHB5tv2EusRVDFDbGQlRTkYDAwB+uZ8gypZ7AKol1qNdjrQa7ySMhHCQf OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367c8h8j2k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:41:32 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LFXfdK084843;
        Thu, 21 Jan 2021 10:41:32 -0500
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367c8h8j0v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 10:41:32 -0500
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LFXBZf007106;
        Thu, 21 Jan 2021 15:41:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03fra.de.ibm.com with ESMTP id 3668ny0x6y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 15:41:30 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LFfRet43188612
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 15:41:27 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6E3904C044;
        Thu, 21 Jan 2021 15:41:27 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EF2F34C040;
        Thu, 21 Jan 2021 15:41:26 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.91.116])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 15:41:26 +0000 (GMT)
Subject: Re: [PATCH v2 2/2] s390: mm: Fix secure storage access exception
 handling
To:     Janosch Frank <frankja@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, thuth@redhat.com, david@redhat.com,
        imbrenda@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, gor@linux.ibm.com, hca@linux.ibm.com,
        mihajlov@linux.ibm.com
References: <20210121151436.417240-1-frankja@linux.ibm.com>
 <20210121151436.417240-3-frankja@linux.ibm.com>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <a1d228f4-0710-bdaa-a923-d2ca24cff9f7@de.ibm.com>
Date:   Thu, 21 Jan 2021 16:41:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210121151436.417240-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_08:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 clxscore=1011 bulkscore=0 phishscore=0 mlxscore=0 spamscore=0
 impostorscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101210085
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 21.01.21 16:14, Janosch Frank wrote:
> Turns out that the bit 61 in the TEID is not always 1 and if that's
> the case the address space ID and the address are
> unpredictable. Without an address and its address space ID we can't
> export memory and hence we can only send a SIGSEGV to the process or
> panic the kernel depending on who caused the exception.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: 084ea4d611a3d ("s390/mm: add (non)secure page access exceptions handlers")
> Cc: stable@vger.kernel.org

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

we should let it run in our CI for some days, though.

> ---
>  arch/s390/mm/fault.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index e30c7c781172..3e8685ad938d 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -791,6 +791,20 @@ void do_secure_storage_access(struct pt_regs *regs)
>  	struct page *page;
>  	int rc;
>  
> +	/* There are cases where we don't have a TEID. */
> +	if (!(regs->int_parm_long & 0x4)) {
> +		/*
> +		 * When this happens, userspace did something that it
> +		 * was not supposed to do, e.g. branching into secure
> +		 * memory. Trigger a segmentation fault.
> +		 */
> +		if (user_mode(regs)) {
> +			send_sig(SIGSEGV, current, 0);
> +			return;
> +		} else
> +			panic("Unexpected PGM 0x3d with TEID bit 61=0");
> +	}
> +
>  	switch (get_fault_type(regs)) {
>  	case USER_FAULT:
>  		mm = current->mm;
> 
