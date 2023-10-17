Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 983A77CC305
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 14:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343697AbjJQMWr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 08:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343641AbjJQMWa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 08:22:30 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A310C30C2
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 05:09:27 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-53f3609550bso123195a12.1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 05:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697544559; x=1698149359; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZH0F3f+uCOPEXSYjYgewFnE5Faf1m9Z5ZRrf3gXOZSQ=;
        b=n1jy87sF3XvyBSjSEDGKN8FNYu5wWf2ctIRpEdwKtzNhj777VY3f6huvCmd5RSirJN
         +Ab7EekjMzIb5ZmK5pImFzXmrr9B+mmJiweOXrFPjvoUJ1Xhj+GmCITxyiNpv07YwvuT
         V7ybt0auEnWHmWVKGl9MrwalNQN5RjUzpE6QNcxa12DqmPBtb/AsaU78w8yJgyAkHPqb
         DkM1iW5bvaGn/Qp/KvWiVbl+KEV3GXWv8VfX0pTUZLixSfemZUKVEe04XCMPNBtHLATc
         mGZsPHslqnEn8b3KSXdJfW8kl+6ZREqZYYZakvmloN/I7i9Dz6rjLGUiRwJkS/Gn/L25
         FK3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697544559; x=1698149359;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZH0F3f+uCOPEXSYjYgewFnE5Faf1m9Z5ZRrf3gXOZSQ=;
        b=PH5Ya1mVZI5/W0s4Le86YOW0Tc6S9Pem1uuLecpDNIwip64pRkiwcdKsZYOvWVy1iQ
         CafYmbegEqc55nPpYGqP9wlAI9pUbdYL7Qn3Vr5AKnsTAs0kGkUnOA2kNQp9DqO/KU20
         uF3w0z6sZNfaMTEpPPLbJ9I2LMAyzJoKrEXyiZ3Nas+otZ+BAnbw7niTx5dC/L/t91yG
         qz3+2t2kKcx2La45sX6bl0NkHzcUR+wYWgxBGCYy99iWqotSglHEhiejI5RGuNfGVp/4
         /6k8VZ48iUkmCKxOI1OsBd7V+/iBLQwxaKpW7bFV2Sn6fuJKvg7EkxUpcYzlR1zEv9GY
         OrFg==
X-Gm-Message-State: AOJu0YyjV8I9ZfEz+IRDrQy2QbS5SfWuHuqdozjPxXoORCM4IlNMcHNW
        SGlWAHwnvPIz5exob2Rl0jNwDrAPsNCelFfvAekw4w==
X-Google-Smtp-Source: AGHT+IE2K/jx6F/ccMe+2Nr4uzND2KYEgDenap1j6wu8HI14c9LkVAzKww/ddi7gIjkhtF68YjnF7I+dfY9RVUoPZh8=
X-Received: by 2002:a50:9e24:0:b0:53d:a0c9:dbd4 with SMTP id
 z33-20020a509e24000000b0053da0c9dbd4mr1427326ede.21.1697544559610; Tue, 17
 Oct 2023 05:09:19 -0700 (PDT)
MIME-Version: 1.0
References: <20231010142453.224369-1-cohuck@redhat.com> <20231010142453.224369-4-cohuck@redhat.com>
In-Reply-To: <20231010142453.224369-4-cohuck@redhat.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 17 Oct 2023 13:09:08 +0100
Message-ID: <CAFEAcA88O-VDq2rRfVhZ_6OShFq1ANEMmHWHVtNS5hCPQNYtdg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] arm/kvm: convert to read_sys_reg64
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Gavin Shan <gshan@redhat.com>,
        qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 Oct 2023 at 15:25, Cornelia Huck <cohuck@redhat.com> wrote:
>
> We can use read_sys_reg64 to get the SVE_VLS register instead of
> calling GET_ONE_REG directly.
>
> Suggested-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  target/arm/kvm64.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/target/arm/kvm64.c b/target/arm/kvm64.c
> index 558c0b88dd69..d40c89a84752 100644
> --- a/target/arm/kvm64.c
> +++ b/target/arm/kvm64.c
> @@ -500,10 +500,6 @@ uint32_t kvm_arm_sve_get_vls(CPUState *cs)
>              .target = -1,
>              .features[0] = (1 << KVM_ARM_VCPU_SVE),
>          };
> -        struct kvm_one_reg reg = {
> -            .id = KVM_REG_ARM64_SVE_VLS,
> -            .addr = (uint64_t)&vls[0],
> -        };
>          int fdarray[3], ret;
>
>          probed = true;
> @@ -512,7 +508,7 @@ uint32_t kvm_arm_sve_get_vls(CPUState *cs)
>              error_report("failed to create scratch VCPU with SVE enabled");
>              abort();
>          }
> -        ret = ioctl(fdarray[2], KVM_GET_ONE_REG, &reg);
> +        ret = read_sys_reg64(fdarray[2], &vls[0], KVM_REG_ARM64_SVE_VLS);
>          kvm_arm_destroy_scratch_host_vcpu(fdarray);
>          if (ret) {
>              error_report("failed to get KVM_REG_ARM64_SVE_VLS: %s",

read_sys_reg64() asserts that the register you're trying to
read is 64 bits, but KVM_REG_ARM64_SVE_VLS is not, it's 512 bits:

#define KVM_REG_ARM64_SVE_VLS           (KVM_REG_ARM64 | KVM_REG_ARM64_SVE | \
                                         KVM_REG_SIZE_U512 | 0xffff)

So this change would trip the assert on a host where SVE
is supported and enabled.

thanks
-- PMM
