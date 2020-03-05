Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214FF17AE5D
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 19:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbgCESoE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 13:44:04 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:41659 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbgCESoE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 13:44:04 -0500
Received: by mail-il1-f194.google.com with SMTP id q13so5938241ile.8
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 10:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jQrU1ycuK56Wco0X09B7AmUEkfvXTDPV4/enUSsAJG4=;
        b=qHwudCiMEDtoduI5abx7Au96djjqA4MICG5WoLKcDqa4HyqqKsWk3xsnY1KfBgAzbV
         FUHboP4KQaYuvYxEWZui1b0dbf14eiq9p7o1Uznhf0EVJfQ+w9ls6C4Us1yJhGtAiZvk
         CbPIuS5ymL4SIYYu+njrQA2xuEu2sGvvQx6uAVm7eEjmwU1JAN8z8m1uU1EQwHdsdkJo
         +N4jR+N883F8TWXXG38iAfzZZZBjQhLsQqDgIKGtIXl03ThPz+q9yaZ8ggxUI/UKibdl
         RCQIDOnKlpeEqTe2uphYjCyptK0+7GwzZXkUGTF2oN0KTAYVNfVhg7chqedDnRHzMEZg
         FLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jQrU1ycuK56Wco0X09B7AmUEkfvXTDPV4/enUSsAJG4=;
        b=FrWZQyFiBqLcTzJjRK9egAIzglYHxFRUMXbLbDrL2A3DLxfCh2bNWd6DAzv/aEcgrl
         bBOgj46Y5E41nYvhERt2B0mcfaodgiI3L4RB3ZQBq91AJqwQ4BkKpxVcu21iBJGJwfge
         FLQZvZvPztzP05a/9ixJCxt6L+EymXUKwf+xQU6EmgO6JgV4Hc9+Q4QutYHadSexxEHg
         bvor2JbPjaFhdfYd1A881g/ZuytDMMVb8zUYNTdLAsE2bEutkh5656k03vRtF3ghJfgl
         EEt1qcMpu5AUwszQ2SDFe3DfvlWbjRPup5Wu+yy66QXaLefbsD078HvT7ciM7+TIOM8D
         ExBw==
X-Gm-Message-State: ANhLgQ2s4TJHo5gVL14QCldFtEGDEIBzIgiECJL+jRR0F5ZRDpurnQVn
        23jeNAYIU5r9wchtHULWgvr1M9ffOaL8eXzMrH1f4Q==
X-Google-Smtp-Source: ADFU+vt4qvBIGp+yHLrI64YSK1/fHHdooZOdurgvTYU1hu2RTLUDofVfOjMRFYxg87L1Ni2t/O3L+teG2/uSYul8txw=
X-Received: by 2002:a92:914a:: with SMTP id t71mr357972ild.108.1583433842040;
 Thu, 05 Mar 2020 10:44:02 -0800 (PST)
MIME-Version: 1.0
References: <20200305013437.8578-1-sean.j.christopherson@intel.com> <20200305013437.8578-5-sean.j.christopherson@intel.com>
In-Reply-To: <20200305013437.8578-5-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 5 Mar 2020 10:43:51 -0800
Message-ID: <CALMp9eRRWZ54kzMXdTqRCy2KmaUAq+HVVVzbxJNVdgktg65XCA@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: x86: Fix CPUID range checks for Hypervisor
 and Centaur classes
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pu Wen <puwen@hygon.cn>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 4, 2020 at 5:34 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Rework the masking in the out-of-range CPUID logic to handle the
> Hypervisor sub-classes, as well as the Centaur class if the guest
> virtual CPU vendor is Centaur.
>
> Masking against 0x80000000 only handles basic and extended leafs, which
> results in Hypervisor range checks being performed against the basic
> CPUID class, and Centuar range checks being performed against the
> Extended class.  E.g. if CPUID.0x40000000.EAX returns 0x4000000A and
> there is no entry for CPUID.0x40000006, then function 0x40000006 would
> be incorrectly reported as out of bounds.
>
> While there is no official definition of what constitutes a class, the
> convention established for Hypervisor classes effectively uses bits 31:8
> as the mask by virtue of checking for different bases in increments of
> 0x100, e.g. KVM advertises its CPUID functions starting at 0x40000100
> when HyperV features are advertised at the default base of 0x40000000.
>
> The bad range check doesn't cause functional problems for any known VMM
> because out-of-range semantics only come into play if the exact entry
> isn't found, and VMMs either support a very limited Hypervisor range,
> e.g. the official KVM range is 0x40000000-0x40000001 (effectively no
> room for undefined leafs) or explicitly defines gaps to be zero, e.g.
> Qemu explicitly creates zeroed entries up to the Cenatur and Hypervisor
> limits (the latter comes into play when providing HyperV features).
>
> The bad behavior can be visually confirmed by dumping CPUID output in
> the guest when running Qemu with a stable TSC, as Qemu extends the limit
> of range 0x40000000 to 0x40000010 to advertise VMware's cpuid_freq,
> without defining zeroed entries for 0x40000002 - 0x4000000f.
>
> Note, documentation of Centaur/VIA CPUs is hard to come by.  Designating
> 0xc0000000 - 0xcfffffff as the Centaur class is a best guess as to the
> behavior of a real Centaur/VIA CPU.

Don't forget Transmeta's CPUID range at 0x80860000 through 0x8086FFFF!
