Return-Path: <kvm+bounces-53099-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A4AD9B0D403
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 09:58:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1A626188F83E
	for <lists+kvm@lfdr.de>; Tue, 22 Jul 2025 07:58:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757DE2D322A;
	Tue, 22 Jul 2025 07:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdcFf6pg"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 535C32BE057;
	Tue, 22 Jul 2025 07:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753171057; cv=none; b=b0QgwqwmSRtaM6jviIDragRELjFQzj77bdVaPz9f4OlqpfvJzo5OkEwEyEab/UIBFVZkGQ081Q0ZzNk1XZkch3jz9dMfatnUR11xfWe+d1/q6j7+kI13Pxlch2Ut4/hTaWDGF5muGkglcuZYCgnJSXM0bchjIM1RSzdSFcwTBF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753171057; c=relaxed/simple;
	bh=wEUHDmsgHVPe5kSmdb1Wec3UqL9t1n89LTQEk85htD0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c+bjYFj5zhts9XqsCmalseJtrMDO/k1FW8hik5jNKWqA9Rmq2m4ZOXUT7WRueMinpHMuWvY5h3g989Um6Kssa8PnGHBwFvXNJMhauuBEAvj+ZQI+ybpLp3U3oEvymHGBZw+Od20RaAa1xjvOPZF4zrmYnuJovCP8sulZaR3ruqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdcFf6pg; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9B5C4CEEB;
	Tue, 22 Jul 2025 07:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753171056;
	bh=wEUHDmsgHVPe5kSmdb1Wec3UqL9t1n89LTQEk85htD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JdcFf6pgjhk/nGBgS+COUsHqDSedZPrRp7PmpD9jj0Sy18W7SgAXvzKROr973tS19
	 GmDs4Z2sApDs+Xt0VQpiOqw2NeYSo/wv/f2IDtHwKTBYe7ze0KkyW9m1MQ29aRc7hI
	 g+r9qkREXxILI6FRvwKRc9d4sfo0vJI9m3c+MSdQ=
Date: Tue, 22 Jul 2025 09:57:33 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: WangYuli <wangyuli@uniontech.com>
Cc: airlied@gmail.com, akpm@linux-foundation.org,
	alison.schofield@intel.com, andrew+netdev@lunn.ch,
	andriy.shevchenko@linux.intel.com, arend.vanspriel@broadcom.com,
	bp@alien8.de, brcm80211-dev-list.pdl@broadcom.com,
	brcm80211@lists.linux.dev, colin.i.king@gmail.com,
	cvam0000@gmail.com, dan.j.williams@intel.com,
	dave.hansen@linux.intel.com, dave.jiang@intel.com,
	dave@stgolabs.net, davem@davemloft.net,
	dri-devel@lists.freedesktop.org, edumazet@google.com,
	guanwentao@uniontech.com, hpa@zytor.com,
	ilpo.jarvinen@linux.intel.com, intel-xe@lists.freedesktop.org,
	ira.weiny@intel.com, j@jannau.net, jeff.johnson@oss.qualcomm.com,
	jgross@suse.com, jirislaby@kernel.org, johannes.berg@intel.com,
	jonathan.cameron@huawei.com, kuba@kernel.org, kvalo@kernel.org,
	kvm@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux@treblig.org,
	lucas.demarchi@intel.com, marcin.s.wojtas@gmail.com,
	ming.li@zohomail.com, mingo@kernel.org, mingo@redhat.com,
	netdev@vger.kernel.org, niecheng1@uniontech.com,
	oleksandr_tyshchenko@epam.com, pabeni@redhat.com,
	pbonzini@redhat.com, quic_ramess@quicinc.com, ragazenta@gmail.com,
	rodrigo.vivi@intel.com, seanjc@google.com, shenlichuan@vivo.com,
	simona@ffwll.ch, sstabellini@kernel.org, tglx@linutronix.de,
	thomas.hellstrom@linux.intel.com, vishal.l.verma@intel.com,
	x86@kernel.org, xen-devel@lists.xenproject.org,
	yujiaoliang@vivo.com, zhanjun@uniontech.com
Subject: Re: [PATCH v2 6/8] serial: 8250_dw: Fix typo "notifer"
Message-ID: <2025072252-halves-sadness-18dc@gregkh>
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
 <2BF1749F02ADE664+20250715134407.540483-6-wangyuli@uniontech.com>
 <2025071607-outbid-heat-b0ba@gregkh>
 <634BA467821D37FE+0b2ace38-07d9-4500-8bb7-5a4fa65c4b9f@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <634BA467821D37FE+0b2ace38-07d9-4500-8bb7-5a4fa65c4b9f@uniontech.com>

On Tue, Jul 22, 2025 at 03:22:18PM +0800, WangYuli wrote:
> Hi greg k-h,
> 
> On 2025/7/16 16:08, Greg KH wrote:
> > > Signed-off-by: WangYuli <wangyuli@uniontech.com>
> > Is your name all one word like that, or should there be a " " between
> > them?
> 
> If I were to follow Western naming conventions, my name would be written as
> 'Yuli Wang'.
> 
> However, frankly, I find it unnecessary and can't be bothered to follow
> their customs, unless a maintainer strongly insists. (For example, you can
> see that my signature on commits for the LoongArch subsystem is different
> from my other contributions).
> 
> Since Chinese names are written without any spaces in Chinese characters, I
> don't think it matters.

Then use your Chinese name, don't feel like you need to change it to any
other naming convention.  There's no requirement here at all to do so.

thanks,

greg k-h

