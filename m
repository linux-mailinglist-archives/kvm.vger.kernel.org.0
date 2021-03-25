Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9635A348E52
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 11:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhCYKtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 06:49:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27864 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230151AbhCYKsb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 06:48:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616669310;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uG7Xvxqmhobojsj5OJqFrV/WCwv8p+ZZ6c7WsrWCTcI=;
        b=KS0gk0hRyMzGAmOBRIoG/Uj1YuCiU27q5uztHdVGzTtdyzMC44Iw3XzjLPv8lodJlBqvqy
        nTabUFIeKnDlk7+XMD/2h5TSR/3ra82T5ApVWi4yCeZq/1h/e8c6Ti+/WZQ/MSHJFpCs3V
        zBunUTp6c+04sCSnyU3dvnCYGnoUetQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-ArqQSAHfN_Sr4i2n9-q1FQ-1; Thu, 25 Mar 2021 06:48:28 -0400
X-MC-Unique: ArqQSAHfN_Sr4i2n9-q1FQ-1
Received: by mail-wm1-f70.google.com with SMTP id y9so1097443wma.4
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 03:48:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uG7Xvxqmhobojsj5OJqFrV/WCwv8p+ZZ6c7WsrWCTcI=;
        b=IWW4KZpll4mF4LkgS2rzg7HjUTjH5hwQIf6S+yjKl4Uy7QIVSX3GOITiLznurtfopW
         MyVGP9KiiBeUf0njNhxXmaJ7I60NsKPNwClk6lj3gLK563cVcWsy+6hknXMJ620Gzs4U
         q3cTEj77pQnspfGtPf4NFM9nY1DM1M5BskFFnvzkHwuN6Wv4oT/fyXj1JvrHngNOCyK0
         RT23NrXTV8TvXyzTDL95unK2E08imq3qTuLQDXNsy8O+RT1zerzfJ+Cew+0yVFrzHLag
         RjdBxbLPt/aedbhiBJeCfwIh40JOFJYWjsyLikctfYkpwcqGthX3swtMTD2niue736SS
         mSvA==
X-Gm-Message-State: AOAM5306+yoe1SfbiwJhZ3v8RSV5NB7q36AJu1Z2zAQcBudmX34lzP9N
        818O6WIOJOlZgnLFofadquJcqIeCZ4FwFXnYsoK0YEJbf9/GePC+L+YSXAy+BSXkBj/DlUATvys
        iVjUbbSabarDF
X-Received: by 2002:a5d:4687:: with SMTP id u7mr6830190wrq.357.1616669307627;
        Thu, 25 Mar 2021 03:48:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwba4i/cNkvyGHe1MXcfBoFDQppd2SFKpM4+Idmc3yl4RPx5YeZV2q+XoHVidJ3th6SnvpH1g==
X-Received: by 2002:a5d:4687:: with SMTP id u7mr6830170wrq.357.1616669307472;
        Thu, 25 Mar 2021 03:48:27 -0700 (PDT)
Received: from steredhat (host-79-34-249-199.business.telecomitalia.it. [79.34.249.199])
        by smtp.gmail.com with ESMTPSA id x23sm5818233wmi.33.2021.03.25.03.48.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 03:48:27 -0700 (PDT)
Date:   Thu, 25 Mar 2021 11:48:24 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Arseny Krasnov <arseny.krasnov@kaspersky.com>
Cc:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Alexander Popov <alex.popov@linux.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stsp2@yandex.ru, oxffffaa@gmail.com
Subject: Re: [RFC PATCH v7 18/22] vsock/loopback: setup SEQPACKET ops for
 transport
Message-ID: <20210325104824.josycnluwxehuxhn@steredhat>
References: <20210323130716.2459195-1-arseny.krasnov@kaspersky.com>
 <20210323131436.2461881-1-arseny.krasnov@kaspersky.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210323131436.2461881-1-arseny.krasnov@kaspersky.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 23, 2021 at 04:14:33PM +0300, Arseny Krasnov wrote:
>This adds SEQPACKET ops for loopback transport and 'seqpacket_allow()'
>callback.
>
>Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>---
> net/vmw_vsock/vsock_loopback.c | 12 ++++++++++++
> 1 file changed, 12 insertions(+)


Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>

