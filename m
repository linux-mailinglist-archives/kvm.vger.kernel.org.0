Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97406A230A
	for <lists+kvm@lfdr.de>; Fri, 24 Feb 2023 21:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbjBXUIO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Feb 2023 15:08:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjBXUIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Feb 2023 15:08:12 -0500
Received: from mail-io1-xd4a.google.com (mail-io1-xd4a.google.com [IPv6:2607:f8b0:4864:20::d4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C39811178
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:08:00 -0800 (PST)
Received: by mail-io1-xd4a.google.com with SMTP id i3-20020a0566022c8300b0073a6a9f8f45so59224iow.11
        for <kvm@vger.kernel.org>; Fri, 24 Feb 2023 12:08:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hqBDCaRUpk8eeZQxB4xKYCRgQ97yBQOILalgfmcsiXE=;
        b=PpVmRsfgRU3/7G3EUko9SO7Uz+4sbcJza/bKiesHq4gRYVc0ySt6JR2N0ILMGK6IZm
         NZJQ7TUnJv6kKCgDK9fdXRCtZSsNOFeB5uS+ptf2u4V0IukvE621a4uR4PSZukVXATOA
         pWrNGtUZn63LWdSMq6SVGoWgEPivBA4e13bxeyBhzn+zFCYQRQUlrQrslOLSnP4DIPlb
         jYFKzsJMhEPQUNL/N2HlOS3imzJ1QEkn/NIJVATwykJWgh3UANOeE0nIJ46BzE1FoIOS
         NYlNvdeQtC27E+h7LPSVDY/0LBoyqGAp8/Y5w0Gc7jlQ72LIoYIn58ekYRxwWhbGqcqR
         fP1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hqBDCaRUpk8eeZQxB4xKYCRgQ97yBQOILalgfmcsiXE=;
        b=p4v1m0LyfnK44lNmbJtDho1H1wRMLRadTwDo0XaJXSaiQ+BwkrUEb587dDgbJFdGA8
         r188TOKbIqfkQAj0077nnX/Su3NLTo/e+ezRoZ/0jte8lgtsAbEgn0JJn0Mp8LyWs+Sz
         3LMKLHdzd9e30fsIEd/VXFj4FK/BsL3LxwWGoeTbi/Vr3X36J+slH4tek6icsbaXZcEM
         pkaq7lnvWd5nhaPXA3oqq1OtQz0uZ9s9uDCVM/dwhLRoB0xGNnEOeq9aFRB5m6+Sq6yZ
         3WjXir2ffyE1tiV+h+Q9u8OBfpEKEyOLBVxB/xdLPQa079BZzPP9WY/R/B3J6FKOOZbv
         05iw==
X-Gm-Message-State: AO0yUKUrB3H0FmbHSAhVrTa4uJGCjRQYE9/QFMZZ55doN4eMTK1rEPsa
        52kRfCkyoaoFwP1CNjk4mFS9C7e+p05zCkL4XQ==
X-Google-Smtp-Source: AK7set8qKDHKk40apdIcYxEoC/sxsBMxabxSWSh9r3ex6HkDrTM9Dipd7uUTAZQ4hCt54nyTpZ17rrTiHfIUINRn/g==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a05:6e02:1146:b0:315:34c0:d463 with
 SMTP id o6-20020a056e02114600b0031534c0d463mr5264952ill.3.1677269280238; Fri,
 24 Feb 2023 12:08:00 -0800 (PST)
Date:   Fri, 24 Feb 2023 20:07:59 +0000
In-Reply-To: <20230216142123.2638675-13-maz@kernel.org> (message from Marc
 Zyngier on Thu, 16 Feb 2023 14:21:19 +0000)
Mime-Version: 1.0
Message-ID: <gsntk006968w.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 12/16] KVM: arm64: nv: timers: Add a per-timer, per-vcpu offset
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

Marc Zyngier <maz@kernel.org> writes:

> diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
> index 62ef4883e644..e76e513b90c5 100644
> --- a/include/kvm/arm_arch_timer.h
> +++ b/include/kvm/arm_arch_timer.h
> @@ -29,6 +29,11 @@ struct arch_timer_offset {
>   	 * structure. If NULL, assume a zero offset.
>   	 */
>   	u64	*vm_offset;
> +	/*
> +	 * If set, pointer to one of the offsets in the vcpu's sysreg
> +	 * array. If NULL, assume a zero offset.
> +	 */
> +	u64	*vcpu_offset;
>   };

>   struct arch_timer_vm_offsets {
> --
> 2.34.1

This pointer isn't initialized until next commit and this commit is
small so I think it should be merged with the next one.
