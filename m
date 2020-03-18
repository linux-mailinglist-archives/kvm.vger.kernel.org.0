Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 328D818A285
	for <lists+kvm@lfdr.de>; Wed, 18 Mar 2020 19:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgCRSkV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Mar 2020 14:40:21 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46722 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgCRSkV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Mar 2020 14:40:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IIcn3A042181;
        Wed, 18 Mar 2020 18:40:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=sLjVWZvpMwWx2eXCxBSd4lEA29TaEzJvkHaAr3aH71E=;
 b=OlTrfFpzt3wNpk/1TwUZrjzjw/A6/Py5RD/7zvESyQEJsQPI/2sVmo0WrxFhINidH4DS
 p3ghzipq54NeyAjgm7G3LgstyyHx5nNqdCQUOdFY7KHI6rzZxOCJ961l0vS8WS+omfvy
 DaOZw4Ui1QLXfD+xDsa/3KMuCDKdWixwIQD8YEb7y2dlI+aiV5qrdl+ThYKyTAc59zl3
 +BdT8shtqFTshogdL5lRw47YfoY2prAD5WhviY8Ugx5BVjpSU0cPVfHJuLgLYBBB+56N
 UW5ap7rhG/8UGmb1H90TlY5orXhfUDykYtvBcn8uYRa4d/27ok8A0p+EY4kK0VHHgeb4 oA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yrq7m49pf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 18:40:17 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02IIbe4b053965;
        Wed, 18 Mar 2020 18:40:16 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 2ys92has9y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Mar 2020 18:40:16 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02IIeFAQ020988;
        Wed, 18 Mar 2020 18:40:15 GMT
Received: from localhost.localdomain (/10.159.130.178)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 18 Mar 2020 11:40:15 -0700
Subject: Re: [PATCH] KVM: nSVM: check for EFER.SVME=1 before entering guest
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
References: <1584535300-6571-1-git-send-email-pbonzini@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <b5cb03b1-9840-f8f5-843a-1eab680d5e8e@oracle.com>
Date:   Wed, 18 Mar 2020 11:40:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1584535300-6571-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 bulkscore=0 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003180083
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9564 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=999 priorityscore=1501 clxscore=1015
 malwarescore=0 mlxscore=0 phishscore=0 impostorscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003180083
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 3/18/20 5:41 AM, Paolo Bonzini wrote:
> EFER is set for L2 using svm_set_efer, which hardcodes EFER_SVME to 1 and hides
> an incorrect value for EFER.SVME in the L1 VMCB.  Perform the check manually
> to detect invalid guest state.
>
> Reported-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>   arch/x86/kvm/svm.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
> index 08568ae9f7a1..2125c6ae5951 100644
> --- a/arch/x86/kvm/svm.c
> +++ b/arch/x86/kvm/svm.c
> @@ -3558,6 +3558,9 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>   
>   static bool nested_vmcb_checks(struct vmcb *vmcb)
>   {
> +	if ((vmcb->save.efer & EFER_SVME) == 0)
> +		return false;
> +
>   	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
>   		return false;
>   

Ah! This now tells me that I forgot the KVM fix that was supposed to 
accompany my patchset.

Do we need this check in software ? I wasn't checking the bit in KVM and 
instead I was just making sure that L0 sets that bit based on the 
setting in nested vmcb:


+static void nested_svm_set_efer(struct kvm_vcpu *vcpu, u64 
nested_vmcb_efer)
+{
+       svm_set_efer(vcpu, nested_vmcb_efer);
+
+       if (!(nested_vmcb_efer & EFER_SVME))
+               to_svm(vcpu)->vmcb->save.efer &= ~EFER_SVME;
+}
+
  static int is_external_interrupt(u32 info)
  {
         info &= SVM_EVTINJ_TYPE_MASK | SVM_EVTINJ_VALID;
@@ -3554,7 +3562,7 @@ static void enter_svm_guest_mode(struct vcpu_svm 
*svm, u64
         svm->vmcb->save.gdtr = nested_vmcb->save.gdtr;
         svm->vmcb->save.idtr = nested_vmcb->save.idtr;
         kvm_set_rflags(&svm->vcpu, nested_vmcb->save.rflags);
-       svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
+       nested_svm_set_efer(&svm->vcpu, nested_vmcb->save.efer);
         svm_set_cr0(&svm->vcpu, nested_vmcb->save.cr0);
         svm_set_cr4(&svm->vcpu, nested_vmcb->save.cr4);
         if (npt_enabled) {

