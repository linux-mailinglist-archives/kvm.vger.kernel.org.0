Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE3344C944E
	for <lists+kvm@lfdr.de>; Tue,  1 Mar 2022 20:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbiCATcT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Mar 2022 14:32:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236067AbiCATcP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Mar 2022 14:32:15 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE2F46A01C
        for <kvm@vger.kernel.org>; Tue,  1 Mar 2022 11:31:32 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id s25so23241649lji.5
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 11:31:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tBCWb7PwbT43VGHxFqcKndIr9KxLErVmYKG+r9qe67A=;
        b=f89A2pypRpCoKxJg+cX6HSFQZ2dRsjtqJGJCHwDCo/XiFoXB+LtkLg5nOUSLTR7Zlo
         eU+bGhmL2KmRlodVlqD6+ODrBfKQi7i3b2vylG4PKun7taOdLlkSbD39LAvUPRJ43APt
         TWn29lEYeNWRPtm0JolOXmvAqWcF+Dr7e0y1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tBCWb7PwbT43VGHxFqcKndIr9KxLErVmYKG+r9qe67A=;
        b=Q30eHSbDF1+l1uPQiQyzyj8pi1JViVrBagbWUCaiTTrBvsk7HJrhk6xYvKahSRkrzd
         GJgCJ6LA9Ne56qxDGXA2peHEx59+Cwx9EtGAb9TDbK1fafqhxkXGKLhd0mIJQOMjQ4QR
         Q6oHKAhyzLQ7XXO9R8Tzv0ns9QuWH9LdbMWnJFgUruLV5/fuBCU8gnUN8SHvmJSzB9KA
         QrFShxh4rAdvxNTUskcA0ukoC5OSUO1UQol38IwU38qBJQnQDzHKj3UJ2vHIFEJb7m3L
         dTyJMw1qh1oU1cnMn7tRXTLi9rx0ykIN8Y0c0o7u9mm3Vbfm2rARPTGA4n3kWAAl/c3T
         /okA==
X-Gm-Message-State: AOAM532zOQO3j8p7Llft6IGguyWUzKkX6Di7Rg2kpWcB6owfXOI6y+Th
        q4Fgju6+weE4tnOb3GamkOYL13j3VKqp4k/AY6M=
X-Google-Smtp-Source: ABdhPJympinj7tFBWRLV4Fzhwu7z++8yZebdCpLKSQI81z3LPDNitI2O1zkuuoAQQiLwpfUJ2nQwgw==
X-Received: by 2002:a2e:9019:0:b0:22e:1b3:190d with SMTP id h25-20020a2e9019000000b0022e01b3190dmr18690430ljg.160.1646163090391;
        Tue, 01 Mar 2022 11:31:30 -0800 (PST)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id i31-20020a0565123e1f00b004437ea7d615sm1643799lfv.41.2022.03.01.11.31.29
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Mar 2022 11:31:29 -0800 (PST)
Received: by mail-lf1-f47.google.com with SMTP id i11so28649250lfu.3
        for <kvm@vger.kernel.org>; Tue, 01 Mar 2022 11:31:29 -0800 (PST)
X-Received: by 2002:a05:6512:e8a:b0:443:7b8c:579a with SMTP id
 bi10-20020a0565120e8a00b004437b8c579amr16542590lfb.687.1646163089338; Tue, 01
 Mar 2022 11:31:29 -0800 (PST)
MIME-Version: 1.0
References: <20220301130815.151511-1-pbonzini@redhat.com>
In-Reply-To: <20220301130815.151511-1-pbonzini@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 1 Mar 2022 11:31:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg1LV8MoSNXQE9kiaFSUHdyMhLpAiQ0JW=JGZKmrORQ4Q@mail.gmail.com>
Message-ID: <CAHk-=wg1LV8MoSNXQE9kiaFSUHdyMhLpAiQ0JW=JGZKmrORQ4Q@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for 5.17-rc7
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 1, 2022 at 5:08 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
> The following changes [..] are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/virt/kvm/kvm.git tags/for-linus

Nope. Not there.

When I do a 'git ls-remote' on that thing, the 'for-linus' tag still
points to your previous pull request from last week.

Forgot to push?

              Linus
