Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4392F6DA66E
	for <lists+kvm@lfdr.de>; Fri,  7 Apr 2023 02:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbjDGAHJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Apr 2023 20:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237881AbjDGAHD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Apr 2023 20:07:03 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE057A273
        for <kvm@vger.kernel.org>; Thu,  6 Apr 2023 17:06:57 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d2-20020a170902cec200b001a1e8390831so23303343plg.5
        for <kvm@vger.kernel.org>; Thu, 06 Apr 2023 17:06:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680826017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ino5YyBq/GfM+fUdSOf2HFa4ZsDYuj7dqoyVWykvLN0=;
        b=n4LTyjMaGSYct8qR2/uFWsF8lJ2I/NsaOf1QPwunNmd1BJpFI5usfASmHnbIJTW70u
         DNOtoCY8+V5kn7qgLAQ9T3tKSLTQ0OiVjgUaouc8G64Hx5SBuZx4Zr8KaaZmdwfP9+ei
         tCrM1yfRD5tf9a7rLw1O9HAi41/k/Cdi7ITb7UwrvCDV5EJDG4A+Fk3izlynYI8PraH1
         Bo1lgo0LtDDyC8I+UHvwLNGubfFMbZBJIi9nmiBpzw17ee4buvvUGRDilUQy/SX2Bh0S
         h1EOkiHUc/NK8XPF3wJ/nP8KNSHpPdAsgidyq5YIN7bY4STMHMzy7BG+79nkHstr9tHb
         v1hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680826017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ino5YyBq/GfM+fUdSOf2HFa4ZsDYuj7dqoyVWykvLN0=;
        b=IsCjdvgqDH2nL5OKVBP8D1WVtbqeIWL/G42+G25HUVHfjcgVpO08BdSop1VN31dNjB
         PpHLb/cl9kkOAUJOevx5VSZfZUl8T1jZCa388CHkx8jsqDLKRREdkbArBggj6urEbJza
         r3602dfiNuqIAG8P9zUUkR6W4p9g/yw7PHVvsCddSFw4/8yTyY99jrC+cHHwG2GLHLxq
         aciCCvrmZIIYjoYUMCf/w3l9P4G57hcVI3kNdQ/O5SmjeejgYS9oJfrtHKTRglhlLjjQ
         JuG08iWwvxw9VrgR7OONQrEDYaq559tFbBsssbK1q0CaL0Wiwl0jn9mrx+D6obObOTAv
         sCQw==
X-Gm-Message-State: AAQBX9cE0w6Xy/G3byIe+3ZMJilnVlgaSQiTVoGvEAnpdKbbEoGXGJDt
        6sg/Rl2ywF7fLPy9hrM+4G9a6GkGwQ4=
X-Google-Smtp-Source: AKy350a73DHnnELb5cDiJLkorAYbdxsCG3F958mQpUlO3g71ZEteroWPX8jwZ0wYHIFoy+VpYhKoJlx7CfU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:bf0c:b0:1a0:52f1:8ea7 with SMTP id
 bi12-20020a170902bf0c00b001a052f18ea7mr299235plb.12.1680826017296; Thu, 06
 Apr 2023 17:06:57 -0700 (PDT)
Date:   Thu, 6 Apr 2023 17:06:55 -0700
In-Reply-To: <20230214050757.9623-9-likexu@tencent.com>
Mime-Version: 1.0
References: <20230214050757.9623-1-likexu@tencent.com> <20230214050757.9623-9-likexu@tencent.com>
Message-ID: <ZC9enygbWzJ59Ssb@google.com>
Subject: Re: [PATCH v4 08/12] KVM: x86/pmu: Disable vPMU if the minimum num of
 counters isn't met
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Tue, Feb 14, 2023, Like Xu wrote:
> From: Like Xu <likexu@tencent.com>
> 
> For compatibility with old software, KVM/AMD should never report less
> than four counters if vPMU is supported.

Explain _why_.  Anchor what "should" be done in hardware specifications and
architecture.

> Thus KVM should sanity check the number of counters enumerated by perf and
> explicitly disable vPMU support if the min isn't met. E.g. if KVM needs 4
> counters and perf says there are 3, then something is wrong and enumerating 4
> to the guest is only going to cause more troubles.

Again, state what the patch actually does, not what KVM "should do".  E.g.

  Disable PMU support when running on AMD and perf reports fewer than four
  general purpose counters.  All AMD PMUs must define at least four counters
  due to AMD's legacy architecture hardcoding the number of counters
  without providing a way to enumerate the number of counters to software,
  e.g. from AMD's APM.

    The legacy architecture defines four performance counters

  Virtualizing fewer than four counters can lead to guest instability as
  software expects four counters to be available.

> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Like Xu <likexu@tencent.com>
> ---
>  arch/x86/kvm/pmu.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
> index d1cc02c8da88..46db5404894e 100644
> --- a/arch/x86/kvm/pmu.h
> +++ b/arch/x86/kvm/pmu.h
> @@ -170,6 +170,12 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
>  	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
>  		enable_pmu = false;
>  
> +	/*
> +	 * For AMD, disable vPMU if the minimum number of counters isn't met.
> +	 */

Doesn't need to be a multiple line comment.  This comment is also useless.  It's
quite clear from the code that PMU support is being disabled when there aren't
enough counters, what's missing is _why_.

> +	if (!is_intel && kvm_pmu_cap.num_counters_gp < AMD64_NUM_COUNTERS)
> +		enable_pmu = false;
> +
>  	if (!enable_pmu) {
>  		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
>  		return;
> -- 
> 2.39.1
> 
