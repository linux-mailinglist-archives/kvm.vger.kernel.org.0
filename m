Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC595D472
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbfGBQkB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:40:01 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43231 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbfGBQkB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:40:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id p13so18588613wru.10
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:40:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=89JzHazKkLt0rnC7Q/hksVSrRUZdomcRTw+AhbuGiRM=;
        b=k9f0GLOcnSr4+8t/dkcaX5eBgCZhS2Jwjqrf4GtJumVVe/w59mqwEP/ZVUd5Udjd+f
         S2ikIdpQtrfYGVIkz7j4mmAqqmIL68XbDqF8Wwvv50kraVYvq9GjyLbUvxJb+Mldawsp
         sh54hEHjIliYBjbJ8D3YMVb9KwF75bmV9uylIWrJxoKD0BUnf1kXIm/mU8ykMuIki7cK
         IVkZ/Cpw89okTlA8qFI0LkG+X/tZ7ZLz7+/eQE3+KHbb3yWUvBDvBXK7TvvEIO00kgr5
         9LWY5p7Whj23U2gaDsrwqjFVkagySa72+FfpPFBCoj2z8dDd8pnTpTNkML0SYgZfeqF4
         NBZQ==
X-Gm-Message-State: APjAAAVEldIDChUrgW0JmdEyWm2GKmm8W2oSfmTYFxFQ6iNcHMcdfv4q
        t4tC74eFI7GEOotqOA39OfTbww==
X-Google-Smtp-Source: APXvYqy5EHQlpOFDkiKzKqbJ6+g1TVh8VsVpOr4feuxwdnA1jIV4TrmY3bMpw/b27dqFIiJf+ZfKjA==
X-Received: by 2002:a5d:470d:: with SMTP id y13mr19747003wrq.81.1562085599683;
        Tue, 02 Jul 2019 09:39:59 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id d201sm2155255wmd.19.2019.07.02.09.39.58
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:39:58 -0700 (PDT)
Subject: Re: [PATCH] target/i386: kvm: Fix when nested state is needed for
 migration
To:     Liran Alon <liran.alon@oracle.com>, qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Karl Heubaum <karl.heubaum@oracle.com>
References: <20190624230514.53326-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6499083f-c159-1c3e-0339-87aa5b13c2c0@redhat.com>
Date:   Tue, 2 Jul 2019 18:39:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190624230514.53326-1-liran.alon@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/06/19 01:05, Liran Alon wrote:
> When vCPU is in VMX operation and enters SMM mode,
> it temporarily exits VMX operation but KVM maintained nested-state
> still stores the VMXON region physical address, i.e. even when the
> vCPU is in SMM mode then (nested_state->hdr.vmx.vmxon_pa != -1ull).
> 
> Therefore, there is no need to explicitly check for
> KVM_STATE_NESTED_SMM_VMXON to determine if it is necessary
> to save nested-state as part of migration stream.
> 
> In addition, destination must enable eVMCS if it is enabled on
> source as specified by the KVM_STATE_NESTED_EVMCS flag, even if
> the VMXON region is not set. Thus, change the code to require saving
> nested-state as part of migration stream in case it is set.
> 
> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> Signed-off-by: Liran Alon <liran.alon@oracle.com>
> ---
>  target/i386/machine.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/target/i386/machine.c b/target/i386/machine.c
> index 851b249d1a39..e7d72faf9e24 100644
> --- a/target/i386/machine.c
> +++ b/target/i386/machine.c
> @@ -999,7 +999,7 @@ static bool vmx_nested_state_needed(void *opaque)
>  
>      return ((nested_state->format == KVM_STATE_NESTED_FORMAT_VMX) &&
>              ((nested_state->hdr.vmx.vmxon_pa != -1ull) ||
> -             (nested_state->hdr.vmx.smm.flags & KVM_STATE_NESTED_SMM_VMXON)));
> +             (nested_state->flags & KVM_STATE_NESTED_EVMCS)));
>  }
>  
>  static const VMStateDescription vmstate_vmx_nested_state = {
> 

Queued, thanks.

Paolo
