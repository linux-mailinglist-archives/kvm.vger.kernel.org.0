Return-Path: <kvm+bounces-13020-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AFEFC8902C8
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 16:14:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 64D5F2930D5
	for <lists+kvm@lfdr.de>; Thu, 28 Mar 2024 15:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC0F1823AF;
	Thu, 28 Mar 2024 15:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="IwpxAgak"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C8352F6D
	for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 15:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711638843; cv=none; b=lolkG0ABs53ooTUB/ewvw8isd9xTDgLP4yU+S9DQH2PUDocM4eswOB7TU7bKz1ORr9HFXgflPL5x6JRWcc6ZPNjuDEOU/W/h1JRViUO9ml6NJFp6Y+beiLN7l73AEXbI6K3VwAxvpv5bNOCUtrZAsBXqFUxJ5SkYePWggDs4gnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711638843; c=relaxed/simple;
	bh=g1q6pIXhedpAZIVPScHYLLCJR3yjuWrUTgey6uGVN8I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4LKoCPXbv1QiblGqsMGBKM5ZMlGGob41G9Iusq5hqX+hSx7nOcp7zxchULoXV4Gn73hPC/b1QirSsCXJMFirJ7kPmRXxXhuqfqTQUEVTTDYjMOSo5RjMqLVkfJluUjK6MO9gSOgSz3ISaNGijvLbvPPtkprpJmqURoGEArBKjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=IwpxAgak; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4154471fb59so5190465e9.3
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 08:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1711638839; x=1712243639; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Vutwe9uQNhqbkQuib/VJsrR0Y5T7DY7pGtessWbxb5I=;
        b=IwpxAgakQa+Wvzt2HD84xLvRR7ynoSArpnlukffcTQapscHOAOM9pDWKnDvRBDBeNm
         XyurlGg86R771z9ds2ENVd9+WJl4lrBukbbdt9DrSticRSw7H7XaNHKCYCu+P4BMhalm
         BNEBX0Ly7H23HHRoz3sEwlnBBQC98uczhE6Yo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711638839; x=1712243639;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Vutwe9uQNhqbkQuib/VJsrR0Y5T7DY7pGtessWbxb5I=;
        b=FhRxtaNKDUOXbhRltqk2w6bYeGrU0XXdg7VffOdr8COWLJPzHfE1ozejnFk5sdqG66
         Pw7+RxaDXwyCqb3cYR0B31hnBFP5tx+SrrXFKsk05Ye6bh+6DRk3CpOktPv0GVJEBhR/
         eRybBWqTD/v3cM+aC7g4xiZz+ahVGoyIpKC+4cWZsVtSyuVTFtWZY0TRLHBwjEY+l3/I
         CP0+IIo9WNebgVwP26aBRKD3Q4Rh/2L17GSV4Bul+wwnQ2XqS1NKwRRBXH5Zk4tuopFO
         wqWQ7eSEKwbM+1L0rAhVZTOA8z15EeX3EbsMBF1pSpQofm4u1lkX04uIacBaDi952zam
         VoyA==
X-Forwarded-Encrypted: i=1; AJvYcCXsag593licnKv+I8y8jUqtvRc9qojn5v/0dyJbASwy9/7hFvk4DDR3u//62ZodlMz4LQm2ABhNQAfJcbdVtvsjZ8dG
X-Gm-Message-State: AOJu0YzOuUMnycKOW9EPvKQIqAWodrEOkeS1pjuDR8ib3tAFtQEY1X5n
	goSD1RsMV6qIbe7sV4eBruHtsJXj/caQ2+kcAUxpixjlJ++L79STvZTniKiBDLM=
X-Google-Smtp-Source: AGHT+IGqAinQBfrXGU5/mTtpVN5DvsCj7MjTmxxo3BTpBz9VwcwzSMIjsSrbfaQrLhnH/z44soQEMQ==
X-Received: by 2002:adf:e9cf:0:b0:341:bf20:c840 with SMTP id l15-20020adfe9cf000000b00341bf20c840mr2502075wrn.11.1711638839070;
        Thu, 28 Mar 2024 08:13:59 -0700 (PDT)
Received: from perard.uk.xensource.com (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id ea2-20020a0560000ec200b003432d79876esm1947746wrb.97.2024.03.28.08.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 08:13:52 -0700 (PDT)
Date: Thu, 28 Mar 2024 15:13:51 +0000
From: Anthony PERARD <anthony.perard@cloud.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: David Woodhouse <dwmw@amazon.co.uk>, qemu-devel@nongnu.org,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
	kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>
Subject: Re: [PATCH-for-9.0 v2 19/19] hw/xen: Have most of Xen files become
 target-agnostic
Message-ID: <83ff9fec-2ac1-418f-ac76-2256d03e676e@perard>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-20-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231114143816.71079-20-philmd@linaro.org>

On Tue, Nov 14, 2023 at 03:38:15PM +0100, Philippe Mathieu-Daudé wrote:
> Previous commits re-organized the target-specific bits
> from Xen files. We can now build the common files once
> instead of per-target.
> 
> Only 4 files call libxen API (thus its CPPFLAGS):
> - xen-hvm-common.c,
> - xen_pt.c, xen_pt_graphics.c, xen_pt_msi.c
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
> Reworked since v1 so dropping David's R-b tag.
> ---
>  accel/xen/meson.build          |  2 +-
>  hw/block/dataplane/meson.build |  2 +-
>  hw/xen/meson.build             | 21 ++++++++++-----------
>  3 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/accel/xen/meson.build b/accel/xen/meson.build
> index 002bdb03c6..455ad5d6be 100644
> --- a/accel/xen/meson.build
> +++ b/accel/xen/meson.build
> @@ -1 +1 @@
> -specific_ss.add(when: 'CONFIG_XEN', if_true: files('xen-all.c'))
> +system_ss.add(when: 'CONFIG_XEN', if_true: files('xen-all.c'))
> diff --git a/hw/block/dataplane/meson.build b/hw/block/dataplane/meson.build
> index 025b3b061b..4d8bcb0bb9 100644
> --- a/hw/block/dataplane/meson.build
> +++ b/hw/block/dataplane/meson.build
> @@ -1,2 +1,2 @@
>  system_ss.add(when: 'CONFIG_VIRTIO_BLK', if_true: files('virtio-blk.c'))
> -specific_ss.add(when: 'CONFIG_XEN_BUS', if_true: files('xen-block.c'))
> +system_ss.add(when: 'CONFIG_XEN_BUS', if_true: files('xen-block.c'))
> diff --git a/hw/xen/meson.build b/hw/xen/meson.build
> index d887fa9ba4..403cab49cf 100644
> --- a/hw/xen/meson.build
> +++ b/hw/xen/meson.build
> @@ -7,26 +7,25 @@ system_ss.add(when: ['CONFIG_XEN_BUS'], if_true: files(
>    'xen_pvdev.c',
>  ))
>  
> -system_ss.add(when: ['CONFIG_XEN', xen], if_true: files(
> +system_ss.add(when: ['CONFIG_XEN'], if_true: files(
>    'xen-operations.c',
> -))
> -
> -xen_specific_ss = ss.source_set()
> -xen_specific_ss.add(files(
>    'xen-mapcache.c',
> +))
> +system_ss.add(when: ['CONFIG_XEN', xen], if_true: files(
>    'xen-hvm-common.c',
>  ))
> +
>  if have_xen_pci_passthrough
> -  xen_specific_ss.add(files(
> +  system_ss.add(when: ['CONFIG_XEN'], if_true: files(
>      'xen-host-pci-device.c',
> -    'xen_pt.c',
>      'xen_pt_config_init.c',
> -    'xen_pt_graphics.c',
>      'xen_pt_load_rom.c',
> +  ))
> +  system_ss.add(when: ['CONFIG_XEN', xen], if_true: files(
> +    'xen_pt.c',
> +    'xen_pt_graphics.c',

How is it useful to separate those source files? In the commit
description, there's a talk about "CPPFLAGS", but having `when: [xen]`
doesn't change the flags used to build those objects, so the talk about
"CPPFLAGS" is confusing.
Second, if for some reason the dependency `xen` is false, but
`CONFIG_XEN` is true, then we wouldn't be able to build QEMU. Try
linking a binary with "xen_pt_config_init.o" but without "xen_pt.o",
that's not going to work. So even if that first source file doesn't
directly depend on the Xen libraries, it depends on "xen_pt.o" which
depends on the Xen libraries. So ultimately, I think all those source
files should have the same condition: ['CONFIG_XEN', xen].

I've only checked the xen_pt* source files, I don't know if the same
applies to "xen-operations.c" or "xen-mapcache.c".

Beside this, QEMU built with Xen support still seems to works fine, so
adding the objects to `system_ss` instead of `specific_ss` seems
alright.

Thanks,

-- 
Anthony PERARD

