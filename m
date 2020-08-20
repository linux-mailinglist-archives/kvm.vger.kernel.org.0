Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FCA824B681
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 12:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731588AbgHTKfs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 06:35:48 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23721 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727863AbgHTKSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 06:18:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597918714;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ks6Vmm7jkQp97PF98e15DQTqLGcM4ICVk2CkEB67KBg=;
        b=DoxlEh7UIMQKyS7uMYVKXK75YTxHksvQT5LhuS6lXW4hKY/7N/NCUhRdKgyFv3/vScY8cP
        s4ycKOHUOr0hNwLuk7HJXoiip7H4TbZ2Ci1KJFqjHsSXCwjZK8vGEig8+o5nsnPh/6QFUF
        cqeNb5ZDd9YOXZvaTHrESZ6RjFNsfW4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-Y3148KjFPtShyDzkcQVpAQ-1; Thu, 20 Aug 2020 06:18:32 -0400
X-MC-Unique: Y3148KjFPtShyDzkcQVpAQ-1
Received: by mail-wm1-f72.google.com with SMTP id p23so797723wmc.2
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 03:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ks6Vmm7jkQp97PF98e15DQTqLGcM4ICVk2CkEB67KBg=;
        b=F0dJozvaJjoUfKEhZIxgi8YoBSovMsL5oVjqDNz/K6SztlCMgClWHwrPXrzQHoqkeH
         IDiloiOPYuu5iRqcwF8DA54gTO4j44jY+pyxnqQAZfsqAbCWGTWKB8ztG2b9RC3PRUcD
         2uvrhHXU0sa8f6uYkzOYaK9d4SuRvz87i1ABPBFKl2tLpDTLA0Dn0Dp+rKdo/9HH+wns
         8I0WKvlbr/+uh8Bx376PJYP78qd9SZBk+KY90mfEf8+2ccbsPv2nr+l2P+PRNoZn3mHG
         5sZCYwKU3PKxF1CEMZMKHqMVyZbgRPphqKr2rEKPR7UBrPMzBV48GnanOhFYjAc8VRks
         GNDA==
X-Gm-Message-State: AOAM530ng4objlvtP1DQF4Mcj5We9ZyW20ZcJUIwQSzThXoL8wg7MIry
        Z9YzOPzF12iLnV7GBJeSPVKYcNiubcVtyaDx1p1fMtq1YR+0OhlZGgrl4KgF8OlBATDj2KQr4vD
        8npH46m40Sr4d
X-Received: by 2002:a1c:de41:: with SMTP id v62mr2939602wmg.163.1597918711332;
        Thu, 20 Aug 2020 03:18:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbot6hubXE5I5zNDOSnTrvtsfmtrg53QJyDVNw19vVjiZS7ReblTt/IIGb0cMLxSkI2HCmCw==
X-Received: by 2002:a1c:de41:: with SMTP id v62mr2939573wmg.163.1597918711112;
        Thu, 20 Aug 2020 03:18:31 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id m14sm3267389wrx.76.2020.08.20.03.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 03:18:30 -0700 (PDT)
Subject: Re: [PATCH 8/8] KVM: nSVM: read only changed fields of the nested
 guest data area
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
 <20200820091327.197807-9-mlevitsk@redhat.com>
 <53afbfba-427e-72f5-73a6-faea7606e78e@redhat.com>
 <33166884f54569ab47cc17a4c3e01f9dbc96401a.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <be88aaae-c776-32d2-fa69-00c6aace787d@redhat.com>
Date:   Thu, 20 Aug 2020 12:18:28 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <33166884f54569ab47cc17a4c3e01f9dbc96401a.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/20 12:05, Maxim Levitsky wrote:
>> You probably should set clean to 0 also if the guest doesn't have the
>> VMCBCLEAN feature (so, you first need an extra patch to add the
>> VMCBCLEAN feature to cpufeatures.h).  It's probably best to cache the
>> guest vmcbclean in struct vcpu_svm, too.
> Right, I totally forgot about this one.
> 
> One thing why I made this patch optional, is that I can instead drop it,
> and not 'read back' the saved area on vmexit, this will probably be faster
> that what this optimization does. What do you think? Is this patch worth it?
> (I submitted it because I already implemented this and wanted to hear opinion
> on this).

Yeah, good point.  It's one copy either way, either on vmexit (and
partly on vmentry depending on clean bits) or on vmentry.  I had not
considered the need to copy from vmcb02 to the cached vmcb12 on vmexit. :(

Let's shelve this for a bit, and revisit it once we have separate vmcb01
and vmcb02.  Then we might still use the clean bits to avoid copying
data from vmcb12 to vmcb02, including avoiding consistency checks
because we know the vmcb02 data is legit.

Patches 1-5 are still worthwhile, so you can clean them up and send them.

Paolo

