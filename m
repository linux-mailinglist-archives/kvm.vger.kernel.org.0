Return-Path: <kvm+bounces-64021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AD42C76C4D
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:25:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id E56DB289DE
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C50DE267AF2;
	Fri, 21 Nov 2025 00:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="eynA8kSm"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9FA253951
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763684665; cv=none; b=SuX6AWdog+06+U5WHvjgFvlRdoYHQfFY79ZXCbiA2EcUGmtrHsl8E+dPZ63/b661eCHouuU/i+8vtYnhQHryQ96hjUwSUQPp7qNUkCSWW8XFC1B+W1vpDgq5KgXOEfoI3/WemAvvcUksPhJ8GQrhZh7germhHcJOYx1Eiu0SvcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763684665; c=relaxed/simple;
	bh=AHcFWUsLYropoR6mkRkWraNUvMOyjYxiRegP129uRpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XyyE4orpliRo5TqLdil+4blXk99F1ONsyZmvPRb6gcRwpOObZdRCdOAmk4fvkfTas0tzVZOoyeANA9IApq5KflMCf2nWHtVg910+drQ7lEVblYPqxIydecJ5xeYY/n8Smp0XLPLr9NmMsPiUE/Tg2p7X3lkDPQ056nO54jT/+GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=eynA8kSm; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=KXXaKr3PtFYh8nhHwgchIQAJ3u9wYBNIFydgNDU6Wo4=; b=eynA8kSmvhNEEgT9
	y0JKtg7iv1DeFQTCEwqE9seSwcVA1Xi7+YLa4mjuKStD0NXdu5S7jQHRij5Rtl9JTltmG+TsTC9Qx
	lOfNhVdI53+2SguooVed7NpK4gfR+2vbhtKFwSkttQDsraFmllf8Mt/0vctal58hWk1BxvQyIuHeu
	yCB3kkv3ZI/sZzZy5wcSXhbCuEAwhWxv94eXCJZ1AjXbelxxGWUGT0Ws5Eu3/gJ8ZSKS1ivDgyD9k
	L2BibqN6dzoj/ed6KSGgmPDpg4ESeaqhl/QfEgTk1Lxhf5r5xJzPuFDmoYjnS5h7I+ddk+xbmKbfj
	WwRB4DRNuEnYvwwalw==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vMEwY-00000005d06-2W0z;
	Fri, 21 Nov 2025 00:24:06 +0000
Date: Fri, 21 Nov 2025 00:24:06 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, arei.gonglei@huawei.com, pizhenwei@bytedance.com,
	alistair.francis@wdc.com, stefanb@linux.vnet.ibm.com,
	kwolf@redhat.com, hreitz@redhat.com, sw@weilnetz.de,
	qemu_oss@crudebyte.com, groug@kaod.org, mst@redhat.com,
	imammedo@redhat.com, anisinha@redhat.com, kraxel@redhat.com,
	shentey@gmail.com, npiggin@gmail.com, harshpb@linux.ibm.com,
	sstabellini@kernel.org, anthony@xenproject.org, paul@xen.org,
	edgar.iglesias@gmail.com, elena.ufimtseva@oracle.com,
	jag.raman@oracle.com, sgarzare@redhat.com, pbonzini@redhat.com,
	fam@euphon.net, philmd@linaro.org, alex@shazbot.org, clg@redhat.com,
	peterx@redhat.com, farosas@suse.de, lizhijian@fujitsu.com,
	jasowang@redhat.com, samuel.thibault@ens-lyon.org,
	michael.roth@amd.com, kkostiuk@redhat.com, zhao1.liu@intel.com,
	mtosatti@redhat.com, rathc@linux.ibm.com, palmer@dabbelt.com,
	liwei1518@gmail.com, dbarboza@ventanamicro.com,
	zhiwei_liu@linux.alibaba.com, marcandre.lureau@redhat.com,
	qemu-block@nongnu.org, qemu-ppc@nongnu.org,
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
	qemu-riscv@nongnu.org
Subject: Re: [PATCH 03/14] tap-solaris: Use error_setg_file_open() for better
 error messages
Message-ID: <aR-xJgDErvQaN600@gallifrey>
References: <20251120191339.756429-1-armbru@redhat.com>
 <20251120191339.756429-4-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20251120191339.756429-4-armbru@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 00:23:09 up 24 days, 23:59,  2 users,  load average: 0.00, 0.00,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Markus Armbruster (armbru@redhat.com) wrote:
> Error messages change from
> 
>     Can't open /dev/ip (actually /dev/udp)
>     Can't open /dev/tap
>     Can't open /dev/tap (2)
> 
> to
> 
>     Could not open '/dev/udp': REASON
>     Could not open '/dev/tap': REASON
> 
> where REASON is the value of strerror(errno).

I guess the new macro has a __LINE__ so the (2) is redundant.

> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>

> ---
>  net/tap-solaris.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/tap-solaris.c b/net/tap-solaris.c
> index 75397e6c54..faf7922ea8 100644
> --- a/net/tap-solaris.c
> +++ b/net/tap-solaris.c
> @@ -87,13 +87,13 @@ static int tap_alloc(char *dev, size_t dev_size, Error **errp)
>  
>      ip_fd = RETRY_ON_EINTR(open("/dev/udp", O_RDWR, 0));
>      if (ip_fd < 0) {
> -        error_setg(errp, "Can't open /dev/ip (actually /dev/udp)");
> +        error_setg_file_open(errp, errno, "/dev/udp");
>          return -1;
>      }
>  
>      tap_fd = RETRY_ON_EINTR(open("/dev/tap", O_RDWR, 0));
>      if (tap_fd < 0) {
> -        error_setg(errp, "Can't open /dev/tap");
> +        error_setg_file_open(errp, errno, "/dev/tap");
>          return -1;
>      }
>  
> @@ -107,7 +107,7 @@ static int tap_alloc(char *dev, size_t dev_size, Error **errp)
>  
>      if_fd = RETRY_ON_EINTR(open("/dev/tap", O_RDWR, 0));
>      if (if_fd < 0) {
> -        error_setg(errp, "Can't open /dev/tap (2)");
> +        error_setg_file_open(errp, errno, "/dev/tap");
>          return -1;
>      }
>      if(ioctl(if_fd, I_PUSH, "ip") < 0){
> -- 
> 2.49.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

