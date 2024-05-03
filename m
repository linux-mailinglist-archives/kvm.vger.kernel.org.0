Return-Path: <kvm+bounces-16521-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2262B8BB02B
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 17:42:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B60091F232C8
	for <lists+kvm@lfdr.de>; Fri,  3 May 2024 15:42:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29E3153BD2;
	Fri,  3 May 2024 15:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dv+kE0Et"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7115E26296
	for <kvm@vger.kernel.org>; Fri,  3 May 2024 15:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714750909; cv=none; b=ECL9dlRLietEwXTM2j6uOxpsQ963nM3Wv3sbjLl15gkX92H+mVUfytv3geaxeCup70KBspD5n8qDfXvCetWq80l17myOQ+DGwSIPZsqmReK2INxlDSNqSL9xy/Ig5ZX/hsEQwY9vMqU2OyQSPM3VaTUcHUWdcTIX4GYohfsOIhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714750909; c=relaxed/simple;
	bh=rVld10tE0C52HYanJVGtq1wK+8/S48n/EcxiWlbDXtw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eBF59DemeM3+ZIXX40xBaDy1fFgxc8rXtcWl++AqFSWRBoy3VL54X1DoMwcXMgxAcY/5mEVOgbnLcw+o06RQM3cs6Lhh1+vuXMzVTAxp6DQvoVug5J2rufwCIWVijQLQz7mLpqbqtAin9D0v2SVZZHg9VFX2Kr31uBClSIdmYyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dv+kE0Et; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714750906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pnFu+vibcwvq3xNtE6dk2KrEqW6IYlf8YWi6hQ7dcY8=;
	b=dv+kE0EtZlg7tXI97TzCMX9Ict8RFEkT9TNbKemUZLHrjSe3ytJ9a5xn+vxLSzG9vk3iV2
	7PCbubqdT5FGm5Lh23JTjQXP0JkjAbhuRpa+YwtPH89Kve0nxtJswhnyw5+wf2uYVF4+ak
	M29/apyarVfUmXamYxwJZAdWJpxGYKU=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-157-sQI60goDPf6hQM0C3FV0aA-1; Fri, 03 May 2024 11:41:45 -0400
X-MC-Unique: sQI60goDPf6hQM0C3FV0aA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-36c6dfc6134so23114705ab.0
        for <kvm@vger.kernel.org>; Fri, 03 May 2024 08:41:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714750904; x=1715355704;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pnFu+vibcwvq3xNtE6dk2KrEqW6IYlf8YWi6hQ7dcY8=;
        b=ALJ6JzE7oTRtPomyiSQ24rghiqZNIKklTS4t+6K4xFpsB/Sj0N5CeA9yQ/4zXSCHkh
         ZuDNDUKR+getjGQ0XN7AVwAnBh5EkwIE1JoCPAuJxFhneY4UGUwJWx+ipB6Ho994FwCe
         aOyEsN5wvE5NH9ZYHOBCd0QE6rwUTtE1n+QLuoz5lXZuUZ74LzmFtDyQhhPtud9NgM71
         cdl8i4jOlFYg9BEMAQlvFzwzNj6R8N0s7xMPXjHDeh5PsnGDOYbVVCH+xbpPZG6z7cIn
         Rjspvpth5SW+qxPtlbhBjTGrbwzV14pS5DKoaj9nttvQQnYHbkqbjIgNbe3e0aGXML/v
         zVYw==
X-Forwarded-Encrypted: i=1; AJvYcCXeSMtKD7EioB6S/mLVQsWwXVadl6BCmFj1yL5Np1rzjmw72yZlUvlR093cZgTJyk/e3ZL50+RX1k8NSzvhMrGn9n8p
X-Gm-Message-State: AOJu0YwzE0E6tyv3NCNElJQ31pppC7Rljg9cfLcLqcy02cb1mwSutrdU
	GdnkoAa33yYudNwoqKad4NwHdidnqlNfryWuXbSnPu9Dc+KUAV4OcLryoMvaa9zCzCDdm9i0IwK
	Wd8nvG0Emc9GRv6aKpUoKzs7twVrCiXT5YaH/dAQqwRSTn8abEQ==
X-Received: by 2002:a05:6e02:dc3:b0:36c:9b0:2e5f with SMTP id l3-20020a056e020dc300b0036c09b02e5fmr2581770ilj.7.1714750903581;
        Fri, 03 May 2024 08:41:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4dQjkdj8kmj0CmeULShj4qV/zxtJET/hncYpj1wfcrqV7ncF7NLfAQMxwQcxXu4DLh0IugA==
X-Received: by 2002:a05:6e02:dc3:b0:36c:9b0:2e5f with SMTP id l3-20020a056e020dc300b0036c09b02e5fmr2581709ilj.7.1714750901795;
        Fri, 03 May 2024 08:41:41 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id o16-20020a056638269000b00485128ef27csm838777jat.168.2024.05.03.08.41.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 08:41:41 -0700 (PDT)
Date: Fri, 3 May 2024 09:41:38 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Xin Zeng <xin.zeng@intel.com>
Cc: herbert@gondor.apana.org.au, jgg@nvidia.com, yishaih@nvidia.com,
 shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
 linux-crypto@vger.kernel.org, kvm@vger.kernel.org, qat-linux@intel.com,
 Yahui Cao <yahui.cao@intel.com>
Subject: Re: [PATCH v7] vfio/qat: Add vfio_pci driver for Intel QAT SR-IOV
 VF devices
Message-ID: <20240503094138.1f921e49.alex.williamson@redhat.com>
In-Reply-To: <20240426064051.2859652-1-xin.zeng@intel.com>
References: <20240426064051.2859652-1-xin.zeng@intel.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Apr 2024 14:40:51 +0800
Xin Zeng <xin.zeng@intel.com> wrote:

> Add vfio pci variant driver for Intel QAT SR-IOV VF devices. This driver
> registers to the vfio subsystem through the interfaces exposed by the
> susbsystem. It follows the live migration protocol v2 defined in
> uapi/linux/vfio.h and interacts with Intel QAT PF driver through a set
> of interfaces defined in qat/qat_mig_dev.h to support live migration of
> Intel QAT VF devices.
> 
> This version only covers migration for Intel QAT GEN4 VF devices.
> 
> Co-developed-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Yahui Cao <yahui.cao@intel.com>
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> ---
> Changes in v7:
> - Move some device specific details from the commit message into driver
>   and add more comments around the P2P state handler (Alex)
> 
> V6:
> https://lore.kernel.org/kvm/20240417143141.1909824-1-xin.zeng@intel.com
> ---
>  MAINTAINERS                   |   8 +
>  drivers/vfio/pci/Kconfig      |   2 +
>  drivers/vfio/pci/Makefile     |   2 +
>  drivers/vfio/pci/qat/Kconfig  |  12 +
>  drivers/vfio/pci/qat/Makefile |   3 +
>  drivers/vfio/pci/qat/main.c   | 702 ++++++++++++++++++++++++++++++++++
>  6 files changed, 729 insertions(+)
>  create mode 100644 drivers/vfio/pci/qat/Kconfig
>  create mode 100644 drivers/vfio/pci/qat/Makefile
>  create mode 100644 drivers/vfio/pci/qat/main.c

Applied to vfio next branch for v6.10.  Thanks,

Alex


