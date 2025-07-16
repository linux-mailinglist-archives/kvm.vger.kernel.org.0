Return-Path: <kvm+bounces-52575-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 921EFB06DAE
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:11:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D7AC65628EC
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 06:11:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 039F229B77A;
	Wed, 16 Jul 2025 06:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DCh6an8D"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E7B8634A;
	Wed, 16 Jul 2025 06:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752646285; cv=none; b=Lk5kbMdTfg6mJryXCUmZsE628CY6NTiDuykKM2igTitg/LfPk8QBmcn+FELSxN1cZ9DFpIiZcwXg158Lg0mZnSi3g4etRC6WasqDDBgLCd/0O2pP2wx2rTljD4xq7u3BvQBy2RXR1vw6YMuRNKK305Qe+so9euj52OTtCHn9m+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752646285; c=relaxed/simple;
	bh=UVJe3el9jbj4WjVeMJzLRr38mWDTucXHPmi9EtpiP/k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SSiduzijMMTpjaNq1p2xdZjoQYSzeLnc2xR+uW49jg7fqkLBA5TNSrlTq608SZdz/y0TtXk/Vi44G7eFRo0IUK6DbzLXyjvh1FqE7ZRtGzA0haP42yp9CkRlD6l6/Z6/dPD1FW6YnOJoUFyuTs5tZ9bdit0iFC4b/2Cexf7AYcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DCh6an8D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD4CC4CEF0;
	Wed, 16 Jul 2025 06:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752646284;
	bh=UVJe3el9jbj4WjVeMJzLRr38mWDTucXHPmi9EtpiP/k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DCh6an8DZXMymHh90s9hI078GBvkLPqFI9WeE0gMO8YnOVueYVnBgIha6pjBo9Au/
	 z2fdf8E1h3Wa4zxWYlJnaoNhDEZ7DuyNNwiPVF141rpzSKd95K2GSp+0MLd9kHEJfL
	 vB/n7PNKVCjGrZD2wCjOPIOQwHnCxByJ7D9alYH/GFfFVUyn1reZ14JiaETuL6/Csy
	 38Us//BTeuFIf/xJ8z0zdk0bKRYedHF5pZfV+WVuaWWkuPemssm8s92pMzjPlH1N7W
	 a/UFQMQn4Eduyz35cSSX/qiVFVbfrupObmUen+Vs9fdMl6Xyk364e7gi/is6MoGkc/
	 1hHKwyEy3eK0g==
Date: Wed, 16 Jul 2025 08:11:17 +0200
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Igor Mammedov <imammedo@redhat.com>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Shiju Jose <shiju.jose@huawei.com>,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org, Philippe =?UTF-8?B?TWF0aGll?=
 =?UTF-8?B?dS1EYXVkw6k=?= <philmd@linaro.org>, Ani Sinha
 <anisinha@redhat.com>, Dongjiu Geng <gengdongjiu1@gmail.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Peter Maydell <peter.maydell@linaro.org>, Shannon
 Zhao <shannon.zhaosl@gmail.com>, Yanan Wang <wangyanan55@huawei.com>, Zhao
 Liu <zhao1.liu@intel.com>, kvm@vger.kernel.org, Cleber Rosa
 <crosa@redhat.com>, Eduardo Habkost <eduardo@habkost.net>, Eric Blake
 <eblake@redhat.com>, John Snow <jsnow@redhat.com>, Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>, Markus Armbruster <armbru@redhat.com>,
 Michael Roth <michael.roth@amd.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 (RESEND) 00/20] Change ghes to use HEST-based
 offsets and add support for error inject
Message-ID: <20250716081117.4b89570a@foz.lan>
In-Reply-To: <20250715133423-mutt-send-email-mst@kernel.org>
References: <cover.1749741085.git.mchehab+huawei@kernel.org>
	<20250715133423-mutt-send-email-mst@kernel.org>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Tue, 15 Jul 2025 13:36:26 -0400
"Michael S. Tsirkin" <mst@redhat.com> escreveu:

> On Thu, Jun 12, 2025 at 05:17:24PM +0200, Mauro Carvalho Chehab wrote:
> > Hi Michael,
> > 
> > This is v10 of the patch series, rebased to apply after release
> > 10.0. The only difference against v9 is a minor confict resolution.  
> 
> Unfortunately, this needs a rebase on top of latest PCIHP
> changes in my tree.  The changes are non trivial, too.
> I should have let you know more early, sorry :(

If you still accept merging it, I can quickly rebase and send you.
Just let me know about what branch you want the rebase.

Regards,
Mauro

