Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6EC6EA6F
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 20:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729485AbfGSSB1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 14:01:27 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40524 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727497AbfGSSB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 14:01:27 -0400
Received: by mail-wm1-f65.google.com with SMTP id v19so29820287wmj.5
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 11:01:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=glVXcYJgC6+xN1fJyxN8vMROWGd0QRIs5qsZ+/VfNTE=;
        b=miysL0C44heG7pfCwt/GtjcFK9NcsnchZrb2AoCThV99NspiuOiI91r9vc7/urdRrK
         5NoIwljRFDtkkOB/FBzSAZGz/sB1Gplm+wFVP1U8CHMd7dg0LVBDoOaloe2nWizDkQEJ
         6VIngXauO1KOJM5pn4fBtdFkxlqg/CzdjH1Iv+IMPhfo5ecXesgmvaGI2GGovXfBZsGO
         HvyTktRlFHLOiZ7e0m7hAE1f1Hvn9ukcFbZ7Hudqv/mHTJV1WYpujL8XWezE8YP0l1kM
         QBJRRsNqDhb/lQDMrk40eLQN9KoS46Wuxdt19G5NwDqpnStHAB468MNdTlup6HijZvL/
         LNnQ==
X-Gm-Message-State: APjAAAUsho1poMsQsCpM/sv43fC4AND2Ejia0fPdU487TDG5FD/NLqtC
        pKixTLipm2A9nirQHFPDSUTP/YOJ8mo=
X-Google-Smtp-Source: APXvYqy4kgeauWud2yowIbe5ZmJJGhSxCjr/9dtHvZTr9LUuzJclaFN62/heA68sUOhgsEliqPlzqg==
X-Received: by 2002:a1c:6882:: with SMTP id d124mr48027233wmc.40.1563559284590;
        Fri, 19 Jul 2019 11:01:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8501:6b03:f18c:74f8? ([2001:b07:6468:f312:8501:6b03:f18c:74f8])
        by smtp.gmail.com with ESMTPSA id y7sm23970213wmm.19.2019.07.19.11.01.23
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 11:01:24 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: VMX: Preemptivly optimize VMX instrs
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org
References: <20190719172540.7697-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <dc2e7ed5-bc1c-6392-9e12-ff9284e7a9f4@redhat.com>
Date:   Fri, 19 Jul 2019 20:01:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190719172540.7697-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/07/19 19:25, Sean Christopherson wrote:
> An in-flight patch[1] to make __kvm_handle_fault_on_reboot() play nice
> with objtool will add a JMP after most VMX instructions so that the reboot
> macro can use an actual CALL to kvm_spurious_fault() instead of a funky
> PUSH+JMP facsimile.
> 
> Rework the low level VMX instruction helpers to handle unexpected faults
> manually instead of relying on the "fault on reboot" macro.  By using
> asm-goto, most helpers can branch directly to an in-function call to
> kvm_spurious_fault(), which can then be optimized by compilers to reside
> out-of-line at the end of the function instead of inline as done by
> "fault on reboot".
> 
> The net impact relative to the current code base is more or less a nop
> when building with a compiler that supports __GCC_ASM_FLAG_OUTPUTS__.
> A bunch of code that was previously in .fixup gets moved into the slow
> paths of functions, but the fast paths are more basically unchanged.
> 
> Without __GCC_ASM_FLAG_OUTPUTS__, manually coding the Jcc is a net
> positive as CC_SET() without compiler support almost always generates a
> SETcc+CMP+Jcc sequence, which is now replaced with a single Jcc.
> 
> A small bonus is that the Jcc instrs are hinted to predict that the VMX
> instr will be successful.
> 
> [1] https://lkml.kernel.org/r/64a9b64d127e87b6920a97afde8e96ea76f6524e.1563413318.git.jpoimboe@redhat.com
> 
> Sean Christopherson (4):
>   objtool: KVM: x86: Check kvm_rebooting in kvm_spurious_fault()
>   KVM: VMX: Optimize VMX instruction error and fault handling
>   KVM: VMX: Add error handling to VMREAD helper
>   KVM: x86: Drop ____kvm_handle_fault_on_reboot()
> 
>  arch/x86/include/asm/kvm_host.h |  6 +--
>  arch/x86/kvm/vmx/ops.h          | 93 ++++++++++++++++++++-------------
>  arch/x86/kvm/vmx/vmx.c          | 42 +++++++++++++++
>  arch/x86/kvm/x86.c              |  3 +-
>  tools/objtool/check.c           |  1 -
>  5 files changed, 102 insertions(+), 43 deletions(-)
> 

Sean, would you mind basing these on top of Josh's patches, so that
Peter can add them to his tree?

Paolo
