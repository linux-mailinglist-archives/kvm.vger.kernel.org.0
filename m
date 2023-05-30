Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381F4716A24
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 18:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbjE3Q4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 12:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjE3Q4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 12:56:35 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A806DA7
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:56:33 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-33b7f217dd0so5455ab.0
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 09:56:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685465793; x=1688057793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F4saRnoXm29F46lt8r9s8eZWy2RiZg/7MPw1IC2AIu4=;
        b=vmD2nxEkM5VZgF0z4VKdntqKmWYMwOU/7ppjyUarV+pDN5m1KUWmAA+uKRh+Zg0BYv
         Phd68Abs+auvFE4D8cdwFkOj/lkGcojoA1yozZ2pdpFJ3r9q+b2hoZ73NrcLRtfcfAUJ
         aZd0y6h04tN7Kk1TALhDnvfe6ojLCzj+HvQCzG9CwbLPTv+H6C+qpeWmtfNHdP856pPN
         NUd7ShdFnBsNOWaGUKUqmhz5O2mwm5xPj6ivlawSJd1NkrV7f4QpcugMSpXJ4hgdItaA
         Qxub9Q4YXcFzUEoup0M4y9QrIr/LqnXsbLfjx8V7nw3nLVHSgtWWJxya5hyubyRpDrwB
         SjpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685465793; x=1688057793;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F4saRnoXm29F46lt8r9s8eZWy2RiZg/7MPw1IC2AIu4=;
        b=L7rpgQZ/FleISoqPJ80+zw0ZBLYnRz9anhSeTXw9sztTqbsGQr8OMexy8uqviK9cqL
         zABml/1UVDorHaJUnTGRq4/6nQaM104FnSsytkDiKX/EPvhl3a145/MnR0NgQtEavaFq
         +qapr8HG6ryAwdqTZe8RK72zCNEjw54BEXkXV/BPCid2a4j6sFkcJRK4vGUwENxEgaU+
         9GNb7k8uaLocJxeKTj/c+UMlHF2z6+hdLZVX8/kVTa06P2CIyu/XuiG/xFMRLzOVUp1o
         PTloaxogchK4GhmBZ6dRcTr59PDFHwtS9g1xZoqT6IvYqNgXiyxYumqYvOLZ5HFMRRhV
         /vmA==
X-Gm-Message-State: AC+VfDzSzgYhR0k8tzQ1VHWuKIMHdCrh6uSEAAaK3PwisL97lfsbOrE0
        dPavbZHReNzNlzlkwugy6/0yj2ba+s9NGeUgF0iMfg==
X-Google-Smtp-Source: ACHHUZ5y/iD2FePf4vPxl8EfHEhPUNPWYGHIIZTuc+5SlHhXurVNAz3+YkQrWL+XnqbVk1QkZSl+CD+AzvvaUTDwcXg=
X-Received: by 2002:a05:6e02:1bc1:b0:337:c28c:3d0f with SMTP id
 x1-20020a056e021bc100b00337c28c3d0fmr187437ilv.6.1685465792930; Tue, 30 May
 2023 09:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230523194949.96149-1-twiederh@redhat.com> <20230530102358.16430-1-twiederh@redhat.com>
In-Reply-To: <20230530102358.16430-1-twiederh@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 30 May 2023 09:56:21 -0700
Message-ID: <CALMp9eSsx0WLd0RdkpXnDkyKGM2CZxSwgtfmFtH2hxYprfvhAA@mail.gmail.com>
Subject: Re: [PATCH v2] x86/msr: Allow unprivileged read access to some MSRs
To:     Tim Wiederhake <twiederh@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
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

On Tue, May 30, 2023 at 3:28=E2=80=AFAM Tim Wiederhake <twiederh@redhat.com=
> wrote:
>
> Software such as qemu and libvirt require the raw content of some MSRs

Note that KVM doesn't return the raw value of IA32_ARCH_CAPABILITIES.
First, it filters out unsupported bits, and then it massages the
result a bit. See kvm_get_arch_capabilities(). Isn't this what qemu
actually wants?
