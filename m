Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC7F5B278D
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 22:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiIHURr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 16:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbiIHURo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 16:17:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EDB1023E8
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 13:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662668262;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GikWZTxGj/63HCy54SuFQr3ZFtzXKVCYYeh8Zi7wQj0=;
        b=U02Fhotg7k3Eif9SK5G1Ig0XagEX1Y5qJStZunD3b+Qn7qEzFvdPzwzLxYbdEeMuged5JU
        0d3UjXkIaQzg1MJjPsy8BzVODxM9ZxWI8JqJitbpwSzljjexwqCxWyIafjwDwvrUexfNmr
        cNTYx5WnmvKeriJURw3c+k58PUEMGg8=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-127-tN40IVbANYeMwIuC30XqLg-1; Thu, 08 Sep 2022 16:17:40 -0400
X-MC-Unique: tN40IVbANYeMwIuC30XqLg-1
Received: by mail-il1-f200.google.com with SMTP id l20-20020a056e02067400b002dfa7256498so15712964ilt.4
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 13:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=GikWZTxGj/63HCy54SuFQr3ZFtzXKVCYYeh8Zi7wQj0=;
        b=2+wmD/4s/Tn/5aTCfDtgm2WQpcJjEzoWVBAg2xirBn1JqiTfHWGsxecf/Ip4WsKEJP
         vaR4RoHmq9pVKnp+qvHDheiwo/k+ZoPqadVGB+Cqp6A38eMx4ndPUpUjWXTEZ5omVBJm
         sDpI9yxqbP6LozL+5j6akV8iAbibkUOOOtC8sIVp+yzxCggIM7q+JGlVeJqTwl+L4mei
         doxjyV2DoEmL36dEVwQE3bRrbiWcPGsur+K98GwVl79GX5FVCyTwxYZ5ok//IdqRnKZ6
         OgcuspcuI049WbyPjcwMi64BBJv+skeSpPWvMZ9axF2cPNx8jjTP6EfYA6aFeILnwnFk
         2eow==
X-Gm-Message-State: ACgBeo3SjgGmt1vC4rbJVutsehwYHNg3XRtzmON/re2ph5Y8RsMUD9LN
        TbseoJZG9h+E84L5AqHKbr6Zms+Y+xbG05yxkOUCtGA08+urEYwVef7oU9UiOFTQ+OvyUI1m2tP
        z3T3CEwDSOEZB
X-Received: by 2002:a05:6638:1450:b0:346:8a18:737c with SMTP id l16-20020a056638145000b003468a18737cmr5866072jad.149.1662668260203;
        Thu, 08 Sep 2022 13:17:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4bf3RGZy+4hv8eZB5owi2SQBjkJww84tNK4SaY69049bB9OXpEkDKFHS1lXlnWgZWIpF29XQ==
X-Received: by 2002:a05:6638:1450:b0:346:8a18:737c with SMTP id l16-20020a056638145000b003468a18737cmr5866067jad.149.1662668260023;
        Thu, 08 Sep 2022 13:17:40 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id p5-20020a02b005000000b003583d27d258sm1125812jah.105.2022.09.08.13.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 13:17:39 -0700 (PDT)
Date:   Thu, 8 Sep 2022 14:17:33 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3] vfio/fsl-mc: Fix a typo in a message
Message-ID: <20220908141733.1af63ac3.alex.williamson@redhat.com>
In-Reply-To: <a7c1394346725b7435792628c8d4c06a0a745e0b.1662134821.git.christophe.jaillet@wanadoo.fr>
References: <a7c1394346725b7435792628c8d4c06a0a745e0b.1662134821.git.christophe.jaillet@wanadoo.fr>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  2 Sep 2022 18:07:54 +0200
Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> L and S are swapped in the message.
> s/VFIO_FLS_MC/VFIO_FSL_MC/
> 
> Also use 'ret' instead of 'WARN_ON(ret)' to avoid a duplicated message.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Changes in v3:
>   * Remove WARN_ON() and WARN() and only keep dev_warn()   [Diana Madalina Craciun <diana.craciun@oss.nxp.com>]

Applied to vfio next branch for v6.1.  Thanks,

Alex

