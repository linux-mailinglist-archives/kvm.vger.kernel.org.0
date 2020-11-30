Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA76D2C8771
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 16:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbgK3PJ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 10:09:57 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60052 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgK3PJ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 10:09:56 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUExHsb079081;
        Mon, 30 Nov 2020 15:08:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=E4TL13lsS3BmUyz+NpG0/cvxf17YJNKT5OVumb4dVpU=;
 b=CWEMg9yenWGv4X8JuWhIqjJUgfAV5uvZnVQBgNrYCumnqwNSo/JRTH+EgR/Xq0W8a3za
 JLiTVFXk5wMXVnWAEVF6vqbQXmU3T3NHq5okvyN8dgaP8YRetzepMW/W/UmR0hsnSOXe
 UmjR4FZmv3iaxltC4xpe8zZD21GN3Xq2+WhM3RW/ZPMphXp4dshjouLB+HokdP+raNcK
 JbanKnl9Tp6pupv5gldJ/ONwI2zPoqq0YJB5M+wcQCxx9jIJGY91QqEkjKn5W5RFCGX4
 MxlAOr1fLOon4TbR/YbgjOUzUW1kSljO76+iB/atF58aGiKEe2r7ID2ff+ki6V1wxTQ0 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 353c2annep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 30 Nov 2020 15:08:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AUF1Gg4139772;
        Mon, 30 Nov 2020 15:08:41 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3540fv7yud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 30 Nov 2020 15:08:41 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0AUF8bwX030657;
        Mon, 30 Nov 2020 15:08:37 GMT
Received: from [10.175.212.254] (/10.175.212.254)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 30 Nov 2020 07:08:36 -0800
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
From:   Joao Martins <joao.m.martins@oracle.com>
Message-ID: <0b9d3901-c10b-effd-6278-6afd1e95b09e@oracle.com>
Date:   Mon, 30 Nov 2020 15:08:32 +0000
MIME-Version: 1.0
In-Reply-To: <18e854e2a84750c2de2d32384710132b83d84286.camel@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9820 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=1
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011300098
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9820 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 lowpriorityscore=0
 clxscore=1015 bulkscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 spamscore=0 adultscore=0 mlxscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011300098
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/30/20 12:55 PM, David Woodhouse wrote:
> On Mon, 2020-11-30 at 12:17 +0000, Joao Martins wrote:
>> On 11/30/20 9:41 AM, David Woodhouse wrote:
>>> On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:
>>>> EVTCHNOP_send short-circuiting happens by marking the event as pending
>>>> in the shared info and vcpu info pages and doing the upcall. For IPIs
>>>> and interdomain event channels, we do the upcall on the assigned vcpu.
>>>
>>> This part I understand, 'peeking' at the EVTCHNOP_send hypercall so
>>> that we can short-circuit IPI delivery without it having to bounce
>>> through userspace.
>>>
>>> But why would I then want then short-circuit the short-circuit,
>>> providing an eventfd for it to signal... so that I can then just
>>> receive the event in userspace in a *different* form to the original
>>> hypercall exit I would have got?
>>>
>>
>> One thing I didn't quite do at the time, is the whitelisting of unregistered
>> ports to userspace. Right now, it's a blacklist i.e. if it's not handled in
>> the kernel (IPIs, timer vIRQ, etc) it goes back to userspace. When the only
>> ones which go to userspace should be explicitly requested as such
>> and otherwise return -ENOENT in the hypercall.
> 
> Hm, why would -ENOENT be a fast path which needs to be handled in the
> kernel?
> 
It's not that it's a fast path.

Like sending an event channel to an unbound vector, now becomes an possible vector to
worry about in userspace VMM e.g. should that port lookup logic be fragile.

So it's more along the lines of Nack-ing the invalid port earlier to rather go
to go userspace to invalidate it, provided we do the lookup anyway in the kernel.

>> Perhaps eventfd could be a way to express this? Like if you register
>> without an eventfd it's offloaded, otherwise it's assigned to userspace,
>> or if neither it's then returned an error without bothering the VMM.
> 
> I much prefer the simple model where the *only* event channels that the
> kernel knows about are the ones it's expected to handle.
> 
> For any others, the bypass doesn't kick in, and userspace gets the
> KVM_EXIT_HYPERCALL exit.
> 
/me nods

I should comment on your other patch but: if we're going to make it generic for
the userspace hypercall handling, might as well move hyper-v there too. In this series,
I added KVM_EXIT_XEN, much like it exists KVM_EXIT_HYPERV -- but with a generic version
I wonder if a capability could gate KVM_EXIT_HYPERCALL to handle both guest types, while
disabling KVM_EXIT_HYPERV. But this is probably subject of its own separate patch :)

>> But still, eventfd is probably unnecessary complexity when another @type
>> (XEN_EVTCHN_TYPE_USER) would serve, and then just exiting to userspace
>> and let it route its evtchn port handling to the its own I/O handling thread.
> 
> Hmm... so the benefit of the eventfd is that we can wake the I/O thread
> directly instead of bouncing out to userspace on the vCPU thread only
> for it to send a signal and return to the guest? Did you ever use that,
> and it is worth the additional in-kernel code?
> 
This was my own preemptive optimization to the interface -- it's not worth
the added code for vIRQ and IPI at this point which is what *for sure* the
kernel will handle.

> Is there any reason we'd want that for IPI or VIRQ event channels, or
> can it be only for INTERDOM/UNBOUND event channels which come later?
> 
/me nods.

No reason to keep that for IPI/vIRQ.

> I'm tempted to leave it out of the first patch, and *maybe* add it back
> in a later patch, putting it in the union alongside .virq.type.
> 
> 
>                 struct kvm_xen_eventfd {
>  
>  #define XEN_EVTCHN_TYPE_VIRQ 0
>  #define XEN_EVTCHN_TYPE_IPI  1
>                         __u32 type;
>                         __u32 port;
>                         __u32 vcpu;
> -                       __s32 fd;
>  
>  #define KVM_XEN_EVENTFD_DEASSIGN       (1 << 0)
>  #define KVM_XEN_EVENTFD_UPDATE         (1 << 1)
>                         __u32 flags;
>                         union {
>                                 struct {
>                                         __u8 type;
>                                 } virq;
> +                              struct {
> +                                      __s32 eventfd;
> +                              } interdom; /* including unbound */
>                                 __u32 padding[2];
>                         };
>                } evtchn;
> 
> Does that make sense to you?
> 
Yeap! :)

	Joao
