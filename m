Return-Path: <kvm+bounces-15519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D2AB8AD00E
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:01:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FD67281BCB
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:01:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DF17152194;
	Mon, 22 Apr 2024 15:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Unc1spcH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23C6136988
	for <kvm@vger.kernel.org>; Mon, 22 Apr 2024 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713798107; cv=none; b=JdHi23Xzm4x/5/vpsJiH3Q4pI0DKzUzge8IGMVo0/LDxQ/tAN5nDxtFU5PI3nj5e/UcyBgxVDsE9nsOsSY8GX0kXC3rVN9LYK5Bf1plwDn754Iz35GWbdIQJSf/u/vNtRCdeRn3vfDfPs/ScJtLfPdVnbOY7IwwhUaYDg3RDsjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713798107; c=relaxed/simple;
	bh=tXPS7BjFdfhYwIfTjyImTdbYhDGTSiKkLcEMO5YmpOk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=swCAMwbeceiZriljys632AeKu79/oZO30zjLqp2r/97MecpHe/GzBdqqGau2bR1IuoBTlEIHQPH2nfg5+YVpTW4HYRND6RUQYW9MiIAUCtIzryAnMM44hyRZWONOr/RGxVu/H+s2fvOvbs07oZwTKsa4Blu1fZj0Tr3lbrGMtBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Unc1spcH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713798104;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xxVhsEGm5iz8MRA6eQz0OUYX8Ub1fWixOcLGuqPi9rg=;
	b=Unc1spcHMEzDyDU3JQtRKWZAExPKa++wtES/+Wq5WPDtM0IGWTh5yQipPBTgR9r+hnImA8
	W4am9OmqnvI6bfT8HOwM8S0V/2sSIg9PrhJPvPqMW5fOnPsIIuYKjeN9yBHJLCRMjvt8Je
	/797+Rd8sGn1j7+/vq/onjs23wTMXrE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-287-XhS98-4PNAeRM3cQdYehEw-1; Mon, 22 Apr 2024 11:01:37 -0400
X-MC-Unique: XhS98-4PNAeRM3cQdYehEw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD0D69AADB7;
	Mon, 22 Apr 2024 15:01:36 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.247])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 9C1A7492BC6;
	Mon, 22 Apr 2024 15:01:36 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 8F7C221E66C8; Mon, 22 Apr 2024 17:01:35 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Michael Roth <michael.roth@amd.com>
Cc: <qemu-devel@nongnu.org>,  <kvm@vger.kernel.org>,  Tom Lendacky
 <thomas.lendacky@amd.com>,  "Paolo Bonzini" <pbonzini@redhat.com>,  Daniel
 P . =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  Pankaj Gupta
 <pankaj.gupta@amd.com>,
  Xiaoyao Li <xiaoyao.li@intel.com>,  Isaku Yamahata
 <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 31/49] i386/sev: Update query-sev QAPI format to
 handle SEV-SNP
In-Reply-To: <20240320083945.991426-32-michael.roth@amd.com> (Michael Roth's
	message of "Wed, 20 Mar 2024 03:39:27 -0500")
References: <20240320083945.991426-1-michael.roth@amd.com>
	<20240320083945.991426-32-michael.roth@amd.com>
Date: Mon, 22 Apr 2024 17:01:35 +0200
Message-ID: <87jzkpcugg.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

Michael Roth <michael.roth@amd.com> writes:

> Most of the current 'query-sev' command is relevant to both legacy
> SEV/SEV-ES guests and SEV-SNP guests, with 2 exceptions:
>
>   - 'policy' is a 64-bit field for SEV-SNP, not 32-bit, and
>     the meaning of the bit positions has changed
>   - 'handle' is not relevant to SEV-SNP
>
> To address this, this patch adds a new 'sev-type' field that can be
> used as a discriminator to select between SEV and SEV-SNP-specific
> fields/formats without breaking compatibility for existing management
> tools (so long as management tools that add support for launching
> SEV-SNP guest update their handling of query-sev appropriately).
>
> The corresponding HMP command has also been fixed up similarly.
>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  qapi/misc-target.json | 71 ++++++++++++++++++++++++++++++++++---------
>  target/i386/sev.c     | 50 ++++++++++++++++++++----------
>  target/i386/sev.h     |  3 ++
>  3 files changed, 94 insertions(+), 30 deletions(-)
>
> diff --git a/qapi/misc-target.json b/qapi/misc-target.json
> index 4e0a6492a9..daceb85d95 100644
> --- a/qapi/misc-target.json
> +++ b/qapi/misc-target.json
> @@ -47,6 +47,49 @@
>             'send-update', 'receive-update' ],
>    'if': 'TARGET_I386' }
>  
> +##
> +# @SevGuestType:
> +#
> +# An enumeration indicating the type of SEV guest being run.
> +#
> +# @sev:     The guest is a legacy SEV or SEV-ES guest.

Single space after ':', please.

Recommend a blank line between argument descriptions.

> +# @sev-snp: The guest is an SEV-SNP guest.
> +#
> +# Since: 6.2

The type is since 9.1, but its members become results of query-sev,
where they are since 2.12.  See also my reply to Daniel's question on
PATCH 21.

> +##
> +{ 'enum': 'SevGuestType',
> +  'data': [ 'sev', 'sev-snp' ],
> +  'if': 'TARGET_I386' }
> +
> +##
> +# @SevGuestInfo:
> +#
> +# Information specific to legacy SEV/SEV-ES guests.
> +#
> +# @policy: SEV policy value

I know you're just moving existing documentation.  Still: this is rather
sparse.  Where would I find what numbers to pass for @policy?

> +#
> +# @handle: SEV firmware handle
> +#
> +# Since: 2.12
> +##
> +{ 'struct': 'SevGuestInfo',
> +  'data': { 'policy': 'uint32',
> +            'handle': 'uint32' },
> +  'if': 'TARGET_I386' }
> +
> +##
> +# @SevSnpGuestInfo:
> +#
> +# Information specific to SEV-SNP guests.
> +#
> +# @snp-policy: SEV-SNP policy value

Same question.

> +#
> +# Since: 6.2

9.1

> +##
> +{ 'struct': 'SevSnpGuestInfo',
> +  'data': { 'snp-policy': 'uint64' },
> +  'if': 'TARGET_I386' }
> +
>  ##
>  # @SevInfo:
>  #
> @@ -60,25 +103,25 @@
>  #
>  # @build-id: SEV FW build id
>  #
> -# @policy: SEV policy value
> -#
>  # @state: SEV guest state
>  #
> -# @handle: SEV firmware handle
> +# @sev-type: Type of SEV guest being run
>  #
>  # Since: 2.12
>  ##
> -{ 'struct': 'SevInfo',
> -    'data': { 'enabled': 'bool',
> -              'api-major': 'uint8',
> -              'api-minor' : 'uint8',
> -              'build-id' : 'uint8',
> -              'policy' : 'uint32',
> -              'state' : 'SevState',
> -              'handle' : 'uint32'
> -            },
> -  'if': 'TARGET_I386'
> -}
> +{ 'union': 'SevInfo',
> +  'base': { 'enabled': 'bool',
> +            'api-major': 'uint8',
> +            'api-minor' : 'uint8',
> +            'build-id' : 'uint8',
> +            'state' : 'SevState',
> +            'sev-type' : 'SevGuestType' },
> +  'discriminator': 'sev-type',
> +  'data': {
> +      'sev': 'SevGuestInfo',
> +      'sev-snp': 'SevSnpGuestInfo' },
> +  'if': 'TARGET_I386' }
> +
>  
>  ##
>  # @query-sev:

[...]


