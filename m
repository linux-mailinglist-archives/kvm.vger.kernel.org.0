Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF3FC2CFDF7
	for <lists+kvm@lfdr.de>; Sat,  5 Dec 2020 19:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbgLESwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Dec 2020 13:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726125AbgLESwB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Dec 2020 13:52:01 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40A6DC0613D1
        for <kvm@vger.kernel.org>; Sat,  5 Dec 2020 10:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Message-ID:From:CC:To:Subject:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:
        Date:Sender:Reply-To:Content-ID:Content-Description;
        bh=72qn0wCk3+rll5i6MqNF5XWubar1zBuegi2RkyseWXk=; b=fE6vMn2I4Hkp7t2FBn3ILF7bcw
        Z+37asaTAwoB+pAAaaSo0Wf+BealjUKyrJ3HvOi68FciHgS5F15fis4tXSWN40izSuwSo7RB7Ex/d
        Kj8kWCFurqe3V4NRam/AFr7dVBJ9+1y9vf34XhgaQKXnl3/M6Mrx/otSR1bBYvCaunjA8KvNAvQg/
        7yjLUR+/ZA7oTnsoe1AnJUo3nP2k1CuPijwDgFoNN+nWxKvTG/4nrbPRVzMEIEXEbwsXeqULKfIlG
        YMhpdQqHB6cdRGlZdFzqZUzC3Y4S7wTuME7zUE3dvIV/zMrwuVwXWEfMAle4EEexbTv/irNoPefF1
        qyLe5gCg==;
Received: from [2a01:4c8:1065:9e1b:cae1:f652:6216:ccb1]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1klceE-0007Yo-A8; Sat, 05 Dec 2020 18:51:10 +0000
Date:   Sat, 05 Dec 2020 18:51:08 +0000
User-Agent: K-9 Mail for Android
In-Reply-To: <e62dd528-2bee-9e8b-c395-256e6980307e@oracle.com>
References: <20201204011848.2967588-1-dwmw2@infradead.org> <20201204011848.2967588-4-dwmw2@infradead.org> <e62dd528-2bee-9e8b-c395-256e6980307e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 03/15] KVM: x86/xen: intercept xen hypercalls if enabled
To:     Joao Martins <joao.m.martins@oracle.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org
From:   David Woodhouse <dwmw2@infradead.org>
Message-ID: <9A93D396-9C77-4E57-A7E0-61BBEEB83658@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5 December 2020 18:42:53 GMT, Joao Martins <joao=2Em=2Emartins@oracle=
=2Ecom> wrote:
>On 12/4/20 1:18 AM, David Woodhouse wrote:
>> @@ -3742,6 +3716,9 @@ int kvm_vm_ioctl_check_extension(struct kvm
>*kvm, long ext)
>>  	case KVM_CAP_ENFORCE_PV_FEATURE_CPUID:
>>  		r =3D 1;
>>  		break;
>> +	case KVM_CAP_XEN_HVM:
>> +		r =3D 1 | KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;
>> +		break;
>
>Maybe:
>
>	r =3D KVM_XEN_HVM_CONFIG_HYPERCALL_MSR |
>		KVM_XEN_HVM_CONFIG_INTERCEPT_HCALL;

Yeah, I already did that as I did the docs=2E In my tree it's already fold=
ed into this patch for when I post v2=2E Thanks=2E


>I suppose it makes sense restricting to INTERCEPT_HCALL to make sure
>that the kernel only
>forwards the hcall if it is control off what it put there in the
>hypercall page (i=2Ee=2E
>vmmcall/vmcall)=2E hcall userspace exiting without INTERCEPT_HCALL would
>break ABI over how
>this ioctl was used before the new flag=2E=2E=2E In case
>kvm_xen_hypercall_enabled() would
>return true with KVM_XEN_HVM_CONFIG_HYPERCALL_MSR, as now it needs to
>handle a new
>userspace exit=2E

Right=2E=20

>If we're are being pedantic, the Xen hypercall MSR is a utility more
>than a necessity as
>the OS can always do without the hcall msr IIUC=2E But it is defacto used
>by enlightened Xen
>guests included FreeBSD=2E

Not sure about that=2E Xen doesn't guarantee that the hypercall will be VM=
CALL; the ABI *is* ",use the hypercall page MSR and call it" I believe=2E

But if they do just do the VMCALL, that *will* work as I have it, won't it=
?

>
>And adding:
>
>#define KVM_XEN_HVM_CONFIG_HYPERCALL_MSR	(1 << 0)
>
>Of course, this is a nit for readability only, but it aligns with what
>you write
>in the docs update you do in the last patch=2E

Yep, already there=2E Thanks=2E

--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
