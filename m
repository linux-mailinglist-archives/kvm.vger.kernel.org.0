Return-Path: <kvm+bounces-37481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CB14A2A826
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 13:13:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9F90D1887664
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2025 12:13:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3133D22D4C7;
	Thu,  6 Feb 2025 12:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GOhw5yQJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF00D15A848
	for <kvm@vger.kernel.org>; Thu,  6 Feb 2025 12:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738844002; cv=none; b=m7KNNLFQauwk3YV8tXr7KBlSxih2HEpYZINQ/lINW7z69CxOfJPNgts/CwELiHbPmN+yHKceVDbh/FPeX9KPPh4ddpM7flJHW6xk/mqp87ph2OusMSb73qppNY1i7QUxYS2kxnBcOAOIEjuDEDCAeU9YnNNMxEbzMI+oWCP1zP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738844002; c=relaxed/simple;
	bh=hDTXFSzPZFuDlHFd9Ob8Nf5fLzH4lL7tA1iWIGbnwGM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=o+XexmEhDsmg1LVP+eKvSLaHZhlk4TeDwwknaChDyQItEq6Wh92Cm3CjDx7FevuqG2SktXgC0EyZEGZFRQXNDKqzqgKbTthmTMla+AmaxXflglDz8EuUYf+Xxb/OLcerUluKlW3ULZ2yN05uyuKF/1m2QhT16XOwY+xbXlDQQRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GOhw5yQJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738843998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QbaGyGBhUSjBumJijeigRGmqZB/oIS5ICSFxiOZSqrQ=;
	b=GOhw5yQJDCqcQQDW8ktlGgEGAWuSnUnRHH9LCMO0ZWV02OQT9NM3MT5NqPQwN+jyYsQ6OI
	spYgWo8hijwLahAwHZCQNU14A+b0ltC5MV/mFAmc0rH5XtLhskgH86tBssonM3BRMSRgsw
	uLA/SBKuPD8a0ZJidNNGUKHEe+p/6KQ=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-tBgfEbVwPb-ADGZjCYreww-1; Thu,
 06 Feb 2025 07:13:14 -0500
X-MC-Unique: tBgfEbVwPb-ADGZjCYreww-1
X-Mimecast-MFC-AGG-ID: tBgfEbVwPb-ADGZjCYreww
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B60C1956096;
	Thu,  6 Feb 2025 12:13:11 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.40])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08A3119560A3;
	Thu,  6 Feb 2025 12:13:10 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id B11F921E6A28; Thu, 06 Feb 2025 13:13:07 +0100 (CET)
From: Markus Armbruster <armbru@redhat.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,  Eric Blake <eblake@redhat.com>,
  Michael Roth <michael.roth@amd.com>,  Daniel P . =?utf-8?Q?Berrang=C3=A9?=
 <berrange@redhat.com>,  Eduardo Habkost <eduardo@habkost.net>,  Marcelo
 Tosatti <mtosatti@redhat.com>,  Shaoqin Huang <shahuang@redhat.com>,  Eric
 Auger <eauger@redhat.com>,  Peter Maydell <peter.maydell@linaro.org>,
  Laurent Vivier <lvivier@redhat.com>,  Thomas Huth <thuth@redhat.com>,
  Sebastian Ott <sebott@redhat.com>,  Gavin Shan <gshan@redhat.com>,
  qemu-devel@nongnu.org,  kvm@vger.kernel.org,  qemu-arm@nongnu.org,
  Dapeng Mi <dapeng1.mi@intel.com>,  Yi Lai <yi1.lai@intel.com>
Subject: Re: [RFC v2 1/5] qapi/qom: Introduce kvm-pmu-filter object
In-Reply-To: <Z6SMxlWhHgronott@intel.com> (Zhao Liu's message of "Thu, 6 Feb
	2025 18:19:50 +0800")
References: <20250122090517.294083-1-zhao1.liu@intel.com>
	<20250122090517.294083-2-zhao1.liu@intel.com>
	<871pwc3dyw.fsf@pond.sub.org> <Z6SMxlWhHgronott@intel.com>
Date: Thu, 06 Feb 2025 13:13:07 +0100
Message-ID: <87h657p8z0.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

Zhao Liu <zhao1.liu@intel.com> writes:

> On Wed, Feb 05, 2025 at 11:03:51AM +0100, Markus Armbruster wrote:
>> Date: Wed, 05 Feb 2025 11:03:51 +0100
>> From: Markus Armbruster <armbru@redhat.com>
>> Subject: Re: [RFC v2 1/5] qapi/qom: Introduce kvm-pmu-filter object
>> 
>> Quick & superficial review for now.
>
> Thanks!
>
>> > diff --git a/qapi/kvm.json b/qapi/kvm.json
>> > new file mode 100644
>> > index 000000000000..d51aeeba7cd8
>> > --- /dev/null
>> > +++ b/qapi/kvm.json
>> > @@ -0,0 +1,116 @@
>> > +# -*- Mode: Python -*-
>> > +# vim: filetype=python
>> > +
>> > +##
>> > +# = KVM based feature API
>> 
>> This is a top-level section.  It ends up between sections "QMP
>> introspection" and "QEMU Object Model (QOM)".  Is this what we want?  Or
>> should it be a sub-section of something?  Or next to something else?
>
> Do you mean it's not in the right place in the qapi-schema.json?
>
> diff --git a/qapi/qapi-schema.json b/qapi/qapi-schema.json
> index b1581988e4eb..742818d16e45 100644
> --- a/qapi/qapi-schema.json
> +++ b/qapi/qapi-schema.json
> @@ -64,6 +64,7 @@
>  { 'include': 'compat.json' }
>  { 'include': 'control.json' }
>  { 'include': 'introspect.json' }
> +{ 'include': 'kvm.json' }
>  { 'include': 'qom.json' }
>  { 'include': 'qdev.json' }
>  { 'include': 'machine-common.json' }
>
> Because qom.json includes kvm.json, so I have to place it before
> qom.json.
>
> It doesn't have any dependencies itself, so placing it in the previous
> position should be fine, where do you prefer?

Let's ignore how to place it for now, and focus on where we would *like*
to place it.

Is it related to anything other than ObjectType / ObjectOptions in the
QMP reference manual?

I guess qapi/kvm.json is for KVM-specific stuff in general, not just the
KVM PMU filter.  Should we have a section for accelerator-specific
stuff, with subsections for the various accelerators?

[...]


