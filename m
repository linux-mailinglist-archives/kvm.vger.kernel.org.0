Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2A63F04EF
	for <lists+kvm@lfdr.de>; Wed, 18 Aug 2021 15:37:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236767AbhHRNhz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Aug 2021 09:37:55 -0400
Received: from vps-vb.mhejs.net ([37.28.154.113]:39710 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233722AbhHRNhz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Aug 2021 09:37:55 -0400
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1mGLkN-0004Vy-54; Wed, 18 Aug 2021 15:36:47 +0200
Subject: Re: [PATCH] x86: kvm: Demote level of already loaded message from
 error to info
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20210818114956.7171-1-pmenzel@molgen.mpg.de>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Message-ID: <f9ba6fec-f764-dae7-e4f9-c532f4672359@maciej.szmigiero.name>
Date:   Wed, 18 Aug 2021 15:36:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210818114956.7171-1-pmenzel@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18.08.2021 13:49, Paul Menzel wrote:
> In scripts, running
> 
>      modprobe kvm_amd     2>/dev/null
>      modprobe kvm_intel   2>/dev/null
> 
> to ensure the modules are loaded causes Linux to log errors.
> 
>      $ dmesg --level=err
>      [    0.641747] [Firmware Bug]: TSC_DEADLINE disabled due to Errata; please update microcode to version: 0x3a (or later)
>      [   40.196868] kvm: already loaded the other module
>      [   40.219857] kvm: already loaded the other module
>      [   55.501362] kvm [1177]: vcpu0, guest rIP: 0xffffffff96e5b644 disabled perfctr wrmsr: 0xc2 data 0xffff
>      [   56.397974] kvm [1418]: vcpu0, guest rIP: 0xffffffff81046158 disabled perfctr wrmsr: 0xc1 data 0xabcd
>      [1007981.827781] kvm: already loaded the other module
>      [1008000.394089] kvm: already loaded the other module
>      [1008030.706999] kvm: already loaded the other module
>      [1020396.054470] kvm: already loaded the other module
>      [1020405.614774] kvm: already loaded the other module
>      [1020410.140069] kvm: already loaded the other module
>      [1020704.049231] kvm: already loaded the other module
> 
> As one of the two KVM modules is already loaded, KVM is functioning, and
> their is no error condition. Therefore, demote the log message level to
> informational.
> 

Shouldn't this return ENODEV when loading one of these modules instead
as there is no hardware that supports both VMX and SVM?

Thanks,
Maciej
