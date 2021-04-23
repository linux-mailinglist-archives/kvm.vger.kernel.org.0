Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB71F3696E6
	for <lists+kvm@lfdr.de>; Fri, 23 Apr 2021 18:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhDWQb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 12:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbhDWQbz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 12:31:55 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86004C061574
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 09:31:18 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id k18so44772342oik.1
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 09:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U2EXIvMnjtnhRUtBtSIOAaq4PzYyW6aIEs/mWjl+wGc=;
        b=mLDTOowF7V5GRwuBLTnc9OCTmJbvNzDDORiSx6GCBRlkZyLY57vHXAfAqC2TyMUBhF
         /BkFiE7MJ/7vYAedb3/vsKpBRkyEUdOxQQ+WH0fH21zvaDz/y+pO9hxuVHiI0V95jM+/
         e5i16Ft6BXJCYMQXjpS/43PdYDWs+g9+bh3QcLPgNbuyr4P5CkPjuHibHvNHAbu0sGdi
         /XhTh8VL6Zf9RFRkttCxBa0LlqpnGyAJwOG7zmU9xLPcPxnwAJMnhvXR8kPxTgy4kWom
         3iqWfUR+6WpcZWxlbpigL8IJ7Drfd0zxVjtKKUU1Aqnuu3AMLMZ8QPOwIATtwYSZ23hq
         2ZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U2EXIvMnjtnhRUtBtSIOAaq4PzYyW6aIEs/mWjl+wGc=;
        b=UFT2WJ+2KTeXqpZGRq9SXMnqkgPqwnkEmSmBMmO2c2JfhyHedONc/SlIeEGaW3gyJU
         lo+aULOyGg1XyXODZSVuFjkURByV9eLCYFhX4Of5gVouBjJHftDy29JD+zkax0rNrnhr
         natrSHGZz9hHX6Eu97ghaYUYtGoVtMdaAP5Hx4EMZfouCS+IgpHyDF1p5XYPXzrAfVkO
         vU4kWvhXlIluqJ+4e9pgD8TLgsIR3utz6+dhc8W3kjCz3FxPCiwQrAqEthtXJ7upUO7N
         /yNdFpfeTMzRL4mA9qHXFO7Txn+YH24/F3uQ4lVUlAPHWCegaTb+DzxzecheppEL8ozF
         ZIqQ==
X-Gm-Message-State: AOAM531pbRUMK232EnDA3LhS93VCPZ98RP8znjA63xmfCgFfeCVzanM1
        OJk/YeCLSVTML7Q4F/2Kn3ddwxW+q4d+6UQiqJVwXA==
X-Google-Smtp-Source: ABdhPJzLiUJkZg3Yh+AZMlqLEQ4kXy5Lgt3F3JyzdsTtw/M09nnRP+YyZ17L5abh81xiSIra4buqcRBgZjsuQGkfmMM=
X-Received: by 2002:aca:408b:: with SMTP id n133mr4631502oia.13.1619195477655;
 Fri, 23 Apr 2021 09:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1619193043.git.ashish.kalra@amd.com> <76ad1a3f7ce817e8d269a6d58293fc128678affc.1619193043.git.ashish.kalra@amd.com>
In-Reply-To: <76ad1a3f7ce817e8d269a6d58293fc128678affc.1619193043.git.ashish.kalra@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 23 Apr 2021 09:31:07 -0700
Message-ID: <CALMp9eTTC0kFbRt8TBC3x8N4mDism-xg3xEFSCPGiGc20pZ3ZQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: x86: invert KVM_HYPERCALL to default to VMMCALL
To:     Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H . Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steve Rutherford <srutherford@google.com>,
        Sean Christopherson <seanjc@google.com>,
        venu.busireddy@oracle.com, Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 9:00 AM Ashish Kalra <Ashish.Kalra@amd.com> wrote:
>
> From: Ashish Kalra <ashish.kalra@amd.com>
>
> KVM hypercall framework relies on alternative framework to patch the
> VMCALL -> VMMCALL on AMD platform. If a hypercall is made before
> apply_alternative() is called then it defaults to VMCALL. The approach
> works fine on non SEV guest. A VMCALL would causes #UD, and hypervisor
> will be able to decode the instruction and do the right things. But
> when SEV is active, guest memory is encrypted with guest key and
> hypervisor will not be able to decode the instruction bytes.
>
> So invert KVM_HYPERCALL and X86_FEATURE_VMMCALL to default to VMMCALL
> and opt into VMCALL.
>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: x86@kernel.org
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  arch/x86/include/asm/kvm_para.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
> index 338119852512..fda2fe0d1b10 100644
> --- a/arch/x86/include/asm/kvm_para.h
> +++ b/arch/x86/include/asm/kvm_para.h
> @@ -19,7 +19,7 @@ static inline bool kvm_check_and_clear_guest_paused(void)
>  #endif /* CONFIG_KVM_GUEST */
>
>  #define KVM_HYPERCALL \
> -        ALTERNATIVE("vmcall", "vmmcall", X86_FEATURE_VMMCALL)
> +       ALTERNATIVE("vmmcall", "vmcall", X86_FEATURE_VMCALL)
>
>  /* For KVM hypercalls, a three-byte sequence of either the vmcall or the vmmcall
>   * instruction.  The hypervisor may replace it with something else but only the
> --
> 2.17.1
>

Won't this result in the same problem when Intel implements full VM encryption?
