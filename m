Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 185AE6A12D9
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 23:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbjBWWeX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 17:34:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjBWWeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 17:34:22 -0500
Received: from mail-io1-xd49.google.com (mail-io1-xd49.google.com [IPv6:2607:f8b0:4864:20::d49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB8412BC5
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:34:21 -0800 (PST)
Received: by mail-io1-xd49.google.com with SMTP id i70-20020a6b3b49000000b0074c7f0b085dso6199035ioa.22
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 14:34:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=f5G8pOd3SsfHOvb383fp62P/cWOAfsSg8HgIFePsLTI=;
        b=Qts9DQIFDgpqPqkY2OB27ix9hDXO1g3+ptGVYA1Iak34y4N1HJjFRKpLPGhtgJBV0g
         2k0YDKTOX564NphkIu58VRqd6vDYuFiIB86gEWhsUurO5VrtrgCHt4JcOVZ7Q4dYbOEE
         /udVuJxucJpD3gnT/ALck3wSRWXavzAHIR9SfqDkKK4ooPA6HAlXQ44/cnuG20rqr25j
         eFrEAJLrP1tLlGzm+0lPHKozvjct25Ntr3XXP9bpFvZza+jZEtz9SuJ1aQwPEFMdCJ/4
         PJ9s1SuANSRqZQQ38Jl5sKU8n+9HghXjLKphcYQ70P3HX4M5ctZ5+Sh4mYdxQxS3yXLR
         liBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f5G8pOd3SsfHOvb383fp62P/cWOAfsSg8HgIFePsLTI=;
        b=FmehCgfTHkhmDOdHOVdbQySuuThXV9QItiLVQzdPQyqi3r8YVvyxWAZKz0EtLsv49O
         1ZAAIkvZB4kI+O3yDFZiz2l3hQ+L6+oIc8FsUO5yzjYXUwkyvc5mHJMLs2gRK6ZBV58M
         d7BAZ6tFyufWgJPOD1XgNueWPte2lsgrJ6tG3KIoEbb8Bhluc6UIhNeXCGFzYwp+MPPh
         UyE0g7CtDN+pf65CmP+qBucuUAZSox9CZkfGMuqXyPGahhqOcrs9mXMj82jgEmG+qxV2
         XYDZxW+f/VKeNWvRl2FNwEi93MoRcfF642ob4Pdj0EwwYcRaXkO5jDIKM4Zsi11L9t0k
         tkHA==
X-Gm-Message-State: AO0yUKV9Xsf6Qy58pVhdGDvYp2NnrF/T17wRLdrwyFG5kB+BJfjIusGT
        WCY8qAwxKp8hdHbaRqLvOe+9c1wB+SZXwEZvgQ==
X-Google-Smtp-Source: AK7set8TaSIyth8jADCSw+x57VUjquM5K/QIekc64rxEpvlrEXEvHiHLNvBm/FfKB1f11iiuNTja2L3YSW+/JELC6Q==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6638:10f5:b0:3b7:9d19:fec7 with
 SMTP id g21-20020a05663810f500b003b79d19fec7mr5136649jae.0.1677191660511;
 Thu, 23 Feb 2023 14:34:20 -0800 (PST)
Date:   Thu, 23 Feb 2023 22:34:19 +0000
In-Reply-To: <20230216142123.2638675-7-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:13 +0000)
Mime-Version: 1.0
Message-ID: <gsntzg948104.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 06/16] KVM: arm64: timers: Use CNTPOFF_EL2 to offset the
 physical timer
From:   Colton Lewis <coltonlewis@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
        suzuki.poulose@arm.com, oliver.upton@linux.dev,
        yuzenghui@huawei.com, ricarkol@google.com, sveith@amazon.de,
        dwmw2@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


CNTPOFF_EL2 should probably be added to the vcpu_sysreg enum in
kvm_host.h for this patch. This seemed like the most relevant commit.

Marc Zyngier <maz@kernel.org> writes:

> +static bool has_cntpoff(void)
> +{
> +	return (has_vhe() && cpus_have_final_cap(ARM64_HAS_ECV_CNTPOFF));
> +}
> +

This being used to guard the register in set_cntpoff seems to say that
we can only write CNTPOFF in VHE mode. Since it's possible the
underlying hardware could still support CNTPOFF even if KVM is running
in nVHE mode, should there be a way to set CNTPOFF in nVHE mode? Is that
possible?

This caused some confusion for me on my implementation as some teammates
thought so but I could not get an implementation working for nVHE mode.

> @@ -84,7 +89,7 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)

>   static u64 timer_get_offset(struct arch_timer_context *ctxt)
>   {
> -	if (ctxt->offset.vm_offset)
> +	if (ctxt && ctxt->offset.vm_offset)
>   		return *ctxt->offset.vm_offset;

>   	return 0;

nit: this change should be in the previous commit

> @@ -480,6 +491,7 @@ static void timer_save_state(struct  
> arch_timer_context *ctx)
>   		write_sysreg_el0(0, SYS_CNTP_CTL);
>   		isb();

> +		set_cntpoff(0);
>   		break;
>   	case NR_KVM_TIMERS:
>   		BUG();

This seems to say CNTPOFF will be reset to 0 every time a vcpu
switches out. What if the host originally had some value other than 0?
Is KVM responsible for that context?
