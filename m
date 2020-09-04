Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1339F25CF5B
	for <lists+kvm@lfdr.de>; Fri,  4 Sep 2020 04:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729538AbgIDCTJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Sep 2020 22:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729318AbgIDCTI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Sep 2020 22:19:08 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83A9C061244
        for <kvm@vger.kernel.org>; Thu,  3 Sep 2020 19:19:07 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id ay8so4612831edb.8
        for <kvm@vger.kernel.org>; Thu, 03 Sep 2020 19:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LrAdzv24TvKINI+TSt9YrTxl/N6E+xS4y6ll+3lQsBM=;
        b=MRIf1HBgmWXfY1BikF2IYGavdlt4nQmFrVJ6Mi+ad+vUFt0vx2nR0LP2LhUjG+MOoy
         y/BaY2dLXwr0smwGz3krb1Tp8HTvrZBPaxjjJswpXWPxv6eY9MBUdVuGde7aYtuDJ4fl
         vM4WtJ4alvKrxThlhkLGNlCGI2rDb91JN/ZjFLZ/CRmly547F0A2OlB7yDF546n0qcGv
         32QV9KC3cBX+N7U5ISIfjFklMV66lljsGD2vDQSqAPwrTrxnegtZENKpP7AlOhf8OuAe
         bEWWikidflcbq6YaJCTNtFrd7PAjhQh5W4X+VczD8GPAuWc4xbg7ba7h8uc9XO9w0sRy
         Mwrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LrAdzv24TvKINI+TSt9YrTxl/N6E+xS4y6ll+3lQsBM=;
        b=ZYVnMpiqbhvdMOhE2EaLX3eMh2PxbHK0k4PKpHoSGSW6eI1zpT5+RhdGrl+nwBukUa
         ubFocX5hdq6ohiHiapiWpLgTW08XV8O700wnoRK8VqCIlKteoMzZ1IayneftlAflTuBc
         5UH8zRCPygHGza4QRwdwTb1iAYkoPhZpM+qTfCSMvb7uFVGCwIz15r6YVoji4Jhv6ZYz
         7Wgo4Gj4793Dh2qGoZSSnnxCTBdzHp/FZ1O4tNcBSZQMvN79vsFp1cZt/UTjF+udhBTX
         /HPSPd2S6rF4Je5eAVeKyy9kQwNeiMLVHiTecDOA34qU7HP32I1hfOKf2Ieg7/tDBAG6
         4OIQ==
X-Gm-Message-State: AOAM533kyTLzar87g3+SrAFRoCxRzE9VxlswoYdth5Ed9VA/eWOnSQwh
        KsONnd75srIti6X/NW5rsmjMP+R7kdox0eNUoKtLhw==
X-Google-Smtp-Source: ABdhPJxs5wovzcetJu5uDT3AQi1FzFLV1CCc/+8EIHAU6I/Z4nPfDoYG4OvY59GtSoCuXmq4fFtncIcI2zqBYqdeokE=
X-Received: by 2002:a50:d809:: with SMTP id o9mr6138860edj.12.1599185946357;
 Thu, 03 Sep 2020 19:19:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200902125935.20646-1-graf@amazon.com> <20200902125935.20646-6-graf@amazon.com>
In-Reply-To: <20200902125935.20646-6-graf@amazon.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Thu, 3 Sep 2020 19:18:55 -0700
Message-ID: <CAAAPnDH2D6fANhZzy3fAL2XKO4ROrvbOoqPme2Ww6q5XcVJfog@mail.gmail.com>
Subject: Re: [PATCH v6 5/7] KVM: x86: VMX: Prevent MSR passthrough when MSR
 access is denied
To:     Alexander Graf <graf@amazon.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        KarimAllah Raslan <karahmed@amazon.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kvm list <kvm@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> +/*
> + * List of MSRs that can be directly passed to the guest.
> + * In addition to these x2apic and PT MSRs are handled specially.
> + */
> +static u32 vmx_possible_passthrough_msrs[MAX_POSSIBLE_PASSGHROUGH_MSRS] = {

MAX_POSSIBLE_PASSGHROUGH_MSRS should be MAX_POSSIBLE_PASSTHROUGH_MSRS

> +       MSR_IA32_SPEC_CTRL,
> +       MSR_IA32_PRED_CMD,
> +       MSR_IA32_TSC,
> +       MSR_FS_BASE,
> +       MSR_GS_BASE,
> +       MSR_KERNEL_GS_BASE,
> +       MSR_IA32_SYSENTER_CS,
> +       MSR_IA32_SYSENTER_ESP,
> +       MSR_IA32_SYSENTER_EIP,
> +       MSR_CORE_C1_RES,
> +       MSR_CORE_C3_RESIDENCY,
> +       MSR_CORE_C6_RESIDENCY,
> +       MSR_CORE_C7_RESIDENCY,
> +};

Is there any reason not to construct this list on the fly?  That could
help prevent the list from becoming stale over time if this is missed
when calls to vmx_disable_intercept_for_msr() are added.

> +
>  /*
>   * These 2 parameters are used to config the controls for Pause-Loop Exiting:
>   * ple_gap:    upper bound on the amount of time between two successive
> @@ -622,6 +642,41 @@ static inline bool report_flexpriority(void)
>         return flexpriority_enabled;
>  }

One thing that seems to be missing is removing MSRs from the
permission bitmap or resetting the permission bitmap to its original
state before adding changes on top of it.  This would be needed on
subsequent calls to kvm_vm_ioctl_set_msr_filter().  When that happens
the original changes made by KVM_REQ_MSR_FILTER_CHANGED need to be
backed out before applying the new set.
