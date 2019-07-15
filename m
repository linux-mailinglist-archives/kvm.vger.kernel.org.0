Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB3668622
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 11:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729532AbfGOJRB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 05:17:01 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37998 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729257AbfGOJRB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 05:17:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so14387718wmj.3
        for <kvm@vger.kernel.org>; Mon, 15 Jul 2019 02:16:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v5fo+uSi73xpR+4ETmGVl9w7fmYmhPooNofZwTaxS60=;
        b=lE3ULvXTAh8w5ZlPEJlSTD0sheljPwYh65kW7l6PB2inadPWc97VQaZn7DoIa8Qa0N
         4sxzqGLJeA63duY9688zTg12AEGHABUcRWMAJZ2w+zs2MdtkBgYu+vCzLts0qQqIIkvr
         DLQ9kJ9/GEyYuQOnkq78SwZa/xYBxjzid0sgFUytdPKJes08DMLt8Es2bTXIXmGUASGm
         npH9T6MysShVm9dAwyVsqTj2jBhb+4vn4Lm72MXlD+l0BRbPDy+wqnWmZkka9NV64YpQ
         ToNbVfIinFu5pMzie485RkId1AM90uUFg33nhzEZBdOTVfGRqwCx4EOWeSb0q3fV3Pej
         TosQ==
X-Gm-Message-State: APjAAAXipDQmyDBM2MEURT7lt0ytBHKERQKk2t4/uMD+ZnhoamKndLgC
        PmGDWanqnpjopeCYhQKd444t3A==
X-Google-Smtp-Source: APXvYqx/8fS4DHovqQrXPURh4GRC5n8Wt1AN2V3TGuiwf2O7Uf1HvdjxSGYzf+fWQVXcWRo5LGl0GA==
X-Received: by 2002:a1c:20c3:: with SMTP id g186mr11970612wmg.15.1563182219160;
        Mon, 15 Jul 2019 02:16:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e983:8394:d6:a612? ([2001:b07:6468:f312:e983:8394:d6:a612])
        by smtp.gmail.com with ESMTPSA id x20sm12605163wmc.1.2019.07.15.02.16.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 02:16:58 -0700 (PDT)
Subject: Re: [PATCH RESEND] i386/kvm: support guest access CORE cstate
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <1563154124-18579-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ba3ae595-7f82-d17b-e8ed-6e86e9195ce5@redhat.com>
Date:   Mon, 15 Jul 2019 11:16:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1563154124-18579-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 15/07/19 03:28, Wanpeng Li wrote:
> From: Wanpeng Li <wanpengli@tencent.com>
> 
> Allow guest reads CORE cstate when exposing host CPU power management capabilities 
> to the guest. PKG cstate is restricted to avoid a guest to get the whole package 
> information in multi-tenant scenario.
> 
> Cc: Eduardo Habkost <ehabkost@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Radim Krčmář <rkrcmar@redhat.com>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

Hi,

QEMU is in hard freeze now.  This will be applied after the release.

Thanks,

Paolo

> ---
>  linux-headers/linux/kvm.h | 4 +++-
>  target/i386/kvm.c         | 3 ++-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index b53ee59..d648fde 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -696,9 +696,11 @@ struct kvm_ioeventfd {
>  #define KVM_X86_DISABLE_EXITS_MWAIT          (1 << 0)
>  #define KVM_X86_DISABLE_EXITS_HLT            (1 << 1)
>  #define KVM_X86_DISABLE_EXITS_PAUSE          (1 << 2)
> +#define KVM_X86_DISABLE_EXITS_CSTATE         (1 << 3)
>  #define KVM_X86_DISABLE_VALID_EXITS          (KVM_X86_DISABLE_EXITS_MWAIT | \
>                                                KVM_X86_DISABLE_EXITS_HLT | \
> -                                              KVM_X86_DISABLE_EXITS_PAUSE)
> +                                              KVM_X86_DISABLE_EXITS_PAUSE | \
> +                                              KVM_X86_DISABLE_EXITS_CSTATE)
>  
>  /* for KVM_ENABLE_CAP */
>  struct kvm_enable_cap {
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index 3b29ce5..49a0cc1 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -1645,7 +1645,8 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>          if (disable_exits) {
>              disable_exits &= (KVM_X86_DISABLE_EXITS_MWAIT |
>                                KVM_X86_DISABLE_EXITS_HLT |
> -                              KVM_X86_DISABLE_EXITS_PAUSE);
> +                              KVM_X86_DISABLE_EXITS_PAUSE |
> +                              KVM_X86_DISABLE_EXITS_CSTATE);
>          }
>  
>          ret = kvm_vm_enable_cap(s, KVM_CAP_X86_DISABLE_EXITS, 0,
> 

