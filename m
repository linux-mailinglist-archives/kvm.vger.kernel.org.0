Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60B83F7749
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 16:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfKKPAY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 10:00:24 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44204 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKPAX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 10:00:23 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABEmYWN112065;
        Mon, 11 Nov 2019 15:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2019-08-05; bh=itWzv1khxDVQnIj5NruSBlZmnfQMjgbtR2kHUGi2kjg=;
 b=VYplmCNZ1jxvN1lAWaJblHPEN2NtB0TyiEuiX3EGR1EA4Gg0Vdmy6sur/1ZAaVFK/aS2
 hs/k846gOu4MXscy8LE47V/3dD7rsK+Ks8njSuBwcBsiQNG6tS+hp0d5EK7JvrWq2Kv8
 nT6ifIkrrYoLkeI0evKL/ErxFHaUj9zH55Ggk1cuUHZlOlf02uw/VNz+xBavkJtCumfm
 CSaUbd0sPFAlMCpOnBO3JijkmZgzG9pPOitMpTQZyxuqKwT1chEEXJul1jSgBHCcIWd9
 O5ZZtt38DClEjuH9sKWr8AxdNxmhIjxoHlAAoM9diYOlFnmeZyBgiKwPQUihjH78fsIT DQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w5p3qfbp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 15:00:16 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABEmU87124633;
        Mon, 11 Nov 2019 15:00:16 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2w66yxxf8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 15:00:15 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xABF0Ene012397;
        Mon, 11 Nov 2019 15:00:14 GMT
Received: from [192.168.14.112] (/79.182.207.213)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 07:00:14 -0800
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Subject: Re: [PATCH 1/2] KVM: VMX: Refactor update_cr8_intercept()
From:   Liran Alon <liran.alon@oracle.com>
In-Reply-To: <de93a7b8-d0b6-33b2-2039-ad836fcfab1e@redhat.com>
Date:   Mon, 11 Nov 2019 17:00:11 +0200
Cc:     rkrcmar@redhat.com, kvm@vger.kernel.org,
        sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
Content-Transfer-Encoding: 7bit
Message-Id: <30BFAF3B-EB5A-4121-B53D-9FD594CFF92E@oracle.com>
References: <20191111123055.93270-1-liran.alon@oracle.com>
 <20191111123055.93270-2-liran.alon@oracle.com>
 <de93a7b8-d0b6-33b2-2039-ad836fcfab1e@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3445.4.7)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=938
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On 11 Nov 2019, at 16:57, Paolo Bonzini <pbonzini@redhat.com> wrote:
> 
> On 11/11/19 13:30, Liran Alon wrote:
>> No functional changes.
>> 
>> Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
>> ---
>> arch/x86/kvm/vmx/vmx.c | 9 +++------
>> 1 file changed, 3 insertions(+), 6 deletions(-)
>> 
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index f53b0c74f7c8..d5742378d031 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -6013,17 +6013,14 @@ static void vmx_l1d_flush(struct kvm_vcpu *vcpu)
>> static void update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
>> {
>> 	struct vmcs12 *vmcs12 = get_vmcs12(vcpu);
>> +	int tpr_threshold;
>> 
>> 	if (is_guest_mode(vcpu) &&
>> 		nested_cpu_has(vmcs12, CPU_BASED_TPR_SHADOW))
>> 		return;
>> 
>> -	if (irr == -1 || tpr < irr) {
>> -		vmcs_write32(TPR_THRESHOLD, 0);
>> -		return;
>> -	}
>> -
>> -	vmcs_write32(TPR_THRESHOLD, irr);
>> +	tpr_threshold = ((irr == -1) || (tpr < irr)) ? 0 : irr;
> 
> Pascal parentheses? :)
> 
> Paolo

What do you mean?

-Liran

> 
>> +	vmcs_write32(TPR_THRESHOLD, tpr_threshold);
>> }
>> 
>> void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu)
>> 
> 

