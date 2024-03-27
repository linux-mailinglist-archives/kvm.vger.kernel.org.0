Return-Path: <kvm+bounces-12875-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9067188E8F5
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 16:27:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4CC09307E03
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 15:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE21812F38B;
	Wed, 27 Mar 2024 15:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SasH/zYe"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 351CD1400D
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 15:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711552953; cv=none; b=F1VOjaL9htg8T6BkWs1skYppmSaGBmW8sxq9NwR9tE6UOI1Vu+9Zqcuf3Ma3r9WwC6NKpTqt7PxsMNjBSkhpeTsTRnGi2SYOgVg7NV80fFEuJJWmm9Wei8H6pyukwcx8GGxYbf6qS0/virP7jcWiDQkvPmOmDT1ucnBoqjyWFqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711552953; c=relaxed/simple;
	bh=luLU+8FApFwQg47JX1HC7wio4pkbdPW/FNecmv1VkK4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=SQsF8jc0BwM5iqQwQPSHLuDR+0KIaFCoi5itjGc26zyMPWAujq6VFIdL5G11o2qrWLDiKlVJW62btOtnN2cKqDNd8zQn4+Lalv6r+jTSTq+vCOzwJJu0CxgYTrfMTFKV0bM8gBLD0UDxTKRIRfpZQid0THeDUHUrKypIwk7cpcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SasH/zYe; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711552951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TKHBlePX4k/2OLlFq3bcKjGQhaDBP7mP8uLkw/9KFoM=;
	b=SasH/zYeMtroe1yXnuu+DOOWk7TZkOMnwdUdBUMvSGcq4FVEg0yp4KF16F/gFYUhFYao+H
	kRFaG66vhLYZsb5Z5Px23qcn4d87q8z82I33cWOaCKy+hWzxUiIp0v5Cc6JpCDMP4VJq1H
	AuVKuE0SBgj3YVZ9sf2weNAjww3n0tA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-568-U8EEQHf6Of6yEiVosqE-cQ-1; Wed, 27 Mar 2024 11:22:27 -0400
X-MC-Unique: U8EEQHf6Of6yEiVosqE-cQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6F30D10189AB;
	Wed, 27 Mar 2024 15:22:27 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.81])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F49440C6CBB;
	Wed, 27 Mar 2024 15:22:27 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 2102021E669D; Wed, 27 Mar 2024 16:22:06 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Daniel P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Cc: Michael Roth <michael.roth@amd.com>,  qemu-devel@nongnu.org,
  kvm@vger.kernel.org,  Tom Lendacky <thomas.lendacky@amd.com>,  Paolo
 Bonzini <pbonzini@redhat.com>,  Pankaj Gupta <pankaj.gupta@amd.com>,
  Xiaoyao Li <xiaoyao.li@intel.com>,  Isaku Yamahata
 <isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v3 21/49] i386/sev: Introduce "sev-common" type to
 encapsulate common SEV state
In-Reply-To: <ZfrMDYk-gSQF04gQ@redhat.com> ("Daniel P. =?utf-8?Q?Berrang?=
 =?utf-8?Q?=C3=A9=22's?= message of
	"Wed, 20 Mar 2024 11:44:13 +0000")
References: <20240320083945.991426-1-michael.roth@amd.com>
	<20240320083945.991426-22-michael.roth@amd.com>
	<ZfrMDYk-gSQF04gQ@redhat.com>
Date: Wed, 27 Mar 2024 16:22:06 +0100
Message-ID: <87h6gritsx.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Daniel P. Berrang=C3=A9 <berrange@redhat.com> writes:

> On Wed, Mar 20, 2024 at 03:39:17AM -0500, Michael Roth wrote:
>> Currently all SEV/SEV-ES functionality is managed through a single
>> 'sev-guest' QOM type. With upcoming support for SEV-SNP, taking this
>> same approach won't work well since some of the properties/state
>> managed by 'sev-guest' is not applicable to SEV-SNP, which will instead
>> rely on a new QOM type with its own set of properties/state.
>>=20
>> To prepare for this, this patch moves common state into an abstract
>> 'sev-common' parent type to encapsulate properties/state that are
>> common to both SEV/SEV-ES and SEV-SNP, leaving only SEV/SEV-ES-specific
>> properties/state in the current 'sev-guest' type. This should not
>> affect current behavior or command-line options.
>>=20
>> As part of this patch, some related changes are also made:
>>=20
>>   - a static 'sev_guest' variable is currently used to keep track of
>>     the 'sev-guest' instance. SEV-SNP would similarly introduce an
>>     'sev_snp_guest' static variable. But these instances are now
>>     available via qdev_get_machine()->cgs, so switch to using that
>>     instead and drop the static variable.
>>=20
>>   - 'sev_guest' is currently used as the name for the static variable
>>     holding a pointer to the 'sev-guest' instance. Re-purpose the name
>>     as a local variable referring the 'sev-guest' instance, and use
>>     that consistently throughout the code so it can be easily
>>     distinguished from sev-common/sev-snp-guest instances.
>>=20
>>   - 'sev' is generally used as the name for local variables holding a
>>     pointer to the 'sev-guest' instance. In cases where that now points
>>     to common state, use the name 'sev_common'; in cases where that now
>>     points to state specific to 'sev-guest' instance, use the name
>>     'sev_guest'
>>=20
>> Signed-off-by: Michael Roth <michael.roth@amd.com>
>> ---
>>  qapi/qom.json     |  32 ++--
>>  target/i386/sev.c | 457 ++++++++++++++++++++++++++--------------------
>>  target/i386/sev.h |   3 +
>>  3 files changed, 281 insertions(+), 211 deletions(-)
>>=20
>> diff --git a/qapi/qom.json b/qapi/qom.json
>> index baae3a183f..66b5781ca6 100644
>> --- a/qapi/qom.json
>> +++ b/qapi/qom.json
>> @@ -875,12 +875,29 @@
>>    'data': { '*filename': 'str' } }
>>=20=20
>>  ##
>> -# @SevGuestProperties:
>> +# @SevCommonProperties:
>>  #
>> -# Properties for sev-guest objects.
>> +# Properties common to objects that are derivatives of sev-common.
>>  #
>>  # @sev-device: SEV device to use (default: "/dev/sev")
>>  #
>> +# @cbitpos: C-bit location in page table entry (default: 0)
>> +#
>> +# @reduced-phys-bits: number of bits in physical addresses that become
>> +#     unavailable when SEV is enabled
>> +#
>> +# Since: 2.12
>
> Not quite sure what we've done in this scenario before.
> It feels wierd to use '2.12' for the new base type, even
> though in effect the properties all existed since 2.12 in
> the sub-class.
>
> Perhaps 'Since: 9.1' for the type, but 'Since: 2.12' for the
> properties, along with an explanatory comment about stuff
> moving into the new base type ?
>
> Markus, opinions ?

The confusion is due to us documenting the schema instead of the
external interface defined by it.  Let me explain.

The external interface is commands and their arguments, ignoring
results, errors and events for brevity's sake.

We use types to define the arguments.  How exactly we use types is not
part of the interface.  This permits refactorings.  However, since the
documentation is attached to the types, refactorings can easily mess it
up.

I'd like to demonstrate this for a simpler command first, then return to
object-add.

Consider nbd-server-add.  It is documented to be since 1.3.

From now on, I'm abbreviating "documented to be since X.Y" to "since
X.Y".

Its arguments are the members of struct NbdServerAddOptions.

NbdServerAddOptions is since 5.0.  Its base BlockExportOptionsNbdBase is
since 5.2.

BlockExportOptionsNbdBase member @name is since 2.12, and @description
is since 5.0.

NbdServerAddOptions member @bitmap is since 4.0.  Members @device and
@writable have no "since" documented, so they inherit it from the
struct, i.e. 5.0.

So, it looks like the command is since 1.3, argument @name since 2.12,
@bitmap since 4.0, @description, @device, and @writable since 5.0.

Wrong!  Arguments @device and @writable have always been there,
i.e. since 1.3.  We ended up with documentation incorrectly claiming 5.0
via several refactorings.

Initially, the command arguments were defined right with the command.
They simply inherited the command's since 1.3.

Commit c62d24e906e (blockdev-nbd: Boxed argument type for
nbd-server-add) moved them to a struct type BlockExportNbd.  The new
struct type was since 5.0.  Newer arguments retained their "since" tags,
but the initial arguments @device and @writable remained without one.
Their documented "since" changed from 1.3 to 5.0.

Aside: the new struct was then used as a branch of union BlockExport,
which was incorrectly documented to be since 4.2.

Messing up "since" when factoring out arguments into a new type was
avoidable: either lie and claim the new type is as old as its members,
or add suitable since tags to its members.

Having a struct with members older than itself looks weird.  Of course,
when a struct came to be is *immaterial*.  How exactly we assemble the
arguments from types is not part of the interface.  We could omit
"since" for the struct, and then require it for all members.  We don't,
because having to think (and then argue!) whether we want a "since" or
not would be a waste of mental capacity.

Here's another refactoring where that may not be possible.  Say you
discover two structs share several members.  You decide to factor them
out into a common base type.  Won't affect the external interface.  But
what if one of these common members has conflicting "since"?  Either we
refrain from the refactoring, or we resort to something like "since
X1.Y1 when used for USER1, since X1.Y2 when used for USER2".  Which
*sucks* as external interface documentation.

Aside: documentation text could clash similarly.  Same code, different
meaning.

I've come to the conclusion that manually recording "since" in the
documentation is dumb.  One, because we mess it up.  Two, because not
messing it up involves either lies or oddities, or too much thought.
Three, because keeping it correct can interfere with refactorings.

Some time ago, Michael Tsirkin suggested to generate "since" information
automatically.  I like the idea.  We'd have to record the external
interface at release time.  To fully replace existing "since" tags, we'd
have to record for old versions, too.  I'd expect this to fix quite a
few doc bugs.

I hope "The confusion is due to us documenting the schema instead of the
external interface defined by it" is now more clear.  The external
interface is derived from the types.  How exactly we construct it from
types is invisible at the interface.  But since we document the
interface by documenting the types, the structure of our interface
documentation mirrors our use of types.  We succeed at shielding the
interface from how we use types, but we fail to shield the
documentation.

Back to your problem at hand.  The external interface is command
object-add.  The command is since 2.0.

It has common arguments and variant arguments depending on the value of
common argument @type.  We specify all that via union ObjectOptions, and
the variant arguments for @type value "sev-guest" via struct
SevGuestProperties.

Union ObjectOptions is since 6.0, but that's immaterial; the type isn't
part of the external interface, only its members are.

Its members are the common arguments.  Since they don't have their own
"since" tag, they inherit it from ObjectOptions, i.e. since 6.0.  That's
simply wrong; they exist since 2.0 just like object-add.

Struct SevGuestProperties is since 2.12, but that's also immaterial.

The members of SevGuestProperties are the variant arguments for @type
value "sev-guest".  Since they don't have their own "since" tag, they
inherit it from SevGuestProperties, i.e. since 2.12.

Your patch moves some of the members to new base type
SevCommonProperties.  As Daniel observed, you can either claim
SevCommonProperties is since 2.12 (which is a lie), or you claim 9.1 for
the type and 2.12 for all its members (which is odd).

I prefer oddities to lies.

I'm not sure we need a comment explaining the oddity.  If you think it's
useful, please make it a non-doc comment.  Reminder:

    ##
    # This is a doc comment.  It goes into generated documentation.
    ##

    # This is is not a doc comment.  It does not go into generated
    # documentation.

Comments?

[...]


