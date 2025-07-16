Return-Path: <kvm+bounces-52582-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 850A6B06F17
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:37:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C3DC7B74C2
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 07:35:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C56828DB64;
	Wed, 16 Jul 2025 07:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IL2DhtWk"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168F3274FE7;
	Wed, 16 Jul 2025 07:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752651404; cv=none; b=gVJMEcDZld4HWU2oh/sCLTOKqtymkF8vuLJXnqPnpbhn5AvzItjDNYBQHz7z9BYkdbuXPI+BS1AgVN85zb9klPE5/s2grjrTN/agUQRoCrDELGRZU10vE8U9ynDBdwGyO1VHqNBEJbAwCmxZv1yCkYVW7oCJ5YCsSnrHGCJ8+4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752651404; c=relaxed/simple;
	bh=X+LoooskKcWhlAk2v6lNXE/e0zZx766RhuQ3yNOXPys=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Id0dAQxBihxhcucRaRAQvqkdYJtnpFU6Hx7fhkYFsB7X8QdQvM6rZ0TMuSH6mNFqUaQHU332Il3IEwbdeaRHH8iGHPkU1ah+EgNS9Uu6HJ4BEzG56VL9Xi0YY5eLwYqJ0EXKWaSoDdNTATUPaKEk0K8KRkvsjXhwpHWmoipNpgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IL2DhtWk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E68C4CEF0;
	Wed, 16 Jul 2025 07:36:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752651403;
	bh=X+LoooskKcWhlAk2v6lNXE/e0zZx766RhuQ3yNOXPys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IL2DhtWkL8GDzqJNo9+kBPyWdkfG4GzpC2X36NeLSTin8LCx+WYzbrCpq6G0Dx8SS
	 zArHhlzubKDio5Zro02MVteupBYUx+LntvJuzZe9iENIH2yMp8bsI7rqrHAkJPHs5t
	 UYon4DAT51Cfe6549+kL80qFPh0YWlhHPaP+nyhxbbvDaxfXt2qAr+/qu9gAlYC4RD
	 eWQELv9GKJhWdGr1wuiKilj3h0h6g+m5p91k9Nr9XdppMcjzkk+uMayh4/b1NsdN78
	 kdORh0vvOWrU9L25zluzsIbqMTSQwMyn1eEUj6sfWG5/RYBdJz/kkol7HSKvq2/Pc2
	 SY5E7sSIHOjxw==
Date: Wed, 16 Jul 2025 08:36:30 +0100
From: Simon Horman <horms@kernel.org>
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
	gregkh@linuxfoundation.org, guanwentao@uniontech.com, hpa@zytor.com,
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
Subject: Re: [PATCH v2 4/8] net: mvneta: Fix typo "notifer"
Message-ID: <20250716073630.GB1428042@horms.kernel.org>
References: <BD5C52D2838AEA48+20250715134050.539234-1-wangyuli@uniontech.com>
 <41013AF60AF9B5BE+20250715134407.540483-4-wangyuli@uniontech.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41013AF60AF9B5BE+20250715134407.540483-4-wangyuli@uniontech.com>

On Tue, Jul 15, 2025 at 09:44:03PM +0800, WangYuli wrote:
> There is a spelling mistake of 'notifer' in the comment which
> should be 'notifier'.
> 
> Link: https://lore.kernel.org/all/B3C019B63C93846F+20250715071245.398846-1-wangyuli@uniontech.com/

As suggested by Jonathan Cameron elsewhere in this thread, this link to an
earlier version doesn't seem appropriate here. I'd suggest it belongs
below the scissors ('---') with a note that it is a link to v1.

> Signed-off-by: WangYuli <wangyuli@uniontech.com>

The comment above notwithstanding this looks good to me.

Reviewed-by: Simon Horman <horms@kernel.org>

