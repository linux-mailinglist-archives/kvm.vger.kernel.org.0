Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCEBFF0A86
	for <lists+kvm@lfdr.de>; Wed,  6 Nov 2019 00:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730555AbfKEX4V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Nov 2019 18:56:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15505 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729494AbfKEX4U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Nov 2019 18:56:20 -0500
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8646A83F3F
        for <kvm@vger.kernel.org>; Tue,  5 Nov 2019 23:56:20 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id c2so6517180wrt.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2019 15:56:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=06M8EIegAgG0v07Clyq4kGwN0RVfmrVZoqQU2t3v1Zs=;
        b=Z/MVoLQQnHXnbsCLgxPJtFqzzv34vGh14mnbXoKoqsHK331m9UxPDGQLFKrqb3uxNd
         ovCdG7skUxlDj3zqWc3ZqpXOeBsFV8dR/NBoR1qmbd3KHrvxAMxUa3cB50dutQMmZbSF
         ziGSWUuakEpR1HYggy/cS9dMyjvPKoxPYidkaw/8k2Qhzz9zcsPKoH98+1/mX2YO86Nq
         emIv70UXMRTjM/lwkrBECir3lvmiGMJhe4qBl3dMIJJFYrfR9Ou/WpMujNwkxHlT92Gm
         zlxnrgTRpiyLrzkFu4xjLe30ma8LDiKSuq4HCDa23vsl7KRy1DA0YHRve83wHzrXNQaR
         vjrA==
X-Gm-Message-State: APjAAAV4cnctLA1GcEfslKrkAFrq3ZEb2hVtJK1++BKE6ZIO7XVIkElf
        xaCDdhyL7BuOf/WUgz1RK+tThnrgABlftSMA54KLr5DD+TZwjNETZqlxYoLB317a6O30hTaKwKr
        Y5s6V0sC4MqaO
X-Received: by 2002:a1c:4606:: with SMTP id t6mr1208600wma.73.1572998179159;
        Tue, 05 Nov 2019 15:56:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqzo4uEw1UA97/7uwCK1BrInQ2RF0IfORXDnQy0cW0ZN2MjlHjscwGDB2jkOL9nU2PO9JMXwbg==
X-Received: by 2002:a1c:4606:: with SMTP id t6mr1208582wma.73.1572998178811;
        Tue, 05 Nov 2019 15:56:18 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id 4sm1154288wmd.33.2019.11.05.15.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2019 15:56:18 -0800 (PST)
Subject: Re: [PATCH RFC] KVM: x86: tell guests if the exposed SMT topology is
 trustworthy
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
References: <20191105161737.21395-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <de3cade3-c069-dc6b-1d2d-aa10abe365b8@redhat.com>
Date:   Wed, 6 Nov 2019 00:56:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191105161737.21395-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/11/19 17:17, Vitaly Kuznetsov wrote:
> There is also one additional piece of the information missing. A VM can be
> sharing physical cores with other VMs (or other userspace tasks on the
> host) so does KVM_FEATURE_TRUSTWORTHY_SMT imply that it's not the case or
> not? It is unclear if this changes anything and can probably be left out
> of scope (just don't do that).
> 
> Similar to the already existent 'NoNonArchitecturalCoreSharing' Hyper-V
> enlightenment, the default value of KVM_HINTS_TRUSTWORTHY_SMT is set to
> !cpu_smt_possible(). KVM userspace is thus supposed to pass it to guest's
> CPUIDs in case it is '1' (meaning no SMT on the host at all) or do some
> extra work (like CPU pinning and exposing the correct topology) before
> passing '1' to the guest.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  Documentation/virt/kvm/cpuid.rst     | 27 +++++++++++++++++++--------
>  arch/x86/include/uapi/asm/kvm_para.h |  2 ++
>  arch/x86/kvm/cpuid.c                 |  7 ++++++-
>  3 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/cpuid.rst b/Documentation/virt/kvm/cpuid.rst
> index 01b081f6e7ea..64b94103fc90 100644
> --- a/Documentation/virt/kvm/cpuid.rst
> +++ b/Documentation/virt/kvm/cpuid.rst
> @@ -86,6 +86,10 @@ KVM_FEATURE_PV_SCHED_YIELD        13          guest checks this feature bit
>                                                before using paravirtualized
>                                                sched yield.
>  
> +KVM_FEATURE_TRUSTWORTHY_SMT       14          set when host supports 'SMT
> +                                              topology is trustworthy' hint
> +                                              (KVM_HINTS_TRUSTWORTHY_SMT).
> +

Instead of defining a one-off bit, can we make:

ecx = the set of known "hints" (defaults to edx if zero)

edx = the set of hints that apply to the virtual machine

Paolo
