Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7AB640E54
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 20:20:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbiLBTUh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 14:20:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiLBTUf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 14:20:35 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68FBCEF8AA
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 11:20:34 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id b21so5483312plc.9
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 11:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KjhSpTyu+aaTapJuHKJDiYaRzS+s27HOfqbTwrumNXw=;
        b=DN/PaAGRPHK+Crex4AP1cTmwbbPi6kfnfWjoEnMDdEuQ0JxtQn2tZtb0BHgFeGutZi
         SP+tQK/nVZ/59x3jJmHtLFunwJsdKzdNK4A8sIa6wjTG3rQ5lgOA/AB/pdS6ekfcIiYy
         g+1n3p9ETedR6IDCGlf7y1znqAgeaNpjVFPqG/3iamivl1xzI1XXJcBpBpJ423Azbuzw
         7EQkYlSJV8bddI2WYsL6zby6ph/GjvNJ3Nd3SnYV6EJ6PGA7Ds1EP/lyNTYTK4LkaabU
         y4pAMNHpdtdsNx1FD2Kx4e9RImh5sw9BHNkvbUKyFqcFUHtsBs2TGjocR60X8Z9q6YSe
         Whbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjhSpTyu+aaTapJuHKJDiYaRzS+s27HOfqbTwrumNXw=;
        b=xiFY5SpuDBhp0AMX8DqLOryUzxogmToSTcz7EPf7xoGfURaSHt6HvsZFz7a7I0X6EB
         bAgakKP38KJF8sf9YkCOHbYDzkqY9xrix+d2fTN7t5hBWLh3Mlo5JFUtxNuG/bZPeLs9
         vsB2VUxDiVmOH03CnV/Igr0ZL/IOsdT/TsgH/ql+nxhUX++B/GlLcASbeRM9oWw3nh9F
         kX84qJTh1ycIzVQXQcBMflz6KsGHLlEj3TlUSZOaL+riqi2ND6QRAYaiJMeuvBx4UkfX
         PCGCg6UyH2xAfw+IQhImdfrv00XAHgrb5jws7xLceREYjfC7pu+M50DfhccX3buLCNxN
         8Fzw==
X-Gm-Message-State: ANoB5pn9nOk6HZs+Tpigtp7HCGZ56HyiVaPMPbeDB5qa1yRgCZRnCWu5
        yW7KXw7cb5hYQa4C5gnIGEzGrA==
X-Google-Smtp-Source: AA0mqf6N7XJBTQ5M2dbhotjqw1xxqdG12arkFwdhLMUNrQOEt2VUghLgZJtxwxPkzvTTr8bHQ1OCaw==
X-Received: by 2002:a17:90a:ba81:b0:219:3e1b:3dc1 with SMTP id t1-20020a17090aba8100b002193e1b3dc1mr26196564pjr.60.1670008833742;
        Fri, 02 Dec 2022 11:20:33 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a10-20020a1709027e4a00b001898aa48d17sm5868771pln.185.2022.12.02.11.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 11:20:33 -0800 (PST)
Date:   Fri, 2 Dec 2022 19:20:30 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Anton Romanov <romanton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com,
        mlevitsk@redhat.com
Subject: Re: [PATCHv6] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
Message-ID: <Y4pP/uu7Mg+NaEUY@google.com>
References: <20220608183525.1143682-1-romanton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220608183525.1143682-1-romanton@google.com>
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

On Wed, Jun 08, 2022, Anton Romanov wrote:
> Don't snapshot tsc_khz into per-cpu cpu_tsc_khz if the host TSC is
> constant, in which case the actual TSC frequency will never change and thus
> capturing TSC during initialization is unnecessary, KVM can simply use
> tsc_khz.  This value is snapshotted from
> kvm_timer_init->kvmclock_cpu_online->tsc_khz_changed(NULL)
> 
> On CPUs with constant TSC, but not a hardware-specified TSC frequency,
> snapshotting cpu_tsc_khz and using that to set a VM's target TSC frequency
> can lead to VM to think its TSC frequency is not what it actually is if
> refining the TSC completes after KVM snapshots tsc_khz.  The actual
> frequency never changes, only the kernel's calculation of what that
> frequency is changes.
> 
> Ideally, KVM would not be able to race with TSC refinement, or would have
> a hook into tsc_refine_calibration_work() to get an alert when refinement
> is complete.  Avoiding the race altogether isn't practical as refinement
> takes a relative eternity; it's deliberately put on a work queue outside of
> the normal boot sequence to avoid unnecessarily delaying boot.
> 
> Adding a hook is doable, but somewhat gross due to KVM's ability to be
> built as a module.  And if the TSC is constant, which is likely the case
> for every VMX/SVM-capable CPU produced in the last decade, the race can be
> hit if and only if userspace is able to create a VM before TSC refinement
> completes; refinement is slow, but not that slow.
> 
> For now, punt on a proper fix, as not taking a snapshot can help some uses
> cases and not taking a snapshot is arguably correct irrespective of the
> race with refinement.
> 
> Signed-off-by: Anton Romanov <romanton@google.com>
> Reviewed-by: Sean Christopherson <seanjc@google.com>
> ---

Merged to kvm/queue, thanks!

https://lore.kernel.org/all/Y4lHxds8pvBhxXFX@google.com
