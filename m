Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B2FD95CC
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 17:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405457AbfJPPho (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 11:37:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38290 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405138AbfJPPhn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 11:37:43 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4D3947FDFB
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 15:37:43 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id n18so11889322wro.11
        for <kvm@vger.kernel.org>; Wed, 16 Oct 2019 08:37:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V6hR9H4+lxaTVZm42Obod2VDDJdFkvo/7dcvc/koK54=;
        b=jYK6S35s1FCjSPvA4h/0UM56XoODsAxYbxIhr9LaMZORs2dcEeYWIelJCm016j5GzI
         U/zHpcA9LXlhpB/V7YZ5wz9KDYidZZmcc4dgZoK895Wud7HW4B16l3oXwZSuoFh1Vtkx
         JMH5hQs7yRAHGFoAI4hIVhUXesekKK3/jbh+XHRGsfjfHisoVLgzx12a5svsl8s886tM
         96IYa3r/O5E4RHZel2YAzL2E02lb1hKzVSFzH3jTrXaNrRPZmky1l8F7+BhuC+6jQ9DJ
         Ds0XMowmzy96sr+FttFOZswgH3q4i9Rv0fgH58nBpWKkOaGR47wJqKCE+2B/cGKxjONg
         A5PA==
X-Gm-Message-State: APjAAAUY7hP/LfZFfUsgO5DLN/BhQ4bE7vzFi7AZS3qw3Gx/WvwTQqbs
        LO3SITo+cBlxMs5WlDaFJwkj/NBZ7Xu1Uk8LUpf2WrEXuJigYzQ8K7voNsHapmIyii14zcdSPHF
        Z7UFJEhxp5Fap
X-Received: by 2002:adf:eec4:: with SMTP id a4mr2808804wrp.38.1571240261721;
        Wed, 16 Oct 2019 08:37:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwt1fLjCxwAblIIbCXdSfq16TKVqcCfYDAFhjaP+M99q7uE0WC3rfXXLkAGNqMzvsZlJQDnSg==
X-Received: by 2002:adf:eec4:: with SMTP id a4mr2808772wrp.38.1571240261365;
        Wed, 16 Oct 2019 08:37:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d001:591b:c73b:6c41? ([2001:b07:6468:f312:d001:591b:c73b:6c41])
        by smtp.gmail.com with ESMTPSA id o18sm6831906wrm.11.2019.10.16.08.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 08:37:40 -0700 (PDT)
Subject: Re: [PATCH v9 09/17] x86/split_lock: Handle #AC exception for split
 lock
To:     Thomas Gleixner <tglx@linutronix.de>,
        Xiaoyao Li <xiaoyao.li@intel.com>
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
 <c3ff2fb3-4380-fb07-1fa3-15896a09e748@intel.com>
 <d30652bb-89fa-671a-5691-e2c76af231d0@redhat.com>
 <8808c9ac-0906-5eec-a31f-27cbec778f9c@intel.com>
 <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ba2c0aab-1d7c-5cfd-0054-ac2c266c1df3@redhat.com>
Date:   Wed, 16 Oct 2019 17:37:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1910161519260.2046@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/10/19 16:43, Thomas Gleixner wrote:
> 
> N | #AC       | #AC enabled | SMT | Ctrl    | Guest | Action
> R | available | on host     |     | exposed | #AC   |
> --|-----------|-------------|-----|---------|-------|---------------------
>   |           |             |     |         |       |
> 0 | N         |     x       |  x  |   N     |   x   | None
>   |           |             |     |         |       |
> 1 | Y         |     N       |  x  |   N     |   x   | None

So far so good.

> 2 | Y         |     Y       |  x  |   Y     |   Y   | Forward to guest
>
> 3 | Y         |     Y       |  N  |   Y     |   N   | A) Store in vCPU and
>   |           |             |     |         |       |    toggle on VMENTER/EXIT
>   |           |             |     |         |       |
>   |           |             |     |         |       | B) SIGBUS or KVM exit code

(2) is problematic for the SMT=y case, because of what happens when #AC 
is disabled on the host---safe guests can start to be susceptible to 
DoS.

For (3), which is the SMT=n case,, the behavior is the same independent of
guest #AC.

So I would change these two lines to:

  2 | Y         |     Y       |  Y  |   N     |   x   | On first guest #AC,
    |           |             |     |         |       | disable globally on host.
    |           |             |     |         |       |
  3 | Y         |     Y       |  N  |   Y     |   x   | Switch MSR_TEST_CTRL on
    |           |             |     |         |       | enter/exit, plus:
    |           |             |     |         |       | A) #AC forwarded to guest.
    |           |             |     |         |       | B) SIGBUS or KVM exit code

> 4 | Y         |     Y       |  Y  |   Y     |   N   | A) Disable globally on
>   |           |             |     |         |       |    host. Store in vCPU/guest
>   |           |             |     |         |       |    state and evtl. reenable
>   |           |             |     |         |       |    when guest goes away.
>   |           |             |     |         |       |
>   |           |             |     |         |       | B) SIGBUS or KVM exit code

Also okay.  And finally:

  5 | Y         |     Y       |  Y  |   Y     |   Y   | Forward to guest

> Now there are a two possible state transitions:

>  #AC enabled on host during runtime
> 
>    Existing guests are not notified. Nothing changes.

Switches from (1) to (2) or (4) and (5).  Ugly for (2) and (4A), in that
split-lock detection might end up being forcibly disabled on the host, but
guests do not notice anything.  Okay for (4B) and (5).

>  #AC disabled on host during runtime

Switches from (2), (4) and (5) to (1).  Bad for (4A) and (5), in that
guests might miss #ACs from userspace.  No problem for (2), okay for (4B)
since the host admin decision affects KVM userspace but not KVM guests.

Because (4A) and (5) are problematic, and (4B) can cause guests to halt
irrecoverably on guest #AC, I'd prefer the control not to be
exposed by default.  In KVM API terms:

- KVM_GET_SUPPORTED_CPUID should *not* return the new CPUID bit and
KVM_GET_MSR_INDEX_LIST should not return MSR_TEST_CTRL.  A separate
capability can be queried with KVM_CHECK_EXTENSION to determine whether
KVM supports split-lock detection is available.  The default behavior will
be (2).

- we only need to pick one of (3A)/(4A) and (3B)/(4B).  (3A) should definitely
be the default, probably (4A) too.  But if both are implemented, the
aforementioned capability can be used with KVM_ENABLE_CAP to switch from
one behavior to the other.

Paolo
