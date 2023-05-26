Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2733C7124B3
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 12:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243211AbjEZKbQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 06:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237005AbjEZKbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 06:31:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC35412F
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 03:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685097017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mg7/ojhaSlvyz/vXgtSMO2mGG83UKNLR01zwLceFGek=;
        b=PR3/v2wyPlKZZo07PDZ1HdjsbN6PI8ECQzOHpW0Z+EhRZ+LKP0BUc78v+EPOdJqHs+uVsp
        Spx5HdYtbIQ/YrdPXE4yZKnYhn2rpTy9yAyST5bpki19niORtia/skv+RbD6N8i+hiBA/o
        pkNTnuqEEfz0gvafR2sBq+eJKb+bsBE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-220-oqCU5hPLPi26vXe-FiHD3A-1; Fri, 26 May 2023 06:30:16 -0400
X-MC-Unique: oqCU5hPLPi26vXe-FiHD3A-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f60481749eso4002075e9.1
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 03:30:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685097015; x=1687689015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mg7/ojhaSlvyz/vXgtSMO2mGG83UKNLR01zwLceFGek=;
        b=kyNDRlYk9iqZKE/0ZhVnZW2DwbSJrClEPXmlqZuw7+YFtmXihmssUW6KI6TbSBixsQ
         /SKFTngBS0G/n49qlVD35kScX+pH5CuBafAXaMhIKOIbQIyvNy1rpsUGQMw9pKywRffE
         TVRkMiBp5Cub6upQGD02JCYbpADJrDzACcutaRQUcXnvGyPuWBYIBeXqHBoDpBSPyIli
         JsSSJQ3YZfi3O0Bbh8STtZAhhnoq3ytTFXMPlWnrgDRqTP2yw4Dz581zJxJDQmB9fXOv
         I+gjIPxHI0NXOQST6r8T2+5npXxu0Bv091PTMJqJLeZ0hqLlMvQm6YpOA4BgClkA2bb/
         n4Lw==
X-Gm-Message-State: AC+VfDxCFlWcwbzwcSK0vSlquDIVfzXLGMaZ3pLzp5E01P4nPvJs1jnb
        Q0N0smhSX4A4HoNSCcPy7niPSKY2IWdxLBs6xGOhT5YLLmCXD3SJePZrRVvlSINJuOu6muEADs+
        SX7ea/63xx2rD
X-Received: by 2002:a05:600c:3b13:b0:3f6:f81:385e with SMTP id m19-20020a05600c3b1300b003f60f81385emr4386156wms.17.1685097015594;
        Fri, 26 May 2023 03:30:15 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7azWOTs7u22NKP+c/72YjQZNnbnYXTsbR5Iqy6Gxd/0ppYvVT8VSjnd/KLYwpjJ1ml7uASbg==
X-Received: by 2002:a05:600c:3b13:b0:3f6:f81:385e with SMTP id m19-20020a05600c3b1300b003f60f81385emr4386137wms.17.1685097015327;
        Fri, 26 May 2023 03:30:15 -0700 (PDT)
Received: from sgarzare-redhat (host-87-12-25-16.business.telecomitalia.it. [87.12.25.16])
        by smtp.gmail.com with ESMTPSA id v7-20020a05600c214700b003f4f89bc48dsm8530412wml.15.2023.05.26.03.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 03:30:14 -0700 (PDT)
Date:   Fri, 26 May 2023 12:30:11 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <avkrasnov@sberdevices.ru>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Bobby Eshleman <bobby.eshleman@bytedance.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@sberdevices.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v3 00/17] vsock: MSG_ZEROCOPY flag support
Message-ID: <y5tgyj5awrd4hvlrsxsvrern6pd2sby2mdtskah2qp5hemmo2a@72nhcpilg7v2>
References: <20230522073950.3574171-1-AVKrasnov@sberdevices.ru>
 <76270fab-8af7-7597-9193-64cb553a543e@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <76270fab-8af7-7597-9193-64cb553a543e@sberdevices.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 25, 2023 at 06:56:42PM +0300, Arseniy Krasnov wrote:
>
>
>On 22.05.2023 10:39, Arseniy Krasnov wrote:
>
>This patchset is unstable with SOCK_SEQPACKET. I'll fix it.

Thanks for let us know!

I'm thinking if we should start split this series in two, because it
becomes too big.

But let keep this for RFC, we can decide later. An idea is to send
the first 7 patches with a preparation series, and the next ones with a
second series.

Thanks,
Stefano

