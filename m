Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC15A322E9D
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 17:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbhBWQUQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 11:20:16 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61102 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233500AbhBWQUL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 11:20:11 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11NG47ac179109
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 11:19:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=to : cc : references :
 from : subject : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=xaHANsgD7Lkilhm4187HXP9MTRXqJYauwUW6a4KBmeE=;
 b=IuSlMRxs+85u/TXXZlhgArlqr2bbl8DoI5bwm61a6oPJOBXkKqVV3bhm/SYacHAAsEtN
 zGJ3u+X4AFa94xYpp4goCM+ZhmRrnWPqK+Ywwkw2pFtsnu++Fjugu8ayLQVa/ku6pyVN
 FDTzTGstzML/j/21lIO83OdYdEU7GqwUKuxbC8VWhxKZouqgtn9YISbwSJB2lI6yfQlR
 pKKr3LkZbEW2OE6OsAgfEKoI9zk8DzmKzCdnJgnvhmIwwMQcjH7rIT3Pd67XR/o6sXpW
 PuxRfto3sKQHBl6jq62iN4lSatIZbaviqCXYmGvGTEoHv9Beq7DsOnDKxZx8J19MGZ4M DQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vwmpg5vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 11:19:28 -0500
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 11NG5ulo192704
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 11:19:27 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36vwmpg5ue-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 11:19:27 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11NGDaCY020218;
        Tue, 23 Feb 2021 16:19:25 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 36tsph9f2j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 23 Feb 2021 16:19:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11NGJMoc24117750
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 16:19:22 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 825DFA405B;
        Tue, 23 Feb 2021 16:19:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1AC3CA4054;
        Tue, 23 Feb 2021 16:19:22 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.145.67.183])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 23 Feb 2021 16:19:22 +0000 (GMT)
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     david@redhat.com, thuth@redhat.com, cohuck@redhat.com,
        pmorel@linux.ibm.com, borntraeger@de.ibm.com
References: <20210223142429.256420-1-imbrenda@linux.ibm.com>
 <20210223142429.256420-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: introduce leave_pstate to
 leave userspace
Message-ID: <6eb8c9eb-d5af-2790-1855-8b85693ef3e8@linux.ibm.com>
Date:   Tue, 23 Feb 2021 17:19:21 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210223142429.256420-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-23_08:2021-02-23,2021-02-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102230135
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/23/21 3:24 PM, Claudio Imbrenda wrote:
> In most testcases, we enter problem state (userspace) just to test if a
> privileged instruction causes a fault. In some cases, though, we need
> to test if an instruction works properly in userspace. This means that
> we do not expect a fault, and we need an orderly way to leave problem
> state afterwards.
> 
> This patch introduces a simple system based on the SVC instruction.
> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h |  7 +++++++
>  lib/s390x/interrupt.c    | 12 ++++++++++--
>  2 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 9c4e330a..4cf8eb11 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -173,6 +173,8 @@ struct cpuid {
>  	uint64_t reserved : 15;
>  };
>  
> +#define SVC_LEAVE_PSTATE 1
> +
>  static inline unsigned short stap(void)
>  {
>  	unsigned short cpu_address;
> @@ -276,6 +278,11 @@ static inline void enter_pstate(void)
>  	load_psw_mask(mask);
>  }
>  
> +static inline void leave_pstate(void)
> +{
> +	asm volatile("	svc %0\n" : : "i" (SVC_LEAVE_PSTATE));
> +}

When we add other svc calls then we should create a svc(int code)
function and call it here.

> +
>  static inline int stsi(void *addr, int fc, int sel1, int sel2)
>  {
>  	register int r0 asm("0") = (fc << 28) | sel1;
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 1ce36073..d0567845 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -188,6 +188,14 @@ int unregister_io_int_func(void (*f)(void))
>  
>  void handle_svc_int(void)
>  {
> -	report_abort("Unexpected supervisor call interrupt: on cpu %d at %#lx",
> -		     stap(), lc->svc_old_psw.addr);
> +	uint16_t code = lc->svc_int_code;
> +
> +	switch (code) {
> +	case SVC_LEAVE_PSTATE:
> +		lc->svc_old_psw.mask &= ~PSW_MASK_PSTATE;
> +		break;
> +	default:
> +		report_abort("Unexpected supervisor call interrupt: code %#x on cpu %d at %#lx",
> +			      code, stap(), lc->svc_old_psw.addr);
> +	}
>  }
> 

