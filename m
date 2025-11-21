Return-Path: <kvm+bounces-64013-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id BC4DEC76B5F
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:10:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.lore.kernel.org (Postfix) with ESMTPS id 887C128D25
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:10:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29B484502A;
	Fri, 21 Nov 2025 00:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b="ilbUYMN0"
X-Original-To: kvm@vger.kernel.org
Received: from mx.treblig.org (mx.treblig.org [46.235.229.95])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276CFC2EA
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 00:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.235.229.95
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763683835; cv=none; b=RjYvRqZT/AoqW/qt0rdEqXWsp0+gtneqPCWtHVRV5VGEse9gbKMQo9ukVua6nM2UeVQxh6ujpMoJ0Llmee47mYXWQy0jY3vDzJosSt/F0++8Lsz5CbXSOLiqdWUedi7f77r8obkSAx1kggYhU02rFoUSgO/+SBbMBR/TrqiQeXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763683835; c=relaxed/simple;
	bh=q9MRXngO/Fk44Lxrn6ZdUWbjYdM5alzXXaJptUgHiLM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IK1ZHc2yhX0DnnuS8l3C05JRMmhw3vspBCoL/P5aU1SSem4H9mrcVgU7VYVJKkb1q465I2//dRG2W504Z0uRK8IwpA2tMPD3U+G/vpPYdE2RRED/CPzXkml5XI6DP6npaLUj7vxFp7ACGlG2fx5oWaDWMYw7+XXd5e5vuZHaYHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org; spf=pass smtp.mailfrom=treblig.org; dkim=pass (2048-bit key) header.d=treblig.org header.i=@treblig.org header.b=ilbUYMN0; arc=none smtp.client-ip=46.235.229.95
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=treblig.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=treblig.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=treblig.org
	; s=bytemarkmx; h=Content-Type:MIME-Version:Message-ID:Subject:From:Date:From
	:Subject; bh=4YAcbiarbzQHvhEzZ63n6RkH46R+BEUGak5gqn7DS+0=; b=ilbUYMN0rKRC6nJC
	AjVUwVMVW7944N9SN4N3h+IDCtzr87WMNXUIjULXle6L7f2jIHRXFfSFJOhAvPsDh+Z0MgdXaqFzH
	xtlyavuW6OwPf2BO03CsvX0Ryu0GPXNoJeLboZkxtZVm6GJSOHN/CzhKQQpMqsdK6HpavN34jWfZZ
	Kt1+prB3CLGVGdrqi5ZXeOePqoNkHL74MhrVFb1qWAECOoiXvaAqik3S9zDCGG3ogy18MMD4PBfRk
	VNgLVDGImyGZWGiBa95qzFc+pyTfzMMKtajdwOWnCMLk2vMLrIgLH4H3PxDBorM9KvZw7GDP0Hojb
	9PgYJe97XoKoacFcHw==;
Received: from dg by mx.treblig.org with local (Exim 4.98.2)
	(envelope-from <dg@treblig.org>)
	id 1vMEj7-00000005csx-0Lk8;
	Fri, 21 Nov 2025 00:10:13 +0000
Date: Fri, 21 Nov 2025 00:10:13 +0000
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
Subject: Re: [PATCH 11/14] error: Use error_setg_errno() to improve error
 messages
Message-ID: <aR-t5SzR2AdqlJtq@gallifrey>
References: <20251120191339.756429-1-armbru@redhat.com>
 <20251120191339.756429-12-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20251120191339.756429-12-armbru@redhat.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/6.12.48+deb13-amd64 (x86_64)
X-Uptime: 00:09:12 up 24 days, 23:45,  2 users,  load average: 0.03, 0.03,
 0.00
User-Agent: Mutt/2.2.13 (2024-03-09)

* Markus Armbruster (armbru@redhat.com) wrote:
> A few error messages show numeric errno codes.  Use error_setg_errno()
> to show human-readable text instead.
> 
> Signed-off-by: Markus Armbruster <armbru@redhat.com>

...

> diff --git a/migration/rdma.c b/migration/rdma.c
> index 337b415889..ef4885ef5f 100644
> --- a/migration/rdma.c
> +++ b/migration/rdma.c
> @@ -2349,8 +2349,7 @@ static int qemu_get_cm_event_timeout(RDMAContext *rdma,
>          error_setg(errp, "RDMA ERROR: poll cm event timeout");
>          return -1;
>      } else if (ret < 0) {
> -        error_setg(errp, "RDMA ERROR: failed to poll cm event, errno=%i",
> -                   errno);
> +        error_setg_errno(errp, "RDMA ERROR: failed to poll cm event");

Hasn't that lost the errno ?

Dave

-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\        dave @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/

