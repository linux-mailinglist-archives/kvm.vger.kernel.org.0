Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78343785A87
	for <lists+kvm@lfdr.de>; Wed, 23 Aug 2023 16:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236438AbjHWOb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Aug 2023 10:31:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236431AbjHWOb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Aug 2023 10:31:58 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95CB0E66
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 07:31:56 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-26b10a6da80so6047546a91.3
        for <kvm@vger.kernel.org>; Wed, 23 Aug 2023 07:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692801116; x=1693405916;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p+7iLveG+eJzHBFrfOKuJ5YG6FqnmCVegyIJkjx3CJs=;
        b=LzhZHLtB03/JJ1EFMYkoId7U63M6kz0rkZQdYP+DWvlThHHu5yYTmURkn+QTm93znp
         aDmlh3jz/Z9a3dG9h7rQfpUWUDhMW/Me62S5jR/KVyHvk9sLCeI97HayzwHA4gHzgQDN
         JKLH4SdNd2wo4dgiAf+TF2u4WIhjZ/xcMIbsPoRk5L3INLBE4eZt8mtQR3+ePM3qrgva
         aMFnwJawtJQ7LQACF6LIeqPzftsTWoWcoVwiChA/qjkVeMf98TKJ9urswuYEhAVFejO/
         FTdXmJezgzkc7mtO6slkhV1UEvepS6MvxgKg+fzpNbIwgfE0FUeh2Cjg1PbppcsOcBQ7
         irnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692801116; x=1693405916;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p+7iLveG+eJzHBFrfOKuJ5YG6FqnmCVegyIJkjx3CJs=;
        b=bbo7gRYnsg30TZyLt3U22NFJD4PuK4mJJFRvfQtpn7iLqgqMNQDmvk9aQqhB/Jrz0E
         gHqWHg6hDAcB/pCzMYS8f9qFMoaRfyFDXy39y6XRqWUdb5ieMQ4DnnRQcBtYecoVGRRG
         jSH2M3WA+cJzUHHFHqXGXPKLzHT5JHhjTCWRqOJYZYozV3twm2YN5JrfI+kPjTlCQm4Y
         3iuoFfHt2qmlo91IkoRmxwPMURZtetiTV8B4efEa7hWFdbSG89J2RizFh2t3baqVWtjp
         bOgbcG8UShlzSZ3oCV1sxo92VOCQluknhGsUEzwCFzxCIwNZCzyLyAYmh90LIIlqyCdG
         l5Wg==
X-Gm-Message-State: AOJu0YwYMq3HR+juSXRxF7kePZM5RlMx1N9/dfwo7TTDpGFiXB6xLU4l
        diGlpCekcdDtDWgFYbiK+7ZI2bYEbvk=
X-Google-Smtp-Source: AGHT+IGtI7MXslrycISJQNQJ0AoAcyzbEKDIHnO0byuO9FAEJ+E63W5Ojv9JmpsztfJ4GL1dF8FIqVWO81w=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:30cb:b0:268:1be1:b835 with SMTP id
 hi11-20020a17090b30cb00b002681be1b835mr2918260pjb.2.1692801116013; Wed, 23
 Aug 2023 07:31:56 -0700 (PDT)
Date:   Wed, 23 Aug 2023 14:31:54 +0000
In-Reply-To: <498ee0c4-4736-68a7-7cbf-12e54f6a0d22@intel.com>
Mime-Version: 1.0
References: <1692588392-58155-1-git-send-email-hao.xiang@linux.alibaba.com>
 <ZOMWM+YmScUG3U5W@chao-email> <6d10dcf7-7912-25a2-8d8e-ef7d71a4ce83@linux.alibaba.com>
 <ZOM/8IVsRf3esyQ1@chao-email> <33f0e9bb-da79-6f32-f1c3-816eb37daea6@linux.alibaba.com>
 <ZOOMwvPd/Cz/cEmv@google.com> <498ee0c4-4736-68a7-7cbf-12e54f6a0d22@intel.com>
Message-ID: <ZOYYFPrQSPUjS7kk@google.com>
Subject: Re: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Hao Xiang <hao.xiang@linux.alibaba.com>,
        Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        shannon.zhao@linux.alibaba.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 23, 2023, Xiaoyao Li wrote:
> On 8/22/2023 12:11 AM, Sean Christopherson wrote:
> > > Set these msr bits (needed by turbostat on intel platform) in KVM by
> > > default.  Of cource, QEMU can also set MSR value by need. It does not
> > > conflict.
> >=20
> > It doesn't conflict per se, but it's still problematic.  By stuffing a =
default
> > value, KVM _forces_ userspace to override the MSR to align with the top=
ology and
> > CPUID defined by userspace.
>=20
> I don't understand how this MSR is related to topology and CPUID?

Heh, looked at the SDM to double check myself, and the first hit when searc=
hing
for MSR_PLATFORM_INFO says:

  When TSC scaling is enabled for a guest using Intel PT, the VMM should en=
sure
  that the value of Maximum Non-Turbo Ratio[15:8] in MSR_PLATFORM_INFO (MSR=
 0CEH)
  and the TSC/=E2=80=9Dcore crystal clock=E2=80=9D ratio (EBX/EAX) in CPUID=
 leaf 15H are set in
  a manner consistent with the resulting TSC rate that will be visible to t=
he VM.

As Chao pointed out, the MSR is technically per package, so a weird setup c=
ould
have sockets with different frequencies, or enumerate a virtual topology to=
 the
guest with such a configuration.  I doubt/hope no one actually does somethi=
ng
like that, but it's theoretically possible, and one of the many reasons why=
 KVM
needs to stay out of the way and let userspace define the vCPU model.

> > And if userspace uses KVM's "default" CPUID, or lack thereof, using the
> > underlying values from hardware are all but guaranteed to be wrong.
>=20
> Could you please elaborate?

I guess an empty CPUID would probably be ok?  If there's no CPUID.0x15, it =
can't
be wrong.  It's largely a moot point though, I highly doubt anyone runs a "=
real"
VM without populating _something_ in guest CPUID.
