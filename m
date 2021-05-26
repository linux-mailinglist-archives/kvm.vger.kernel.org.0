Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3B239110F
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 08:55:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbhEZG50 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 02:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbhEZG5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 02:57:23 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5689CC061756
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 23:55:52 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso335336pjb.5
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 23:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OghfnCYzIco1oCB8DECwfdKUj+xfk1JNRs+3JjyLdXI=;
        b=CCftkdps53BVXky2a9t4INCXiuBpldrwHuYcfsj9FttPg9GWoJMIbrkQPyFn2MYHIf
         bkw6b6zp9AUYdfjPZQroCwWoeyRlmE/2TAfr3U37E7UB8yknBqC4cvY0lHPvUlROS9UD
         eao02dBf+HTJvDo3JdkmS0VaouKxD1I+3c1LTjCckBYxsaLqCMVotKxMKJtEZE1izPs6
         f812utp0zPSVIfJajOBZORYmQJu76xCDQYPyv06KK5Hh2/ftc1MNKSg0KycP8XdMDo6L
         nblUf2RnO1XQakl22pTpRPpHxuKKjUKg5PWuXVFDXzZ6OEYb0/MSMYpcVEnSnUtDzb38
         pnyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OghfnCYzIco1oCB8DECwfdKUj+xfk1JNRs+3JjyLdXI=;
        b=njTpCzYbsXZWq+SkTNyde7CO4b7H/7h7ejv0FMxp2rjLWg8CsdcEVZwOT1Sl566rza
         PERqtTzemsiMo04DvKu+7pa6lfh5vkNHYRyTb/MaKoVaTuFcIgw2PcpeNbnSbhjKza0I
         zmk9JEnwheMyNRdfq3z6hAeFI5NN/oYOVrJytCUNNt8EbMtR5REdaxvELuPvuDVhrJOo
         vmwgRuggy+d6t2XJTyFOd8ia/6L/3ePqdLQ0qF97nnY0XtQhaDPZ6z9XDPekogvnpk7M
         t4OZ0+RfRawA3N2Lb5tcIMLBLyL+YcgQicBQCLFvTVJqSV9tyyTvuGEFbiYBoFlFHzHk
         XIxA==
X-Gm-Message-State: AOAM530nfJrIokXNk74GIAnillIdwJTeWjkweOfBTCHP/q6wI6NaNtIk
        BSOP5/F/IRTGHZZB7FWkJi8t9VY4ny2KYvsjsNRarA==
X-Google-Smtp-Source: ABdhPJzyaejiTydXm07i/HmREiEYAcJNxFQUzAXDcvtQus1UwAnFRkMd3F6EUE8wkrNfH1tbPx7q4VrM4ztY4bhY21M=
X-Received: by 2002:a17:90a:6f06:: with SMTP id d6mr34723831pjk.216.1622012151775;
 Tue, 25 May 2021 23:55:51 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-17-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-17-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 25 May 2021 23:55:36 -0700
Message-ID: <CAAeT=FxQzCnMECRjSxi6J1KVdCnMaRYCOxeE-9efmN_BFFGsAw@mail.gmail.com>
Subject: Re: [PATCH 16/43] KVM: VMX: Stuff vcpu->arch.apic_base directly at
 vCPU RESET
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

On Fri, Apr 23, 2021 at 5:50 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Write vcpu->arch.apic_base directly instead of bouncing through
> kvm_set_apic_base().  This is a glorified nop, and is a step towards
> cleaning up the mess that is local APIC creation.
>
> When using an in-kernel APIC, kvm_create_lapic() explicitly sets
> vcpu->arch.apic_base to MSR_IA32_APICBASE_ENABLE to avoid its own
> kvm_lapic_set_base() call in kvm_lapic_reset() from triggering state
> changes.  That call during RESET exists purely to set apic->base_address
> to the default base value.  As a result, by the time VMX gets control,
> the only missing piece is the BSP bit being set for the reset BSP.
>
> For a userspace APIC, there are no side effects to process (for the APIC).
>
> In both cases, the call to kvm_update_cpuid_runtime() is a nop because
> the vCPU hasn't yet been exposed to userspace, i.e. there can't be any
> CPUID entries.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
