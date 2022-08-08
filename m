Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A82858C670
	for <lists+kvm@lfdr.de>; Mon,  8 Aug 2022 12:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242617AbiHHKbO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Aug 2022 06:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236801AbiHHKbM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Aug 2022 06:31:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E64866161
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 03:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659954670;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XvPrsjTvSRvoKVmqojs3rSzxL2OS329sfzMWHSZ4M50=;
        b=hsLrLaDXqyZFYwbZT6mFuuSNkrV4abgxjUGpt2ty+VNtlurNXKparLZPB9DtK1tofrvIAv
        jQ3vh4ZPcKBYOyBUvoote/qgPCd3r7oiwHSQULayWF6UvlExJ/ct6/Fhle1qaCQyGSKSON
        1J5xPUrtmYKvWKKdYlmvHvqy6YNLSx0=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-473-nBp97hEUMJmzhEPhyKMjcQ-1; Mon, 08 Aug 2022 06:31:08 -0400
X-MC-Unique: nBp97hEUMJmzhEPhyKMjcQ-1
Received: by mail-qt1-f199.google.com with SMTP id k3-20020ac86043000000b0033cab47c483so6493297qtm.4
        for <kvm@vger.kernel.org>; Mon, 08 Aug 2022 03:31:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=XvPrsjTvSRvoKVmqojs3rSzxL2OS329sfzMWHSZ4M50=;
        b=SzsVblg+xB6Ij7X28x34WPNAPnw6Os59VfjzYSxaUWaNF9Bg62gYjbG7WIkdFDnu5C
         geG+NINTHs0dm3Weotkgjdi83Zp5ck3sOk3cg9PpVZK2kBsINv31HQ7AHf1clU/MjFgg
         7YlCC1Ax5KyIm1eY0Bi5xpT+BRHWJCLcJT4J5rJUX6AwXUXyY/yyyfQN7WgJyWq9mdO5
         neXvXg+HDDIgA8ZMVWOWB+ysDwdIBnDfFG+Mg6LCeQTU236TekUzL30xIroAK0O18ah2
         oqBxfTIiWAV3neoq8Utnzi1l51aXSLY601EZbpLxd4HcQ2yBWzGufJax+EvMpk0xoqd8
         oFDw==
X-Gm-Message-State: ACgBeo06g5OOtQVVzRL//THVpBwHTLjMN6qnVK2KRcofzQEjuxHwXP4E
        ruDur08skNZaE+BaG8Ep89LDj1ODvq64usZzGpSptvjCCcv/Un2acZRFAsEcz8lqme8AnRIxtqh
        z12Smw/TNjy2u
X-Received: by 2002:a37:8a44:0:b0:6b5:f371:a183 with SMTP id m65-20020a378a44000000b006b5f371a183mr13302332qkd.492.1659954668395;
        Mon, 08 Aug 2022 03:31:08 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6/yFs0KjeGd8bKDfXwYhjua9yB0wwXzaxZKsQn6plBoppBAz4IclCsn96TyP1BAgwx2AsEgg==
X-Received: by 2002:a37:8a44:0:b0:6b5:f371:a183 with SMTP id m65-20020a378a44000000b006b5f371a183mr13302320qkd.492.1659954668196;
        Mon, 08 Aug 2022 03:31:08 -0700 (PDT)
Received: from sgarzare-redhat (host-79-46-200-178.retail.telecomitalia.it. [79.46.200.178])
        by smtp.gmail.com with ESMTPSA id u12-20020a05620a454c00b006b928ba8989sm844240qkp.23.2022.08.08.03.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 03:31:07 -0700 (PDT)
Date:   Mon, 8 Aug 2022 12:31:01 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "haiyangz@microsoft.com" <haiyangz@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bryan Tan <bryantan@vmware.com>,
        Vishnu Dasa <vdasa@vmware.com>,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        Krasnov Arseniy <oxffffaa@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        kernel <kernel@sberdevices.ru>
Subject: Re: [RFC PATCH v3 2/9] hv_sock: disable SO_RCVLOWAT support
Message-ID: <20220808103101.iknoveb7vgsrkxp6@sgarzare-redhat>
References: <2ac35e2c-26a8-6f6d-2236-c4692600db9e@sberdevices.ru>
 <58f53bef-62f4-fd63-472c-dcd158439b09@sberdevices.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <58f53bef-62f4-fd63-472c-dcd158439b09@sberdevices.ru>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 03, 2022 at 01:53:23PM +0000, Arseniy Krasnov wrote:
>For Hyper-V it is quiet difficult to support this socket option,due to
>transport internals, so disable it.
>
>Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
>Reviewed-by: Dexuan Cui <decui@microsoft.com>
>---
> net/vmw_vsock/hyperv_transport.c | 7 +++++++
> 1 file changed, 7 insertions(+)

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

