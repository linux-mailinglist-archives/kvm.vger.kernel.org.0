Return-Path: <kvm+bounces-47927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1586BAC7729
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 06:31:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B26921BA75E0
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 04:31:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEC39252296;
	Thu, 29 May 2025 04:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="iM8ZqWT7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 999FA54F81
	for <kvm@vger.kernel.org>; Thu, 29 May 2025 04:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748493094; cv=none; b=ADlYuSCUAfv/p9cp/bnxB2LQCjQOV6+dSS/8Mw+XVipWy/T9FIuV6goP9noChES/eJGMTqxRCvwO2Gqohy0LdWK664KF932PMkF1buVsnGdtszL6N3gQ1Ic6ylISePcilsjooAQ9E8jiKG8+Lb0+TT/62VS413jgedCDLKQSDCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748493094; c=relaxed/simple;
	bh=7zYJ5r2anCAN+UcUG4V3nTPVwMsW8DRoqrhx23/0IgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQEY8h8jHkck/vFFGEb4ZHp4kpsKQHL6IFL6vkw3Hrv7IwDe7VGMpCwfrNX+i+k2xMzaco7tm/maSZ4Tuor+t63HCzNOqUCB6IHAeSD2I1YpX/YvX+Gu3SiBEGvKvDS6sf5vm4/RkAhkLofqbf0Gv63H6X3Q/l1YeRF3AgLxyYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=iM8ZqWT7; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-742b0840d98so269084b3a.1
        for <kvm@vger.kernel.org>; Wed, 28 May 2025 21:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1748493092; x=1749097892; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2o+2tHrbcVdORj49S8NV86zMTS78meAi/ActS4n4zg=;
        b=iM8ZqWT7TV81QxxUFaZKVu9ot2sk4JPtGW8OumC9qshPX1HjoIm0hnUulOxX0tRDMc
         AavjXMVN3zlUAW7H7RoN8hReEFuO5dcZeeUCcTO7aTry+z1YdynvNjmepTXsZFwRlj5f
         R6AOoBohwegonF1EFXVOW7nVG8XBGCfeWQw7rPJnNv9vkESQHthFeljIwCJUPrBCE92K
         yOzv17e3Kp0ySqyfHrR9Q+EZeVEZbdfEZRIdt1eKzAWgmyliFpv0PS8ZWBMGCNgB7yxZ
         4LQTakiKuRE51HHyHUI7RxZqXHTu9g8cB2u83AAGHLgSTsrdlKVPYVM8wlUgnR86lJfh
         MlyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748493092; x=1749097892;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q2o+2tHrbcVdORj49S8NV86zMTS78meAi/ActS4n4zg=;
        b=aRbn3GUijqHaJXUZhjE3btOv4kSqY247TZx26jE3T0tkO8YBR/PoERxvPpGvu+QHUG
         BDi9f8inTJUwF9qbiS8x5NnGZrDyzOLIGD7aofSKiyB5BuXUpJSZFnWttcCQL9iZIs15
         L2y+FAnaHaF60lq/WnzxKV3bHr2uJX1IuTWkSeeUPSOjmxPxvVtf2VwxvOu4ZnlzlcXB
         ZnTDGo0SBl7NgJaCdIsxbqMlNAu6vdlOPnvIjGJor99Qs7RpcbmKzK22NDIKUWb1Bjv1
         slK4ezHtcvzEF82dXcyJBI/ikDAFZfvSZIFZaIc5egm6HyYMlD/7dG43YgjVDIbCMG2w
         2AAg==
X-Forwarded-Encrypted: i=1; AJvYcCVGPVKXwIaYS24oxpaQNBrnwGZICP7u/OlsZTlWxiZSe2jcv0xH1//ewOp8UQ1a2uMm7vE=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsImwFo6Kj7JjVZ3WZ+86gIpU29l7GcZYobgSB9hAQDopLswqR
	w7tG/t4q1VSY+deCfGeLp4kPYIudwmeuGvHsgjmWWQu430j8gUPpGJK3gAke0n5owBA=
X-Gm-Gg: ASbGnct74WZxM+OiuZZd+lSFracyUjaPdZdfqmEL6cFf4wVtenythH/T8BnXBNCrJY/
	03eiuntMYXWadbjJCJwE7IXTPets+WG0lAEAJsrCR/9T8vAGWZZOg7gw39ZZH01eXSKYCM7jKvo
	eudu5DjrOVSxkgRS2EGDrUB8wxSma/NVZpAorgD8Lm8IttLOZKyrtVc+1zeebInambmOYY/gFA+
	uAwZ+uQGhqWi9kXCwervmhf90db9jJl5POUDkBGboEY+tr4E0x8G3i9FLJ68Un+V3Ur5Z9Xr0Cs
	3JJC3h3IFbFVf+BXlUeDkzyMAJoyi75baQ4If4x4Mf4WSa7FXuc8KkAPptLNwbvCzgDJS3v6rNm
	AGao=
X-Google-Smtp-Source: AGHT+IE1BY+5uXy2u0GwajwCh6OtDltmjtBMsqeuIsMxRA/YNF3XfoU+Uv4IEITyJ6u3Metnixo/xA==
X-Received: by 2002:a05:6a00:3c83:b0:73e:1e24:5a4e with SMTP id d2e1a72fcca58-745fe03d5c5mr33068343b3a.24.1748493091760;
        Wed, 28 May 2025 21:31:31 -0700 (PDT)
Received: from localhost.localdomain ([203.208.189.11])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2d99e1b72esm1650449a12.20.2025.05.28.21.31.28
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 28 May 2025 21:31:31 -0700 (PDT)
From: lizhe.67@bytedance.com
To: alex.williamson@redhat.com,
	jgg@ziepe.ca
Cc: david@redhat.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lizhe.67@bytedance.com,
	muchun.song@linux.dev
Subject: Re: [PATCH v3] vfio/type1: optimize vfio_pin_pages_remote() for huge folio
Date: Thu, 29 May 2025 12:31:25 +0800
Message-ID: <20250529043125.30478-1-lizhe.67@bytedance.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250528140941.151b2f70.alex.williamson@redhat.com>
References: <20250528140941.151b2f70.alex.williamson@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 28 May 2025 14:09:41 -0600, alex.williamson@redhat.com wrote:

> On Tue, 27 May 2025 20:46:27 -0300
> Jason Gunthorpe <jgg@ziepe.ca> wrote:
> 
> > On Tue, May 27, 2025 at 01:52:52PM -0600, Alex Williamson wrote:
> > 
> > > > Lots of CSPs are running iommufd now. There is a commonly used OOT
> > > > patch to add the insecure P2P support like VFIO. I know lots of folks
> > > > have backported iommufd.. No idea about libvirt, but you can run it in
> > > > compatibility mode and then you don't need to change libvirt.  
> > > 
> > > For distributions that don't have an upstream first policy, sure, they
> > > can patch whatever they like.  I can't recommend that solution though.  
> > 
> > I appreciate that, and we are working on it.. The first round of
> > patches for DMA API improvements that Christoph asked for were sent as
> > a PR yesterday.
> > 
> > > Otherwise the problem with compatibility mode is that it's a compile
> > > time choice.  
> > 
> > The compile time choice is not the compatability mode.
> > 
> > Any iommufd, even if opened from /dev/iommu, is usable as a VFIO
> > container in the classic group based ioctls.
> > 
> > The group path in VFIO calls vfio_group_ioctl_set_container() ->
> > iommufd_ctx_from_file() which works with iommufd from any source.
> > 
> > The type 1 emulation ioctls are also always available on any iommufd.
> > After set container VFIO does iommufd_vfio_compat_ioas_create() to
> > setup the default compatability stuff.
> > 
> > All the compile time option does is replace /dev/vfio/vfio with
> > /dev/iommu, but they have *exactly* the same fops:
> > 
> > static struct miscdevice iommu_misc_dev = {
> > 	.minor = MISC_DYNAMIC_MINOR,
> > 	.name = "iommu",
> > 	.fops = &iommufd_fops,
> > 
> > static struct miscdevice vfio_misc_dev = {
> > 	.minor = VFIO_MINOR,
> > 	.name = "vfio",
> > 	.fops = &iommufd_fops,
> > 
> > So you can have libvirt open /dev/iommu, or you can have the admin
> > symlink /dev/iommu to /dev/vfio/vfio and opt in on a case by case
> > basis.
> 
> Yes, I'd forgotten we added this.  It's QEMU opening /dev/vfio/vfio and
> QEMU already has native iommufd support, so a per VM hack could be done
> via qemu:args or a QEMU wrapper script to instantiate an iommufd object
> in the VM xml, or as noted, a system-wide change could be done
> transparently via 'ln -sf /dev/iommu /dev/vfio/vfio'.
> 
> To be fair to libvirt, we'd really like libvirt to make use of iommufd
> whenever it's available, but without feature parity this would break
> users.  And without feature parity, it's not clear how libvirt should
> probe for feature parity.  Things get a lot easier for libvirt if we
> can switch the default at a point where we expect no regressions.
> 
> > The compile time choice is really just a way to make testing easier
> > and down the road if a distro decides they don't want to support both
> > code bases then can choose to disable the type 1 code entirely and
> > still be uAPI compatible, but I think that is down the road a ways
> > still.
> 
> Yep.
>  
> > > A single kernel binary cannot interchangeably provide
> > > either P2P DMA with legacy vfio or better IOMMUFD improvements without
> > > P2P DMA.  
> > 
> > See above, it can, and it was deliberately made easy to do without
> > having to change any applications.
> > 
> > The idea was you can sort of incrementally decide which things to move
> > over. For instance you can keep all the type 1 code and vfio
> > group/container stuff unchanged but use a combination of
> > IOMMU_VFIO_IOAS_GET and then IOMMUFD_CMD_IOAS_MAP_FILE to map a memfd.
> 
> Right, sorry, it'd slipped my mind that we'd created the "soft"
> compatibility mode too.
> 
> Zhe, so if you have no dependencies on P2P DMA within your device
> assignment VMs, the options above may be useful or at least a data
> point for comparison of type1 vs IOMMUFD performance.  Thanks,
> 
> Alex

Hi Alex, Jason, thank a lot for your suggestions. I will try to explore
the usage of iommufd in our scenario. I also hope that the P2P DMA patches
will be merged into the mainline soon.

Thanks,
Zhe

