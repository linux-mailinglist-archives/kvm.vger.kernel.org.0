Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CA23886BC
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244485AbhESFjW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242154AbhESFhV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:37:21 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E277C06134D
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:35:11 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id y32so8627718pga.11
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZnXQTZd4YFiMxjzLc+WeIPzH5Cugof+bDJeafEZszhA=;
        b=OWZHAZGSoROkzO2D07Qx34Q2pTN/VV2QPYjA6sI+a5Mzw19NU6NO1dGrrvlKE6jE/A
         f357jaHElfq3C8/Q5Li3LkEkQdZvPxtRHUJIJ8qR5wwUvrEH6w1fAdA//kgPzaCbGVwP
         qHZpdC89rPPqrRdX0NaV/a2hndUrexpx1e8A0omE5npzPx+TdVnEMHbfh6xpmATIt9SD
         z0ZUhz+Fxe0LTo5EckuZuaRNv661aK7wGkNcmTyw3/Cp6zR8c3bJ0HO8+P048SMQQDHg
         SlorePs2V97iUM+6qysZMOk6R+En8+SnbwZWwu3TRCKQFyGXvtPRs6YjzijP7hmBFv/s
         JmqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZnXQTZd4YFiMxjzLc+WeIPzH5Cugof+bDJeafEZszhA=;
        b=oWZr1DR2ngQ0kEs1ucdMcQx515Vz4vqqMwol6304gld+OcNeuI0gYJ7nYdGLXRXAe6
         2ulJDXUZVrUDV0aKu2b6lg+tBoH2qgHAA/f+Y3bxAhBNt9o/7Dk5M8404Oa24GHeLNMN
         XDXWoVbjslaXpy7m4ZscLTVTA67PzkpTcmZ2huWetqS6DU+QCKME7UDPsVi641fWNauV
         NqhvjPO62Cam1um0op7qle2wpQ98eEEPUfo4xX742C3CT3avtWNMcAnj2/CHwNow8D9H
         Eyybuw8h0laPqcSiAUXbtKBVf8lNAKbFWXfuPH4rfZNMWtvqaxoVCiOz2wEfjwAtcnql
         /Wrg==
X-Gm-Message-State: AOAM530qHOD2f7DpvpDVG6u2eE8GWiUhqLtatLmgRmLNe1ctVk25ocUi
        2H5mQ9/U3Y3L7ekNCUgVzt1wRivpmKOAUXooepaNIQ==
X-Google-Smtp-Source: ABdhPJxRVRGQRmTOrx5g0fwZQ40vUC2OtgTmQ1h1QHlPsnFidYfsegpgCrqjFWNAVWbiD7CLjNy9sS0H5nOMl+lOapE=
X-Received: by 2002:aa7:8c59:0:b029:28e:9093:cd4d with SMTP id
 e25-20020aa78c590000b029028e9093cd4dmr8891246pfd.25.1621402510627; Tue, 18
 May 2021 22:35:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-23-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-23-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 May 2021 22:34:54 -0700
Message-ID: <CAAeT=FzLMNr3QtTjchzvr9QStaQPJaQNvaqHGzfsRpp5fOBSEg@mail.gmail.com>
Subject: Re: [PATCH 22/43] KVM: VMX: Remove direct write to vcpu->arch.cr0
 during vCPU RESET/INIT
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

On Fri, Apr 23, 2021 at 5:51 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Remove a bogus write to vcpu->arch.cr0 that immediately precedes
> vmx_set_cr0() during vCPU RESET/INIT.  For RESET, this is a nop since
> the "old" CR0 value is meaningless.  But for INIT, if the vCPU is coming
> from paging enabled mode, crushing vcpu->arch.cr0 will cause the various
> is_paging() checks in vmx_set_cr0() to get false negatives.
>
> For the exit_lmode() case, the false negative is benign as vmx_set_efer()
> is called immediately after vmx_set_cr0().
>
> For EPT without unrestricted guest, the false negative will cause KVM to
> unnecessarily run with CR3 load/store exiting.  But again, this is
> benign, albeit sub-optimal.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
