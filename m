Return-Path: <kvm+bounces-64069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id AF595C777A9
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:55:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 463CA3613F5
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 05:52:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A672B2FD7D6;
	Fri, 21 Nov 2025 05:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NdxWdY2i"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975BA279DA6
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 05:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763704003; cv=none; b=P6sTvQxfzROYeNlTMgE2PJTpjOTXYaOcOnMN22lAlx/KQapy2Znp9YIOioGg9Gbqxl86JWBYQtOPOnBTGThlKAObh+8lmbKQJuuq6RB4t2gnh/vbfCU3H2OgCOoFLQhyMKkRvEuLWytQ7wlGk7PN16W8/xbljGloMhfKciURwk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763704003; c=relaxed/simple;
	bh=pKXvuTUuVUdZDcn02jF5WOtDnUeBdmJiiJe79qCuK7U=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UZJf+icH+3xlzJq2/zlBCc9xmKX6zTmlwlHzk9KZ1tQ6EM1CoFX441jiLDuLywu22YNnEbXCk+ci7sGO9xlr0RUm4umefb5TvrS0WMnpR8DIbfuYOk0Ck5N7uKHo+NNnTwNk6OHnivPX/oP+fmzrWK4vhF0GvuRmAROUPSNio0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NdxWdY2i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763704000;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PL3yXLCkMFHCIh38uQXNnEtvLjSg5S3Sh+k5cm/3Mtg=;
	b=NdxWdY2iCyU4CMCGdUyyLou1luNwZrFhWmnfwqBnauK5N6B7OWQmZViarkv4HuptSUIh6J
	qc8sYiHUEFS2XPx7Hk21zs9zk+VaMInW77S/+G0syaxD5vvbgA/2snBzMZIYldbUNayoAf
	AXqADCh/+ukLB6YDeJKyc3vYuN5Na1Y=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-265-dw4h8ppxNGOwFwV5lUYlYA-1; Fri,
 21 Nov 2025 00:46:38 -0500
X-MC-Unique: dw4h8ppxNGOwFwV5lUYlYA-1
X-Mimecast-MFC-AGG-ID: dw4h8ppxNGOwFwV5lUYlYA_1763703994
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DBBCD1956050;
	Fri, 21 Nov 2025 05:46:32 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DF8A430044DC;
	Fri, 21 Nov 2025 05:46:30 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 6FAF521E6A27; Fri, 21 Nov 2025 06:46:28 +0100 (CET)
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
Subject: Re: [PATCH 11/14] error: Use error_setg_errno() to improve error
 messages
In-Reply-To: <aR-t5SzR2AdqlJtq@gallifrey> (David Alan Gilbert's message of
	"Fri, 21 Nov 2025 00:10:13 +0000")
References: <20251120191339.756429-1-armbru@redhat.com>
	<20251120191339.756429-12-armbru@redhat.com>
	<aR-t5SzR2AdqlJtq@gallifrey>
Date: Fri, 21 Nov 2025 06:46:28 +0100
Message-ID: <87o6owq6ob.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

"Dr. David Alan Gilbert" <dave@treblig.org> writes:

> * Markus Armbruster (armbru@redhat.com) wrote:
>> A few error messages show numeric errno codes.  Use error_setg_errno()
>> to show human-readable text instead.
>> 
>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>
> ...
>
>> diff --git a/migration/rdma.c b/migration/rdma.c
>> index 337b415889..ef4885ef5f 100644
>> --- a/migration/rdma.c
>> +++ b/migration/rdma.c
>> @@ -2349,8 +2349,7 @@ static int qemu_get_cm_event_timeout(RDMAContext *rdma,
>>          error_setg(errp, "RDMA ERROR: poll cm event timeout");
>>          return -1;
>>      } else if (ret < 0) {
>> -        error_setg(errp, "RDMA ERROR: failed to poll cm event, errno=%i",
>> -                   errno);
>> +        error_setg_errno(errp, "RDMA ERROR: failed to poll cm event");
>
> Hasn't that lost the errno ?

Yes.  My build tree must have lost the ability to compile this file.  I
need to fix that.

Thanks!


