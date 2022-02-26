Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06EF74C5263
	for <lists+kvm@lfdr.de>; Sat, 26 Feb 2022 01:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239984AbiBZAFb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 19:05:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239844AbiBZAFa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 19:05:30 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468AB1EF350
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:04:57 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id v186so8938369ybg.1
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 16:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xh2DfY71AEL+z6I0W8RmqNYIDvyBELhMm6wEeHMpm9I=;
        b=DFOdIhRAXQYYVJ4uRC/w9xr6CCX/DhdB2qSGcgW150f0vhQiE2KUQmV8+HAnUSPh7l
         qgmYEmMmJtsZcEBjLx2aBVMMKfs/Y0dToxRTWNGGsc1ypxPqCibVrSKMahuECCDZQCdB
         BYTlhetQmZxFYBHIu2zHAjXzE01f9MPZxoGx3uOg/e4tNgsQDj2CRletALHvfsw8Tg7x
         1WPHe30IaKE65aElQF5Up/ffyziqQI/7rUXzKrmYYTGGxXgbYRMthAl0rhYg2bna/XMC
         3MrcG/odaEh0CPnCzL9rW0TdWMcDWjUdz7Y4/FrWlBuZ2toujCbwlYYVF4j4L/RGyOu5
         yCtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xh2DfY71AEL+z6I0W8RmqNYIDvyBELhMm6wEeHMpm9I=;
        b=nYsFx4eeS3v1Yacc25/+qaVXxlgKU3HHLpdjZ4YosclrdNJNPPlqQ+8DMogOzKtW4+
         tuPgk+4VkBNbjxMxhlaR6gLhiVnK0RgB2mLYjbmr0lyNdreT+oLc1YbkdPHadndYPfhn
         B8Y/ICBgniyc6iV5fH5Di+1peYxylfWooJz8L1Fz+bBm2rvQvBGAf4pxS5Y/Ll78+xFS
         vrTIv49+XuYVX8/5xCrysuAtSEmGfxEx0fNCzHBmJ+VflACwI4JYJQzItkVp2T7UqKFa
         cHNI7s04anPWffk7kNO80yevKDVovZ+M4SK77PKKso0zMB+7dqSaGKD1zwHxcBQ71P+M
         up0Q==
X-Gm-Message-State: AOAM53050MOdire/DDuEKl39bry7CUTaW9Xf7b+Alr3VoCkJtcKXSt0D
        D9vUbq9DNmINh+ZXs7htGS2ZqGTf+weWX1FITCA=
X-Google-Smtp-Source: ABdhPJydOKc18n0KWe0quMXK5jcP0sJmGXX298q0yZbR+l+DDabiqzV7ryWv3mi6GZsLC7DMVc8RhbTF4MHfPH2lIhU=
X-Received: by 2002:a25:4097:0:b0:622:986e:81b0 with SMTP id
 n145-20020a254097000000b00622986e81b0mr9386219yba.138.1645833896564; Fri, 25
 Feb 2022 16:04:56 -0800 (PST)
MIME-Version: 1.0
References: <1645760664-26028-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1645760664-26028-1-git-send-email-lirongqing@baidu.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Sat, 26 Feb 2022 08:04:45 +0800
Message-ID: <CANRm+Czf8Ge4cMKrccq5yEbR=_bsCr-OxXpy0RVV4uk5vxR5yA@mail.gmail.com>
Subject: Re: [PATCH][resend] KVM: x86: Yield to IPI target vCPU only if it is busy
To:     Li RongQing <lirongqing@baidu.com>
Cc:     kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 25 Feb 2022 at 23:04, Li RongQing <lirongqing@baidu.com> wrote:
>
> When sending a call-function IPI-many to vCPUs, yield to the
> IPI target vCPU which is marked as preempted.
>
> but when emulating HLT, an idling vCPU will be voluntarily
> scheduled out and mark as preempted from the guest kernel
> perspective. yielding to idle vCPU is pointless and increase
> unnecessary vmexit, maybe miss the true preempted vCPU
>
> so yield to IPI target vCPU only if vCPU is busy and preempted

This is not correct, there is an intention to boost the reactivation
of idle vCPU, PV sched yield is used in over-subscribe scenario and
the pCPU which idle vCPU is resident maybe busy, and the vCPU will
wait in the host scheduler run queue. There is a research paper [1]
focusing on this boost and showing better performance numbers, though
their boost is more unfair.

[1]. https://ieeexplore.ieee.org/document/8526900
"Accelerating Idle vCPU Reactivation"

    Wanpeng
