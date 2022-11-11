Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA4C0625E00
	for <lists+kvm@lfdr.de>; Fri, 11 Nov 2022 16:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234368AbiKKPOk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Nov 2022 10:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234949AbiKKPOM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Nov 2022 10:14:12 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3752787B8
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 07:12:19 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-3775545dc24so46556467b3.7
        for <kvm@vger.kernel.org>; Fri, 11 Nov 2022 07:12:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mRwD4q1oXYsS4gdSliEkfcIBmvSTpaDci200wLy4Z4k=;
        b=bQ/5hEGbLYOnrAyjfgUGSIYyDxjnvrlQUtR5gXpnHEEZDfJKjLJ+dOsTLH/LBJDeoV
         IL06n9OgQ+FFqz1pCF6LhqqF+gqo3WugXf/P0lthXVHIRPrlo0mHHfMJqhYZgPQoHrRy
         ONLMZZ0QNntH2mo8pg45a2C8L2Zp5pnqYD4fmSJpOzYQCofmh4ybsKUmU3XmAmhcQshG
         t0v0GvqYQhdPLMc+rNzbimn2RNIMIUSaweM9VmIP/NAJRNrdr5gAD58P7hzaVZJfR/Ks
         WxP0l2Xjj4C5AymI8YUxKahwzlYzJKYiXoVyhFrFBF6ZISgBpwxANx3wprhN6ogXUN4j
         oLjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mRwD4q1oXYsS4gdSliEkfcIBmvSTpaDci200wLy4Z4k=;
        b=28BWjHJLoyPhALpKkZ1ZY69l47w14vgw+FMkuYNF/E8P15isNEIPDoWQFcoAJzMfim
         IRuYd1UwBB3UP/Vz8ia7i98Oc6VvW46+KD5AvHJTzq6WK7VFvT82yKAqgvu/rj65V6gl
         A4eDO06Ydy4rMUrBxY/tlHHIfKlp0AjZ2QqpygCgSfGr12hEsR4xlkUK+2HESvsI4M6n
         VRzYUbZ6Z7JZK428nJ+4FWDHpvbuCFKfbSlNzBqRe7lM6ctEZM4Zvqq1Tq1T1HzUZFbE
         JF9syYndS1lObnkvTf56RAdRjTGNuDJ7ldkryDsA7bwPgkriKlhidruQxLDVXNGtCFqn
         pAuQ==
X-Gm-Message-State: ANoB5pnVQExzrPq1j5GM1ifq4y4CwWUwZ6Aj2nvojlG5hGmAoHxfN1V3
        A5RiP8agti9MSYa0GdeHtyxfpfYqYyZgkAMb0sn8ZQ==
X-Google-Smtp-Source: AA0mqf4D3VEMEpied9d1LqE9AKSEtbRZju0zw2Rp0ZDogoffXUYvG+XGJfuYyAWagG+Dk8PsVhRhhHiMSUZ8UDIHhEc=
X-Received: by 2002:a0d:ed06:0:b0:368:b923:b500 with SMTP id
 w6-20020a0ded06000000b00368b923b500mr2286799ywe.10.1668179538779; Fri, 11 Nov
 2022 07:12:18 -0800 (PST)
MIME-Version: 1.0
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 11 Nov 2022 16:11:42 +0100
Message-ID: <CAG_fn=W0vXvFrQdRhZiCriz7JjM+zLzKQY+z36j+UqPYnsmq_Q@mail.gmail.com>
Subject: Making KMSAN compatible with paravirtualization
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Juergen Gross <jgross@suse.com>, srivatsa@csail.mit.edu
Cc:     Peter Zijlstra <peterz@infradead.org>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

While investigating KMSAN's incompatibilities with the default Ubuntu
config (https://github.com/google/kmsan/issues/89#issuecomment-1310702949),
I figured out that a kernel won't boot with both CONFIG_KMSAN=3Dy and
CONFIG_XEN_PV=3Dy.

In particular, it may crash in load_percpu_segment():

        __loadsegment_simple(gs, 0);
        wrmsrl(MSR_GS_BASE, cpu_kernelmode_gs_base(cpu));

Here the value of %gs between __loadsegment_simple() and wrmsrl() is
zero, so when KMSAN's __msan_get_context_state() instrumentation
function is called before the actual WRMSR instruction is performed,
it will attempt to access percpu data and crash.

Unless instructed otherwise (by noinstr or __no_sanitize_memory on the
source level, or by KMSAN_SANITIZE :=3D n on the Makefile level), KMSAN
inserts instrumentation at function prologue for every non-inlined
function, including native_write_msr().

Marking native_write_msr() noinstr actually makes the kernel boot for
me, but I am not sure if this is enough. In fact we'll need to fix
every situation in which instrumentation code may be called with
invalid %gs value. Do you think this is feasible? Overall, should we
care about KMSAN working with paravirtualization?

Thank you,
--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
