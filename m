Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37BE6102735
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2019 15:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbfKSOpm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Nov 2019 09:45:42 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:40734 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727124AbfKSOpm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Nov 2019 09:45:42 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJEdWqK177168;
        Tue, 19 Nov 2019 14:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=KyULXMqBuw+BBUz3KfOuulONWiy+9k5YMKxdr3Y2jng=;
 b=D50jOauubj4oZP7fPhc5xjTiqd5rjhiK8fcjZFX7JtrtHR997ILtuMgkrvmdyMfxeAnl
 bl2kbnnyDRVPZJo39wPWkqTsuL5qQsnfqabquloo2EG6s+Zkumdhu3cQwVRqs6rbG7RR
 74sgKNiZMjO657E+ltSzO8+mB8M+5d3wXGwyIXT6rZ1tbfkc37leZXG4qmfNNhk6J7bw
 YmN1UHwrLYWdSZmmscNkVbXLa2Mej/5PCQ7A16yuK0JKjfRFVZagXXLIEbree+WszRNE
 VdsFa1DXwFxgceJT4G4ymR5yKbfjMCdC/NXT+fwLGdk7cGn0ek3DWNtAc8uLBuBABrHF lg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 2wa9rqf8aw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 14:44:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xAJEdWGT055757;
        Tue, 19 Nov 2019 14:44:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wc09xga8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Nov 2019 14:44:34 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xAJEiWFh031935;
        Tue, 19 Nov 2019 14:44:32 GMT
Received: from [192.168.1.67] (/94.61.1.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 19 Nov 2019 06:44:31 -0800
Subject: Re: [PATCH v2 2/3] KVM: VMX: Do not change PID.NDST when loading a
 blocked vCPU
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     kvm <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Liran Alon <liran.alon@oracle.com>,
        Jag Raman <jag.raman@oracle.com>
References: <20191111172012.28356-1-joao.m.martins@oracle.com>
 <20191111172012.28356-3-joao.m.martins@oracle.com>
 <CANRm+CyrbiJ068zLRH8ZMttqjnEG38qb1W1SMND+H-D=8N8tVw@mail.gmail.com>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <6b6acdee-f080-241f-8a6e-89708f746944@oracle.com>
Date:   Tue, 19 Nov 2019 14:44:27 +0000
MIME-Version: 1.0
In-Reply-To: <CANRm+CyrbiJ068zLRH8ZMttqjnEG38qb1W1SMND+H-D=8N8tVw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911190134
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9445 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911190134
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/19/19 11:36 AM, Wanpeng Li wrote:
> On Tue, 12 Nov 2019 at 01:23, Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> While vCPU is blocked (in kvm_vcpu_block()), it may be preempted which
>> will cause vmx_vcpu_pi_put() to set PID.SN.  If later the vCPU will be
> 
> How can this happen? See the prepare_to_swait_exlusive() in
> kvm_vcpu_block(), the task will be set in TASK_INTERRUPTIBLE state,
> kvm_sched_out will set vcpu->preempted to true iff current->state ==
> TASK_RUNNING.

You're right.

But preemption (thus setting PID.SN) can still happen before vcpu_block(), or
otherwise scheduled out if we are already in vcpu_block() (with task in
TASK_INTERRUPTIBLE). The right term we should have written in that sentence
above would have been 'scheduled out' and drop the vcpu_block mention and it
would encompass both cases. A better sentence would perhaps be:

"While vCPU is blocked (or about to block) it may be scheduled out which will
cause vmx_vcpu_pi_put() to be called."

But setting or not preempted/PID.SN doesn't change the rest and was mentioned
for completeness.

	Joao
