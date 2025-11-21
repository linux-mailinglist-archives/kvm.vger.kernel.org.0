Return-Path: <kvm+bounces-64049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 320D2C76FA5
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 03:14:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 03E4635E24F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 02:09:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEAA423AB88;
	Fri, 21 Nov 2025 02:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="MA2Q9aKa"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412D7199EAD
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 02:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763690727; cv=none; b=AFWaEkuJmreojRtRvtHMrE7WQdmtTDKyuq81lU9tWvJvSxW4pPyHfOIZyQZs1bM2JB7k8Acittu5wBNL2l2VUk0Dcds0CCNzeoQr+9yW6bS1DiQ8fN+IqYuBlZAZ6ric8x5iupWRg1rqTS8OT1YUaOjLfd09SOSICK4iG0eyiS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763690727; c=relaxed/simple;
	bh=bLUohN9acE8zBJ1cUmJj3kwXyokVsYnxXAYyWXaC/Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X9KH/eRS/MFxksQBoZh5vxaJHf9YfM6E8Uh+kN8OYB1MZbi8Oo53ZdLtve82fUHDAnuEulP220/mgyVFNDNy2EBoxmeDg5VmQuciN/YWB9gdBc85yBYgOo0dYaVQvPt7FfbBg9GxTClsBQMPmP9mdZ6Uyf8Vg1ACXy9hknj4lGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=MA2Q9aKa; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=Pm4UnpdimlqsbJ4K376o2cJfR1Zky2oPXK2MjIcdLJY=; b=MA2Q9aKaMU1Z17SE
	Jy1K/s9Q2Ui7G0xXYte5iIj7lkeCCWTJlcqzv2legK6cK609mCL7Ok7MYB1Lz09b8y/q2DsX+rTkF
	dHQXIKiI19wjB8DeTNjb+SbaH1zrFUPh1PXNw3GBoZuS9yY8BFPdgr5tJ1U3ixF7i/Tw2tOaxN9si
	FqQmU2Y42S7qsAHDLSwELMBJ2q6MmsOkXA0fdPwwIMASdNHyaT+h0dhMD8C/EGSPU1GHxbITV4cc/
	H3fbq4sEwhBgq4DlXvgpywHAmKtRp6LN3o9vEhODJxZPAg3ASOTdQk06a6GlBHAfIR0sW0jAF8CcS
	ZsEY1K7sjBBktQyQPg==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vMGWK-00000005dm0-1euI;
	Fri, 21 Nov 2025 02:05:08 +0000
Date: Fri, 21 Nov 2025 02:05:08 +0000
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
Subject: Re: [PATCH 05/14] hw/scsi: Use error_setg_file_open() for a better
 error message
Message-ID: <aR_I1POkMYcdb1LJ@gallifrey>
References: <20251120191339.756429-1-armbru@redhat.com>
 <20251120191339.756429-6-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20251120191339.756429-6-armbru@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 02:04:59 up 25 days,  1:41,  2 users,  load average: 0.04, 0.04,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Markus Armbruster (armbru@redhat.com) wrote:
> The error message changes from
> 
>     vhost-scsi: open vhost char device failed: REASON
> 
> to
> 
>     Could not open '/dev/vhost-scsi': REASON
> 
> I think the exact file name is more useful to know than the file's
> purpose.
> 
> We could put back the "vhost-scsi: " prefix with error_prepend().  Not
> worth the bother.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>

> ---
>  hw/scsi/vhost-scsi.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/hw/scsi/vhost-scsi.c b/hw/scsi/vhost-scsi.c
> index cdf405b0f8..239138c931 100644
> --- a/hw/scsi/vhost-scsi.c
> +++ b/hw/scsi/vhost-scsi.c
> @@ -245,8 +245,7 @@ static void vhost_scsi_realize(DeviceState *dev, Error **errp)
>      } else {
>          vhostfd = open("/dev/vhost-scsi", O_RDWR);
>          if (vhostfd < 0) {
> -            error_setg(errp, "vhost-scsi: open vhost char device failed: %s",
> -                       strerror(errno));
> +            error_setg_file_open(errp, errno, "/dev/vhost-scsi");
>              return;
>          }
>      }
> -- 
> 2.49.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

