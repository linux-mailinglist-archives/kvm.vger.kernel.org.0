Return-Path: <kvm+bounces-39554-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6588EA4784B
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 09:53:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5E4AC3A6BC9
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 08:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9AEB226551;
	Thu, 27 Feb 2025 08:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ErPzERDz"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 569B6222595
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 08:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740646412; cv=none; b=t5L0PM2gaKen1oWjtFGAVjGc9WDOn88GE4ED55jCHH8o7C+XUhDp0oAmeGEBebwFmWSgZ3btA9X7l5O6ulXlfAEkKteQqn9FjvHGkEdWlLwv9FN2IXjVWFtHPeb9omWG9VtE4RxiDsmgxCma/wvE0Dnd+pLOs0qjmKgKBbbk0ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740646412; c=relaxed/simple;
	bh=3GpRrQB1DypQLUYLxyCLDjQ561KIZeotsWfmMyEWDf4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iCiWAXUQ8PwBsRiU2hxZGUkEdtwmNWoh3yrzCnw+S2DJqj6onG8b5NVDohFf1ZxDVx9yeDn1jfkBgJGzCFbYOTGY8/VpAb0i+cfdhMd5lamPEtwKjN+q0D+mpNzioDiQw6YTzEVRxZ9NnNFZp9BPYewMlH7xClV5RqssHJ7nQuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ErPzERDz; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740646409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EyvlqtbZaeJM3spFnINaDI06hIqM+bBC6L0QBlOLKJ8=;
	b=ErPzERDz9Ehomo75oNOQC13uCLqDsk4gPCzH9XZBvlarszCXnS24sOBBNQjpA0fKUnhMEz
	aSeeOrDd8IbcMB96+lJXoVYKz3YnYpYIPKKmw+KmNpvz8VGtYLCu9WVV84/NjXB4N17F/E
	ds221IMnfHcJcsrQhXvL3OJauMCl7bo=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-132-S4wPb6MSO1ekkZZI3GDm_A-1; Thu, 27 Feb 2025 03:53:27 -0500
X-MC-Unique: S4wPb6MSO1ekkZZI3GDm_A-1
X-Mimecast-MFC-AGG-ID: S4wPb6MSO1ekkZZI3GDm_A_1740646406
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-38f31e96292so401105f8f.3
        for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 00:53:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740646406; x=1741251206;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EyvlqtbZaeJM3spFnINaDI06hIqM+bBC6L0QBlOLKJ8=;
        b=ZU9IrLe4QxbMSD0YX6pUnIbWqNf2o9QBtokPl/HHGvfsndgFdrKt4XvceSJPDp00G/
         B6gvzVBcrGJ95rCNqe6PLKO+OKufc331fsSzhS/UvNR5PilRe5jFf/pzXEttriadmapa
         vAw8KZuU5PWXEuCpYAL8O0w6ZPsxDKTAoetldVkV2pU9tVRAmm9kPojXwT89+SIPzWNT
         WoIHuqO9gQvLz9q2ofKafegwpl5oKll8qnqlUXBHMF6tvszfKbqIze7jadPciXBT6Wd/
         qQKyUaXxKklgQlzUR/dH35Hq2O0603TUub9ssp6F9/LpfRprhU7F1cz3uLVCj3pM5q0K
         kQEg==
X-Forwarded-Encrypted: i=1; AJvYcCWhDZ6EMG+ccEAdiRIfCcAuZb46d8ke4S2vs8tRu/PsgCjf/Pnm7QIc9FSVjNKCqtoPpBU=@vger.kernel.org
X-Gm-Message-State: AOJu0YyciOMx2w6gQ567IrZkoxzvGUV0t0IN7aKTyX5cLaJtwiCbWNLv
	2TQZujpMr2bLPHc2tqGRk01MZaBR1jqoixNZ1MVJC7RJuGeP7z6KRxdg4ppOcZIpFKjbqCJ3FEf
	+qPjW1nUfxx3LWtdNBEfLENaoqYPwGbvqiO+HlUmi7IxIsi/6cA==
X-Gm-Gg: ASbGncsmlCSdvFLq8Y5lvbbKXwCBYKVvUSWG1mxKyrocYpKOdorniFhLLJUzhchdpI7
	1oyFv+UZX8XvpYzHCzlRSqkuZnun1u3QWucXPNN9pKGQ6cdygjtSK4Gr43rk/E8n83sidkFWtcJ
	HFQeC3/ca2ITkFsV8OB1TMuNvHzZAgMiGMo8EUhClWjznc6WCU+99ZIU2tjpw91qdeLhQTFo2PS
	q/abKwJttz6hgR1gqoEbLkR9qu6HxuWoDJGewB8c/cwiqQ2jI1vbxgGlLeqwGODACRfvSB/7l+R
X-Received: by 2002:a05:6000:188d:b0:390:de67:2661 with SMTP id ffacd0b85a97d-390de672726mr3623243f8f.14.1740646405855;
        Thu, 27 Feb 2025 00:53:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGZtPZ71xXc3/ezwCo25Ggz6REeCkcCkX8Y7Z6psxHYAImpw+ef4XDuShBy1cgFq9Op/H86MA==
X-Received: by 2002:a05:6000:188d:b0:390:de67:2661 with SMTP id ffacd0b85a97d-390de672726mr3623228f8f.14.1740646405519;
        Thu, 27 Feb 2025 00:53:25 -0800 (PST)
Received: from redhat.com ([2.52.7.97])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390e47b7d12sm1361883f8f.58.2025.02.27.00.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2025 00:53:24 -0800 (PST)
Date: Thu, 27 Feb 2025 03:53:20 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Max Gurtovoy <mgurtovoy@nvidia.com>, israelr@nvidia.com,
	virtualization@lists.linux.dev, linux-block@vger.kernel.org,
	oren@nvidia.com, nitzanc@nvidia.com, dbenbasat@nvidia.com,
	smalin@nvidia.com, larora@nvidia.com, izach@nvidia.com,
	aaptel@nvidia.com, parav@nvidia.com, kvm@vger.kernel.org
Subject: Re: [PATCH v1 0/2] virtio: Add length checks for device writable
 portions
Message-ID: <20250227034434-mutt-send-email-mst@kernel.org>
References: <20250224233106.8519-1-mgurtovoy@nvidia.com>
 <20250227081747.GE85709@fedora>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227081747.GE85709@fedora>

On Thu, Feb 27, 2025 at 04:17:47PM +0800, Stefan Hajnoczi wrote:
> On Tue, Feb 25, 2025 at 01:31:04AM +0200, Max Gurtovoy wrote:
> > Hi,
> > 
> > This patch series introduces safety checks in virtio-blk and virtio-fs
> > drivers to ensure proper handling of device-writable buffer lengths as
> > specified by the virtio specification.
> > 
> > The virtio specification states:
> > "The driver MUST NOT make assumptions about data in device-writable
> > buffers beyond the first len bytes, and SHOULD ignore this data."
> > 
> > To align with this requirement, we introduce checks in both drivers to
> > verify that the length of data written by the device is at least as
> > large as the expected/needed payload.
> > 
> > If this condition is not met, we set an I/O error status to prevent
> > processing of potentially invalid or incomplete data.
> > 
> > These changes improve the robustness of the drivers and ensure better
> > compliance with the virtio specification.
> > 
> > Max Gurtovoy (2):
> >   virtio_blk: add length check for device writable portion
> >   virtio_fs: add length check for device writable portion
> > 
> >  drivers/block/virtio_blk.c | 20 ++++++++++++++++++++
> >  fs/fuse/virtio_fs.c        |  9 +++++++++
> >  2 files changed, 29 insertions(+)
> > 
> > -- 
> > 2.18.1
> > 
> 
> There are 3 cases:
> 1. The device reports len correctly.
> 2. The device reports len incorrectly, but the in buffers contain valid
>    data.
> 3. The device reports len incorrectly and the in buffers contain invalid
>    data.
> 
> Case 1 does not change behavior.
> 
> Case 3 never worked in the first place. This patch might produce an
> error now where garbage was returned in the past.
> 
> It's case 2 that I'm worried about: users won't be happy if the driver
> stops working with a device that previously worked.
> 
> Should we really risk breakage for little benefit?
> 
> I remember there were cases of invalid len values reported by devices in
> the past. Michael might have thoughts about this.
> 
> Stefan


Indeed, there were. This is where Jason's efforts to validate
length stalled.

See message id 20230526063041.18359-1-jasowang@redhat.com

I am not sure I get the motivation for this patch. And yes, seems to
risky especially for blk. If it's to help device validation, I suggest a
Kconfig option.


-- 
MST


