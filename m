Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F09A78E536
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 05:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239176AbjHaD7j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 23:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234565AbjHaD7i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 23:59:38 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1785CD6
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 20:59:35 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-52a4737a08fso361214a12.3
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 20:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1693454374; x=1694059174; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=32Wr8NYu6HSmc0mkG+FLn0sx5HN2+FhcGiqyKWtv7y8=;
        b=htestwlF5DdghKeMk3UrzsnxUWcimyGZy/IP4Q7RFYb6UbMedUrtqJVYqc5ISvSih7
         Vb4oBmZ/wFofHnzn4DdcW5c926kq1S/ajvZF3A3/kdZ+6CQ4tQHnpmz/FMsb3NkCRFgv
         Y+mte31bn0vurt2OIS6BnoCVBG+8c+H+IoChA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693454374; x=1694059174;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=32Wr8NYu6HSmc0mkG+FLn0sx5HN2+FhcGiqyKWtv7y8=;
        b=YBbbQ6+gOIdBkhnnYK5nH4zdnwmCGANLKEqSn0Wh2gHxlyUoA4DgkHOUAcVnicr1n8
         J0d0xuLQunyEj+dc3pUwUgvB+TizjI1xO8fgT7KNIbXYKTSQP0dCHz26USuyym8RnV1/
         EQhJk7PYIa6sTDLyosGlHrpjX4rj8o/RJ9b1LYp57LYxXb5fPbgZgE5pKLzNCWbiL+SE
         uvWeioXMK9mSwIQbGfH4+uTqOCQ/hn37Z+gvaxHZ4zmEfJZMvbbRjkxXeDadjPGqwXJM
         9iIvEdBTZMqx/3FRZCgBA7xfcuEsTxZplGaaxw6V9yKe1UAiyz7I+uo5uslxfq30I3Xo
         e0PA==
X-Gm-Message-State: AOJu0Yx9WDTsJ0mbAMadGEw4oVR4PdxNP+w1+P14YyxId29kzOKP+eXV
        TwBqH1pFeQNtq1GxqEC3TJtLPCAeKDwD9mi2SzE+AA==
X-Google-Smtp-Source: AGHT+IF77BwZKW2Ldy6N0/EGNmta9gD4pVPXBb8NDLFqeRxCFpG4plWmSRQRQhMAlRJRdi0k2CmQMw==
X-Received: by 2002:aa7:df87:0:b0:523:ae0a:a446 with SMTP id b7-20020aa7df87000000b00523ae0aa446mr3617157edy.24.1693454374069;
        Wed, 30 Aug 2023 20:59:34 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id h3-20020a50ed83000000b005236b47116asm296861edr.70.2023.08.30.20.59.33
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 20:59:33 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-52a5c0d949eso388912a12.0
        for <kvm@vger.kernel.org>; Wed, 30 Aug 2023 20:59:33 -0700 (PDT)
X-Received: by 2002:a17:907:7844:b0:9a5:c4ae:9fec with SMTP id
 lb4-20020a170907784400b009a5c4ae9fecmr3151324ejc.52.1693454372889; Wed, 30
 Aug 2023 20:59:32 -0700 (PDT)
MIME-Version: 1.0
References: <ZO/Te6LU1ENf58ZW@nvidia.com>
In-Reply-To: <ZO/Te6LU1ENf58ZW@nvidia.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Aug 2023 20:59:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg_L-97_06_ruO7xL7vxX4QpaqGQKw-6LtKAR_CB1cyYw@mail.gmail.com>
Message-ID: <CAHk-=wg_L-97_06_ruO7xL7vxX4QpaqGQKw-6LtKAR_CB1cyYw@mail.gmail.com>
Subject: Re: [GIT PULL] Please pull IOMMUFD subsystem changes
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     iommu@lists.linux.dev, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kevin Tian <kevin.tian@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 30 Aug 2023 at 16:40, Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> This includes a shared branch with VFIO:
>
>  - Enhance VFIO_DEVICE_GET_PCI_HOT_RESET_INFO so it can work with iommufd
>    FDs, not just group FDs. [...]

So because I had pulled the vfio changes independently with their own
merge message, I ended up editing out all the commentary you had about
the vfio side of the changes.

Which is kind of sad, since you arguably put some more information and
effort into it than Alex had done in his vfio pull request. But the
vfio parts just weren't part of the merge any more.

I did put a link to your pull request in the commit, so people can
find this info, but I thought I'd mention how I ruthlessly edited down
the merge commit message to just the parts that were new to the merge.

I appreciate the extra background, even if I then decided that by the
time I merged your part, some of it was "old news" and not actually
about what I merged when I pulled your branch.

.. and if I had realized when I merged the vfio parts, I probably
could have added your commentary to that merge. Oh well.

                  Linus
