Return-Path: <kvm+bounces-64070-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B575C777DA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 07:00:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DBD53344E59
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 05:59:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3561C28A1F1;
	Fri, 21 Nov 2025 05:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LI8cRzPH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A2F24728F
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 05:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763704732; cv=none; b=Sf3Lm2yoa3AwDeHExvBwiRJN9aX37WI46NVcRronGlbW4T06H3sKQAzjWqOTyR9UN42IqGoY51WPwZdBtTNl/2MNCwhERhgVc9T6I3EInVwUjLvcTq0UPJY+e/2TxrgNuiJCB+ndU2TA0KyCwp+QbkX0nu1r7FOriwRakS6n/XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763704732; c=relaxed/simple;
	bh=BEMxfBOYQEUzN0sBK1lWBnRrXM0j97fIbmEldBvUYrY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bN+1a2Ns31fwcYWj5ofUEnR46rPUmQefzm5PlGhRnFo35zpo6e7x3/fOcMLiU6EH07p+n9nWH40ePwWN+QxfURwdcLKl7eYdc10iD5hH9XcuMaPLSAuEBjFxnFVwf700dWIe8h97zX8pkn7qZ5ZVe4ohvvtMuy5QPoBJwlNUW1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LI8cRzPH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763704727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 resent-to:resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references; bh=KxWPyWlvO0rezo2o1B/UY81NZvVMPhvZc/dOplcdSKY=;
	b=LI8cRzPH4HkOKLEuPSmJDPH6LDRrbHHgwdmPK8fgmIkENwWmHsZaIRekCBnKAYeQK+Sm6D
	5o7NZfzTkjwqkK94etFZo11e9u4w2RVXMCwOexcFpyi9EUjRKGJoFwP+mwgjQWfLmviOxa
	8JTB073GCrNjeV+CJYjMZEDZER3fnPM=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-540-gnVpiT2lMau2bDq3UAQfEg-1; Fri,
 21 Nov 2025 00:58:43 -0500
X-MC-Unique: gnVpiT2lMau2bDq3UAQfEg-1
X-Mimecast-MFC-AGG-ID: gnVpiT2lMau2bDq3UAQfEg_1763704719
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1718F180057A;
	Fri, 21 Nov 2025 05:58:38 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id F30B218004A3;
	Fri, 21 Nov 2025 05:58:35 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 9FDDF21E6A27; Fri, 21 Nov 2025 06:58:33 +0100 (CET)
Resent-To: michael.roth@amd.com, qemu_oss@crudebyte.com, palmer@dabbelt.com,
 samuel.thibault@ens-lyon.org, fam@euphon.net, lizhijian@fujitsu.com,
 edgar.iglesias@gmail.com, liwei1518@gmail.com, npiggin@gmail.com,
 shentey@gmail.com, arei.gonglei@huawei.com, zhao1.liu@intel.com,
 groug@kaod.org, sstabellini@kernel.org, philmd@linaro.org,
 zhiwei_liu@linux.alibaba.com, harshpb@linux.ibm.com, rathc@linux.ibm.com,
 stefanb@linux.vnet.ibm.com, xen-devel@lists.xenproject.org,
 qemu-block@nongnu.org, qemu-devel@nongnu.org, qemu-ppc@nongnu.org,
 qemu-riscv@nongnu.org, elena.ufimtseva@oracle.com, jag.raman@oracle.com,
 alex@shazbot.org, farosas@suse.de, dave@treblig.org,
 dbarboza@ventanamicro.com, kvm@vger.kernel.org, alistair.francis@wdc.com,
 sw@weilnetz.de, paul@xen.org, anthony@xenproject.org
Resent-From: Markus Armbruster <armbru@redhat.com>
Resent-Date: Fri, 21 Nov 2025 06:58:33 +0100
Resent-Message-ID: <87wm3korjq.fsf@pond.sub.org>
X-From-Line: armbru@redhat.com Fri Nov 21 06:55:24 2025
Received: from imap.gmail.com ([2a00:1450:400c:c07::6d]:993) by
  dusky.pond.sub.org with IMAP4-SSL getmail6 msgid:11/376136; 21 Nov 2025
  05:55:24 -0000
Received: from blackfin.pond.sub.org
 (p200300d36f125200d4b07119e720e6da.dip0.t-ipconnect.de.
 [2003:d3:6f12:5200:d4b0:7119:e720:e6da])
        by smtp.gmail.com with ESMTPSA id
 ffacd0b85a97d-42cb7fd8e54sm9034202f8f.40.2025.11.20.21.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 21:47:19 -0800 (PST)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id E659421E6A27; Fri, 21 Nov 2025 06:47:18 +0100 (CET)
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
Subject: Re: [PATCH 12/14] error: Use error_setg_errno() for simplicity and
 consistency
In-Reply-To: <aR-vExiomEe9jUNN@gallifrey> (David Alan Gilbert's message of
	"Fri, 21 Nov 2025 00:15:15 +0000")
References: <20251120191339.756429-1-armbru@redhat.com>
	<20251120191339.756429-13-armbru@redhat.com>
	<aR-vExiomEe9jUNN@gallifrey>
Date: Fri, 21 Nov 2025 06:47:18 +0100
Message-ID: <87jyzkq6mx.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-getmail-retrieved-from-mailbox: [Gmail]/All Mail
X-GMAIL-LABELS: "\\Sent"
X-GMAIL-THRID: 1849337867389441729
X-GMAIL-MSGID: 1849377727029175239
Lines: 45
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

"Dr. David Alan Gilbert" <dave@treblig.org> writes:

> * Markus Armbruster (armbru@redhat.com) wrote:
>> Use error_setg_errno() instead of passing the value of strerror() or
>> g_strerror() to error_setg().
>> 
>> The separator between the error message proper and the value of
>> strerror() changes from " : ", "", " - ", "- " to ": " in places.
>> 
>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>
>> @@ -792,9 +792,9 @@ static void vfu_object_init_ctx(VfuObject *o, Error **errp)
>>                             VFU_REGION_FLAG_RW | VFU_REGION_FLAG_ALWAYS_CB,
>>                             NULL, 0, -1, 0);
>>      if (ret < 0) {
>> -        error_setg(errp,
>> -                   "vfu: Failed to setup config space handlers for %s- %s",
>> -                   o->device, strerror(errno));
>> +        error_setg_errno(errp,
>> +                         "vfu: Failed to setup config space handlers for %s",
>> +                         o->device);
>
> missing errno.

Yes.

>>          goto fail;
>>      }
>>  
>> @@ -822,8 +822,8 @@ static void vfu_object_init_ctx(VfuObject *o, Error **errp)
>>  
>>      ret = vfu_realize_ctx(o->vfu_ctx);
>>      if (ret < 0) {
>> -        error_setg(errp, "vfu: Failed to realize device %s- %s",
>> -                   o->device, strerror(errno));
>> +        error_setg_errno(errp, "vfu: Failed to realize device %s",
>> +                         o->device);
>
> missing errno.

Yes.  Another file my build tree doesn't compile anymore.  Will fix,
thanks!

[...]


