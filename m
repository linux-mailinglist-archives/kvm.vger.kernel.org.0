Return-Path: <kvm+bounces-52590-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9979B07067
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 10:23:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A7AB0580C7A
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 08:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA0A2EACF1;
	Wed, 16 Jul 2025 08:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="exXqPj6W"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB63F256C6D
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 08:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752654221; cv=none; b=j6Hm1bIQ1O0GhryrP0LWXA55MPHSmAD+aS59Ng5c8cMKfL+faPtzh5jddVYfQ7YXvX/NJgvPgGh+fL+aPqg9eXWL7k89LlHG03fmGHdQ6kLCO4fDsENI0dzVdX6vF6jahZBmMxBEJSh8ESmyIkJVEzOv/KrD5w+7q6p4K6/4qDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752654221; c=relaxed/simple;
	bh=paTfRGHkvf1SbD2JKx5jmgOaLo6grjWR4gpGzCvi9/Q=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=nMfi7S7TDYOmqEF2aEY1Xwjwao+yLYiv9bXcQCkHwQWGGPV02tH8uA1RbbjtuwQCGINbfZbq8K+lV7WA7HvYYWUIpmtAztWSO8XJWXB9P/L5W/182JphRMY9/ACvaAcm6DlvNOlxnc7VhMDpn+kUprU0XP8KEYIpWymrAv6KS/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=exXqPj6W; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752654215;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=STUiBIB+Th2T363ay6GOHVdT+QkghnT6vecX0DXWUeM=;
	b=exXqPj6Wy9JdyE02Sn9DMdT9J2DR76lV62Hav/curm/CDE44nOA8CKpJ3jZhFuhfdgRzfs
	/wgVukx0xolJfn+ZXOL9PCvdvSioGgKZkl1aPWeAqM8wwl3XUavcHTP6oNpM/E/SAi9Cjh
	weEO+mBPaKLZ1WfMVccUP/M4gBt4cVA=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-41NsQrsXNwWBG8ttagMCbg-1; Wed,
 16 Jul 2025 04:23:32 -0400
X-MC-Unique: 41NsQrsXNwWBG8ttagMCbg-1
X-Mimecast-MFC-AGG-ID: 41NsQrsXNwWBG8ttagMCbg_1752654210
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 23F491800366;
	Wed, 16 Jul 2025 08:23:30 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.6])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8355F1955F16;
	Wed, 16 Jul 2025 08:23:29 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id D3D1D21E6A27; Wed, 16 Jul 2025 10:23:26 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org,  Alex =?utf-8?Q?Benn=C3=A9e?=
 <alex.bennee@linaro.org>,  Paolo
 Bonzini <pbonzini@redhat.com>,  Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,  kvm@vger.kernel.org,  Richard Henderson
 <richard.henderson@linaro.org>,  Zhao Liu <zhao1.liu@intel.com>,  Eduardo
 Habkost <eduardo@habkost.net>,  Marcel Apfelbaum
 <marcel.apfelbaum@gmail.com>,  Yanan Wang <wangyanan55@huawei.com>,  Eric
 Blake <eblake@redhat.com>,  Michael Roth <michael.roth@amd.com>,  Daniel
 P. =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>
Subject: Re: [PATCH v5 28/69] qapi: Move definitions related to accelerators
 in their own file
In-Reply-To: <db0b2ce0-e702-4f32-b284-29cccc8d67ba@linaro.org> ("Philippe
	=?utf-8?Q?Mathieu-Daud=C3=A9=22's?= message of "Thu, 3 Jul 2025 18:42:06
 +0200")
References: <20250703105540.67664-1-philmd@linaro.org>
	<20250703105540.67664-29-philmd@linaro.org>
	<db0b2ce0-e702-4f32-b284-29cccc8d67ba@linaro.org>
Date: Wed, 16 Jul 2025 10:23:26 +0200
Message-ID: <877c08wnlt.fsf@pond.sub.org>
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

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> Hi Markus,

I missed this one, sorry!

> On 3/7/25 12:54, Philippe Mathieu-Daud=C3=A9 wrote:
>> Extract TCG and KVM definitions from machine.json to accelerator.json.
>> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
>> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
>> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

[...]

>> diff --git a/qapi/accelerator.json b/qapi/accelerator.json
>> new file mode 100644
>> index 00000000000..00d25427059
>> --- /dev/null
>> +++ b/qapi/accelerator.json
>> @@ -0,0 +1,57 @@
>> +# -*- Mode: Python -*-
>> +# vim: filetype=3Dpython
>> +#
>> +# SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +##
>> +# =3D Accelerators
>> +##
>> +
>> +{ 'include': 'common.json' }
>
> common.json defines @HumanReadableText, ...
>
> [...]
>
>> +##
>> +# @x-query-jit:
>> +#
>> +# Query TCG compiler statistics
>> +#
>> +# Features:
>> +#
>> +# @unstable: This command is meant for debugging.
>> +#
>> +# Returns: TCG compiler statistics
>> +#
>> +# Since: 6.2
>> +##
>> +{ 'command': 'x-query-jit',
>> +  'returns': 'HumanReadableText',
>> +  'if': 'CONFIG_TCG',
>
> ... which is *optionally* used here, triggering when
> TCG is not built in:
>
> qapi/qapi-commands-accelerator.c:85:13: error: =E2=80=98qmp_marshal_outpu=
t_HumanReadableText=E2=80=99 defined but not used [-Werror=3Dunused-functio=
n]
>    85 | static void qmp_marshal_output_HumanReadableText(HumanReadableTex=
t *ret_in,
>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> cc1: all warnings being treated as errors

This is a defect in the QAPI code generator.  More below.

> We previously discussed that issue:
> https://mail.gnu.org/archive/html/qemu-devel/2021-06/msg02667.html
>
> where you said:
>
> "conditional commands returning an unconditional type is a bit
> of a code smell". Is it however a "non-smelly instances of this pattern"?

The instance discussed there wasn't.

You ran into it when you made TPM commands conditional on CONFIG_TPM
without also making the types they return conditional.  The proper
solution was to make the types conditional, too.  Avoided generating
dead code.  I told you "The user is responsible for making T's 'if' the
conjunction of the commands'."

Some of the commands returning HumanReadableText are unconditional, so
said conjunction is also unconditional.  So how do we end up with unused
qmp_marshal_output_HumanReadableText()?

A qmp_marshal_output_T() is only ever called by qmp_marshal_C() for a
command C that returns T.

We've always generated it as a static function on demand, i.e. when we
generate a call.

Since we split up monolithic generated code into modules, we do this on
per module.  This can result in identical (static)
qmp_marshal_output_T() in several modules.  Fine, but we haven't
considered conditionals, yet.

As long as all functions returning T are in the same module, "making T's
'if' the conjunction of the commands'" works.  This is the case for the
TPM commands.

However, it need not work when the functions returning T are in multiple
modules.  For each module, we need the conjunction of that module's
commands' conditions.  We can't make it T's condition unless they are
all the same.  They aren't for HumanReadableText, as you found out.

I need to ponder this to decide on a solution.

Thanks!


