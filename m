Return-Path: <kvm+bounces-29882-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAEA79B38EB
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 19:17:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 665E51F2214F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 18:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 061A21DF757;
	Mon, 28 Oct 2024 18:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iGMDmh07"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35019186616
	for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 18:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730139473; cv=none; b=YOrWBw9VIoYb65qyZvC4OBzBjBikVzBd8GyLntw5aLAv8NDiJ7W0UC/LG7FONE5Wiu575mWdAlDAh28CRls+zm23WEqCZZnBfnPg0MA70xlRwNHaYti4mkHxmDlM/sbDKDqTGZ6IVkpToSL5K/f92ADOek/CUx5x6aV+ylAT8MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730139473; c=relaxed/simple;
	bh=BI0TiyriFR9sBLWv0MTNVLSTtiBR6zB5VM599YILyhE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VZPZ1Cc0Zfub4Rb1i4sBYTXEhUUVkbTKh+k2E6g5fcC0MEq1GWLU6xz1dK2jTF9mnaUbo+Z/yT4v5yJ2mZlIIZ4TPY0rNJEG7mJOLBKXHfHPo+V8tNfVhQvmUcsY2Kqi9vPVqgX58Bf2Bmxe8FxWZpMyymhTxMLNgzPd+p+Jx5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iGMDmh07; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730139470;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ow6yg5EfDFU7n7Pa/d9u/odwnb2QoL21BBF3d5MTEfc=;
	b=iGMDmh07/fsEobL8nhvhOURoj0PWM5jbZTItYtlYWkjQD1+ZFwmp26sAZnMU3LQJgADlly
	AdF1h+StAnAlDQnvBFAZamlxI500P4Pql9mHvzqN5/0474kWTkF1phbk7KrroiRBm2n8rf
	T3YNo6L/EYnJ+f491nWmMDYgusEoX4c=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-jS7CPEonM7aw1ggzpOmPRw-1; Mon, 28 Oct 2024 14:17:48 -0400
X-MC-Unique: jS7CPEonM7aw1ggzpOmPRw-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-83ab67710b5so50087939f.3
        for <kvm@vger.kernel.org>; Mon, 28 Oct 2024 11:17:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730139468; x=1730744268;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ow6yg5EfDFU7n7Pa/d9u/odwnb2QoL21BBF3d5MTEfc=;
        b=FQCY/yLzfhAQVzaTD+Ny13uFXIUfLLoyS87C0G9TUF+QMAJlSS7MLeyB4CX6At4N2H
         89dDgHTe8Bb34/3w/OOahk0jnYUGKx3AAfT8UHVuqIViXT+oPw0EFsdi7mFpvrk5c4km
         eymdI6lMDnJxSR4PPjpA0slDjq+jDCI0inLwK6kx6b7++C1vFDOA4BeAFszOIHQZNeIW
         eBKYL+19wTSE2ny8YnCHUJghBS88IVL9lIW52bKKCYP0r3DaIaTv+C6Iu03NJTsWVYQ1
         BaiWsxAWMRFhic0SryJ+J9tPd7+RYUudRSz7bszSoQoSH0SSfTgjKK64IcKm0ZMzUuPe
         T94A==
X-Forwarded-Encrypted: i=1; AJvYcCUFqRCxZf8XbvO9ApeSa+5N8d9H0/dZEK0uCSN9lV8aUSomzYMPpvdAZMFB1AOaPGv4NQE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyADX1elIplqrysKffTNN3jstzAKU+QKqAZRFhLUYXlm3GHbcs
	9cfQBvIVJP3/h301DNaK/ScU9l4Q83JJQ2XlwJxzYI2TgqOckdcS7gdLO8PetUkM9jcMnoRuunZ
	JK2gsziapNfbJTSM0rJW2sQHhV+NIs5V5jegl/1EHNPMncWbtzQ==
X-Received: by 2002:a05:6e02:1d19:b0:3a2:6cd7:3255 with SMTP id e9e14a558f8ab-3a4ed30c266mr22182685ab.6.1730139467881;
        Mon, 28 Oct 2024 11:17:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFyaCZsOb3OubpwLQK2tvyyyBnC7J+AwIr3XfWRoJc04SSKzCg6MWaZngCwZ2ehfEY79ESAGQ==
X-Received: by 2002:a05:6e02:1d19:b0:3a2:6cd7:3255 with SMTP id e9e14a558f8ab-3a4ed30c266mr22182605ab.6.1730139467445;
        Mon, 28 Oct 2024 11:17:47 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb673sm1826022173.16.2024.10.28.11.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 11:17:47 -0700 (PDT)
Date: Mon, 28 Oct 2024 12:17:45 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yishai Hadas <yishaih@nvidia.com>
Cc: <mst@redhat.com>, <jasowang@redhat.com>, <jgg@nvidia.com>,
 <kvm@vger.kernel.org>, <virtualization@lists.linux-foundation.org>,
 <parav@nvidia.com>, <feliu@nvidia.com>, <kevin.tian@intel.com>,
 <joao.m.martins@oracle.com>, <leonro@nvidia.com>, <maorg@nvidia.com>
Subject: Re: [PATCH vfio 0/7] Enhances the vfio-virtio driver to support
 live migration
Message-ID: <20241028121745.17d4d18c.alex.williamson@redhat.com>
In-Reply-To: <20241027100751.219214-1-yishaih@nvidia.com>
References: <20241027100751.219214-1-yishaih@nvidia.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 27 Oct 2024 12:07:44 +0200
Yishai Hadas <yishaih@nvidia.com> wrote:

> This series enhances the vfio-virtio driver to support live migration
> for virtio-net Virtual Functions (VFs) that are migration-capable.

What's the status of making virtio-net VFs in QEMU migration capable?

There would be some obvious benefits for the vfio migration ecosystem
if we could validate migration of a functional device (ie. not mtty) in
an L2 guest with no physical hardware dependencies.  Thanks,

Alex


