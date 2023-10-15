Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B97697C98EE
	for <lists+kvm@lfdr.de>; Sun, 15 Oct 2023 14:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbjJOMYO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Oct 2023 08:24:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbjJOMYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Oct 2023 08:24:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86473A9
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 05:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697372605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJ81Q5/B7q8cI3s0s8gDvVOoyclQrSAhpuPqTSeggew=;
        b=f7dcEUtx0+aFToHWdsVjjMWSZxv50Vo9NydFNf4KMSHmtim7scNhmbM+1yEkRaF6SF4Qty
        ho+JlTeDvUDyp/rb599Y6QfmbnUnZH9k/aEsWAUI9Uf2hXeW2f5RLg2gj/o2X+wYXz4h2O
        8qkMxBI2aQAvXtLujbMOYYiAoS9lU4g=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-314-yZ2VMO2WMCGlhy5gJ51rkQ-1; Sun, 15 Oct 2023 08:23:18 -0400
X-MC-Unique: yZ2VMO2WMCGlhy5gJ51rkQ-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-457bcc71151so887550137.3
        for <kvm@vger.kernel.org>; Sun, 15 Oct 2023 05:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697372597; x=1697977397;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MJ81Q5/B7q8cI3s0s8gDvVOoyclQrSAhpuPqTSeggew=;
        b=aGDnlAL4GWffWoler0Ko3PfV7pAL1uUDHOSAuPw6mN01jnKOXIVURyYbQVAyqK279Z
         frLUjyNXJgUXfTvaxI5gCPmDLIDtbGhfKqsQKT68tbZZgutcygu7jIFBwk7P9Bbx15MU
         Y4ZZEHJBIs1hGPZQLjYobNBSszFJTN1TRkDBpNyeAnXNHCHVgho8C+vPFBTCv/+8LpbQ
         2viLzFYro7vos2UlPO3B06Pmt/Qf9oX7GiD3rchY8JQc3O6hPO0ggRFLuC7KYaey8oFB
         aF0j6EKv86hKkIz9XYXYI+4sLo9tselAjyvm8u8jpo4cKpVGSYih2usu8wbWZD3K1Iau
         Z6qw==
X-Gm-Message-State: AOJu0YyFECuaGqc2iRANcNH/ziAPXGIy+9R0dNnD2fugN9s1dEKo4UdV
        5ZQkmamn1WFPxzidzEJV/A1/fHUzSE4k/Wf4hAM+lrih3SiDXMiIbkKb9dfkSm82x9xspijBEnk
        e6BM2UnWGvGm9kyMWzu/sbadsKHgs
X-Received: by 2002:a67:e1c4:0:b0:457:bdbf:8a34 with SMTP id p4-20020a67e1c4000000b00457bdbf8a34mr5510902vsl.29.1697372597589;
        Sun, 15 Oct 2023 05:23:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHLssNye3K6hgQQYMw1WXAnaq+73MFpiDByXlBI9bAJiL9b103Flr6+4ZBOkqE2VWibhn55BXabT71I1Q4Czc4=
X-Received: by 2002:a67:e1c4:0:b0:457:bdbf:8a34 with SMTP id
 p4-20020a67e1c4000000b00457bdbf8a34mr5510883vsl.29.1697372596972; Sun, 15 Oct
 2023 05:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <20231013213053.3947696-1-maz@kernel.org>
In-Reply-To: <20231013213053.3947696-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sun, 15 Oct 2023 14:23:05 +0200
Message-ID: <CABgObfYQoepvvB6j7k2gei0DdV+noO-qSfEzqFcmrKLM_URG_Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.6, take #2
To:     Marc Zyngier <maz@kernel.org>
Cc:     Anshuman Khandual <anshuman.khandual@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        James Morse <james.morse@arm.com>,
        Joey Gouly <joey.gouly@arm.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Oliver Upton <oliver.upton@linux.dev>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 13, 2023 at 11:31=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
>  Paolo,
>
> Here's a set of additional fixes for 6.6. The most important part is
> the fix for a breakage of the Permission Indirection feature, which is
> a regression. The other (less important) part is a fix for the physical
> timer offset.
>
> Please pull,
>
>         M.
>
> The following changes since commit 373beef00f7d781a000b12c31fb17a5a9c2596=
9c:
>
>   KVM: arm64: nvhe: Ignore SVE hint in SMCCC function ID (2023-09-12 13:0=
7:37 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.6-2
>
> for you to fetch changes up to 9404673293b065cbb16b8915530147cac7e80b4d:
>
>   KVM: arm64: timers: Correctly handle TGE flip with CNTPOFF_EL2 (2023-10=
-12 16:55:21 +0100)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.6, take #2
>
> - Fix the handling of the phycal timer offset when FEAT_ECV
>   and CNTPOFF_EL2 are implemented.
>
> - Restore the functionnality of Permission Indirection that
>   was broken by the Fine Grained Trapping rework
>
> - Cleanup some PMU event sharing code
>
> ----------------------------------------------------------------
> Anshuman Khandual (1):
>       KVM: arm64: pmu: Drop redundant check for non-NULL kvm_pmu_events
>
> Joey Gouly (2):
>       KVM: arm64: Add nPIR{E0}_EL1 to HFG traps
>       KVM: arm64: POR{E0}_EL1 do not need trap handlers
>
> Marc Zyngier (1):
>       KVM: arm64: timers: Correctly handle TGE flip with CNTPOFF_EL2
>
>  arch/arm64/include/asm/kvm_arm.h |  4 ++--
>  arch/arm64/kvm/arch_timer.c      | 13 +++---------
>  arch/arm64/kvm/emulate-nested.c  |  2 ++
>  arch/arm64/kvm/hyp/vhe/switch.c  | 44 ++++++++++++++++++++++++++++++++++=
++++++
>  arch/arm64/kvm/pmu.c             |  4 ++--
>  arch/arm64/kvm/sys_regs.c        |  4 ++--
>  include/kvm/arm_arch_timer.h     |  7 +++++++
>  7 files changed, 62 insertions(+), 16 deletions(-)
>

