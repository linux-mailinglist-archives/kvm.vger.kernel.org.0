Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3005F6CA785
	for <lists+kvm@lfdr.de>; Mon, 27 Mar 2023 16:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232691AbjC0OZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Mar 2023 10:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbjC0OYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Mar 2023 10:24:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BF97DB2
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679926947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vyn1Z4Cm3Qnn1B5gjs0PMw218V0pgoJF2q9YZrci5IA=;
        b=dfxq7n3PnTXeg3Efz7F3Hi7lcQv+dDfdqIBSurLjvDdZ3zhg3DpHRi26SYtyBieCcH7sFx
        Tx5tRFPFc4VoxANfBL1BFsuzzSyOORWzEw//xqhzuargqaSVKIkUuOWtS57nJqGNyS+6T5
        Lz2o3CDX1R3W9rcQeIGpk/aGHD2phdE=
Received: from mail-ua1-f70.google.com (mail-ua1-f70.google.com
 [209.85.222.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-BLiNIsRrPIyvJlw-wbbkQA-1; Mon, 27 Mar 2023 10:22:25 -0400
X-MC-Unique: BLiNIsRrPIyvJlw-wbbkQA-1
Received: by mail-ua1-f70.google.com with SMTP id y14-20020ab020ae000000b0074fa36da8adso4243622ual.19
        for <kvm@vger.kernel.org>; Mon, 27 Mar 2023 07:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926945;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vyn1Z4Cm3Qnn1B5gjs0PMw218V0pgoJF2q9YZrci5IA=;
        b=q2CIw3X4ISKhpwB8ft8GsdP3b7yWrjU68oq7PKo7tGOc9uok5MiWbmJCrO//EOsHfu
         aE/XaVtKx6XvNjxk/NnN3dlUFaGcBegP3c+coGdXkesukcX3r/rAi1i7Q3luEQK2lgRC
         zGA/mB30govzV+EawH2PrG9qOIiVdcMtFBTcjFN+4/yDu7Pnkc9h0k2ZWfVtvwkEeZF9
         dIkEHGE2Fqin3BvV8by08L4gQcbRsRqgNMHNbhlP+tE8M2pvLRC5hnPB0WftKyGmUh15
         Une1ZvFYECMmd7QMnJYpeF6J5CNcdZgTacL6w3DdzS1SmiRcZ0GY6Hr22kF35DUmR7Pa
         W5Tg==
X-Gm-Message-State: AAQBX9dcIyQJRQORWi/fYQ/UHSx+KqdmnERlYSdv6M17PNw6WZMw/EZU
        rQhyjTVe6ATOCqKkhvrbW/9UCNSnQV2GO599+Kudry5txuR+VrPqyiy4P4ItRIz31SOJzpDKMbe
        aaOCGwYzuzzzyPGDx6KzlNKJkbDh7
X-Received: by 2002:a67:ca87:0:b0:425:d255:dd38 with SMTP id a7-20020a67ca87000000b00425d255dd38mr6251391vsl.1.1679926945218;
        Mon, 27 Mar 2023 07:22:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350bl07pHGy/zP3d2BdHOczsEcEI97K10LYgkyXfU7tsU+NpG6dVmvmQkJy6N40BAAu9eE9DlNDALHagepcKfrtM=
X-Received: by 2002:a67:ca87:0:b0:425:d255:dd38 with SMTP id
 a7-20020a67ca87000000b00425d255dd38mr6251374vsl.1.1679926944945; Mon, 27 Mar
 2023 07:22:24 -0700 (PDT)
MIME-Version: 1.0
References: <ZBPZ4D9MIsaCNDh6@thinky-boi> <ZB3o/jsQIwS+4g4E@linux.dev>
 <86v8imwhi1.wl-maz@kernel.org> <49385a34-6ad7-255d-68d9-6b41a76f01df@redhat.com>
 <86sfdqwa9h.wl-maz@kernel.org>
In-Reply-To: <86sfdqwa9h.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 27 Mar 2023 16:22:13 +0200
Message-ID: <CABgObfYYxznmrV1_ooDvjnDwXvL5EY=xF59Fs2stQOgnaF8Y5A@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/arm64 fixes for 6.3, part #2
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, reijiw@google.com,
        dmatlack@google.com, james.morse@arm.com, suzuki.poulose@arm.com,
        yuzenghui@huawei.com, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 4:15=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
> > It missed the pull request I sent on March 17th by a few hours.  I
> > have queued it now and will send it to Linus later today.
>
> Maybe you could help us here and state what is your schedule when it
> comes to sending these pull requests? It would certainly help
> coordinate and avoid wasting 10+ days to get things merged.
>
> I appreciate that you don't need nor want to wait for us to send
> something to Linus, but if we know when the train is departing, we can
> make sure we're standing on the platform early enough.

In general, sending the pull request to me on or before Thursday will
work best, though I have no problem sending stuff to Linus on Sunday
morning (so that architectures don't need to time their request too
carefully).

These weeks my Friday afternoon was more free than usual due to all
meetings with American people moving one hour earlier, and that
translated into different family plans for Friday itself and over the
weekend.

Paolo

