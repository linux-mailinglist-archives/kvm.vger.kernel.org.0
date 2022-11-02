Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B226C615C13
	for <lists+kvm@lfdr.de>; Wed,  2 Nov 2022 07:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiKBGIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 02:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbiKBGIw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 02:08:52 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076E02DCE
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 23:08:52 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 66so3183590ybl.11
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 23:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=il3ZtgB9NYdWIwujqVE/vtr81bmPbSm84N+bXazElYg=;
        b=fftlL88Wv8/qPfZnbBzDzMgp5h6lVzMdFbRl5BRihlBKdZ1vKITnIaRtBExcXtWmHw
         WigSdxy9U+mfehPYCQrugJBBZzTOxZ7iyO5tqpKfD10QOfqRiSco1bWgFwr/Wn4mWkA9
         AEUGlScfBPBKPu9gSLoYP9RTwDisuBJV+s5a1qEGsN7HyAXbOu4PiCnHeiXUqb+J/UNo
         pFYsAw2Lxny1OXK/nUiJiD0Urq+hXpglogvP2+hpv/MnA0V8S1X4VJIB9Ul6wU3H6nW0
         AGxN/cIPbOtM7NiF/efsaBmyNWgmGnY8aQcFIHyXeUVLXkO6nEYNlR4uS1F7evLLJLQY
         2RrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=il3ZtgB9NYdWIwujqVE/vtr81bmPbSm84N+bXazElYg=;
        b=Me7dtNgtPX93RrfadBtEaKhjomYbsa9hNJVDb+yDIVDD3ENV/gt2FY86gnKIlRQTE5
         K1ytmxX23/z1WC31S0Cnxhou3Jxnphsn1I+Eocnqz7y4fa6y/9V9ZNmhrJuzhV8VOnoq
         i+VGQ2edGwMjQ+NZMD1XHUlOGKYkj0KGiAfV1xdbT7/HAe6s7KBdTSwSuaeRluels2FL
         gKI+9PaVvZVkR88h4J/S9dXLxFstR8VeFK8bRzlOkLZTW1zhFm9/1CZBMNeFM/TuHw1k
         HvrvCR09aaTcdeRsOTNa6q7iHJRJLaJ+W8GHCZRWD8EIhLUSmXb0bNnAeyr6c5GO/296
         RWBw==
X-Gm-Message-State: ACrzQf2ysZl+XCrgu0tv630g10EIak8O5zKBM7nSJu60E6mMGk7hWkwN
        tgj8ngvJHODxO5X6/XNPkYMa3UjnjqBonKNUx/8=
X-Google-Smtp-Source: AMsMyM6rJK3is5x2YFhhuabozPugUh/IWXlyX1Z9cH2QR6+paR3btvK8YHaMYzbkI84TSlhS6cm8GT7RnOo+i2ryL0U=
X-Received: by 2002:a25:23c9:0:b0:6ca:15ee:3b92 with SMTP id
 j192-20020a2523c9000000b006ca15ee3b92mr20865257ybj.107.1667369331302; Tue, 01
 Nov 2022 23:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <20221026194245.1769-1-ajderossi@gmail.com> <BN9PR11MB52763B921748415B14FFB57D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
In-Reply-To: <BN9PR11MB52763B921748415B14FFB57D8C369@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Anthony DeRossi <ajderossi@gmail.com>
Date:   Wed, 2 Nov 2022 06:08:40 +0000
Message-ID: <CAKkLME1vg4kJNzs4y7Z18EHPspGaoJmhPV7hKjHLy=VsFpxhhg@mail.gmail.com>
Subject: Re: [PATCH v2] vfio-pci: Accept a non-zero open_count on reset
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "abhsahu@nvidia.com" <abhsahu@nvidia.com>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 1, 2022 at 8:49 AM Tian, Kevin <kevin.tian@intel.com> wrote:
> WARN_ON()

I sent an updated patch with this change. Thanks.

v3: https://lore.kernel.org/kvm/20221102055732.2110-1-ajderossi@gmail.com/

Anthony
