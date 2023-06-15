Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16014730CF4
	for <lists+kvm@lfdr.de>; Thu, 15 Jun 2023 03:57:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbjFOB5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Jun 2023 21:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237931AbjFOB5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Jun 2023 21:57:14 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EE4D198D
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 18:57:13 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b4fe2139a8so58405ad.1
        for <kvm@vger.kernel.org>; Wed, 14 Jun 2023 18:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686794233; x=1689386233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FMLY1axQ9dhHgS2evzrC32ToK9p7zpIVVjZVrkVP9Q4=;
        b=JgGHVcV8/EOlg76CXREOFygRfcPLh0TvPl2YGB0VlwURFpypN66Kb1alr53MRziI0e
         HBYWPc90/oiaA7G6zUyWrl/uxY/oAhW9DKtoyE8Ho3PoorWVYZdX4w3Fxq1OcnWLaBu6
         0LKDTDBzdo+KJIsG26awIGClEZe4bI/iRsZu0tmLTBVPsEH5a72580lO+Sy8YC0GOW6g
         o08HyBosEsk2I2G38RG0zWToRkkdp29E/XznTlNmnTiVzEmZY/AWdY+4p3O/H67u6ndI
         38FJWCrJAW8asX0QUo3w9AW+tptp2b5A3zCqQDu8DCVyosUvLpbpp5JXKWyLmpsPZkbg
         VkUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686794233; x=1689386233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMLY1axQ9dhHgS2evzrC32ToK9p7zpIVVjZVrkVP9Q4=;
        b=jWFyrYWRfY1ObS10NiL3NGmSmrU3FhLjKbFHafYK0o1ZLj/8XlKmHqzh6WkXVPEjc7
         CQUEeJcl+8BrChB/s55qMoSeUYLzWD/nydAIwvFFnLmxS7uT8leqJdz6nVq8fidW8DK8
         33izaE5lT6YbLeAFtHM85aAMZj87wDw1iw1XV4Lti4tvMhD2RviBziP6IUEHqOQ5lS2Y
         96PkEvhE50a9Kjt65p8SpKmkXY6i5Fc3fhubRXOtqvjiIwQMFVq/S9+/xY1jKckWoK6x
         J62UsB6XM1gQDYwS9en7QOCqnzEE9Ap65S4LZvQGdMOzBN7MC3yvdb4e96ps2/OJHfLr
         xI1g==
X-Gm-Message-State: AC+VfDyaVYX5MU2L2yIumH25CSZjm8NCQhkfDfnPT+wKAx0qJh9NAtSQ
        EiUenBnrEjia1s3T2c4ubASrrL10KWzIxZ87gBiAI5/a6j4C6fdoAQo=
X-Google-Smtp-Source: ACHHUZ7k0wQBEo+NKxdCH3hP8L0i+8TYR5xJPePgVUW4Nh6Q7s/Lv/FmuVPnnao1IQ/tXOiUiu+GK3HzgdtUQbbtnqs=
X-Received: by 2002:a17:902:f684:b0:1b3:a195:12d4 with SMTP id
 l4-20020a170902f68400b001b3a19512d4mr124232plg.12.1686794232483; Wed, 14 Jun
 2023 18:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230606192858.3600174-1-rananta@google.com> <ZImwRAuSXcVt3UPV@linux.dev>
In-Reply-To: <ZImwRAuSXcVt3UPV@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Wed, 14 Jun 2023 18:57:01 -0700
Message-ID: <CAJHc60wUSNpFLeESWcpEa5OmN4bJg9wBre-2k8803WHpn03LGw@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] KVM: arm64: Add support for FEAT_TLBIRANGE
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 14, 2023 at 5:19=E2=80=AFAM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Raghavendra,
>
> On Tue, Jun 06, 2023 at 07:28:51PM +0000, Raghavendra Rao Ananta wrote:
> > The series is based off of upstream v6.4-rc2, and applied David
> > Matlack's common API for TLB invalidations[1] on top.
>
> Sorry I didn't spot the dependency earlier, but this isn't helpful TBH.
>
> David's series was partially applied, and what remains no longer cleanly
> applies to the base you suggest. Independent of that, my *strong*
> preference is that you just send out a series containing your patches as
> well as David's. Coordinating dependent efforts is the only sane thing
> to do. Also, those patches are 5 months old at this point which is
> ancient history.
>
Would you rather prefer I detach this series from David's as I'm not
sure what his plans are for future versions?
On the other hand, the patches seem simple enough to rebase and give
another shot at review, but may end up delaying this series.
WDYT?

Thank you.
Raghavendra

> > [1]:
> > https://lore.kernel.org/linux-arm-kernel/20230126184025.2294823-1-dmatl=
ack@google.com/
>
> --
> Thanks,
> Oliver
