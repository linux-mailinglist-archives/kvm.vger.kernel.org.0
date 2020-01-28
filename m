Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44CBA14B1D5
	for <lists+kvm@lfdr.de>; Tue, 28 Jan 2020 10:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgA1Jjr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jan 2020 04:39:47 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34157 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725271AbgA1Jjq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Jan 2020 04:39:46 -0500
Received: by mail-pg1-f194.google.com with SMTP id r11so6693156pgf.1
        for <kvm@vger.kernel.org>; Tue, 28 Jan 2020 01:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Zmy0r6q/FqjUGXy2IPzJQRkxgciGCHgHr3RawgBkybI=;
        b=Pb7PR2UOi5E4xxu2nOS/APG5nHPwHRKtCDigGSGKaQK3uOqQxw3hlOcCu2CrIKdmt7
         SfVLxTpQjiCSpdSqDr1804aDJBTxuAFlODdJ7LwOy0p5ULZsbMG8SE0U/3zBq4dgcijz
         DVm//YgRWqSYRxCyZ4CuXCuOeeQ4hAPDAEQD9aSxcE+WLz8um3eWlX2CJZkc8X63yh2D
         Iyyk8fsuSAegSJ52ZEzHNdXgjrOMHezFJSZ9JHpqwqVVJ61uCKTq3IVwPW6SryX2llqm
         L0eScEQGb7lkCYR/42W80BsmFC063tyezGYZMbm8N5NrX3YG3b3MZF/KPfyYGyX+HzBa
         NGDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Zmy0r6q/FqjUGXy2IPzJQRkxgciGCHgHr3RawgBkybI=;
        b=M+iH53KX0WEgItjgsxbXcVb+mn+pnHRHh+VHtlsFrzi628/U4CofdfXGq7N2bBbebW
         JS3E0eeygCDiNpBKWxB0nSploZNhlxhkgexFqYaVoaY89kMOXTSgeUfTXvOuVvuuPjV8
         oCadCpoZBhvYrI2HsER8XMpbubgSzHE6Dc5VtZOYR5l7ZCdm1ZGghSC/UxuP1VH69nfQ
         MpnFES+yePgVcr5YDSbeKnbRsAqfT0g0cge3mjDYcowtwEUph0P86eiIyd1gAs6PKfNM
         a8/Lb+i6qHZKtGNagtZRlmOMqpRLWP3rgc9rwWmNpZPI1T+lSakEfaL4zO6RE/lvKrSW
         K7mg==
X-Gm-Message-State: APjAAAVcXX3q3M9w2qtsLw8rr5gqF8NZM2EIsDNfIlqiuI1wEKgY1rmp
        +6/2AQlQ/z33piwzbGAyerKOaZqvsK4=
X-Google-Smtp-Source: APXvYqwj8BWykneFPXctGV3d4LMxVbS3MKpJfTfo7Ij6RkyYPwGu8RCvtHu04v603/H3hKYKzoRrnQ==
X-Received: by 2002:a63:181a:: with SMTP id y26mr24643742pgl.423.1580204385129;
        Tue, 28 Jan 2020 01:39:45 -0800 (PST)
Received: from google.com ([2620:15c:100:202:d78:d09d:ec00:5fa7])
        by smtp.gmail.com with ESMTPSA id x66sm11484445pfd.71.2020.01.28.01.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2020 01:39:44 -0800 (PST)
Date:   Tue, 28 Jan 2020 01:39:40 -0800
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v2 0/5] Handle monitor trap flag during instruction
 emulation
Message-ID: <20200128093940.GA85872@google.com>
References: <20200128092715.69429-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200128092715.69429-1-oupton@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 28, 2020 at 01:27:10AM -0800, Oliver Upton wrote:
> v1: http://lore.kernel.org/r/20200113221053.22053-1-oupton@google.com
> 
> v1 => v2:
>  - Don't split the #DB delivery by vendors. Unconditionally injecting
>    #DB payloads into the 'pending debug exceptions' field will cause KVM
>    to get stuck in a loop. Per the SDM, when hardware injects an event
>    resulting from this field's value, it is checked against the
>    exception interception bitmap.
>  - Address Sean's comments by injecting the VM-exit into L1 from
>    vmx_check_nested_events().
>  - Added fix for nested INIT VM-exits + 'pending debug exceptions' field
>    as it was noticed in implementing v2.
>  - Drop Peter + Jim's Reviewed-by tags, as the patch set has changed
>    since v1.
> 
> KVM already provides guests the ability to use the 'monitor trap flag'
> VM-execution control. Support for this flag is provided by the fact that
> KVM unconditionally forwards MTF VM-exits to the guest (if requested),
> as KVM doesn't utilize MTF. While this provides support during hardware
> instruction execution, it is insufficient for instruction emulation.
> 
> Should L0 emulate an instruction on the behalf of L2, L0 should also
> synthesize an MTF VM-exit into L1, should control be set.
> 
> The first patch corrects a nuanced difference between the definition of
> a #DB exception payload field and DR6 register. Mask off bit 12 which is
> defined in the 'pending debug exceptions' field when applying to DR6,
> since the payload field is said to be compatible with the aforementioned
> VMCS field.
> 
> The second patch sets the 'pending debug exceptions' VMCS field when
> delivering an INIT signal VM-exit to L1, as described in the SDM. This
> patch also introduces helpers for setting the 'pending debug exceptions'
> VMCS field.
> 
> The third patch massages KVM's handling of exception payloads with
> regard to API compatibility. Rather than immediately injecting the
> payload w/o opt-in, instead defer the payload + immediately inject
> before completing a KVM_GET_VCPU_EVENTS. This maintains API
> compatibility whilst correcting #DB behavior with regard to higher
> priority VM-exit events.
> 
> Fourth patch introduces MTF implementation for emulated instructions.
> Identify if an MTF is due on an instruction boundary from
> kvm_vcpu_do_singlestep(), however only deliver this VM-exit from
> vmx_check_nested_events() to respect the relative prioritization to
> other VM-exits. Since this augments the nested state, introduce a new
> flag for (de)serialization.
> 
> Last patch adds tests to kvm-unit-tests to assert the correctness of MTF
> under several conditions (concurrent #DB trap, #DB fault, etc). These
> tests pass under virtualization with this series as well as on
> bare-metal.

Based on tip of kvm/next as of Jan 28:

f1b0bc14f2db ("KVM: x86: Use a typedef for fastop functions")


> Oliver Upton (4):
>   KVM: x86: Mask off reserved bit from #DB exception payload
>   KVM: nVMX: Handle pending #DB when injecting INIT VM-exit
>   KVM: x86: Deliver exception payload on KVM_GET_VCPU_EVENTS
>   KVM: nVMX: Emulate MTF when performing instruction emulation
> 
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/include/uapi/asm/kvm.h |  1 +
>  arch/x86/kvm/svm.c              |  1 +
>  arch/x86/kvm/vmx/nested.c       | 60 ++++++++++++++++++++++++++++++++-
>  arch/x86/kvm/vmx/nested.h       |  5 +++
>  arch/x86/kvm/vmx/vmx.c          | 22 ++++++++++++
>  arch/x86/kvm/vmx/vmx.h          |  3 ++
>  arch/x86/kvm/x86.c              | 52 +++++++++++++++++-----------
>  8 files changed, 125 insertions(+), 20 deletions(-)
> 
> -- 
> 2.25.0.341.g760bfbb309-goog
> 
