Return-Path: <kvm+bounces-20238-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18CB79122C3
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 12:46:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 497B01C219A9
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 10:46:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE3D172BDC;
	Fri, 21 Jun 2024 10:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b="S/67yKen"
X-Original-To: kvm@vger.kernel.org
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9866F16DEC9
	for <kvm@vger.kernel.org>; Fri, 21 Jun 2024 10:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718966736; cv=none; b=dV36aOE2EExG4/FIzWIP1c68/23dFsECMX++zFn/HeD6Qtek3y5ktnQAQF1gYe5b5WNCZVN8tKXlDdsvdNnA08jbSCcWWpz3UuvJIHKaDMFTZHVPfbtqawBN5lFh71M9VCxhsLFLoTwn4WwocWjUQibqkJbPXABJTph9VoeJhlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718966736; c=relaxed/simple;
	bh=HAOg6CcvIbtWrST0s7daJ2upj71SoAy3nNYChBzVssY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AwuZ43+Cewt7nQeTHKvLYkItlvuv9824NB319uw08D4sThueUz0Ia1Z/mtwpY5nq2DzV02jduTJIG020AePumLo+xBE5NbVicSdehB8HoNj6RWLuoa1yZe0js00dfKfL7tp114rqmLU9oEz6Vcq+q5yIcH4hJBK6aUWYz2/r5Mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de; spf=pass smtp.mailfrom=t-8ch.de; dkim=pass (1024-bit key) header.d=t-8ch.de header.i=@t-8ch.de header.b=S/67yKen; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=t-8ch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=t-8ch.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=t-8ch.de; s=mail;
	t=1718966730; bh=HAOg6CcvIbtWrST0s7daJ2upj71SoAy3nNYChBzVssY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S/67yKenKThw2jqYinx+evK6yK5PsvxKTvKD60miRaRh7sg1iaNAWY296XwUofc9r
	 aiP9sZ2MDEpNR21cBLaJPxdYMX1lD4ZvDd4BC6GR/HRdc8gxWURwh5CWiCuH/TpM3m
	 NAeks98RF0+qnxvv6cuvFWs9gsAtNxGlgPKesg/Q=
Date: Fri, 21 Jun 2024 12:45:29 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas@t-8ch.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Cornelia Huck <cohuck@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
	Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>, qemu-devel@nongnu.org, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v8 3/8] hw/misc/pvpanic: centralize definition of
 supported events
Message-ID: <4873c62a-7d23-4c03-bfde-5f6c00e10aaa@t-8ch.de>
References: <20240527-pvpanic-shutdown-v8-0-5a28ec02558b@t-8ch.de>
 <20240527-pvpanic-shutdown-v8-3-5a28ec02558b@t-8ch.de>
 <20240621062512-mutt-send-email-mst@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240621062512-mutt-send-email-mst@kernel.org>

On 2024-06-21 06:26:19+0000, Michael S. Tsirkin wrote:
> On Mon, May 27, 2024 at 08:27:49AM +0200, Thomas Weißschuh wrote:

<snip>

> > diff --git a/hw/misc/pvpanic.c b/hw/misc/pvpanic.c
> > index 1540e9091a45..a4982cc5928e 100644
> > --- a/hw/misc/pvpanic.c
> > +++ b/hw/misc/pvpanic.c
> > @@ -21,13 +21,12 @@
> >  #include "hw/qdev-properties.h"
> >  #include "hw/misc/pvpanic.h"
> >  #include "qom/object.h"
> > -#include "standard-headers/linux/pvpanic.h"
> 
> 
> This part is wrong. PVPANIC_PANICKED and PVPANIC_CRASH_LOADED
> are still used in pvpanic.c directly, so we should
> include standard-headers/linux/pvpanic.h to avoid depending
> on which header includes which.

Ack.

> I fixed up the patch.

Thanks!

<snip>


Thomas

