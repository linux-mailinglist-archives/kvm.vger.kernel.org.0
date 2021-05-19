Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5FB38870E
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:59:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbhESGBE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 02:01:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbhESGBD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 02:01:03 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9709AC06175F
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:59:43 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id g6-20020a17090adac6b029015d1a9a6f1aso2954635pjx.1
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nAKu+6MtH3s2XmeunaD2gUOZOf681k6swYOZ6Q7YH1o=;
        b=dl0Y3OWKdChY8uN3dxtupVDMeHqtfCUT/EAQIz6Lpivm3M3ZO/XZgAyyl3WX31vTCN
         Rtg+MIpdW7PDIup9To1oMb47EX46dRVS742LoPE8/m7vI9WHK5SFYS2tGTZmG2b65ccb
         l7NcMMixEl8mqbvSlav9WTXVpquyh3bkSsWFPRArj8yhzxJypS5LSLZ8dWukRe3CXwnE
         xOjuBdJg41kO+t11XTe9j1WAt2/VZY8yUvdNJjhtLMg5OzybUdtAvqLE/a4OYdhLzP8z
         zJ2VzCXrHdfRzBRXZigvh8/8z8r7ObdtjCbCyN03G8LJQAVHRhBFDi6Wl++/j//elAix
         H4kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nAKu+6MtH3s2XmeunaD2gUOZOf681k6swYOZ6Q7YH1o=;
        b=EYruBadIJflTy4rIva6OLEw7BzrwBtg5LGCgNm0DgGXy8avG4ZF3o6cfzW1std3UAe
         iOklDHa5nPZqx1KeZzWqibEgSFWih2HA/U1zqQIyxKI3n2IWvHRhABvmt2/m8X8p65kM
         /gPfped3+/A65dD4hSxmDo+cJVWZ/HwtWy7FPOXMnU4xADkswjhQxWwS0zvjCmnzCnsg
         0giz/PFNmx4ojrwEI3D9V2Q9pAWKMiUcdjzChqOm5WkGpdwRn0vVlfLCPxK1FROXup5w
         28WrgMpIloyEskvojeYz9+qncXiEMB9B0wOENJvySmSiAZAM8qDCxsEvZczEQwO2+ZIv
         tWYA==
X-Gm-Message-State: AOAM530Y6TnqDso30fXNCikLkJhzNq+RYfR7rwlTaoF1PlyKy3ZiP2cb
        QgNC9e65t3Z90+OZq+ZEHh2FTPUXVVEC/65IDPZTMQ==
X-Google-Smtp-Source: ABdhPJzJMo5cw4xYaWDtukM4Rsql7PyzgUfpSjgP4taVIiTuHnLSJ2O+n6zomR9cXECNjhMHzmORzEcZWeEDhyz/2Kg=
X-Received: by 2002:a17:902:f20c:b029:f0:af3d:c5d8 with SMTP id
 m12-20020a170902f20cb02900f0af3dc5d8mr8859697plc.23.1621403983010; Tue, 18
 May 2021 22:59:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-3-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-3-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 May 2021 22:59:27 -0700
Message-ID: <CAAeT=FyNo1CGvnamc3_J9EEQUn6WcdkMp50-QgmLYYVCFA2fZA@mail.gmail.com>
Subject: Re: [PATCH 02/43] KVM: VMX: Set EDX at INIT with CPUID.0x1, Family-Model-Stepping
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> @@ -4504,7 +4505,11 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>
>         vmx->msr_ia32_umwait_control = 0;
>
> -       vmx->vcpu.arch.regs[VCPU_REGS_RDX] = get_rdx_init_val();
> +       eax = 1;
> +       if (!kvm_cpuid(vcpu, &eax, &dummy, &dummy, &dummy, true))
> +               eax = get_rdx_init_val();
> +       kvm_rdx_write(vcpu, eax);

Reviewed-by: Reiji Watanabe <reijiw@google.com>

For RESET, I assume that rdx should be set by userspace
when userspace changes CPUID.0x1.EAX.

BTW, I would think having a default CPUID for CPUID.(EAX=0x1)
would be better for consistency of a vCPU state for RESET.
I would think it doesn't matter practically anyway though.

Thanks,
Reiji
