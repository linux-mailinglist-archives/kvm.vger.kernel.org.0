Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFBD64C2C30
	for <lists+kvm@lfdr.de>; Thu, 24 Feb 2022 13:53:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233767AbiBXMyP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Feb 2022 07:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232323AbiBXMyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Feb 2022 07:54:14 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FB0020E5A2
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 04:53:45 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id v186so3631210ybg.1
        for <kvm@vger.kernel.org>; Thu, 24 Feb 2022 04:53:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GRBDVTzcuYqNGgw6Uwjpe8bJtuUyK1gPxnqjvDUw3sY=;
        b=mMrfglo5n+wTbPRSovXb4CuODGjWbQqENjwShu1rj4DQrWgRUEHFY/gxXNpdvCZaHB
         a1HMJQr2Exp7S3qkg3s3gR6+NVALnzdDhueHrnfV6U+TrDr7AkgNcrwjKiJqLq7U6XSE
         2n/d08WXuGExO8kGVJIhrxabgko3TkjbrWs5y0ESxpqyhWTF8Z6bOVrDTLgzuLeLviyb
         rPzAOuycbaWWlTyWj703HKbsSelB+Tm7EzllMQc36mazMfNgjTfbsoSOc7qfL9tkjCRx
         NsdGd5E1alKq0RWb32cgC1EpxmGsuKRmwelzI47FDHqNSxgzYPbg1ZjxTpqx/tJ8dZLZ
         wdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GRBDVTzcuYqNGgw6Uwjpe8bJtuUyK1gPxnqjvDUw3sY=;
        b=cHTdfzeqNLCNFjRTvKmfR6nbMmUJMs27jLrcHKiSIAhvKFoVklpdH58R/TL6b2GfXD
         AvCOGkYo0UJEsbgMeVLT0bYXiLUg6t07/IagW6zSDrKOeDJ0kZWEYLotsCuZQqA7nC9y
         fxGVj3tSEX/JXcrz3fbk1DLCVxyv/GpTB+N6AZXay1inZYrlT/3dw+4UzipNniHWuzrB
         lT1+UPXacthcXThIRFB5/6WcT/9Rqzd/gUM9HkLBCKIBQagyJengfOpCTSL7FlAdM/cE
         o5KdtJI+pcXMoPsHw0W0AegA5VK40jO3UQ7t9kHyCPh6rPhCAVl5GEHBpAMZxb1NTW88
         gVJw==
X-Gm-Message-State: AOAM531/hBWAVMc8qus/6bDiWDH+FGGbI3feH2fUO2uhmiZ5tK/KkECF
        eMSJH++vCeW8EUT5g4sLk1cZpgCP9ZsT8sWgCtXGW90Q/uM=
X-Google-Smtp-Source: ABdhPJzSbdZNrPR6oefMAKAEMiILHM9FCzkK5Z2IeEfDhOl9KuqVD8IOjjXQzEp9vQmzNcmPhdlgxatAachlPLJRwVQ=
X-Received: by 2002:a25:69c4:0:b0:624:4ee4:a142 with SMTP id
 e187-20020a2569c4000000b006244ee4a142mr2290233ybc.85.1645707224336; Thu, 24
 Feb 2022 04:53:44 -0800 (PST)
MIME-Version: 1.0
References: <20220213035753.34577-1-akihiko.odaki@gmail.com>
In-Reply-To: <20220213035753.34577-1-akihiko.odaki@gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 24 Feb 2022 12:53:33 +0000
Message-ID: <CAFEAcA9eXpxC7R_qcDsBh4C9Aur5417kTzAhs4c7p2YRCFQUKQ@mail.gmail.com>
Subject: Re: [PATCH v2] target/arm: Support PSCI 1.1 and SMCCC 1.0
To:     Akihiko Odaki <akihiko.odaki@gmail.com>
Cc:     qemu-devel@nongnu.org, qemu-arm@nongnu.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Alexander Graf <agraf@csgraf.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 13 Feb 2022 at 03:58, Akihiko Odaki <akihiko.odaki@gmail.com> wrote:
>
> Support the latest PSCI on TCG and HVF. A 64-bit function called from
> AArch32 now returns NOT_SUPPORTED, which is necessary to adhere to SMC
> Calling Convention 1.0. It is still not compliant with SMCCC 1.3 since
> they do not implement mandatory functions.
>
> Signed-off-by: Akihiko Odaki <akihiko.odaki@gmail.com>
> ---

Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/7.0
for any user-visible changes.

(I noticed while reviewing this that we report KVM's PSCI via
the DTB as only 0.2 even if KVM's actually implementing better
than that; I'll write a patch to clean that up.)

-- PMM
