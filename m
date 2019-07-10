Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95A2164CA6
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 21:19:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727770AbfGJTTe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 15:19:34 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:46824 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727612AbfGJTTe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 15:19:34 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AJIwiw025819;
        Wed, 10 Jul 2019 19:18:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2018-07-02;
 bh=z4u687MoXqEgulgTuj85lpG+TckwxQW9LLPZjZYZsOs=;
 b=hCZDvLIiehzSgthNvExFb6DOoFqdPWGeVdmB4yZgL29l/NCjE0OQElzRwY5oKjfUlxVD
 kJa8t2qVOMFDlCHtfMPlNkSJ6F8CZC74xnTGwh8FzgvLAkt5rV+rATljQnTJGkI4J2Pj
 UixOI9jL50q+Ya1yuzp489jXUPcXnXon97LF/CmT6xqpDXndEVOJlXQjS4M4y7gEa8Pw
 XjOoBy5aCwExly0xYPJk5OLBsNASTRSoDw0fk1+CuhZn58tFpFpRpNIW0hVkBO+0qxwZ
 HgEkwC6gtbfEpkjTu8EPlPXtlBMjbxEGpXlfSiAuec6I9q+jkgGoX2Lx/2HNJgtsN5y3 vw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2tjkkpv2ac-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 19:18:58 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x6AJI5Gv003082;
        Wed, 10 Jul 2019 19:18:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 2tnc8t27k1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Jul 2019 19:18:57 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x6AJIu2C011829;
        Wed, 10 Jul 2019 19:18:56 GMT
Received: from [10.159.238.2] (/10.159.238.2)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 10 Jul 2019 12:18:56 -0700
Subject: Re: [PATCH 2/5] KVM: nVMX: Skip VM-Exit Control vmentry checks that
 are necessary only if VMCS12 is dirty
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     rkrcmar@redhat.com, jmattson@google.com
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
 <20190707071147.11651-3-krish.sadhukhan@oracle.com>
 <f42d3eac-8353-3d90-a621-ca82460b66e7@redhat.com>
From:   Krish Sadhukhan <krish.sadhukhan@oracle.com>
Message-ID: <9e0b1aba-8cf6-733c-dc4d-63aa61fcddd8@oracle.com>
Date:   Wed, 10 Jul 2019 12:18:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <f42d3eac-8353-3d90-a621-ca82460b66e7@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=736
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1907100219
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9314 signatures=668688
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=788 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1907100220
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 7/10/19 7:28 AM, Paolo Bonzini wrote:
> On 07/07/19 09:11, Krish Sadhukhan wrote:
>>   
>>   	if (!vmx_control_verify(vmcs12->vm_exit_controls,
>>   				vmx->nested.msrs.exit_ctls_low,
>> -				vmx->nested.msrs.exit_ctls_high) ||
>> -	    nested_vmx_check_exit_msr_switch_controls(vcpu, vmcs12))
>> +				vmx->nested.msrs.exit_ctls_high))
>> +		return -EINVAL;
>> +
> Exit controls are not shadowed, are they?

No, they aren't.   However, I see that prepare_vmcs02_constant_state() 
which is called in the path of prepare_vmcs02_early_full() writes those 
Exit Control fields:

        vmcs_write32(VM_EXIT_MSR_STORE_COUNT, 0);
         vmcs_write64(VM_EXIT_MSR_LOAD_ADDR, 
__pa(vmx->msr_autoload.host.val));
         vmcs_write64(VM_ENTRY_MSR_LOAD_ADDR, 
__pa(vmx->msr_autoload.guest.val));


Should we add these fields to the shadow list then ?

>
> Paolo
