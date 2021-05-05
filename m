Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20D61373469
	for <lists+kvm@lfdr.de>; Wed,  5 May 2021 06:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231350AbhEEE2i (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 May 2021 00:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231319AbhEEE2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 May 2021 00:28:33 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB03C06138A
        for <kvm@vger.kernel.org>; Tue,  4 May 2021 21:27:10 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id p4so1163386pfo.3
        for <kvm@vger.kernel.org>; Tue, 04 May 2021 21:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AkdJ7jdjHyuclShdANsqX7WPCnDkiVjMoelEcVTWBS0=;
        b=gR3LsznuyMIGgTZilvyx0JbzPUtgRaDl77q4aHnJG9jj2xRpGmUuKNGJmmDri8x6AB
         1rx+OC3k+00tTkLIB0hsHQr2xUbgzHtK1opdiINI1vQ1MRP1Zt9ppArBgVelELnXR2UT
         VKjYZuOFWLL10Q6ZgngjkAfpOQaYSId/h3eJ3UOTMxiLVycyZrQ6uzZYv1QWVdwp2X1Y
         UVgku59UHziHV0a/0Ukn9h8lWrJ0tMc/u8iqfVnV/a7jsZxhto9jRLq+A0GlU7ib+oGP
         9oX5E8rMCfiMYzBJe1ttxKAvMxK3fdGoIZDfmPLXdNqYp3wl7+HQtoofT7PoZrGXv65c
         mIDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AkdJ7jdjHyuclShdANsqX7WPCnDkiVjMoelEcVTWBS0=;
        b=YooQlg3ZR1SkHm6TUzVESv0Byv8ImM2XHuAg8UmxTHAT8Qous6aGiPySOgl7HvW43S
         9YD73c9jvFU3M/7dHYsnhFsq6iUTApivge6gmlqEhrvaYly0k/o6IxdcT0Sdwfp0A/UW
         Fbu7JXr2EcAjYQw5nGaxY9U3YTOoZtAiqsTr2ARCz/TD9JVzicT01CTIQ3NIM4yN9ENJ
         mgb9oooG+DHpVs9y0Z8yq2u8wHa70yZQeVGHjPD/whICXSmwlmjQE+ibt941hMZBw02O
         fFwabdn/Gwp9vLfGcMRApTqozqygGICF18U0mgSZuL1x3GXitA5vmwwuFQx3o2j+x3KY
         /qVA==
X-Gm-Message-State: AOAM530p8aT0FYv2NpxnU25tdb3SdyIJ7/3iwlz42yIP2T1/XH9q6zMu
        cwNnG5YvBiQsKeRY+Chfz/s6bPbgQPMU9fLecAAhGg==
X-Google-Smtp-Source: ABdhPJza8kErNiYiPhF4FsjxuCaUWp/dAsMXwZIhcTVBemm9n0WZjL+SoMALzGDgzOMRk8qkAZVeoJ4Cn6BCROM7Soc=
X-Received: by 2002:a63:4f50:: with SMTP id p16mr26300372pgl.40.1620188829494;
 Tue, 04 May 2021 21:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210504171734.1434054-1-seanjc@google.com> <20210504171734.1434054-4-seanjc@google.com>
In-Reply-To: <20210504171734.1434054-4-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 4 May 2021 21:26:53 -0700
Message-ID: <CAAeT=FyA_0NDX0BqEkBwXLOY6vm3XfkYJmd9bpRNSza-2i42wA@mail.gmail.com>
Subject: Re: [PATCH 03/15] KVM: SVM: Inject #UD on RDTSCP when it should be
 disabled in the guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 4, 2021 at 10:17 AM Sean Christopherson <seanjc@google.com> wrote:
>
> Intercept RDTSCP to inject #UD if RDTSC is disabled in the guest.
>
> Note, SVM does not support intercepting RDPID.  Unlike VMX's
> ENABLE_RDTSCP control, RDTSCP interception does not apply to RDPID.  This
> is a benign virtualization hole as the host kernel (incorrectly) sets
> MSR_TSC_AUX if RDTSCP is supported, and KVM loads the guest's MSR_TSC_AUX
> into hardware if RDTSCP is supported in the host, i.e. KVM will not leak
> the host's MSR_TSC_AUX to the guest.
>
> But, when the kernel bug is fixed, KVM will start leaking the host's
> MSR_TSC_AUX if RDPID is supported in hardware, but RDTSCP isn't available
> for whatever reason.  This leak will be remedied in a future commit.
>
> Fixes: 46896c73c1a4 ("KVM: svm: add support for RDTSCP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
