Return-Path: <kvm+bounces-54897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 21E73B2AE90
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 18:53:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB1A0564E6B
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 16:53:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FCDB343D62;
	Mon, 18 Aug 2025 16:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="f5c89ng2"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092C2335BAD
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 16:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755535972; cv=none; b=q06l9Np6y7yweDfgduacxPGJN8WqzVlZyRzwuCTwU+FW6vh4ERkVneaypyWGMG7Lefk2Fc9C6eYatB7eoI0rXvXbmTMkkcEUbKzy0c3x4k6SuE9vdtnCRvYKjs2hsQf+AwjPWShP5vV8hIuVnpmg5g7XX6CHvl60vutuPuI8pu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755535972; c=relaxed/simple;
	bh=lF2HYMBkdtqH1e6PDiM+pGCP7LuT0SndsFFraot4ftQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YUmUm4cUmR7rqsc+m4cfL8uXgadkcf1P28wzRez090jlSOyR2rXpC6hgp9PO2JkCjHgByCOu/AxhhpHSiz/V7bccxF8u84LmH0HgQ2HEhGy9hYR1uxv8wzlNAa1PiLJrYES6EE2rbNy29M8ylZZrqtYw7caF2eWVUXQe/WujfDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=f5c89ng2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755535969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j1jHYfLFogpmHbZNi2BJHyHSZ5SOcVw8OfGNKzVyZu4=;
	b=f5c89ng2kxTUHzCypJlztA5t4NnOpdUmHzU4J5uZVqLEj2FsJTug5huPiSMgSGdh7dNt+Y
	I9OxWqotHmLDpVI1jpRkZdWtnkswmcBubODq9+6lFlPOwbmiWgFQZ/gZee77zGlktIfoUD
	TzNbBc8VeBySJij4XWd4MBNnCTn/iHk=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-369-KWpuJrkMOMqVIzAhsQHyQA-1; Mon, 18 Aug 2025 12:52:47 -0400
X-MC-Unique: KWpuJrkMOMqVIzAhsQHyQA-1
X-Mimecast-MFC-AGG-ID: KWpuJrkMOMqVIzAhsQHyQA_1755535966
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e58433459bso6328675ab.2
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 09:52:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755535966; x=1756140766;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j1jHYfLFogpmHbZNi2BJHyHSZ5SOcVw8OfGNKzVyZu4=;
        b=ntcy9UbLHnkVge0dAjvz5QIgG82hr4PcZIjd8NCgTjSYjKm9rVd347R/B/778HTUYV
         TR+/s5OWmtn+18JRBpKmRBhsvD8YS/IZzYkUKPDzKP7LyuIWeampj5jDqvjtiUoDDC22
         Gm9wYTebaSpeMeOO2I+xMzBFoUCcH9uHf5zjM6h3D4JuoD8LMF8e/S5RKGMpuSCvb+en
         FvEJai2eDSrESTEaf0wIJSokoo80qnxzqSyEfRBu+qOTuAklP/twrR8RmMfXy2y/04ux
         T0vjBD3swMqxoL5Qu4fgvhECDtgPj1ePnf9Bq8H1o3Nj4Cwerr1vzU6463Fj3oGhPo/W
         46uw==
X-Gm-Message-State: AOJu0Yw5LJduEpVEB3g2Km8fKX+k83oQBILFq4B+j6CsQci31jz0q8NP
	k+4zpRYkQYUkUD+Olt239FM9NTiEgnqj8EtimcUt5weyq55JRY3tuidDs9czr5olt7oaewhaCjl
	RprXnziaCRvNPBlF0hKVVb9WLymIvYh3MtIy9+ErL2MYh0eZ3301PjA==
X-Gm-Gg: ASbGncsYwdJ8D0/xhCXBemwTU9fSQ4bN/GeL8SqIC2Uosyeq3hNZ5wYoB8NvZoTG3te
	XCDufgVhQP4585BKkN4SxXLBWI2LyhWrirgqo+wAGI+uLhDTPUD+MPkCqnMoBzQDQMJBXGAFGuB
	3wgItJ4nGJoJRkhGQxZkbIwvCk8Sv0s5yVt0xNQ+8O+yRWs9qaQ21W13i0ni3TMuHsC9h0wmHib
	h0DEivqOvsBz3Ysh7GSmqhAdhU+o4/pOH8OcevcyXOYBm4ZCH8inkuUh03kpIKqyKU4CPp9zwxL
	9+ZXtYr9TTOdE2jmMAvavSz/3iSm3ITYIyKYmIIhcVM=
X-Received: by 2002:a05:6e02:1a2c:b0:3e5:2b81:974d with SMTP id e9e14a558f8ab-3e57e9af4b8mr57232165ab.6.1755535966396;
        Mon, 18 Aug 2025 09:52:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgd1vBnXxH2nUasW/OGUg54y8D5g+6yVNB2ibk+91UWR6e4ao4rpXtciqpkhvs0yVkV1QceA==
X-Received: by 2002:a05:6e02:1a2c:b0:3e5:2b81:974d with SMTP id e9e14a558f8ab-3e57e9af4b8mr57232065ab.6.1755535965964;
        Mon, 18 Aug 2025 09:52:45 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e58398cce3sm28835185ab.19.2025.08.18.09.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 09:52:44 -0700 (PDT)
Date: Mon, 18 Aug 2025 10:52:42 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 eric.auger@redhat.com, clg@redhat.com
Subject: Re: [PATCH 2/2] vfio/platform: Mark for removal
Message-ID: <20250818105242.4e6b96ed.alex.williamson@redhat.com>
In-Reply-To: <aJ9neYocl8sSjpOG@google.com>
References: <20250806170314.3768750-1-alex.williamson@redhat.com>
	<20250806170314.3768750-3-alex.williamson@redhat.com>
	<aJ9neYocl8sSjpOG@google.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Aug 2025 16:59:37 +0000
Mostafa Saleh <smostafa@google.com> wrote:

> Hi Alex,
>=20
> On Wed, Aug 06, 2025 at 11:03:12AM -0600, Alex Williamson wrote:
> > vfio-platform hasn't had a meaningful contribution in years.  In-tree
> > hardware support is predominantly only for devices which are long since
> > e-waste.  QEMU support for platform devices is slated for removal in
> > QEMU-10.2.  Eric Auger presented on the future of the vfio-platform
> > driver and difficulties supporting new devices at KVM Forum 2024,
> > gaining some support for removal, some disagreement, but garnering no
> > new hardware support, leaving the driver in a state where it cannot
> > be tested.
> >=20
> > Mark as obsolete and subject to removal. =20
>=20
> Recently(this year) in Android, we enabled VFIO-platform for protected KV=
M,
> and it=E2=80=99s supported in our VMM (CrosVM) [1].
> CrosVM support is different from Qemu, as it doesn't require any device
> specific logic in the VMM, however, it relies on loading a device tree
> template in runtime (with =E2=80=9Ccompatiable=E2=80=9D string...) and it=
 will just
> override regs, irqs.. So it doesn=E2=80=99t need device knowledge (at lea=
st for now)
> Similarly, the kernel doesn=E2=80=99t need reset drivers as the hyperviso=
r handles that.

I think what we attempt to achieve in vfio is repeatability and data
integrity independent of the hypervisor.  IOW, if we 'kill -9' the
hypervisor process, the kernel can bring the device back to a default
state where the device isn't wedged or leaking information through the
device to the next use case.  If the hypervisor wants to support
enhanced resets on top of that, that's great, but I think it becomes
difficult to argue that vfio-platform itself holds up its end of the
bargain if we're really trusting the hypervisor to handle these aspects.

> Unfortunately, there is no upstream support at the moment, we are making
> some -slow- progress on that [2][3]
>=20
> If it helps, I have access to HW that can run that and I can review/test
> changes, until upstream support lands; if you are open to keeping VFIO-pl=
atform.
> Or I can look into adding support for existing upstream HW(with platforms=
 I am
> familiar with as Pixel-6)

Ultimately I'll lean on Eric to make the call.  I know he's concerned
about testing, but he raised that and various other concerns whether
platform device really have a future with vfio nearly a year ago and
nothing has changed.  Currently it requires a module option opt-in to
enable devices that the kernel doesn't know how to reset.  Is that
sufficient or should use of such a device taint the kernel?  If any
device beyond the few e-waste devices that we know how to reset taint
the kernel, should this support really even be in the kernel?  Thanks,

Alex


