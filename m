Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E572A383A9D
	for <lists+kvm@lfdr.de>; Mon, 17 May 2021 18:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241607AbhEQQ7d (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 May 2021 12:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239927AbhEQQ7c (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 May 2021 12:59:32 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7DCC06175F
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 09:58:15 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id q15so5053117pgg.12
        for <kvm@vger.kernel.org>; Mon, 17 May 2021 09:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LnIhHy3o+INmhoR9lM+wDxWHFzbc4Yd/gOiGaQXOvgY=;
        b=M2f2xxjLJ1/DKzKFaQc/xGGVWDDw5G368pcqcKyd3B6hIgx4eOPanb47sRPjPa/d/F
         LtXTJ2/qZKlWQxj5AL5qEXTF52flhpiW4gAnoZScT6yPXeZ69A0kqfPv+VNIbqNH0Fi6
         SE9dAPthqfIbrSsugfLbwC/KyYSXrzHmqpoRbu10zUBQLQ9QMJQzWqHRzGO6FnfdFeCp
         60fvWxL2NvtXxjbeYUE9EK4BHUUo5uysOc5gvaBrIkXvu/UKiR1gmUBkeNUcWRceuiFI
         yNgaosLDu7Fdp3TBiZJBOIIzrlOgEPSud9craPgu5L/exIh7HcxECtrkZkzvuyb0B+2n
         4Eig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LnIhHy3o+INmhoR9lM+wDxWHFzbc4Yd/gOiGaQXOvgY=;
        b=pOCLlsFlFSasgxWZbDHjKgWPsADXKv6lrrqtDMBXIRbLPd4xesI8X9BnU3v5o4sqIo
         kIZqz4uXqLsT1qrLEaMLhaVcnmiTUUi/Eg+K3Ckry2izLN+dlVkBTSyQu6NV3WqU+ObP
         xZu+p5AC7jgJmjbjVV6gzHib/FARAiRHA/1iPDNHih009cAlHSwFdOYr09FKARjwb6sv
         ME5+6r6bAhl8z41IUmD3X2ny6rPIuTgUfaPrE+572IMxIHRJzvqIk3gqfgYbKGXwmdzt
         +mYo0O+HJvJRAUFkgkWAPdHzLQf65wlpIjbCDgpy5jfSYbi0jEiUtrI/iPbxrZ8tXGBp
         QQMA==
X-Gm-Message-State: AOAM531Vut8v8h4OaRU1mdShcOjEGpmMt7tF/4C1ZWdf56I2Yin2bxX7
        2XjO4DH5QLY/ua4e3hEEONcO8eFbRZxXfFucMOe2+A==
X-Google-Smtp-Source: ABdhPJzwjlWNXq6OExL/GpLMOrSlpqXgbFT2NYwFwrsUyHwGh/RqTFRIYzusOqf6adEqhUpMIXE1AZd3fBChTs2DOJQ=
X-Received: by 2002:aa7:8c59:0:b029:28e:9093:cd4d with SMTP id
 e25-20020aa78c590000b029028e9093cd4dmr550064pfd.25.1621270694586; Mon, 17 May
 2021 09:58:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-7-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-7-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 17 May 2021 09:57:58 -0700
Message-ID: <CAAeT=FzS0bP_7_wz6G6cL8-7pudTD7fhavLCVsOE0KnPXf99dQ@mail.gmail.com>
Subject: Re: [PATCH 06/43] KVM: x86: Properly reset MMU context at vCPU RESET/INIT
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

>  void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>  {
> +       unsigned long old_cr0 = kvm_read_cr0(vcpu);
> +       unsigned long old_cr4 = kvm_read_cr4(vcpu);
> +
>         kvm_lapic_reset(vcpu, init_event);
>
>         vcpu->arch.hflags = 0;
> @@ -10483,6 +10485,10 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
>         vcpu->arch.ia32_xss = 0;
>
>         static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
> +
> +       if (kvm_cr0_mmu_role_changed(old_cr0, kvm_read_cr0(vcpu)) ||
> +           kvm_cr4_mmu_role_changed(old_cr4, kvm_read_cr4(vcpu)))
> +               kvm_mmu_reset_context(vcpu);
>  }

I'm wondering if kvm_vcpu_reset() should call kvm_mmu_reset_context()
for a change in EFER.NX as well.

Thanks,
Reiji
