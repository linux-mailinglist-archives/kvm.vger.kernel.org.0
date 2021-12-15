Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C49C475696
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 11:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236580AbhLOKla (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 05:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231685AbhLOKl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 05:41:28 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32566C061574;
        Wed, 15 Dec 2021 02:41:28 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t26so1058867wrb.4;
        Wed, 15 Dec 2021 02:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=MAhfJh7s9/d3wbnBM9DglzrX7wV8ZUR6EM7SZPDhxok=;
        b=YOnD6+LjNyz+lW+YtwLWa23N0/aF5/SprGp4BPiNWXJ1Mk2IXyvagOb9DIdkY/61G7
         cRwA+SaZuWtCu3NK/5TdpTxDI70V1spzzJVr2igdBwSTmmPQGtYfqFSV6G6jn6w2HVHO
         wJKKytNEfxREWtquyllqHvEQ3faivTR7x8wG97WlQVFHPvFvRrvuOxrVZde7rG7J+j+h
         uiIcf0ukwqgIRHa7sISbWi6mvmGtUhynOx3VjjHa2Wdt76dVB8jrh79Z30mboLUwubNU
         s6jBO0tRSbOD9h7fk5LDVXGEwdY6T+9n0MB1qWK6p2ZjeTuN8vDA0jwo/YN1cY7jAvbF
         fN5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=MAhfJh7s9/d3wbnBM9DglzrX7wV8ZUR6EM7SZPDhxok=;
        b=OhuqAqUwW4sF455OQD+LndjBQhCMlMsEZWvg9Vlm4iCfUpLD8zH078TVI3xziob8DZ
         UeEPFYyABZM8H1u54ijvA8YLLVBsYlKhcqscfwo7SmvFGN2b2QGvkNDieXULSaJ3HfE+
         rVpyaIUDQU5JwAlQMM3WiE+ie7w8m+LKO6r5kJL0fZoMqqvsV6fwehRxix5NbRkrVDb4
         6cT2EnnzMWylwMB0tRnCCAnq0UHo6cux+06HMs1yl7t+l8CyZdUhrEuaPNfaTUGRTKYK
         vF3v/KNS+Xrymv6QpxOk7iCrPz4io2ICTTZPys+Jag1VEcLyBmBLEXt/slkhm2Z9sYPu
         dpOw==
X-Gm-Message-State: AOAM53217EzLjhn7HVRV72ig71FVRJBkhnHG3lTbNOTAHW+77VO59vT3
        tZn1ZBfWLyPSV+F4kJvNDrQ=
X-Google-Smtp-Source: ABdhPJza0sGe+SbXvyRdldbMV9xSSEuqc4NgzQO2pEAtbr4wzKRKHyTfTr1U7d8NGAj1QTKxVzZsUA==
X-Received: by 2002:a05:6000:15c7:: with SMTP id y7mr3836155wry.424.1639564886768;
        Wed, 15 Dec 2021 02:41:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id l15sm1388770wme.47.2021.12.15.02.41.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 02:41:26 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <8f37c8a3-1823-0e8f-dc24-6dbae5ce1535@redhat.com>
Date:   Wed, 15 Dec 2021 11:41:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [patch 5/6] x86/fpu: Provide fpu_update_guest_xcr0/xfd()
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        "Wang, Wei W" <wei.w.wang@intel.com>,
        "quintela@redhat.com" <quintela@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christoperson <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Zeng, Guang" <guang.zeng@intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024948.048572883@linutronix.de>
 <854480525e7f4f3baeba09ec6a864b80@intel.com> <87zgp3ry8i.ffs@tglx>
 <b3ac7ba45c984cf39783e33e0c25274d@intel.com> <87r1afrrjx.ffs@tglx>
 <87k0g7qa3t.fsf@secure.mitica> <87k0g7rkwj.ffs@tglx>
 <878rwm7tu8.fsf@secure.mitica> <afeba57f71f742b88aac3f01800086f9@intel.com>
 <878rwmrxgb.ffs@tglx> <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
In-Reply-To: <a4fbf9f8-8876-f58c-d2b6-15add35bedd0@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/21 11:27, Paolo Bonzini wrote:
> On 12/15/21 11:09, Thomas Gleixner wrote:
>> Lets assume the restore order is XSTATE, XCR0, XFD:
>>
>>       XSTATE has everything in init state, which means the default
>>       buffer is good enough
>>
>>       XCR0 has everything enabled including AMX, so the buffer is
>>       expanded
>>
>>       XFD has AMX disable set, which means the buffer expansion was
>>       pointless
>>
>> If we go there, then we can just use a full expanded buffer for KVM
>> unconditionally and be done with it. That spares a lot of code.
> 
> If we decide to use a full expanded buffer as soon as KVM_SET_CPUID2 is 
> done, that would work for me. 

Off-list, Thomas mentioned doing it even at vCPU creation as long as the 
prctl has been called.  That is also okay and even simpler.

There's also another important thing that hasn't been mentioned so far: 
KVM_GET_SUPPORTED_CPUID should _not_ include the dynamic bits in 
CPUID[0xD] if they have not been requested with prctl.  It's okay to 
return the AMX bit, but not the bit in CPUID[0xD].

Paolo
