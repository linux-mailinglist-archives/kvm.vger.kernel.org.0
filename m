Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DCC6DD1CE
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 07:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjDKFgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 01:36:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjDKFgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 01:36:36 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667782722
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 22:36:35 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-184518754bfso4867137fac.5
        for <kvm@vger.kernel.org>; Mon, 10 Apr 2023 22:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681191394; x=1683783394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mdU3Bs8JQQ33splN92FBiHtIvH17DV/SWgdHpTNTSsU=;
        b=Ai94Ld0eiIhTrLPOTcEF/nNJkZP42ALKAw4OhARQy5f8G4uVWqRxO2LbkgqZVuRXUu
         e+8kqSxykt1A9iDU01Ot/xjQdEu/k/5HCPBdazwHC1ech/qr7V2pnvNWbxRud4NwinDu
         5FdXNZe3mT6ndRR1YR/ksjrv+3zx3gxCZ9ABFmtdIChJB6u+nFts49mSzcq0/L4SrqAc
         JG6KeolZmJkcdvxxZXKtPt/caFMh8KUw3DiU0D5pVL0+6W16mEg+wCiy6WoezQvU0a5Q
         3gzpA2wF8ICNpAkHXwhkAfl+KzJQLpKPKNrHiabkAuoz+1Dlwrud5BTt7l6gl7abeWde
         9vXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681191394; x=1683783394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mdU3Bs8JQQ33splN92FBiHtIvH17DV/SWgdHpTNTSsU=;
        b=XSHStYm42oh+YoLvWSVdNuJPc2ShpeBn1jI6UqDOOB9djIoJFGCqa9AYQ4RJFZytkA
         qzKaieriiCL9EmWLkeDD14Ks+DASv4XXoje5UWEx+VdC1/mD+IPurfIaLke7N6p4hznM
         y2KXCghZQ2WJArWWMbOf5FAYReDxEifQDmY/2R204tyuOupBth4UCUlulsNSSDMkyup1
         PaVZNefukv1076p6nKrxwvmFYoZPeTcwZZQQbKXP/UlQbzCZhVGuUjUTWLzNbuCdfTDc
         LRYz0swvqhYBD7HAeiyxHGz9IxD49sjDcpOJ2hf/qUCNaxMZZInG552xSj7ngBC8zwWz
         x9zA==
X-Gm-Message-State: AAQBX9cuuUevrnf6uZhXFvEc0FolAA74cG9ZueGSovLYUdWNDOueF0N2
        8yhOCKVYDknFF5qsdWunWcxMo9joA5AZXmryMXXqlA==
X-Google-Smtp-Source: AKy350Y13pNbkk38TS7Z01b8gLcWD7y+DFYaX0cSUhPN3bBQ/MHeCwKEm8LjF8T81FeDnTkmsakQvs12U7I3j3I/h9M=
X-Received: by 2002:a05:6870:4192:b0:17f:1723:fc82 with SMTP id
 y18-20020a056870419200b0017f1723fc82mr728779oac.9.1681191394445; Mon, 10 Apr
 2023 22:36:34 -0700 (PDT)
MIME-Version: 1.0
References: <20230410105056.60973-1-likexu@tencent.com> <20230410105056.60973-6-likexu@tencent.com>
In-Reply-To: <20230410105056.60973-6-likexu@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 10 Apr 2023 22:36:23 -0700
Message-ID: <CALMp9eTLvJ6GW1mfgjO7CL7tW-79asykyz9=Fb=FfT74VRkDVA@mail.gmail.com>
Subject: Re: [PATCH V5 05/10] KVM: x86/pmu: Disable vPMU if the minimum num of
 counters isn't met
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 10, 2023 at 3:51=E2=80=AFAM Like Xu <like.xu.linux@gmail.com> w=
rote:
>
> From: Like Xu <likexu@tencent.com>
>
> Disable PMU support when running on AMD and perf reports fewer than four
> general purpose counters. All AMD PMUs must define at least four counters
> due to AMD's legacy architecture hardcoding the number of counters
> without providing a way to enumerate the number of counters to software,
> e.g. from AMD's APM:
>
>  The legacy architecture defines four performance counters (PerfCtrn)
>  and corresponding event-select registers (PerfEvtSeln).
>
> Virtualizing fewer than four counters can lead to guest instability as
> software expects four counters to be available.

I'm confused. Isn't zero less than four?

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.h | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index dd7c7d4ffe3b..002b527360f4 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -182,6 +182,9 @@ static inline void kvm_init_pmu_capability(const stru=
ct kvm_pmu_ops *pmu_ops)
>                         enable_pmu =3D false;
>         }
>
> +       if (!is_intel && kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS=
)
> +               enable_pmu =3D false;
> +
>         if (!enable_pmu) {
>                 memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
>                 return;
> --
> 2.40.0
>
