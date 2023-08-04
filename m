Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18749770709
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:27:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbjHDR1F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231771AbjHDR1D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:27:03 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D282746A6
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 10:27:02 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-5231f439968so916533a12.0
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 10:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691170021; x=1691774821;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=t0nTOeFqnFzKnRnAXx88oyJs4DA0yn0GoPkWdFMCgC4=;
        b=NnbURue9QVpbCAE6+MyqLRHPNIAYc3jnsxxUWAn1hNTR523mEqOhomdRB+QV5vKg8y
         hWAD+Kl6pcZGFnJuUzufsnFqHcwCqyaUncLztoFqyY6AiGMsGj/kv3MbJmSmOcqDqt8r
         dMdS6/gGEwb/uFNviF5mrNqoFe242pm/PuCccQsoSiBsmHqUqrkuqSMYmbsiF/JlYo8G
         eCG6hW5uyrWN/NVJz5eo9amz5pU25QNonY9L9aJ/vwjeAbLoFdedeO0LaNMpCoQDH+3K
         LhdIxvwpQMDXFlnDGVx3oEUmv+D0kfmT06YDxPqxup6HARxJghQsVHCEBsHJSjLxife/
         Accg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691170021; x=1691774821;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t0nTOeFqnFzKnRnAXx88oyJs4DA0yn0GoPkWdFMCgC4=;
        b=NnpOmFcWdERuxwR37ecwR/trfea3C+9yfmhUVH8LHHSCeYS/fInL+khmlNfsiPtK5i
         dfnto4RaNblTIpoHzJJOLyHHsnDSrt4NPlBd7z25i5jhdf2lCZuzR6tZdQ4Po0Pljf4L
         n77B2vnkyOA/dUERWdJtep+5qtZv+JsBXXKcayQV2tDB01G9XRmXI1RW9tn8W6oca0zq
         87HAUNBTaeZiPoAjvKM328/NWUqc4Q/Ka/LCMgw2p6JdQHPoCAwIy4VYVkaO8lBZrUpw
         ZtMP/wnb+fuwnIQNbCLfDNMIX5VA9MCTihkWGGoukIJfHjVJDqAEDVxbiUKPmCMrIP/6
         D11A==
X-Gm-Message-State: AOJu0YydtjXJ/hboOcV50GMH+FEurt1XtFIzwjufK8eUNLpyl8rBvd3+
        vgHBezDUDFYGc++6fmSrSLd8j0a4VnpTfaKqdEyPwRpfM8StzU/T
X-Google-Smtp-Source: AGHT+IGGWvPwHXlthmbhmT9sSh+Oh6pYUSZ5Z0MssLXkPyAueXQTUFZUTTOC03AofxhRHW5idyqmiSmCxgL2o0+a2hQ=
X-Received: by 2002:aa7:c383:0:b0:522:219b:ce05 with SMTP id
 k3-20020aa7c383000000b00522219bce05mr2343717edq.7.1691170021093; Fri, 04 Aug
 2023 10:27:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230727073134.134102-1-akihiko.odaki@daynix.com> <20230727073134.134102-2-akihiko.odaki@daynix.com>
In-Reply-To: <20230727073134.134102-2-akihiko.odaki@daynix.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 4 Aug 2023 18:26:49 +0100
Message-ID: <CAFEAcA_26e2G_qLA8DEcv74MADgquhiVkWEZkh_wL0+JxAf91Q@mail.gmail.com>
Subject: Re: [PATCH v5 1/6] kvm: Introduce kvm_arch_get_default_type hook
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jul 2023 at 08:31, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> kvm_arch_get_default_type() returns the default KVM type. This hook is
> particularly useful to derive a KVM type that is valid for "none"
> machine model, which is used by libvirt to probe the availability of
> KVM.
>
> For MIPS, the existing mips_kvm_type() is reused. This function ensures
> the availability of VZ which is mandatory to use KVM on the current
> QEMU.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  include/sysemu/kvm.h     | 2 ++
>  target/mips/kvm_mips.h   | 9 ---------
>  accel/kvm/kvm-all.c      | 4 +++-
>  hw/mips/loongson3_virt.c | 2 --
>  target/arm/kvm.c         | 5 +++++
>  target/i386/kvm/kvm.c    | 5 +++++
>  target/mips/kvm.c        | 2 +-
>  target/ppc/kvm.c         | 5 +++++
>  target/riscv/kvm.c       | 5 +++++
>  target/s390x/kvm/kvm.c   | 5 +++++
>  10 files changed, 31 insertions(+), 13 deletions(-)
>
> diff --git a/include/sysemu/kvm.h b/include/sysemu/kvm.h
> index 115f0cca79..ccaf55caf7 100644
> --- a/include/sysemu/kvm.h
> +++ b/include/sysemu/kvm.h
> @@ -369,6 +369,8 @@ int kvm_arch_get_registers(CPUState *cpu);
>
>  int kvm_arch_put_registers(CPUState *cpu, int level);
>
> +int kvm_arch_get_default_type(MachineState *ms);
> +

New global functions should have a doc comment that explains
what they do, what their API is, etc. For instance, is
this allowed to return an error, and if so, how ?

Otherwise
Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM
