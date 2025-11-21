Return-Path: <kvm+bounces-64026-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B37BC76CB0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:43:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id B73C44E33BB
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:43:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A20926AA94;
	Fri, 21 Nov 2025 00:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="Qf7O3sUM"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC8922D780
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:43:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763685796; cv=none; b=l2fXzuu9ING4nBExavmjwoRhDyFcKADuQ9zNa+oVMSU1sRTD3g1Mm18PXiG71z3DVY45MfW6tZqlBS/dvx7nsT3ekw+mo6EFLDaqnlIu0qgahLU64PVeRHypzOo95sfmG0XPk/FC1elMAuBJuhcMrU+YGl2pcizZ7Rh26jZITkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763685796; c=relaxed/simple;
	bh=UhTFvtpVq6kWmVt5shuUmmxHH2vcg97cqvd4UMEAHHE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HU5+67DvZFwPEw7w4SE6pJ9Ht6ErS9fSuZiT5MaoqYSp+R4gD2puVMRt/+GfIEFu2/fe1SyOrU06s5SGjyp/F+xyLY00mTnsevXGGcltcGliwDoYokGQl7+nvTiAQB2uW2WpizflkGeVWFY+CzhgoZmEo/rna1Et8g8BIgGsP6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=Qf7O3sUM; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=2lQMqxTn4BDPqEuJHUsXNxZ6n7/HofNAtadPoRD5+7A=; b=Qf7O3sUMLMEvDppF
	qQS46KXVaYPyHAaU1CV6kQ3Zac1Bsl979tFpEKhucfRVImUbbRbQAkvH/J6e1RkwbIJ9ER9wzz6QN
	RH8AcCtZaVM3MsUhggZi8wPrN5NFCfg0uNr7O160etRomxsSa0Jh4M+pvJIiG63p3ncXU94kqOzWr
	jXgZWgi/P/gswYRUiVLOtFw1NDiXKw1dgi42YCoknL0Gp2dYCm6LqmlqsV+qycQ6UsUfNDqp1LmBX
	pkhtExl893Wi0Ca9f3caRkQI/N2V6wf2WvNWVwxV9VtNbVMCeGGp26Nsw/jhOgF1sZTbaeYLH0Stz
	GqEA+p/C4lktH6mnRg==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vMFEi-00000005d8M-37pF;
	Fri, 21 Nov 2025 00:42:52 +0000
Date: Fri, 21 Nov 2025 00:42:52 +0000
From: "Dr. David Alan Gilbert" <dave@treblig.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: qemu-devel@nongnu.org, arei.gonglei@huawei.com,
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
Subject: Re: [PATCH 02/14] hw/usb: Use error_setg_file_open() for a better
 error message
Message-ID: <aR-1jGX4Ck0f69zG@gallifrey>
References: <20251120191339.756429-1-armbru@redhat.com>
 <20251120191339.756429-3-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20251120191339.756429-3-armbru@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 00:41:22 up 25 days, 17 min,  2 users,  load average: 0.01, 0.02,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Markus Armbruster (armbru@redhat.com) wrote:
> The error message changes from
> 
>     open FILENAME failed
> 
> to
> 
>     Could not open 'FILENAME': REASON
> 
> where REASON is the value of strerror(errno).
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>
> ---
>  hw/usb/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/hw/usb/bus.c b/hw/usb/bus.c
> index 8dd2ce415e..47d42ca3c1 100644
> --- a/hw/usb/bus.c
> +++ b/hw/usb/bus.c
> @@ -262,7 +262,7 @@ static void usb_qdev_realize(DeviceState *qdev, Error **errp)
>          int fd = qemu_open_old(dev->pcap_filename,
>                                 O_CREAT | O_WRONLY | O_TRUNC | O_BINARY, 0666);
>          if (fd < 0) {
> -            error_setg(errp, "open %s failed", dev->pcap_filename);
> +            error_setg_file_open(errp, errno, dev->pcap_filename);

Wouldn't it be easier to flip it to use qemu_open() ?

Dave

>              usb_qdev_unrealize(qdev);
>              return;
>          }
> -- 
> 2.49.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

