Return-Path: <kvm+bounces-61360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D174C173CE
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 23:55:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 52D743B06B4
	for <lists+kvm@lfdr.de>; Tue, 28 Oct 2025 22:53:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B00036999D;
	Tue, 28 Oct 2025 22:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y70QZHG8"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8919A1891AB;
	Tue, 28 Oct 2025 22:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761692004; cv=none; b=rzKCEGHMsNLhctB8s9ManMhjrQj+cNSpKvgU6YM37UOAZersO6aJhN0mSIxgkBJ/RTxNM4dBEcru++CCkSIi6MxBPGMAjOKywRF5LcaydFgWWSOlOwsW3jys6mmg8YjoeSEB7t1P/pE8ib6jtNKa/2EmG1WEU4XaQUxqLIyPf70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761692004; c=relaxed/simple;
	bh=E4SFGU0lgJj/10+0QYHjZwLGjT5sBHYhEzNGPcYiYTY=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Fx3vq7cS24WSV13n9HhmqlwU8vmG1MN95XPJIf/xSZSXIcgvGth9KyToFzmxZY6zFDn5RGwOwQoagcVcYl47FSOWvpCKzv2uDRfRQ6z4yckxn3oiHs143VMDNEZgqY2HDn/aRToBv8WsI0ql+84Q2fVPUuJpoTYdXS9dRMFWIYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y70QZHG8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4935C4CEE7;
	Tue, 28 Oct 2025 22:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761692003;
	bh=E4SFGU0lgJj/10+0QYHjZwLGjT5sBHYhEzNGPcYiYTY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Y70QZHG8LT9n4mmrxudVJN2xlcIb7ty3zXNrXYaF/C5I2/VWyDIoGpMh4YZ/iSLnu
	 FuQQTlzhSw0CvAOVj0syku80FEVFazIAtXF9r5PGaMqJQ78mlt1y0UEW9yu3G7UiYZ
	 X0+j0cGGGcCKDj0+ZEMITrxP/v7bGrvOEiuXkBYo=
Date: Tue, 28 Oct 2025 15:53:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: balbirs@nvidia.com, borntraeger@de.ibm.com, david@redhat.com,
 Liam.Howlett@oracle.com, airlied@gmail.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 dakr@kernel.org, dev.jain@arm.com, dri-devel@lists.freedesktop.org,
 francois.dugast@intel.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, lyude@redhat.com, matthew.brost@intel.com,
 mpenttil@redhat.com, npache@redhat.com, osalvador@suse.de,
 rakie.kim@sk.com, rcampbell@nvidia.com, ryan.roberts@arm.com,
 simona@ffwll.ch, ying.huang@linux.alibaba.com, ziy@nvidia.com,
 kvm@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-next@vger.kernel.org, hca@linux.ibm.com, gor@linux.ibm.com,
 agordeev@linux.ibm.com
Subject: Re: [PATCH v1 0/1] KVM: s390: Fix missing present bit for gmap puds
Message-Id: <20251028155322.392c2fe0ce1952a61af39a89@linux-foundation.org>
In-Reply-To: <20251028130150.57379-1-imbrenda@linux.ibm.com>
References: <d4a09cc8-84b2-42a8-bd03-7fa3adee4a99@linux.ibm.com>
	<20251028130150.57379-1-imbrenda@linux.ibm.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 Oct 2025 14:01:49 +0100 Claudio Imbrenda <imbrenda@linux.ibm.com> wrote:

> @Andrew: do you think it's possible to squeeze this patch in -next
> _before_ the patches that introduce the issue? This will guarantee that
> the patch is merged first, and will not break bisections once merged.

no problem, thanks.

