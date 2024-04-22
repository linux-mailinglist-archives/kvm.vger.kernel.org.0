Return-Path: <kvm+bounces-15522-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A243A8AD021
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DD5C286536
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:03:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C7F2152503;
	Mon, 22 Apr 2024 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LtLNvHnV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFA9152184
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 15:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713798214; cv=none; b=KfjOSWdZPA9bjzxyiVvBkKySzdbdvCDnOrkwyqfeQ0MCgXA1Zpb2joivwYj7vQtpOTRvd4XpQFvROlrR6vrHjarBd0f6uBw3+UO1g4/9X3h86WkeFx91CQhXvINr7hVyYmLEg6W9L/KbTY2L5hhaYc6zKQV928cLqYlv31/Bt/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713798214; c=relaxed/simple;
	bh=SFczTtkLN9u6FwwaTWRYnTEFC4jtIZ3V75ELO2p/YFQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=eUxeoFzn9yIAlvoyGnip8PbzuZq2TZnmlImDHq8X4XCK/64CPGR6xZ/cMAiDpPYgnyzl6kXYeuo4YIBx30NPqqDpj+sn7aYwDf6FZnYL1457cv5gX3Y+hR4No5p90L6PG5ORYjfABmnTH8onBJP67vStQjkINNkt9Igr3IlLyws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LtLNvHnV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713798208;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EdDc6WXJuq/j61tE7mxWaOSVj7MV2NeZEPjXCUBwqgo=;
	b=LtLNvHnVeSTqk4ZUXL5//jIhSf7MACLrjLdji9+8IG89byOlgKjoWmT/iHWCaMdkC4gqOf
	Wk6XdQPcMe5/Ub9tgvq8Ez3k38oioonn9GMiKaaEQ4zhOYb78Zl2jw7wqq2Rd5Cr2Z2t3I
	7Vdp8zD/6CEYu08nwE55z5xHXP+6zPc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-rK0zSUoONgOEBjPZ-9xkJQ-1; Mon, 22 Apr 2024 11:03:22 -0400
X-MC-Unique: rK0zSUoONgOEBjPZ-9xkJQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25B62811008;
	Mon, 22 Apr 2024 15:03:22 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.247])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 01B1D2166B32;
	Mon, 22 Apr 2024 15:03:22 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 151A921E66C8; Mon, 22 Apr 2024 17:03:21 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>,  qemu-devel@nongnu.org,
  kvm@vger.kernel.org,  Tom Lendacky <thomas.lendacky@amd.com>,  Paolo
 Bonzini <pbonzini@redhat.com>,  Pankaj Gupta <pankaj.gupta@amd.com>,
  Xiaoyao Li <xiaoyao.li@intel.com>,  Isaku Yamahata
 <isaku.yamahata@linux.intel.com>,  Dov Murik <dovmurik@linux.ibm.com>
Subject: Re: [PATCH v3 43/49] qapi, i386: Move kernel-hashes to
 SevCommonProperties
In-Reply-To: <ZfrUiBlbEVHkMYl0@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Wed, 20 Mar 2024 12:20:24 +0000")
References: <20240320083945.991426-1-michael.roth@amd.com>
	<20240320083945.991426-44-michael.roth@amd.com>
	<ZfrUiBlbEVHkMYl0@redhat.com>
Date: Mon, 22 Apr 2024 17:03:21 +0200
Message-ID: <87bk61cudi.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Wed, Mar 20, 2024 at 03:39:39AM -0500, Michael Roth wrote:
>> From: Dov Murik <dovmurik@linux.ibm.com>
>>=20
>> In order to enable kernel-hashes for SNP, pull it from
>> SevGuestProperties to its parent SevCommonProperties so
>> it will be available for both SEV and SNP.
>>=20
>> Signed-off-by: Dov Murik <dovmurik@linux.ibm.com>
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>  qapi/qom.json     | 14 +++++++-------
>>  target/i386/sev.c | 44 ++++++++++++++++++--------------------------
>>  2 files changed, 25 insertions(+), 33 deletions(-)
>
> This change ought to be squashed into the earlier patch
> that introduce sev-guest-common.

Concur.

[...]


