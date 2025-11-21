Return-Path: <kvm+bounces-64075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id ECCDFC77B6A
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 08:37:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 964463607AA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 07:37:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49338337B8B;
	Fri, 21 Nov 2025 07:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T/7e/eEo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FD3A33468E
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 07:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763710661; cv=none; b=RlfR/mslh4FNzKHiMjgrtVlQ8LiSKi36oX3zwpK6RMvv2YRzadfM4OsKkLhoSV8ylU+aA1cQ1CoFRGyUAaIHEBG1wDrsqXwwmzLaAzL6hI4O/LhsakJyaogalTGEXqoFnU/Xwb7OCUYmp+/cWVGH6yeCYakzw2eBdrCJQEprgIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763710661; c=relaxed/simple;
	bh=O4yUYlstzsGsEo98C5hQ9CTzRlB+xJjn+a0Fg6FDZos=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=bwRbUbRluBg63ntukpcM/HSCYIuSTA3eTno0C6PQG8Kyawh7o9LAVQ1dSVPgPtoGbz4TsTGgDSIY4I4Z3tOzGX9nDjmwxXyZDvzPFCyLqpqqSO1vRlIgkYlPUIWex371NNAm3y9SuKgyGlma3aDlKyU3gbZ4dLv+0Wf0hasf224=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=T/7e/eEo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763710657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=igDlYyRnPCE7UGrSaq2pRsy2AoYFeSBXmKnGZzjhM+c=;
	b=T/7e/eEoH6tK6Z6PkSNQOrFuKDSOUOWK05pa2NnadVYhMyvmB9x4c455isesYBscibvHeS
	jc52ZOeU39Rt8sFzel/M2NCGK9VOL3CMSD8aOD9YbmIuyaQ6kKDjejKOL8+azH6soNwblv
	U672nkQO1mSd01eygoNRMVPozJaQMX4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-145-4S8p1gJgOD2z9prdQBzToA-1; Fri,
 21 Nov 2025 02:37:32 -0500
X-MC-Unique: 4S8p1gJgOD2z9prdQBzToA-1
X-Mimecast-MFC-AGG-ID: 4S8p1gJgOD2z9prdQBzToA_1763710648
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A617B1956061;
	Fri, 21 Nov 2025 07:37:26 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23A9E1800877;
	Fri, 21 Nov 2025 07:37:24 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id ADAC221E6A27; Fri, 21 Nov 2025 08:37:21 +0100 (CET)
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
In-Reply-To: <87o6owq6ob.fsf@pond.sub.org> (Markus Armbruster's message of
	"Fri, 21 Nov 2025 06:46:28 +0100")
References: <20251120191339.756429-1-armbru@redhat.com>
	<20251120191339.756429-12-armbru@redhat.com>
	<aR-t5SzR2AdqlJtq@gallifrey> <87o6owq6ob.fsf@pond.sub.org>
Date: Fri, 21 Nov 2025 08:37:21 +0100
Message-ID: <87a50fq1ji.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Markus Armbruster <armbru@redhat.com> writes:

> "Dr. David Alan Gilbert" <dave@treblig.org> writes:
>
>> * Markus Armbruster (armbru@redhat.com) wrote:
>>> A few error messages show numeric errno codes.  Use error_setg_errno()
>>> to show human-readable text instead.
>>> 
>>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>>
>> ...
>>
>>> diff --git a/migration/rdma.c b/migration/rdma.c
>>> index 337b415889..ef4885ef5f 100644
>>> --- a/migration/rdma.c
>>> +++ b/migration/rdma.c
>>> @@ -2349,8 +2349,7 @@ static int qemu_get_cm_event_timeout(RDMAContext *rdma,
>>>          error_setg(errp, "RDMA ERROR: poll cm event timeout");
>>>          return -1;
>>>      } else if (ret < 0) {
>>> -        error_setg(errp, "RDMA ERROR: failed to poll cm event, errno=%i",
>>> -                   errno);
>>> +        error_setg_errno(errp, "RDMA ERROR: failed to poll cm event");
>>
>> Hasn't that lost the errno ?
>
> Yes.  My build tree must have lost the ability to compile this file.  I
> need to fix that.

Actually a patch splitting accident.  Fixed.

[...]


