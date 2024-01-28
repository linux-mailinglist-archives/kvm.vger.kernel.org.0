Return-Path: <kvm+bounces-7285-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46A6283F50E
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 11:56:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F1561C20DD7
	for <lists+kvm@lfdr.de>; Sun, 28 Jan 2024 10:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A3411EB22;
	Sun, 28 Jan 2024 10:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mail.uni-paderborn.de header.i=@mail.uni-paderborn.de header.b="mtzig3qU"
X-Original-To: kvm@vger.kernel.org
Received: from zuban.uni-paderborn.de (zuban.uni-paderborn.de [131.234.189.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0898C1E
	for <kvm@vger.kernel.org>; Sun, 28 Jan 2024 10:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=131.234.189.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706439378; cv=none; b=OP3GInM1BOqWUFWGOpzLBr3xLC4KJ2nn7N6MgzMy30ZcC53bBvsEaV9s74q6rJL3wCrw9fxQ2agiHzTrkKWPL8UgcaCKC6m5zg+xYbQ3rN8JUbGHTjGj0YNjNhBBs1KubzRXo9MAShMmsadVJzBG8JtDNDhgaYZRwEr4G03sAAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706439378; c=relaxed/simple;
	bh=fFAgeFBEgOOFJ5hD4V3021p4VZqeTLLRWgB35/dvVN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ee3KtdBbGJL+UYoHQfdWOtNIACsxgmVmlxBgvgxPDGRsm+58ewDEv4k78FpAdZ+EUaEKK0Z27JOkrXHFjan5yveaG6OpPgS2sNUa22KbYRbmWgvOYqt4XxOww/MEMuCAFNrvaPjWJkD6dDiTfDptKy1lkEih66Ko5JT2XkoS+z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.uni-paderborn.de; spf=pass smtp.mailfrom=mail.uni-paderborn.de; dkim=pass (1024-bit key) header.d=mail.uni-paderborn.de header.i=@mail.uni-paderborn.de header.b=mtzig3qU; arc=none smtp.client-ip=131.234.189.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.uni-paderborn.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.uni-paderborn.de
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=mail.uni-paderborn.de; s=20170601; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=vvIF26RBDLw+ldxcag6nMVV5Dto0lCR4pixmzH4okR8=; b=mtzig3qUEc29xOV48tBTafSouS
	kYOTxo1qfO1eb7PHNe7+5869tAjNjANki5CK7hOSu7tfylhpsS2P8/rOpbfXQcILECgiWXepxp8Q2
	tq6NqTcqAisc0R98LRRP3A+RjNTk4zdt50hyxYyw8X2VhXC3NE0/Hoe+69FX9vTAmFoo=;
Date: Sun, 28 Jan 2024 11:34:48 +0100
From: Bastian Koppelmann <kbastian@mail.uni-paderborn.de>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, qemu-arm@nongnu.org, 
	Thomas Huth <thuth@redhat.com>, qemu-s390x@nongnu.org, qemu-riscv@nongnu.org, 
	Eduardo Habkost <eduardo@habkost.net>, kvm@vger.kernel.org, qemu-ppc@nongnu.org, 
	Richard Henderson <richard.henderson@linaro.org>, Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>, 
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 21/23] target/tricore: Prefer fast cpu_env() over
 slower CPU QOM cast macro
Message-ID: <mc67nwaoaqancyz63zt36awnsyzslgl24w3hnctaxzuycezixt@yvxaywvzntvb>
References: <20240126220407.95022-1-philmd@linaro.org>
 <20240126220407.95022-22-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240126220407.95022-22-philmd@linaro.org>
X-IMT-Source: Extern
X-IMT-rspamd-score: -25
X-IMT-Spam-Score: 0.0 ()
X-Sophos-SenderHistory: ip=84.184.59.80,fs=1716459,da=194047155,mc=2,sc=0,hc=2,sp=0,fso=1716459,re=0,sd=0,hd=0
X-PMX-Version: 6.4.9.2830568, Antispam-Engine: 2.7.2.2107409, Antispam-Data: 2024.1.27.235115, AntiVirus-Engine: 6.0.2, AntiVirus-Data: 2024.1.26.602001
X-IMT-Authenticated-Sender: kbastian@UNI-PADERBORN.DE

On Fri, Jan 26, 2024 at 11:04:03PM +0100, Philippe Mathieu-Daudé wrote:
> Mechanical patch produced running the command documented
> in scripts/coccinelle/cpu_env.cocci_template header.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>  target/tricore/cpu.c       | 20 ++++----------------
>  target/tricore/gdbstub.c   |  6 ++----
>  target/tricore/helper.c    |  3 +--
>  target/tricore/translate.c |  3 +--
>  4 files changed, 8 insertions(+), 24 deletions(-)

Reviewed-by: Bastian Koppelmann <kbastian@mail.uni-paderborn.de>

Cheers,
Bastian

