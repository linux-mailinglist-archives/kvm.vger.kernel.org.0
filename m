Return-Path: <kvm+bounces-52601-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 953C2B07190
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 11:24:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97397500BBD
	for <lists+kvm@lfdr.de>; Wed, 16 Jul 2025 09:24:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 402812EFDBE;
	Wed, 16 Jul 2025 09:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g0yAhDMP"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4A52857C9
	for <kvm@vger.kernel.org>; Wed, 16 Jul 2025 09:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752657876; cv=none; b=AQFYHx0KtyF8upFelXr1FxqX/B/dD06fA/2fJ+IsCzyqA73JTI5VvMZqhBa9WdS/56IRKIlZ6AR7QEYrCaf3CxwGqW8X5XCumdENcH2Hh08o9d6QQi/LbJPAoaAgg8gguYiVBU2/FPCP1Kd9RLrr2pFPIfnrgTK2Fo2OoHPN8hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752657876; c=relaxed/simple;
	bh=/t0v5Ng4w7o9mBT+MF2siICCn+4HZjgG5VkDiCJ1Ghk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BqVbhj6pmzk1ZdGM+eNW2QzIJ5Cj9U3U0S1W4sdT3VW8a5TkOcA5Bpsm4jBj2T5wYK/5dE4j1ahjUQvLQW0GDKvNWivJoqi0NDFvEFlqQ5Lff77eEucJFq/tvjolqTqQwfvgmGvzSvDqbEafokCZiE3wpHPAU1Aud28P1l+Fe0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=g0yAhDMP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752657871;
	h=from:from:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cWNQdSEpfaOY2a4nUWkKCi7tzS/2GKrr+dfvj8bLCno=;
	b=g0yAhDMPAScjyVkCO+dAny2080ELPUAVeE++LE/MCgNDXGbYOCRyTHAT/V/G+a+QkM9o6b
	F1y6TG4q2VQt6IPyDvWfF/i/cnAyYPuZ4Zx0pmq18J4XfkKlO7Yu3vOpRL5I9iQSuR9mW2
	dsAINUO6wEWFPA5GpHOtjMa3f9Zxvqc=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-519-4ff33AIpOnqdepdhKsfFUQ-1; Wed,
 16 Jul 2025 05:24:27 -0400
X-MC-Unique: 4ff33AIpOnqdepdhKsfFUQ-1
X-Mimecast-MFC-AGG-ID: 4ff33AIpOnqdepdhKsfFUQ_1752657866
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CC251956095;
	Wed, 16 Jul 2025 09:24:25 +0000 (UTC)
Received: from redhat.com (unknown [10.42.28.68])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1B11830001A2;
	Wed, 16 Jul 2025 09:24:20 +0000 (UTC)
Date: Wed, 16 Jul 2025 10:24:17 +0100
From: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
To: Markus Armbruster <armbru@redhat.com>
Cc: Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	qemu-devel@nongnu.org,
	Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>, kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>, Eric Blake <eblake@redhat.com>,
	Michael Roth <michael.roth@amd.com>
Subject: Re: [PATCH v5 28/69] qapi: Move definitions related to accelerators
 in their own file
Message-ID: <aHdvwYM7kXBU4cji@redhat.com>
Reply-To: Daniel =?utf-8?B?UC4gQmVycmFuZ8Op?= <berrange@redhat.com>
References: <20250703105540.67664-1-philmd@linaro.org>
 <20250703105540.67664-29-philmd@linaro.org>
 <db0b2ce0-e702-4f32-b284-29cccc8d67ba@linaro.org>
 <877c08wnlt.fsf@pond.sub.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <877c08wnlt.fsf@pond.sub.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Wed, Jul 16, 2025 at 10:23:26AM +0200, Markus Armbruster wrote:
> Philippe Mathieu-Daudé <philmd@linaro.org> writes:
> 
> > Hi Markus,
> 
> I missed this one, sorry!
> 
> > On 3/7/25 12:54, Philippe Mathieu-Daudé wrote:
> >> Extract TCG and KVM definitions from machine.json to accelerator.json.
> >> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> >> Reviewed-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
> >> Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
> 
> [...]
> 
> >> diff --git a/qapi/accelerator.json b/qapi/accelerator.json
> >> new file mode 100644
> >> index 00000000000..00d25427059
> >> --- /dev/null
> >> +++ b/qapi/accelerator.json
> >> @@ -0,0 +1,57 @@
> >> +# -*- Mode: Python -*-
> >> +# vim: filetype=python
> >> +#
> >> +# SPDX-License-Identifier: GPL-2.0-or-later
> >> +
> >> +##
> >> +# = Accelerators
> >> +##
> >> +
> >> +{ 'include': 'common.json' }
> >
> > common.json defines @HumanReadableText, ...
> >
> > [...]
> >
> >> +##
> >> +# @x-query-jit:
> >> +#
> >> +# Query TCG compiler statistics
> >> +#
> >> +# Features:
> >> +#
> >> +# @unstable: This command is meant for debugging.
> >> +#
> >> +# Returns: TCG compiler statistics
> >> +#
> >> +# Since: 6.2
> >> +##
> >> +{ 'command': 'x-query-jit',
> >> +  'returns': 'HumanReadableText',
> >> +  'if': 'CONFIG_TCG',
> >
> > ... which is *optionally* used here, triggering when
> > TCG is not built in:
> >
> > qapi/qapi-commands-accelerator.c:85:13: error: ‘qmp_marshal_output_HumanReadableText’ defined but not used [-Werror=unused-function]
> >    85 | static void qmp_marshal_output_HumanReadableText(HumanReadableText *ret_in,
> >       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > cc1: all warnings being treated as errors
> 
> This is a defect in the QAPI code generator.  More below.
> 
> > We previously discussed that issue:
> > https://mail.gnu.org/archive/html/qemu-devel/2021-06/msg02667.html
> >
> > where you said:
> >
> > "conditional commands returning an unconditional type is a bit
> > of a code smell". Is it however a "non-smelly instances of this pattern"?
> 
> The instance discussed there wasn't.
> 
> You ran into it when you made TPM commands conditional on CONFIG_TPM
> without also making the types they return conditional.  The proper
> solution was to make the types conditional, too.  Avoided generating
> dead code.  I told you "The user is responsible for making T's 'if' the
> conjunction of the commands'."
> 
> Some of the commands returning HumanReadableText are unconditional, so
> said conjunction is also unconditional.  So how do we end up with unused
> qmp_marshal_output_HumanReadableText()?
> 
> A qmp_marshal_output_T() is only ever called by qmp_marshal_C() for a
> command C that returns T.
> 
> We've always generated it as a static function on demand, i.e. when we
> generate a call.

..snip..

> I need to ponder this to decide on a solution.

Functionally the redundat function is harmless, so the least effort
option is to change the generated QAPI headers to look like

  #pragma GCC diagnostic push
  #pragma GCC ignored "-Wunused-function"

  ... rest of QAPI header...

  #pragma GCC diagnostic pop

With regards,
Daniel
-- 
|: https://berrange.com      -o-    https://www.flickr.com/photos/dberrange :|
|: https://libvirt.org         -o-            https://fstop138.berrange.com :|
|: https://entangle-photo.org    -o-    https://www.instagram.com/dberrange :|


