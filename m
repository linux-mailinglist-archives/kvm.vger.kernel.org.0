Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02E16DDE49
	for <lists+kvm@lfdr.de>; Tue, 11 Apr 2023 16:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjDKOmT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Apr 2023 10:42:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbjDKOmS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Apr 2023 10:42:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67FF172A
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 07:42:15 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-94a34e3526fso201740266b.3
        for <kvm@vger.kernel.org>; Tue, 11 Apr 2023 07:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681224134; x=1683816134;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9tYSZk5Fru65LRrfi4OzRnhB9ZIK2giLFVk4/qJWImA=;
        b=T+jx+WTwC0g+vBbHREBhA2xOIiJV86ufATNu650Y6l6b+rx8vtHkJhw9CJ9EdUG4pQ
         THGoVlE2mDqkCZYBLvqz161+oQxMjSkESZqVYdUUtL8CuRYyeCTWSHttTQ30kh4mFmn6
         qZSEJJ3mkWemH9xpYviiTHSt9+D6tlKSPycapUL4+yCg/I5ty9kqy/xK/+XQYWitj9NV
         +HV3t/WmxHNUpsRLJzUpP5LQj7ylkbGHBqmW+sFiySUz670gZmz0cJWzHzC9f14+nc7E
         m+ekZxDD70P7kx2Cut7MDxCpo/ijrsDfG6qZuDIHzgpZnqbO2G8Lmqbdzm3khHma5kQI
         bCew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681224134; x=1683816134;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9tYSZk5Fru65LRrfi4OzRnhB9ZIK2giLFVk4/qJWImA=;
        b=uEAEHNr2cTevXwFxXslw18Q6JxSfxi4qkOK9cC2cfuVTNHL3PLhrBD9WPnvaNhzD1a
         l5ra36KwSl7hJKC20qLNbpPJyArtCpRLpSm6f0xIl1NI81m7OrE6v3H1VGNQEjZYVCUz
         RrtobjqUJACMfRVM+cq4LPzhtj4wlG+XVxpSzdM6PSeLhrXbmXNvtg/brwRr+hbqScxz
         V2IhUZLovo2t+COUJ3I2k8aCXN6N5ID1HKT9R7I1s0yklba1FggLTSLaW50lwMRJnxsI
         3OCcv5YDgBCBxnPTcF4XnyoGL6XBYBeTwUVWmGeAMWcCvCYVdzFOKWZFMoqAkKjqDos/
         n9KQ==
X-Gm-Message-State: AAQBX9fbKhwKVlPp3O9KFSKvsZ/r74o3187xUSrbld3+9bQah5wRODp/
        ZY7Py745r66fyne0MJXb5wn8Mcu2SsnWmNEsDK0FkA==
X-Google-Smtp-Source: AKy350YzGJ8pgn67PmNpUk3zu304rvFvrN7yIz8E+p6w9O6GCoQebsWp7MKRziyJUsvy9AQ1o7l7V8XOKYmldgVnGuo=
X-Received: by 2002:a50:9fe1:0:b0:504:87d8:ac39 with SMTP id
 c88-20020a509fe1000000b0050487d8ac39mr1365390edf.6.1681224134171; Tue, 11 Apr
 2023 07:42:14 -0700 (PDT)
MIME-Version: 1.0
References: <20230405070244.23464-1-akihiko.odaki@daynix.com>
In-Reply-To: <20230405070244.23464-1-akihiko.odaki@daynix.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 11 Apr 2023 15:42:03 +0100
Message-ID: <CAFEAcA_Ge0HX28qs+08h+k4GBWhNd6367grCdXgPupB46O+aHA@mail.gmail.com>
Subject: Re: [PATCH] target/arm: Check if debug is already initialized
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 5 Apr 2023 at 08:02, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>
> When virtualizing SMP system, kvm_arm_init_debug() will be called
> multiple times. Check if the debug feature is already initialized when the
> function is called; otherwise it will overwrite pointers to memory
> allocated with the previous call and leak it.
>
> Fixes: e4482ab7e3 ("target-arm: kvm - add support for HW assisted debug")
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  target/arm/kvm64.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)

I think I agree with Philippe that the better fix is to call
kvm_arm_init_debug() from kvm_arch_init() -- if we avoid
calling this for each vcpu then we don't have to carefully arrange
to ignore all but the first call. We never actually care about
the CPUState we're passed in, so we could instead pass in the
KVMState directly, which kvm_arch_init() has.

thanks
-- PMM
