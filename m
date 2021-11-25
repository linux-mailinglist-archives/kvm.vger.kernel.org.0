Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1563A45E2EC
	for <lists+kvm@lfdr.de>; Thu, 25 Nov 2021 23:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343576AbhKYWTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Nov 2021 17:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhKYWRD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Nov 2021 17:17:03 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93E94C06173E;
        Thu, 25 Nov 2021 14:13:51 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id x6so30729771edr.5;
        Thu, 25 Nov 2021 14:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FmBDveGdYzfRFf0c4UcZyJUB+E6D6wLSxmJT8Ou2ANk=;
        b=JeYd2+EXDtNYgi5B3NnDoyeOAe3qPw3EHZd54XD4kbejmbGUxDZraPj41DbaZwKWkg
         TVyZkpTPGOtA43QKjCz8Be7rXN1YF1MSmQrm+m8Ox6EgbBDmUCTTlH7wUxITIWd1bcRr
         E3aRGo6jwkxiOGIXTmNfXfB7cDt0n8EYDp84SLQUtahKvjDeEZ6qgTVqoG37ZKpNijuQ
         sAj1jTCZRdYCthjIupuuYfmHbPahawYToeHKMLBC60H3ka5zX/AUeCeBb/UwWyTxVYJ6
         +P6fFGl3HsnvmB917F5vdUZr1hkwTnfRwob06dd81Kk2fYkmDPzZacKTXjIi9I2RwU8L
         p7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FmBDveGdYzfRFf0c4UcZyJUB+E6D6wLSxmJT8Ou2ANk=;
        b=Wxxe8tmCgnm+6RidZ4KQ78XTwe/kaFlPo5w+TqRXlitGUk+Cf7g93HOJy3TIbp3u9k
         Bna0LuJdjP3QOIqFLbyK2sauglUD4SYVnn+2W9uR558G9wakhPAUXfYXG9IriTDOk1KD
         MgoCN3aaqtf6MXu6Hx79jxbmCbCHWLCQk4/MW/XoCWKu1JrEgnRAJGpa8B199EXLQFQw
         m3pSgsqBXfO5bDJHpWIVUPlCtp0bUJjX7wRHPtHtSsOHDyBrUa/RYa2rj6AiUG4RnpXt
         KwydOBuaBdjOOTH/pU7zvXU+tVTeDoQsjxCRJV4DnAkHEBeGtxhEJkX2YyUZO7AybWuS
         CsUg==
X-Gm-Message-State: AOAM530pbMb4WbnUthHO5Y3vBoRcsApzTx2J6H/v9OAlk9C0E8vuUYck
        3HsZe++rdlr1vJGHjNDAYUI=
X-Google-Smtp-Source: ABdhPJxIMIcfZlp1yzImg6En8XI380O06uCXHZdqF32qgNoL4WiajLpUUlRqyDOeCcFC+EQAV9A0wg==
X-Received: by 2002:a17:906:c301:: with SMTP id s1mr34977187ejz.56.1637878430038;
        Thu, 25 Nov 2021 14:13:50 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id s4sm2332246ejn.25.2021.11.25.14.13.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 14:13:49 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <741df444-5cd0-2049-f93a-c2521e4f426d@redhat.com>
Date:   Thu, 25 Nov 2021 23:13:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH v3 54/59] KVM: X86: Introduce initial_tsc_khz in
 struct kvm_arch
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <5ba3573c8b82fcbdc3f3994f6d4d2a3c40445be9.1637799475.git.isaku.yamahata@intel.com>
 <875ysghrp8.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <875ysghrp8.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/25/21 22:05, Thomas Gleixner wrote:
> You can argue that my request is unreasonable until you are blue in
> your face, it's not going to lift my NAK on this.

There's no need for that.  I'd be saying the same, and I don't think 
it's particularly helpful that you made it almost a personal issue.

While in this series there is a separation of changes to existing code 
vs. new code, what's not clear is _why_ you have all those changes. 
These are not code cleanups or refactorings that can stand on their own 
feet; lots of the early patches are actually part of the new 
functionality.  And being in the form of "add an argument here" or 
"export a function there", it's not really easy (or feasible) to review 
them without seeing how the new functionality is used, which requires a 
constant back and forth between early patches and the final 2000 line file.

In some sense, the poor commit messages at the beginning of the series 
are just a symptom of not having any meat until too late, and then 
dropping it all at once.  There's only so much that you can say about an 
EXPORT_SYMBOL_GPL, the real thing to talk about is probably the thing 
that refers to that symbol.

If there are some patches that are actually independent, go ahead and 
submit them early.  But more practically, for the bulk of the changes 
what you need to do is:

1) incorporate into patch 55 a version of tdx.c that essentially does 
KVM_BUG_ON or WARN_ON for each function.  Temporarily keep the same huge 
patch that adds the remaining 2000 lines of tdx.c

2) squash the tdx.c stub with patch 44.

3) gather a strace of QEMU starting up a TDX domain.

4) figure out which parts of the code are needed to run until the first 
ioctl.  Make that a first patch.

5) repeat step 4 until you have covered all the code

5) Move the new "KVM: VMX: Add 'main.c' to wrap VMX and TDX" (which also 
adds the tdx.c stub) as possible in the series.

6) Move each of the new patches as early as possible in the series.

7) Look for candidates for squashing (e.g. commit messages that say it's 
"used later"; now the use should be very close and the two can be 
merged).  Add to the commit message a note about changes outside VMX.

The resulting series may not be perfect, but it would be a much better 
starting point for review.

Paolo
