Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 354FC4C445D
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 13:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240550AbiBYMKw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 07:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240541AbiBYMKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 07:10:48 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 642FA20B16F;
        Fri, 25 Feb 2022 04:10:15 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id s13so4175623wrb.6;
        Fri, 25 Feb 2022 04:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8Y/NiUMDT4o9WesyCiv4t4HIqqx9u2movM8AhOuROWs=;
        b=bw5zm9xJiLlxYM4Y0HyPeGLJ8VQtO4R1BlfQHug0KoiSeLnyfrdxJMZnZNhF1FfgFD
         WzdI+ZwOM794EATAySdnzGKWRaXZWGPIxWis1qbXEqknG65YlATpWw12vu4gvLihpVhb
         zQwYTOW3BOVqY/Qr/LdU3dpGtsvehWM3hoHEfPbJtTH8gA87dlxttwyDJATRhXWzbXrX
         YlXPuIfhoEgX/do7F6K2S+hnUIudUAuZ8HxCxdcQD5FrCl5Z3jjy1LCN9UEjs8cJwuRL
         F2yVFoJwm4zK72vbsCVS0aEY+qHciAtAbtDmjeoeKb62ES2QPmCR+uaiiuhNPrpCyw11
         Eckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8Y/NiUMDT4o9WesyCiv4t4HIqqx9u2movM8AhOuROWs=;
        b=nrtPOZHkFfPFGhMDidIWahBUvR1BFTBDySvplxfpPhjIsah0vuizmk2+k2CQH4LixI
         qQfRjoHcThv/KKrdgcnVHgjPVk1M1XLHJnnetJu+2AHo+Kyaj4b8UQKUkxpZVnR0CY5/
         E97AVV/qYqPCSNo3LUkDnI26wEYix/55cCHeCusHFICcJqlEZt2GyAzNif3o64LgiadZ
         3yhatbFJOHhpwJlmQLug4tcsC8hJOvkzVVkZC3F4FYqFH4aOyw/bFMnd4CDiyJ3B92lk
         mno3YcS+dKwWhcN6wNvRCGF1DXdiHwmMhhz95TuqzsU15MQaAamC6nlJb4AUTvhx8s/i
         W/9w==
X-Gm-Message-State: AOAM533bkMhD6+YS7f+vy8BtFzHH+OPhR1HSG4eSibgKzHQ+n0w+GePn
        slFZ4bqd5vRbAl1Qq3cCtRw=
X-Google-Smtp-Source: ABdhPJy5W+FR+p+CNgIV3LW8a7Od3pp/DnDWnDDBXPp4BDrxfuoWUu4rO+7AE2F7IOmJaFkBWKRi5A==
X-Received: by 2002:a5d:6389:0:b0:1ed:bc35:cda4 with SMTP id p9-20020a5d6389000000b001edbc35cda4mr6111841wru.350.1645791013841;
        Fri, 25 Feb 2022 04:10:13 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id r2-20020a05600c35c200b00352cdcdd7b2sm16549826wmq.0.2022.02.25.04.10.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Feb 2022 04:10:13 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <609de7ff-92e2-f96e-e6f5-127251f6e16d@redhat.com>
Date:   Fri, 25 Feb 2022 13:10:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] KVM: x86: Don't snapshot "max" TSC if host TSC is
 constant
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suleiman Souhlal <suleiman@google.com>,
        Anton Romanov <romanton@google.com>
References: <20220225013929.3577699-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220225013929.3577699-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/25/22 02:39, Sean Christopherson wrote:
> Don't snapshot tsc_khz into max_tsc_khz during KVM initialization if the
> host TSC is constant, in which case the actual TSC frequency will never
> change and thus capturing the "max" TSC during initialization is
> unnecessary, KVM can simply use tsc_khz during VM creation.
> 
> On CPUs with constant TSC, but not a hardware-specified TSC frequency,
> snapshotting max_tsc_khz and using that to set a VM's default TSC
> frequency can lead to KVM thinking it needs to manually scale the guest's
> TSC if refining the TSC completes after KVM snapshots tsc_khz.  The
> actual frequency never changes, only the kernel's calculation of what
> that frequency is changes.  On systems without hardware TSC scaling, this
> either puts KVM into "always catchup" mode (extremely inefficient), or
> prevents creating VMs altogether.
> 
> Ideally, KVM would not be able to race with TSC refinement, or would have
> a hook into tsc_refine_calibration_work() to get an alert when refinement
> is complete.  Avoiding the race altogether isn't practical as refinement
> takes a relative eternity; it's deliberately put on a work queue outside
> of the normal boot sequence to avoid unnecessarily delaying boot.
> 
> Adding a hook is doable, but somewhat gross due to KVM's ability to be
> built as a module.  And if the TSC is constant, which is likely the case
> for every VMX/SVM-capable CPU produced in the last decade, the race can
> be hit if and only if userspace is able to create a VM before TSC
> refinement completes; refinement is slow, but not that slow.
> 
> For now, punt on a proper fix, as not taking a snapshot can help some
> uses cases and not taking a snapshot is arguably correct irrespective of
> the race with refinement.
> 
> Cc: Suleiman Souhlal <suleiman@google.com>
> Cc: Anton Romanov <romanton@google.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Queued, but I'd rather have a subject that calls out that max_tsc_khz 
needs a replacement at vCPU creation time.  In fact, the real change 
(and bug, and fix) is in kvm_arch_vcpu_create(), while the subject 
mentions only the change in kvm_timer_init().

What do you think of "KVM: x86: Use current rather than max TSC 
frequency if it is constant"?

Pao
