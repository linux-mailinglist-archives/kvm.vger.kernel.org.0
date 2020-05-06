Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17DF1C7AE9
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 22:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbgEFUHZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 16:07:25 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56614 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727824AbgEFUHX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 16:07:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588795641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nr2XB0SiZijHY6nfXs3OR3ar7uF0bSSBLwC2t+otSlI=;
        b=C2QZyPBeZe6DVkNIG61auBbm3WacrbF7mVaXDIaMWZI7gClIeTWLb11BtSpLOFDpS6IggW
        2wlxM/Y6cEvU5hzrxguzYfvbDIvLcWMjSeXFfLud2G5i8uEIDV8fx/qxVRvyIvd0ICXOdg
        pRw7/7FbkCcbwp+CLK2znmW7pby40es=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-w7Lk9v9jPzKdKai7hK6D7A-1; Wed, 06 May 2020 16:07:19 -0400
X-MC-Unique: w7Lk9v9jPzKdKai7hK6D7A-1
Received: by mail-wr1-f72.google.com with SMTP id z8so1889418wrp.7
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 13:07:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nr2XB0SiZijHY6nfXs3OR3ar7uF0bSSBLwC2t+otSlI=;
        b=V28u2GLpSWTyNGKhGYRPJ4NVvIw9O0ofY/RqK6Fmp6pxeMnH00CJuj19T5+EYiqjS+
         uNu3g4OyhttXsVf9BX31ljvU4GOVbvzJyf+wzR3lrlUK4+r/bsMdtQBzqAn3Z0+pi3qd
         RZxpVg2rGOgOyug3IwgkmhQ9O+/rSxDE+I6U+aEtvPHRDuYhIS5ZdJdC7gyiFFXi2TPy
         uzgk5bG3lvQT+rM3e2VJZUnagNT+3BKxil5TEOXvJO2I5Qqd8BGdhK99kVVQVsQlWyeW
         GrylPyAnprPUqhHahZxKuNbRQ7eDk1X2nAioTX15c0hYU4VnWf/bSxxX918WUFpiXig6
         HjNQ==
X-Gm-Message-State: AGi0PuZon1DgGzQ1tcsYMg5gtbB9QfAdHrdIwNvnLiIQoHFFMWTMkr6r
        iMhlLuxAynQA6ribLp1m7+7R5fi8R3k9neAyznBTGBmvu1evSvmEo2ShQsF/87tpV4CtohzvfcL
        6qScXKz5wm60E
X-Received: by 2002:adf:a118:: with SMTP id o24mr10790496wro.330.1588795638257;
        Wed, 06 May 2020 13:07:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypI1QhkL/CkiekHxjEdCPMNrWs8KQjzSl9IDIA1IuPBMTiLzuwT4e/4T4P7nwRcfbaE9f3Cp8g==
X-Received: by 2002:adf:a118:: with SMTP id o24mr10790464wro.330.1588795637918;
        Wed, 06 May 2020 13:07:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id w10sm4498960wrg.52.2020.05.06.13.07.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 13:07:17 -0700 (PDT)
Subject: Re: [PATCH 8/9] KVM: x86, SVM: do not clobber guest DR6 on
 KVM_EXIT_DEBUG
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200506111034.11756-1-pbonzini@redhat.com>
 <20200506111034.11756-9-pbonzini@redhat.com> <20200506181515.GR6299@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8f7f319c-4093-0ddc-f9f5-002c41d5622c@redhat.com>
Date:   Wed, 6 May 2020 22:07:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506181515.GR6299@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 20:15, Peter Xu wrote:
> On Wed, May 06, 2020 at 07:10:33AM -0400, Paolo Bonzini wrote:
>> On Intel, #DB exceptions transmit the DR6 value via the exit qualification
>> field of the VMCS, and the exit qualification only contains the description
>> of the precise event that caused a vmexit.
>>
>> On AMD, instead the DR6 field of the VMCB is filled in as if the #DB exception
>> was to be injected into the guest.  This has two effects when guest debugging
>> is in use:
>>
>> * the guest DR6 is clobbered
>>
>> * the kvm_run->debug.arch.dr6 field can accumulate more debug events, rather
>> than just the last one that happened.
>>
>> Fortunately, if guest debugging is in use we debug register reads and writes
>> are always intercepted.  Now that the guest DR6 is always synchronized with
>> vcpu->arch.dr6, we can just run the guest with an all-zero DR6 while guest
>> debugging is enabled, and restore the guest value when it is disabled.  This
>> fixes both problems.
>>
>> A testcase for the second issue is added in the next patch.
> 
> Is there supposed to be another test after this one, or the GD test?

It's the GD test.
>> +		/* This restores DR6 to all zeros.  */
>> +		kvm_update_dr6(vcpu);
> 
> I feel like it won't work as expected for KVM_GUESTDBG_SINGLESTEP, because at
> [2] below it'll go to the "else" instead so dr6 seems won't be cleared in that
> case.

You're right, I need to cover both cases that trigger #DB.

> Another concern I have is that, I mostly read kvm_update_dr6() as "apply the
> dr6 memory cache --> VMCB".  I'm worried this might confuse people (at least I
> used quite a few minutes to digest...) here because latest data should already
> be in the VMCB.

No, the latest guest register is always in vcpu->arch.dr6.  It's only
because of KVM_DEBUGREG_WONT_EXIT that kvm_update_dr6() needs to pass
vcpu->arch.dr6 to kvm_x86_ops.set_dr6.  Actually this patch could even
check KVM_DEBUGREG_WONT_EXIT instead of vcpu->guest_debug.  I'll take a
look tomorrow.

> Also, IMHO it would be fine to have invalid dr6 values during
> KVM_SET_GUEST_DEBUG.  I'm not sure whether my understanding is correct, but I
> see KVM_SET_GUEST_DEBUG needs to override the in-guest debug completely.

Sort of, userspace can try to juggle host and guest debugging (this is
why you have KVM_GUESTDBG_INJECT_DB and KVM_GUESTDBG_INJECT_BP).

> If we worry about dr6 being incorrect after KVM_SET_GUEST_DEBUG is disabled,
> IMHO we can reset dr6 in kvm_arch_vcpu_ioctl_set_guest_debug() properly before
> we return the debug registers to the guest.
> 
> PS. I cannot see above lines [1] in my local tree (which seems to be really a
> bugfix...).  I tried to use kvm/queue just in case I missed some patches, but I
> still didn't see them.  So am I reading the wrong tree here?

The patch is based on kvm/master, and indeed that line is from a bugfix
that I've posted yesterday ("KVM: SVM: fill in
kvm_run->debug.arch.dr[67]"). I had pushed that one right away, because
it was quite obviously suitable for 5.7.

Paolo

