Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E5B4497F
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 19:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728119AbfFMRSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 13:18:06 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54647 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726230AbfFMRSF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jun 2019 13:18:05 -0400
Received: by mail-wm1-f65.google.com with SMTP id g135so11025761wme.4
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 10:18:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kNBPdXobpQxKhUp1vpZiR89rKDdrsNlQ94KX0iJwiks=;
        b=HvtioscO1427GO7La0sw4z5i7xumLG/9ExiF0+uWId7jZRcrwHBZmOR23/1T0doTvC
         X83NEJCahV27R4shYedjoesQAesR/UhhvA+moU0nVa5bUvC09DmNAgBWgmKSwBZ2to0X
         f2cy8IeIB7k2pUOJl3oKEiVN3AZvt5uD7RWNXN80JGYFymqpe9n7w4h7sANvgK1btGpV
         eFY/vSXu7auzbvrgg/5nhsBgbLIY+FhqQMlB4TwFfuIURqWB6Hy6xdsmrldcSrNoSnwh
         RiBybGy/A3YUHJlDMQaUE/PPG0wHVVyj6i0hl1zuzW7z3Pfi1DDC6zF0wtNV3K/hXl7j
         iuFQ==
X-Gm-Message-State: APjAAAXnza8KgLmTPo9OIqjYNlRckym/IkdeRUl2MTg0jdbLXeVhLJOb
        a5YnQtpJU/NpT4hcKZRMb5/veg==
X-Google-Smtp-Source: APXvYqyRIf4uq8u6/A8e46V5D7KYAsHIEIste9gkTICRXaI/HuwGid/QXSginTxr8QOcW+gTJfuOCQ==
X-Received: by 2002:a1c:2d5:: with SMTP id 204mr4849573wmc.175.1560446283818;
        Thu, 13 Jun 2019 10:18:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:56e1:adff:fed9:caf0? ([2001:b07:6468:f312:56e1:adff:fed9:caf0])
        by smtp.gmail.com with ESMTPSA id k82sm740121wma.15.2019.06.13.10.18.02
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 10:18:03 -0700 (PDT)
Subject: Re: [PATCH 1/7] KVM: nVMX: Intercept VMWRITEs to read-only shadow
 VMCS fields
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Liran Alon <liran.alon@oracle.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
 <20190507153629.3681-2-sean.j.christopherson@intel.com>
 <CALMp9eRb8GC1NH9agiWWwkY5ac4CKxZqzobzmLiV5FiscV_B+A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9d82caf7-1735-a5e8-8206-bdec3ddf12d4@redhat.com>
Date:   Thu, 13 Jun 2019 19:18:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CALMp9eRb8GC1NH9agiWWwkY5ac4CKxZqzobzmLiV5FiscV_B+A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/06/19 19:02, Jim Mattson wrote:
> On Tue, May 7, 2019 at 8:36 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
> 
>> Not intercepting fields tagged read-only also allows for additional
>> optimizations, e.g. marking GUEST_{CS,SS}_AR_BYTES as SHADOW_FIELD_RO
>> since those fields are rarely written by a VMMs, but read frequently.
> 
> Do you have data to support this, or is this just a gut feeling? The
> last time I looked at Virtual Box (which was admittedly a long time
> ago), it liked to read and write just about every VMCS guest-state
> field it could find on every VM-exit.

I have never looked at VirtualBox, but most other hypervisors do have a
common set of fields (give or take a couple) that they like to read
and/or write on most if not every vmexit.

Also, while this may vary dynamically based on the L2 guest that is
running, this is much less true for unrestricted-guest processors.
Without data on _which_ scenarios are bad for a static set of shadowed
fields, I'm not really happy to add even more complexity.

Paolo

> The decision of which fields to shadow is really something that should
> be done dynamically, depending on the behavior of the guest hypervisor
> (which may vary depending on the L2 guest it's running!) Making the
> decision statically is bound to result in a poor outcome for some
> scenarios.

