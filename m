Return-Path: <kvm+bounces-64052-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9B9C775DE
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:28:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id A36234E6504
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 05:28:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59E9A2F12C0;
	Fri, 21 Nov 2025 05:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZeOKvZZA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B931B85F8
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 05:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763702912; cv=none; b=FvN7A+69zl+rPCCHfBlrwSUuPMZOonmYY06egsB2T+jAa/nLur8bNmRGljaov/8dnNSzxSZ82BRC1j/xtVmtaEZDB5cW4IOhZlGPiKRpupB7C5x2DJB7ugLiknt1o7DgfdAnQ7lw+cQ6RcxuRn+1wyw5F38w1wti8i4cZH0/9I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763702912; c=relaxed/simple;
	bh=2FdNfe2rs3p+D0+Ez0qwYShuB/om8qis6O35bKAXV94=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KKxbIKJ/ii4qoTqtPFHzJbCmieXPcBIxlpnuOkAXLgS6dYvHRMozcyvsxoaOioS9//rDafUehPrtG+ZGO1f2vub1415xIK7Rq8ChdPfk38AGLPh3zDdcor24Ac/RqY2tFbMGKRTfIyZNfDSRg1mm2XmVOzXBDkWn7ifZisNbSek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZeOKvZZA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763702909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BEd9KlDvB7GskRmSaCjimoNXVvT4vORaDdSrmiFotWU=;
	b=ZeOKvZZA/U1pxUcvAyoFRdl3vID0QNoi472YNodxTuXl5Ox655mfUeUwccD/dahJfWlRyI
	72aSpUENxZ0VbE0e16G+4oXJ3viYyLIjBit2VJuWECXRbPsigb8opHZjVuBrh8P6QBvdyz
	mOEnJxGO423yXUevzvPxHu/yT+4/qoY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-387-m_eSFKIbNuOvbL9nfv2Tzg-1; Fri,
 21 Nov 2025 00:28:26 -0500
X-MC-Unique: m_eSFKIbNuOvbL9nfv2Tzg-1
X-Mimecast-MFC-AGG-ID: m_eSFKIbNuOvbL9nfv2Tzg_1763702902
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5C049180049F;
	Fri, 21 Nov 2025 05:28:20 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 58D431940E82;
	Fri, 21 Nov 2025 05:28:17 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id DF74721E6A27; Fri, 21 Nov 2025 06:28:14 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: "Dr. David Alan Gilbert" <dave@treblig.org>
Cc: qemu-devel@nongnu.org,  arei.gonglei@huawei.com,
  alistair.francis@wdc.com,  stefanb@linux.vnet.ibm.com,  kwolf@redhat.com,
  hreitz@redhat.com,  sw@weilnetz.de,  qemu_oss@crudebyte.com,
  groug@kaod.org,  mst@redhat.com,  imammedo@redhat.com,
  anisinha@redhat.com,  kraxel@redhat.com,  shentey@gmail.com,
  npiggin@gmail.com,  harshpb@linux.ibm.com,  sstabellini@kernel.org,
  anthony@xenproject.org,  paul@xen.org,  edgar.iglesias@gmail.com,
  elena.ufimtseva@oracle.com,  jag.raman@oracle.com,  sgarzare@redhat.com,
  pbonzini@redhat.com,  fam@euphon.net,  philmd@linaro.org,
  alex@shazbot.org,  clg@redhat.com,  peterx@redhat.com,  farosas@suse.de,
  lizhijian@fujitsu.com,  jasowang@redhat.com,
  samuel.thibault@ens-lyon.org,  michael.roth@amd.com,
  kkostiuk@redhat.com,  zhao1.liu@intel.com,  mtosatti@redhat.com,
  rathc@linux.ibm.com,  palmer@dabbelt.com,  liwei1518@gmail.com,
  dbarboza@ventanamicro.com,  zhiwei_liu@linux.alibaba.com,
  marcandre.lureau@redhat.com,  qemu-block@nongnu.org,
  qemu-ppc@nongnu.org,  xen-devel@lists.xenproject.org,
  kvm@vger.kernel.org,  qemu-riscv@nongnu.org
Subject: Re: [PATCH 02/14] hw/usb: Use error_setg_file_open() for a better
 error message
In-Reply-To: <aR-1jGX4Ck0f69zG@gallifrey> (David Alan Gilbert's message of
	"Fri, 21 Nov 2025 00:42:52 +0000")
References: <20251120191339.756429-1-armbru@redhat.com>
	<20251120191339.756429-3-armbru@redhat.com>
	<aR-1jGX4Ck0f69zG@gallifrey>
Date: Fri, 21 Nov 2025 06:28:14 +0100
Message-ID: <873468rm35.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

"Dr. David Alan Gilbert" <dave@treblig.org> writes:

> * Markus Armbruster (armbru@redhat.com) wrote:
>> The error message changes from
>> 
>>     open FILENAME failed
>> 
>> to
>> 
>>     Could not open 'FILENAME': REASON
>> 
>> where REASON is the value of strerror(errno).
>> 
>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>> ---
>>  hw/usb/bus.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/hw/usb/bus.c b/hw/usb/bus.c
>> index 8dd2ce415e..47d42ca3c1 100644
>> --- a/hw/usb/bus.c
>> +++ b/hw/usb/bus.c
>> @@ -262,7 +262,7 @@ static void usb_qdev_realize(DeviceState *qdev, Error **errp)
>>          int fd = qemu_open_old(dev->pcap_filename,
>>                                 O_CREAT | O_WRONLY | O_TRUNC | O_BINARY, 0666);
>>          if (fd < 0) {
>> -            error_setg(errp, "open %s failed", dev->pcap_filename);
>> +            error_setg_file_open(errp, errno, dev->pcap_filename);
>
> Wouldn't it be easier to flip it to use qemu_open() ?

Mechanical change; I missed the obvious :)

I'll give it a try, along with the call in ui/ui-qmp-cmd.c [PATCH 09].
Thanks!

>
> Dave
>
>>              usb_qdev_unrealize(qdev);
>>              return;
>>          }
>> -- 
>> 2.49.0
>> 


