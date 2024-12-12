Return-Path: <kvm+bounces-33547-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 095FD9EDE98
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 05:42:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57754283034
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2024 04:42:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8405116C854;
	Thu, 12 Dec 2024 04:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3hBq4Mi2"
X-Original-To: kvm@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1303A1632F2
	for <kvm@vger.kernel.org>; Thu, 12 Dec 2024 04:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733978529; cv=none; b=tqeOuItfODWoI/9USmELM+7gkSw57R4H0U3uGL70s9z5c7o6RbIO7hkeXbatJ8Jv6E+kFpkRVhSVcOirrmhVWtL4Z4AgJo8Gvvzl725X5W0AdnINincs8h7F+hVVMi9wFrJrUHccVIGVEcGNAmILFFGsDK0J3ma7E1I0B2g1NUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733978529; c=relaxed/simple;
	bh=VSPB5H/5Ru+deWWFWdmUnNIGHQXEATcyG1ExVSyPzws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oyQ0VNDf9+yxLZyydjZItsplW4i8vBIeG4Uba1V1oSWT8q5RvVCv9K1xpz0RY695/ug91R7FQtrI7bEeO5RTpRgqgxy2V6PRssw/RduL6CIGXl2JsWDtuZigAEB9/GgdjdrNW1S7qAzNKhmRGBVI2bDc0y21QkIIGh7acOIguDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3hBq4Mi2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iusK5qMixvk25AR0AHWcAwBzio4CrfqDNx30hrL/AzU=; b=3hBq4Mi2X8jYDOkiRad8lZLfif
	f2KWAWN6jqS32FuRgI/bsOwUIuF7zyMZFnPMfCMbCf5t9DRvnLLTWFcOTTaLjOWWeYzRRVJkay3fx
	xPWZ8+6KbyYJwz+0o7AJOaWRTMzQ0+yQN+l1y66uC+GAKCdTAlqpatwvcNrRuE2CBA4FoDtT/8sqY
	/ozjDYUPXp4uWkndRW7grtdbx7EwMCwtI/L3+jc3NukpXr5BwNamDUnwT6aPsto/AL6KWyD1gXVm4
	nJpf3Me9jwYAC7OwF63qrfmFAB0SbZLwiVL0GXUwdnho82ItNYn6A6wwnAxFb9oJl0IV3vBsn8AV1
	Qe4PpVDA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tLb1a-0000000GuhF-1fMs;
	Thu, 12 Dec 2024 04:42:06 +0000
Date: Wed, 11 Dec 2024 20:42:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] vfio/mdev: inline needed class_compat functionality
Message-ID: <Z1ppnnRV4aN4mZGy@infradead.org>
References: <0a14a4df-fbb5-4613-837f-f8025dc73380@gmail.com>
 <2024120430-boneless-wafer-bf0c@gregkh>
 <fb0fc57d-955f-404e-a222-e3864cce2b14@gmail.com>
 <2024120410-promoter-blandness-efa1@gregkh>
 <20241204123040.7e3483a4.alex.williamson@redhat.com>
 <9015ce52-e4f3-459c-bd74-b8707cf8fd88@gmail.com>
 <2024120617-icon-bagel-86b3@gregkh>
 <20241206093733.1d887dfc.alex.williamson@redhat.com>
 <2024120721-parasite-thespian-84e0@gregkh>
 <4b9781d5-5cbc-4254-9753-014cf5a8438d@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b9781d5-5cbc-4254-9753-014cf5a8438d@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sat, Dec 07, 2024 at 11:06:15AM +0100, Heiner Kallweit wrote:

[..a lot of full quotes..  Guys, can you please fix your email to
actually be readable.  Having to delete dozens of pages of crap is
really infuriating]

> Issue with this approach is that these "mdev parent" devices are partially
> class devices belonging to other classes. See for example mtty_dev_init(),
> there the device passed to us belongs to class mtty.

The samples don't matter and can be fixed any time.  Or even better
deleted.  The real question is if the i915, ccw and ap devices are
class devices.  From a quick unscientific grep they appear not to,
but we'd need to double check that.

(btw, drm_class_device_register in drm is entirely unused)


