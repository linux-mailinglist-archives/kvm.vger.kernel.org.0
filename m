Return-Path: <kvm+bounces-52661-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 848FFB07ECE
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 22:23:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 451BF4A80A4
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 20:23:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BC122BEFE7;
	Wed, 16 Jul 2025 20:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ISuLrsd7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F69A920
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 20:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752697378; cv=none; b=cFnIKkgyXf6vSAkah/rXwnLb8lxy51P6S3hpaIcUTflNH1KI3wjaS4ZoJclv1SJIRnDmm08CU7BfXvDBjqzLIDFr7L7i08KJaQQ850syVMCQ2gvPGkk1kE2C9bYxvYyGIsu4RfHsqiBQlubhfwytj6d/FmVNzk6VpBL2xvJaHco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752697378; c=relaxed/simple;
	bh=s5XyDtWQOLf/P4iqLHI7GlT/xAvUQUiMoFn8lYYDEec=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y4uWtzYaa3Is7AmD6KTMmLxLGQaf0GUA9pv84oo/amPP9BWfelihtsz5kQeJJSZ+eGB/lw3lm7J2R8SdgLPy/sOkJhT4vheI29EIqSPxZwx4RWXPoU8JQUxqa/A5OCcVgpXGNhv+7NI/9+ym/IJ5XTesUEy6UQ6hfvCCuaO4QAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ISuLrsd7; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752697373;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hvHxQrfGCpDG34jzQeMKVORhbQgdlZ/Yq6Jal7UEEXg=;
	b=ISuLrsd77mZIoyqoPAXFuoxOJqpJKCimlYzz7JO5GLoWHIBSA7v9AwXqisLoscidVLqnXg
	JPZYuAV9/mO2yFgI5CdqRbdtrBYL/+g8iYE4uHahmAjprL8n2LE6A9U5ar3s1hAhRF+4fM
	zi8ZZTAGX8iQiPOrIH16FmSj7Vqf530=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-551-6oXGVjOrPSimZPSh5ZOQTw-1; Wed, 16 Jul 2025 16:22:51 -0400
X-MC-Unique: 6oXGVjOrPSimZPSh5ZOQTw-1
X-Mimecast-MFC-AGG-ID: 6oXGVjOrPSimZPSh5ZOQTw_1752697370
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e0564038f5so346215ab.1
        for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 13:22:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752697370; x=1753302170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hvHxQrfGCpDG34jzQeMKVORhbQgdlZ/Yq6Jal7UEEXg=;
        b=PCrWwphLnS6l0rd6ZRkaNd6Si7wcllmLDQ1T4SWCFUZedJX5tbcTt8okRCBUQhpcoh
         pw4uWzyiwOb7VMfFKnIP26ywmakZUP9iL9nw1BBPHbLyuoeS141OuWMSUbRIBDyqUj88
         i8YHV0zfLAe7FBmlw/riQu0TocRjO2BnTPeZYBBy56zcXyJskvZJTjXHSv2SysXFFuF+
         KV+IUCP8uCezs9Xtpax37oSY2YlkoR/h/jtpG4XtwdT846gRGy8nmWR6nwqMXJnB9XWX
         yxsUX3cAVHJ9jf8vtmuHG4LHwkx1UoWXktoi4ng6xvHgjAbuwhL8zUdtxswWHJ5JKvPd
         gv7Q==
X-Gm-Message-State: AOJu0Yy0rdfjsDSqu4Kdk6M7slxlwrF+t0JSc1cPYazRHPMi86aqkeCh
	li6Bmn3CZS5E5i8BRO8VzA0eQsjVF/E90pifFRPLVqHG3QfuEgPX0AV6nCcjtiwlmn/s2lZO0ka
	f6w3y5muTT6A0vU6wkm7QmH4x7bRvYj246pzPsLc6vwHzK7Qu6gJETg==
X-Gm-Gg: ASbGnctNSM2lJNnxI7IfYPAwhCbw/a0Sf9IzRLHUfosFqqMWVq0wzzNas6/OYx+3DeL
	Ml6YZGojs4UwsBHRb0dM1ZMp1s/er4dnbr+OK0Y+zKLQSXhEjq9KTOLkg07m1iZCXXqD0s14Jig
	ouk2ex1Pf7TVQ8ZZXzmsbk5VA16O6BH4vrX3fOJcboc973V0M1emK1fs4dp4fW110xPXFV5Y3Dk
	pvmI9GcQCvigoE18EclPf4TvfiGDwzzj+p1roYyyYAhu8p6oO953v2SxsCaJcKue4YEjySy+GzW
	sN1mi2SvjgJEZQZiwfl42svduNHH4ivyhK2IsroisMY=
X-Received: by 2002:a05:6602:2d8e:b0:873:13c6:f37b with SMTP id ca18e2360f4ac-879c08e150bmr150387439f.3.1752697370301;
        Wed, 16 Jul 2025 13:22:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IExSIVdwatnerBCS+QONpamuk2uJG6xO5vzOTbOEa49/NStl/0hCUo3DbPgvXgQWk+u9lMffw==
X-Received: by 2002:a05:6602:2d8e:b0:873:13c6:f37b with SMTP id ca18e2360f4ac-879c08e150bmr150385939f.3.1752697369967;
        Wed, 16 Jul 2025 13:22:49 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5055697325bsm3242011173.73.2025.07.16.13.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jul 2025 13:22:48 -0700 (PDT)
Date: Wed, 16 Jul 2025 14:22:47 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Xin Zeng <xin.zeng@intel.com>
Cc: kvm@vger.kernel.org, qat-linux@intel.com, giovanni.cabiddu@intel.com
Subject: Re: [PATCH] vfio/qat: Remove myself from VFIO QAT PCI driver
 maintainers
Message-ID: <20250716142247.6c9aef1b.alex.williamson@redhat.com>
In-Reply-To: <20250715001357.33725-1-xin.zeng@intel.com>
References: <20250715001357.33725-1-xin.zeng@intel.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Jul 2025 20:13:57 -0400
Xin Zeng <xin.zeng@intel.com> wrote:

> Remove myself from VFIO QAT PCI driver maintainers as I'm leaving
> Intel.
> 
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> ---
>  MAINTAINERS | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fad6cb025a19..886365433105 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -26090,7 +26090,6 @@ S:	Maintained
>  F:	drivers/vfio/platform/
>  
>  VFIO QAT PCI DRIVER
> -M:	Xin Zeng <xin.zeng@intel.com>
>  M:	Giovanni Cabiddu <giovanni.cabiddu@intel.com>
>  L:	kvm@vger.kernel.org
>  L:	qat-linux@intel.com

Thank you for your service.  Applied to vfio next branch for v6.17.
Thanks,

Alex


