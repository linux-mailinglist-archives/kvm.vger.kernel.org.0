Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C619F54B41A
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 17:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245266AbiFNPBq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 11:01:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245738AbiFNPBn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 11:01:43 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC7D541988
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:01:41 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b8so12017387edj.11
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ODxKv9DXEzyXisW4L2tDdOPQuT/fUgqqrwiPKscw3fY=;
        b=dkRLuS0K2v319PcXm79Yz14PlggFsMt6Q4N5YFB5jl+SHs7stUFsx+coHokzgJJH3h
         299y17G/0dbEqff95oaV0FYeWPzppSBxZuXGaB+HZwvVQ6d2j7M+J8kroFyNVqQW0P7K
         AZy2aV48j43OARlj0tuXcNA05O42ayDB13CF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ODxKv9DXEzyXisW4L2tDdOPQuT/fUgqqrwiPKscw3fY=;
        b=VHORSUw05W1LXvuPzLvYcl3yMkJGVYfDI0ARREa+7cU9Yj8xsuh82k/9W6jt7qlDui
         qMzfwJG7R0jR8uscheUdAIbc2OtYy2q+H9EIQRwZR3V/KFq2BqaLrkWl9nBzJpHfnZd7
         o3VHhHkMGHrrpjfLMdhezGPGhRz7IYvmE2WV2hjsIiiQWzT1BrkAQpVlgSuAduShFmZj
         Yza7Jtv9XtuxxW4YdLqftY0ttbGpndDbznEL+/r0zqzXcv2VpEVMJCoJkcVXMZHzPOW2
         DWmLQvYMfoxPUUj8edC2nQeMLqVX6BTXE57/oZqeXc555NMY8HRi2AjkVy86ZS5guOU8
         50TA==
X-Gm-Message-State: AJIora9mG4xxDlPzZyMujovGo2cwpRBuO5X82OXO9NHV5IxyZc8tDcxl
        wBH0ofa5rZOfglHrJSreyk9hHrKSvAu03O5d
X-Google-Smtp-Source: AGRyM1tdG0qY5mTKjyRcrhSoXzmIxSImdxtSfsGjV/Z/3rxZDovIwU+q2eudRXIdusgGzEg3dCjjXg==
X-Received: by 2002:a05:6402:35c4:b0:42f:b0f8:6a69 with SMTP id z4-20020a05640235c400b0042fb0f86a69mr6730638edc.180.1655218899778;
        Tue, 14 Jun 2022 08:01:39 -0700 (PDT)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com. [209.85.221.52])
        by smtp.gmail.com with ESMTPSA id h18-20020a05640250d200b0042e15364d14sm7296590edb.8.2022.06.14.08.01.38
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 08:01:39 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id x17so11672893wrg.6
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 08:01:38 -0700 (PDT)
X-Received: by 2002:a5d:414d:0:b0:213:be00:a35 with SMTP id
 c13-20020a5d414d000000b00213be000a35mr5170207wrq.97.1655218898671; Tue, 14
 Jun 2022 08:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220614083552.1559600-1-pbonzini@redhat.com> <YqihVgV1AHGJ1GKw@google.com>
In-Reply-To: <YqihVgV1AHGJ1GKw@google.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Jun 2022 08:01:22 -0700
X-Gmail-Original-Message-ID: <CAHk-=whZWxdfY3Ks7E_G0=8TmUyc0nnGGiBij_ARsk4JNZiQeQ@mail.gmail.com>
Message-ID: <CAHk-=whZWxdfY3Ks7E_G0=8TmUyc0nnGGiBij_ARsk4JNZiQeQ@mail.gmail.com>
Subject: Re: [GIT PULL] More KVM changes for Linux 5.19-rc3
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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

On Tue, Jun 14, 2022 at 7:55 AM Sean Christopherson <seanjc@google.com> wrote:
>
> This patch has a bug that breaks 32-bit builds, and undoubtedly does weird things
> for 64-bit builds.

Thanks, you caught me just as I was merging it.

I fixed it up in the merge itself.

                 Linus
