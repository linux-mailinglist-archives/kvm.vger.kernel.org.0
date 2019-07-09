Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC04363A10
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 19:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbfGIRWE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 13:22:04 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:51898 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfGIRWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 13:22:04 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69HJV5i106130;
        Tue, 9 Jul 2019 17:21:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=QG7Cn5ilNtKmYY+Sw+y1cHv7M7dmnZ2eB20dwustp3g=;
 b=ljaH5H6fiMn7s3EW14oRNzJt+sQvH1CGyyuqeC2jVUtu642GMfoyP14W2zxOvKfo5uET
 q0L8n6kWqmgxAIod5xUtvdbikueSos6F1NX98qyGAv273S4K8R9OhjnFvMzvT4Ey9YIX
 Xb4DFJnidqItMQnxawLQW8w5eYHQmvwtFmDPxYZyKlxYklyICa1Sr3cBilvl0miCWOFK
 L6EaxvWdrtMjKxQAO4PGu5JnYfcT3YxUNwWkmcwPfdSNcZTlMBo17sx+k76fa4Duu+fl
 VPFeaOjBNVVXEKkkJQsa22+lX4aR0khUac4BlFrDvnFiJPUMWWCwvc9Usr4bKwNvujto qQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2tjm9qnn6e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:21:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69HI2lo028495;
        Tue, 9 Jul 2019 17:21:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tjjykx7by-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:21:19 +0000
Received: from abhmp0022.oracle.com (abhmp0022.oracle.com [141.146.116.28])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x69HLHwi020202;
        Tue, 9 Jul 2019 17:21:18 GMT
Received: from [10.159.233.89] (/10.159.233.89)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 10:21:17 -0700
Subject: Re: [Qemu-devel] [PATCH 1/4] target/i386: kvm: Init nested-state for
 VMX when vCPU expose VMX
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, Joao Martins <joao.m.martins@oracle.com>,
        ehabkost@redhat.com, kvm@vger.kernel.org
References: <20190705210636.3095-1-liran.alon@oracle.com>
 <20190705210636.3095-2-liran.alon@oracle.com>
From:   Maran Wilson <maran.wilson@oracle.com>
Organization: Oracle Corporation
Message-ID: <7958e451-b39a-76ae-1b57-dc92572e7b5d@oracle.com>
Date:   Tue, 9 Jul 2019 10:21:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190705210636.3095-2-liran.alon@oracle.com>
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
> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>   target/i386/kvm.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index e4b4f5756a34..b57f873ec9e8 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1714,7 +1714,7 @@ int kvm_arch_init_vcpu(CPUState *cs)
>   
>           env->nested_state->size = max_nested_state_len;
>   
> -        if (IS_INTEL_CPU(env)) {
> +        if (cpu_has_vmx(env)) {
>               struct kvm_vmx_nested_state_hdr *vmx_hdr =
>                   &env->nested_state->hdr.vmx;
>   

Reviewed-by: Maran Wilson <maran.wilson@oracle.com>

Thanks,
-Maran
