Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146BA68E5E2
	for <lists+kvm@lfdr.de>; Wed,  8 Feb 2023 03:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjBHCKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 21:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjBHCKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 21:10:46 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFACF410AE
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 18:10:45 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-517f8be4b00so162180267b3.3
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 18:10:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4dI1dLE9c0JEJEHlQtU3MKKZat0zt/lT6+w1+UkGkAE=;
        b=YZxmxsiCjTwKgEXmwcQRVkB9LyAmgXdGNaVmcI1mSK+azpNl/HdLoIo5PY0lYcoBFj
         sdgFOH4b7EdFyNoErgokiWHe2rncSI8IoRp74kh8v+zSYm3nuTShKbw81sOrlz4YvAGP
         tj6FJ9Pa/a6GUV8WBW5PsSNiLIT/x6PugFUDmS/aTBDGmbggdfUqzg4WztX+Ha/aI4v+
         vGLMmJI0lCRJpNiqZumYLQKuDZ5sAYGaTZIZcUNJPDnWQcOGv1fP2/lWfFRqNNVyK374
         GQy7Akg64bwh0xQGMwnidbfTXcmgOPAB8IiCafF6TWqKSbmtpLiF6gFztau2lYEmpoYa
         qbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4dI1dLE9c0JEJEHlQtU3MKKZat0zt/lT6+w1+UkGkAE=;
        b=M428VsC63vlFeTJT9Ol3Rh9w44MQT0dCikwiL9xUOcqPSCDK6fTnukJlesU+2g6ugY
         vqNlkoNRbcL7SlDDY1TcSjhcyPB1sKqIJe0EcxG9sf6i0sMOifJ2kKGpU7znw8SJ0R+9
         s6Y48/IU1SbqXuA3MviaLRjp7iIkK+Z5oZSXo2dw72PyULcGVmAk36zSwFUht43gfpfW
         c2e6V5oiEQ//QDp54Yyr8CQ8okwm2Zf+EAcHQSbS8dZiULH/4heuvSksB06VHQcNmVLZ
         elcLdiBCpvgdFadPf72ixtvVYf6CuGQIOLv3NBh1BbtJrL4awmUnhE7SgVSJg8S3f9sK
         oMaQ==
X-Gm-Message-State: AO0yUKUb9vAblBfaZgWqk1v7bwpIPUqywu0AQANeTjKCJ/VwaOECW1E2
        rNIu8jLUIIaTveCXqzNK7E0Gal018XE=
X-Google-Smtp-Source: AK7set9ko8ei1F48HvQladxcXhFwkQty+XkBNKk2Z7vG69UAELA8QCDoLV8nrjwwkd1gJb0P/bITYW2lfBM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:d794:0:b0:509:e6b6:3491 with SMTP id
 z142-20020a0dd794000000b00509e6b63491mr711776ywd.341.1675822244973; Tue, 07
 Feb 2023 18:10:44 -0800 (PST)
Date:   Wed,  8 Feb 2023 02:07:32 +0000
In-Reply-To: <20230111183408.104491-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20230111183408.104491-1-vipinsh@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <167582135970.455074.533102478332510041.b4-ty@google.com>
Subject: Re: [Patch v2] KVM: selftests: Make reclaim_period_ms input always be positive
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        bgardon@google.com, Vipin Sharma <vipinsh@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 11 Jan 2023 10:34:08 -0800, Vipin Sharma wrote:
> reclaim_period_ms use to be positive only but the commit 0001725d0f9b
> ("KVM: selftests: Add atoi_positive() and atoi_non_negative() for input
> validation") incorrectly changed it to non-negative validation.
> 
> Change validation to allow only positive input.
> 
> 
> [...]

Applied to kvm-x86 selftests, thanks!

[1/1] KVM: selftests: Make reclaim_period_ms input always be positive
      https://github.com/kvm-x86/linux/commit/4dfd8e37fa0f

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
