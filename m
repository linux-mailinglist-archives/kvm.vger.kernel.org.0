Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E0F118AF2
	for <lists+kvm@lfdr.de>; Tue, 10 Dec 2019 15:32:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbfLJOc6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Dec 2019 09:32:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32928 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727272AbfLJOc6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Dec 2019 09:32:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575988376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oltekNksYL0JppEwk+sb0PIOexNRJT7sk8bU9jqVsg4=;
        b=QU8uEPJoFeaAU13A7xsOSR4otPE3OZRrNZPhhSTp9FMrPqXfbKl8+eJh8Vwygw4/0s1Job
        PECIPR/ZfyDgNTN9q9wh8Jj530nx6crXrr1MIFxHReoBrDoPh+XfRteRQZ9tUjud5Ghme3
        7ptaOKdfgZGYpIOSSK9NcFzqF6tFI7w=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-392-1TyFiPE2O5Wxzkhw_kuIRg-1; Tue, 10 Dec 2019 09:32:55 -0500
Received: by mail-wr1-f69.google.com with SMTP id h30so9017086wrh.5
        for <kvm@vger.kernel.org>; Tue, 10 Dec 2019 06:32:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZX5clcawRs9HvyErreGyUr6byz6y4hiLe4x5yy5XB+w=;
        b=fwbdFF1fjFk5nEHRILXPDfIFax4GUY5hgGZbxg8QvwtXi/jdH9MOadmtD4P6b5sLYw
         hl4RdweUTiV8y2OSjW2Sg80EX1ucLxleS3l50QvIfPzMXHaVUN60Zmd25RgbebctL047
         hYh51Ad/r50dcDdKJyzEK64wtvBTNmNFFQshU/9OzpGoV3GvFZK77h4CNrMXIBjxdgyJ
         aZ66bdEf0T/fy+4bNEm7PeDHlCJz0JNCS+QjFTUeBDA9+wjIph0YYaAe48m6Lz9B2qfN
         9zs7MlHIysU6MSZ2FbzHqFJXbWF9X3RLLTQRM7R5+a+voUMjmZsA8egGsMt4dLoeF5YQ
         iRqA==
X-Gm-Message-State: APjAAAVsaH/9W36Nvp74wyP6nqLzMPuIFD4xSOQDNkHTkALtU7XTGv/A
        aeQkzYA5YFJtw3n8jbNy4WfGgi7Xy2KKsF2T6fEsoQrtl1Ay56C2BvcTKw20HvwrqtRkYcgCIuT
        qIee94t5MV82i
X-Received: by 2002:a05:600c:2947:: with SMTP id n7mr5228101wmd.156.1575988374114;
        Tue, 10 Dec 2019 06:32:54 -0800 (PST)
X-Google-Smtp-Source: APXvYqx5osq8iXaghf+DSPEJ+fI9zhfAtq/jAq/Ozou/cbeXTMCvexsR8V2x1X6t2Pp1+8eyRY0ljg==
X-Received: by 2002:a05:600c:2947:: with SMTP id n7mr5228075wmd.156.1575988373894;
        Tue, 10 Dec 2019 06:32:53 -0800 (PST)
Received: from steredhat ([95.235.120.92])
        by smtp.gmail.com with ESMTPSA id b185sm3483015wme.36.2019.12.10.06.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 06:32:53 -0800 (PST)
Date:   Tue, 10 Dec 2019 15:32:51 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vhost/vsock: accept only packets with the right dst_cid
Message-ID: <20191210143251.szkicty23b6pojxh@steredhat>
References: <20191206143912.153583-1-sgarzare@redhat.com>
 <20191210090505-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20191210090505-mutt-send-email-mst@kernel.org>
X-MC-Unique: 1TyFiPE2O5Wxzkhw_kuIRg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 10, 2019 at 09:05:58AM -0500, Michael S. Tsirkin wrote:
> On Fri, Dec 06, 2019 at 03:39:12PM +0100, Stefano Garzarella wrote:
> > When we receive a new packet from the guest, we check if the
> > src_cid is correct, but we forgot to check the dst_cid.
> >=20
> > The host should accept only packets where dst_cid is
> > equal to the host CID.
> >=20
> > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
>=20
> what's the implication of processing incorrect dst cid?
> I think mostly it's malformed guests, right?

Exaclty, as for the src_cid.

In both cases the packet may be delivered to the wrong socket in the
host, because in the virtio_transport_recv_pkt() we are using the
src_cid and dst_cid to look for the socket where to queue the packet.

> Everyone else just passes the known host cid ...

Yes, good guests should do it, and we do it :-)

Thanks,
Stefano

