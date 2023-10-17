Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D57787CC9D7
	for <lists+kvm@lfdr.de>; Tue, 17 Oct 2023 19:26:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234752AbjJQR0G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 13:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjJQR0F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 13:26:05 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C0B4A4
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 10:26:04 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1c9b70b9671so8415ad.1
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 10:26:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697563563; x=1698168363; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b98W+/GnlYMBBaEIRZ/yrKu+yROp6z3ItYJheiFNfWY=;
        b=IcWaZ8Ml2sZHN2wMskXKVM0XboPKGtGNZV7nlTe2aTVAET9PeNJjDE7SrhtEGqaXvm
         eiWLw7pnM/2cpziBS/u/J/Eg4LIR1k9vD1EPhz3EzQC0rlkkCIpjEByHTpY1VVU7n+QR
         8IOeQCluFNpf7gdPgSCJAC0JB3o94DprII7OTZ8h6LCt8sM85wkWV7VgXsw3JThye543
         USCCubBT6AiDZ2jB8XwJsTzgwJUZGQv1UgCJwLDFmIFc3J9Y6mShx5ZjwKh1T3dyuyQO
         WyfOi8wDVczgcVEaeyUdiVClkVEn9WeGiXHrUr2sCpdYaU6che/bHCejXrVTPWv8wUmf
         QYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697563563; x=1698168363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b98W+/GnlYMBBaEIRZ/yrKu+yROp6z3ItYJheiFNfWY=;
        b=Yj2WfhFMFu+CRy/WoAp4hmrYFyvLjjBI51srW/l1azw5WtPsywHMQdy4C/onl9J6un
         MGYz3YnCdrDi0LFetlaStNEmsHj5s4z11X7Wi7QmeqXLUIe7UfEgzVYYkHTj95LvcZBe
         OJiwIp2vKXpBdsH1mxvov/Sto8M8s1PzazJDhGnTrlyQ9DHdz0nmUcFVWtpjCc/rQXJm
         vVMd/TDs/Dj4me6U8w0wsPFKXuDivW9oJ9duQVFH4Wr73C/BAscwHudQAzZ/Ccrlx70P
         T1NztmZjPHSqx/ubMNnAcySpukwD1iiW0e2HHg2qGC9pzsmIRqk7cG3ei2eSG/hbb5mV
         1qWw==
X-Gm-Message-State: AOJu0YyrU9GlfGIuJkC72GwQGIDl3OuZHYRln5VifYzwRG/KXX0eGWPT
        VQEjeuO8ZzXJnwFA8NyTVlo0N/mjCq8GE7CDnzsTMw==
X-Google-Smtp-Source: AGHT+IHb5B0YZuQ8upjbjeL9ha316DU4/zeX9v9YItDefLh84Iu+cQVZ7EJdEAX5vIIp6CqyfVqxyGhsl1ayop2hEX8=
X-Received: by 2002:a17:902:f611:b0:1b8:b564:b528 with SMTP id
 n17-20020a170902f61100b001b8b564b528mr8101plg.7.1697563563148; Tue, 17 Oct
 2023 10:26:03 -0700 (PDT)
MIME-Version: 1.0
References: <20231009230858.3444834-1-rananta@google.com> <20231009230858.3444834-8-rananta@google.com>
 <b4739328-5dba-a3a6-54ef-2db2d34201d8@redhat.com> <CAJHc60zpH8Y8h72=jUbshGoqye20FaHRcsb+TFDxkk7rhJAUxQ@mail.gmail.com>
 <ZS2L6uIlUtkltyrF@linux.dev> <CAJHc60wvMSHuLuRsZJOn7+r7LxZ661xEkDfqxGHed5Y+95Fxeg@mail.gmail.com>
 <ZS4hGL5RIIuI1KOC@linux.dev> <CAJHc60zQb0akx2Opbh3_Q8JShBC_9NFNvtAE+bPNi9QqXUGncA@mail.gmail.com>
 <ZS6_tdkS6GyNlt4l@linux.dev>
In-Reply-To: <ZS6_tdkS6GyNlt4l@linux.dev>
From:   Raghavendra Rao Ananta <rananta@google.com>
Date:   Tue, 17 Oct 2023 10:25:50 -0700
Message-ID: <CAJHc60w-CsqdYX8JG-CRutwg0UyWmvk1TyoR-y9JBV_mqWUVKw@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] KVM: arm64: PMU: Set PMCR_EL0.N for vCPU based
 on the associated PMU
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Sebastian Ott <sebott@redhat.com>, Marc Zyngier <maz@kernel.org>,
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17, 2023 at 10:09=E2=80=AFAM Oliver Upton <oliver.upton@linux.d=
ev> wrote:
>
> On Tue, Oct 17, 2023 at 09:58:08AM -0700, Raghavendra Rao Ananta wrote:
> > On Mon, Oct 16, 2023 at 10:52=E2=80=AFPM Oliver Upton <oliver.upton@lin=
ux.dev> wrote:
> > >
> > > On Mon, Oct 16, 2023 at 02:35:52PM -0700, Raghavendra Rao Ananta wrot=
e:
> > >
> > > [...]
> > >
> > > > > What's the point of doing this in the first place? The implementa=
tion of
> > > > > kvm_vcpu_read_pmcr() is populating PMCR_EL0.N using the VM-scoped=
 value.
> > > > >
> > > > I guess originally the change replaced read_sysreg(pmcr_el0) with
> > > > kvm_vcpu_read_pmcr(vcpu) to maintain consistency with others.
> > > > But if you and Sebastian feel that it's an overkill and directly
> > > > getting the value via vcpu->kvm->arch.pmcr_n is more readable, I'm
> > > > happy to make the change.
> > >
> > > No, I'd rather you delete the line where PMCR_EL0.N altogether.
> > > reset_pmcr() tries to initialize the field, but your
> > > kvm_vcpu_read_pmcr() winds up replacing it with pmcr_n.
> > >
> > I didn't get this comment. We still do initialize pmcr, but using the
> > pmcr.n read via kvm_vcpu_read_pmcr() instead of the actual system
> > register.
>
> You have two bits of code trying to do the exact same thing:
>
>  1) reset_pmcr() initializes __vcpu_sys_reg(vcpu, PMCR_EL0) with the N
>     field set up.
>
>  2) kvm_vcpu_read_pmcr() takes whatever is in __vcpu_sys_reg(vcpu, PMCR_E=
L0),
>     *masks out* the N field and re-initializes it with vcpu->kvm->arch.pm=
cr_n
>
> Why do you need (1) if you do (2)?
>
Okay, I see what you mean now. In that case, let reset_pmcr():
- Initialize 'pmcr' using  vcpu->kvm->arch.pmcr_n
- Set ARMV8_PMU_PMCR_LC as appropriate in 'pmcr'
- Write 'pmcr' to the vcpu reg

From here on out, kvm_vcpu_read_pmcr() would read off of this
initialized value, unless of course, userspace updates the pmcr.n.
Is this the flow that you were suggesting?

Thank you.
Raghavendra

> --
> Thanks,
> Oliver
