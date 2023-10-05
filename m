Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7BFA7BAEF2
	for <lists+kvm@lfdr.de>; Fri,  6 Oct 2023 00:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbjJEWqc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 18:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjJEWqb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 18:46:31 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D440EDB
        for <kvm@vger.kernel.org>; Thu,  5 Oct 2023 15:46:29 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-279353904a9so1368992a91.3
        for <kvm@vger.kernel.org>; Thu, 05 Oct 2023 15:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696545989; x=1697150789; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BFNKMdFnPveldc0HQ7aZGfenM2ZrJbvkhgfmrxqt94M=;
        b=b2ZAAo2RLBA8EGZPw55N+wyoEcba8G77IVJ8ZBcyQp2Dmi36Sn8Py4VOOv/A/7DA8B
         X4ZrjM15SD3XxzmLK4uTG9GIdFZWKGk0W2mKzCFxX+GyIJn1sastwlYLv6AJa9AwdlCh
         +t7uFiqtdMObMKKyShosdrvJESkXJBlxV5OUTyVtRbCHGPjPwtciJpxgqLILT4ms5hhm
         kCUXSEOnrq425/BV/1K4ftRZ/L9CycF7lKGYDceB0+JaNHJpy3I1LJG3GqfPoX55ilJE
         WibKy2ybISvuBuw4xrbycnIXVQnr9LCBc/E8+l5DsjgDZsfq+e1jGOOZJe7wm00Rnk/M
         9i5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696545989; x=1697150789;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BFNKMdFnPveldc0HQ7aZGfenM2ZrJbvkhgfmrxqt94M=;
        b=bpsMinBOJmCEAsKP/baRJwzdQzEhpRqzCOe1wsZbvd/h02sY0cnjtLP+nej4VuA13t
         xSWHOsPaWYJRU/K5uzeAg92lyEz+6ePEsg2oHuPQ895c7m5eYO7+0faewoiY5VmjMw/n
         3o4baUUDdzl8gMQ4T712mB558Jp2/GX0kq91xXyGDGohiL8T/o1pz4WES028BfrBZhJF
         klJkTn/XsCJgWXlsT9lPohkGOXaDvnSKg93kFxZyWSrzGWQM0aO+i+iT9TOzT7hNqCqw
         /QAjIOWR9MaWScJp5yjfCzopc7kEgPKWPnFaNg5SV2fV+ISsjwmB3hmc3JbXypesBF7N
         a4nQ==
X-Gm-Message-State: AOJu0YzL13U9dlGzu7Up0ZkQAono5kg4cqey+I3+E2CeqNO1v1MxYCVS
        gkeTY+Tjr8XQjAnS+5jq1gIvvMeQUWM=
X-Google-Smtp-Source: AGHT+IEtahwBg2Zwge0uEd3Ui7DNj7uWo5yXZrXRWofh6Qbm+2xT8gySHKj0YTx2KOHMFuyEUr32wAYCdkY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:e06:b0:279:9aa1:402c with SMTP id
 ge6-20020a17090b0e0600b002799aa1402cmr104744pjb.7.1696545989346; Thu, 05 Oct
 2023 15:46:29 -0700 (PDT)
Date:   Thu, 5 Oct 2023 15:46:27 -0700
In-Reply-To: <CAF7b7mqYr0J-J2oaU=c-dzLys-m6Ttp7ZOb3Em7n1wUj3rhh+A@mail.gmail.com>
Mime-Version: 1.0
References: <20230914015531.1419405-1-seanjc@google.com> <20230914015531.1419405-8-seanjc@google.com>
 <117db856-9aec-e91c-b1d4-db2b90ae563d@intel.com> <ZQ3AmLO2SYv3DszH@google.com>
 <CAF7b7mrf-y9DNdsreOAedGJueOThnYE=ascFd4=rvW0Z4rhTQg@mail.gmail.com>
 <ZRtxoaJdVF1C2Mvy@google.com> <CAF7b7mqyU059YpBBVYjTMNXf9VHSc6tbKrQ8avFXYtP6LWMh8Q@mail.gmail.com>
 <ZRyn0nPQpbVpz8ah@google.com> <CAF7b7mqYr0J-J2oaU=c-dzLys-m6Ttp7ZOb3Em7n1wUj3rhh+A@mail.gmail.com>
Message-ID: <ZR88w9W62qsZDro-@google.com>
Subject: Re: [RFC PATCH v12 07/33] KVM: Add KVM_EXIT_MEMORY_FAULT exit to
 report faults to userspace
From:   Sean Christopherson <seanjc@google.com>
To:     Anish Moorthy <amoorthy@google.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, kvm-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Fuad Tabba <tabba@google.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Xu Yilun <yilun.xu@intel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Maciej Szmigiero <mail@maciej.szmigiero.name>,
        David Hildenbrand <david@redhat.com>,
        Quentin Perret <qperret@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Wang <wei.w.wang@intel.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 05, 2023, Anish Moorthy wrote:
> On Tue, Oct 3, 2023 at 4:46=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> >
> > The only way a KVM_EXIT_MEMORY_FAULT that actually reaches userspace co=
uld be
> > "unreliable" is if something other than a memory_fault exit clobbered t=
he union,
> > but didn't signal its KVM_EXIT_* reason.  And that would be an egregiou=
s bug that
> > isn't unique to KVM_EXIT_MEMORY_FAULT, i.e. the same data corruption wo=
uld affect
> > each and every other KVM_EXIT_* reason.
>=20
> Keep in mind the case where an "unreliable" annotation sets up a
> KVM_EXIT_MEMORY_FAULT, KVM_RUN ends up continuing, then something
> unrelated comes up and causes KVM_RUN to EFAULT. Although this at
> least is a case of "outdated" information rather than blatant
> corruption.

Drat, I managed to forget about that.

> IIRC the last time this came up we said that there's minimal harm in
> userspace acting on the outdated info, but it seems like another good
> argument for just restricting the annotations to paths we know are
> reliable. What if the second EFAULT above is fatal (as I understand
> all are today) and sets up subsequent KVM_RUNs to crash and burn
> somehow? Seems like that'd be a safety issue.

For your series, let's omit=20

  KVM: Annotate -EFAULTs from kvm_vcpu_read/write_guest_page

and just fill memory_fault for the page fault paths.  That will be easier t=
o
document too since we can simply say that if the exit reason is KVM_EXIT_ME=
MORY_FAULT,
then run->memory_fault is valid and fresh.

Adding a flag or whatever to mark the data as trustworthy would be the alte=
rnative,
but that's effectively adding ABI that says "KVM is buggy, sorry".

My dream of having KVM always return useful information for -EFAULT will ha=
ve to
wait for another day.
