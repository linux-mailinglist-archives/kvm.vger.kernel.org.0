Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 614D9FB392
	for <lists+kvm@lfdr.de>; Wed, 13 Nov 2019 16:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbfKMPVF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 10:21:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:34780 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfKMPVE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 10:21:04 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADFEXgq130715;
        Wed, 13 Nov 2019 15:20:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=pkFy/Zp/PcpVu9YbRXp2CC66m0hSTM6eWqI4zwR7HUM=;
 b=N/f85k+pZp18+XULFbjvo9vR6mFUAKV+aStOaSjVWxD8X2AmITGoXp0gyWfbkw+UmUnw
 fxJ4yViRMKJ6MA+grfwqh48GuDrRsk0JNsbA72aIh8EfQ8q1ZJNcwa8K6zYo6Eqk/5MY
 AYI8VjYgtHnfaK/56JKu0SrnQyFUkrU9K4c5cP5ai71C7Mfvg8mjyUihZj5wcTagc8G1
 DaMI/50k2U/X1jr/2Hamho/lxl8R7oMH3MODPWebs9t08+U7p98lxok1dGrQWZEjLrvR
 vErcoFId0U73LWyB2arppzReCXlw1A1VIHnE2AMtMDd+u25JHL4mrEDYFszg4UlcgYem +Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w5ndqd4vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 15:20:56 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xADFEGii154079;
        Wed, 13 Nov 2019 15:20:56 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w7vppehcy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 15:20:55 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xADFKtfx005464;
        Wed, 13 Nov 2019 15:20:55 GMT
Received: from [192.168.14.112] (/79.181.225.209)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 Nov 2019 07:20:54 -0800
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH] KVM: x86: Optimization: Requst TLB flush in
 fast_cr3_switch() instead of do it directly
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <6292b4ef-64df-5e37-dcf7-a359f3268a6f@redhat.com>
Date:   Wed, 13 Nov 2019 17:20:50 +0200
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Bhavesh Davda <bhavesh.davda@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9802964F-4629-46D8-A528-67B0AB5E372B@oracle.com>
References: <20191112183300.6959-1-liran.alon@oracle.com>
 <6292b4ef-64df-5e37-dcf7-a359f3268a6f@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911130142
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9439 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911130142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 13 Nov 2019, at 17:17, Paolo Bonzini <pbonzini@redhat.com> wrote:
>=20
> On 12/11/19 19:33, Liran Alon wrote:
>> When KVM emulates a nested VMEntry (L1->L2 VMEntry), it switches mmu =
root
>> page. If nEPT is used, this will happen from
>> kvm_init_shadow_ept_mmu()->__kvm_mmu_new_cr3() and otherwise it will
>> happpen from nested_vmx_load_cr3()->kvm_mmu_new_cr3(). Either case,
>> __kvm_mmu_new_cr3() will use fast_cr3_switch() in attempt to switch =
to a
>> previously cached root page.
>>=20
>> In case fast_cr3_switch() finds a matching cached root page, it will
>> set it in mmu->root_hpa and request KVM_REQ_LOAD_CR3 such that on
>> next entry to guest, KVM will set root HPA in appropriate hardware
>> fields (e.g. vmcs->eptp). In addition, fast_cr3_switch() calls
>> kvm_x86_ops->tlb_flush() in order to flush TLB as MMU root page
>> was replaced.
>>=20
>> This works as mmu->root_hpa, which vmx_flush_tlb() use, was
>> already replaced in cached_root_available(). However, this may
>> result in unnecessary INVEPT execution because a KVM_REQ_TLB_FLUSH
>> may have already been requested. For example, by prepare_vmcs02()
>> in case L1 don't use VPID.
>>=20
>> Therefore, change fast_cr3_switch() to just request TLB flush on
>> next entry to guest.
>>=20
>> Reviewed-by: Bhavesh Davda <bhavesh.davda@oracle.com>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>> ---
>> arch/x86/kvm/mmu.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index 24c23c66b226..150d982ec1d2 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -4295,7 +4295,7 @@ static bool fast_cr3_switch(struct kvm_vcpu =
*vcpu, gpa_t new_cr3,
>> 			kvm_make_request(KVM_REQ_LOAD_CR3, vcpu);
>> 			if (!skip_tlb_flush) {
>> 				kvm_make_request(KVM_REQ_MMU_SYNC, =
vcpu);
>> -				kvm_x86_ops->tlb_flush(vcpu, true);
>> +				kvm_make_request(KVM_REQ_TLB_FLUSH, =
vcpu);
>> 			}
>>=20
>> 			/*
>>=20
>=20
> Queued, thanks.
>=20
> (I should get kvm/queue properly tested and pushed by the end of this =
week).
>=20
> Paolo
>=20

Thanks.

Also note that I have sent another trivial patch that didn=E2=80=99t got =
any response ("KVM: VMX: Consume pending LAPIC INIT event when exit on =
INIT_SIGNAL=E2=80=9D).
See: https://patchwork.kernel.org/patch/11236869/

I have also sent kvm-unit-tests for my recent patches (The INIT_SIGNAL =
fix and nVMX TPR-Threshold issue).
See: https://patchwork.kernel.org/patch/11236951/ and =
https://patchwork.kernel.org/patch/11236961/

-Liran

