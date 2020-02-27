Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2A31725C1
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2020 18:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730405AbgB0Rzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Feb 2020 12:55:44 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:46087 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729624AbgB0Rzo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Feb 2020 12:55:44 -0500
Received: by mail-io1-f68.google.com with SMTP id e7so362944ioe.13
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2020 09:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NylVHJE6upVF29IVdBuSvP++A0hZb65rcSiVqx/spX0=;
        b=eOiS86viM71jTaieN8tpKi/iZHr0ck18Lvx7IOIytjUhy17X68LguUFd/elbTXuZLH
         lM6D06RdoG36UyIH1ELD/OKP4tk2qxDf3avqVhYoVcNgtYw3AgmEXz0Av6gshpEehdP/
         AO0BzoR/+HGd1J+/TYdPwercOcnCP44Om7rOZiJIJovsCbo5eT78DOyShKW9mdw8lSH/
         x/QD7aSj0jOfyn4RMFjxgL48f2ZF00YY4/95eP/WgT9N0lCVpWGsHzbS6fecmWThDueV
         ywuDRWa2kMVvy00eIgULbTOZdthUVPjBNVtNwrwWvMIPB/BmthzIxfXLtVyUOZW9vuou
         3uOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NylVHJE6upVF29IVdBuSvP++A0hZb65rcSiVqx/spX0=;
        b=gaoyscUss+Z0Kr0jLXT4LzsZKoLCa30Mu2P86gIdwcVDNlcm9fU+/JPGlRmejS6ysn
         4u70REeye30l5pmrm8M96HtgvnW8ZWo38NvMv/fEHglnWz+0z8uw7XPNSdPnuevTaYTS
         kmEvCs5PPM9yHV67DYSMYztmZDSFR8sdK0N9TjtTacZof71R1LjK89XYngic+0sjhkFf
         Ph4c/dXKAFe/QLF13OZXEW2r+Jlq8fMfXGRfAyaFk3MmYaJzj9BYq4GkLqCHnx8vsN5C
         FflHAMeb+370PY6RVXViLJu0PJmxYIewruWWoLu+DArVWkmoj5HjhtyhBkWzYJz4/szr
         WFxw==
X-Gm-Message-State: APjAAAUnjcAwOMpP6YTB2NFuOtheYpmizPhwRGMXYYBzuvPBmsrREaF3
        O1C1TiiKkDWxUQ3Q+V/hSdkfeCkpjSjs+MRx4NYdYg==
X-Google-Smtp-Source: APXvYqwFptUgwySCKOI0OSvyxECMDGUM5f6sOv8slHlp/a4KD/nPi+VDoaD1TXchnUg04QgiHVgi/lUA/uQgZeQjMAg=
X-Received: by 2002:a05:6602:2c91:: with SMTP id i17mr443965iow.26.1582826143722;
 Thu, 27 Feb 2020 09:55:43 -0800 (PST)
MIME-Version: 1.0
References: <20200227172306.21426-1-mgamal@redhat.com> <20200227172306.21426-3-mgamal@redhat.com>
In-Reply-To: <20200227172306.21426-3-mgamal@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 27 Feb 2020 09:55:32 -0800
Message-ID: <CALMp9eR7heTGQ6zwYrK5rJ-xs_wKqz49gfcNtaEC7S6J7n2aFQ@mail.gmail.com>
Subject: Re: [PATCH 2/5] KVM: VMX: Add guest physical address check in EPT
 violation and misconfig
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 27, 2020 at 9:23 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>
> Check guest physical address against it's maximum physical memory. If
Nit: "its," without an apostrophe.

> the guest's physical address exceeds the maximum (i.e. has reserved bits
> set), inject a guest page fault with PFERR_RSVD_MASK.
>
> Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 63aaf44edd1f..477d196aa235 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5162,6 +5162,12 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>         gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
>         trace_kvm_page_fault(gpa, exit_qualification);
>
> +       /* Check if guest gpa doesn't exceed physical memory limits */
> +       if (gpa >= (1ull << cpuid_maxphyaddr(vcpu))) {
> +               kvm_inject_rsvd_bits_pf(vcpu, gpa);

Even if PFERR_RSVD_MASK is set in the page fault error code, shouldn't
we set still conditionally set:
    PFERR_WRITE_MASK - for an attempted write
    PFERR_USER_MASK - for a usermode access
    PFERR_FETCH_MASK - for an instruction fetch

> +               return 1;
> +       }
> +
>         /* Is it a read fault? */
>         error_code = (exit_qualification & EPT_VIOLATION_ACC_READ)
>                      ? PFERR_USER_MASK : 0;
> @@ -5193,6 +5199,13 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>          * nGPA here instead of the required GPA.
>          */
>         gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> +
> +       /* Check if guest gpa doesn't exceed physical memory limits */
> +       if (gpa >= (1ull << cpuid_maxphyaddr(vcpu))) {
> +               kvm_inject_rsvd_bits_pf(vcpu, gpa);

And here as well?

> +               return 1;
> +       }
> +
>         if (!is_guest_mode(vcpu) &&
>             !kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
>                 trace_kvm_fast_mmio(gpa);
> --
> 2.21.1
>
