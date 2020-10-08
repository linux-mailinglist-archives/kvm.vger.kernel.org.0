Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A743B287B8A
	for <lists+kvm@lfdr.de>; Thu,  8 Oct 2020 20:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727816AbgJHSS0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Oct 2020 14:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbgJHSS0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Oct 2020 14:18:26 -0400
Received: from forward102j.mail.yandex.net (forward102j.mail.yandex.net [IPv6:2a02:6b8:0:801:2::102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D4CC061755
        for <kvm@vger.kernel.org>; Thu,  8 Oct 2020 11:18:25 -0700 (PDT)
Received: from mxback13j.mail.yandex.net (mxback13j.mail.yandex.net [IPv6:2a02:6b8:0:1619::88])
        by forward102j.mail.yandex.net (Yandex) with ESMTP id 01D6DF200FC;
        Thu,  8 Oct 2020 21:18:21 +0300 (MSK)
Received: from iva5-057a0d1fbbd8.qloud-c.yandex.net (iva5-057a0d1fbbd8.qloud-c.yandex.net [2a02:6b8:c0c:7f1c:0:640:57a:d1f])
        by mxback13j.mail.yandex.net (mxback/Yandex) with ESMTP id RfimM7jweV-IKdGnEhk;
        Thu, 08 Oct 2020 21:18:20 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail; t=1602181100;
        bh=cFs6DvdMaKWn5+qm6nyo0Jb17ex+dF10ztqVuJwEsR0=;
        h=In-Reply-To:From:To:Subject:Cc:Date:References:Message-ID;
        b=vWLvcpLh5wN8l5/1IwiTYp8M1YjvMoa+R6hg2pkGEwaKmHMiCyX2KM2HDvZbg5qsY
         wpRi7Op6nJM9HVt7olbLt5ih/PYT1zvNxBC+9nWyhsWxlXDSr5i5p3HmZgyu4NOQAC
         AAv4elQ82k7g7rqQ1FditDibRWgec/7thmOvU2HA=
Authentication-Results: mxback13j.mail.yandex.net; dkim=pass header.i=@yandex.ru
Received: by iva5-057a0d1fbbd8.qloud-c.yandex.net (smtp/Yandex) with ESMTPSA id VYNFEb9DbQ-IKmWX7U3;
        Thu, 08 Oct 2020 21:18:20 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Subject: Re: [PATCH 0/6] KVM: x86: KVM_SET_SREGS.CR4 bug fixes and cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201007014417.29276-1-sean.j.christopherson@intel.com>
 <99334de1-ba3d-dfac-0730-e637d39b948f@yandex.ru>
 <20201008175951.GA9267@linux.intel.com>
From:   stsp <stsp2@yandex.ru>
Message-ID: <7efe1398-24c0-139f-29fa-3d89b6013f34@yandex.ru>
Date:   Thu, 8 Oct 2020 21:18:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201008175951.GA9267@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

08.10.2020 20:59, Sean Christopherson пишет:
> On Thu, Oct 08, 2020 at 07:00:13PM +0300, stsp wrote:
>> 07.10.2020 04:44, Sean Christopherson пишет:
>>> Two bug fixes to handle KVM_SET_SREGS without a preceding KVM_SET_CPUID2.
>> Hi Sean & KVM devs.
>>
>> I tested the patches, and wherever I
>> set VMXE in CR4, I now get
>> KVM: KVM_SET_SREGS: Invalid argument
>> Before the patch I was able (with many
>> problems, but still) to set VMXE sometimes.
>>
>> So its a NAK so far, waiting for an update. :)
> IIRC, you said you were going to test on AMD?  Assuming that's correct,

Yes, that is true.


>   -EINVAL
> is the expected behavior.  KVM was essentially lying before; it never actually
> set CR4.VMXE in hardware, it just didn't properply detect the error and so VMXE
> was set in KVM's shadow of the guest's CR4.

Hmm. But at least it was lying
similarly on AMD and Intel CPUs. :)
So I was able to reproduce the problems
myself.
Do you mean, any AMD tests are now
useless, and we need to proceed with
Intel tests only?

Then additional question.
On old Intel CPUs we needed to set
VMXE in guest to make it to work in
nested-guest mode.
Is it still needed even with your patches?
Or the nested-guest mode will work
now even on older Intel CPUs and KVM
will set VMXE for us itself, when needed?

