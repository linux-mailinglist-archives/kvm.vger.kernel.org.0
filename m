Return-Path: <kvm+bounces-52435-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B754B0532A
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 09:29:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0AB7A7B63B7
	for <lists+kvm@lfdr.de>; Tue, 15 Jul 2025 07:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E55E127464A;
	Tue, 15 Jul 2025 07:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xV4ayyVH"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7EF417C77;
	Tue, 15 Jul 2025 07:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752564128; cv=none; b=PAVborFcxROuQwkYOfS1cWzJRH7RIsynaNIm79hTQiK6ZIXnzOnwrkRE1pNtkqFxaCZredu+r0ZrqM4SsoM2foOPPhpezSfEmvwvcreWngNigXyTpfWX8n6yFLNnhktQx61duZ3olDcVLHHrltzD99MVK5yl8LlOgdhSfF7qnKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752564128; c=relaxed/simple;
	bh=Rhik2SI+sxdIEG5rfGbMFjsf4x5xltoyJp8F3xN1GvI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ejiuz8NUtXdV/i2Arl4Ez7gW7Amh1x0cGJG4DyMOjLYv3yo8OkIAPohbO2UJgA/ZR4T3tYG/0FWefzPGpGQzQ3iLH/Hx6ZFLQKQuBWEYjExoeW3E/Y/s+UsTi7HA7G+kLo23j/trKcTiy5AFagyWTp7P6R+LDlMkptgBxHL24ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xV4ayyVH; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF12C4CEE3;
	Tue, 15 Jul 2025 07:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752564127;
	bh=Rhik2SI+sxdIEG5rfGbMFjsf4x5xltoyJp8F3xN1GvI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xV4ayyVHzmMklnAQs9ZPV19B42Zsk2m7JMrMJ9Ou80gk+ulgxsyLIhmhnUsk5ITkT
	 BIOD164QstgeLz9+xuFFZ01NuqUGgIn+VixhoplzD96lw9IWhOcL5obCmwa6Ivp5vT
	 /UdnZj44/JtIwtk6Q92BDyrCHIsNzPlEBMflYjVA=
Date: Tue, 15 Jul 2025 09:22:03 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: WangYuli <wangyuli@uniontech.com>
Cc: seanjc@google.com, pbonzini@redhat.com, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com,
	lucas.demarchi@intel.com, thomas.hellstrom@linux.intel.com,
	rodrigo.vivi@intel.com, airlied@gmail.com, simona@ffwll.ch,
	marcin.s.wojtas@gmail.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, arend.vanspriel@broadcom.com,
	ilpo.jarvinen@linux.intel.com, andriy.shevchenko@linux.intel.com,
	jirislaby@kernel.org, jgross@suse.com, sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com, akpm@linux-foundation.org,
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
	ming.li@zohomail.com, linux-cxl@vger.kernel.org,
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	netdev@vger.kernel.org, kvalo@kernel.org, johannes.berg@intel.com,
	quic_ramess@quicinc.com, ragazenta@gmail.com,
	jeff.johnson@oss.qualcomm.com, mingo@kernel.org, j@jannau.net,
	linux@treblig.org, linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
	linux-serial@vger.kernel.org, xen-devel@lists.xenproject.org,
	shenlichuan@vivo.com, yujiaoliang@vivo.com, colin.i.king@gmail.com,
	cvam0000@gmail.com, zhanjun@uniontech.com, niecheng1@uniontech.com,
	guanwentao@uniontech.com
Subject: Re: [PATCH] treewide: Fix typo "notifer"
Message-ID: <2025071545-endnote-imprison-2b98@gregkh>
References: <B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com>

On Tue, Jul 15, 2025 at 03:12:45PM +0800, WangYuli wrote:
> There are some spelling mistakes of 'notifer' in comments which
> should be 'notifier'.
> 
> Fix them and add it to scripts/spelling.txt.
> 
> Signed-off-by: WangYuli <wangyuli@uniontech.com>
> ---
>  arch/x86/kvm/i8254.c                                        | 4 ++--
>  drivers/cxl/core/mce.h                                      | 2 +-
>  drivers/gpu/drm/xe/xe_vm_types.h                            | 2 +-
>  drivers/net/ethernet/marvell/mvneta.c                       | 2 +-
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 +-
>  drivers/tty/serial/8250/8250_dw.c                           | 2 +-
>  include/xen/xenbus.h                                        | 2 +-
>  scripts/spelling.txt                                        | 1 +
>  8 files changed, 9 insertions(+), 8 deletions(-)

Please break this up into one-patch-per-subsystem, like is required for
things like this.

thanks,

greg k-h

