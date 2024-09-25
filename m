Return-Path: <kvm+bounces-27496-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42C5F9867DA
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 22:50:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E65EA1F236CE
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 20:50:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0CAF156677;
	Wed, 25 Sep 2024 20:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="KkDNER+0"
X-Original-To: kvm@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8925F1534EC;
	Wed, 25 Sep 2024 20:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727297410; cv=none; b=r2D+sED9sSeQfavQEU8x9IO8paV1ngHOnYzm2YPXyO6IpJX2iTmtZvwkSozFvXUIReRZuTMh5kbFL57IShD0XFEGMO+XySUrUoKsjNLjQEH9ebpPH8D2pmdGpF2CZUwGIegPw1g1BL8GecKEf8c/M0tUM+cm6TYYTMxnh5hEl7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727297410; c=relaxed/simple;
	bh=GLEGXW/IRreMuP+Ewe2MM2lF19EhyviiE352szWHvaE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hm3YfGuPf8UQORwkuh4WTlmcxumXif6Hdo2cYVBBHJi1FC+2dbtxfuG/gP6FBKZbQIzwP5h3ttSjS0DUkoPgrOpEPNp5N21ezEtehjMRaK0DECzmf5kqSyUMqg8yZNtrcbkFRSXf5+cNFBZUQZg7bjlYNAFy2JI867JbosDxVAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=KkDNER+0; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=9Fw6nSSCpgyFPlJKUOs3JFoolcvYhoNhkTP59zcOyUg=; b=KkDNER+0neATPShnr3UWEAMMfc
	EUgLliRk49wD+jn7X3Mm0nrgEBxGYQCk1K6fi3UN0XOQjC0dvC1R466n6Nbs7j4GjabOkxvSOw8qC
	X5RprFLMo6NGy1TjcTYJty2SJ5jiF+RyZkzOX8jyChUozIxu3TiBFc9udU7GVyYN+jlW+xiodAhJ3
	Aq5fi9rteygETWNqwOk8PvCHRgkQTvKt1GHzbOkXjGJHDiiCWu/5e8lbcKVy2DsaO+YZBEKHk/UVH
	JgCWh7EKohG++4t/SyQpgiraYfRBU5/tfwiUE4MFcJvqWrY50jstTrRbZCGsHY5VRq8ItjuGdpeG1
	1Q5Lti9Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1stYxZ-0000000FVTV-3oxD;
	Wed, 25 Sep 2024 20:50:05 +0000
Date: Wed, 25 Sep 2024 21:50:05 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Markus Elfring <Markus.Elfring@web.de>
Cc: virtualization@lists.linux.dev, kvm@vger.kernel.org,
	netdev@vger.kernel.org,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Tiwei Bie <tiwei.bie@intel.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] vhost-vdpa: Refactor copy_to_user() usage in
 vhost_vdpa_get_config()
Message-ID: <20240925205005.GL3550746@ZenIV>
References: <79b2f48a-f6a1-4bfc-9a8d-cb09777f2a07@web.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79b2f48a-f6a1-4bfc-9a8d-cb09777f2a07@web.de>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Sep 25, 2024 at 08:48:16PM +0200, Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Wed, 25 Sep 2024 20:36:35 +0200
> 
> Assign the return value from a copy_to_user() call to an additional
> local variable so that a kvfree() call and return statement can be
> omitted accordingly.

Ugly and unidiomatic.

> This issue was detected by using the Coccinelle software.

What issue?

> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Nevermind (and I really need more coffee, seeing that I'd missed the
obvious indicator of garbage and failed to hit delete)...

