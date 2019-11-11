Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6CEEF79FE
	for <lists+kvm@lfdr.de>; Mon, 11 Nov 2019 18:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfKKRbB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Nov 2019 12:31:01 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23989 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726878AbfKKRbA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Nov 2019 12:31:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573493459;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/Pu/XRjHN00bp26uJKyF+eeNc+4bMeKaeoX1nXunFjQ=;
        b=B3+zBx3A2z2CLJYpuFDga6a7BkjYtwct6WzeFGE4DPuIk6ZDgh7rcQkFqMtr9SOl7empPi
        GW74xE2ZQsZM+CH7qb2SsvThkQ7S8IF4PmM+XAlRDH/gBdeM3d5Gt39oDeDoy5RrDNf3ao
        bA9YoAkCi3r7XEeWwf5sN6kyXAc0Tr0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-nJcRJRQ2MUG1G2FWAsLZeQ-1; Mon, 11 Nov 2019 12:30:57 -0500
Received: by mail-wm1-f71.google.com with SMTP id x16so64160wmk.2
        for <kvm@vger.kernel.org>; Mon, 11 Nov 2019 09:30:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OGemqcYu9gXrdCs7NgbTRCHoieRkJLCT5RXpmkbgD3I=;
        b=FwwwiY+aqure6V0YYNTs2bdYm5Jh2hR0NiaaAKGg/G/lmfJYU4Xro9T6iwvXjNaBWv
         2WjmOX7g6taNH3ZQfQoLjs8UrLlBaEO/DrCQV8fLsDOnR4dp8VRLAr/x/G9gjo2OxKdm
         eWXxOw/SF+8ZBCBBF1hUwJ8ZZFGCILHZZOfQQsb9XLwme8HOEUkwbT0NawaQD9Ec8HyU
         ar078nRojvpFlKk4H+zq1lxxU0LOMRaA+T03Z6xgMftPPXwcs/ohgEaX7PXcDUCdGPpk
         291QowY8ia+NYjDujJEKde1ectxTyuD9pVHt8RIQzz5DLgNLSZjnNDpDOfDEHDDT24Oc
         wkSg==
X-Gm-Message-State: APjAAAX5bm3u0NOzBdspLcFL5uivamNuRNOXuDxca75UTheQE1hpaLxx
        bou4kRW+kXVzbMhY0dWVMp+V5q0CBCTqXWjM5C0wMf6YCcmyQcBjnqPkMERQ2fSe7BBoyuOET2Q
        xfxCDTqsv5GfP
X-Received: by 2002:adf:ed4b:: with SMTP id u11mr2059898wro.215.1573493456385;
        Mon, 11 Nov 2019 09:30:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqxtK1/4KWgD9KPJoU+tAGhHUeUEQrzwzlucpPtfP0PmUdGJAdIPC9pkDZltrDfXpW0g+AEtzQ==
X-Received: by 2002:adf:ed4b:: with SMTP id u11mr2059871wro.215.1573493456151;
        Mon, 11 Nov 2019 09:30:56 -0800 (PST)
Received: from steredhat (a-nu5-32.tin.it. [212.216.181.31])
        by smtp.gmail.com with ESMTPSA id m1sm1701700wrv.37.2019.11.11.09.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 09:30:55 -0800 (PST)
Date:   Mon, 11 Nov 2019 18:30:53 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jorgen Hansen <jhansen@vmware.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dexuan Cui <decui@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 12/14] vsock/vmci: register vmci_transport only
 when VMCI guest/host are active
Message-ID: <20191111173053.erwfzawioxje635o@steredhat>
References: <20191023095554.11340-1-sgarzare@redhat.com>
 <20191023095554.11340-13-sgarzare@redhat.com>
 <MWHPR05MB3376266BC6AE9E6E0B75F1A1DA740@MWHPR05MB3376.namprd05.prod.outlook.com>
MIME-Version: 1.0
In-Reply-To: <MWHPR05MB3376266BC6AE9E6E0B75F1A1DA740@MWHPR05MB3376.namprd05.prod.outlook.com>
X-MC-Unique: nJcRJRQ2MUG1G2FWAsLZeQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 11, 2019 at 04:27:28PM +0000, Jorgen Hansen wrote:
> > From: Stefano Garzarella [mailto:sgarzare@redhat.com]
> > Sent: Wednesday, October 23, 2019 11:56 AM
> >=20
> > To allow other transports to be loaded with vmci_transport,
> > we register the vmci_transport as G2H or H2G only when a VMCI guest
> > or host is active.
> >=20
> > To do that, this patch adds a callback registered in the vmci driver
> > that will be called when a new host or guest become active.
> > This callback will register the vmci_transport in the VSOCK core.
> > If the transport is already registered, we ignore the error coming
> > from vsock_core_register().
>=20
> So today this is mainly an issue for the VMCI vsock transport, because
> VMCI autoloads with vsock (and with this solution it can continue to
> do that, so none of our old products break due to changed behavior,
> which is great).

I tried to not break anything :-)

>                  Shouldn't vhost behave similar, so that any module
> that registers a h2g transport only does so if it is in active use?
>=20

The vhost-vsock module will load when the first hypervisor open
/dev/vhost-vsock, so in theory, when there's at least one active user.

>=20
> > --- a/drivers/misc/vmw_vmci/vmci_host.c
> > +++ b/drivers/misc/vmw_vmci/vmci_host.c
> > @@ -108,6 +108,11 @@ bool vmci_host_code_active(void)
> >  =09     atomic_read(&vmci_host_active_users) > 0);
> >  }
> >=20
> > +int vmci_host_users(void)
> > +{
> > +=09return atomic_read(&vmci_host_active_users);
> > +}
> > +
> >  /*
> >   * Called on open of /dev/vmci.
> >   */
> > @@ -338,6 +343,8 @@ static int vmci_host_do_init_context(struct
> > vmci_host_dev *vmci_host_dev,
> >  =09vmci_host_dev->ct_type =3D VMCIOBJ_CONTEXT;
> >  =09atomic_inc(&vmci_host_active_users);
> >=20
> > +=09vmci_call_vsock_callback(true);
> > +
>=20
> Since we don't unregister the transport if user count drops back to 0, we=
 could
> just call this the first time, a VM is powered on after the module is loa=
ded.

Yes, make sense. can I use the 'vmci_host_active_users' or is better to
add a new 'vmci_host_vsock_loaded'?

My doubt is that vmci_host_active_users can return to 0, so when it returns
to 1, we call vmci_call_vsock_callback() again.

Thanks,
Stefano

