Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 782E56096FA
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 00:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJWWPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Oct 2022 18:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiJWWP3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 23 Oct 2022 18:15:29 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7D446878
        for <kvm@vger.kernel.org>; Sun, 23 Oct 2022 15:15:26 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id ml12so4511124qvb.0
        for <kvm@vger.kernel.org>; Sun, 23 Oct 2022 15:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=y24AOJSf6aWoSnenwrB4rB+v3E66RFlXKYZodyfNpmI=;
        b=bYPvGCsIR4tXMVTQIDgsK6ovOEDTsnWnZFWagZ69yVWsOXt3quZB41d2pj+DwvzEgl
         4v/a818ksm996aOQdG7sbDti2ShqA0oH5Zag95O6OrGmWkHFXcWE0eFFs2kMgb6ftKzg
         UxtGjkNOPKmKt7VQ2ubIAOuanhlaZ59MN3WVM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y24AOJSf6aWoSnenwrB4rB+v3E66RFlXKYZodyfNpmI=;
        b=bgU+COJXiW/kd9GEEMquzaX1vlNZpLm+g7iDs2LsTReq0BGEmaEmOyB56Sr59vGNK+
         AqnwG5/uehBJB4mfOXLfdibL1yknOyqCS7Y+7zagdrulEFJ4fEVMXQvB8/AgNpMfD4Mp
         DuoFiqs0Nk/MQMi/o7z9Z838vbYoGl9KQXxjVAi47rBMti8z9iLd5O7/rorcoJ5bvlkI
         cgL8WVTrugZFMcv1/Qe92N2N7HwN85RKnus416/BWhPpm0FBaXuJya5nQZDtuwqT1auV
         GFdFLsIm+MyGSoANhs6d6V1FR6I0nKK8PxO+r5Ljwc6MW33Uv2QMf0fPoZoYSZXrlP1/
         jHzw==
X-Gm-Message-State: ACrzQf3LBI7y7klFaqKlD2B3r+zDLOj3TehalqN0gkx0OSIvsYk8PzlM
        Y01EUtldA8YIiFyhA8IDLtfpYLb8LwK0ZA==
X-Google-Smtp-Source: AMsMyM6y4FsCcbnkmeLydNmb3M0eoaJAhS1NYhjRnLIPViELIibsdq8RgEhbZ9OxGaFDl/83a3O0Dg==
X-Received: by 2002:a05:6214:1d26:b0:4bb:5bb9:bd6d with SMTP id f6-20020a0562141d2600b004bb5bb9bd6dmr9534077qvd.69.1666563325367;
        Sun, 23 Oct 2022 15:15:25 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id u24-20020a37ab18000000b006bb83c2be40sm13829407qke.59.2022.10.23.15.15.24
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Oct 2022 15:15:24 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id 187so141793ybe.1
        for <kvm@vger.kernel.org>; Sun, 23 Oct 2022 15:15:24 -0700 (PDT)
X-Received: by 2002:a25:5389:0:b0:6bc:f12c:5d36 with SMTP id
 h131-20020a255389000000b006bcf12c5d36mr25687050ybb.184.1666563324398; Sun, 23
 Oct 2022 15:15:24 -0700 (PDT)
MIME-Version: 1.0
References: <20221023174307.1868939-1-pbonzini@redhat.com>
In-Reply-To: <20221023174307.1868939-1-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 23 Oct 2022 15:15:08 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgL7sh-+6mPk7FGCFtjuh36fhOLNRTT0_4g3yd380P0+w@mail.gmail.com>
Message-ID: <CAHk-=wgL7sh-+6mPk7FGCFtjuh36fhOLNRTT0_4g3yd380P0+w@mail.gmail.com>
Subject: Re: [GIT PULL] KVM patches for Linux 6.1-rc2
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <graf@amazon.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, Oct 23, 2022 at 10:43 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> x86:
>
> - add compat implementation for KVM_X86_SET_MSR_FILTER ioctl

Side note: this should probably have used

        compat_uptr_t bitmap;
        ...
        .bitmap = compat_ptr(cr->bitmap),

instead of doing that

        __u32 bitmap;
        ...
       .bitmap = (__u8 *)(ulong)cr->bitmap,

because not only are those casts really ugly, using that
'compat_uptr_t" and "compat_ptr()" helper also really explains what is
going on.

compat_ptr() also happens to get the address space right (ie it
returns a "void __user *" pointer). But since the non-compat 'struct
kvm_msr_filter_range' bitmap member doesn't get that right either
(because it uses the same type for kernel pointers as for user
pointers - ugly uglt), that isn't such a big deal. The kvm code
clearly doesn't do proper user pointer typing, and just uses random
casts instead.

                         Linus
