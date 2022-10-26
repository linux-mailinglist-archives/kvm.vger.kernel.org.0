Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54DC260E9A7
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 21:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbiJZT5U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 15:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233935AbiJZT5T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 15:57:19 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E753B98C
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 12:57:18 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id r12so14753605lfp.1
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 12:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Ti3WZ50Swd16DVe3SwAW+SLNzNpIEMNp9mQWvKMEBVA=;
        b=kr86P5ci420kas0qaPRim9p9fUq4yQVJgwD75i/KcdQMXlJJE9ZFenB7OXO8TGC1QX
         GpzOi6jyOK88Hst6iVrvyFkbOpRJWEocFCORXdbh5CToOWcYa1Wy9k3GLBVhPy8S4lxk
         14y4smbVktlQYgD13geXWfVs7y8lzJHAetx54BjO+MdqISXxkw553AGB6WNkP6jAXGu3
         ZK2ahHmWuMSKP1GXo/NQV3qWRwuozkTwVy+wDCnn5TtIDRqXNabkgr0Rw4H5Flymc4Te
         aynndIB283pTMOSKXIMcd64HdQXXenSz15M7Siq3Jt8WxLLymke38VPeuZ8Vtcv/z6HF
         jKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ti3WZ50Swd16DVe3SwAW+SLNzNpIEMNp9mQWvKMEBVA=;
        b=hT0aBt6JVUG+8sDyeEv1sW1yCzkoUa/d4s1DCBdG03i3OGa7YP0tyQvUUrNh90f1j5
         C6mAB/I92fpRwimg+xGaS0puAbm8oc3/MF6P9zLu4CP9lVuXPqInTItsayeup0WH8upe
         y+5192W9OqwyLqiJOBaBOvRocLzbpTMd+iZHKERUmmas1ApIP49L1HbHYMwoXDL9Wtku
         nfmZQGcAgdW1iHSteMzTZfikWI0W7EJx/LK+ymO2hZvjx6f450rwDe2EzcWHZAp8EoCq
         laegz1gfKG3KICaEBUT2jz9XpEiQiVb1tuB6KjiwGRSPVtU8sEq8MFEtF2D5j8Es/ldA
         qBzg==
X-Gm-Message-State: ACrzQf3VusasSTxC7EyIj8wb0wbAFXn56Z3jnHWnVDFr/oaopBGhdTIj
        ZZLkoHGpO9FmEcMSPtU0qI57TLAUE95+YKEe7lE=
X-Google-Smtp-Source: AMsMyM5xPXoepQ49pcNkUH4mx7Sk6HS89XW5JvjW85zMmmel+UxNOk552j59bi90n56q5blr/JTorUW5ornUF2iJ06g=
X-Received: by 2002:ac2:4e07:0:b0:4a4:841c:52d5 with SMTP id
 e7-20020ac24e07000000b004a4841c52d5mr15863163lfr.443.1666814236796; Wed, 26
 Oct 2022 12:57:16 -0700 (PDT)
MIME-Version: 1.0
References: <20221025193820.4412-1-ajderossi@gmail.com> <Y1kY0I4lr7KntbWp@ziepe.ca>
In-Reply-To: <Y1kY0I4lr7KntbWp@ziepe.ca>
From:   Anthony DeRossi <ajderossi@gmail.com>
Date:   Wed, 26 Oct 2022 19:57:05 +0000
Message-ID: <CAKkLME3O0a=6aS-Qc8MbuihcTjirGWY5gYAFxsAkELgcBts4Kg@mail.gmail.com>
Subject: Re: [PATCH] vfio: Decrement open_count before close_device()
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kvm@vger.kernel.org, alex.williamson@redhat.com, cohuck@redhat.com,
        yishaih@nvidia.com, kevin.tian@intel.com
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

On Wed, Oct 26, 2022 at 11:24 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> I think the best approach is to change vfio_pci to understand that
> open_count == 1 means it is the last close.

Thanks for the feedback. I sent an updated patch.

v2: https://lore.kernel.org/kvm/20221026194245.1769-1-ajderossi@gmail.com/

Anthony
