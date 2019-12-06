Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A03CB114F05
	for <lists+kvm@lfdr.de>; Fri,  6 Dec 2019 11:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbfLFK2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Dec 2019 05:28:44 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:43102 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfLFK2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Dec 2019 05:28:44 -0500
Received: by mail-ot1-f68.google.com with SMTP id p8so5355718oth.10
        for <kvm@vger.kernel.org>; Fri, 06 Dec 2019 02:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+8cUyT1Lf+4L8XZshnnb3bBeNvCQNOiW1dT/SRoEk8g=;
        b=t/kAR8owd+iRH0RQaZpGRqIj9UiatUZlb1TwI917jUpOOYVUQXPJitnior+gS9MBKF
         3aMWCk/7qZKq0YBF6blMcWZITPu5hkfDS8miw3f0ZPBjQRlhSLTqbriWWlxpPRsZwM8T
         z+efisOMoWCbHDXniczObHqUBRxVf6fgK0ewka/V21z+53gOuHRpXj+qj6KYBJOtBYMc
         5mFMW8cPjLJ2F2h5fhNE9FeP7FLEFlGyvcG4NBzAnGMnkcXwmvkhwLeCzslCMnvbfr61
         nLniwh0WTM8zsoK/eJeHcO3JSjc/d2tf2w2nwhwIXIlLOcVG74u+8sLwkF2zn54p7xhP
         M0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+8cUyT1Lf+4L8XZshnnb3bBeNvCQNOiW1dT/SRoEk8g=;
        b=e6xja00564oDvwcCZAioKcrxfyiT6QjiQOzSywWWRw3AN+TynEh49MRu2QzBW7Lt7A
         BUUnX36S+9VuNxmd7JUwBGWDWKhZE1udbrUps10tOXrNIvlZ3tG4w8tlRZ2owi7BW/rf
         ET7sWhKaAqUx2PaxjyWgeTa4Tmwkos0fSJjgDP38Jq9ReS0yoz+gDG2fOURmHRYn6FJI
         dIw/x5j+ZUHRqTCbfSgdXL6MmEZFPiotHD+cdFg1VLcL/xiZRbRI1IXSFaz78O5MMLLw
         UGSyUyNnT9Uons/fiC4Q61ZZLmph+3HAwpD1xXfKwh9/2FOKM7Bne7HLbWjciI+qmlPq
         9E4g==
X-Gm-Message-State: APjAAAXfBoyRe0ez67JJOksxMZmZFOd1pVeXKRvhMnXrWjGUUm9tMklY
        eFa2N87NmAIZ+fTl7XRKTB7/4mCI+L8GzDLWrBQ=
X-Google-Smtp-Source: APXvYqzvfujyFtYr5PZKgG2pftw8UMeLLVW5w8N1lQaid36Y//Wlghf0dxDXMCl2MuIcHlIM61+AXw4qGIDY2vXAwUU=
X-Received: by 2002:a9d:674f:: with SMTP id w15mr440865otm.243.1575628123545;
 Fri, 06 Dec 2019 02:28:43 -0800 (PST)
MIME-Version: 1.0
References: <3a1c97b2-789f-dd21-59ba-f780cf3bad92@redhat.com> <1575627817-24625-1-git-send-email-catherine.hecx@gmail.com>
In-Reply-To: <1575627817-24625-1-git-send-email-catherine.hecx@gmail.com>
From:   Catherine Ho <catherine.hecx@gmail.com>
Date:   Fri, 6 Dec 2019 18:28:32 +0800
Message-ID: <CAEn6zmGDOsOx7yG42MJxLMUAVUtKH2f8vjLLO5txZ=kUb-QpyQ@mail.gmail.com>
Subject: Re: [PATCH] target/i386: skip kvm_msr_entry_add when kvm_vmx_basic is 0
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        QEMU Developers <qemu-devel@nongnu.org>
Cc:     Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo and Eduardo
I digged into the put msr assertion bug a little more, and seems I
found the root cause.
Please have a review.

Best regards.
Catherine

On Fri, 6 Dec 2019 at 18:25, Catherine Ho <catherine.hecx@gmail.com> wrote:
>
> Commit 1389309c811b ("KVM: nVMX: expose VMX capabilities for nested
> hypervisors to userspace") expands the msr_based_features with
> MSR_IA32_VMX_BASIC and others. Then together with an old kernel before
> 1389309c811b, the qemu call KVM_GET_MSR_FEATURE_INDEX_LIST and got the
> smaller kvm_feature_msrs. Then in kvm_arch_get_supported_msr_feature(),
> searching VMX_BASIC will be failed and return 0. At last kvm_vmx_basic
> will be assigned to 0.
>
> Without this patch, it will cause a qemu crash (host kernel 4.15
> ubuntu 18.04+qemu 4.1):
> qemu-system-x86_64: error: failed to set MSR 0x480 to 0x0
> target/i386/kvm.c:2932: kvm_put_msrs: Assertion `ret ==
> cpu->kvm_msr_buf->nmsrs' failed.
>
> This fixes it by skipping kvm_msr_entry_add when kvm_vmx_basic is 0
>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Catherine Ho <catherine.hecx@gmail.com>
> ---
>  target/i386/kvm.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/target/i386/kvm.c b/target/i386/kvm.c
> index a8c44bf..8cf84a2 100644
> --- a/target/i386/kvm.c
> +++ b/target/i386/kvm.c
> @@ -2632,8 +2632,13 @@ static void kvm_msr_entry_add_vmx(X86CPU *cpu, FeatureWordArray f)
>                                           f[FEAT_VMX_SECONDARY_CTLS]));
>      kvm_msr_entry_add(cpu, MSR_IA32_VMX_EPT_VPID_CAP,
>                        f[FEAT_VMX_EPT_VPID_CAPS] | fixed_vmx_ept_vpid);
> -    kvm_msr_entry_add(cpu, MSR_IA32_VMX_BASIC,
> +
> +    if (kvm_vmx_basic) {
> +       /* Only add the entry when host supports it */
> +        kvm_msr_entry_add(cpu, MSR_IA32_VMX_BASIC,
>                        f[FEAT_VMX_BASIC] | fixed_vmx_basic);
> +    }
> +
>      kvm_msr_entry_add(cpu, MSR_IA32_VMX_MISC,
>                        f[FEAT_VMX_MISC] | fixed_vmx_misc);
>      if (has_msr_vmx_vmfunc) {
> --
> 1.7.1
>
