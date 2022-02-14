Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902984B5D36
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 22:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbiBNVsp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 16:48:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiBNVso (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 16:48:44 -0500
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50336190CA0
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:48:36 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id t75-20020a4a3e4e000000b002e9c0821d78so21028518oot.4
        for <kvm@vger.kernel.org>; Mon, 14 Feb 2022 13:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0bj4wDUKYjJrzpjUGLlAuaY5lTtZXVgJ4y/cPezdFzE=;
        b=WjUQacOW9nf6r9Mj3WYTOmOd7I3zvIH7u2dPv3N5WswE6M8uQ766yihsNfBtSLWfWo
         zAZinkMbN3eTFUav/XXkNHKm6cPROGDIXU6D1oNnDbAn9HirKSfgn+5rzHgDi71JNxop
         qLKABlwBP1UQYFoLJEfKlz3H5sx4gKE+rYnSL/+mCTY8IfjERi/CA+nDHkMIjpARXncE
         ElmiCt5J8Wl0ohhrwzZxPhazoQ22tNcUveLkH7Wo6ZpgFuADhwQ+LuUPxJPR53dpQwV8
         mhrs8BepUxBoGpB8fihZ191/xp4MONYQrk4lxDdNsrojFl/J0CKw+9dA1bmB8QUPlaFH
         0SkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0bj4wDUKYjJrzpjUGLlAuaY5lTtZXVgJ4y/cPezdFzE=;
        b=OqX8CohsEn9gYlmWnV0gVJPHOOpwPeZiiPmwWF1S9ud5Taqv4WaozPbNj4zWyrQyD+
         BpHc+dFywtswMc4bPR1KYnF58KneRgJfzLVsmTAx2tbnMigbcHOKcherQP2H4tKXtaHC
         Rzj/Wv6Ho19pQREfZGvdhhxHI6mXhEnLm8q/fj+ir26PxTdX9IBJb7XCmeHGaRiHO6iL
         6935CA9KFD5jvw0HDr0WQ2PAeAroYZ1VAmkSRaT8a+IF0AMx0bBCxCK0K5fLxOeVauOt
         l4Z2BuhrMhfLrliBL1/0QTjKfopJ7xOclv6jd+MPagAnvEJCz4sUUJiInbttK/D20DoZ
         2BFQ==
X-Gm-Message-State: AOAM530xwRAa1RazvCRiCR1W2BWZ4PKAw4sZSiVuBO4JltuMhkXg/YhN
        Y+gFIT6326i+eNl524NggUpk8yhT8WwuXVLivRg8vuambzJIfA6n
X-Google-Smtp-Source: ABdhPJzHJlmFFkErh2NrAXRyU8JRCWCWpja4KANRY1E/6IlGckDh9Bfhv/TZRWKhfnkQpNLiyn/K7v/x9FPZUszqGfE=
X-Received: by 2002:a05:6870:d693:: with SMTP id z19mr308003oap.129.1644875315458;
 Mon, 14 Feb 2022 13:48:35 -0800 (PST)
MIME-Version: 1.0
References: <20220214212950.1776943-1-aaronlewis@google.com>
In-Reply-To: <20220214212950.1776943-1-aaronlewis@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 14 Feb 2022 13:48:24 -0800
Message-ID: <CALMp9eRojXiKrK-jUpYvZniJh6NtocXVpE-awQsiRV1NhSSXhQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Add KVM_CAP_ENABLE_CAP to x86
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
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

On Mon, Feb 14, 2022 at 1:30 PM Aaron Lewis <aaronlewis@google.com> wrote:
>
> Add the capability KVM_CAP_ENABLE_CAP to x86 so userspace can ensure
> KVM_ENABLE_CAP is available on a vcpu before using it.

That's a bit terse.

Maybe something like:

Follow the precedent set by other architectures that support the VCPU
ioctl, KVM_ENABLE_CAP, and advertise the VM extension,
KVM_CAP_ENABLE_CAP.
