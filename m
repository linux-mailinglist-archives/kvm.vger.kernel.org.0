Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9258A73A90F
	for <lists+kvm@lfdr.de>; Thu, 22 Jun 2023 21:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230280AbjFVTka (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Jun 2023 15:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbjFVTk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Jun 2023 15:40:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8CF1A4
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 12:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687462785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Edd2SuIQ3rUI8IaV9M9bH7sRwy/Lge1qapI4gHEyAgk=;
        b=JWkkBHO4FFhtst3dpI8NzQK8f/dfNxUDCX4z+7wuAYzHBr3Y+q5EUkFx8GYpuaz9p4EmjG
        zVRGup+OKynWskfVxM4FkY5CitaOsDSHLykMTHSRxA1avL8IiA40XQupq3ottb4pYGhlPz
        1zUMh8rP8IbM7iiA57rEmrQoNUcoysQ=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-574-QFISMeKwPOOzt1wCzPgCzw-1; Thu, 22 Jun 2023 15:39:43 -0400
X-MC-Unique: QFISMeKwPOOzt1wCzPgCzw-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-440cff7a170so905037137.0
        for <kvm@vger.kernel.org>; Thu, 22 Jun 2023 12:39:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687462781; x=1690054781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Edd2SuIQ3rUI8IaV9M9bH7sRwy/Lge1qapI4gHEyAgk=;
        b=GDnaYw9yy1jnYAYspoS/kAfftqfk9XQzGNuQPeuz4U+16sRtj7o2Sk50K2QRvfHeT4
         hBkO6jN+4Q+LZ2rro5GJ2IN38A6WPba/LNeirDIkgmWjT9cFW8cBquAWOUK4qHkM81Ls
         w/zf7smr132f+kLKouxfhsWicmE9MK29FfIW5aqIM/aD1tEM5YZfqBuozmTmeo+ngRg4
         567eqdKzswwTzTulpjiXC6CKZJFkD3osYVOsIB9HvaCE8FnOiSkxV89LbaH7Qx4Sr8F2
         5oHYT0CELXHaKv/HwjNSlJrQPWv7lwVeop7CFL4M11dbqIzLWtMCctakfrLDA5ZYvTJ6
         0/ig==
X-Gm-Message-State: AC+VfDws2FVcteQ1UaBZdvkAQZWcjwF7b6ye+EsO2nfd9RAZlymqyUhU
        W6hRqH1EEGwwyMnxglxEsgSb+d3F6SMTu7N85AicF+l1BXQxazFpMmq13N3s+U/x2u9OnugSHhz
        dD5kLhPZyZ6KtTFZUXdtejSvy05zHxyE5Jxnz
X-Received: by 2002:a05:6102:485:b0:440:b6b5:eb30 with SMTP id n5-20020a056102048500b00440b6b5eb30mr5603036vsa.10.1687462781614;
        Thu, 22 Jun 2023 12:39:41 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6v49HgjgIIqCSi3sjYhFVyX+ZxdXrX5nJ0x5xE7UTZXMcQlvPQVMPZn47t28O8kk5Ah4NtrZD5jfO+Peujdv0=
X-Received: by 2002:a05:6102:485:b0:440:b6b5:eb30 with SMTP id
 n5-20020a056102048500b00440b6b5eb30mr5603019vsa.10.1687462781337; Thu, 22 Jun
 2023 12:39:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230608155255.1850620-1-maz@kernel.org>
In-Reply-To: <20230608155255.1850620-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 22 Jun 2023 21:39:30 +0200
Message-ID: <CABgObfYTyzDQoGrt=cFHyejH7e=R3jZ+K5BC=Wa4SyQJ_UbNEQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.4, take #4
To:     Marc Zyngier <maz@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Reiji Watanabe <reijiw@google.com>,
        Sebastian Ott <sebott@redhat.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 8, 2023 at 5:53=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> Paolo,
>
> Here's yet another batch of fixes, two of them addressing pretty
> recent regressions: GICv2 emulation on GICv3 was accidently killed,
> and the PMU rework needed some tweaking.
>
> The last two patches address an annoying PMU (again) problem where
> the KVM requirements were never factored in when PMU counters were
> directly exposed to userspace. Reiji has been working on a fix, which
> is now readdy to be merged.
>
> Please pull,
>
>         M.
>
> The following changes since commit 40e54cad454076172cc3e2bca60aa924650a3e=
4b:
>
>   KVM: arm64: Document default vPMU behavior on heterogeneous systems (20=
23-05-31 10:29:56 +0100)
>
> are available in the Git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kv=
marm-fixes-6.4-4

Pulled, finally. Apologies for the delay.

Paolo

