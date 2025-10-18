Return-Path: <kvm+bounces-60440-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 73CEABED1DF
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 17:00:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12FAC19C3927
	for <lists+kvm@lfdr.de>; Sat, 18 Oct 2025 15:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F42B2D7DC8;
	Sat, 18 Oct 2025 15:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OkqYqVGK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111D6285CA9
	for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 14:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760799599; cv=none; b=dZGbEkgcSqffyvGHa7TslOJzwoEWELxGYSNeOG0nV0CZ/Xga4gieTSZAqGwVeTf/G/3iyNric3IrAWnpjzIagzwALfSwrOlDG+M8QxYckHc3bBYAJ7bkivAiGa9Qq7q51NtRm0Kti8/dyefGB/TJyxba8iWWYDgqq36TWf2QuR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760799599; c=relaxed/simple;
	bh=RxRGGS34lOYtj1tSF3o9XGto7oo+cPrOhIqsrmS/Bwg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GPYLq8/t+feMlcUaoX23AAIJw95KZxcOpEJew4vFSaqRUDRGVkqpVA26k9rETGfeP9h02hB5rQl82d1LwuEwr8phlTAfypUdJm9841Nkxv3bGhDwaSxixGxDy08+4r9N2LJGDAxQLKL4YbaIsPTqhGY6c8TAG+ugoNSTUIyX828=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OkqYqVGK; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-290da96b37fso102135ad.1
        for <kvm@vger.kernel.org>; Sat, 18 Oct 2025 07:59:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760799597; x=1761404397; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9SjKrzbC5Tx+d+FYfgi0Q+xGdmlz3Y5FBshE2AUsLRs=;
        b=OkqYqVGKYHwDdEwQJBt2VkDH5MaQIyGq3FtXkW08/OwuvvPJDWPWk5TwDvn7M3Aqtr
         IZQtMOCZ+F83AY4oBm0UOIBTTHJzCPB8/acfwSYbzppaujUrw5395lpEhzFcQaKGlqVq
         w+yOpAZYLzOE3iBSiZpzQuCDCbhyG3W6byh99Mf5XmLp7XhnP4sZgxu3o3px6Y6YvByz
         7i5rnuI5e4GHQ0wvyLh+d090sdS4MIwW+nTheFVi0jCE2xYE+0romD5W31sYPFBE+R/0
         1qyvW86n5PUnYpJIVkPwOqU/JyVV6f3r8480bWL7qqc/+QrhM5MvKzR5E6HtKrdIXQS2
         Q52A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760799597; x=1761404397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9SjKrzbC5Tx+d+FYfgi0Q+xGdmlz3Y5FBshE2AUsLRs=;
        b=bxmnR4qiF0jbWefxFVUYvc/MUa8HQ5uVkAJeINONO/J7ARdx0aW1yBK7CYLZqOUTTL
         BXPviPd1ODz1bhw9g57QL3LA0i5jrlh30bqQo+mDu/SMSkJvO5CZ3JbkDCkmlbbCV9AU
         mrjt2+CClcFZyqV6qdX9vShKfcc/Zf2DW3jiwhTDaUrmEcnpuM6MCjBleifNmi4qjMSl
         CDtqTUQfzun7Hx6uZurR/WGiu5g5RgHJCPPWBCpA9Dkx0rd1RBQ77MjaewsOnuPAFD8n
         g1kKPT2CwDRif0Pd7pg6M4EyILkBCTjvhNPJFhB+sN4FCXb7gordCW6v6+Ihs5PwtztK
         IYug==
X-Forwarded-Encrypted: i=1; AJvYcCXJShPS4b5aSN/30oNdCNyqCEpbOgbyIHBQbqQ3cVCQ4ky2+dFhQzvi788JM13EVjkpP78=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvaLmSWORiLi9A5enamTodMy8wobcYVMW+EiskvDHXjg/rJPN4
	f+agPqz4HPiiN28YouESUZp8x2/gjsCHwX8n/GRs3BlmBBfx9hjs7I3aO09oCDqHgQ==
X-Gm-Gg: ASbGncu3ROp4R6xuz1oYAhMAZr8uI0AjpwfWl1TYRyAXyaT5wkd+blCTEl6FjcLewKk
	y30AR7vE0OgbkDZkEWmwBU+pKEjocQN/RZgnOVb98lZ8T9a5rsQ9dLO3/PynYyFiWO1SZ3n936t
	iR91X38LQdT1Q7kJvz8xFTmFv0ZKxauNCNsLn/ealXg7um6EHr4jpOmhGCLbVh4f5RrCvZJ201s
	9e+1x0axPDIfcI7jEx8rWPI9SDo1iv/ifao3i7jYWTA25VKviEgGUTjZD6r3uiAeax4zaXDmECf
	ApSIjzALNW4CS//QNL1BzG//hdHZj0PU96p8hqTiLCcryo8biq2ZmXnPkhBmquQgr9YpKoyDmF1
	WJrASasTVM4uH1ZsRRYchRmxY2E7ZRBfYnQqTug3Efcjwo458aqoxCKqtZBgodoO55i+ZV93f97
	o92m4Ki2/n4FQ5DPFSiswRRIn7A7tqvriakg==
X-Google-Smtp-Source: AGHT+IEO4meUUEecoQCQ1m49ew5u3IzhZQhIoa/TkD8EI1gJuwGpLMOCNbvdEHLSvt4FD9IHI/8J/w==
X-Received: by 2002:a17:903:2284:b0:26e:ac44:3b44 with SMTP id d9443c01a7336-290879ecc6bmr22769125ad.10.1760799596925;
        Sat, 18 Oct 2025 07:59:56 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a23010d818sm2994154b3a.53.2025.10.18.07.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Oct 2025 07:59:56 -0700 (PDT)
Date: Sat, 18 Oct 2025 07:59:51 -0700
From: Vipin Sharma <vipinsh@google.com>
To: bhelgaas@google.com, alex.williamson@redhat.com,
	pasha.tatashin@soleen.com, dmatlack@google.com, jgg@ziepe.ca,
	graf@amazon.com
Cc: pratyush@kernel.org, gregkh@linuxfoundation.org, chrisl@kernel.org,
	rppt@kernel.org, skhawaja@google.com, parav@nvidia.com,
	saeedm@nvidia.com, kevin.tian@intel.com, jrhilke@google.com,
	david@redhat.com, jgowans@amazon.com, dwmw2@infradead.org,
	epetron@amazon.de, junaids@google.com, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [RFC PATCH 13/21] vfio/pci: Preserve VFIO PCI config space
 through live update
Message-ID: <20251018145951.GA1034710.vipinsh@google.com>
References: <20251018000713.677779-1-vipinsh@google.com>
 <20251018000713.677779-14-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251018000713.677779-14-vipinsh@google.com>

On 2025-10-17 17:07:05, Vipin Sharma wrote:
> --- a/drivers/vfio/pci/vfio_pci_priv.h
> +++ b/drivers/vfio/pci/vfio_pci_priv.h
> @@ -109,8 +109,13 @@ static inline bool vfio_pci_is_vga(struct pci_dev *pdev)
>  
>  #ifdef CONFIG_LIVEUPDATE
>  void vfio_pci_liveupdate_init(void);
> +int vfio_pci_liveupdate_restore_config(struct vfio_pci_core_device *vdev);
>  #else
>  static inline void vfio_pci_liveupdate_init(void) { }
> +int vfio_pci_liveupdate_restore_config(struct vfio_pci_core_device *vdev)

This should be static inline

> +{
> +	return -EINVAL;
> +}
>  #endif /* CONFIG_LIVEUPDATE */
>  
>  #endif
> -- 
> 2.51.0.858.gf9c4a03a3a-goog
> 

