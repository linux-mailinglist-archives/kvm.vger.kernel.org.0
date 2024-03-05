Return-Path: <kvm+bounces-10948-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB16871C74
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 11:59:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B819D1C22FAF
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:59:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED93B5D473;
	Tue,  5 Mar 2024 10:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IV1VzYLu"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCBA55E4B
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 10:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709636082; cv=none; b=DcT6ibzA2xTq3+xeeS8sWNL5W9rayAu2aQoQwzl3AHKM/o70QUWt6fKcNvhokCHC2OWvy8Ia73OxdGyhntebCMXy1M00CzqVUkOA2+4pNgHUyw+Heh88GAYkjLmGf3HvScrTLs7BwnrGZ/3cL04oOwPsEED95ozfn4jPuCTou6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709636082; c=relaxed/simple;
	bh=dI3s000qixj3E5I8Q6Pjeucgog6eAH6spG8GFUWUn1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uS9+v2/NhnPXE/J93VyVSU3tB8mIMH14zK4ZOkvZ4nKpqDfB2WDchqKz4x/+ZbxLnBEwRaT9/ffpkKGgGNkdMqvJTF6VwRYsxyRgUFWxkFs4e8Fd2spg30J/QWuB13vOI9p/76V7Mx+R0dwXAG3yKiFPUDgY9tKf6zsYCMyA454=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IV1VzYLu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709636079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xageVqCN2K3BbBi/+AWPwm4uxws0zuBvGlm7BUF0h+0=;
	b=IV1VzYLuC8RD1n1TNiqzz12IzHmaLEcd8OhcFNczJ5+a7jeIIogLlZde/x0DpNkoegCM1z
	VJljr6tz1er2Es4UXdA5IaK8dRfsSFPdJeeKl+YMVy4KXSzSFm/RbEwcFXzkjmLW3EV3Dj
	QwJ/nT5dwXESBb4tzi5A4feLCUnJwlM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-616-ckiM_axHPZScQyri9_KITA-1; Tue, 05 Mar 2024 05:54:36 -0500
X-MC-Unique: ckiM_axHPZScQyri9_KITA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 828ED18172C0;
	Tue,  5 Mar 2024 10:54:36 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.193.36])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 60204492BD6;
	Tue,  5 Mar 2024 10:54:36 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
	id 6710A18000B2; Tue,  5 Mar 2024 11:54:35 +0100 (CET)
Date: Tue, 5 Mar 2024 11:54:35 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
To: qemu-devel@nongnu.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v2 1/2] [debug] log kvm supported cpuid
Message-ID: <v7gtkm3ejxz7zsu4cfper7ukukz4uvovzcrvfcp2t2xw6rf33s@gkxwhk25cong>
References: <20240305105233.617131-1-kraxel@redhat.com>
 <20240305105233.617131-2-kraxel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305105233.617131-2-kraxel@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

>  target/i386/kvm/kvm.c | 14 ++++++++++++++

Oops, that was not meant to be posted.
Please ignore and look at patch 2/2.

thanks,
  Gerd


