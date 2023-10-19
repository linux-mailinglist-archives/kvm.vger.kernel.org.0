Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01EDD7D011F
	for <lists+kvm@lfdr.de>; Thu, 19 Oct 2023 20:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345405AbjJSSFe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Oct 2023 14:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbjJSSFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Oct 2023 14:05:33 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 082F2124
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 11:05:30 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1c9d4f08d7cso20575ad.0
        for <kvm@vger.kernel.org>; Thu, 19 Oct 2023 11:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697738729; x=1698343529; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X79WPuk0kI/Em6qMbs24oISDzyvT6ZbjodD9ilXj+Jg=;
        b=GQ5byXDBZunYyxebO377e+jO7uTKZmd3RMGNISic/cc7cufZyel9VMfqGO4G53U/Kb
         z2zS0JA0Y3muD2YEJaV3O8IAJ02R79wPBWCmZ1qG51C62sEBUdu6uoaNUZx6qzC621nK
         BluKb7Qi+t6UOJpN+U3EWy0k0bdZYioxyoe7XJlBto5N6J8ubGloPCNumeeTXxU28fX8
         a1oX7kOwflEBwcay8Xol+HM+IetiRV2z+m04Sq8+9eq2AY/+0McuZ2inzuS9UDRmW5x1
         lpSZdO+mhLiQCDf2zJd4WCOFaXsxTWP7f1A9+N+BhyBI7ZNFblwMTdOWdUfRQTh2GrDz
         Y8mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697738729; x=1698343529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X79WPuk0kI/Em6qMbs24oISDzyvT6ZbjodD9ilXj+Jg=;
        b=Srrbo5RTsJfIziPztWZj7uCe8SLj9O+kQSUwbTmGMGOXqw9JJDlsxVudoKdg59nOfe
         eUErOAVImuHzlRajBsa0S1Smt68K/k288f4TIKpCSBzBibRC1CxDKidMtQ2hYZsczekp
         Tro02dmYobkUkF1dQFhDy4+70RJeZ5HP7zy8ue3WuIWYJBdzecWWT7Ubpgj4BQcygejN
         a80PghvalCC+VtFOOsrnoEdnVCyCLs/xSC2678e3DauK/nnAoIgYiAYXPutzv+xsDJRY
         hWP8c+eX+wLJL0kppTVGMXChIYVbFKINNLHSovDfn3ddyBofO/hjIigZ4DYnftz4y9B/
         tLug==
X-Gm-Message-State: AOJu0Yy/tKsZSCrUxdH5hok1ih/Dr4rzfhVHcsZW6WQk2epaTypUYRzz
        4NhfBpuhHT7t109cXiryJDrq/PO8WP0FA2h0sEhcSw==
X-Google-Smtp-Source: AGHT+IGPFLME4RoxjHjo1Pf3PTYmSxKaORuw3AAyosh0yvejALLkHkk75EQDfaXWAFN6tu+Lh+D7VkjaPKVDnv/kJOo=
X-Received: by 2002:a17:902:ebc4:b0:1c4:1392:e4b5 with SMTP id
 p4-20020a170902ebc400b001c41392e4b5mr5130plg.21.1697738729250; Thu, 19 Oct
 2023 11:05:29 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-9-rananta@google.com>
 <5d35c9f3-455e-6aa9-fd6a-4433cf70803a@redhat.com> <CAJHc60z7U1-irTy-6URb_V0PTW+TYS4qodf2akSg33_7CJgjyw@mail.gmail.com>
 <f7cd9b3d-c817-7082-d60a-a529e1c82f1e@redhat.com>
In-Reply-To: <f7cd9b3d-c817-7082-d60a-a529e1c82f1e@redhat.com>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Thu, 19 Oct 2023 11:05:17 -0700
Message-ID: <CAJHc60xJs+NzjfG_ESvQuyYdV0bDSwAetuam7yO35FOZBBJ9fQ@mail.gmail.com>
Subject: Re: [PATCH v7 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To:     Sebastian Ott <sebott@redhat.com>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 19, 2023 at 3:45=E2=80=AFAM Sebastian Ott <sebott@redhat.com> w=
rote:
>
> On Tue, 17 Oct 2023, Raghavendra Rao Ananta wrote:
> > On Tue, Oct 17, 2023 at 8:52=E2=80=AFAM Sebastian Ott <sebott@redhat.co=
m> wrote:
> >>
> >> On Mon, 9 Oct 2023, Raghavendra Rao Ananta wrote:
> >>> +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc=
 *r,
> >>> +                 u64 val)
> >>> +{
> >>> +     struct kvm *kvm =3D vcpu->kvm;
> >>> +     u64 new_n, mutable_mask;
> >>> +
> >>> +     mutex_lock(&kvm->arch.config_lock);
> >>> +
> >>> +     /*
> >>> +      * Make PMCR immutable once the VM has started running, but do
> >>> +      * not return an error (-EBUSY) to meet the existing expectatio=
ns.
> >>> +      */
> >>
> >> Why should we mention which error we're _not_ returning?
> >>
> > Oh, it's not to break the existing userspace expectations. Before this
> > series, any 'write' from userspace was possible. Returning -EBUSY all
> > of a sudden might tamper with this expectation.
>
> Yes I get that part. What I've meant is why specifically mention -EBUSY?
> You're also not returning -EFAULT nor -EINVAL.
>
> /*
>   * Make PMCR immutable once the VM has started running, but do
>   * not return an error to meet the existing expectations.
>   */
> IMHO provides the same info to the reader and is less confusing
>
Sounds good. I'll apply this.

Thank you.
Raghavendra
> Sebastian
