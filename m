Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A51DD7D59CD
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 19:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343686AbjJXRdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 13:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231469AbjJXRdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 13:33:16 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E8C1B3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 10:33:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5a7a6fd18abso60499337b3.1
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 10:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698168793; x=1698773593; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gqZurBUg9EMJiDsOKjz68gzG8KRiFUNX+GCM2ruP+q4=;
        b=iwB2DCV/XnbkMvcFSS1J1Z9v0QXdzEHQzh9rSavY2me6pD9rtdGnPHxNEwLgLgdcYD
         dBgzNQTgkgqWtOwNLDQmQMpAYCjnJWG9GrmXWWMqlaylClK38A1uPqTcmXq/Atfa+MaV
         z57aCoicbP21CajORgi8rZSvXW2yD8RpMEM0hp8YhxWG0MvT7788TM9mzOD3IJQhNVn3
         EWQRjz3T1om36YNzM8nAw+GsF+/VNeDOAoELpJ4oxSb7yaOTBaL+zcd9o66Z2tcbL4Oq
         W4+Vwwv+RgUBC7eT3E4ynZhXtu2XccOy/0CfQtQvh7Ak7G/vpi9Z+3zgt3htxlZEeftF
         J71Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698168793; x=1698773593;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gqZurBUg9EMJiDsOKjz68gzG8KRiFUNX+GCM2ruP+q4=;
        b=R5KsrZ+KRSXXB3dS1EHNbUu3pgMX92/8sqJWa8hCdIMeSvJElD6kS3iEXdxiSpffc6
         CS/7715cf8QRYxJHohc7Yum38YQ1Mc3NEBtTcAu//GtXaOWO7p17/Qq2mERksVLls52o
         f7ZBxAk+1FkMOcVtxNpptb9+MHKRyONNJHo1I5u62j11gwQ2ooRVac73YXFhnUfIwLSU
         SpHdw3z9Svk6Ii1xcs/eknSpOaLfDgUk8wXqVtrBJ1OeL6xVEnBb/fEvjHjAHGnayQQR
         lSuiVqDzp5YUS0SDHE+8/GZ3ZHcM1VLYypnJbgzEB8014YZYpvMWflsKD0yhXgjW84iC
         f/Sg==
X-Gm-Message-State: AOJu0YziI3+zVuqGvW/7xL8k/z+N04M4sGZH9jG1CgDe0u4CqlL7ZijU
        7dGZR05RCiPnTughHInxHp8z5pxJWbQ=
X-Google-Smtp-Source: AGHT+IGIZMbUPEoeUN735t07o23rVpBG90ofqm5qT0pHm3dexdz6I6B08mArlSlqVD2VuYhGEzh1B0SUyyQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d34e:0:b0:d9a:e3d9:99bd with SMTP id
 e75-20020a25d34e000000b00d9ae3d999bdmr224545ybf.5.1698168793645; Tue, 24 Oct
 2023 10:33:13 -0700 (PDT)
Date:   Tue, 24 Oct 2023 10:33:12 -0700
In-Reply-To: <594A322A-8100-429A-A3E8-64362E3ED5A2@clockwork.io>
Mime-Version: 1.0
References: <594A322A-8100-429A-A3E8-64362E3ED5A2@clockwork.io>
Message-ID: <ZTf_2MN3uyHFtWqa@google.com>
Subject: Re: Questions about TSC virtualization in KVM
From:   Sean Christopherson <seanjc@google.com>
To:     Yifei Ma <yifei@clockwork.io>
Cc:     kvm@vger.kernel.org
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

On Tue, Oct 24, 2023, Yifei Ma wrote:
> Hi KVM community,
>=20
>    I am trying to figure out how TSC is virtualized in KVM-VMX world.
>    According to the kernel documentation, reading TSC register through MS=
R
>    can be trapped into KVM and VMX. I am trying to figure out the KVM cod=
e
>    handing this trap.

Key word "can".  KVM chooses not to intercept RDMSR to MSR_IA32_TSC because
hardware handles the necessary offset and scaling.  KVM does still emulate =
reads
in kvm_get_msr_common(), e.g. if KVM is forced to emulate a RDMSR, but that=
's a
very, very uncommon path.

Ditto for the RDTSC instruction, which isn't subject to MSR intercpetion bi=
tmaps
and has a dedicated control.  KVM will emulate RDTSC if KVM is already emul=
ating,
but otherwise the guest can execute RDTSC without triggering a VM-Exit.

Modern CPUs provide both a offset and a scaling factor for VMX guests, i.e.=
 the
CPU itself virtualizes guest TSC.  See the RDMSR and RDTSC bullet points in=
 the
"CHANGES TO INSTRUCTION BEHAVIOR IN VMX NON-ROOT OPERATION" section of the =
SDM
for details.

>    In order to understand it, I have run a kernel traced by GDB, and adde=
d
>    break points to the code I thought they may handle the MSR trap, e.g.,
>    kvm_get_msr, vmx_exec_control, etc. Then ran rdtsc from guest applicat=
ion,
>    however, it  didn=E2=80=99t trigger these breakpoints. I am a little l=
ost in how
>    TSC is virtualized.
>
>    Two questions:
>    - does the TSC MRS instructions are emulated and trapped into KVM?

Nope, see above.

>    - if TSC is trapped, which code handles it?

Also see above :-)

> Any background about TSC virtualization and suggestions on tracing its
> virtualization are appreciated.
