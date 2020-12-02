Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750FF2CB44E
	for <lists+kvm@lfdr.de>; Wed,  2 Dec 2020 06:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbgLBFUr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Dec 2020 00:20:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:45616 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726228AbgLBFUq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Dec 2020 00:20:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B253ilM174598;
        Wed, 2 Dec 2020 05:19:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=cMYiHoDqWu1caH/axLlQ3XDo3E331ceUnyp/wEwpk/k=;
 b=X9nHrXrYHhHHLTyrNQ1Wey+8HxaacctT8UYzqypg6QB+IInFPSutvkDx4N3qJfeD2t2j
 Umi/02K1vFG411Tfp+Zu2E/mYWk6tsDApUq9WcieUE6KlnmqZtDS+6V0D+SiKUJdfa0R
 SDdvlQaDPuMOd4BhN3S1zkL/7yHr9rKLG9zICxEus9ugASrU9xxTcvR4S7egiMtS69OP
 T80OzyoEIru1at9ZnAesUgqmP7LsN+vMfQlbRj95Q1SqC+CEqQMWbxqXYhos2U081c16
 6hMO+zW5m9sHR5W7+U2l5ae0MMUZOPZjj9vEx4G2d2acdoIYVvPwfL7GC8E9asnTdADl IA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 353dyqp8an-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 02 Dec 2020 05:19:54 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0B251LhA076776;
        Wed, 2 Dec 2020 05:17:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 3540fy287n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Dec 2020 05:17:54 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0B25Ho2l006448;
        Wed, 2 Dec 2020 05:17:50 GMT
Received: from [192.168.0.108] (/70.36.60.91)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 01 Dec 2020 21:17:49 -0800
Subject: Re: [PATCH RFC 03/39] KVM: x86/xen: register shared_info page
To:     David Woodhouse <dwmw2@infradead.org>,
        Joao Martins <joao.m.martins@oracle.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20190220201609.28290-1-joao.m.martins@oracle.com>
 <20190220201609.28290-4-joao.m.martins@oracle.com>
 <b647bed6c75f8743b8afea251a88f00a5feaee29.camel@infradead.org>
 <2d4df59d-f945-32dc-6999-a6f711e972ea@oracle.com>
 <3ac692ed7dd77aa2ed23646bb1741a7b40bddcff.camel@infradead.org>
From:   Ankur Arora <ankur.a.arora@oracle.com>
Message-ID: <a6102420-cbda-700a-b049-31db96d357b1@oracle.com>
Date:   Tue, 1 Dec 2020 21:17:47 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <3ac692ed7dd77aa2ed23646bb1741a7b40bddcff.camel@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 adultscore=0 mlxscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9822 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 clxscore=1015 mlxscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012020031
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-12-01 5:26 p.m., David Woodhouse wrote
> On Tue, 2020-12-01 at 16:40 -0800, Ankur Arora wrote:
>> On 2020-12-01 5:07 a.m., David Woodhouse wrote:
>>> On Wed, 2019-02-20 at 20:15 +0000, Joao Martins wrote:
>>>> +static int kvm_xen_shared_info_init(struct kvm *kvm, gfn_t gfn)
>>>> +{
>>>> +       struct shared_info *shared_info;
>>>> +       struct page *page;
>>>> +
>>>> +       page = gfn_to_page(kvm, gfn);
>>>> +       if (is_error_page(page))
>>>> +               return -EINVAL;
>>>> +
>>>> +       kvm->arch.xen.shinfo_addr = gfn;
>>>> +
>>>> +       shared_info = page_to_virt(page);
>>>> +       memset(shared_info, 0, sizeof(struct shared_info));
>>>> +       kvm->arch.xen.shinfo = shared_info;
>>>> +       return 0;
>>>> +}
>>>> +
>>>
>>> Hm.
>>>
>>> How come we get to pin the page and directly dereference it every time,
>>> while kvm_setup_pvclock_page() has to use kvm_write_guest_cached()
>>> instead?
>>
>> So looking at my WIP trees from the time, this is something that
>> we went back and forth on as well with using just a pinned page or a
>> persistent kvm_vcpu_map().
> 
> OK, thanks.
> 
>> I remember distinguishing shared_info/vcpu_info from kvm_setup_pvclock_page()
>> as shared_info is created early and is not expected to change during the
>> lifetime of the guest which didn't seem true for MSR_KVM_SYSTEM_TIME (or
>> MSR_KVM_STEAL_TIME) so that would either need to do a kvm_vcpu_map()
>> kvm_vcpu_unmap() dance or do some kind of synchronization.
>>
>> That said, I don't think this code explicitly disallows any updates
>> to shared_info.
> 
> It needs to allow updates as well as disabling the shared_info pages.
> We're going to need that to implement SHUTDOWN_soft_reset for kexec.
True.

> 
>>>
>>> If that was allowed, wouldn't it have been a much simpler fix for
>>> CVE-2019-3016? What am I missing?
>>
>> Agreed.
>>
>> Perhaps, Paolo can chime in with why KVM never uses pinned page
>> and always prefers to do cached mappings instead?
>>
>>>
>>> Should I rework these to use kvm_write_guest_cached()?
>>
>> kvm_vcpu_map() would be better. The event channel logic does RMW operations
>> on shared_info->vcpu_info.
> 
> I've ported the shared_info/vcpu_info parts and made a test case, and
> was going back through to make it use kvm_write_guest_cached(). But I
> should probably plug on through the evtchn bits before I do that.
> 
> I also don't see much locking on the cache, and can't convince myself
> that accessing the shared_info page from multiple CPUs with
> kvm_write_guest_cached() or kvm_map_gfn() is sane unless they each have
> their own cache.

I think you could get a VCPU specific cache with kvm_vcpu_map().

> 
> What I have so far is at
> 
> https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/xenpv

Thanks. Will take a look there.

Ankur

> 
> I'll do the event channel support tomorrow and hook it up to my actual
> VMM to give it some more serious testing.
> 
