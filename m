Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6D8249FCFF
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 16:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349636AbiA1Pmy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jan 2022 10:42:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbiA1Pmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jan 2022 10:42:53 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863B9C06173B
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 07:42:53 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id d1so6241061plh.10
        for <kvm@vger.kernel.org>; Fri, 28 Jan 2022 07:42:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8cQiGIW7LrGAvgSo7SrwK7BDrdq6t9tzSMhHudcU/rs=;
        b=cU5U0mO08WxFQS7m8O7fIDlpMlElcqhBbIXtvbv/0BX3a18uy6Og8Z95GVemMqvRJB
         Se7mIrefKld7NWk3xoHo5/t91eTSkWAZhj/1wSGFSoQLFhhQhAm6kYyuaD0eqWwbfPmw
         zmWtJiKcMN7DO5+9JDJIVI8CVVmfW5YsKpzh+obD/n8WePb7kM6uzmxNStCEvwjMJivb
         23yAEUSIx/rsz/AAcH6spyAKUZ/Gn3TiSFqhgA1rvBHervyLwrKNb9pbMWUR6LEftZLW
         TMcMhRPoJ9lyRlHjDIQtLoKOgmATRVSyvewMCjAgunRr8G/6pc5iYV9Ja+IxP62mpnKT
         t6+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8cQiGIW7LrGAvgSo7SrwK7BDrdq6t9tzSMhHudcU/rs=;
        b=MZdO+CDQtGSr+ZrCxFlPGK/LTFXUNGRJxfQWa0rSiAXmkM/jBA/B1An+Q6OJIgh9eY
         w0y+qE5T3wiMzuErXIbo+TgoA4k8zzoG9+LSEwFl7VQEHdWUneiUWqTokXQeC7709OIz
         lFBaXP2nAHvJqs56RvONn2ZkxG6gSBozI+tKbTiY31/ge0nPvb9SMFyybbhI1LLoTS8C
         +iTvD8bRCPSslEyeH/85iGbJvqCy7QQrb0u6Q+NvMNS0dEhQ5rp27sTJ3xtV5h4JUA7i
         gTBic8PpaOdRLCiG+Ud2wrg0K4BlG7loW9T9uRVm4okMJZOCMCdNfS6MSh3rR1UOMLXI
         l5TA==
X-Gm-Message-State: AOAM533BUpcvmUq6oeG7gk0z9dlqjoBLDC1gMbjY1oMMIare1ANhM82X
        s6CiMMVgD5zCb3IQr+8Qj+Um/w==
X-Google-Smtp-Source: ABdhPJzGCRvVnPAS0yk1YsryL/2cBsLsN12clibk4RleUoV/vt2H4rWeK6zEg423wLzTB2+/HFvuZA==
X-Received: by 2002:a17:903:4053:: with SMTP id n19mr9357650pla.37.1643384572865;
        Fri, 28 Jan 2022 07:42:52 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t14sm2880879pjd.6.2022.01.28.07.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Jan 2022 07:42:52 -0800 (PST)
Date:   Fri, 28 Jan 2022 15:42:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Subject: Re: [PATCH 01/22] KVM: x86: Drop unnecessary and confusing
 KVM_X86_OP_NULL macro
Message-ID: <YfQO+ADS1wnefoSr@google.com>
References: <20220128005208.4008533-1-seanjc@google.com>
 <20220128005208.4008533-2-seanjc@google.com>
 <152db376-b0f3-3102-233c-a0dbb4011d0c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <152db376-b0f3-3102-233c-a0dbb4011d0c@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 28, 2022, Paolo Bonzini wrote:
> On 1/28/22 01:51, Sean Christopherson wrote:
> > Drop KVM_X86_OP_NULL, which is superfluous and confusing.  The macro is
> > just a "pass-through" to KVM_X86_OP; it was added with the intent of
> > actually using it in the future, but that obviously never happened.  The
> > name is confusing because its intended use was to provide a way for
> > vendor implementations to specify a NULL pointer, and even if it were
> > used, wouldn't necessarily be synonymous with declaring a kvm_x86_op as
> > DEFINE_STATIC_CALL_NULL.
> > 
> > Lastly, actually using KVM_X86_OP_NULL as intended isn't a maintanable
> > approach, e.g. bleeds vendor details into common x86 code, and would
> > either be prone to bit rot or would require modifying common x86 code
> > when modifying a vendor implementation.
> 
> I have some patches that redefine KVM_X86_OP_NULL as "must be used with
> static_call_cond".  That's a more interesting definition, as it can be used
> to WARN if KVM_X86_OP is used with a NULL function pointer.

I'm skeptical that will actually work well and be maintainble.  E.g. sync_pir_to_ir()
must be explicitly check for NULL in apic_has_interrupt_for_ppr(), forcing that path
to do static_call_cond() will be odd.  Ditto for ops that are wired up to ioctl()s,
e.g. the confidential VM stuff, and for ops that are guarded by other stuff, e.g. the
hypervisor timer.

Actually, it won't just be odd, it will be impossible to disallow NULL a pointer
for KVM_X86_OP and require static_call_cond() for KVM_X86_OP_NULL.  static_call_cond()
forces the return to "void", so any path that returns a value needs to be manually
guarded and can't use static_call_cond(), e.g.

arch/x86/kvm/x86.c: In function ‘kvm_arch_vm_ioctl’:
arch/x86/kvm/x86.c:6450:19: error: void value not ignored as it ought to be
 6450 |                 r = static_call_cond(kvm_x86_mem_enc_ioctl)(kvm, argp);
      |                   ^
