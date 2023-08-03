Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40A4E76DF0B
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 05:33:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbjHCDdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 23:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbjHCDdC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 23:33:02 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C72C8E61
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 20:32:59 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id 006d021491bc7-55e1ae72dceso305088eaf.3
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 20:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691033579; x=1691638379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LTNE6qlcxM1i0PcHskgHEnRcd+f44VUJz3njSknkI/s=;
        b=py+/eIrs5YCHB2Oru937Ea5D9UcfiN/pYPSrGRSjlN5KRXVdRMr3zW2/QZwekX97Jl
         ZKoJ101PAqdJL5I+GVwi7u0Ju+p8HlCzcMMEc6UoTqlPi3N50mdWSxppSbG88yT3LzrH
         6GN0yxzA46ArrgGZno/fWmRkkGf5LgMsq72s2ZPWbv2XpurXxvKBfDUIHRx9ydxoopkz
         goFtPDafSSeXEo+B05Huc8HDZaWPPxGowzbN8Ama1QI8JYrLsv2ePXukU4Vh9ACPpp5i
         aeeRtUNbVJFpJiJOGSIVMcH76Ht7QhynrQMlNQvVjsnY8rxrxhuEJGT/IF3D2duEruaI
         lAiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691033579; x=1691638379;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LTNE6qlcxM1i0PcHskgHEnRcd+f44VUJz3njSknkI/s=;
        b=QoB0DklPbuaHbNikqFkFUWMOpKDTO1xyb2svdgFtacDNgSAduw6ekgy8iG2Yy/EN9G
         Ka27IBHJIdeNyI6JS02KPgwJYIO9pD94q4RQwcRWhjCUN1qirI1BWQSg+B1yn/+D+4rl
         x5QALO+gYe/48NdlQtfl/RzkBbP5nN8a7c+UV0fBZaCYbxZKRrrZwqGVT8Zo0lrZuHtf
         ve1JRMBppkeBBwdSd1MWvukaV19ymbNEKz0AJAPwZ8m/MnARvbKpKe/gYPA3I4+I19jg
         5CrpxFXeqNANy6MADqy2fIKmiI8kJQ3fSNIVDOB1hj6J5ZIjVilJWhWUK+z+mPG8WUwi
         jiyw==
X-Gm-Message-State: AOJu0YygqOVB0A4F/EZjDF1ViIxTQZUioltFlrBA8jipQExHhaRn43g9
        66MWE035GZvUptDJCGY2Phe9zhoHwnQnnlXIduG06A==
X-Google-Smtp-Source: AGHT+IHcxC0wvEo7xcqzzTyr9+/Mog6eIkUZeINgRRrAOqEuqwJbtV9No/bOrCbt+PPGuk6wsh7lHk3XeTMAxzxvgJg=
X-Received: by 2002:a05:6870:560e:b0:1bf:7b28:a4b3 with SMTP id
 m14-20020a056870560e00b001bf7b28a4b3mr677047oao.13.1691033578965; Wed, 02 Aug
 2023 20:32:58 -0700 (PDT)
MIME-Version: 1.0
References: <20230726044652.2169513-1-jingzhangos@google.com> <ZMrVBWg+c3PSUilR@google.com>
In-Reply-To: <ZMrVBWg+c3PSUilR@google.com>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 2 Aug 2023 20:32:46 -0700
Message-ID: <CAAdAUthkeu-_5MeR689boGkzkkCbtz+Hrhm0XxQZh0a7S96jaQ@mail.gmail.com>
Subject: Re: [PATCH v1] KVM: arm64: selftests: Test pointer authentication
 support in KVM guest
To:     Sean Christopherson <seanjc@google.com>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 2, 2023 at 3:13=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> On Tue, Jul 25, 2023, Jing Zhang wrote:
> > Add a selftest to verify the support for pointer authentication in KVM
> > guest.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
>
> ...
>
> > +     /* Shouldn't be here unless the pac_corruptor didn't do its work =
*/
> > +     GUEST_SYNC(FAIL);
>
> FYI, I'm fast tracking guest printf support along with a pile of GUEST_AS=
SERT()
> changes through kvm-x86/selftests[*].  At a glance, this test can probabl=
y use
> e.g. GUEST_FAIL() to make things easier to debug.
>
> [*] https://lore.kernel.org/all/20230729003643.1053367-1-seanjc@google.co=
m

Thanks for the heads up, Sean!

Jing
