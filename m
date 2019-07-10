Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E35464877
	for <lists+kvm@lfdr.de>; Wed, 10 Jul 2019 16:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbfGJOfu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Jul 2019 10:35:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43976 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfGJOft (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Jul 2019 10:35:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so2714811wru.10
        for <kvm@vger.kernel.org>; Wed, 10 Jul 2019 07:35:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XY/huNJSOc9RlBKCSI76QiNmqWEotNY2J4pc+lZH72g=;
        b=it7/qtqOQjrLEUM8uzD9CxMccMfKEo8SRb3/iNCI+xz9og3/+w3BpejunpTyKD96OL
         VfH1lbxB11vjGL5iYr64kDqb928vjwc1OY0MVvdLcDqb2c9cIDACLYmKsMxHOOWxDWZy
         iP+ImR6uXoFN5gksmjO9lwap1jRIzjQVPJBdZzdlw6bshgn9lSiWMf7NszIWFoR98gFz
         uO8Id6xYuglbYtnLT4+Ia2CROWyIKsVn4DEGwkkSJwPlMgl1f3aeTwdCYW/7Uaru3pf8
         OrE8iU6AAi0Hn0RWiTuMMdikn3fcbUl2aIZh2gQGRHlY0qIGOtH1imRiG8XGltnwuiMX
         utIQ==
X-Gm-Message-State: APjAAAUrRjZb8hdqsTKFpd+xGPH5nL8xM3BISL2B9mGhoCF61OXdImYH
        yAmhlG1Wc3m0oBzGb+YjS1F/oQ==
X-Google-Smtp-Source: APXvYqyavTo7feiFReWPnREPF1/cX2CQHt2acVT14H4swTlQJ71QpA9ou79SLx+7G9sTDJohM32KMg==
X-Received: by 2002:adf:f904:: with SMTP id b4mr33101014wrr.291.1562769347490;
        Wed, 10 Jul 2019 07:35:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id a64sm6252795wmf.1.2019.07.10.07.35.46
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Jul 2019 07:35:47 -0700 (PDT)
Subject: Re: [PATCH 0/5] KVM: nVMX: Skip vmentry checks that are necessary
 only if VMCS12 is dirty
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, rkrcmar@redhat.com, jmattson@google.com
References: <20190707071147.11651-1-krish.sadhukhan@oracle.com>
 <20190708181759.GB20791@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4a9a76e4-a40c-58a6-4768-1125f6193c81@redhat.com>
Date:   Wed, 10 Jul 2019 16:35:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190708181759.GB20791@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/19 20:17, Sean Christopherson wrote:
> On Sun, Jul 07, 2019 at 03:11:42AM -0400, Krish Sadhukhan wrote:
>> The following functions,
>>
>> 	nested_vmx_check_controls
>> 	nested_vmx_check_host_state
>> 	nested_vmx_check_guest_state
>>
>> do a number of vmentry checks for VMCS12. However, not all of these checks need
>> to be executed on every vmentry. This patchset makes some of these vmentry
>> checks optional based on the state of VMCS12 in that if VMCS12 is dirty, only
>> then the checks will be executed. This will reduce performance impact on
>> vmentry of nested guests.
> 
> All of these patches break vmx_set_nested_state(), which sets dirty_vmcs12
> only after the aforementioned consistency checks pass.
> 
> The new nomenclature for the dirty paths is "rare", not "full".
> 
> In general, I dislike directly associating the consistency checks with
> dirty_vmcs12.
> 
>   - It's difficult to assess the correctness of the resulting code, e.g.
>     changing CPU_BASED_VM_EXEC_CONTROL doesn't set dirty_vmcs12, which
>     calls into question any and all SECONDARY_VM_EXEC_CONTROL checks since
>     an L1 could toggle CPU_BASED_ACTIVATE_SECONDARY_CONTROLS.

Yes, CPU-based controls are tricky and should not be changed.  But I
don't see a big issue apart from the CPU-based controls, and the other
checks can also be quite expensive---and the point of dirty_vmcs12 and
shadow VMCS is that we _can_ exclude them most of the time.

This is all 5.4 material anyway, I'll do some testing of Krish's patches
2-5.

Thanks,

Paolo

>   - We lose the existing organization of the consistency checks, e.g.
>     similar checks get arbitrarily split into separate flows based on
>     the rarity of the field changing.
> 
>   - The performance gains are likely minimal since the majority of checks
>     can't be skipped due to the coarseness of dirty_vmcs12.
>
> Rather than a quick and dirty (pun intended) change to use dirty_vmcs12,
> I think we should have some amount of dedicated infrastructure for
> optimizing consistency checks from the get go, e.g. perhaps something
> similar to how eVMCS categorizes fields.  The initial usage could be very
> coarse grained, e.g. based purely on dirty_vmcs12, but having the
> infrastructure would make it easier to reason about the correctness of
> the code.  Future patches could then refine the triggerring of checks to
> achieve better optimization, e.g. skipping the vast majority of checks
> when L1 is simply toggling CPU_BASED_VIRTUAL_INTR_PENDING.
