Return-Path: <kvm+bounces-60571-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD81BBF3C26
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 23:32:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB62348849D
	for <lists+kvm@lfdr.de>; Mon, 20 Oct 2025 21:30:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C9B3334C1C;
	Mon, 20 Oct 2025 21:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jdqaA1UZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D6833375F
	for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 21:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760995794; cv=none; b=lgUK6cinzN9XY6DtSvb2Vl1sSZ6+4HXBJ9kJfOzzZM4PRD7TLwiUgcwP2H7SkmA512sJtBzt6Q2e/fGpYpyLKvGYuhZp85s7OuAN5VuFWcWlVhSSD4F3927i5if7IjgSAIsCO57b8XpbfuQq0TlKPTuw7j3S9O4gS4vSqRO7yLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760995794; c=relaxed/simple;
	bh=PqlFilZVmSbZKJLHpAkGDW0igOyGGkLNA6FRjPXGD80=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GFTv9cw4hT3FbDgIM2rBuR7NVlUKEjf4UBJQ/G8TvoD9cciUpeeA4xJ79qdKHqnrAPnJmsfVigLSpBlCtMdC/1t4CVbnUTunIlzONQwy2hvpbOqoTGj8vBpnZnXRUV13cwIuh9Kcn2gq+smoYewepBOgLt6UMrZuSPVntItRA+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jdqaA1UZ; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b57bffc0248so3381278a12.0
        for <kvm@vger.kernel.org>; Mon, 20 Oct 2025 14:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760995793; x=1761600593; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=26ASe6SsfcfwXN+JG/2GTGw7BHHgM1XlqQIlC1K/NBc=;
        b=jdqaA1UZWsigzRkXK2O8p9ZQRSa+FDJucZvY9vIZ2BoFf1KNt3MbiDs/62NGsrCOg2
         +ji/hFkyfbsmnE0rwdNEtIylVUnKfefBtHhh/6EOYh+9tVd+THKYWhq+fI1ZEbdhro11
         vn2+42low1nO93m0mJkAor0w5myk7GaQ4IXqojE5v1HQQtdFTHB+I8m36E1XFnL4sQyx
         V7/KxdJlCH1CjhJAjvOoNcX7Znw8KNJMeP6CcSL/u8a8C02oO2QqgyH7tjwTNES8KFyU
         irFosAixaTf4Y0zIUR6td7j210oJ3OayDY4HpFL+Ov9ev7xYEHSHa9xxvnRpcw+HhVE2
         hZdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760995793; x=1761600593;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=26ASe6SsfcfwXN+JG/2GTGw7BHHgM1XlqQIlC1K/NBc=;
        b=vfWdjrFy9gGO+mTbNBthDyhYh9tDHtpMIZ3KmAhs65ksEq0OlRqGj0bGqNgIz7rIed
         0f41niFhzpY8UPwOvylhq2LE/cqJPp19BX30z8QlxwFSlmXOPcN9ySf1puzQfN5gRRgd
         lPH9KvllwzGIJV2JCnoJ+wUVJLbCMvQnOCmr8FPygaR/26UMi59OPm9gsEbuhpGDeu+A
         HSwBrC77iKiCU1lH08cdBH1cN6/nhKDorP5Rz2jq3JqeuaUWA0bPZBbHuIrboIF7kO9J
         k43VZBlXrD2gXnZMBJy4M+DHpGu8JU2n3BeRZiNkPFZlUegmMyApjacWvdqTOuTEVax6
         zZAA==
X-Forwarded-Encrypted: i=1; AJvYcCUe3DNdXXfdDz6SIihCLRo9NkWrfobb4EiB/wjF1lwBiLa4/EKWAagb+A7+7/6AInc9/m0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyFSRSucnL/jtX36H7Fd2/yjuyFl0qojzR68LSe/65XIws/SKag
	5aSFaDF/rdDTXyCAsEgeJy2UvfGaqpj0uOyvl+yuhG02NPtwK+JgHBthrO6CwfkTEQ==
X-Gm-Gg: ASbGncvR78LSg7qafKBfOPdgF33PxqT3Dm3HQIcuKX2q2piIoaofl/g9DgP+JDZbx0H
	gb/W+v8WYaStwFWferMlmElq9/lANyI2EVm6OfVpaQwzGp0fb2VX/BL4/4AuLJ/vPDxlASjmZAr
	j1Chz8YxRembgRm/RF+R3VQbBoEmPANL42wv9jiJ46TUDoC2PlGkuPyBXsFSCU0N1KzI4vvwjuS
	fBRrKEig12b0tct2CZpUivD/uW9673TemwfkeSRnluP2a02PMJCnrg4xxCMUUs9F8NcqQLTj3G3
	IMNcLtI+sQLNEktzgXYoUxQzPN8di0lcH4HsJ9AWK/AOH/P4BVoOGBBeIGb/P66pi101Eaz/CqJ
	cJBZtn5xlwWwOXn22UK3R5KL+e31cHM/IZ2POZjvZnYLPkZ07he/TIrISGf7Ia+SglKwgP4zGIB
	f9SR5D6eaNF7ByGLrqtMuac/Jjuj3qCFCmZdto6WeLzbhtRg==
X-Google-Smtp-Source: AGHT+IGk4YTNxvDRPlGdzR4t9GlLZJuciLlt+LaOjUUn8d6Qy58ILE26bgum5kvXRpVHjALaky9Cew==
X-Received: by 2002:a17:902:ecc6:b0:249:71f5:4e5a with SMTP id d9443c01a7336-290c76f8182mr169199055ad.26.1760995792362;
        Mon, 20 Oct 2025 14:29:52 -0700 (PDT)
Received: from google.com (96.75.168.34.bc.googleusercontent.com. [34.168.75.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292472193dfsm88852855ad.105.2025.10.20.14.29.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 14:29:51 -0700 (PDT)
Date: Mon, 20 Oct 2025 21:29:47 +0000
From: David Matlack <dmatlack@google.com>
To: Vipin Sharma <vipinsh@google.com>
Cc: bhelgaas@google.com, alex.williamson@redhat.com,
	pasha.tatashin@soleen.com, jgg@ziepe.ca, graf@amazon.com,
	pratyush@kernel.org, gregkh@linuxfoundation.org, chrisl@kernel.org,
	rppt@kernel.org, skhawaja@google.com, parav@nvidia.com,
	saeedm@nvidia.com, kevin.tian@intel.com, jrhilke@google.com,
	david@redhat.com, jgowans@amazon.com, dwmw2@infradead.org,
	epetron@amazon.de, junaids@google.com, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 12/21] vfio/pci: Skip clearing bus master on live
 update restored device
Message-ID: <aPapy8nuqO3EETQB@google.com>
References: <20251018000713.677779-1-vipinsh@google.com>
 <20251018000713.677779-13-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018000713.677779-13-vipinsh@google.com>

On 2025-10-17 05:07 PM, Vipin Sharma wrote:

> @@ -167,6 +173,9 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_handler *handler,
>  	 */
>  	filep->f_mapping = device->inode->i_mapping;
>  	*file = filep;
> +	vdev = container_of(device, struct vfio_pci_core_device, vdev);
> +	guard(mutex)(&device->dev_set->lock);
> +	vdev->liveupdate_restore = ser;

FYI, this causes a build failure for me:

drivers/vfio/pci/vfio_pci_liveupdate.c:381:3: error: cannot jump from this goto statement to its label
  381 |                 goto err_get_registration;
      |                 ^
drivers/vfio/pci/vfio_pci_liveupdate.c:394:2: note: jump bypasses initialization of variable with __attribute__((cleanup))
  394 |         guard(mutex)(&device->dev_set->lock);
      |         ^

It seems you cannot jump past a guard(). Replacing the guard with
lock/unlock fixes it, and so does putting the guard into its own inner
statement.

