Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C95806EA71
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 20:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730352AbfGSSBm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 14:01:42 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33767 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729769AbfGSSBm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 14:01:42 -0400
Received: by mail-wm1-f68.google.com with SMTP id h19so24224728wme.0
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 11:01:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HWXDGs03LlwJgYH9CB+elGBEaKY5SGGpnZ0sOz+NTWM=;
        b=fDt4HyXOP/+uLorqNBhFgmR7IT1QUp9IbkDm5AxD5eSvhm0Uw2CzImmthlDHRmBp3A
         TcJO801jAtatLg8iV02ALq1QWu2tIEKdvFdvRcatNbU1MMwWUqWzfO2UPjDMikOhqUuG
         HEYcmxw6uOozDjEoIhjAp2Gdf4KN4itMrVG0af5Apib0aifPkOOqa60dJ4uE6vjAfVpM
         IKtWC6zu8pN91J0hCApswipQ9cO2ilXcz75gWrzwZM/ANMxJnLb52YbGnjKg/wvZAy36
         XHlZ1hTPbQMD0JbPhv+wQWkFZMTX4i3cWVEV8XxokUbQEq3B34jlQeuVlwUGlQ5vUsV9
         TrGA==
X-Gm-Message-State: APjAAAU7jwZX9ByA7K9yVpor+9Jsaid4c17V9vDgEYJtaS3nXXGx4qvt
        Y9q0PA6PkFA8+GIFGqMUBMi4A2+xh0A=
X-Google-Smtp-Source: APXvYqy+61UZz3eVi81de4LKKGy7PvriR8Az4/nlqbO5YAmACxnWuvq/jWI86zBPsjaZNF+KsZQHGA==
X-Received: by 2002:a7b:c215:: with SMTP id x21mr49378944wmi.38.1563559299814;
        Fri, 19 Jul 2019 11:01:39 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8501:6b03:f18c:74f8? ([2001:b07:6468:f312:8501:6b03:f18c:74f8])
        by smtp.gmail.com with ESMTPSA id l2sm21115094wmj.4.2019.07.19.11.01.39
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 11:01:39 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: VMX: Preemptivly optimize VMX instrs
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     kvm@vger.kernel.org
References: <20190719172540.7697-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <0113d029-11b9-1955-907b-3dbc9ccd0b91@redhat.com>
Date:   Fri, 19 Jul 2019 20:01:38 +0200
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

Very nice - series

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
