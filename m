Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEEA77CD1BC
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 03:17:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344392AbjJRBRN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Oct 2023 21:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344371AbjJRBRL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Oct 2023 21:17:11 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A7BFA
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 18:17:09 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1c9e0b9b96cso44699285ad.2
        for <kvm@vger.kernel.org>; Tue, 17 Oct 2023 18:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1697591828; x=1698196628; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3n3bprVeIQuT2Ng9Lf574qnCGv4o8+z0VKTT/COmX9Q=;
        b=KmHbK/G2xmikzjtcHD7dGMJdB8+tRHOpRptRNALPHyL2DYqRgOH1bMIeGUqK1EbOGP
         4to8W9LqBAcFOwilHbSGVGTEi587ddTy0EQOrVOWET1/H4QeGAC062OMsd/CHUpWES8y
         nWAh21q4LbZpK+VPwFb9Ib92KqvgZzqYj807pOIph20AD0SItjG/cLyBKCaG+GB5EeQ8
         ZdZbswWNo+UUBxT3LC3Jf6+hjZU9GO25jQjV0LIrgeOJA61S7rmgPFyuQvfPq4XNRMYg
         dlThAVfEkhPELdowbkI5Q2ozJEX3HWN+qpfgkwpb+vZOOogRN7NAkRf3V8ViPKhyeMCa
         B+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697591828; x=1698196628;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3n3bprVeIQuT2Ng9Lf574qnCGv4o8+z0VKTT/COmX9Q=;
        b=oavjoIW88UMWNiyyNsEGiEPEmMzYDB39lOdS/VdPcIX2T66sa1p6kDzG46TSUGkp6b
         sAQaTh2zsT2FVQzDEwYPFD2pQip87BuPd6PNksZg5J8sqZP4yqa8p82Gq27H2DJjDDuo
         fWWZ+Tl7Nd54y+pt738cLwli4A9dKzZyrQNDKnOLq+G3MhzzlSNmZMI9zF3nNa0xcSIB
         Itm32mF49PZDb8oBCxLzfeyaAgKKAqNl6prATY1ZYriCK0/st/h5ARu72Lii+3Drxfkb
         RzhPfvBWStuudqBFhcBE4tIIsk0cE6wp9U3ujLjOuCpkNxH7Svh5FxOR6tjA445OqG4o
         yDkA==
X-Gm-Message-State: AOJu0Yw4V9gy1LeDJqj+Jm2C+ZrLRbVSToFbfSKPaRujDlytB5BkVxb8
        xP5lqBAJTVfqM0TSbUsBeESZgAhx9A0=
X-Google-Smtp-Source: AGHT+IH/h6VBuLNlyY3uWvKQWh9avfftGmDa316dg+vgdu/+7muqIhPyBmlDCjLij/7M4rsy1Exn781Z6iA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:f14c:b0:1c9:dbcf:a87c with SMTP id
 d12-20020a170902f14c00b001c9dbcfa87cmr63061plb.3.1697591828655; Tue, 17 Oct
 2023 18:17:08 -0700 (PDT)
Date:   Tue, 17 Oct 2023 18:16:20 -0700
In-Reply-To: <20231017155101.40677-1-nsaenz@amazon.com>
Mime-Version: 1.0
References: <20231017155101.40677-1-nsaenz@amazon.com>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
Message-ID: <169759163972.1787364.3932584247097617727.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: x86: hyper-v: Don't auto-enable stimer on write
 from user-space
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc:     vkuznets@redhat.com, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, graf@amazon.de, rkagan@amazon.de,
        linux-kernel@vger.kernel.org, anelkz@amazon.de,
        stable@vger.kernel.org
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

On Tue, 17 Oct 2023 15:51:02 +0000, Nicolas Saenz Julienne wrote:
> Don't apply the stimer's counter side effects when modifying its
> value from user-space, as this may trigger spurious interrupts.
> 
> For example:
>  - The stimer is configured in auto-enable mode.
>  - The stimer's count is set and the timer enabled.
>  - The stimer expires, an interrupt is injected.
>  - The VM is live migrated.
>  - The stimer config and count are deserialized, auto-enable is ON, the
>    stimer is re-enabled.
>  - The stimer expires right away, and injects an unwarranted interrupt.
> 
> [...]

Applied to kvm-x86 misc, thanks!

[1/1] KVM: x86: hyper-v: Don't auto-enable stimer on write from user-space
      https://github.com/kvm-x86/linux/commit/d6800af51c76

--
https://github.com/kvm-x86/linux/tree/next
