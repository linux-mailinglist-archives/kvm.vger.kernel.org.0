Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7626F7706
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 15:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKKOt5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 09:49:57 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:41800 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfKKOt5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Nov 2019 09:49:57 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABEme8H132966;
        Mon, 11 Nov 2019 14:48:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=nCtY+7bdd6mv8eDFRHIRK+wmFtnJwxI7n+WAF/dPn8A=;
 b=Ulr0/sLsLSiw3RXJBoQlA05oYd/mcLKXQ+nBThVFbv03XAo78feVR1Zfn20e9uohxdT1
 hWT6G0VNTXHilRfbJ0IWokVG6CBkG2EQOwZh/2izWmsoEJz+L3n3oe1KxGrEYyCpqPPu
 Ver//X//qTU64DMq/JjYyLhhJm5iI8FShtdA8OmZTKN5TehcAcO1H2FcF3HP1I2iLTUb
 Rfzy0mer7+5YrmLmskM73HFVDp46plw7wvD8MunwgH/wOP+qGguwBxL07jWFE/1VvLzy
 YkbOERI2JJ9n1BDGZY8cShF2iOjZFAxXdXieCRzWPVwqbCtwjPfhwXM+8SE/vmcSELYR NA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w5ndpydhw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 14:48:51 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xABEmNM8175977;
        Mon, 11 Nov 2019 14:48:51 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w6r8jrb7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Nov 2019 14:48:50 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xABEmmQY005104;
        Mon, 11 Nov 2019 14:48:48 GMT
Received: from [10.175.169.52] (/10.175.169.52)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 11 Nov 2019 14:48:48 +0000
Subject: Re: [PATCH v1 2/3] KVM: VMX: Do not change PID.NDST when loading a
 blocked vCPU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
References: <20191106175602.4515-1-joao.m.martins@oracle.com>
 <20191106175602.4515-3-joao.m.martins@oracle.com>
 <15c8c821-25ff-eb62-abd3-8d7d69650744@redhat.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <314a4120-036c-e954-bc9f-e57dee3bbb7c@oracle.com>
Date:   Mon, 11 Nov 2019 14:48:44 +0000
MIME-Version: 1.0
In-Reply-To: <15c8c821-25ff-eb62-abd3-8d7d69650744@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911110137
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9437 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911110137
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/19 2:39 PM, Paolo Bonzini wrote:
> On 06/11/19 18:56, Joao Martins wrote:
>> When vCPU enters block phase, pi_pre_block() inserts vCPU to a per pCPU
>> linked list of all vCPUs that are blocked on this pCPU. Afterwards, it
>> changes PID.NV to POSTED_INTR_WAKEUP_VECTOR which its handler
>> (wakeup_handler()) is responsible to kick (unblock) any vCPU on that
>> linked list that now has pending posted interrupts.
>>
>> While vCPU is blocked (in kvm_vcpu_block()), it may be preempted which
>> will cause vmx_vcpu_pi_put() to set PID.SN.  If later the vCPU will be
>> scheduled to run on a different pCPU, vmx_vcpu_pi_load() will clear
>> PID.SN but will also *overwrite PID.NDST to this different pCPU*.
>> Instead of keeping it with original pCPU which vCPU had entered block
>> phase on.
>>
>> This results in an issue because when a posted interrupt is delivered,
>> the wakeup_handler() will be executed and fail to find blocked vCPU on
>> its per pCPU linked list of all vCPUs that are blocked on this pCPU.
>> Which is due to the vCPU being placed on a *different* per pCPU
>> linked list than the original pCPU that it had entered block phase.
>>
>> The regression is introduced by commit c112b5f50232 ("KVM: x86:
>> Recompute PID.ON when clearing PID.SN"). Therefore, partially revert
>> it and reintroduce the condition in vmx_vcpu_pi_load() responsible for
>> avoiding changing PID.NDST when loading a blocked vCPU.
>>
>> Fixes: c112b5f50232 ("KVM: x86: Recompute PID.ON when clearing PID.SN")
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> 
> Something wrong in the SoB line?
> 
I can't spot any mistake; at least it looks chained correctly for me. What's the
issue you see with the Sob line?

The only thing I forgot was a:

Tested-by: Nathan Ni <nathan.ni@oracle.com>

> Otherwise looks good.

If you want I can resubmit the series with the Tb and Jag Rb, unless you think
it's OK doing on commit? Otherwise I can resubmit.

	Joao
