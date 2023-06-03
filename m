Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07BC27211BE
	for <lists+kvm@lfdr.de>; Sat,  3 Jun 2023 21:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjFCTP5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Jun 2023 15:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjFCTPz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Jun 2023 15:15:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86A3197
        for <kvm@vger.kernel.org>; Sat,  3 Jun 2023 12:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685819706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DnPK8tVOnIu5iVyOmiMdqzb+Fu0aARjMaEhuhDTR2qQ=;
        b=TAXlMe88nId36K4auis29evX2T0TAp75Nk8u6jPt+TVN4kW95cjcPztcuUvBHK6gYr/5KY
        oey+sm/5efLIJQtAUxkJKUCDG9pQqSFZjimSWqtNoJPB8WFbAP4RGtjeXB+7bcy4m1APKS
        7lDRkIySXhEoR2aUFRHT/zQhn7Iymis=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-317-NzKB23kwMEWRCiHUG5BEBQ-1; Sat, 03 Jun 2023 15:15:05 -0400
X-MC-Unique: NzKB23kwMEWRCiHUG5BEBQ-1
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-437e6224e38so736646137.1
        for <kvm@vger.kernel.org>; Sat, 03 Jun 2023 12:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685819704; x=1688411704;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DnPK8tVOnIu5iVyOmiMdqzb+Fu0aARjMaEhuhDTR2qQ=;
        b=AmP5b43dSJMFvHOfaPQ9vcG/48trEk7exdPMMuSllukk9J9eGksa8etFsE+IelKNxY
         zbNAsPPU61HTSUGKEEYwE26z0dRA6PvzW3ANJSpbBSJ8RJ/L3lcxMdnkRqG/1txPHleG
         xI189GgD6etH4Lp7fqtSEQHwbYMgQx8M/zdVEzxqawyD1T/lBvKO/2j8Z3T2ywrE7V8m
         h4Fg2IyFipjByW3XuaMYd9+u8A4k7xdOZHVg9bRMADLIHp5VVbwQTqacGxoLqubDGFEz
         QycXL1HeSLXn//uX1qr0MFRHkciqRATgJGCz/p4MYGkse1NbBGDzyYXr8+6PlH1GmBO2
         RznA==
X-Gm-Message-State: AC+VfDz4xJVQgFQjq7zeFKZod8z9PeMsZwmQhpe8SirAnoT8u1CC2u96
        ZOKgoiSuZAjc4VxVUz3pyzqw9QWd0X24+akmS+/NoRPMhN0tHMvy9o0GeNK7BbmzhvBdSshR2gi
        MWKzQkiwLWTU2yAvWU/FrnUVfsdKcyo73NNrL
X-Received: by 2002:a67:f516:0:b0:43b:1a6e:b105 with SMTP id u22-20020a67f516000000b0043b1a6eb105mr3300214vsn.13.1685819704085;
        Sat, 03 Jun 2023 12:15:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5Bst0bhcf5pkOuZSlY76/be3DNNv46RicRmDFmPPFPfvt9ff7FUTtG4TIWehE6uZmToXLR2lgL8HtrGGGuonY=
X-Received: by 2002:a67:f516:0:b0:43b:1a6e:b105 with SMTP id
 u22-20020a67f516000000b0043b1a6eb105mr3300212vsn.13.1685819703859; Sat, 03
 Jun 2023 12:15:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230524125757.3631091-1-maz@kernel.org> <e6baaa4dbb813cd46c41d079154e3e15@kernel.org>
In-Reply-To: <e6baaa4dbb813cd46c41d079154e3e15@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Sat, 3 Jun 2023 21:14:52 +0200
Message-ID: <CABgObfY5igVKMre4Ze21XrGffuG9wEa1ROpLDqk8_4PNi0h7xQ@mail.gmail.com>
Subject: Re: [GIC PULL] KVM/arm64 fixes for 6.4, take #2
To:     Marc Zyngier <maz@kernel.org>
Cc:     Cornelia Huck <cohuck@redhat.com>, Fuad Tabba <tabba@google.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Quentin Perret <qperret@google.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 24, 2023 at 4:18=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On 2023-05-24 13:57, Marc Zyngier wrote:
> > Paolo,
> >
> > Here's the second batch of fixes for 6.4: two interesting MMU-related
> > fixes that affect pKVM, a set of locking fixes, and the belated
> > emulation of Set/Way MTE CMO.
>
> OK, $subject is an indication of what's on my mind...
>
> But please pull anyway!

Uh oh, this was not filtered correctly. Pulled now, separately to
preserve the tag message.

Paolo

