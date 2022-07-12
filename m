Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC385711CD
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 07:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiGLFXN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 01:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiGLFXJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 01:23:09 -0400
Received: from mail-vs1-xe2d.google.com (mail-vs1-xe2d.google.com [IPv6:2607:f8b0:4864:20::e2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C5731202
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 22:23:08 -0700 (PDT)
Received: by mail-vs1-xe2d.google.com with SMTP id 185so6818170vse.6
        for <kvm@vger.kernel.org>; Mon, 11 Jul 2022 22:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/VRajJxNUiS0mp6F6S2buQXRTsevV7rowOUF5aBZsQI=;
        b=OiSBox2sJ0e0F+m7zahTrJvpzUBmI5f3RMcKq0nC8srWH3BPfHFA5bvqMMIihpfXxR
         aK7vrYOk6hDw41MycU0xQYZtUSzKVo69UYBJvJ/H091shMkEcLzTCRroVEf7VLNN02I6
         /WT+nthsAqircmH+X5S9FLhM3WmMGDKhyC0nTSNHHTHEQP+0AbUMFIqdCampj+p5WvMo
         /KnLTr7K3MeSfdrj0b25WqEGJ1Pl6t0M8TqzCK3UpZltOGY6N1R85kcuZMkZVe4KaShd
         tPvoWhQc12doCLTJmUQRbTbB/LMLUUuCNpC8ZPe/BG3b0QppKBz43qT4AUA3fSFd32uZ
         ly2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/VRajJxNUiS0mp6F6S2buQXRTsevV7rowOUF5aBZsQI=;
        b=eoQs+z5mCl0TJKFGi7/xsQBQEv7j/WrUpjbR404wVlcJz6tkinb0DYHAVQO1Az96IW
         PH7YBtsWkaZwFhl3QDLWYzYltqDCqB4fRqmgpl6cip66MqYi5Oltou2AsfLSYUyvL8D/
         GL+OIhVi3RJYfLyk96kX00MmwZ00htzO9oqk/6QCQRYgVxmwp5fCIiVJlw6ZJLhZ6Gsa
         4/fF6wyz6UttCa+ddR6Om4VjHRhvjFzf0oromEH/Smb1qJW7NNPoTbFC6llipP+VnrcL
         pyq7cGJvQrXtMPutZYZjLTumtfBOtoxsTTev3Z2Kr6aQzqDoB48GAbq3igMNbrpmNY+K
         7meA==
X-Gm-Message-State: AJIora9cmPRulYXeNKNcU9A5cU4s69W1/PonNykimU/96IC75Zz/mPSD
        h7UwUuvjeIuLf0zKCG+qgQx+y6OP0mSbFgovjubdi35CSMI=
X-Google-Smtp-Source: AGRyM1taYhdOJ76KHhu1hfwHJcpNMUoDVUHGja8vLOMJi5jaaNCuKYH76aur5PS3Rq4Q6Zx/eQJbN10MhL0nB2tD6bo=
X-Received: by 2002:a05:6102:2126:b0:357:6663:a469 with SMTP id
 f6-20020a056102212600b003576663a469mr2600597vsg.58.1657603387497; Mon, 11 Jul
 2022 22:23:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220706164304.1582687-1-maz@kernel.org> <20220706164304.1582687-8-maz@kernel.org>
In-Reply-To: <20220706164304.1582687-8-maz@kernel.org>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Mon, 11 Jul 2022 22:22:51 -0700
Message-ID: <CAAeT=FwKmNfGZM7U1MHUsOcEBR2x6f3DgmpCyLW3wPydvswVEg@mail.gmail.com>
Subject: Re: [PATCH 07/19] KVM: arm64: vgic-v3: Simplify vgic_v3_has_cpu_sysregs_attr()
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Schspa Shi <schspa@gmail.com>, kernel-team@android.com,
        Oliver Upton <oliver.upton@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 6, 2022 at 9:43 AM Marc Zyngier <maz@kernel.org> wrote:
>
> Finding out whether a sysreg exists has little to do with that
> register being accessed, so drop the is_write parameter.
>
> Also, the reg pointer is completely unused, and we're better off
> just passing the attr pointer to the function.
>
> This result in a small cleanup of the calling site, with a new
> helper converting the vGIC view of a sysreg into the canonical
> one (this is purely cosmetic, as the encoding is the same).
>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
