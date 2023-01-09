Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0FE3662C9A
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 18:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbjAIRZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 12:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235348AbjAIRZW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 12:25:22 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1B9F40C1A
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 09:25:21 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-14455716674so9363706fac.7
        for <kvm@vger.kernel.org>; Mon, 09 Jan 2023 09:25:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BfmjP2mndLDes9oQRNaJXeRDdi6D0K9ObPAqlxFeEu0=;
        b=n90Q6czpE5ApJ2gN/nhORqyIrmbjapJ05+Aff3Ztvw5ahUAcOGpKgIM6yaDv0lJO8Z
         +Mi25azRzciEp5kW6wNc8xmhvdj8UtvajbJQ1mLZy/4rtz95POVxJ9bBaWv05g2yO1yB
         1NpiAnyRFitfTzeRTk6gk7dL6msevio0pwpGakUWJusEBE/6ln9/R2Q1x/5FMJfErXIH
         aGzGU1NtQSkc8dDkz6Bstdg9nlHsXEH9p1wh9N5ociAd8ZOFGUulqZqwkYDZbcDWm4s/
         29fLrU1Z55eNQEHJsUzWeS24GerzqvBUqJM/tocu9i+0uEp6+I8EzI7VdukyCoB7Op1L
         /t9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BfmjP2mndLDes9oQRNaJXeRDdi6D0K9ObPAqlxFeEu0=;
        b=L1FroAL5bbRtxi07iniZ4XOpIinDUwxCP8ByPhqVZEQaBDS7rqk1N4orMwYW8yd6Vz
         hlHb6PNCbYrbvNcTe97pnuCmx3VpWAF3CTL2Q5ERtnSyswXQMRG31W2pAfhhtDyn47Y+
         zWRyKxXL8dEpmQW3xXe9HOs8cVV/aMF2BZJm9UTqRAWuHxi+mkbJ2jJrr5kxuNsJ4H79
         HDD5LoCi4s1pQXr1DUWlFAwXnlSTQo73IBZ88U7/INIDOhpZqinZTiYDH7vVXnNJLE/i
         cpc5EWY2xVCiSYmpkfdVMRDYNWdwupnl/5a18esZLtKIbjq6SAtxeo975Oig6DKD9VER
         as6A==
X-Gm-Message-State: AFqh2kopipatF/Idqm5gTFKZJmT4T+8CkERrxoPuMtgL3O9yvIMkVgjE
        FfccU+kzhhE2XP1NhhslT7x/0225xFyqMp+qIZuTdA==
X-Google-Smtp-Source: AMrXdXtzQNFiyh4xIRzhYuKtkMcUQ2K4IiyYKYar0Jys/Q3OEqkhPu8uyjJho++He3RsqGUv1AZTzdsWHegUt+RO7OQ=
X-Received: by 2002:a05:6870:b8f:b0:153:8960:d987 with SMTP id
 lg15-20020a0568700b8f00b001538960d987mr1155220oab.103.1673285121011; Mon, 09
 Jan 2023 09:25:21 -0800 (PST)
MIME-Version: 1.0
References: <20230107011025.565472-1-seanjc@google.com> <20230107011025.565472-6-seanjc@google.com>
In-Reply-To: <20230107011025.565472-6-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 9 Jan 2023 09:25:09 -0800
Message-ID: <CALMp9eQRc7rFruYQiaP1wUfPpvp4oVE=JX=TDtR=WZSoC6Nb2w@mail.gmail.com>
Subject: Re: [PATCH 5/6] KVM: VMX: Always intercept accesses to unsupported
 "extended" x2APIC regs
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Ben Gardon <bgardon@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>
Content-Type: text/plain; charset="UTF-8"
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

On Fri, Jan 6, 2023 at 5:10 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Don't clear the "read" bits for x2APIC registers above SELF_IPI (APIC regs

Odd use of quotation marks in the shortlog  and here.

> 0x400 - 0xff0, MSRs 0x840 - 0x8ff).  KVM doesn't emulate registers in that
> space (there are a smattering of AMD-only extensions) and so should
> intercept reads in order to inject #GP.  When APICv is fully enabled,
> Intel hardware doesn't validate the registers on RDMSR and instead blindly
> retrieves data from the vAPIC page, i.e. it's software's responsibility to
> intercept reads to non-existent MSRs.
>
> Fixes: 8d14695f9542 ("x86, apicv: add virtual x2apic support")
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
