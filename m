Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29A3712E6AB
	for <lists+kvm@lfdr.de>; Thu,  2 Jan 2020 14:24:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgABNYA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jan 2020 08:24:00 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36064 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbgABNYA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jan 2020 08:24:00 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002DMQkW074848;
        Thu, 2 Jan 2020 13:22:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=E58dPgAUN7qsIQeKA+zHJ3+zUCt1y/EVyKTFMcsGSJo=;
 b=Kz+SHpD4btPYSgwtW5zjM8cC7w79xYikWd8b5pXBtTC9WjddOHkgjQm94e1yHvtva4TB
 6MtgKIVaGC1+QOYaPLo2dPZ+kWeiju5DFyR1URrrVBEXT4I3a+Sn0S/w8qHFzb2ggUn6
 FBSvVF7WsKrMVru9PB0BzFlzkPXONFNqkOmPRrjVuYq6HOq4PwRZOMryOolAtNMvWgGd
 0sWDqUy9UtD3vFF+7LUgKWqhiQEMJ67ZU+MRMOudg7pVz3tVE6FNyiTB5dDoUFpRLTW+
 jGTW6RBcnHV7iifq9Lwjx87pyu/wkP+0PvyzSuxF+yHRL6EV6pbMN8apm9l7f1ExciaA Tw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 2x5ypqq8mc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 13:22:26 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 002DJ8UU066806;
        Thu, 2 Jan 2020 13:22:26 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gjajhxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Jan 2020 13:22:26 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 002DMLiO004117;
        Thu, 2 Jan 2020 13:22:21 GMT
Received: from [192.168.14.112] (/79.178.220.19)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Jan 2020 05:22:21 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: SVM: Fix potential memory leak in svm_cpu_init()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <1577931640-29420-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 2 Jan 2020 15:22:14 +0200
Cc:     Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <BEE0CD6D-B921-4FFE-ADD6-76A7A170C2B0@oracle.com>
References: <1577931640-29420-1-git-send-email-linmiaohe@huawei.com>
To:     linmiaohe <linmiaohe@huawei.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001020120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001020120
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 2 Jan 2020, at 4:20, linmiaohe <linmiaohe@huawei.com> wrote:
> 
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> When kmalloc memory for sd->sev_vmcbs failed, we forget to free the page
> held by sd->save_area.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Reviewed-by: Liran Alon <liran.alon@oracle.com>

-Liran

> ---
> arch/x86/kvm/svm.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 8f1b715dfde8..89eb382e8580 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -1012,7 +1012,7 @@ static int svm_cpu_init(int cpu)
> 	r = -ENOMEM;
> 	sd->save_area = alloc_page(GFP_KERNEL);
> 	if (!sd->save_area)
> -		goto err_1;
> +		goto free_cpu_data;
> 
> 	if (svm_sev_enabled()) {
> 		r = -ENOMEM;
> @@ -1020,14 +1020,16 @@ static int svm_cpu_init(int cpu)
> 					      sizeof(void *),
> 					      GFP_KERNEL);
> 		if (!sd->sev_vmcbs)
> -			goto err_1;
> +			goto free_save_area;
> 	}
> 
> 	per_cpu(svm_data, cpu) = sd;
> 
> 	return 0;
> 
> -err_1:
> +free_save_area:
> +	__free_page(sd->save_area);
> +free_cpu_data:
> 	kfree(sd);
> 	return r;
> 
> -- 
> 2.19.1
> 

