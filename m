Return-Path: <kvm+bounces-32949-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A9D29E2C81
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 20:57:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6DF92B391CF
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2024 19:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C53A13B2B8;
	Tue,  3 Dec 2024 19:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZDYRKRJT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C391F76BE
	for <kvm@vger.kernel.org>; Tue,  3 Dec 2024 19:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733253630; cv=none; b=s3SFli1mkYRejaJ0GzLKMalFsTV/AHrW3GCaYrIKmAsDfxVRi/chm5Lh9GD/RporLlwhhOCVt4LGkMRv6Pak6+phofBgBewpgjhFsMKPaOH+fiGPmcdyiL/ARhTCpUq/+sxWx53dRkNx/dktTk0b0XVdYaaCICvivZhkIE3sZZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733253630; c=relaxed/simple;
	bh=xmLrAoZYfH1C9qAMCpwXhGPaCxW23fC01rFSUrJArXk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lKI2plA2zQQaQkMpDJc0Ywo3DgMFpeCV2SsVkKr/MD6wtKQQyFtBdwXJpTBAk4iKX4tqD4sqVgKMjkZWXblZ7UBILXAw7CgBA0RDwb2oVcDAsmpgBH6A/ywzuXnmwajhlZDmB5QLkbTR4TMJ/4rFwuPZDjj31dBTWDxY4/Ry2iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZDYRKRJT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733253627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MTrbWwo6c0uY9C6iZcF4Of2Z27zcDH0xT1dmnkzM2/Q=;
	b=ZDYRKRJTnoLEqUvqBPtF6HOe9flEOohMqaAkXxswrk9QaURx5gBbs5MO9C+DN2fvF6oprm
	y8U5B7dJGAAZA3tgJdj321fR9J7hI/PaMLn80Mknbo8yiFi8HlCBquK3/YpovaLtU3x03J
	jO4LQoNLsS+7f91NGEgdmI9HbJYUL7U=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-8n6f_AL0O0O0GSHXngZjiQ-1; Tue, 03 Dec 2024 14:20:26 -0500
X-MC-Unique: 8n6f_AL0O0O0GSHXngZjiQ-1
X-Mimecast-MFC-AGG-ID: 8n6f_AL0O0O0GSHXngZjiQ
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-841a3038d3aso66508939f.3
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2024 11:20:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733253626; x=1733858426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MTrbWwo6c0uY9C6iZcF4Of2Z27zcDH0xT1dmnkzM2/Q=;
        b=Mz5uH9+gTCwLXj21rrurFYzTKHbYCOJ5b0WQED9OvC8otoTijiEHHYPMzCQZm7eIHK
         0wmf/OyB++fK8BGU1+1KE31p4ZM/Qks0zyLfLV+vgO4xVjdo1sQijPwlQf41mWepuUE2
         i/oNjlx5D5arKLXHxykjFr8yTK6mmEfP/5SZOYU6SyMu1E3CtXD+tJ0EeMBRUMxm3Q9K
         DGxNSrQZ1czo5Rs2TYKoTAPYpnPevUe9+k6jNp36kDIS9x0Uej6HWASMGX3Mq/hfX2ex
         wpp65x3T+Z0HdZdsp1sNupVVA+LmVKS7riMzw3SZM7zDjre13YFlRTQM9g5vq53NQbbm
         dUCA==
X-Forwarded-Encrypted: i=1; AJvYcCXSU0MI7CcgXbjWDP7rBbQh0xTwaW+pCm4zNyMnbT9QRXI1BVZvpEsfJyAYKeU8EmSxAmg=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBxCcNC0VqDk9+vCG/OvZ4axQUB40ZT5i8CCtD4AFlMvkpqBae
	nI1sJf1C/SFbM69fxtZKRWbvgC/NeuF9VsCmBpOXqbcpwQvJo+rQV5iw3pLGjboao1yGb/WktuF
	4J9va++9284+QcjQISe5gXO7RQdnEWvZ9OgbQNug18wDBsThiSg==
X-Gm-Gg: ASbGncspx8MVIQ2bBh6S803HMr5pCPFkgQvtWJDlvHclK1DWucX0b83353EH2KOdunc
	eA/bH00RVIkdqZg6rFHmCc19+4+eGkeh5cpo0odvdGvQhn7ECa8Jwxyfm9shR6EDd4pEBwwtINw
	WKMAE0Ota0wRWRfREOnUbToYEtRd5gxaeb0uCHBMHGEba1FxhrhL9/lWKSWoTb/g5Rj9zQ0pkUZ
	SwsdPW8MbfTkm1Ki6RSB0c+HPrauItAuysCdufWiPrjv/FGSB2Lew==
X-Received: by 2002:a05:6602:1588:b0:83a:abd1:6af2 with SMTP id ca18e2360f4ac-8445b7d3fe9mr107439239f.3.1733253625910;
        Tue, 03 Dec 2024 11:20:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHdS55JUe4FzmsGSIchjfa8Tf5gGWZeiOfX6lsv54NBFvIWQxWGmKOKqYeAHPiZ9GJxJvIQug==
X-Received: by 2002:a05:6602:1588:b0:83a:abd1:6af2 with SMTP id ca18e2360f4ac-8445b7d3fe9mr107438439f.3.1733253625625;
        Tue, 03 Dec 2024 11:20:25 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e230e5f21esm2722452173.80.2024.12.03.11.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2024 11:20:25 -0800 (PST)
Date: Tue, 3 Dec 2024 12:20:23 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Mitchell Augustin <mitchell.augustin@canonical.com>
Cc: linux-pci@vger.kernel.org, kvm@vger.kernel.org, Bjorn Helgaas
 <bhelgaas@google.com>, linux-kernel@vger.kernel.org
Subject: Re: drivers/pci: (and/or KVM): Slow PCI initialization during VM
 boot with passthrough of large BAR Nvidia GPUs on DGX H100
Message-ID: <20241203122023.21171712.alex.williamson@redhat.com>
In-Reply-To: <CAHTA-uaGZkQ6rEMcRq6JiZn8v9nZPn80NyucuSTEXuPfy+0ccw@mail.gmail.com>
References: <CAHTA-uYp07FgM6T1OZQKqAdSA5JrZo0ReNEyZgQZub4mDRrV5w@mail.gmail.com>
	<20241126103427.42d21193.alex.williamson@redhat.com>
	<CAHTA-ubXiDePmfgTdPbg144tHmRZR8=2cNshcL5tMkoMXdyn_Q@mail.gmail.com>
	<20241126154145.638dba46.alex.williamson@redhat.com>
	<CAHTA-uZp-bk5HeE7uhsR1frtj9dU+HrXxFZTAVeAwFhPen87wA@mail.gmail.com>
	<20241126170214.5717003f.alex.williamson@redhat.com>
	<CAHTA-uY3pyDLH9-hy1RjOqrRR+OU=Ko6hJ4xWmMTyoLwHhgTOQ@mail.gmail.com>
	<20241127102243.57cddb78.alex.williamson@redhat.com>
	<CAHTA-uaGZkQ6rEMcRq6JiZn8v9nZPn80NyucuSTEXuPfy+0ccw@mail.gmail.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Dec 2024 13:36:25 -0600
Mitchell Augustin <mitchell.augustin@canonical.com> wrote:

> Thanks!
>=20
> This approach makes sense to me - the only concern I have is that I
> see this restriction in a comment in __pci_read_base():
>=20
> `/* No printks while decoding is disabled! */`
>=20
> At the end of __pci_read_base(), we do have several pci_info() and
> pci_err() calls - so I think we would need to also print that info one
> level up after the new decode enable if we do decide to move decode
> disable/enable one level up. Let me know if you agree, or if there is
> a more straightforward alternative that I am missing.

Nope, I agree.  The console might be the device we've disabled for
sizing or might be downstream of that device.  The logging would need
to be deferred until the device is enabled.  Thanks,

Alex

> On Wed, Nov 27, 2024 at 11:22=E2=80=AFAM Alex Williamson
> <alex.williamson@redhat.com> wrote:
> >
> > On Tue, 26 Nov 2024 19:12:35 -0600
> > Mitchell Augustin <mitchell.augustin@canonical.com> wrote:
> > =20
> > > Thanks for the breakdown!
> > > =20
> > > > That alone calls __pci_read_base() three separate times, each time
> > > > disabling and re-enabling decode on the bridge. [...] So we're
> > > > really being bitten that we toggle decode-enable/memory enable
> > > > around reading each BAR size =20
> > >
> > > That makes sense to me. Is this something that could theoretically be
> > > done in a less redundant way, or is there some functional limitation
> > > that would prevent that or make it inadvisable? (I'm still new to pci
> > > subsystem debugging, so apologies if that's a bit vague.) =20
> >
> > The only requirement is that decode should be disabled while sizing
> > BARs, the fact that we repeat it around each BAR is, I think, just the
> > way the code is structured.  It doesn't take into account that toggling
> > the command register bit is not a trivial operation in a virtualized
> > environment.  IMO we should push the command register manipulation up a
> > layer so that we only toggle it once per device rather than once per
> > BAR.  Thanks,
> >
> > Alex
> > =20
>=20
>=20


