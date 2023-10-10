Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 078657BEFDB
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 02:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379226AbjJJAox (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Oct 2023 20:44:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379188AbjJJAow (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Oct 2023 20:44:52 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F94A3
        for <kvm@vger.kernel.org>; Mon,  9 Oct 2023 17:44:50 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id 98e67ed59e1d1-27903b68503so3847649a91.0
        for <kvm@vger.kernel.org>; Mon, 09 Oct 2023 17:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696898690; x=1697503490; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GjWqPSaGLXcalBvg3vbKJZBRfdwwxJm8ORCUVRBFN2k=;
        b=nliD91NADAj3P8mRtEEHzzIQK9EKu/4+SW4MYtOA2bwhlnxLNMDHX1dlNoO9E3UZdm
         0HLahyNu8BuUz4429RaqGyY3qkhrK00X8b/fy47F3/JzYXBlYWrlUvoq4iWNPMgRwRiI
         B1m5ytvh6z/q3yMO0VL2rRj1JMXMXwaRsp9qg5X+jybjdD+NBWfc7cy1AnEzHJ6jqBbu
         TeKpv14R8Y+ohWEmS5ls8U0infG2SKCOMlbne3lyk60ldvKM9Jaghy6FAMI+vdjyRZij
         LWhmGnkqElOgdwQAQv/fKexyYrsaavCaACAHtwJofqXSTB8m/zVGl1Z4Sm6Z2xG1gu4D
         klFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696898690; x=1697503490;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GjWqPSaGLXcalBvg3vbKJZBRfdwwxJm8ORCUVRBFN2k=;
        b=ShvK1IPq5+fP8RjoWncN8HCOw7Lx5jTj2b9SipUg+4WR7hMVe3zK58zJJu+dnUs75/
         DS1TbUQnbUDYBx8JVkZMNaNOJ8uTBpnLyJTGylMYoeBY+tVsVw/NASB2KFLFPjRCD5dr
         LCKbgWcvfryUdqXj1faH7PVyibUm5g46EPifalHpFuYcvbHtALskIM1r0h6C5wqifiGF
         a35PAxkKrDYJf2lEf48UbP46uZm3ZYN1RgHULHedSNkNLSgE2ARhA7R/eW1LAkzhiMnW
         yfngoNaufX4m5D5Z6ZKW1oGYGyooJ+zTQYmMNAatuxB6l3JSP33m61G/R7xXjQ3xH/Sr
         zP1A==
X-Gm-Message-State: AOJu0Yw06xwoxyKdCzDNxkM5Rbws3YPP+K9dPaGAHnnl13r/G60T88kh
        BY4mhnGDNNp1C2F+nFHX2C3oFM5kyQ4=
X-Google-Smtp-Source: AGHT+IHks1xinxBpntMCi1lJzcobNtsVg0K7o78+ChOATaq1C8mIgIHSbN9sGo+h7fwAELRBj6ylyMI6yKs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e548:b0:277:5c9b:14dd with SMTP id
 ei8-20020a17090ae54800b002775c9b14ddmr285423pjb.2.1696898690129; Mon, 09 Oct
 2023 17:44:50 -0700 (PDT)
Date:   Mon,  9 Oct 2023 17:44:32 -0700
In-Reply-To: <20231008025335.7419-1-likexu@tencent.com>
Mime-Version: 1.0
References: <20231008025335.7419-1-likexu@tencent.com>
X-Mailer: git-send-email 2.42.0.609.gbb76f46606-goog
Message-ID: <169689823852.390348.16203872510226635933.b4-ty@google.com>
Subject: Re: [PATCH v7] KVM: x86/tsc: Don't sync user-written TSC against
 startup values
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Oliver Upton <oliver.upton@linux.dev>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 08 Oct 2023 10:53:35 +0800, Like Xu wrote:
> The legacy API for setting the TSC is fundamentally broken, and only
> allows userspace to set a TSC "now", without any way to account for
> time lost to preemption between the calculation of the value, and the
> kernel eventually handling the ioctl.
> 
> To work around this we have had a hack which, if a TSC is set with a
> value which is within a second's worth of a previous vCPU, assumes that
> userspace actually intended them to be in sync and adjusts the newly-
> written TSC value accordingly.
> 
> [...]

Applied to kvm-x86 misc, thanks!  I massaged away most of the pronouns in the
changelog.  Yes, they bug me that much, and I genuinely had a hard time following
some of the paragraphs even though I already knew what the patch is doing.

Everyone, please take a look and make sure I didn't botch anything.  I tried my
best to keep the existing "voice" and tone of the changelog (sans pronouns
obviously).  I definitely don't want to bikeshed this thing any further.  If
I've learned anything by this patch, it's that the only guaranteed outcome of
changelog-by-committee is that no one will walk away 100% happy :-)

[1/1] KVM: x86/tsc: Don't sync user-written TSC against startup values
      https://github.com/kvm-x86/linux/commit/bf328e22e472

--
https://github.com/kvm-x86/linux/tree/next
