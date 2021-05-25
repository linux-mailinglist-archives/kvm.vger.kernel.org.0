Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFB67390998
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 21:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbhEYTZ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 15:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232213AbhEYTZ5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 May 2021 15:25:57 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372ACC061574
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 12:24:27 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id j12so23548977pgh.7
        for <kvm@vger.kernel.org>; Tue, 25 May 2021 12:24:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QKF0Q+Cj5dqw+1V9/ENSF5mhLkWuMh2MHkTuwu+K/CI=;
        b=fr4sWzSd3XVB7jfkiZCPY+vyDnv1TIwh7GtyhxR9wwOKR1HVPPFfc9lb1KGLt8lRqz
         iJSvAFe6Iuj9wzt3pssa0K39BonULvT9Tskxx+tYzyviNQBkYxMfrGIl5fQZxPPYKJAe
         QIbQ9qrF1UkbdWbcEUYiIgbFYoMMhLCNerzwrPZwMzoj+2hvo22iAK1HHCNGPEl2rwsq
         HTGsgUi38SQqKkdHemHCIwCHmJOdkpBHRzf9n0O8GxpgSzOO5N88oD7869D7TGtw7Vm3
         RAOoXgLHx4rfLOET7xEeMwrxwHg1s/wmT4uUnS2oER8ErCQJ8JjuUv4e8Bx1vZ/+W9ar
         J1BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QKF0Q+Cj5dqw+1V9/ENSF5mhLkWuMh2MHkTuwu+K/CI=;
        b=mQS96G9nOrcG9beLpAQ3XFkyef5icLdcBCVldvyiiXoCd4WcQycOJyB6mn58orqt8J
         r4jX4PMnAJ8OLtg6FiDXa+YsdKfBXX9GXsJ671IX74xm78wiKCca/aK5r5nYbeLclahQ
         NYHFoF9nPercjjLgn5+JPm3PZqARN1cMmWMe++MgD5U2wJJNhKsPJ+YEwySLd2CwZz1I
         zMvXm9CpcN7L4tErynEzj5ZlOJA/tUvl7XkphqezpX8+PAnsjjeg5+pC7ro9jStEIdKn
         AgKvesCPVGPCJypaO7lMKASapCWITTSsjzMbT7nwFlxCvkFccVocPg8xJbEIdHUQbTuK
         4x+g==
X-Gm-Message-State: AOAM532xx/YTsImadE42l1jFYJqXirLElXF4ClPaVxbQQcJF6GV2Lq1z
        FEsmnHVqV3t25Ip/6WWE8XjAtSYMDcZkRHZIR0ukiQ==
X-Google-Smtp-Source: ABdhPJy6n44ac4ortGYzyaEpc/J2sYqAuwiDHVNqKjEraO4KEkk3WYRDsHgkEhcEdDiJvz6crVJXyX2sFnirrl6fAeM=
X-Received: by 2002:a63:1e4f:: with SMTP id p15mr20624081pgm.40.1621970666619;
 Tue, 25 May 2021 12:24:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210520230339.267445-1-jmattson@google.com> <20210520230339.267445-6-jmattson@google.com>
In-Reply-To: <20210520230339.267445-6-jmattson@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 25 May 2021 12:24:10 -0700
Message-ID: <CAAeT=Fy3qAk3diwEWO1NORRHg=pt=sxSB_b44du97g+oOOoqtQ@mail.gmail.com>
Subject: Re: [PATCH 05/12] KVM: x86: Add a return code to kvm_apic_accept_events
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> @@ -9880,11 +9888,16 @@ int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
>  int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>                                     struct kvm_mp_state *mp_state)
>  {
> +       int r = 0;
> +
>         vcpu_load(vcpu);
>         if (kvm_mpx_supported())
>                 kvm_load_guest_fpu(vcpu);
>
> -       kvm_apic_accept_events(vcpu);
> +       r = kvm_apic_accept_events(vcpu);
> +       if (r < 0)
> +               goto out;
> +
>         if ((vcpu->arch.mp_state == KVM_MP_STATE_HALTED ||
>              vcpu->arch.mp_state == KVM_MP_STATE_AP_RESET_HOLD) &&
>             vcpu->arch.pv.pv_unhalted)
> @@ -9892,6 +9905,7 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
>         else
>                 mp_state->mp_state = vcpu->arch.mp_state;
>
> +out:
>         if (kvm_mpx_supported())
>                 kvm_put_guest_fpu(vcpu);
>         vcpu_put(vcpu);

With the change, if the return value from kvm_apic_accept_events()
is < 0, kvm_arch_vcpu_ioctl_get_mpstate(), which is called from
KVM_GET_MP_STATE ioctl, doesn't set mp_state returning 0 (success).
It leads KVM_GET_MP_STATE ioctl to return an undefined mp_state for
the success case.

Thanks,
Reiji
