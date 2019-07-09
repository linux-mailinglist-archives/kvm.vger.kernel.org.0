Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5723363A13
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 19:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfGIRWw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 13:22:52 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:59246 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726458AbfGIRWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 13:22:52 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69HIxZh094804;
        Tue, 9 Jul 2019 17:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=Wv0QUFTPKvZPvBylNpFSHK+beuMbdZ6PAa8/4zex8pU=;
 b=f5Wyiq713b1LDv5QQVmhayE2rDpYLQH0yecZBlW07bR/zVghQ6J1qqu4ntdJSARAW/Xk
 AbcNX1IiNw5DG78qBaO4yri3Khb+u+A08+CF4qTbMcaxhsmX/rH5yf3oMZUWGQxAwljk
 MOBN5TTltVf431N3644U/JyDbyf0Dxvk/9rl8vqboSG1piy8GAOwYwpijHeHQ3Lbkr02
 KbdClQ7PFfsc5fFnC9sBhfJJsgiUwnykUL4ZKRhiUpcrDuHQDy6KjG6AEjwBnjsAW+P5
 4Se6be5EN+5i31J034NL3m0C8qfkGSXFvVhgiEbEo1gmcZaKdZ8a074a0BUKPwx2fRv0 nA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2tjk2tnqxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:21:35 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69HHwUE028387;
        Tue, 9 Jul 2019 17:21:34 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2tjjykx7fh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:21:34 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x69HLXgR013704;
        Tue, 9 Jul 2019 17:21:33 GMT
Received: from [10.159.233.89] (/10.159.233.89)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 10:21:33 -0700
Subject: Re: [Qemu-devel] [PATCH 3/4] target/i386: kvm: Save nested-state only
 in case vCPU have set VMXON region
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, Joao Martins <joao.m.martins@oracle.com>,
        ehabkost@redhat.com, kvm@vger.kernel.org
References: <20190705210636.3095-1-liran.alon@oracle.com>
 <20190705210636.3095-4-liran.alon@oracle.com>
From:   Maran Wilson <maran.wilson@oracle.com>
Organization: Oracle Corporation
Message-ID: <f264c433-facc-5316-e3e7-11a7bb97ea7a@oracle.com>
Date:   Tue, 9 Jul 2019 10:21:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190705210636.3095-4-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907090204
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9313 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907090204
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/5/2019 2:06 PM, Liran Alon wrote:
> Having (nested_state->hdr.vmx.vmxon_pa != -1ull) signals that vCPU have set
> at some point in time a VMXON region. Note that even though when vCPU enters
> SMM mode it temporarily exit VMX operation, KVM still reports (vmxon_pa != -1ull).
> Therefore, this field can be used as a reliable indicator on when we require to

s/on when we require/for when we are required/

Also, note that you have commit message lines are longer than 76 
characters (longer than 80, for that matter).

But aside from those nits:

Reviewed-by: Maran Wilson <maran.wilson@oracle.com>

Thanks,
-Maran

> send VMX nested-state as part of migration stream.
>
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>   target/i386/machine.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 851b249d1a39..20bda9f80154 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -997,9 +997,8 @@ static bool vmx_nested_state_needed(void *opaque)
>   {
>       struct kvm_nested_state *nested_state = opaque;
>   
> -    return ((nested_state->format == KVM_STATE_NESTED_FORMAT_VMX) &&
> -            ((nested_state->hdr.vmx.vmxon_pa != -1ull) ||
> -             (nested_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON)));
> +    return (nested_state->format == KVM_STATE_NESTED_FORMAT_VMX) &&
> +           (nested_state->hdr.vmx.vmxon_pa != -1ull);
>   }
>   
>   static const VMStateDescription vmstate_vmx_nested_state = {

