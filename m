Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17C61720954
	for <lists+kvm@lfdr.de>; Fri,  2 Jun 2023 20:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237059AbjFBSo3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Jun 2023 14:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236363AbjFBSo2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Jun 2023 14:44:28 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78793E49
        for <kvm@vger.kernel.org>; Fri,  2 Jun 2023 11:44:03 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1ae64580e9fso18415ad.1
        for <kvm@vger.kernel.org>; Fri, 02 Jun 2023 11:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685731443; x=1688323443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4EQFzSrx2n4nQ7Xtqftw4pXvEInOGMWYaTfSVl2wj0=;
        b=SllI/9Kc6RPP2v6ijZTxl+EXQQRZRiW6Zsuio0JxgpATIEUrxAvb+iytOtZvBYyCjJ
         Rx279z2gGLfyDmcB6cqXHfeCr5aHXngOPdOWbKHtyoYSMc3lGMW1VHBQR5WHHy6rxFsZ
         KNvZdK7RE8W34tqzLV9MgOXAUSy2I1Ukr39vO7UjQ2pgWJHUaAA05RovNbGj9EMzjhNE
         nXqz33dwg8rGjAKy7IyeUFN052bbvDAHzSV1m6gDhpY+y9b+gAjlRiAAK3wRDptjXNRU
         ksqebgG7MY2gNhKOYubZNuqL8+UaGvAKeBM1+UNNmB5atLyg8Ghrp5ssblr0aFpicJQa
         LbVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685731443; x=1688323443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I4EQFzSrx2n4nQ7Xtqftw4pXvEInOGMWYaTfSVl2wj0=;
        b=l0RaBWa3E6buJCXAutZQtqOgMva2HrwJH1mAbyha0TSobkFXHz9C74wPIa1uPtxpdD
         5uC5eoHZ9Dgrje7HoWdFkEcHGjEDFXI8NLtdn6AmGcmrMltofkuXcZZBHYxBZSfHkR7R
         pJ+szgkQQFUqb6s+uQweS/Snd4rZYhaY03JzNdy2KVRYLE/hYGKMLbL9nc27fCpm/iMg
         /gTam+K/nLo5x1pyl8oG0gTmKehoi2wtzl9FBV1MzjEmR6yC5znUMecq6XPxkR7cjvVr
         hja+FNm2HWYadTcgqfyitFYz2OBCQ1ReD3OgB7TqnZ8V/P//zNyzmfrknCVD4DCi2Sjw
         oZqw==
X-Gm-Message-State: AC+VfDw+macbHSHyQ/7x2nMCPF78SX6dVwlzThTeMKHkXobczO81TGpC
        64JvliClR6hlLU5TN3q8v7zAqro6iulZ4qPedvOsh9YtEXFn8KUPeS4=
X-Google-Smtp-Source: ACHHUZ5IqG7lGig+wm7ji3SRnyhj5HiIQ8XKl8Lu5NKRS4yzb33lTu/IWlsq0HDGyMU8tLIXWiE/yDn/tEKbLiND4Ao=
X-Received: by 2002:a17:902:eb8e:b0:1ae:221b:5894 with SMTP id
 q14-20020a170902eb8e00b001ae221b5894mr217702plg.1.1685731442679; Fri, 02 Jun
 2023 11:44:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230602070224.92861-1-gaoshiyuan@baidu.com>
In-Reply-To: <20230602070224.92861-1-gaoshiyuan@baidu.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 2 Jun 2023 11:43:51 -0700
Message-ID: <CALMp9eRWJ9H3oY9utMs5auTM-BSCer=XA+Lsr9QVBqkFFDCFQw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86/vPMU: ignore the check of IA32_PERF_GLOBAL_CTRL bit35
To:     Gao Shiyuan <gaoshiyuan@baidu.com>
Cc:     seanjc@google.com, pbonzini@redhat.com, x86@kernel.org,
        kvm@vger.kernel.org, likexu@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Jun 2, 2023 at 12:18=E2=80=AFAM Gao Shiyuan <gaoshiyuan@baidu.com> =
wrote:
>
> From: Shiyuan Gao <gaoshiyuan@baidu.com>
>
> When live-migrate VM on icelake microarchitecture, if the source
> host kernel before commit 2e8cd7a3b828 ("kvm: x86: limit the maximum
> number of vPMU fixed counters to 3") and the dest host kernel after this
> commit, the migration will fail.
>
> The source VM's CPUID.0xA.edx[0..4]=3D4 that is reported by KVM and
> the IA32_PERF_GLOBAL_CTRL MSR is 0xf000000ff. However the dest VM's
> CPUID.0xA.edx[0..4]=3D3 and the IA32_PERF_GLOBAL_CTRL MSR is 0x7000000ff.
> This inconsistency leads to migration failure.
>
> The QEMU limits the maximum number of vPMU fixed counters to 3, so ignore
> the check of IA32_PERF_GLOBAL_CTRL bit35.

Today, the fixed counters are limited to 3, but I hope we get support
for top down slots soon.

Perhaps this inconsistency is best addressed with a quirk?
