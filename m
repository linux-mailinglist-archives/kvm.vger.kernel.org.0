Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 616CF6CF2CE
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 21:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbjC2TLn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 15:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjC2TLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 15:11:41 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86B94CD
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 12:11:40 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5417f156cb9so165466117b3.8
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 12:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680117099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aOTO3i0zW/L4Ct1aMaMN4/os1aAMPD5pwfF1N642Aqw=;
        b=nfgq5VlHao9SgjaA0BPUp+tMyaFPRLYJqLFbIMsOEkRj3MHnTOHAwo4EFbw2eChzMV
         TzK9cTRXK8GOGmnmjwKgTMvtaKN3ijNhfBUnE6R1t2qzb4NcVB9+aPK3JaME0qXai2wg
         Na07ySDk8EPdaBzw1T+Wv9644KCT6rbu40kpjiU/ZzPwkUMJiMaIZNYe80C8ImMdbgvf
         n8ge2NUUM4tU+DPRC6u2oAExtTHXuWfXfSQFw8gxN9l7sCGnB+zAEbb1dQYh5bW7hQVb
         ahB32EZGC1DuAlfNQmS908zu9Bw9iOGkTrOa/wQV6dFtaAj62ZXF5xAwzPaX43/VAw04
         mbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680117099;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aOTO3i0zW/L4Ct1aMaMN4/os1aAMPD5pwfF1N642Aqw=;
        b=PR4YHwTJKuv8IaIYQUFEr4ufvNHd87iK/RVfxBMUh60dFjapVc8nMlg9qgd5cSVFvI
         TM5W9ZVrCCL9eflvH8p9ogaBJyRQIocjCBwKnti9xkrEDpqtLWckbnOj2AgzW7B5+qLz
         w41PK85AGAniOlOyPWNBbr0EVQT9drKCtpwxUGzMgRGzZ4lHHHVeZg2KeDSNraIdGIcc
         i3Dhi0nGu8KBhfvG0zUqPrD2MCCo9CSxlj48PYgZVQZk+gfnyMsAgfMSxzbrFct/df4U
         cpCGr7aeXZWwHjIzWy5PO5SbDQ/GYhH/tCiv5PblTLSZsS3g7tY+AQ99KJTcrmxHRZU6
         TW+w==
X-Gm-Message-State: AAQBX9fVbmhFHTeJtRc2xCGPo8ogKnmiuRFQQMPHw9nQ5NnM0ja6Kpuh
        LAe+xVenrVhf6MDjBvfLaJm9hNDY6Ow=
X-Google-Smtp-Source: AKy350Zg3taZSiKtu93z9QzyieNUHDEQrLUnU6FMvTlpksDA27axFfegjBIm4tKQFyjAAcrpYV/dZZeuxLc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:b149:0:b0:545:1d7f:abfe with SMTP id
 p70-20020a81b149000000b005451d7fabfemr9578304ywh.7.1680117099755; Wed, 29 Mar
 2023 12:11:39 -0700 (PDT)
Date:   Wed, 29 Mar 2023 12:11:38 -0700
In-Reply-To: <0dcae003-d784-d4e6-93a2-d8cc9a1e3bc1@redhat.com>
Mime-Version: 1.0
References: <0dcae003-d784-d4e6-93a2-d8cc9a1e3bc1@redhat.com>
Message-ID: <ZCSNasVg+HBK0vI1@google.com>
Subject: Re: The "memory" test is failing in the kvm-unit-tests CI
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        Cole Robinson <crobinso@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 29, 2023, Thomas Huth wrote:
> 
>  Hi,
> 
> I noticed that in recent builds, the "memory" test started failing in the
> kvm-unit-test CI. After doing some experiments, I think it might rather be
> related to the environment than to a recent change in the k-u-t sources.
> 
> It used to work fine with commit 2480430a here in January:
> 
>  https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/jobs/3613156199#L2873
> 
> Now I've re-run the CI with the same commit 2480430a here and it is failing now:
> 
>  https://gitlab.com/thuth/kvm-unit-tests/-/jobs/4022074711#L2733

Can you provide the logs from the failing test, and/or the build artifacts?  I
tried, and failed, to find them on Gitlab.

> Does anybody have an idea what could be causing this regression? The build
> in January used 7.0.0-12.fc37, the new build used 7.0.0-15.fc37, could that
> be related? Or maybe a different kernel version?

Nothing jumps to mind.  Triaging this without at least the logs in going to be
painful.
