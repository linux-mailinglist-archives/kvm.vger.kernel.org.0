Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C482E6F4CE1
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 00:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjEBWb3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 18:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbjEBWb2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 18:31:28 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E56B6E6
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 15:31:24 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-559e281c5dfso44305477b3.3
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 15:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683066684; x=1685658684;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SIVJcGIva647UNmGPK+udMl/NK3kjFoUm0hqJKOqIDI=;
        b=yug6czQuDTCW52dBy0FDo7Ylclb8BkXmgTi1DJAnoQ+xgU2idHTbWnXdTTaBWr6dzJ
         IEdaDHkrbH3ssuq/0xYLXmYabqGtRcwcr+4NpyOB2Sfk09KVuV3cm0jmd8R46YYbKZ9M
         dErvexVAqOHnTn0m2k69T5hQi/ufSgbuubVsS+RcPUU8J5eJBTDEreEaIwzqQS07CFlx
         oXQPNrrmE78oDI6/2VBhOdr308e2+MjVjSDM8vbedos5C9W/OsNwIVTvcP1hz3HcY6+v
         tLWRmTwghSrHm/aghAQOOCRp3mkhP40paoqjzVQ1BhxqUqKiL8BjRoDvhdXJ1y1YD8zp
         PZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683066684; x=1685658684;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SIVJcGIva647UNmGPK+udMl/NK3kjFoUm0hqJKOqIDI=;
        b=Ald7gxQrAmrDeirRSNLwq4dSA2CHFDs9Qh7lf1jCW/KRuUuUwwbMImbVGoF6OGoT0/
         Uw5Av+2jydKC5C5JUzCqTgqWvKkgLG0ZtXJ/kxuIDCpXfDygXwTthwOf36Cf/6M8CqTD
         OXA84HrsAxzDzoC3Ap8YGI5lzZlOIFCCxKgKIiE8EuG3JRhUj1paS+sQfeBxqkB0fujn
         zsDcH4s/YSXhpKTFiz/87Hkd75Dg4Y8G5rJQdiXyPR7Ze0h/0uOptO/Y8kW/xgAFRTmf
         3WJArgkud74MuWefM1iS+wGzZpPVkY+MVUAu+eo11SAg5EhmIY5IiX305nIPXafBn7Rl
         Wk8A==
X-Gm-Message-State: AC+VfDyliB2sLL39BxMKYDz96MTZKjzQCCiaOJjX4JSpihap43C/8ZIW
        ig/mb4uejFpOj+N8KtHwRChLyW1S5pM=
X-Google-Smtp-Source: ACHHUZ7EqoPbhh3PehAzC9G/nHvcRMmoqlIIGsHGscULH/yhOYfuJYlRXmZ0yd6tLxOKpU03tK93mgs1Qj8=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:72c:b0:52e:e095:d840 with SMTP id
 bt12-20020a05690c072c00b0052ee095d840mr11910199ywb.0.1683066684192; Tue, 02
 May 2023 15:31:24 -0700 (PDT)
Date:   Tue, 2 May 2023 15:31:22 -0700
In-Reply-To: <CAF7b7moeysHUtiS_5DL9c5OPKnCsiO50zBkjp1m4QjVTvXF58A@mail.gmail.com>
Mime-Version: 1.0
References: <20230412213510.1220557-1-amoorthy@google.com> <20230412213510.1220557-5-amoorthy@google.com>
 <CAF7b7mqq3UMeO3M-Fy8SqyL=mjxY4-TyA_PjgGsdVWZrsU2LLQ@mail.gmail.com>
 <ZFFbwOXZ5uI/gdaf@google.com> <CAF7b7moqW41QRNowSnz3E-T+VQMrkeJthDVxM2tuNHtJ5TTjjQ@mail.gmail.com>
 <ZFF1ibyPZHKYzEuY@google.com> <CAF7b7moeysHUtiS_5DL9c5OPKnCsiO50zBkjp1m4QjVTvXF58A@mail.gmail.com>
Message-ID: <ZFGPOiip/Sf8V8DU@google.com>
Subject: Re: [PATCH v3 04/22] KVM: x86: Set vCPU exit reason to
 KVM_EXIT_UNKNOWN at the start of KVM_RUN
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     pbonzini@redhat.com, maz@kernel.org, oliver.upton@linux.dev,
        jthoughton@google.com, bgardon@google.com, dmatlack@google.com,
        ricarkol@google.com, axelrasmussen@google.com, peterx@redhat.com,
        kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 02, 2023, Anish Moorthy wrote:
> On Tue, May 2, 2023 at 1:41=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > If KVM triggers a WARN_ON_ONCE(), then that's an issue.  Though looking=
 at the
> > code, the cui() aspect is a moot point.  As I stated in the previous di=
scussion,
> > the WARN_ON_ONCE() in question needs to be off-by-default.
> >
> >  : Hmm, one idea would be to have the initial -EFAULT detection fill kv=
m_run.memory_fault,
> >  : but set kvm_run.exit_reason to some magic number, e.g. zero it out. =
 Then KVM could
> >  : WARN if something tries to overwrite kvm_run.exit_reason.  The WARN =
would need to
> >  : be buried by a Kconfig or something since kvm_run can be modified by=
 userspace,
> >  : but other than that I think it would work.
>=20
> Ah, ok: I thought using WARN_ON_ONCE instead of WARN might have
> obviated the Kconfig. I'll go add one.

Don't put too much effort into anything at this point.  I'm not entirely co=
nvinced
that it's worth carrying a Kconfig for this one-off case (my "suggestion" w=
as mostly
just me spitballing), and at a quick glance through the rest of the series,=
 I'll
definitely have more comments when I do a full review, i.e. things may chan=
ge too.
