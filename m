Return-Path: <kvm+bounces-64278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B4827C7C98F
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 08:37:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB6563A7F4E
	for <lists+kvm@lfdr.de>; Sat, 22 Nov 2025 07:37:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98849273D81;
	Sat, 22 Nov 2025 07:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Njoorb8B"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C422C1E3DCD
	for <kvm@vger.kernel.org>; Sat, 22 Nov 2025 07:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763797019; cv=none; b=s+UPpvbv0izlPkNi3zBuEAk004n0HKvnfmtvC3FDSvaJtMVpej21YulGjPjmMqfJPDS7QpgjdiAKxZsChLRET8YyEPxGux/ipW1QMuXoG7YMZFvYtlRl0g83j6aIcPLGykKP57Jh6hbwsq9z37Pq/mb7x2B+2BQZcBLvZgOQhkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763797019; c=relaxed/simple;
	bh=socHazK02WmQPAa/H3fBJMqFdlF5N6VLmmRIy+vy1zg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dxye1Bx8uYK28sWPnF1LjmnE07OiVK8NEi+TqW/pdpQuTx7Ddd79OaFV/nvjmtBCzceTR9AvqDDRzWzlVn6ihnhw+JqnixKl0rB0VlZ2xffdXRK+zhMRm1qhTOtjBkGzEgC6mzcwdzIgXMGyC+zzoP0L/+g0KcEg/ea8XCbhwOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Njoorb8B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763797016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9zaKUM6NERkcDDV6tGqy74CB52tnWy2WHUiDFb7Jfp8=;
	b=Njoorb8B24NKoThbfuSpKVtnoVvfJ6lGPvyAYNTIf2igp6WcTimgvWGroBPvGewVs1Lobx
	I/2UM1zkTMHLa93ZZ1+nCicPIdtR3X0pUFCwis/H8bH5/yiIXSeThOFAWWMVpWikpXiBWE
	ReKpfMLQwGiztObXUaPSL32YccCjqPU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-403-_NSKGyWnNIq26wjDIyzvQA-1; Sat,
 22 Nov 2025 02:36:51 -0500
X-MC-Unique: _NSKGyWnNIq26wjDIyzvQA-1
X-Mimecast-MFC-AGG-ID: _NSKGyWnNIq26wjDIyzvQA_1763797008
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8F13A195608F;
	Sat, 22 Nov 2025 07:36:45 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.3])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 930D118004D8;
	Sat, 22 Nov 2025 07:36:42 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 1260B21E6A27; Sat, 22 Nov 2025 08:36:40 +0100 (CET)
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
In-Reply-To: <aSClUIvI2W-PVv6B@gallifrey> (David Alan Gilbert's message of
	"Fri, 21 Nov 2025 17:45:52 +0000")
References: <20251120191339.756429-1-armbru@redhat.com>
	<20251120191339.756429-10-armbru@redhat.com>
	<aR-q2YeegIEPmk2R@gallifrey> <87see8q6qm.fsf@pond.sub.org>
	<aSClUIvI2W-PVv6B@gallifrey>
Date: Sat, 22 Nov 2025 08:36:40 +0100
Message-ID: <87ecpqtt6f.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

"Dr. David Alan Gilbert" <dave@treblig.org> writes:

> * Markus Armbruster (armbru@redhat.com) wrote:
>> "Dr. David Alan Gilbert" <dave@treblig.org> writes:
>> 
>> > * Markus Armbruster (armbru@redhat.com) wrote:
>> >> Replace
>> >> 
>> >>     error_setg_errno(errp, errno, MSG, FNAME);
>> >> 
>> >> by
>> >> 
>> >>     error_setg_file_open(errp, errno, FNAME);
>> >> 
>> >> where MSG is "Could not open '%s'" or similar.
>> >> 
>> >> Also replace equivalent uses of error_setg().
>> >> 
>> >> A few messages lose prefixes ("net dump: ", "SEV: ", __func__ ": ").
>> >> We could put them back with error_prepend().  Not worth the bother.
>> >
>> > Yeh, I guess you could just do it with another macro using
>> > the same internal function just with string concatenation.
>> 
>> I'm no fan of such prefixes.  A sign of developers not caring enough to
>> craft a good error message for *users*.  *Especially* in the case of
>> __func__.
>> 
>> The error messages changes in question are:
>> 
>>     net dump: can't open DUMP-FILE: REASON
>>     Could not open 'DUMP-FILE': REASON
>> 
>>     SEV: Failed to open SEV-DEVICE: REASON
>>     Could not open 'SEV-DEVICE': REASON
>> 
>>     sev_common_kvm_init: Failed to open SEV_DEVICE 'REASON'
>>     Could not open 'SEV-DEVICE': REASON
>> 
>> I think these are all improvements, and the loss of the prefix is fine.
>
> Yeh, although I find the error messages aren't just for users;
> they're often for the first dev to see it to guess which other
> dev to pass the problem to, so a hint about where it's coming
> from can be useful.

I agree!  But I think an error message must be make sense to users
*first* and help developers second, and once they make sense to users,
they're often good enough for developers.

The common failures I see happen when developers remain caught in the
developer's perspective, and write something that makes sense to *them*.
Strawman form:

    prefix: failed op[: reason]

where "prefix" is a subsystem tag, or even __func__, and "reason" is
strerror() or similar.

To users, this tends to read as

    gobbledygook: techbabble[: reason]

When we care to replace "failed op" (developer's perspective) by
something that actually makes sense to users, "prefix" often becomes
redundant.

The error messages shown above aren't bad to begin with.  "failed to
open FILE", where FILE is something the user specified, should make
sense to the user.  It should also be good enough for developers even
without a prefix: connecting trouble with the DUMP-FILE to dump /
trouble with the SEV-DEVICE to SEV should be straightforward.

[...]


