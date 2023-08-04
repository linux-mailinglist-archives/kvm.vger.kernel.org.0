Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 400BF770726
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 19:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232306AbjHDRcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 13:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231153AbjHDRcJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 13:32:09 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE80349F8
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 10:32:07 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id 4fb4d7f45d1cf-5230f8da574so2468883a12.3
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 10:32:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691170326; x=1691775126;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MKX+r86oN0XWzBbrq9duCjlqZuPPIl3Tcvsu5wC7wY0=;
        b=oBlzJZfKXxrC57AwjuPZQSBAz8jiFvzRojnOdvtJGsEAxcz3x41IBFrJvvQNDTSHzu
         LK+4y0gHDaqwI51+SPxRlMdeCHzwoUWOzU5WmGJNy7Lo9GwaQph0lBLQU7xAPXiZZ0Ja
         IIKO4E9uLXdE8LVQl2DbRcqteudF8ZV6i3yQ2Fw/PlRVwVPMHdTqLPEatJ3AXEZfGRuP
         fqm4+a2me8IX8NpI08TdAw8S8b+OH4Ox/picAA48zK+WipqDW/Se0maONzZeJw7TrNpA
         5RsQ2vEd1C/1k4Rdr88O6lc2bDQNNQoZIbSeglVKv6EwoLsofryrrGxdXzaN/LCUzrn+
         ArfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691170326; x=1691775126;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MKX+r86oN0XWzBbrq9duCjlqZuPPIl3Tcvsu5wC7wY0=;
        b=jbF7z6yRNSUGAMMV0KEUbD1iscOJKfrQ6Qpn7FZtC39CXAOEkTzeXEz2Sz9w+KKjyg
         14DbM3k9Srd7qrMB84NDzR0iuHxoIQacbz7df2CJhh901FHM/FKddyNAAvX59cQBE+kv
         eruFtCArgppcjndrA/HADCfPjtF0E1fqx+41WJ3YwfeA9EXqZBG1v5XEYnHRQPlEccck
         of4nivzWX+KiPl2K/1P74zAdQ352rpoR2lj6YyGym3FlBWRzaUqzMjM3wPRVQT2ujzcD
         RDyYmiU9C7+drxVg5VYi5N5uwWEuAKPqFZIwVMVbWDODlcqCOPYSOYAtaVOy5GASRQ/x
         R/Cw==
X-Gm-Message-State: AOJu0Yw+uzHCI5TuYk0Fs5kmLZsmhMN2LDrbnxRrHqc0EABD6SilV5LT
        mWt5Hnt6uW4fRy3UoY06vbUg2kOUeWJijm2WOBWLmQ==
X-Google-Smtp-Source: AGHT+IGdMfiyG++dzHGUSw/tvCVSSbUouSk5Pxs1nt1hiUSQ534dlVQfrvYDr4E9qUkx0O1kupyFg13HYb5RfFI+Fdo=
X-Received: by 2002:aa7:d745:0:b0:523:1400:2d7c with SMTP id
 a5-20020aa7d745000000b0052314002d7cmr1857681eds.35.1691170326260; Fri, 04 Aug
 2023 10:32:06 -0700 (PDT)
MIME-Version: 1.0
References: <20230727073134.134102-1-akihiko.odaki@daynix.com> <20230727073134.134102-7-akihiko.odaki@daynix.com>
In-Reply-To: <20230727073134.134102-7-akihiko.odaki@daynix.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 4 Aug 2023 18:31:55 +0100
Message-ID: <CAFEAcA_=ZK6vbq+73N_R3D1a--amOts71RjbjmmUUQ_yCS8bKA@mail.gmail.com>
Subject: Re: [PATCH v5 6/6] accel/kvm: Make kvm_dirty_ring_reaper_init() void
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 27 Jul 2023 at 08:31, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> The returned value was always zero and had no meaning.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>

Reviewed-by: Peter Maydell <peter.maydell@linaro.org>

thanks
-- PMM
