Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3109C63A11
	for <lists+kvm@lfdr.de>; Tue,  9 Jul 2019 19:22:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfGIRWM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Jul 2019 13:22:12 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:58732 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725816AbfGIRWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Jul 2019 13:22:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69HItej094709;
        Tue, 9 Jul 2019 17:21:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=MjEJhBt7sS82dhXCnwYDQHj5u/g/AGE0b3Hpz5Cr1NA=;
 b=u6NPtatca4FUH8oCXACu7G7vB7R+mVFJZ/mVqTa3nry33wQW20DellT1B4vypv4K0gnz
 fJKQr6/pWaqNaiLnvD0d0l/idlyjBKs7PIZvOAj9y8pfrNb/Lwwt6n3T7eqzcSc8M4nj
 aWdB67nmpcK+Wtf4wNAZuZvQlTgMhKf61Zo6LhOydVTHVpXxybiIjbXGL5MvCGArgcA3
 dhnS64369LjXp24gWTF9NIgUjauWyhXwtAROe5WbLjwyy1eDH2fcCvHGsog6TTs9f8WX
 P6AYm2mzGpphWiFlass+mQzaEcyrC+5oyjQFMP657OWTSX8vgQWP2/p2npkD6ANDUxFZ 4w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2tjk2tnqx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:21:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x69HI1Wx160262;
        Tue, 9 Jul 2019 17:21:26 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 2tjgru7ufk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Jul 2019 17:21:25 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x69HLOe1023541;
        Tue, 9 Jul 2019 17:21:24 GMT
Received: from [10.159.233.89] (/10.159.233.89)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 09 Jul 2019 10:21:24 -0700
Subject: Re: [Qemu-devel] [PATCH 2/4] target/i386: kvm: Init nested-state for
 vCPU exposed with SVM
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, Joao Martins <joao.m.martins@oracle.com>,
        ehabkost@redhat.com, kvm@vger.kernel.org
References: <20190705210636.3095-1-liran.alon@oracle.com>
 <20190705210636.3095-3-liran.alon@oracle.com>
From:   Maran Wilson <maran.wilson@oracle.com>
Organization: Oracle Corporation
Message-ID: <0608e757-148b-4125-6d0a-9b3700f1cc4a@oracle.com>
Date:   Tue, 9 Jul 2019 10:21:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190705210636.3095-3-liran.alon@oracle.com>
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
>   target/i386/cpu.h | 5 +++++
>   target/i386/kvm.c | 2 ++
>   2 files changed, 7 insertions(+)
>
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 93345792f4cb..cdb0e43676a9 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -1867,6 +1867,11 @@ static inline bool cpu_has_vmx(CPUX86State *env)
>       return env->features[FEAT_1_ECX] & CPUID_EXT_VMX;
>   }
>   
> +static inline bool cpu_has_svm(CPUX86State *env)
> +{
> +    return env->features[FEAT_8000_0001_ECX] & CPUID_EXT3_SVM;
> +}
> +
>   /* fpu_helper.c */
>   void update_fp_status(CPUX86State *env);
>   void update_mxcsr_status(CPUX86State *env);
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index b57f873ec9e8..4e2c8652168f 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1721,6 +1721,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>               env->nested_state->format = KVM_STATE_NESTED_FORMAT_VMX;
>               vmx_hdr->vmxon_pa = -1ull;
>               vmx_hdr->vmcs12_pa = -1ull;
> +        } else if (cpu_has_svm(env)) {
> +            env->nested_state->format = KVM_STATE_NESTED_FORMAT_SVM;
>           }
>       }
>   

Reviewed-by: Maran Wilson <maran.wilson@oracle.com>

Thanks,
-Maran
