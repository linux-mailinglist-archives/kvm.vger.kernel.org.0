Return-Path: <kvm+bounces-28406-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B333D9981C9
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 11:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A1B41B2B774
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 09:14:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B23991C242E;
	Thu, 10 Oct 2024 09:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NJq4mpTA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104441C1AD8
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 09:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728551504; cv=none; b=Ih/BF9uriJtRo0GvNMi5EysPP+TcFjsXFS3hZ8UpbJhxgTGNo5bdlCfpH1Z613/ZZl/hKuh/4SOvqKrEofW5mT/rL7g7N1lxnrvU4SIg/hHfM9tQvAPIKcMTSO9iepo8fiVuAKuWpVAo0xduiZYY20k1ZNUtjWh3qG7raE5HJ3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728551504; c=relaxed/simple;
	bh=+ex92FX/6NsvBWmXun+uf0gF3wK3BeTi9EqHuTvNsZQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Pn9K2EVl6Nw6N5xj9qzrRhNvNhDemb8e/KQZ2X1hIWvVzHG6I3N+m9qsbJzDwgw4UENB7DsbCZilpBBUZuFCTCR/afqbl7a5MP8vj3EkbKpuKoOaEUC1cgkMaJnO1usIfbEgWMRiRDQ2Ngab2nKyokny6qeHPI/YEvDERgBy2yY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NJq4mpTA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728551502;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+ex92FX/6NsvBWmXun+uf0gF3wK3BeTi9EqHuTvNsZQ=;
	b=NJq4mpTAcVEpju4GP7UXQ3tFtQq/iwJKZbaUcP9X8XyhDE1gvMJPTtOarmmgE9+I0rCPf4
	yeWON2JS3SedQ18+NhFqPdsIwG8QoFVuC3GYByzq0eMLlsw+e1MugbE70jLtAxPVn6b1tl
	1n9SCjjvdqeNfSsVtuq3LybW+vJVIeA=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-145-deYKTPjuMwueDh14UdTOTg-1; Thu, 10 Oct 2024 05:11:40 -0400
X-MC-Unique: deYKTPjuMwueDh14UdTOTg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-53991bb134bso444043e87.0
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 02:11:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728551499; x=1729156299;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+ex92FX/6NsvBWmXun+uf0gF3wK3BeTi9EqHuTvNsZQ=;
        b=bL/51lkaaOUncz57ZoIJgCa5J7P24ZJONBJwNU3D4oI/xTQbhfUuysbl4CrOxrU5DX
         1w9AfGWFEPzwIQuEVk2ZBIe/Aj1quTcznRvwHbNWVh6uHKHoLFOwWPEJhMVPkJBEi8U8
         3GaWfe1IA8+dIp76dcDmqW7u1n246q7nKQYdU8M2laetSX/k2jQZXmkVIG7s47BzMuwM
         D+hzcTGRr0DIrTseghcDiVd9f6MI8H6fcSskLmIqTmIPUzJap0jULdFUudNjyMc7xzJJ
         0FS3SGY9fcdbc+UKsirkRSAUoAw6YRyo7ZcyeSEXZ424bYP8ZXnQdjNurq50ClvdyBNW
         PALg==
X-Forwarded-Encrypted: i=1; AJvYcCVYhHi0tbabmx0Vf3NeiGJTNcN7pB3dyh9c/1ZWhWYJGGbWfnL3zXVMnQr6bWwwdB0NSa0=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt7cr1kzNlyUZKr+LSvoUrMfzP1wFkjtpbVDVsWtZwCekIYvY0
	yUBWtoda3Pli9fBwsu7wkEw3hfR7xXmY69vWlHUk/iT597Wt+hxYAYOuZNTvT8nTz64hbwxg3Ok
	9UiXkVxmruO9h1oiKd81ZecKeALYZriM44n/ketcBpp/8LClBRA==
X-Received: by 2002:a05:6512:10d1:b0:536:55ae:7444 with SMTP id 2adb3069b0e04-539c4896eb7mr3177283e87.22.1728551499297;
        Thu, 10 Oct 2024 02:11:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExq3OJhlyNTGpjtR1+LjaW3R0iv5Mu7sB9drW/xRJaoCLaoe8gSPgF49M2/ruF8wr/J6TLJA==
X-Received: by 2002:a05:6512:10d1:b0:536:55ae:7444 with SMTP id 2adb3069b0e04-539c4896eb7mr3177227e87.22.1728551498734;
        Thu, 10 Oct 2024 02:11:38 -0700 (PDT)
Received: from dhcp-64-16.muc.redhat.com (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d4b79fdc2sm949476f8f.88.2024.10.10.02.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2024 02:11:38 -0700 (PDT)
Message-ID: <f42bb5de4c9aca307a3431dd15ace4c9cade1cb9.camel@redhat.com>
Subject: Re: [RFC PATCH 13/13] Remove devres from pci_intx()
From: Philipp Stanner <pstanner@redhat.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>, 
 Sergey Shtylyov <s.shtylyov@omp.ru>, Basavaraj Natikar
 <basavaraj.natikar@amd.com>, Jiri Kosina <jikos@kernel.org>,  Benjamin
 Tissoires <bentiss@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Alex Dubov <oakad@yahoo.com>,
 Sudarsana Kalluru <skalluru@marvell.com>, Manish Chopra
 <manishc@marvell.com>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Rasesh Mody <rmody@marvell.com>,
 GR-Linux-NIC-Dev@marvell.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
 Sergey Matyukevich <geomatsi@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Sanjay R Mehta <sanju.mehta@amd.com>, Shyam Sundar S K
 <Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>, Dave Jiang
 <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>, Bjorn Helgaas
 <bhelgaas@google.com>, Alex Williamson <alex.williamson@redhat.com>,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>, Oleksandr Tyshchenko
 <oleksandr_tyshchenko@epam.com>, Jaroslav Kysela <perex@perex.cz>, Takashi
 Iwai <tiwai@suse.com>, Mario Limonciello <mario.limonciello@amd.com>, Chen
 Ni <nichen@iscas.ac.cn>, Ricky Wu <ricky_wu@realtek.com>, Al Viro
 <viro@zeniv.linux.org.uk>, Breno Leitao <leitao@debian.org>, Kevin Tian
 <kevin.tian@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ilpo
 =?ISO-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>, Mostafa Saleh
 <smostafa@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 Soumya Negi <soumya.negi97@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>, Yi
 Liu <yi.l.liu@intel.com>, "Dr. David Alan Gilbert" <linux@treblig.org>, 
 Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>, Eric Auger
 <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>, Marek
 =?ISO-8859-1?Q?Marczykowski-G=F3recki?= <marmarek@invisiblethingslab.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Kai Vehmanen
 <kai.vehmanen@linux.intel.com>,  Peter Ujfalusi
 <peter.ujfalusi@linux.intel.com>, Rui Salvaterra <rsalvaterra@gmail.com>,
 Marc Zyngier <maz@kernel.org>, linux-ide@vger.kernel.org,
 linux-kernel@vger.kernel.org,  linux-input@vger.kernel.org,
 netdev@vger.kernel.org,  linux-wireless@vger.kernel.org,
 ntb@lists.linux.dev, linux-pci@vger.kernel.org, 
 linux-staging@lists.linux.dev, kvm@vger.kernel.org, 
 xen-devel@lists.xenproject.org, linux-sound@vger.kernel.org
Date: Thu, 10 Oct 2024 11:11:36 +0200
In-Reply-To: <7f624c83-115b-4045-b068-0813a18c8200@stanley.mountain>
References: <20241009083519.10088-1-pstanner@redhat.com>
	 <20241009083519.10088-14-pstanner@redhat.com>
	 <7f624c83-115b-4045-b068-0813a18c8200@stanley.mountain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.4 (3.52.4-1.fc40) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-10-10 at 11:50 +0300, Dan Carpenter wrote:
> On Wed, Oct 09, 2024 at 10:35:19AM +0200, Philipp Stanner wrote:
> > pci_intx() is a hybrid function which can sometimes be managed
> > through
> > devres. This hybrid nature is undesirable.
> >=20
> > Since all users of pci_intx() have by now been ported either to
> > always-managed pcim_intx() or never-managed pci_intx_unmanaged(),
> > the
> > devres functionality can be removed from pci_intx().
> >=20
> > Consequently, pci_intx_unmanaged() is now redundant, because
> > pci_intx()
> > itself is now unmanaged.
> >=20
> > Remove the devres functionality from pci_intx(). Remove
> > pci_intx_unmanaged().
> > Have all users of pci_intx_unmanaged() call pci_intx().
> >=20
> > Signed-off-by: Philipp Stanner <pstanner@redhat.com>
>=20
> I don't like when we change a function like this but it still
> compiles fine.
> If someone is working on a driver and hasn't pushed it yet, then it's
> probably
> supposed to be using the new pcim_intx() but they won't discover that
> until they
> detect the leaks at runtime.

There wouldn't be any *leaks*, it's just that the INTx state would not
automatically be restored. BTW the official documentation in its
current state does not hint at pci_intx() doing anything automatically,
but rather actively marks it as deprecated.

But you are right that a hypothetical new driver and OOT drivers could
experience bugs through this change.

>=20
> Why not leave the pci_intx_unmanaged() name.=C2=A0 It's ugly and that wil=
l
> discorage
> people from introducing new uses.

I'd be OK with that. Then we'd have to remove pci_intx() as it has new
users anymore.

Either way should be fine and keep the behavior for existing drivers
identical.

I think Bjorn should express a preference

P.

>=20
> regards,
> dan carpenter
>=20


