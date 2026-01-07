Return-Path: <kvm+bounces-67301-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C7E99D005D4
	for <lists+kvm@lfdr.de>; Thu, 08 Jan 2026 00:06:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 960983043233
	for <lists+kvm@lfdr.de>; Wed,  7 Jan 2026 23:05:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2E632F7AB1;
	Wed,  7 Jan 2026 23:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Je/CCV6c"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f196.google.com (mail-pl1-f196.google.com [209.85.214.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D049526E6F9
	for <kvm@vger.kernel.org>; Wed,  7 Jan 2026 23:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767827144; cv=none; b=T9n5JHnbmV9ox7d68XYhayh/xwlNjZd6Z3kd0z6Eu4zGReCNUiKqGhOF9wHmPMabGQDsmDDEpRDakAi62MzFPeW2tKdKbUn/hKv4pP0kZ1ctUFTKOV3D1xyDIqqP5o+wUjKbHsE450BSpovV3K1mz6DXBfX9UoexYeGH4PFMmXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767827144; c=relaxed/simple;
	bh=8VDJsmbiIoq1x5g/6dWyU2ReAajGODADZaHm9iuAF3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lttabrVTB9hqA1FJp2SBBVciI5iJrVaRTzbzgLsI4IYnvQrcimMWKxHtXIV3kPvgcMd2xbjQRwpqE7cqi8AmI8HwSXOVydvNlAVy+8WkpLtOzERCcOdrRmea21dYo82dnc3GRnT/nYgk84HcwASvHAWkPbhQAo/BxqqVWDwd6gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Je/CCV6c; arc=none smtp.client-ip=209.85.214.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f196.google.com with SMTP id d9443c01a7336-2a0c20ee83dso25526225ad.2
        for <kvm@vger.kernel.org>; Wed, 07 Jan 2026 15:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767827142; x=1768431942; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rw3J+Dzm0fn/t3n/9u+hY5JolnkxDtXW+DtWJ19gmJA=;
        b=Je/CCV6c6eS/WN388Wg26+q8X4nxjhtUOD0lwgPOgPJr9a+32srZx/8exWcfUfa4a6
         PKYmjRfRYFTIbGPd3u5RhKlysE42XRdMcaG8JJU5Dou5kFf984sLy/aoXBFWDFggwA5X
         i2Ycq/45TkNQ6jV16gjMHdkGPsGGmsfzpIAwMbTaee+KiezyVqmJBex/h2AFR6DxOEwo
         e7wOC7bMd1euatj3D+3zVVrnVFuDsSmSQ7GEF6kESsfq0fyakhxkQyNC4zAPgkjtLFrn
         DyC1j8Q5uBAuzoWyOV0ssBCoNxtpkPhqCA6WTwJf4CjhpE5Wi8dSVKFVW+djZp1szmty
         GiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767827142; x=1768431942;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rw3J+Dzm0fn/t3n/9u+hY5JolnkxDtXW+DtWJ19gmJA=;
        b=rVYM+32lvVebrNRbkIq+oHj3qhDwfkTcFXNvUMzg3pG9vQdOT3GnCboXjrLZ3X0DQR
         GR46mzG3rx0olKYKx+4MS4pNV8F37YB/Y0AqCbFitjkIkpYb7GTGYmhJRLbA9To+boS7
         cuODgU4NxTgTomdcKK0cg1j+qdueZD/do6wAN3zpX08l9NfcIoaMnVVQ/9JQC37H92fS
         M7bBInSjr2xWyfj0Apdji4QgTOz9ls2IeX4khTORaPvhn5nPsr+sT4H0Ysxkdq3v5GbS
         qzccu6ZIPU1CJaGOCYlQNFTw6Vu7MYIMwRwLMRJCVzkB0kgrB1QMZhWStj6U5DteeCHj
         SX2w==
X-Forwarded-Encrypted: i=1; AJvYcCUJpO+3IJ83Y2o0lfHp3NjwXMIq5+Bk29P+4QERMvDWlFVWD6Hxm/qdQSDC3BWAdOIzaj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxlfkCaOdTYhYPetcPTY9k2BFfxFetJ3IhahtAe9yYFaBYT7Wq8
	B07FnyBv5dOl13EQRYteJTLYehpX02Nvg1g9yTiz6Nyd7H0HzPXR3B2iUox+sWkZyg==
X-Gm-Gg: AY/fxX4vBVnYJkx70GKekrGP3ymBso1BcaI+i4xFMkEelWXlqr02aAiDuZPx2keB/tI
	dJY8Dpoyw1i/FoDn2BW35Az2V6Gi/njAVZAjXOOukzNZfx0Xc+aottrLBNb4C0P9cTXaTIgrw7d
	QrYTPjg7uBVNMNbQ3ylbVAUDgiXajGRjnQOY/zg7Q/UTcTBm78VthzfMgCPtS3K+IsgTTGctGc3
	gywhIB/SJJeyo9JkaW5MhlPuL68GhWqzXNZHEBVhRXLQytImI4fNC0PyuKrae/YA6A13BaBXB5y
	jnlwf0H7EGPCEIaiNoe0mYZWLPPBlEBV0/GJZ5rz2g+pek+LXRTo9gwjmt3cnTI0J+Sfxho++zw
	hUO7ElXEBmQ2xpUiR0uOXhsESGaRySzr9qiFCDO4rFTrQkxAYMldGxQi6y/ZwG0mTqfUZUTQP5i
	rIafE3I+F9CpcLyyPEj16illwAPcvT6Wp/CJhouj2QvAdjqLrelSI4Ma4=
X-Google-Smtp-Source: AGHT+IGu2DGp2qBk6zfAnR5thPuV+zmyN+FMR7VUZy0unbk+JtT29C3+3CGB2bP1kjcj+iUW71o/+Q==
X-Received: by 2002:a17:903:2ec3:b0:2a0:ad09:750b with SMTP id d9443c01a7336-2a3ee41514dmr26934625ad.9.1767827141945;
        Wed, 07 Jan 2026 15:05:41 -0800 (PST)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3c3a328sm58906885ad.4.2026.01.07.15.05.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 15:05:40 -0800 (PST)
Date: Wed, 7 Jan 2026 23:05:36 +0000
From: David Matlack <dmatlack@google.com>
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Josh Hilke <jrhilke@google.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/6] vfio: selftests: Export more vfio_pci functions
Message-ID: <aV7mwGtyAo7s5yuW@google.com>
References: <20251210181417.3677674-1-rananta@google.com>
 <20251210181417.3677674-5-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251210181417.3677674-5-rananta@google.com>

On 2025-12-10 06:14 PM, Raghavendra Rao Ananta wrote:

> -static void vfio_device_bind_iommufd(int device_fd, int iommufd,
> -				     const char *vf_token)
> +int __vfio_device_bind_iommufd(int device_fd, int iommufd, const char *vf_token)
>  {
>  	struct vfio_device_bind_iommufd args = {
>  		.argsz = sizeof(args),
> @@ -314,7 +322,15 @@ static void vfio_device_bind_iommufd(int device_fd, int iommufd,
>  		args.token_uuid_ptr = (u64)token_uuid;
>  	}
>  
> -	ioctl_assert(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);
> +	return ioctl(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args);

For ioctls that return 0 on success and -1 on error, let's follow the
precedent set in iommu.c and return -errno on error from our library
functions. i.e.

       if (ioctl(device_fd, VFIO_DEVICE_BIND_IOMMUFD, &args))
               return -errno;

       return 0;

