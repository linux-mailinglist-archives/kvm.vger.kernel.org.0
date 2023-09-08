Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A44B798788
	for <lists+kvm@lfdr.de>; Fri,  8 Sep 2023 15:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241666AbjIHNAs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Sep 2023 09:00:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232859AbjIHNAr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Sep 2023 09:00:47 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CEBA19B5
        for <kvm@vger.kernel.org>; Fri,  8 Sep 2023 06:00:43 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id ffacd0b85a97d-31dca134c83so1915053f8f.3
        for <kvm@vger.kernel.org>; Fri, 08 Sep 2023 06:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694178042; x=1694782842; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vyqE/4f+pcS0/D+aGnrXy0k/CeoXT9vuXK8tKhXEawE=;
        b=mKlX0iJlRLIn+wSL4xYyrDzcNP3vQEqcxCqDqJFGSUs8YXAYJ5oAHpE+EnKjn0GUBv
         3qrrt2xQL6jJZuxQuiYgQW6Lw2VF4QUgKsVTNejBzMznZjTM+x/LRNEG+17zN5tHgnG6
         MBTnCPwPbkldip5ZTSrd8PbL05dr/LP4oqOAgQqYJgM4Lu7ia45kziOnOChXaTITTRZo
         OODjZeclQg7V5ANC7CUuFsT5UTKQOvNPjRWJp9w0NxutbM9x/xXfUNwE3Q/nM6xfSRii
         NEradDalDhm18mpcf3S95/4nkyeAvfk8L6xXPFwznzgpOSjL+MrhV3P8uCHn1Soo9nmV
         roOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694178042; x=1694782842;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vyqE/4f+pcS0/D+aGnrXy0k/CeoXT9vuXK8tKhXEawE=;
        b=wWhdZ1TGM0vmTj/a2HFXapISxvhrNVm/xmiooShcJt1fQ6gVXxwI+K6e/xGbqxPqOU
         u8F+7OR+tzialR8ekub4O1yTtVoXCON2Ls6t2KV845+Qe+Y0FN1+SoVK3QNKarbvyCGF
         TNurFH7Vg3VViH688i4nf8Is3mU4oAH/9VK0OssC4KjM2sNbff0nNFa1EaaQxkIFgow0
         VK1WonoM5nte5SebD49jDmJ5H57hpA9UrYgGG79TRXdcKHYA252wUer8FxhzN+F4o7fN
         O4ZrNPd+WDlJiT2rIW1NFlHvAvEKp5C1wPQv3L3rgysEfytmiZ2aF5XSUF/btDFmB+e9
         X1/w==
X-Gm-Message-State: AOJu0Yz8bvKy6I9Y6sr2exmdFvRsFMcv9KXLpxJHcN4n+ctUTO3oL6jD
        5+frtZ0zYG+kaDU+Dzb8krtsl/SbXpBMjozfgOEDQA==
X-Google-Smtp-Source: AGHT+IGW9nyZnH9/LAXQvfyESQ5rz0/Ne+K2IyHeGWmVYxfsDCQQt18T54SFEO3B2qNdfZRtsi6hXlRB7tzplt4nGCc=
X-Received: by 2002:a5d:4b83:0:b0:313:dee2:e052 with SMTP id
 b3-20020a5d4b83000000b00313dee2e052mr2020172wrt.26.1694178041770; Fri, 08 Sep
 2023 06:00:41 -0700 (PDT)
MIME-Version: 1.0
References: <20230831190052.129045-1-coltonlewis@google.com>
In-Reply-To: <20230831190052.129045-1-coltonlewis@google.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 8 Sep 2023 14:00:30 +0100
Message-ID: <CAFEAcA9x9OwCEd5s+q-Sk6mY2LcdmVv=9bCMtF_Ah7d5BmvMUg@mail.gmail.com>
Subject: Re: [PATCH] arm64: Restore trapless ptimer access
To:     Colton Lewis <coltonlewis@google.com>
Cc:     qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Andrew Jones <andrew.jones@linux.dev>, qemu-trivial@nongnu.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 31 Aug 2023 at 20:01, Colton Lewis <coltonlewis@google.com> wrote:
>
> Due to recent KVM changes, QEMU is setting a ptimer offset resulting
> in unintended trap and emulate access and a consequent performance
> hit. Filter out the PTIMER_CNT register to restore trapless ptimer
> access.
>
> Quoting Andrew Jones:
>
> Simply reading the CNT register and writing back the same value is
> enough to set an offset, since the timer will have certainly moved
> past whatever value was read by the time it's written.  QEMU
> frequently saves and restores all registers in the get-reg-list array,
> unless they've been explicitly filtered out (with Linux commit
> 680232a94c12, KVM_REG_ARM_PTIMER_CNT is now in the array). So, to
> restore trapless ptimer accesses, we need a QEMU patch to filter out
> the register.
>
> See
> https://lore.kernel.org/kvmarm/gsntttsonus5.fsf@coltonlewis-kvm.c.googlers.com/T/#m0770023762a821db2a3f0dd0a7dc6aa54e0d0da9
> for additional context.
>
> Signed-off-by: Andrew Jones <andrew.jones@linux.dev>
> ---



Applied to target-arm.next, thanks.

-- PMM
