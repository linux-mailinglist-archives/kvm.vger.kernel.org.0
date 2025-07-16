Return-Path: <kvm+bounces-52585-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3624B06FE9
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:08:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E447A3A6912
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:08:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5484290D95;
	Wed, 16 Jul 2025 08:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="clYWrTZk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E34526E6F9;
	Wed, 16 Jul 2025 08:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752653319; cv=none; b=Z6Na83kA4xNk4y0/GeH58R07Vd9khlhwMVVajcVMVnA8GgBTM2ZvJ1RkJd8uPJ6WKOwC4HixLFweX8o/f/5LEpX7eksKq1GUhq6wcsPqYUKiV3JJxGzXa+LuyvUE6IPordBpnkcBggXbj3aF7AiDRLtIvmKBCmhnUyilqpOzZo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752653319; c=relaxed/simple;
	bh=HIfZ2WyLhan5ssXSdB5gQZDLA9YqfEoaAfStUdGlXFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cUsXuo4TWuekW6cR9sPNd3vEYNXFhgrpXzqeDoQ2G1ZMJ94IxAm9cOI6elJg9wxNTDxuIsiLyBm5UdStHlDxZH9OErn/taC1FLqMhjvOAm5hvUZsaNojjS/4eTrBqAj6LCVBC4CZn3L7jveeMWT3Mk8NCC10P3RIcafbatSl2PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=clYWrTZk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12419C4CEF0;
	Wed, 16 Jul 2025 08:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752653316;
	bh=HIfZ2WyLhan5ssXSdB5gQZDLA9YqfEoaAfStUdGlXFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=clYWrTZkp/rq0rCVhswSXVqfKlXYciP2uM3S5iUrcQP9HIZSlHaFyZZ8e6FhKU9/U
	 Lh3gBy5Ev81QSMIFUAWFwXwi2wp+9D4NRDiE1O/qfo1Dw1EYsEpURuycj9dvpTzLyL
	 hncH3tuUa6Vr1A5Z6VLty6GPo6W0f4WqF8Ccqj7s=
Date: Wed, 16 Jul 2025 10:08:33 +0200
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
Message-ID: <2025071607-outbid-heat-b0ba@gregkh>
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
 <2BF1749F02ADE664+20250715134407.540483-6-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2BF1749F02ADE664+20250715134407.540483-6-wangyuli@uniontech.com>

On Tue, Jul 15, 2025 at 09:44:05PM +0800, WangYuli wrote:
> There is a spelling mistake of 'notifer' in the comment which
> should be 'notifier'.
> 
> Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/
> Signed-off-by: WangYuli <wangyuli@uniontech.com>

Is your name all one word like that, or should there be a " " between
them?

Also, as others said, don't link to your own patch.

thanks,

greg k-h

