Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1832D53F308
	for <lists+kvm@lfdr.de>; Tue,  7 Jun 2022 02:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235494AbiFGAmm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Jun 2022 20:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbiFGAmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Jun 2022 20:42:36 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E84F12091
        for <kvm@vger.kernel.org>; Mon,  6 Jun 2022 17:42:35 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id d14so12929205wra.10
        for <kvm@vger.kernel.org>; Mon, 06 Jun 2022 17:42:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xrS17sEQ3fRPRqMXnMRDhd1tVPi2Vsh08gg2EBYpymM=;
        b=SandzrnngwOhRTb7pOv7vDUXRvqY6I+fX26+o4AE+4oTdmUbOSgFO7ZLB+rx1z3A/D
         xV9ISdzwufntSdxLAJVDSJSsY/g1ASXMr+GS9Ep8fv6saHUVZfAID5Y6sMpqLDrZ6+ri
         8DnY1F8gCpDfLb3G9J0S3+A6EiWDuwMmOamclAsFTGps0qCe6xHs+s4QaTBeyZzhvvtd
         xs1nbZ0048cLZuV27n8vhLONuob2ISCzfsahl7H2WWuDMBdZvGFld2a0fq6RyDYfpi2n
         GM9dIiSUT1ll9rIbt5B9ToV1tMRPrwu7j/rrIe5zmemKTTII4nDov62UIwXsQSFMGmQ5
         hf4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xrS17sEQ3fRPRqMXnMRDhd1tVPi2Vsh08gg2EBYpymM=;
        b=kkHNFrl+I0FMbmhSQahXeh1cPnm//3VbdtJtT4l9ymF6vYqc5qU145RfrQwlNaE+I/
         VYTgDZoyseFIla8yQ+VmxQ7k0nihnopjoInrCVtX3Ia99eQxrC1U4iczwrxwuJMkInkq
         1D7mBkQXxup5H1go+PDVq13E5XWlFHfsBGV7sAgxef6b4Jlv1Wep2QLHJHi9G2HSOMxi
         +1vvpjdGqRdHSP+Qpi6xjVAVpHG4x8hx3ZfDavEKAsYyQwGfHe28KseQssM2514i8zCi
         6d0cl+3Yi5wS4kEJuHw0U4wt3gZ21rmKTSX7/fjAIYUDI25PK62QJBLOyCkC56PJwERm
         TTwQ==
X-Gm-Message-State: AOAM533R1Fhr/1vewjJJwvdSshEjxvGCaKO5PaiPjv/sbWAh+fh7JK+X
        y/7nGs61CyqMSWvM9S1d9lk3oW26KQ0QDV6DZxUicQ==
X-Google-Smtp-Source: ABdhPJycltbOTsL7TkxiF885x5QthonQlvgpxJIZFOu+1GRjvPzN5Kl98cntZbpqNcd7ixaTx3UK+BqqMjFqf1qFZU4=
X-Received: by 2002:a5d:4b10:0:b0:213:5e0:2c6c with SMTP id
 v16-20020a5d4b10000000b0021305e02c6cmr23787190wrq.126.1654562553942; Mon, 06
 Jun 2022 17:42:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220519134204.5379-1-will@kernel.org> <20220519134204.5379-60-will@kernel.org>
In-Reply-To: <20220519134204.5379-60-will@kernel.org>
From:   Peter Collingbourne <pcc@google.com>
Date:   Mon, 6 Jun 2022 17:42:22 -0700
Message-ID: <CAMn1gO7Gs8YUEv9Gx8qakedGNwFVgt9i+X+rjw50uc7YGMhpEQ@mail.gmail.com>
Subject: Re: [PATCH 59/89] KVM: arm64: Do not support MTE for protected VMs
To:     Will Deacon <will@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, Ard Biesheuvel <ardb@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Quentin Perret <qperret@google.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Michael Roth <michael.roth@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Oliver Upton <oupton@google.com>,
        Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
        kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
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

On Thu, May 19, 2022 at 7:40 AM Will Deacon <will@kernel.org> wrote:
>
> From: Fuad Tabba <tabba@google.com>
>
> Return an error (-EINVAL) if trying to enable MTE on a protected
> vm.
>
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/arm.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 10e036bf06e3..8a1b4ba1dfa7 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -90,7 +90,9 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>                 break;
>         case KVM_CAP_ARM_MTE:
>                 mutex_lock(&kvm->lock);
> -               if (!system_supports_mte() || kvm->created_vcpus) {
> +               if (!system_supports_mte() ||
> +                   kvm_vm_is_protected(kvm) ||

Should this check be added to kvm_vm_ioctl_check_extension() as well?

Peter
