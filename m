Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BB44E2F04
	for <lists+kvm@lfdr.de>; Mon, 21 Mar 2022 18:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348638AbiCUR1B (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Mar 2022 13:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242025AbiCUR1A (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Mar 2022 13:27:00 -0400
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A1FE183800
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:25:35 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id v19-20020a056820101300b0032488bb70f5so5913087oor.5
        for <kvm@vger.kernel.org>; Mon, 21 Mar 2022 10:25:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fmeIv2QDOzsS4zlc06LTh9pZ1GK8X0LxwrhNTBduaNE=;
        b=Ht6jx+xVr1kX1fn3bCqDejvCU3VXDWeBe8bNQskALug//Ri2sX9OThqeOZIA30pMVa
         aJWNsC0OZmC9yRDNN9uKgC/a5oWM3IMclnjP0GuPTSMg++dHdHHU1j1CN1FePWCbYgUI
         MpmFWOhO7XnThgsWfZyL5P++U+HBzMPzydUUaDOaSHOKv7hR76MByO0SNZTdT5XhNhXm
         +ypkONCBmSfYr3KSp/sVSGn59d/jcxg8j4DyVqjR89jMD80tNAX+EHyhxQnqttf84JOc
         MFRfcy19RtYm5Y/1sy2ScULSoYwMlIiov+Oya1AMJZEVFcDPvtLfOawzZ5CpZyMqCroG
         7RJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fmeIv2QDOzsS4zlc06LTh9pZ1GK8X0LxwrhNTBduaNE=;
        b=iq+YzF+oZhuZf/8zaWLaIx6nO1XOiH/X0E4qhalp4z14TwOval2AFUWC0+4iuVTcCn
         awTmx/bQw0wrHrxxaTlyEgiE7TP9e1CLs+uCPLpLKGNyOFRcMaxfbLFjD/D87ySLyGnu
         0u6xGJqonTAZea5SdwJ8QGFP830qL/pk1poJ/EB9Ee6elPXI/5FB9zcf8FzNh3GxnVY7
         QBx3PE5MQTRCgMvNzbwf4IXoNEG3BoxrdM85tbXmh2q50FYTGgm2FrvhKkEOvD5jL0R/
         blGn9fX/ALYLdTOCsN37pqjzjGcpOTesyqOAF0RJqVq4ufmRIrIDTxWNxmI/xlpikC7t
         KS3g==
X-Gm-Message-State: AOAM5305LAuIJVlPWp1dqws3FPBvXnDY4c+fX6DaltqA1sSISSdnqa6n
        y13bINilD+KfTG69JJnEH800IO5/GBPXb5kXGhUbdw==
X-Google-Smtp-Source: ABdhPJx916mIocw0CSs5GhHKZIpvBgvBumuH1FgDOkSt/vPvxDiJB7JuxJkaHYMjljkWKaFwGwNr2/5kLY5pgucKJyw=
X-Received: by 2002:a05:6870:40cc:b0:de:15e7:4df0 with SMTP id
 l12-20020a05687040cc00b000de15e74df0mr89545oal.110.1647883534190; Mon, 21 Mar
 2022 10:25:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220321150214.1895231-1-pgonda@google.com>
In-Reply-To: <20220321150214.1895231-1-pgonda@google.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 21 Mar 2022 10:25:22 -0700
Message-ID: <CAA03e5HEKPxfGZ57r=intg_ogTp_JPAio36QJXqviMZM_KmvEg@mail.gmail.com>
Subject: Re: [PATCH] Add KVM_EXIT_SHUTDOWN metadata for SEV-ES
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm list <kvm@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sean Christopherson <seanjc@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 21, 2022 at 8:02 AM Peter Gonda <pgonda@google.com> wrote:
>
> SEV-ES guests can request termination using the GHCB's MSR protocol. See
> AMD's GHCB spec section '4.1.13 Termination Request'. Currently when a
> guest does this the userspace VMM sees an KVM_EXIT_UNKNOWN (-EVINAL)
> return code from KVM_RUN. By adding a KVM_EXIT_SHUTDOWN_ENTRY to kvm_run
> struct the userspace VMM can clearly see the guest has requested a SEV-ES
> termination including the termination reason code set and reason code.
>
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Joerg Roedel <jroedel@suse.de>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
>
> ---
>
> Tested by making an SEV-ES guest call sev_es_terminate() with hardcoded
> reason code set and reason code and then observing the codes from the
> userspace VMM in the kvm_run.shutdown.data fields.
>
> ---
>  arch/x86/kvm/svm/sev.c   |  9 +++++++--
>  include/uapi/linux/kvm.h | 12 ++++++++++++
>  2 files changed, 19 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 75fa6dd268f0..5f9d37dd3f6f 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2735,8 +2735,13 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
>                 pr_info("SEV-ES guest requested termination: %#llx:%#llx\n",
>                         reason_set, reason_code);
>
> -               ret = -EINVAL;
> -               break;
> +               vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> +               vcpu->run->shutdown.reason = KVM_SHUTDOWN_SEV_TERM;
> +               vcpu->run->shutdown.ndata = 2;
> +               vcpu->run->shutdown.data[0] = reason_set;
> +               vcpu->run->shutdown.data[1] = reason_code;
> +
> +               return 0;

Maybe I'm missing something, but don't we want to keep returning an error?

rationale: Current behavior: return -EINVAL to userpsace, but
userpsace cannot infer where the -EINVAL came from. After this patch:
We should still return -EINVAL to userspace, but now userspace can
parse this new info in the KVM run struct to properly terminate.

>         }
>         default:
>                 /* Error, keep GHCB MSR value as-is */
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 8616af85dc5d..12138b8f290c 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -271,6 +271,12 @@ struct kvm_xen_exit {
>  #define KVM_EXIT_XEN              34
>  #define KVM_EXIT_RISCV_SBI        35
>
> +/* For KVM_EXIT_SHUTDOWN */
> +/* Standard VM shutdown request. No additional metadata provided. */
> +#define KVM_SHUTDOWN_REQ       0
> +/* SEV-ES termination request */
> +#define KVM_SHUTDOWN_SEV_TERM  1
> +
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
>  #define KVM_INTERNAL_ERROR_EMULATION   1
> @@ -311,6 +317,12 @@ struct kvm_run {
>                 struct {
>                         __u64 hardware_exit_reason;
>                 } hw;
> +               /* KVM_EXIT_SHUTDOWN_ENTRY */
> +               struct {
> +                       __u64 reason;
> +                       __u32 ndata;
> +                       __u64 data[16];
> +               } shutdown;
>                 /* KVM_EXIT_FAIL_ENTRY */
>                 struct {
>                         __u64 hardware_entry_failure_reason;
> --
> 2.35.1.894.gb6a874cedc-goog
>
