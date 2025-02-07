Return-Path: <kvm+bounces-37584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D5646A2C341
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 14:07:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 543C13A58B4
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 13:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1E1F1E5B7D;
	Fri,  7 Feb 2025 13:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VuB5lGEA"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD951E1A23
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 13:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738933603; cv=none; b=HykfLW/A+q7tjPFiS2o7blQ7ZwSgQnV2NzoJ+0qO6kT4cuplQIMwINqyixblBzuek63fw8NowCRJGpjYMB4Siul782FLsvaVOAhzWWNNLDrn17tb3F5Qoq5/Sw+0rYBHfd3jKP7iC+5PNuW2oCGB3Pp0P2H2TgbcWMWhVnB063M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738933603; c=relaxed/simple;
	bh=wt1SYB5V7DjmUIGircBEISdPspOuP76m0S0oGVJ7nlY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=TxAKQS4uMwDKjB4H0u872TRyjdVo79yLS1EGToyO+sHeVQmoCDoYqK5Pg8LRgfN2XL85hr8HL4TVKWJGiQ29M2ivnf7BchlWfTesFsqfZ/2oihkOtqvcMvx/DMDIjtu5GK3tZWzyHmNnflWRKa8Zhiv8F3vTTNvVerwMXWqzFp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VuB5lGEA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738933601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+/xEHSqNCYLGzlOdpZkl/FdgOJohjnC5Km7HHdqNE1U=;
	b=VuB5lGEA0FmmHomVuIrqL23vuCqLPmo76JP4jOkZqz5YDv/VBSlmhGQldlKLI9qCDJ4RqZ
	c2+y3jQ0mj368qZO4ZZeW7xohR5Q5QcNxk6amfDSBslb01cdE+brMNf7gV3fiCR6Xd2ZC1
	C+B4RTgIB9vgSXbEisnsP+z5XOknsyE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-XBNqVhAqOyyx6wCAtLvc5g-1; Fri,
 07 Feb 2025 08:06:37 -0500
X-MC-Unique: XBNqVhAqOyyx6wCAtLvc5g-1
X-Mimecast-MFC-AGG-ID: XBNqVhAqOyyx6wCAtLvc5g
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 772E71800871;
	Fri,  7 Feb 2025 13:06:35 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.26])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DAA241800360;
	Fri,  7 Feb 2025 13:06:34 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 6F65A21E6A28; Fri, 07 Feb 2025 14:06:32 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Daniel P. =?utf-8?Q?Berrang=EF=BF=BD?= <berrange@redhat.com>,  Paolo
 Bonzini
 <pbonzini@redhat.com>,  Eric Blake <eblake@redhat.com>,  Michael Roth
 <michael.roth@amd.com>,  Eduardo Habkost <eduardo@habkost.net>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  Shaoqin Huang <shahuang@redhat.com>,  Eric
 Auger <eauger@redhat.com>,  Peter Maydell <peter.maydell@linaro.org>,
  Laurent Vivier <lvivier@redhat.com>,  Thomas Huth <thuth@redhat.com>,
  Sebastian Ott <sebott@redhat.com>,  Gavin Shan <gshan@redhat.com>,
  qemu-devel@nongnu.org,  kvm@vger.kernel.org,  qemu-arm@nongnu.org,
  Dapeng Mi <dapeng1.mi@intel.com>,  Yi Lai <yi1.lai@intel.com>
Subject: Re: [RFC v2 3/5] i386/kvm: Support event with select & umask format
 in KVM PMU filter
In-Reply-To: <Z6TNMZbonWmsnyM7@intel.com> (Zhao Liu's message of "Thu, 6 Feb
	2025 22:54:41 +0800")
References: <20250122090517.294083-1-zhao1.liu@intel.com>
	<20250122090517.294083-4-zhao1.liu@intel.com>
	<87zfj01z8x.fsf@pond.sub.org> <Z6SG2NLxxhz4adlV@intel.com>
	<Z6SEIqhJEWrMWTU1@redhat.com> <878qqjqskm.fsf@pond.sub.org>
	<Z6TFr49Cnhe1s4/5@intel.com> <Z6TNMZbonWmsnyM7@intel.com>
Date: Fri, 07 Feb 2025 14:06:32 +0100
Message-ID: <87o6zdhpk7.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Zhao Liu <zhao1.liu@intel.com> writes:

>> > Do users need to know how to compute the raw event value from @select
>> > and @umask?
>> 
>> Yes, because it's also a unified calculation. AMD and Intel have
>> differences in bits for supported select field, but this calculation
>> (which follows from the KVM code) makes both compatible.
>> 
>> > If yes, is C code the best way?
>
> Sorry, I missed this line. In this patch, there's macro:
>
> +#define X86_PMU_RAW_EVENT(eventsel, umask) (((eventsel & 0xf00UL) << 24) | \
> +                                            ((eventsel) & 0xff) | \
> +                                            ((umask) & 0xff) << 8)
>
> So could I said something like the following?
>
> +##
> +# @KVMPMUX86SelectUmaskEvent:
> +#
> +# x86 PMU event encoding with select and umask.  Using the X86_PMU_RAW_EVENT
> +# macro, the select and umask fields will be encoded into raw foramt and
> +# delivered to KVM.

Doc comments are for the QMP reference manual, i.e. for users of QMP.
Explaining the QMP interface in terms of its implementation in QEMU is
not nice.

> +#
> +# @select: x86 PMU event select field, which is a 12-bit unsigned
> +#     number.
> +#
> +# @umask: x86 PMU event umask field.
> +#
> +# Since 10.0
> +##
> +{ 'struct': 'KVMPMUX86DefalutEvent',
> +  'data': { 'select': 'uint16',
> +            'umask': 'uint8' } }
> +
>
> Thanks very much!
>
>> > Here's another way:
>> > 
>> >     bits  0..7 : bits 0..7 of @select
>> >     bits  8..15: @umask
>> >     bits 24..27: bits 8..11 of @select
>> >     all other bits: zero
>> >
>> 
>> Thank you! This is what I want.
>> 
>> 
>> 


