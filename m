Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6717D1500BD
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 04:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727242AbgBCD30 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Sun, 2 Feb 2020 22:29:26 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:2936 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727034AbgBCD30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 2 Feb 2020 22:29:26 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id C98D5E13684D1791D165;
        Mon,  3 Feb 2020 11:29:20 +0800 (CST)
Received: from dggeme715-chm.china.huawei.com (10.1.199.111) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 3 Feb 2020 11:29:20 +0800
Received: from dggeme763-chm.china.huawei.com (10.3.19.109) by
 dggeme715-chm.china.huawei.com (10.1.199.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Mon, 3 Feb 2020 11:29:20 +0800
Received: from dggeme763-chm.china.huawei.com ([10.6.66.36]) by
 dggeme763-chm.china.huawei.com ([10.6.66.36]) with mapi id 15.01.1713.004;
 Mon, 3 Feb 2020 11:29:20 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>
CC:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        =?iso-8859-2?Q?Radim_Kr=E8m=E1=F8?= <rkrcmar@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] KVM: nVMX: set rflags to specify success in
 handle_invvpid() default case
Thread-Topic: [PATCH] KVM: nVMX: set rflags to specify success in
 handle_invvpid() default case
Thread-Index: AdXaOs5msQGrd2JlS/qT+AceqW9QkQ==
Date:   Mon, 3 Feb 2020 03:29:19 +0000
Message-ID: <668e0827d62c489cbf52b7bc5d27ba9b@huawei.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.173.221.158]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> Sean Christopherson <sean.j.christopherson@intel.com> writes:
>> On Thu, Jan 23, 2020 at 10:22:24AM -0800, Jim Mattson wrote:
>>> On Thu, Jan 23, 2020 at 1:54 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>> >
>>> > On 23/01/20 10:45, Vitaly Kuznetsov wrote:
>>> > >>> SDM says that "If an
>>> > >>> unsupported INVVPID type is specified, the instruction fails." 
>>> > >>> and this is similar to INVEPT and I decided to check what 
>>> > >>> handle_invept() does. Well, it does BUG_ON().
>>> > >>>
>>> > >>> Are we doing the right thing in any of these cases?
>>> > >>
>>> > >> Yes, both INVEPT and INVVPID catch this earlier.
>>> > >>
>>> > >> So I'm leaning towards not applying Miaohe's patch.
>>> > >
>>> > > Well, we may at least want to converge on BUG_ON() for both 
>>> > > handle_invvpid()/handle_invept(), there's no need for them to differ.
>>> >
>>> > WARN_ON_ONCE + nested_vmx_failValid would probably be better, if we 
>>> > really want to change this.
>>> >
>>> > Paolo
>>> 
>>> In both cases, something is seriously wrong. The only plausible 
>>> explanations are compiler error or hardware failure. It would be nice 
>>> to handle *all* such failures with a KVM_INTERNAL_ERROR exit to 
>>> userspace. (I'm also thinking of situations like getting a VM-exit 
>> for
>>>> INIT.)
>>
>> Ya.  Vitaly and I had a similar discussion[*].  The idea we tossed 
>> around was to also mark the VM as having encountered a KVM/hardware 
>> bug so that the VM is effectively dead.  That would also allow 
>> gracefully handling bugs that are detected deep in the stack, i.e. 
>> can't simply return 0 to get out to userspace.
>
>Yea, I was thinking about introducing a big hammer which would stop the whole VM as soon as possible to make it easier to debug such situations. Something like (not really tested):
>
Yea, please just ignore my origin patch and do what you want. :)
I'm sorry for reply in such a big day. I'am just backing from a really hard festival. :(
