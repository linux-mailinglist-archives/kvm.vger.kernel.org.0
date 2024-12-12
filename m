Return-Path: <kvm+bounces-33643-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AFF5A9EFAB7
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 19:21:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 049C9172580
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 18:19:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 766CD223C7A;
	Thu, 12 Dec 2024 18:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TJHn1nk0"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F011E22370C
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 18:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734027126; cv=none; b=VfuVHZCyGkg3paRPO/+I4pK0vZwGGap6d57Jyri4E3HUv65SXfpHPrlOCY6mzrZ9CILwhUcwFVwMYbhfYiP9+tiG0W/X9rIqDsXBKZawQ9PwhiMBCqJOaP0STfzck9D86VajS69l88PnK7us+D+Ds3QyEWZnZn8VJGj+lokTmbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734027126; c=relaxed/simple;
	bh=co27ybrB9fEPHaOAtDSNXGPwDntiGLQS8YX9NeDWy4k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QZ7D+KPMAR1gWsvOMqqCNOjWBAkwfLvqy779yh9lJd/w8Afw1MZnq4+A1EyHGGF9GINB6eQMinygqWUIksQH78TpAIStD2BlxddLqx24Aim9kOyBcTl24yM/GAlSalC0s43lqbEI5ym2KZLbDzt4dHjI+MuwKnnbkR70AxL6rp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TJHn1nk0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734027123;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pVc2vEwgHB/uJ4wGOZ6UdvU2vIv/gbN8u5OwYQlvM0U=;
	b=TJHn1nk0znd+7PTHEEAB3zw4fDjklEybE9dIPQmwaerdldbqZGc10unUrfj/ou2fZZc1qV
	chUh12LXF/SWS5AtQQ2Iwst/cvFGSfEkdH25ccXRDNM5EI/HMMvrW+5P8d1KiBPia/7uAk
	ir53YbmN+HhlRH0Xomv8aSteXDyRTOA=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-HAQ2RhujNHC9VBdkQcwZjA-1; Thu, 12 Dec 2024 13:12:02 -0500
X-MC-Unique: HAQ2RhujNHC9VBdkQcwZjA-1
X-Mimecast-MFC-AGG-ID: HAQ2RhujNHC9VBdkQcwZjA
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-844bf90c20aso10841139f.1
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 10:12:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734027122; x=1734631922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pVc2vEwgHB/uJ4wGOZ6UdvU2vIv/gbN8u5OwYQlvM0U=;
        b=Hbk11cjy1tshuIvlUwkCbBNuYPyC4+sMvO3ThawPPClLeG66zoIYJp2NbWvRYIztVg
         lySKKLjZs5OP0ssLMjckDvwcKWUAa7xiS+pTlW2C+kFhvWAOMIH+5G+01SWddkbceeEX
         UFGYlgVulY6K1UZyc9eb6Uo9J6B+Qmdm23bC7HwuSQjk4QLFk3BeU5Beo0a4xYbkFYML
         NMrckK9JDmbvcC5VpSRgEeA6wplJWfm/TO7uI5wE9chPAMZer+wJ3iHFF/0wyVmVItZP
         Tg1+LwZj6aUHRsrBh/Fgt9KJIuckPNoMpnKpP5iI1eEPWVwCMIFDRtdhTrlxaMPxhZ8J
         JEaw==
X-Forwarded-Encrypted: i=1; AJvYcCWFjNME9CxOnDjMyo79pq+L+3v7fBm3Y+NQWHrb+F3JLvSfbR/YTJssqOdhKgLXioxWo7I=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFxHfxi9yc54FiWYwW/xaoAonACvDI9lKDvRzqNFbGOL0uD5OE
	2aoFLPLUXAGX1qWueIweninglc5j4qzUA1JeBVFbvpVQDMhkr2fHZdiHwHIMjiYJbQyJQ+d3QLO
	w15e+S+x2OVZnxlxZyqFNQJrPxemTyIcH1+1SlPcJCh7Rgju82g==
X-Gm-Gg: ASbGnct1SjHTAinqNNYt+GHZ4hcy9evgQkdtn+mDaKiJYpF+4WmQo6Ws8KlS9hPzijO
	DVWwo+prxcQK+QMbY5aH90hd+Nf+14TWFIhqOqAtxUXjYgGjh5bUmpojWhkKl5Gys04hWKCVcpU
	IUh383EqZmOWqZfxZeMADOmuGVQTxgYCYgRfp9icyiAeBIUvElMvz7RQXnU8ThTeSbWRucWK8/p
	N78sQEop78laF0b7a32OsleblYj7SAoviVMAKZsk113QVkxrKRtfcZrWV/p
X-Received: by 2002:a05:6602:601b:b0:83a:9c22:23b3 with SMTP id ca18e2360f4ac-844e56ceae8mr29738839f.4.1734027122004;
        Thu, 12 Dec 2024 10:12:02 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHxhelQP8bT2O5U9c/X1c88ABwnpEP3d2AauGiLXe5Zmg5vc3UY1bQ36XNsGHRSi44ksagzOw==
X-Received: by 2002:a05:6602:601b:b0:83a:9c22:23b3 with SMTP id ca18e2360f4ac-844e56ceae8mr29738239f.4.1734027121670;
        Thu, 12 Dec 2024 10:12:01 -0800 (PST)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-844737bc5e7sm431355639f.7.2024.12.12.10.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2024 10:12:01 -0800 (PST)
Date: Thu, 12 Dec 2024 11:12:00 -0700
From: Alex Williamson <alex.williamson@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Heiner Kallweit <hkallweit1@gmail.com>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>,
 Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <20241212111200.79b565e1.alex.williamson@redhat.com>
In-Reply-To: <Z1ppnnRV4aN4mZGy@infradead.org>
References: <0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
	<2024120430-boneless-wafer-bf0c@gregkh>
	<fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
	<2024120410-promoter-blandness-efa1@gregkh>
	<20241204123040.7e3483a4.alex.williamson@redhat.com>
	<9015ce52-e4f3-459c-bd74-b8707cf8fd88@gmail.com>
	<2024120617-icon-bagel-86b3@gregkh>
	<20241206093733.1d887dfc.alex.williamson@redhat.com>
	<2024120721-parasite-thespian-84e0@gregkh>
	<4b9781d5-5cbc-4254-9753-014cf5a8438d@gmail.com>
	<Z1ppnnRV4aN4mZGy@infradead.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Dec 2024 20:42:06 -0800
Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Dec 07, 2024 at 11:06:15AM +0100, Heiner Kallweit wrote:
> > Issue with this approach is that these "mdev parent" devices are partially
> > class devices belonging to other classes. See for example mtty_dev_init(),
> > there the device passed to us belongs to class mtty.  
> 
> The samples don't matter and can be fixed any time.  Or even better
> deleted.

There is value to these.  In particular mtty exposes a dummy PCI serial
device with two different flavors (single/dual port) that's useful for
not only testing the mdev lifecycle behavior, but also implements the
vfio migration API.  Otherwise testing any of this requires specific
hardware.  I'd agree that breaking userspace API for a sample device is
less of a blocking issue, but then we have these...

> The real question is if the i915, ccw and ap devices are
> class devices.  From a quick unscientific grep they appear not to,
> but we'd need to double check that.

And I'd expect that these are all linking bus devices under the
mdev_bus class.  I understand the issue now, that from the start we
should have been creating class devices, but it seems that resolving
that is going to introduce a level of indirection between the new class
device and the bus device which is likely going to have dependencies in
the existing userspace tools.  We'll need to work through the primary
ones and figure out contingencies for the others to avoid breaking
userspace.  The "just remove it anyway" stance seems to be in conflict
with the "don't break userspace" policy and I don't think we can
instantly fix this.  Thanks,

Alex


