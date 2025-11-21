Return-Path: <kvm+bounces-64068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 021EAC7776A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:51:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by tor.lore.kernel.org (Postfix) with ESMTPS id 58A632C8E8
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 05:51:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E42E30CD95;
	Fri, 21 Nov 2025 05:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FNKvTBqm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FE72F691E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 05:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763703927; cv=none; b=d/NASJ3d3dXTmSczNyaUZKkjmUGIkcdABqF712RdwCs0PXRHUJhJDayNjYylLDMUll+LAnMUUC/o3S5hzQBjcS3a2MaPFEZVWM7S51pMYqnDomRk0tgfdxrrCVCO6yazQZgBPDaL2rlHDNT3bfEsbDQW2xBUAGmmeOefyAKaTCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763703927; c=relaxed/simple;
	bh=fNZ9rmqoUtZt/YTIRrgszuhdubzYE+d6Ik7fy8NrPKs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cY48xj/qxRtInmFpA2wdOmGLt554YrHF85OkI2jEoiAOWmtsShgwwrnogsaD6uMHEzIRXwe8UEsqGyOeg4qVVu58Qo6P1z6nreV+q7Hw8JsFjv2YS4kZ9W3BJnCq91C64hbHL6C8i88z94+V7XzVII1Z+w3JTeAm5v0Be7rg3Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FNKvTBqm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763703920;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=M/iAoWDs3TI1i4yv2SFCc8BQMzVF2ZzwOWLNv6dOrLw=;
	b=FNKvTBqm72s46tEGky5sH9QpYLpbPrOcFK/Zs/m3bdDoDGQcINQztCQpusI9bRap5Oh5Xr
	aDfgmWsa2gvyS+fcDkhjbbP05foCROCaKw6Ps7eTFO7UlGDloubsgLgrHo9/8gJHTg6ajH
	iqmzqzr36xDtz63pcjU2x0yk/69ji/Q=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-556-QWRSdU85PZOwmsuMAg_68Q-1; Fri,
 21 Nov 2025 00:45:17 -0500
X-MC-Unique: QWRSdU85PZOwmsuMAg_68Q-1
X-Mimecast-MFC-AGG-ID: QWRSdU85PZOwmsuMAg_68Q_1763703913
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70BB31956072;
	Fri, 21 Nov 2025 05:45:11 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E836F1956045;
	Fri, 21 Nov 2025 05:45:08 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 7D61821E6A27; Fri, 21 Nov 2025 06:45:06 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: "Dr. David Alan Gilbert" <dave@treblig.org>
Cc: qemu-devel@nongnu.org,  arei.gonglei@huawei.com,
  pizhenwei@bytedance.com,  alistair.francis@wdc.com,
  stefanb@linux.vnet.ibm.com,  kwolf@redhat.com,  hreitz@redhat.com,
  sw@weilnetz.de,  qemu_oss@crudebyte.com,  groug@kaod.org,
  mst@redhat.com,  imammedo@redhat.com,  anisinha@redhat.com,
  kraxel@redhat.com,  shentey@gmail.com,  npiggin@gmail.com,
  harshpb@linux.ibm.com,  sstabellini@kernel.org,  anthony@xenproject.org,
  paul@xen.org,  edgar.iglesias@gmail.com,  elena.ufimtseva@oracle.com,
  jag.raman@oracle.com,  sgarzare@redhat.com,  pbonzini@redhat.com,
  fam@euphon.net,  philmd@linaro.org,  alex@shazbot.org,  clg@redhat.com,
  peterx@redhat.com,  farosas@suse.de,  lizhijian@fujitsu.com,
  jasowang@redhat.com,  samuel.thibault@ens-lyon.org,
  michael.roth@amd.com,  kkostiuk@redhat.com,  zhao1.liu@intel.com,
  mtosatti@redhat.com,  rathc@linux.ibm.com,  palmer@dabbelt.com,
  liwei1518@gmail.com,  dbarboza@ventanamicro.com,
  zhiwei_liu@linux.alibaba.com,  marcandre.lureau@redhat.com,
  qemu-block@nongnu.org,  qemu-ppc@nongnu.org,
  xen-devel@lists.xenproject.org,  kvm@vger.kernel.org,
  qemu-riscv@nongnu.org
Subject: Re: [PATCH 09/14] error: Use error_setg_file_open() for simplicity
 and consistency
In-Reply-To: <aR-q2YeegIEPmk2R@gallifrey> (David Alan Gilbert's message of
	"Thu, 20 Nov 2025 23:57:13 +0000")
References: <20251120191339.756429-1-armbru@redhat.com>
	<20251120191339.756429-10-armbru@redhat.com>
	<aR-q2YeegIEPmk2R@gallifrey>
Date: Fri, 21 Nov 2025 06:45:05 +0100
Message-ID: <87see8q6qm.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

"Dr. David Alan Gilbert" <dave@treblig.org> writes:

> * Markus Armbruster (armbru@redhat.com) wrote:
>> Replace
>> 
>>     error_setg_errno(errp, errno, MSG, FNAME);
>> 
>> by
>> 
>>     error_setg_file_open(errp, errno, FNAME);
>> 
>> where MSG is "Could not open '%s'" or similar.
>> 
>> Also replace equivalent uses of error_setg().
>> 
>> A few messages lose prefixes ("net dump: ", "SEV: ", __func__ ": ").
>> We could put them back with error_prepend().  Not worth the bother.
>
> Yeh, I guess you could just do it with another macro using
> the same internal function just with string concatenation.

I'm no fan of such prefixes.  A sign of developers not caring enough to
craft a good error message for *users*.  *Especially* in the case of
__func__.

The error messages changes in question are:

    net dump: can't open DUMP-FILE: REASON
    Could not open 'DUMP-FILE': REASON

    SEV: Failed to open SEV-DEVICE: REASON
    Could not open 'SEV-DEVICE': REASON

    sev_common_kvm_init: Failed to open SEV_DEVICE 'REASON'
    Could not open 'SEV-DEVICE': REASON

I think these are all improvements, and the loss of the prefix is fine.

>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>
> Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>

Thanks!


