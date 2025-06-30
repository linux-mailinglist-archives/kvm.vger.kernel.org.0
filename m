Return-Path: <kvm+bounces-51102-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EA01AEE1BD
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 17:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3AA51882530
	for <lists+kvm@lfdr.de>; Mon, 30 Jun 2025 14:59:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 549E928CF6B;
	Mon, 30 Jun 2025 14:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i94hf5F4"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADF3228C87B
	for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 14:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751295465; cv=none; b=tT8yVNJDzJbefyjVpPqi7pjXZbbAlcf91RgHn5pgdNt2KN7rfNDbg059pj8dqwWAF96vp+sT4u1/eVwqgKOihYV7X6KuQBbO3QP31CYzkw+nI/uRe4lPF7egfUuPqluRknIz1RsZKvRtcNbWRgdlIbOVjKZ+9zDm/Ntwb5hEgCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751295465; c=relaxed/simple;
	bh=Q6gW51mc3+AXnkKmU1jxofKeTI9/SmVCB+gDtWPXGgo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l+GI6STwD3F21KBt4gRirbQQVBsltcO4P+6Dj2z8MtM9L3RTgrxQEihBNu47hoKFyoGjXtiYj+LVzAvOILCGFIxnzX4wX/4I8KGYBaV8vZ+C1/04nBu0LOfQzO6nWJgHyGu6880zVOKzh5P6OjchKJ6YM4EeWY0Tvix3IHpmrEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=i94hf5F4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751295462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PjtiOXW7e04JEzs7v9dm5HF2XxY7SOpDFAKh/GrjZyo=;
	b=i94hf5F4KH1S0cwOdU1xSGpz9w6TYsVk7BDP/IpYOVwX7vUiEBkARNrtmt2NG4vxAMcJb7
	xnM6NHiDWo2Hf+uFXJJGSRjyL1Bu7lIag7dyzVS33jMhXpE5OgPAb/5Jv/rSy9K7qH/ws2
	kkxBKZhD0Ia5zSB9yVq8nMERHMIMviQ=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-374-tc8S2pmBPi24iqxdk3-VFA-1; Mon, 30 Jun 2025 10:57:40 -0400
X-MC-Unique: tc8S2pmBPi24iqxdk3-VFA-1
X-Mimecast-MFC-AGG-ID: tc8S2pmBPi24iqxdk3-VFA_1751295458
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-73b26178c89so295849a34.3
        for <kvm@vger.kernel.org>; Mon, 30 Jun 2025 07:57:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751295458; x=1751900258;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PjtiOXW7e04JEzs7v9dm5HF2XxY7SOpDFAKh/GrjZyo=;
        b=XJu3p+4TWTx6Dsz07Sd492y3rCwjhHNlsuNN7VAxDVokpmKPQpg+UIeDLI/p2yiA/i
         OMocAoJ2yfjb2N3eM6Cm1YdFykIyiuOZct2BlSybbgzv10SuOG1zJgT3MPVHr9wbmMEs
         V9NMqWdxu0ZFegrT24mdVc1CbqphgeG2VNgYZfT7f/b935hBTRXQY2HglbYVLU1RrZWc
         F1h5ozkt77veHryvvY++QA74CRJ+zs6y0t5pW6K7j9zTjrepUhT1IOd9X5/Mt8/PNPNy
         w36KyMdY0noyC/NKbY9JZCJwzq1LTNjlnBMzGXEBxuvSJNwvkmvkNKhRf01mCMmgtFGI
         touA==
X-Gm-Message-State: AOJu0YwDQ2IUMtJdjFklyYVfCKFl5YjZ9AMJGeagSiwIAc5GRlPr0TTe
	w7P/mH0kzo1DouQGjsvAFmlbz2Xq+UHoBHzjN4Gb5r3EwQZKUE9wIRKQ9zzSsVB5V562UIfpnX+
	dMw7M6nFB71j4xV/UP464XvUJUB7oFjqDcw6dZPFTXNiUEgw7AA6d4A==
X-Gm-Gg: ASbGnctZYE3xGy/f7q5MAUsRxD1yVtgHKWAKOPEsJnIoWQ5wuBm6yMMpIYYG4VyY7x5
	DwUiJjw7YRY5Oq3mScEMcsZXMze8cVF4Tl9pHPPwMviWYNbyfZtpZVS6SOm+6iJmg/C1GkCTx7W
	FmA5kJDH9NWiO8hxHfYiZjtvJaFbhOUOBG92SsnvSO5IPHmTFvwMvUQc1PusAW0AfLhcG7dtVMB
	pnqp9FTR5zzT6KVtYE6LPIUwKXIm8TGXmp/orjO1IRb0fsbeaO8kA72CGwbRCnNDhSIBy9BuZHE
	CGKwPFzAtMAiL0UddCqvrOv8Yg==
X-Received: by 2002:a05:6830:6804:b0:732:262a:c5c4 with SMTP id 46e09a7af769-73b0d7f9034mr2528286a34.0.1751295458284;
        Mon, 30 Jun 2025 07:57:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkqCTomJIxjmmL9pdaXGWX0D/k0eRKheCcbrhTibFqjkwKNmsUW11b/SNugk8Z2hk843Z2Vg==
X-Received: by 2002:a05:6830:6804:b0:732:262a:c5c4 with SMTP id 46e09a7af769-73b0d7f9034mr2528273a34.0.1751295457868;
        Mon, 30 Jun 2025 07:57:37 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-73afaff249bsm1693274a34.6.2025.06.30.07.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 07:57:36 -0700 (PDT)
Date: Mon, 30 Jun 2025 08:57:33 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Yi Liu <yi.l.liu@intel.com>
Cc: <kvm@vger.kernel.org>, <aaronlewis@google.com>, <jgg@nvidia.com>,
 <bhelgaas@google.com>, <dmatlack@google.com>, <vipinsh@google.com>,
 <seanjc@google.com>, <jrhilke@google.com>, <kevin.tian@intel.com>
Subject: Re: [PATCH] vfio/pci: Separate SR-IOV VF dev_set
Message-ID: <20250630085733.48299a47.alex.williamson@redhat.com>
In-Reply-To: <005c3ac7-dfa1-423e-a095-01b5df535b9c@intel.com>
References: <20250626225623.1180952-1-alex.williamson@redhat.com>
	<005c3ac7-dfa1-423e-a095-01b5df535b9c@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Jun 2025 21:15:58 +0800
Yi Liu <yi.l.liu@intel.com> wrote:

> On 2025/6/27 06:56, Alex Williamson wrote:
> > In the below noted Fixes commit we introduced a reflck mutex to allow
> > better scaling between devices for open and close.  The reflck was
> > based on the hot reset granularity, device level for root bus devices
> > which cannot support hot reset or bus/slot reset otherwise.  Overlooked
> > in this were SR-IOV VFs, where there's also no bus reset option, but
> > the default for a non-root-bus, non-slot-based device is bus level
> > reflck granularity.
> > 
> > The reflck mutex has since become the dev_set mutex and is our defacto
> > serialization for various operations and ioctls.  It still seems to be
> > the case though that sets of vfio-pci devices really only need  
> 
> a nit: not sure if mentioning 2cd8b14aaa66 which convers reflck to dev_set
> mutex is helpful. Perhaps, it's welcomed by people working on backporting. :)

Sure, I'll just insert a reference here on commit: "... has since become
the dev_set mutex (via commit 2cd8b14aaa66 ("vfio/pci: Move to the
device set infrastructure")) and is our defacto..."

> > serialization relative to hot resets affecting the entire set, which
> > is not relevant to SR-IOV VFs.  As described in the Closes link below,
> > this serialization contributes to startup latency when multiple VFs
> > sharing the same "bus" are opened concurrently.
> > 
> > Mark the device itself as the basis of the dev_set for SR-IOV VFs.
> > 
> > Reported-by: Aaron Lewis <aaronlewis@google.com>
> > Closes: https://lore.kernel.org/all/20250626180424.632628-1-aaronlewis@google.com
> > Tested-by: Aaron Lewis <aaronlewis@google.com>
> > Fixes: e309df5b0c9e ("vfio/pci: Parallelize device open and release")
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >   drivers/vfio/pci/vfio_pci_core.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)  
> 
> Reviewed-by: Yi Liu <yi.l.liu@intel.com>

Thanks,
Alex


