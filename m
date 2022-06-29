Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62850560C45
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 00:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbiF2W1q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Jun 2022 18:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbiF2W1p (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Jun 2022 18:27:45 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E5FA377C0
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 15:27:44 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id i126so3118683oih.4
        for <kvm@vger.kernel.org>; Wed, 29 Jun 2022 15:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ng/t2d/qzqjg5f87HKrQVLd4Y/9sxNRY/C0EI7Ml8dE=;
        b=kSMy4+POZIfLq5+w6YmxCyMWnCS8C3Mt4MMhjMqXwrv6YoCSvS9D9M6EsnnlTHCwXg
         WpsB41G0aP+1mpcUBlsDVrbw0fMWz+Vtv8sCHqkTZ3nUw6/Tb5t4Gi5e1gW78IZ4Srnx
         ij6ANEQxs4JzTjmGk4DxHQT9H0Rvj6s2Mqdko6vWujTIAKTQdPRLzMzZ0e5nzWbUh7WR
         0U6TOmvZn+NjpRywnZJDvXZFho+7h2SMTxdAaOQSr1Z9ks/zHrjiL2Q4Ay9eSWaNP70X
         aUxCx9k7jjB64wr8LruCIUlU+dtv2EzVtu/C6stflSzpyD109LwXnG/PUKFkv0TqFD+R
         hPrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ng/t2d/qzqjg5f87HKrQVLd4Y/9sxNRY/C0EI7Ml8dE=;
        b=1g/qArZOdxStK+/5gZmeytBTjzcM6CkAWtMToZO0m7IU02b84qu0dgmN24t9oRv3Eu
         ibeZpR/RVYy1rbcMTfapOgLbkh9y4MzIkkdCr0SPuJPk1nhdnn8XjgVoYvtjDUMh37Dq
         p4iufTWrtUa13opuE1s5nWGAly6D4BgLJe1AhNhtj8e9IWdt7puPbHRKoSUk2PCbCEou
         Vmcv88sNi1Hv+q+lkXlF/0waipbw/9CmzF5gdEJDfRNCRataBkDUKavXzt3XQ2t/R1xU
         ta2jHU8W/c+aNX61coyxjLZoMxvdn5dO4p2BOzj0vlMFN7lIgk/UCSMeVbTQonfk8Y7e
         uorA==
X-Gm-Message-State: AJIora8Vyzxu8Y0kVxWiyDeb7Y5L+XcQ7kjjKOuuPydOVViUvD24BUQ5
        2oRa5UdTDcBPwUUOMRPxfTQSvru+GJV9NDqCkkoa3A==
X-Google-Smtp-Source: AGRyM1sl8Uu5Y6pb7Dl4WPAxpFaszRjgSF59h8aOJ+5i3RM3dFYPgMIvv9fll/+t/oLDS23mv6D/L9U8smAMfkgSZ8Q=
X-Received: by 2002:a05:6808:2124:b0:335:7483:f62d with SMTP id
 r36-20020a056808212400b003357483f62dmr4581673oiw.112.1656541663655; Wed, 29
 Jun 2022 15:27:43 -0700 (PDT)
MIME-Version: 1.0
References: <20220627160440.31857-1-vkuznets@redhat.com> <CALMp9eQL2a+mStk-cLwVX6NVqwAso2UYxAO7UD=Xi2TSGwUM2A@mail.gmail.com>
 <87y1xgubot.fsf@redhat.com> <CALMp9eSBLcvuNDquvSfUnaF3S3f4ZkzqDRSsz-v93ZeX=xnssg@mail.gmail.com>
 <87letgu68x.fsf@redhat.com> <CALMp9eQ35g8GpwObYBJRxjuxZAC8P_HNMMaC0v0uZeC+pMeW_Q@mail.gmail.com>
 <87czeru9cp.fsf@redhat.com>
In-Reply-To: <87czeru9cp.fsf@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 29 Jun 2022 15:27:32 -0700
Message-ID: <CALMp9eQ5Sqv3RP8kipSbpfnvef_Sc1xr1+g53fwr0a=bhzgAhg@mail.gmail.com>
Subject: Re: [PATCH 00/14] KVM: nVMX: Use vmcs_config for setting up nested
 VMX MSRs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Jun 29, 2022 at 2:06 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> For PERF_GLOBAL_CTRL errata:
> - We can move the filtering to vmx_vmexit_ctrl()/vmx_vmentry_ctrl()
> preserving the status quo: KVM doesn't use the feature but it is exposed
> to L1 hypervisor (and L1 hypervisor presumably has the same check and
> doesn't use the feature. FWIW, the workaround was added in 2011 and the
> erratas it references appeared in 2010, this means that the affected
> CPUs are quite old, modern proprietary hypervisors won't likely boot
> there).
Sadly, Nehalem and Westmere are well-supported by KVM today, and we
will probably still continue to support them for at least another
decade. They both have EPT, unrestricted guest, and other VT-x2
features that KVM still considers optional.
