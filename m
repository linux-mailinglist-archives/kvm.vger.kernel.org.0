Return-Path: <kvm+bounces-64046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B748CC76DB0
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 02:13:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 5E1FD2B902
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:13:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3317C2749C7;
	Fri, 21 Nov 2025 01:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="TDvy2bE0"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0F641A8F
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 01:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763687599; cv=none; b=Wn6MA/XqmVIps2j7ZjPEais7tptWLl1tyA55KukwpQNxJ7Y1nzndcFqMCKKsvimXuc9plKQDezkVp+FtEl/e1aZlPNdEAqi5uy+zIWqxLIQikIQXDCUUewp0eEDtjcgivi6Tfi4BTXX44GBeRjdh5eJCYwypwx9ZYyjMg2uEnQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763687599; c=relaxed/simple;
	bh=7vMskQIEkUuRVwrkNpGItXZ5CTplE6L4P7NpkQUFI0g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E7wm4DYamMImbazBgCttmBCHSjwOYMRiXiKF6xOijDafCOkuEuDFJnHwQ5E7BIrwEXl3+PR4BvO1v/wVcAIynwKnomjqCGQyw7pngAbwpKcYBibTEVX8PmwIvNUAWWNeK3BkHXR3Z6HP+XoBQb/KkpfTyzovVoKvK7sAcbHGKw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=TDvy2bE0; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=YkcAcM/gBGVrQp+f5sFqb9ygI3lzdlKVWJYNwKoWEWE=; b=TDvy2bE0sCbJMqGR
	6RV+TyLxwmEy+Oyz30kcyWScsmg3kqZ1HYnqmwprl/rnCKams9bOEB3LSH/Akpbrnr2ofs5v/uTGc
	f0Z0rlwOKV6joh0Vy5iuxorodHfXNgMpxdHeZDI5xWGczg0ZiQsLtgLha2rXKgKzRkhOV0q5xRGhu
	QZuUe+F78WpyiyrINkBBn2cMqAlvDfIXl8bTd1oe9wfcjUydY4ZygIcYfKWaaWIJhTOummUCQmzIu
	QFgZ0e7UwZRMbOeB/ohDktlQEp86CO54OhmBDBe3IDmwPu7wcBXoJlpUSJAz3GsGpDs3GGQ7Lw9o1
	EStADm8tf/LhZjsDoQ==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vMFho-00000005dQh-2cmY;
	Fri, 21 Nov 2025 01:12:56 +0000
Date: Fri, 21 Nov 2025 01:12:56 +0000
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
Subject: Re: [PATCH 04/14] qga: Use error_setg_file_open() for better error
 messages
Message-ID: <aR-8mOKG-rYkjyjh@gallifrey>
References: <20251120191339.756429-1-armbru@redhat.com>
 <20251120191339.756429-5-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20251120191339.756429-5-armbru@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 01:12:53 up 25 days, 49 min,  2 users,  load average: 0.02, 0.01,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Markus Armbruster (armbru@redhat.com) wrote:
> Error messages change from
> 
>     open("FNAME"): REASON
> 
> to
> 
>     Could not open 'FNAME': REASON
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>

> ---
>  qga/commands-linux.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/qga/commands-linux.c b/qga/commands-linux.c
> index 4a09ddc760..5cf76ca2d9 100644
> --- a/qga/commands-linux.c
> +++ b/qga/commands-linux.c
> @@ -1502,14 +1502,15 @@ static void transfer_vcpu(GuestLogicalProcessor *vcpu, bool sys2vcpu,
>  
>      dirfd = open(dirpath, O_RDONLY | O_DIRECTORY);
>      if (dirfd == -1) {
> -        error_setg_errno(errp, errno, "open(\"%s\")", dirpath);
> +        error_setg_file_open(errp, errno, dirpath);
>          return;
>      }
>  
>      fd = openat(dirfd, fn, sys2vcpu ? O_RDONLY : O_RDWR);
>      if (fd == -1) {
>          if (errno != ENOENT) {
> -            error_setg_errno(errp, errno, "open(\"%s/%s\")", dirpath, fn);
> +            error_setg_errno(errp, errno, "could not open %s/%s",
> +                             dirpath, fn);
>          } else if (sys2vcpu) {
>              vcpu->online = true;
>              vcpu->can_offline = false;
> @@ -1711,7 +1712,7 @@ static void transfer_memory_block(GuestMemoryBlock *mem_blk, bool sys2memblk,
>      dirfd = open(dirpath, O_RDONLY | O_DIRECTORY);
>      if (dirfd == -1) {
>          if (sys2memblk) {
> -            error_setg_errno(errp, errno, "open(\"%s\")", dirpath);
> +            error_setg_file_open(errp, errno, dirpath);
>          } else {
>              if (errno == ENOENT) {
>                  result->response = GUEST_MEMORY_BLOCK_RESPONSE_TYPE_NOT_FOUND;
> @@ -1936,7 +1937,7 @@ static GuestDiskStatsInfoList *guest_get_diskstats(Error **errp)
>  
>      fp = fopen(diskstats, "r");
>      if (fp  == NULL) {
> -        error_setg_errno(errp, errno, "open(\"%s\")", diskstats);
> +        error_setg_file_open(errp, errno, diskstats);
>          return NULL;
>      }
>  
> @@ -2047,7 +2048,7 @@ GuestCpuStatsList *qmp_guest_get_cpustats(Error **errp)
>  
>      fp = fopen(cpustats, "r");
>      if (fp  == NULL) {
> -        error_setg_errno(errp, errno, "open(\"%s\")", cpustats);
> +        error_setg_file_open(errp, errno, cpustats);
>          return NULL;
>      }
>  
> -- 
> 2.49.0
> 
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

