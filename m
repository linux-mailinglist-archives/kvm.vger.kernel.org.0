Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE5A0D9358
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 16:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393803AbfJPOIT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 10:08:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36748 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732421AbfJPOIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 10:08:18 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BE84C50F7C
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 14:08:17 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id s9so481159wrw.23
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 07:08:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Bc7gkPDeSuKo8mrUFOYa6NlKk3qa9o4j7JsY4jVx7Qw=;
        b=HztxJJUntFaFwUrBi9Ttd8FhQ/pHdwwW7QeY4Ck4NfvWKHlEmhfyArsle7PQUaRbs2
         InIzWXmrpFQL1v89b03t4itZUlHG3iMGkgmTZKD3djnyje5pRGY8bYuEg3MhRHaG59tN
         RDq2xbs1/DeX10Ns0n7TbY0k3cceVY8/3boplqB2sVXTE11Sx7epUeIQWGFjY/npO054
         bfQIuI9Cja7hI1T+9nje6hiEFuS9zc/AOXStJ1TdrSA2inlUF5BQiysl9YZZgY7zUIOR
         /xAzt7sYTNDnj7pHrieYcw+5P3dsryceH/4ncVH/sfiSKWfLAQheisiFuY6Zj9UTaly1
         3b7A==
X-Gm-Message-State: APjAAAVYFpfCBReugjfbtfHEpa2X5Qfe0BldbwSoRsAAgaYBDdkQ0KCS
        QLHczZ/I7km21tVZBrEmMmENe4N0XjCOgoqLGBOkIaZtbmEIsjN+HD313aMZ1HLVFVH7VVYvEEa
        e8r85W/92eYUA
X-Received: by 2002:a1c:8043:: with SMTP id b64mr3428847wmd.145.1571234896113;
        Wed, 16 Oct 2019 07:08:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzj9MuMEtipxnnKimJRV6J44BJGNuzZ1N+fA004PK8PHQrIqMTEcfndSJi7wzxdKKV7NsnMJA==
X-Received: by 2002:a1c:8043:: with SMTP id b64mr3428811wmd.145.1571234895779;
        Wed, 16 Oct 2019 07:08:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id o70sm2980726wme.29.2019.10.16.07.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 07:08:14 -0700 (PDT)
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        H Peter Anvin <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>,
        Ravi V Shankar <ravi.v.shankar@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, kvm@vger.kernel.org
References: <1560897679-228028-1-git-send-email-fenghua.yu@intel.com>
 <1560897679-228028-10-git-send-email-fenghua.yu@intel.com>
 <alpine.DEB.2.21.1906262209590.32342@nanos.tec.linutronix.de>
 <20190626203637.GC245468@romley-ivt3.sc.intel.com>
 <alpine.DEB.2.21.1906262338220.32342@nanos.tec.linutronix.de>
 <20190925180931.GG31852@linux.intel.com>
 <3ec328dc-2763-9da5-28d6-e28970262c58@redhat.com>
 <alpine.DEB.2.21.1910161142560.2046@nanos.tec.linutronix.de>
 <57f40083-9063-5d41-f06d-fa1ae4c78ec6@redhat.com>
 <alpine.DEB.2.21.1910161244060.2046@nanos.tec.linutronix.de>
 <3a12810b-1196-b70a-aa2e-9fe17dc7341a@redhat.com>
 <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d2fc3cbe-1506-94fc-73a4-8ed55dc9337d@redhat.com>
Date:   Wed, 16 Oct 2019 16:08:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <b2c42a64-eb42-1f18-f609-42eec3faef18@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 15:51, Xiaoyao Li wrote:
> On 10/16/2019 7:58 PM, Paolo Bonzini wrote:
>> On 16/10/19 13:49, Thomas Gleixner wrote:
>>> On Wed, 16 Oct 2019, Paolo Bonzini wrote:
>>>> Yes it does.  But Sean's proposal, as I understand it, leads to the
>>>> guest receiving #AC when it wasn't expecting one.  So for an old guest,
>>>> as soon as the guest kernel happens to do a split lock, it gets an
>>>> unexpected #AC and crashes and burns.  And then, after much googling
>>>> and
>>>> gnashing of teeth, people proceed to disable split lock detection.
>>>
>>> I don't think that this was what he suggested/intended.
>>
>> Xiaoyao's reply suggests that he also understood it like that.
> 
> Actually, what I replied is a little different from what you stated
> above that guest won't receive #AC when it wasn't expecting one but the
> userspace receives this #AC.

Okay---but userspace has no choice but to crash the guest, which is okay
for debugging but, most likely, undesirable behavior in production.

>>> With your proposal you render #AC useless even on hosts which have SMT
>>> disabled, which is just wrong. There are enough good reasons to disable
>>> SMT.
>>
>> My lazy "solution" only applies to SMT enabled.  When SMT is either not
>> supported, or disabled as in "nosmt=force", we can virtualize it like
>> the posted patches have done so far.
> 
> Do we really need to divide it into two cases of SMT enabled and SMT
> disabled?

Yes, absolutely.  Because in one case MSR_TEST_CTRL behaves sanely, in
the other it doesn't.

>> Yes, that's a valid alternative.  But if SMT is possible, I think the
>> only sane possibilities are global disable and SIGBUS.  SIGBUS (or
>> better, a new KVM_RUN exit code) can be acceptable for debugging
>> guests too.
> 
> If SIGBUS, why need to globally disable?

SIGBUS (actually a new KVM_EXIT_INTERNAL_ERROR result from KVM_RUN is
better, but that's the idea) is for when you're debugging guests.
Global disable (or alternatively, disable SMT) is for production use.

> When there is an #AC due to split-lock in guest, KVM only has below two
> choices:
> 1) inject back into guest.
>    - If kvm advertise this feature to guest, and guest kernel is latest,
> and guest kernel must enable it too. It's the happy case that guest can
> handler it on its own purpose.
>    - Any other cases, guest get an unexpected #AC and crash.
> 2) report to userspace (I think the same like a SIGBUS)
> 
> So for simplicity, we can do what Paolo suggested that don't advertise
> this feature and report #AC to userspace when an #AC due to split-lock
> in guest *but* we never disable the host's split-lock detection due to
> guest's split-lock.

This is one possibility, but it must be opt-in.  Either you make split
lock detection opt-in in the host (and then a userspace exit is okay),
or you make split lock detection opt-in for KVM (and then #AC causes a
global disable of split-lock detection on the host).

Breaking all old guests with the default options is not a valid choice.

Paolo
