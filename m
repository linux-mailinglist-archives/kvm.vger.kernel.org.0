Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F10D26AB65
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 20:03:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgIOSDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 14:03:06 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47362 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727411AbgIOSB0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Sep 2020 14:01:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FHsLj1101401;
        Tue, 15 Sep 2020 17:58:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=pNW3rt82sSHqqDjP4vSHLYhzjCwLYAMPkCqtg7Nl/7s=;
 b=OCoShOephW8kGU3PmOXez997SQX1mYogfDF8U6Y4lcnrWoaz4ShPQMtx+7Wq4WXsbgRp
 LwaiugZGaaDR3R8RO3zwKM3RtCeYUDPKz0hPErJsR1TZWn+edxTJveH+Y7IouiBM1LyO
 n2g0Nt9UxAk7F8zmofjFf4RXvP4vEtb2MLSUTk/a5ahDmFF4vs6oVoB27ChiJxfRnl8/
 ir5YCm/gm3lyyIbMMyT8o8/ziuDCPS9sWnNYyvGAkwNpOReYLgE5kHqjHxthsRaayM6q
 MrBb6xDZXDlGst48U8RRIpDU/1ZzWr2BRSdRFB/J7CigAwjEzyj/2HVYNLKIzdbaCoXj 7Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 33j91dgar3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Sep 2020 17:58:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08FHtqXM026565;
        Tue, 15 Sep 2020 17:58:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33hm31087y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 17:58:54 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08FHwlk8005756;
        Tue, 15 Sep 2020 17:58:47 GMT
Received: from localhost.localdomain (/10.159.248.187)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 15 Sep 2020 17:58:46 +0000
Subject: Re: [PATCH] KVM: SVM: Get rid of the variable 'exit_fastpath'
To:     lihaiwei.kernel@gmail.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, tglx@linutronix.de, hpa@zytor.com,
        Haiwei Li <lihaiwei@tencent.com>
References: <20200915113033.61817-1-lihaiwei.kernel@gmail.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <e43717a4-cf87-4704-27d5-3d8acce75685@oracle.com>
Date:   Tue, 15 Sep 2020 10:58:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200915113033.61817-1-lihaiwei.kernel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=994
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009150144
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9745 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 mlxlogscore=999
 clxscore=1011 adultscore=0 lowpriorityscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009150144
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 9/15/20 4:30 AM, lihaiwei.kernel@gmail.com wrote:
> From: Haiwei Li <lihaiwei@tencent.com>
>
> 'exit_fastpath' isn't used anywhere else, so remove it.
>
> Suggested-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
> ---
>   arch/x86/kvm/svm/svm.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index c44f3e9..6e88658 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3413,7 +3413,6 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu,
>   
>   static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   {
> -	fastpath_t exit_fastpath;
>   	struct vcpu_svm *svm = to_svm(vcpu);
>   
>   	svm->vmcb->save.rax = vcpu->arch.regs[VCPU_REGS_RAX];
> @@ -3536,8 +3535,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu)
>   		svm_handle_mce(svm);
>   
>   	svm_complete_interrupts(svm);
> -	exit_fastpath = svm_exit_handlers_fastpath(vcpu);
> -	return exit_fastpath;
> +	return svm_exit_handlers_fastpath(vcpu);
>   }
>   
>   static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, unsigned long root,
Reviewed-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
