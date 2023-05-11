Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AACE6FFBC5
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 23:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239259AbjEKVTa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 17:19:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238915AbjEKVT3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 17:19:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252B72D62
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 14:19:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-b9a7c58ec19so10954865276.2
        for <kvm@vger.kernel.org>; Thu, 11 May 2023 14:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683839967; x=1686431967;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Oc8hUlEPkHXHpIXaObZi2PEY2szZrP2OC/2zdz9YSM8=;
        b=GBOsY0xKh32hZmAjiI+2tIEUFpP/w98yvdkIkerE3xKnb7+LX9xcPEFSVNiSWHlUc6
         rzD2un+RgboQBATM0H/exrHiR42ToPnaprS6xWswb2JI3bwZ5m/+0pYb0WzH34hJnRyi
         SPpRJXrhk3jmV2CZbmcYhFZaLAR1PDQ+H8T/oE4Y1qS1oARGTGPUTfkm/MU08kmy5c8i
         +4YjORQ2CYwSntXH0PmZfwnu8m1Sz0YVFiL2MkOARE3T6hF2RZ4j/YUhAgeNPBMhilKy
         z/Tn7VHDkco04jkRjkQMqDwkoJxh5nCW1GQW1GO307PkmTU5GpFOYxXmL38XtisC59AO
         2Xvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683839967; x=1686431967;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Oc8hUlEPkHXHpIXaObZi2PEY2szZrP2OC/2zdz9YSM8=;
        b=eKRaX5Xsy2ztXTj/dbTcjNNuCuPZerW3utdtI6kC0hyXhk6kR87ZNEt0cBqfAD9hrG
         /R6WZ1IY4CE5D82U1vp1EulGwgAUkNOo1QEfVwTdZro6GX39hwTCHlt+51/OQGgMS3qN
         gOvsB5QyHFJwTxwon/+xO+/E603/k1yy3PKyfjrbqyJaf2Z9dGnr+GFAHBMwfgbWJAac
         BG0AQnZHaHDso1zglOaY/vG8eN68mDFIjvhN557Fnw6oS9d91OipHtbOvIr0iNHIwoOY
         Ph6/eHTUezqJPiCuhw3nQtASi/W/16QmYFIP3ZiBJqFXoNjRGl37axhP0kLSvm99IsDY
         6BMA==
X-Gm-Message-State: AC+VfDy3qABut+nr/vMeNrzgw0hTAWfVHShvkIuHlEdP2eCJQYUUjdyq
        +Gw5r+/Tn6c0E6trD/CTrkgW0YqpXrk=
X-Google-Smtp-Source: ACHHUZ4QUgn9SvBu8/bvMAP98JMZb8LOhazbEpwjq76h22pyaexHc3eakOAHRr8Tahs/rDdfmf0AHVNqN1o=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1890:b0:b96:7676:db4a with SMTP id
 cj16-20020a056902189000b00b967676db4amr14611706ybb.0.1683839967423; Thu, 11
 May 2023 14:19:27 -0700 (PDT)
Date:   Thu, 11 May 2023 14:19:25 -0700
In-Reply-To: <20230508154804.30078-1-minipli@grsecurity.net>
Mime-Version: 1.0
References: <20230508154804.30078-1-minipli@grsecurity.net>
Message-ID: <ZF1b3TVTibSbnHrH@google.com>
Subject: Re: [PATCH 5.10 00/10] KVM CR0.WP series backport
From:   Sean Christopherson <seanjc@google.com>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     stable@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 08, 2023, Mathias Krause wrote:
> This is a backport of the CR0.WP KVM series[1] to Linux v5.10. It
> further extends the v5.15 backport by two patches, namely patch 5 (which
> is the prerequisite for Lai's patches) and patch 8 which was already
> part of the v5.15.27 stable update but didn't made it to v5.10.
> 
> I used 'ssdd 10 50000' from rt-tests[2] as a micro-benchmark, running on
> a grsecurity L1 VM. Below table shows the results (runtime in seconds,
> lower is better):
> 
>                           legacy     TDP    shadow
>     Linux v5.10.177       10.37s    88.7s    69.7s
>     + patches              4.88s     4.92s   70.1s
> 
> TDP MMU is, as for v5.15, slower than shadow paging on a vanilla kernel.
> Fortunately it's disabled by default.
> 
> The KVM unit test suite showed no regressions.
> 
> Please consider applying.

NAK, same reasoning as the 5.15 backports.

https://lore.kernel.org/all/ZF1a8xIGLwcdJDVZ@google.com
