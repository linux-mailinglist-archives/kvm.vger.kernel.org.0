Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5AAA34E29
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727839AbfFDRAj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:00:39 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45570 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbfFDRAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:00:39 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so1892618wre.12
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:00:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=riT6wEPLQ4KsZpojwzOKkZqvOV48mi/3Dou4pUvlc9w=;
        b=Dp3sC4vbDj2R5OSXCl6vj+JoDS/1x2CSh/+EiLfVZycX/RZbs8nVlk2LmTzN8yo3hI
         VfDbvqYvLE+Ni00/6C3EJp7/rzQM/1RDTIOjZ9t24MiczMyj/sl664EGd2oqnPl5nzKW
         ZjKZTZIv92A3z0AUz4DiOrB11HnAnGN0P42keMgy5Gj1+VTCfjAxxJoKuWNaboeApTnW
         LvWTXVJ7c+4kdfcRssI7M/jA1tdpC1lNmKHikB5rRDKVjSB8B9f/mo936j4xwhbuXrXe
         T+epsB5vnXicOunlfaTPfbGHRuQ4dbaZSQrccoxqGVKejYvlgvUKv3YDkbigcU1YDRsd
         GLoA==
X-Gm-Message-State: APjAAAVYkylauDyweGlX3WIHXYtLnS275KzWUxNN6LYPeHP3ssuhiB3d
        GPakKEZjc63uDcuO7CoK9W4XFQ==
X-Google-Smtp-Source: APXvYqzICAVp6DhymatU3IrL4xvoXhOaS3p2RhSewcASAJYZDycpiY3vNJw2QBYIzbBrx3vwke4Xpg==
X-Received: by 2002:adf:ef48:: with SMTP id c8mr3496934wrp.352.1559667637449;
        Tue, 04 Jun 2019 10:00:37 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id u11sm12507046wrn.1.2019.06.04.10.00.36
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:00:36 -0700 (PDT)
Subject: Re: [PATCH] kvm: support guest access CORE cstate
To:     Wanpeng Li <kernellwp@gmail.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>
References: <1558419467-7155-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <7bca9a01-4450-df89-ac26-6b5fee103cbd@redhat.com>
Date:   Tue, 4 Jun 2019 19:00:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1558419467-7155-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/19 08:17, Wanpeng Li wrote:
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

Hi,

instead of this, with the new design I've proposed QEMU will have to
save/restore the MSRs, but otherwise no change is needed to
kvm_arch_init and to the KVM headers.

Paolo
