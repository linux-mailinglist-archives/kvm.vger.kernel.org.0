Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02D83BF264
	for <lists+kvm@lfdr.de>; Thu,  8 Jul 2021 01:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhGGXZd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jul 2021 19:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbhGGXZc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jul 2021 19:25:32 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35230C06175F
        for <kvm@vger.kernel.org>; Wed,  7 Jul 2021 16:22:50 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id j199so3724174pfd.7
        for <kvm@vger.kernel.org>; Wed, 07 Jul 2021 16:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iKd8HDMrjBFzk0VAe0M8v1m4ouhHl4ySw1cEWElJcmo=;
        b=Er5fM8T7T1Q/k5rScY29CLM72/C2mVp6/IuOE2sL3+ynyAkqXl+OqtmcGoryLo3xH6
         nmgM2zQeQJ6Nvi6x0SZZ2TUaTrUJ6CYQ316Tv0MdHI2cOe4uRG7XzBHt3YluxiW1tEpD
         D330D6W/kSyivKd5O4tzPi/E/6Vq0woMdaMbLxCucEuxMvlB/jX8aYHbMlFHJLiWOkCg
         NJFrg5bMTWkSacvpRXspojqxjmEVrdUhjyY8OTdiie5sewZQI2aNhpuoEBEYPl9AEmvB
         K60041p4jIk9NqOqOxyqOETbMFjByP9IKKrWVLAsBbugikVQ5Z5TxTClNkYAlYkhhw8z
         rzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iKd8HDMrjBFzk0VAe0M8v1m4ouhHl4ySw1cEWElJcmo=;
        b=Fo8nuE102Qtz+KhP1NdcoVIhQlvTO8+AOlvUgtpfSKFwZ1hsyvH5E2ySH5DQArSyS1
         cFbhpR9G3CtJuiO8zS/s4UENl6k3Ag1YEcSVsgFbvtIWdgW6DIgMcngCmdb+K4fhouEy
         ea0vsIIsCW21hBghV+IidjQrg8SVej060ZznqkW8sQ2MkU1lK5vH2rVFm2jo49KFLV39
         KePIiAdfBhxvUR1xrNMTpaFQWdlwPBJnS0SjjDEEKN9fMnMMVzNy5HVlEc3rONwiZkie
         WILR0TNNL+wYf9Ne89i8JdR8XLujCkeGgWdjPYUibbOcsMXTA3S7tvvD7HYVvfR5l/9N
         4yqA==
X-Gm-Message-State: AOAM532f1hFG83SyGE7fRZpJLSLydotPQLXG8bxuqk1id4AiaamBKynT
        FqFWcT792AC832GKHk4uJABODw==
X-Google-Smtp-Source: ABdhPJzh9BGFbFuxvGs7no5halNClQJ4ARXKZ11cDaqJQcr3A1ELX4x6t3WE8OWICjaRF3XoWpfe/Q==
X-Received: by 2002:aa7:9d1a:0:b029:30f:df6a:77aa with SMTP id k26-20020aa79d1a0000b029030fdf6a77aamr27238659pfp.35.1625700169406;
        Wed, 07 Jul 2021 16:22:49 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id w5sm284204pfu.121.2021.07.07.16.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 16:22:48 -0700 (PDT)
Date:   Wed, 7 Jul 2021 23:22:44 +0000
From:   David Matlack <dmatlack@google.com>
To:     David Edmondson <david.edmondson@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 0/2] kvm: x86: Convey the exit reason to user-space on
 emulation failure
Message-ID: <YOY3RP8iLuWl1Zwh@google.com>
References: <20210706101207.2993686-1-david.edmondson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210706101207.2993686-1-david.edmondson@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 06, 2021 at 11:12:05AM +0100, David Edmondson wrote:
> To help when debugging failures in the field, if instruction emulation
> fails, report the VM exit reason to userspace in order that it can be
> recorded.
> 
> I'm unsure whether sgx_handle_emulation_failure() needs to be adapted
> to use the emulation_failure part of the exit union in struct kvm_run
> - advice welcomed.
> 
> v2:
> - Improve patch comments (dmatlack)
> - Intel should provide the full exit reason (dmatlack)

I just asked if Intel should provide the full exit reason, I do not have
an opinion either way. It really comes down to your usecase for wanting
the exit reason. Would the full exit reason be useful or do you just
need the basic exit number?

> - Pass a boolean rather than flags (dmatlack)
> - Use the helper in kvm_task_switch() and kvm_handle_memory_failure()
>   (dmatlack)
> - Describe the exit_reason field of the emulation_failure structure
>   (dmatlack)
> 
> David Edmondson (2):
>   KVM: x86: Add kvm_x86_ops.get_exit_reason
>   KVM: x86: On emulation failure, convey the exit reason to userspace
> 
>  arch/x86/include/asm/kvm-x86-ops.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  3 +++
>  arch/x86/kvm/svm/svm.c             |  6 ++++++
>  arch/x86/kvm/vmx/vmx.c             | 11 +++++++----
>  arch/x86/kvm/x86.c                 | 22 +++++++++++++---------
>  include/uapi/linux/kvm.h           |  7 +++++++
>  6 files changed, 37 insertions(+), 13 deletions(-)
> 
> -- 
> 2.30.2
> 
