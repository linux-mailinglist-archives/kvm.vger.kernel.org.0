Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6ABF264BB9F
	for <lists+kvm@lfdr.de>; Tue, 13 Dec 2022 19:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbiLMSJD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Dec 2022 13:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236484AbiLMSIr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Dec 2022 13:08:47 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED43124958
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 10:08:45 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id t17so38549697eju.1
        for <kvm@vger.kernel.org>; Tue, 13 Dec 2022 10:08:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RVv2lGS1QtPOv9VnNMYzD4yPosTBNSmpDviAz4kDLPY=;
        b=peLCiPoJN8N8Tb1p6aW0ZcLLW9eQVYFHieGIH+/soE2mJmhBOAE8pgEhFeJerRRajT
         V87AYez/AJLPfiPnujhTZ6JT06R8VkU/8lZyIjK6d9NDWFT3lpIGHW2TCsE3ze/vTjLu
         pMiH3eIoOVedW9v4FHFVP4gg2sTTF+UooGVpFrzyGYMok6+ySeT5WjIQUw2VHAZTUuEH
         waXdjO1JuWmBiMIvNz7yf/SCMzj7UMx6Qom2F3K6hY8D/6ayk5k5aYT4K0CMGnXoWvsK
         96A3S5HXcN/MM3KDlycAfKI09fQ44Ht7hZnUNSOse/gKkpXLXhypMfMbM0q7yESWnyj8
         FxkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RVv2lGS1QtPOv9VnNMYzD4yPosTBNSmpDviAz4kDLPY=;
        b=kyFwrFHne/kqWjNK7/uHaZiJUDCpzFYsB/qg/kfZ172DV0MAw+VBMu3WwcD01fPqSx
         PKeVvrG0HD0wasndWxT2m2gAhTjJFMbeA7ARxBW8AUCOf4dJdafnEe3G5pMfbZncSLWQ
         dCHD9zu0GhbRHXTjbcdGjBasyjJnJEVvAnljA2N+Nf+UhIitfPMYoS+ZWZXCc1fODPJr
         YVVA66KORYPpBZi69k8roYt4EW9KB/S5r6gFTNthFHgo6c954vqXeCevP0iVPEVputR+
         +EfLG0hML7VvVGL9RcdVj4IHDYUCIQ+hBrjVtuI6oSMS44he6VeL0SqcYZUW3e1An3J4
         qxtg==
X-Gm-Message-State: ANoB5pkysSE2NmnQfOKgelrRfJG/5FdD1ez7d3t+LlheUvUmz8UPam/G
        ikHtjYjlFxsf0FFPiR49PleQ56mXAzBGRgZzp+OaBw==
X-Google-Smtp-Source: AA0mqf7EIHynCnOgfqnf8iFQCVyDpM+L9k0NdgVvyfQgxnXZJP8tCzxnleMIyAWGCKcW/91EzMvI3XSvdxT9NvSR9rQ=
X-Received: by 2002:a17:906:c250:b0:7c0:9bc2:a7f0 with SMTP id
 bl16-20020a170906c25000b007c09bc2a7f0mr31409306ejb.59.1670954924310; Tue, 13
 Dec 2022 10:08:44 -0800 (PST)
MIME-Version: 1.0
References: <20221213062306.667649-1-seanjc@google.com> <20221213062306.667649-2-seanjc@google.com>
In-Reply-To: <20221213062306.667649-2-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 13 Dec 2022 10:08:33 -0800
Message-ID: <CALMp9eSsH5UO4=NXOwEWzyqswBQacX7K13X+Tzy6bTQDBatc-A@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] KVM: nVMX: Properly expose ENABLE_USR_WAIT_PAUSE
 control to L1
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
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

On Mon, Dec 12, 2022 at 10:23 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Set ENABLE_USR_WAIT_PAUSE in KVM's supported VMX MSR configuration if the
> feature is supported in hardware and enabled in KVM's base, non-nested
> configuration, i.e. expose ENABLE_USR_WAIT_PAUSE to L1 if it's supported.
> This fixes a bug where saving/restoring, i.e. migrating, a vCPU will fail
> if WAITPKG (the associated CPUID feature) is enabled for the vCPU, and
> obviously allows L1 to enable the feature for L2.
>
> KVM already effectively exposes ENABLE_USR_WAIT_PAUSE to L1 by stuffing
> the allowed-1 control ina vCPU's virtual MSR_IA32_VMX_PROCBASED_CTLS2 when
> updating secondary controls in response to KVM_SET_CPUID(2), but (a) that
> depends on flawed code (KVM shouldn't touch VMX MSRs in response to CPUID
> updates) and (b) runs afoul of vmx_restore_control_msr()'s restriction
> that the guest value must be a strict subset of the supported host value.
>
> Although no past commit explicitly enabled nested support for WAITPKG,
> doing so is safe and functionally correct from an architectural
> perspective as no additional KVM support is needed to virtualize TPAUSE,
> UMONITOR, and UMWAIT for L2 relative to L1, and KVM already forwards
> VM-Exits to L1 as necessary (commit bf653b78f960, "KVM: vmx: Introduce
> handle_unexpected_vmexit and handle WAITPKG vmexit").
>
> Note, KVM always keeps the hosts MSR_IA32_UMWAIT_CONTROL resident in
> hardware, i.e. always runs both L1 and L2 with the host's power management
> settings for TPAUSE and UMWAIT.  See commit bf09fb6cba4f ("KVM: VMX: Stop
> context switching MSR_IA32_UMWAIT_CONTROL") for more details.
>
> Fixes: e69e72faa3a0 ("KVM: x86: Add support for user wait instructions")
> Cc: stable@vger.kernel.org
> Reported-by: Aaron Lewis <aaronlewis@google.com>
> Reported-by: Yu Zhang <yu.c.zhang@linux.intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
