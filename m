Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B1A63EE13
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 11:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230394AbiLAKk0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 05:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230430AbiLAKkW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 05:40:22 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9259F4A6
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 02:40:21 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id f9so1307873pgf.7
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 02:40:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I2jo7y83izFT8U/cMcRzlh9hVnWmYlha3q23d81pN4Y=;
        b=nbc/sXBWRrAgCAF8x0vQ1K+VVuQ8NjFcBDcoa/RdVJ/vzbyeyYe+3UK/D9J4+J5GrS
         RFOxFuJUmspkzAuGnj9XqEVPz1yr+XVCe76AqWrljcgq78ZQhghlFbkGm8b51y1VPOgR
         OuHeDZZMitaEWqsT9aw7dYAAHKh0WI8un6d8ZI78b0BjAQ7A4wQOlMI0RN5/B966V1T/
         fqL6byOEbHlptUAfPlQc3T8dsghUDANhozQQ+l6aCfnMaA+WTK4mg21iWkL3Hdk8MVG9
         uTsYzOHz4wil3BmzRlUXQFZ6kMgNe62ugQNgizKYT1wpzoOeiuEGT3yxqcmxG1neYtTt
         Zcyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I2jo7y83izFT8U/cMcRzlh9hVnWmYlha3q23d81pN4Y=;
        b=Klo0a2NDElSvFjeWSKSRIsasE+rxK8wYITTfX0k5FpgPqOx8nbd7VDA5NI4A3NQIws
         rbowTqtuKactxoyi+EwPpBKUaGNISBhxhNmgYOIZQcFbt4Ac+yJBC/t+u5VxQ3CThakG
         R6au7bz5lmQbs+IsGA0pY4KsOM/UtUxJ0npeuSUoarPXGu643kgEiF1B9h2XoVpWXtmz
         ATpQhfgyQkTJhlsehmB90EDyHrYEzsni7CBQP0bosWj4v5UvL1NPQmEWKNDb11xGf/3m
         Mj+6Xq/jnwYIusVusWJCBir+MYLJ2QV/wlgoyhCImLATIOL8LeWInBb30jz7Y160tBjW
         e7pA==
X-Gm-Message-State: ANoB5pntmfBhhiELV3gtyxbbe4GNd0sMAWQvxkiCy5L4bd0LSLTzBEa1
        0hignEos0WXOxsME+xB8lq/mirblBhTN2qY8iqcnx7J0V6VhnA==
X-Google-Smtp-Source: AA0mqf6Mlnrb0uE2cPDRH6dLcIJ8i9Oxrrxl9T7qAbj3LxIyyYl0KuOh3Vxquo5HXz96iOpePo4w2YlOVRCMHqkoNGs=
X-Received: by 2002:a62:b501:0:b0:573:1959:c356 with SMTP id
 y1-20020a62b501000000b005731959c356mr47210272pfe.51.1669891221061; Thu, 01
 Dec 2022 02:40:21 -0800 (PST)
MIME-Version: 1.0
References: <20221201102728.69751-1-akihiko.odaki@daynix.com>
In-Reply-To: <20221201102728.69751-1-akihiko.odaki@daynix.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 1 Dec 2022 10:40:09 +0000
Message-ID: <CAFEAcA_ORM9CpDCvPMs1XcZVhh_4fKE2wnaS_tp1s4DzZCHsXQ@mail.gmail.com>
Subject: Re: [PATCH] accel/kvm/kvm-all: Handle register access errors
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 1 Dec 2022 at 10:27, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> A register access error typically means something seriously wrong
> happened so that anything bad can happen after that and recovery is
> impossible.
> Even failing one register access is catastorophic as
> architecture-specific code are not written so that it torelates such
> failures.
>
> Make sure the VM stop and nothing worse happens if such an error occurs.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

In a similar vein there was also
https://lore.kernel.org/all/20220617144857.34189-1-peterx@redhat.com/
back in June, which on the one hand was less comprehensive but on
the other does the plumbing to pass the error upwards rather than
reporting it immediately at point of failure.

I'm in principle in favour but suspect we'll run into some corner
cases where we were happily ignoring not-very-important failures
(eg if you're running Linux as the host OS on a Mac M1 and your
host kernel doesn't have this fix:
https://lore.kernel.org/all/YnHz6Cw5ONR2e+KA@google.com/T/
then QEMU will go from "works by sheer luck" to "consistently
hits this error check"). So we should aim to land this extra
error checking early in the release cycle so we have plenty of
time to deal with any bug reports we get about it.

thanks
-- PMM
