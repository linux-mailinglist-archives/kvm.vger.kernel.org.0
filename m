Return-Path: <kvm+bounces-67545-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 029D6D08347
	for <lists+kvm@lfdr.de>; Fri, 09 Jan 2026 10:31:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 298823009D4A
	for <lists+kvm@lfdr.de>; Fri,  9 Jan 2026 09:30:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5307333343B;
	Fri,  9 Jan 2026 09:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FYzA3kaG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1808B33342E
	for <kvm@vger.kernel.org>; Fri,  9 Jan 2026 09:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767951040; cv=none; b=P/w0c/IGMYTkyQ1mHd0658Fo03RiTKX60YwtVii48pyZH2OddKJamIyTfNtf9IS1ciVltz78e4w23Xn0JyeVmROu45jc6cmLv040lJq62y2qttwYahgf91znXU+NtiAAkZtAMhIXB4avlnfaEJVeUNi5TZSGBvirolTRSsNkAQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767951040; c=relaxed/simple;
	bh=acGHAcnZUW4m9odBwGNh6YL+7WiXTybNJUrb/Iy6fl0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Wh/CM21Cjoi/ZCgua7IjnfB//hDlqsHC+aSteQPmsVU7klosXVrD6p1LIscEgo78LvDp8/xLCVNdOZkBl2Qc4ESukZtgWq7I3G+carUZohZl/+5fzIOUx26FwcCPj/YHebV2LiwSJLjRvwGPnnvy4Wzh0dvfzYOX7NuYqxLQr4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FYzA3kaG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767951037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7D3wJsRoUQFpkz+nwVP/SWQLABnNWT7fTShKxG/tM6M=;
	b=FYzA3kaGS+e9MsuoDS65uavIDrH0ekqccf2oDxFWIAKeZva1CDcKBeMP0fHlRmZbMAXzAt
	S0eG7NkZ7uaHFtDUBH3J+VGxZlvvstHZH5kZpEYw2bMSR8coVAguY64/itIR8fEOaGdOcF
	MkhSIYFM4IZUZgW21bw1QPfPjBtuE/w=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-252-tATHLlWJN2WRLHu6i0VSig-1; Fri,
 09 Jan 2026 04:30:36 -0500
X-MC-Unique: tATHLlWJN2WRLHu6i0VSig-1
X-Mimecast-MFC-AGG-ID: tATHLlWJN2WRLHu6i0VSig_1767951036
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D00B41956094;
	Fri,  9 Jan 2026 09:30:35 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.32])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8CB231956048;
	Fri,  9 Jan 2026 09:30:35 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id EC19921E66C1; Fri, 09 Jan 2026 10:30:32 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: marcandre.lureau@redhat.com,  qemu-devel@nongnu.org,  Eric Blake
 <eblake@redhat.com>,  Paolo Bonzini <pbonzini@redhat.com>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  "open list:X86 KVM CPUs"
 <kvm@vger.kernel.org>
Subject: Re: [PATCH] Add query-tdx-capabilities
In-Reply-To: <aV41CQP0JODTdRqy@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Wed, 7 Jan 2026 10:27:21 +0000")
References: <20260106183620.2144309-1-marcandre.lureau@redhat.com>
	<aV41CQP0JODTdRqy@redhat.com>
Date: Fri, 09 Jan 2026 10:30:32 +0100
Message-ID: <87qzrzku9z.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Tue, Jan 06, 2026 at 10:36:20PM +0400, marcandre.lureau@redhat.com wro=
te:
>> From: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
>>=20
>> Return an empty TdxCapability struct, for extensibility and matching
>> query-sev-capabilities return type.
>>=20
>> Fixes: https://issues.redhat.com/browse/RHEL-129674
>> Signed-off-by: Marc-Andr=C3=A9 Lureau <marcandre.lureau@redhat.com>
>> ---
>>  qapi/misc-i386.json        | 30 ++++++++++++++++++++++++++++++
>>  target/i386/kvm/kvm_i386.h |  1 +
>>  target/i386/kvm/kvm.c      |  5 +++++
>>  target/i386/kvm/tdx-stub.c |  8 ++++++++
>>  target/i386/kvm/tdx.c      | 21 +++++++++++++++++++++
>>  5 files changed, 65 insertions(+)
>>=20
>> diff --git a/qapi/misc-i386.json b/qapi/misc-i386.json
>> index 05a94d6c416..f10e4338b48 100644
>> --- a/qapi/misc-i386.json
>> +++ b/qapi/misc-i386.json
>> @@ -225,6 +225,36 @@
>>  ##
>>  { 'command': 'query-sev-capabilities', 'returns': 'SevCapability' }
>>=20=20
>> +##
>> +# @TdxCapability:
>> +#
>> +# The struct describes capability for Intel Trust Domain Extensions
>> +# (TDX) feature.
>> +#
>> +# Since: 11.0
>> +##
>> +{ 'struct': 'TdxCapability',
>> +  'data': { } }
>> +
>> +##
>> +# @query-tdx-capabilities:
>> +#
>> +# Get TDX capabilities.
>> +#
>> +# This is only supported on Intel X86 platforms with KVM enabled.
>> +#
>> +# Errors:
>> +#     - If TDX is not available on the platform, GenericError
>> +#
>> +# Since: 11.0
>> +#
>> +# .. qmp-example::
>> +#
>> +#     -> { "execute": "query-tdx-capabilities" }
>> +#     <- { "return": {} }
>> +##
>> +{ 'command': 'query-tdx-capabilities', 'returns': 'TdxCapability' }
>
> This matches the conceptual design used with query-sev-capabilities,
> where the lack of SEV support has to be inferred from the command
> returning "GenericError".

Such guesswork is brittle.  An interface requiring it is flawed, and
should be improved.

Our SEV interface doesn't actually require it: query-sev tells you
whether we have SEV.  Just run that first.

This patch adds query-tdx-capabilities without query-tdx.  This results
in a flawed interface.

Should we add a query-tdx instead?

>                           On the one hand this allows the caller to
> distinguish different scenarios - unsupported due to lack of HW
> support, vs unsupported due to lack of KVM support. On the other
> hand 'GenericError' might reflect other things that should be
> considered fatal errors, rather than indicitive of lack of support
> in the host.
>
> With the other 'query-sev' command, we have "enabled: bool" field,
> and when enabled =3D=3D false, the other fields are documented to have
> undefined values.

Clunky, but works.

The doc comment calls them "unspecified", which is more precise.

> I tend towards suggesting that 'query-sev-capabilities' (and thus
> also this new query-tdx-capabilities) should have been more like
> query-sev,  and had a a "supported: bool" field to denote the lack
> of support in the host.

Maybe.  What we have there is workable, though.

> This would not have allowed callers to disinguish the reason why
> SEV/TDX is not supported (hardware vs KVM), but I'm not sure that
> reason matters for callers - lack of KVM support is more of an
> OS integration problem.

Let's not complicate interfaces without an actual use case :)

[...]


