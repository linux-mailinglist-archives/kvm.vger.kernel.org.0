Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E4D5EFCD
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 01:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfGCX56 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Jul 2019 19:57:58 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:46478 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfGCX55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Jul 2019 19:57:57 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63NsYJP168403;
        Wed, 3 Jul 2019 23:57:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=wq2XcNNeWcA+SYEe+XQeP1Ou6qKU0kk/7Hd2qQh1a8E=;
 b=3UC413p7xyT8hKKKUG9p6EHV641ANkWBa4tTpRcuTUaFhS02R6FFVNisEQWFg6W8GeiN
 tGNFBFMw4tjLsYskhAZWiRS2CFuz8m1e8huUeBAHnDam7bjPnOHbecRxGtD2mUqpB4N3
 QWCHI04Ya9glKgMSuTq1x84d+FVCqzspgJ/3evlPTKELNReDFDoprq1KtP2TNEzZ3ZH7
 cIWw55yk8ndisXW9P0QP3sPjSAREcVQKPwN4AF9c+vjSum//PszHc5cAelYUByPpcX4+
 ItjZP0DV1Gbo41MtjEBFG29AFTrdtJABUI83WryG6mgFTfOKK4McN8kvVGmB7xppzxY5 Nw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2te61ec0cb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 23:57:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x63NqQVT096911;
        Wed, 3 Jul 2019 23:57:42 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 2th5qkrg1f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 03 Jul 2019 23:57:41 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x63Nvfcp009935;
        Wed, 3 Jul 2019 23:57:41 GMT
Received: from dhcp-10-132-91-225.usdhcp.oraclecorp.com (/10.132.91.225)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 03 Jul 2019 16:57:40 -0700
Subject: Re: [PATCH 1/2] KVM nVMX: Check Host Segment Registers and Descriptor
 Tables on vmentry of nested guests
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190628221447.23498-1-krish.sadhukhan@oracle.com>
 <20190628221447.23498-2-krish.sadhukhan@oracle.com>
 <00f32b48-28e9-2502-5145-52150f0307ca@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <722eb7f6-7617-f45a-4a3a-baa6952f7445@oracle.com>
Date:   Wed, 3 Jul 2019 16:57:39 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.4.0
MIME-Version: 1.0
In-Reply-To: <00f32b48-28e9-2502-5145-52150f0307ca@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=979
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907030294
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9307 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907030294
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 07/02/2019 09:25 AM, Paolo Bonzini wrote:
> On 29/06/19 00:14, Krish Sadhukhan wrote:
>> According to section "Checks on Host Segment and Descriptor-Table
>> Registers" in Intel SDM vol 3C, the following checks are performed on
>> vmentry of nested guests:
>>
>>     - In the selector field for each of CS, SS, DS, ES, FS, GS and TR, the
>>       RPL (bits 1:0) and the TI flag (bit 2) must be 0.
>>     - The selector fields for CS and TR cannot be 0000H.
>>     - The selector field for SS cannot be 0000H if the "host address-space
>>       size" VM-exit control is 0.
>>     - On processors that support Intel 64 architecture, the base-address
>>       fields for FS, GS and TR must contain canonical addresses.
>>
>> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
>> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> All these tests are getting expensive.  Can you look into skipping them
> whenever dirty_vmcs12 is clear?

OK. I am working on it and will send a separate patch-set for that. In 
the meantime, I will send v2 of this patchset containing a fix for a 
compilation error.

Thanks.

> Thanks,
>
> Paolo
>
>> ---
>>   arch/x86/kvm/vmx/nested.c | 26 ++++++++++++++++++++++++--
>>   1 file changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
>> index f1a69117ac0f..856a83aa42f5 100644
>> --- a/arch/x86/kvm/vmx/nested.c
>> +++ b/arch/x86/kvm/vmx/nested.c
>> @@ -2609,6 +2609,30 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>>   	    !kvm_pat_valid(vmcs12->host_ia32_pat))
>>   		return -EINVAL;
>>   
>> +	ia32e = (vmcs12->vm_exit_controls &
>> +		 VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
>> +
>> +	if (vmcs12->host_cs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
>> +	    vmcs12->host_ss_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
>> +	    vmcs12->host_ds_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
>> +	    vmcs12->host_es_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
>> +	    vmcs12->host_fs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
>> +	    vmcs12->host_gs_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
>> +	    vmcs12->host_tr_selector & (SEGMENT_RPL_MASK | SEGMENT_TI_MASK) ||
>> +	    vmcs12->host_cs_selector == 0 ||
>> +	    vmcs12->host_tr_selector == 0 ||
>> +	    (vmcs12->host_ss_selector == 0 && !ia32e))
>> +		return -EINVAL;
>> +
>> +#ifdef CONFIG_X86_64
>> +	if (is_noncanonical_address(vmcs12->host_fs_base, vcpu) ||
>> +	    is_noncanonical_address(vmcs12->host_gs_base, vcpu) ||
>> +	    is_noncanonical_address(vmcs12->host_gdtr_base, vcpu) ||
>> +	    is_noncanonical_address(vmcs12->host_idtr_base, vcpu) ||
>> +	    is_noncanonical_address(vmcs12->host_tr_base, vcpu))
>> +		return -EINVAL;
>> +#endif
>> +
>>   	/*
>>   	 * If the load IA32_EFER VM-exit control is 1, bits reserved in the
>>   	 * IA32_EFER MSR must be 0 in the field for that register. In addition,
>> @@ -2616,8 +2640,6 @@ static int nested_vmx_check_host_state(struct kvm_vcpu *vcpu,
>>   	 * the host address-space size VM-exit control.
>>   	 */
>>   	if (vmcs12->vm_exit_controls & VM_EXIT_LOAD_IA32_EFER) {
>> -		ia32e = (vmcs12->vm_exit_controls &
>> -			 VM_EXIT_HOST_ADDR_SPACE_SIZE) != 0;
>>   		if (!kvm_valid_efer(vcpu, vmcs12->host_ia32_efer) ||
>>   		    ia32e != !!(vmcs12->host_ia32_efer & EFER_LMA) ||
>>   		    ia32e != !!(vmcs12->host_ia32_efer & EFER_LME))
>>

