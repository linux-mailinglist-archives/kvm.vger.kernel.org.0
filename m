Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74183748DBE
	for <lists+kvm@lfdr.de>; Wed,  5 Jul 2023 21:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234278AbjGET1M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jul 2023 15:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbjGET0z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jul 2023 15:26:55 -0400
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F2B32135
        for <kvm@vger.kernel.org>; Wed,  5 Jul 2023 12:26:09 -0700 (PDT)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-1b06da65bdbso35801fac.1
        for <kvm@vger.kernel.org>; Wed, 05 Jul 2023 12:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1688585168; x=1691177168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9KIxxp026/w7UKJlFK3fYGlwG+XSxn3u3/0XumxsaeA=;
        b=054SwNoSENr7q1hk4ph8TPf6/Rl9OBTQDS21mJ2SKL3lagyOMq34Swlbd6UcIJGfxk
         6FfgtaKhK/V/WLW0AfBdjrNpSSsskPUsobYjWw1XAtCUKud1vJ8g435rvAZd8dM3+AIr
         qzQ5hJl9FQpbRU4d1NqR8SrFS2BwF7tCJbNbcFAG/EEY0U2ndRg5plumKc1aRgDD910u
         Xi/SDhlkvO6L5DktKz/M82eAU8mqOfF3GBnyi01If851eD59MG6hCk5io8gIu4HbqxoE
         1riwvUFiezCOF5HRYHr5GoZDGAEKkMwC/RV+udIvu6n2h5nmggpZ/By9liaRjRMUz0UG
         lD/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688585168; x=1691177168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9KIxxp026/w7UKJlFK3fYGlwG+XSxn3u3/0XumxsaeA=;
        b=QqL/ZPWX2v95qRsdj7esHJyRR1Tnwy8vr9RxiHQXHl54gsN+SzzeXF6dY8VOI2+als
         qmsx4T/eZAUAeOp6jnlSt51qOphwKCYCaCtZiNKu5rRhOIhKBLWgxP00opOu5Hv55lAl
         2jacLglq9yZqxYgiXkSfm1RPNPpG97JVkxaYwVUAfF8Gl4SXJg6mXnyfRlZJo0kM5G28
         mn87jxO9VHarOJmjmLtl8lD152a9oc+yQHD8puT32bq/qh17UO1WdEykJe+BC6cN9ahh
         5w/VgVyj7DA1GDyZlmGLh/bRWRors5ehB3TdYHq1/pdz2oEA0jvZLKC+Z4dasE3qn4sd
         gYcA==
X-Gm-Message-State: ABy/qLZ3C//lMMspBCjY7A9qkY9QEVe50Ot7NcGU6l81l90uH2gO4YWk
        PsGetsiLxaVlPMIb5Ynj7iHovd3ATojJfgfvUcdSoQ==
X-Google-Smtp-Source: APBJJlGvXWeSNtOCYEgeQwfIozB9e87JkiwqFzwV4rWdasBMr59GIrb4XnRvhSMyWX4xvVnZXe/BP2yXaEGboH9NXRU=
X-Received: by 2002:a05:6871:4409:b0:1b0:5290:c95e with SMTP id
 nd9-20020a056871440900b001b05290c95emr15909408oab.42.1688585168238; Wed, 05
 Jul 2023 12:26:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230607194554.87359-1-jingzhangos@google.com> <ZJn6niA1RgAqu7DC@linux.dev>
In-Reply-To: <ZJn6niA1RgAqu7DC@linux.dev>
From:   Jing Zhang <jingzhangos@google.com>
Date:   Wed, 5 Jul 2023 12:25:57 -0700
Message-ID: <CAAdAUtjqR1WrCNF9OFxe0atWj1P_Mc+OPv9tLKU3t7QbeiWaqg@mail.gmail.com>
Subject: Re: [PATCH v4 0/4] Enable writable for idregs DFR0,PFR0, MMFR{0,1,2}
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>,
        ARMLinux <linux-arm-kernel@lists.infradead.org>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oupton@google.com>,
        Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fuad Tabba <tabba@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>,
        Suraj Jitindar Singh <surajjs@amazon.com>
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

Hi Oliver,

On Mon, Jun 26, 2023 at 1:52=E2=80=AFPM Oliver Upton <oliver.upton@linux.de=
v> wrote:
>
> Hi Jing,
>
> On Wed, Jun 07, 2023 at 07:45:50PM +0000, Jing Zhang wrote:
> >
> > This patch series enable userspace writable for below idregs:
> > ID_AA64DFR0_EL1, ID_DFR0_EL1, ID_AA64PFR0_EL1, ID_AA64MMFR{0, 1, 2}_EL1=
.
> >
> > It is based on below series [2] which add infrastructure for writable i=
dregs.
>
> Could you implement some tests for these changes? We really need to see
> that userspace is only allowed to select a subset of features that're
> provided by the host, and that the CPU feature set never exceeds what
> the host can support.
Sure, will add a selftest for these.
>
> Additionally, there are places in the kernel where we use host ID
> register values for the sake of emulation (DBGDIDR, LORegion). These
> both should instead be using the _guest_ ID register values.
Will add a new commit for these change.
>
> --
> Thanks,
> Oliver

Thanks,
Jing
