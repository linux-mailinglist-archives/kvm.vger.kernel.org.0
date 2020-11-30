Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C66C2C8D30
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 19:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388271AbgK3SoX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 13:44:23 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:32914 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388264AbgK3SoW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 13:44:22 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUISrfb136966;
        Mon, 30 Nov 2020 18:43:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=VGptTinuknU9DbQlqyBrHws2SfA6tHCjwTpy5V1HH5E=;
 b=Qbh+h95l030CzT3G17995r7xXySCzdhjs1aECHQ2aUN0ymUXmF2PZlxeg4PPg0dp6Pl7
 j7DAlo+YNdPEKSEBdpqGGd+Z9DIVaXxgLYJN23q0xPtVekofMxXgdb1JeAFKcwNBEnRA
 xdNTLD5Hltq9Civ3v62YA375d+cHHZ/dWpAyenj1ZEoTT80rYtd5j1nP9Z3Avf1YaULG
 y8/00o+CavKsZjm+Pn83DLq5DPT+d3hLKA+ZLWAxjRRd4e2hHuXs9I76GiHstsel1mPj
 crHtkub/nzoNbf+6hXBOkUYgDAoqxrFMLpwTQY9A1xBWclH6pTWZi6E4XdLKNLZo9a5o 9w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 353egkenkh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 18:43:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUIU2HU141810;
        Mon, 30 Nov 2020 18:41:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 3540ewww14-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 18:41:25 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AUIfOST014950;
        Mon, 30 Nov 2020 18:41:24 GMT
Received: from [10.175.212.254] (/10.175.212.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 10:41:24 -0800
Subject: Re: [PATCH RFC 11/39] KVM: x86/xen: evtchn signaling via eventfd
To:     David Woodhouse <dwmw2@infradead.org>,
        Ankur Arora <ankur.a.arora@oracle.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-12-joao.m.martins@oracle.com>
 <874d1fa922cb56238676b90bbeeba930d0706500.camel@infradead.org>
 <e83f6438-7256-1dc8-3b13-5498fd5bbed1@oracle.com>
 <18e854e2a84750c2de2d32384710132b83d84286.camel@infradead.org>
 <0b9d3901-c10b-effd-6278-6afd1e95b09e@oracle.com>
 <315ea414c2bf938978f7f2c0598e80fa05b4c07b.camel@infradead.org>
 <05661003-64f0-a32a-5659-6463d4806ef9@oracle.com>
 <13bc2ca60ca4e6d74c619e65502889961a08c3ff.camel@infradead.org>
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <35e45689-8225-7e5d-44ef-23479b563444@oracle.com>
Date:   Mon, 30 Nov 2020 18:41:20 +0000
MIME-Version: 1.0
In-Reply-To: <13bc2ca60ca4e6d74c619e65502889961a08c3ff.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=1 bulkscore=0 spamscore=0 adultscore=0 mlxlogscore=885
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 suspectscore=1
 phishscore=0 mlxlogscore=872 lowpriorityscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300120
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/20 6:01 PM, David Woodhouse wrote:
> On Mon, 2020-11-30 at 17:15 +0000, Joao Martins wrote:
>> On 11/30/20 4:48 PM, David Woodhouse wrote:
>>> On Mon, 2020-11-30 at 15:08 +0000, Joao Martins wrote:
>>>> On 11/30/20 12:55 PM, David Woodhouse wrote:
>>>>> On Mon, 2020-11-30 at 12:17 +0000, Joao Martins wrote:
>>>>>> On 11/30/20 9:41 AM, David Woodhouse wrote:
>>>>>>> On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:

[...]

>>>> I should comment on your other patch but: if we're going to make it generic for
>>>> the userspace hypercall handling, might as well move hyper-v there too. In this series,
>>>> I added KVM_EXIT_XEN, much like it exists KVM_EXIT_HYPERV -- but with a generic version
>>>> I wonder if a capability could gate KVM_EXIT_HYPERCALL to handle both guest types, while
>>>> disabling KVM_EXIT_HYPERV. But this is probably subject of its own separate patch :)
>>>
>>> There's a limit to how much consolidation we can do because the ABI is
>>> different; the args are in different registers.
>>>
>>
>> Yes. It would be optionally enabled of course and VMM would have to adjust to the new ABI
>> -- surely wouldn't want to break current users of KVM_EXIT_HYPERV.
> 
> True, but that means we'd have to keep KVM_EXIT_HYPERV around anyway,
> and can't actually *remove* it. The "consolidation" gives us more
> complexity, not less.
>
Fair point.

>>> I do suspect Hyper-V should have marshalled its arguments into the
>>> existing kvm_run->arch.hypercall and used KVM_EXIT_HYPERCALL but I
>>> don't think it makes sense to change it now since it's a user-facing
>>> ABI. I don't want to follow its lead by inventing *another* gratuitous
>>> exit type for Xen though.
>>>
>>
>> I definitely like the KVM_EXIT_HYPERCALL better than a KVM_EXIT_XEN userspace
>> exit type ;)
>>
>> But I guess you still need to co-relate a type of hypercall (Xen guest cap enabled?) to
>> tell it's Xen or KVM to specially enlighten certain opcodes (EVTCHNOP_send).
> 
> Sure, but if the VMM doesn't know what kind of guest it's hosting, we
> have bigger problems... :)
> 
Right :)

I was referring to the kernel here.

Eventually we need to special case things for a given guest type case e.g.

int kvm_emulate_hypercall(struct kvm_vcpu *vcpu)
{
...
        if (kvm_hv_hypercall_enabled(vcpu->kvm))
                return kvm_hv_hypercall(...);

        if (kvm_xen_hypercall_enabled(vcpu->kvm))
                return kvm_xen_hypercall(...);
...
}

And on kvm_xen_hypercall() for the cases VMM offloads to demarshal what the registers mean
e.g. for event channel send 64-bit guest: RAX for opcode and RDI/RSI for cmd and port.

The kernel logic wouldn't be much different at the core, so thought of tihs consolidation.
But the added complexity would have come from having to deal with two userspace exit types
-- indeed probably not worth the trouble as you pointed out.
