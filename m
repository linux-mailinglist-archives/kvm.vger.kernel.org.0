Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F822C8A9F
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 18:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729060AbgK3RQi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 12:16:38 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:55198 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgK3RQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 12:16:38 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUH8sHg139397;
        Mon, 30 Nov 2020 17:15:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=8k0Ick0cipBZUE2FRf/GcIuu2yQCXpVdYugdOUXaAg8=;
 b=NNUQ4t84Z3haogS/rpq2qdRzegHeNgsUN5hbnMbR0PiIlOIKUd/n1nBALmVYObMvnvtq
 Rx3b8cqc92jengUVO2eXbQDXBEWb5HY0aPpqfk7cbQn8IvGBUobJje5hu021uqcJUPsq
 wTAqbc0d5WdxJ2sMkOIuMAzN/dss/E0OsFCtp+9hgLjCyxjTgU7BsJmRfTujFwO11XDU
 lPKCOwqS2BwoR03hUlMu2maia1aNz+DwGqjglX+Q3SF/bx+Wzjttlq5rwNEX/5XCpmnQ
 3IM3X4vgLNpQ32oHJP1vpZC235s3hB8B798+/hCXjmgnfsfr/okFMrFMikNMMsD4vR5i pQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 353c2apc9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 17:15:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUHALVU122738;
        Mon, 30 Nov 2020 17:15:39 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 35404kuc80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 17:15:39 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AUHFabm014424;
        Mon, 30 Nov 2020 17:15:36 GMT
Received: from [10.175.212.254] (/10.175.212.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 09:15:36 -0800
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
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <05661003-64f0-a32a-5659-6463d4806ef9@oracle.com>
Date:   Mon, 30 Nov 2020 17:15:31 +0000
MIME-Version: 1.0
In-Reply-To: <315ea414c2bf938978f7f2c0598e80fa05b4c07b.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 bulkscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300111
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9821 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/20 4:48 PM, David Woodhouse wrote:
> On Mon, 2020-11-30 at 15:08 +0000, Joao Martins wrote:
>> On 11/30/20 12:55 PM, David Woodhouse wrote:
>>> On Mon, 2020-11-30 at 12:17 +0000, Joao Martins wrote:
>>>> On 11/30/20 9:41 AM, David Woodhouse wrote:
>>>>> On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:
>>>> One thing I didn't quite do at the time, is the whitelisting of unregistered
>>>> ports to userspace. Right now, it's a blacklist i.e. if it's not handled in
>>>> the kernel (IPIs, timer vIRQ, etc) it goes back to userspace. When the only
>>>> ones which go to userspace should be explicitly requested as such
>>>> and otherwise return -ENOENT in the hypercall.
>>>
>>> Hm, why would -ENOENT be a fast path which needs to be handled in the
>>> kernel?
>>>
>>
>> It's not that it's a fast path.
>>
>> Like sending an event channel to an unbound vector, now becomes an possible vector to
>> worry about in userspace VMM e.g. should that port lookup logic be fragile.
>>
>> So it's more along the lines of Nack-ing the invalid port earlier to rather go
>> to go userspace to invalidate it, provided we do the lookup anyway in the kernel.
> 
> If the port lookup logic is fragile, I *want* it in the sandboxed
> userspace VMM and not in the kernel :)
> 
Yes definitely -- I think we are on the same page on that.

But it's just that we do the lookup *anyways* to check if the kernel has a given
evtchn port registered. That's the lookup I am talking about here, with just an
extra bit to tell that's a userspace handled port.

> And unless we're going to do *all* of the EVTCHNOP_bind*, EVTCHN_close,
> etc. handling in the kernel, doesn't userspace have to have all that
> logic for managing the port space anyway?
> 
Indeed.

> I think it's better to let userspace own it outright, and use the
> kernel bypass purely for the fast paths. The VMM can even implement
> IPI/VIRQ support in userspace, then use the kernel bypass if/when it's
> available.
> 
True, and it's pretty much how it's implemented today.

But felt it was still worth having this discussion ... should this be
considered or discarded. I suppose we stick with the later for now.

>>>> Perhaps eventfd could be a way to express this? Like if you register
>>>> without an eventfd it's offloaded, otherwise it's assigned to userspace,
>>>> or if neither it's then returned an error without bothering the VMM.
>>>
>>> I much prefer the simple model where the *only* event channels that the
>>> kernel knows about are the ones it's expected to handle.
>>>
>>> For any others, the bypass doesn't kick in, and userspace gets the
>>> KVM_EXIT_HYPERCALL exit.
>>>
>>
>> /me nods
>>
>> I should comment on your other patch but: if we're going to make it generic for
>> the userspace hypercall handling, might as well move hyper-v there too. In this series,
>> I added KVM_EXIT_XEN, much like it exists KVM_EXIT_HYPERV -- but with a generic version
>> I wonder if a capability could gate KVM_EXIT_HYPERCALL to handle both guest types, while
>> disabling KVM_EXIT_HYPERV. But this is probably subject of its own separate patch :)
> 
> There's a limit to how much consolidation we can do because the ABI is
> different; the args are in different registers.
> 
Yes. It would be optionally enabled of course and VMM would have to adjust to the new ABI
-- surely wouldn't want to break current users of KVM_EXIT_HYPERV.

> I do suspect Hyper-V should have marshalled its arguments into the
> existing kvm_run->arch.hypercall and used KVM_EXIT_HYPERCALL but I
> don't think it makes sense to change it now since it's a user-facing
> ABI. I don't want to follow its lead by inventing *another* gratuitous
> exit type for Xen though.
> 
I definitely like the KVM_EXIT_HYPERCALL better than a KVM_EXIT_XEN userspace
exit type ;)

But I guess you still need to co-relate a type of hypercall (Xen guest cap enabled?) to
tell it's Xen or KVM to specially enlighten certain opcodes (EVTCHNOP_send).

	Joao
