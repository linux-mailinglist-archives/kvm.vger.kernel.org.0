Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D573D2D342
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 03:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbfE2BYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 21:24:18 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36027 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfE2BYS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 21:24:18 -0400
Received: by mail-wm1-f68.google.com with SMTP id v22so373467wml.1
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 18:24:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UiPLvWA/ifZmBgOu5RY7iG79Uns1KHbXQ9v+2ITYDvE=;
        b=plD/C8yydzR2wxkimmSzrNTyz2m3smfysckl/5rUCblavlCgW4DqrpK++TxwAkObBF
         iYEVnOYl7gQhS2lybGz2rlYsgHkDMJvfIAPxztO2B7QTm147jRkSMNUxsG8qIEYYS1cF
         R3oxLY18w6nFrOH8H4SWNDnGNvJJzUYZFluGTJlOROIkSrGVwQv5NqWpSdXWK0fYLtZk
         3JdRBmlg9AduZJ3OTut+4bfB+aCye4lo/TqbqZ0ELzl5YM32dbQ2NAeaq9BtvtTBvKkt
         AaeTUhUFD1PupbwWCzNcjesNHqStacX0wFx9A5iuAVXOE4pyx5LIPi1sTjaUIBGNX9dx
         vQTA==
X-Gm-Message-State: APjAAAWHdRlX5dCM4pid+XzJgc+dfB+u7bmIFnE1uNrkaZaNdGI9zs5Y
        PfuCkKbIjW6Cva8wd+03u+f79Q==
X-Google-Smtp-Source: APXvYqyXLAZxyqIf9pbTP7YEBWBAjL4jFU3SBYm8nLl1/MmAXqgwazyQevT5XTPPFzfWUQKFyN+3qw==
X-Received: by 2002:a1c:23c4:: with SMTP id j187mr4908475wmj.176.1559093055974;
        Tue, 28 May 2019 18:24:15 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id f2sm7111992wrq.48.2019.05.28.18.24.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 18:24:15 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] KVM: x86: add support for user wait instructions
To:     Tao Xu <tao3.xu@intel.com>, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jingqi.liu@intel.com
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-2-tao3.xu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <419f62f3-69a8-7ec0-5eeb-20bed69925f2@redhat.com>
Date:   Wed, 29 May 2019 03:24:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524075637.29496-2-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/19 09:56, Tao Xu wrote:
> +7.19 KVM_CAP_ENABLE_USR_WAIT_PAUSE
> +
> +Architectures: x86
> +Parameters: args[0] whether feature should be enabled or not
> +
> +With this capability enabled, a VM can use UMONITOR, UMWAIT and TPAUSE
> +instructions. If the instruction causes a delay, the amount of
> +time delayed is called here the physical delay. The physical delay is
> +first computed by determining the virtual delay (the time to delay
> +relative to the VM’s timestamp counter). Otherwise, UMONITOR, UMWAIT
> +and TPAUSE cause an invalid-opcode exception(#UD).
> +

There is no need to make it a capability.  You can just check the guest
CPUID and see if it includes X86_FEATURE_WAITPKG.

Paolo
