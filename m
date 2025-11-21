Return-Path: <kvm+bounces-64053-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B66F0C77632
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 06:35:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 805554E50F3
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 05:35:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 670B6246766;
	Fri, 21 Nov 2025 05:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MVSLoiog"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9AE61C5D59
	for <kvm@vger.kernel.org>; Fri, 21 Nov 2025 05:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763703320; cv=none; b=RBYu8IsZ0R8+XgRqritT3tCQw+tqTcQY5urS699HvlCa7UVMxBUAG0PwHTe5MLfdOW+GTcGOgA/RV37pP9j6Yz3CicAfHrV6sNYNdCTY5OILaRmQB7mUylDywq8PHWRILh5U6F/z2g/80Cq8D7nI+U/ShLQOjXQ1RRx4m6XJ4yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763703320; c=relaxed/simple;
	bh=5G5T7J74QSCyJ6nrufez9lpSKDScqOMgQYtebdrCVas=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=HMG5c+X6XKZN2E0/AIU8eTGJYI3jrX4QVck+8BAYtYweh1Yc0Q7RuCTnPp/SWLERHmbe4cqQrr1fMHb2nG7uYmyS3XMXk63esj9YnqzxKYsJhPAm2/GAAEl7JT0ynkxW/keVibQuR+PEgk5z0trZedkTlUS7NiYM5N2lCnAZ83o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MVSLoiog; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763703317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GjNOwtR9Z6IKyvsldJuL+qO2CUUAzUivSxONBT+whyk=;
	b=MVSLoiogcKMaOq3NdrlnXhaRCV5w3m2f1ZynG+TDuFam+b9hywQMKyQFE67DGrENd8aSpG
	vG1DBOgLlzbjHA4316TA9lTW4noHnkPvwGYgid6zAjKmzGCZPcP5vE+UyncZ+CQcvaYpPB
	5pvt20RdGPTewPSx5np2Z4U9sRICBNU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-YELbPn2YM7-MEnuiDffihA-1; Fri,
 21 Nov 2025 00:35:13 -0500
X-MC-Unique: YELbPn2YM7-MEnuiDffihA-1
X-Mimecast-MFC-AGG-ID: YELbPn2YM7-MEnuiDffihA_1763703309
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BD5B11956060;
	Fri, 21 Nov 2025 05:35:07 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 810F430044DB;
	Fri, 21 Nov 2025 05:35:05 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 0CA9D21E6A27; Fri, 21 Nov 2025 06:35:03 +0100 (CET)
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
Subject: Re: [PATCH 03/14] tap-solaris: Use error_setg_file_open() for
 better error messages
In-Reply-To: <aR-xJgDErvQaN600@gallifrey> (David Alan Gilbert's message of
	"Fri, 21 Nov 2025 00:24:06 +0000")
References: <20251120191339.756429-1-armbru@redhat.com>
	<20251120191339.756429-4-armbru@redhat.com>
	<aR-xJgDErvQaN600@gallifrey>
Date: Fri, 21 Nov 2025 06:35:03 +0100
Message-ID: <87wm3kq77c.fsf@pond.sub.org>
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
>> Error messages change from
>> 
>>     Can't open /dev/ip (actually /dev/udp)
>>     Can't open /dev/tap
>>     Can't open /dev/tap (2)
>> 
>> to
>> 
>>     Could not open '/dev/udp': REASON
>>     Could not open '/dev/tap': REASON
>> 
>> where REASON is the value of strerror(errno).
>
> I guess the new macro has a __LINE__ so the (2) is redundant.

It does capture __FILE__, __LINE__, and __func__, but they're only
printed for &error_abort.

How likely is it that the first open of /dev/tap succeeds, and the
second fails?

Do users users then need to know that the second failed?  If yes, then
" (2)" is a terrible way to tell them.

>> Signed-off-by: Markus Armbruster <armbru@redhat.com>
>
> Reviewed-by: Dr. David Alan Gilbert <dave@treblig.org>

Thanks!


