Return-Path: <kvm+bounces-42884-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B3DACA7F46B
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 07:51:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2FF6B3A9191
	for <lists+kvm@lfdr.de>; Tue,  8 Apr 2025 05:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00D1D253F22;
	Tue,  8 Apr 2025 05:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EjFi+V9E"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131622063FA
	for <kvm@vger.kernel.org>; Tue,  8 Apr 2025 05:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744091486; cv=none; b=cEA2M7T2wpCXHPfqShrtTNMiQCmqJalaebc0nSL18gtPQv+4ckCxeWh98dF8KP7ipWu8gTguRPQf1d83mhVLOV+KBCe1eVAzCgHFA3NrDBY6V18sITQHLDV3tIP1tiRnwsmLRIp14H/PtYxuU9FFw1SVgXg3dkUsueDT7Ijixgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744091486; c=relaxed/simple;
	bh=QmKDDyvPn3/AguTsFLoMiM1SUj6+bz1bvBXyyohwfuY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=JXqU0GxMusY+NUyzSVz6UGdsepmf9/RDF5UQ1jM9J7iu2Jn04qGMCwEWwXw/TvLBR4iAGT3TZ+gp0wTYrs+wiwSdon1nKlbAojhLPiGUSkQ0s1wSvfFxh8QUEzqnKPRGpXhFOCviDHjjVBuRzepnBOrqHfuZCirD1OzuPZZHSL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EjFi+V9E; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744091482;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KsGOnFovtOzMtwHN1EPch6+uuIN1gHUnqKOr7Ubv4J8=;
	b=EjFi+V9EjXTJJpZgYPyTv9Yipe9YDvUW33Z4aSThRgjNzf+zcwsR09gthxfcW3DzMdMH2w
	+LWjS4WCbBSd25SAJMCWjwGDxNBgqAlQ0PkoCx+y4+rOiSuPX7Cn5KV7+1HOElOlXA2XlC
	1W6KywBPAEf2ONA8PU8j3Q77YyZO/CE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-354-PMoa9VyhMEafLbhCzvRMtA-1; Tue,
 08 Apr 2025 01:51:18 -0400
X-MC-Unique: PMoa9VyhMEafLbhCzvRMtA-1
X-Mimecast-MFC-AGG-ID: PMoa9VyhMEafLbhCzvRMtA_1744091477
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 08F811956080;
	Tue,  8 Apr 2025 05:51:17 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.44.22.7])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E1B3919560AD;
	Tue,  8 Apr 2025 05:51:15 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 981EB21E6757; Tue, 08 Apr 2025 07:51:13 +0200 (CEST)
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
In-Reply-To: <Z+uaGHiOkFJd6TAO@intel.com> (Zhao Liu's message of "Tue, 1 Apr
	2025 15:47:36 +0800")
References: <20250122090517.294083-1-zhao1.liu@intel.com>
	<20250122090517.294083-2-zhao1.liu@intel.com>
	<871pwc3dyw.fsf@pond.sub.org> <Z6SMxlWhHgronott@intel.com>
	<87h657p8z0.fsf@pond.sub.org> <Z6TH+ZyLg/6pgKId@intel.com>
	<87v7tlhpqj.fsf@pond.sub.org> <Z+uaGHiOkFJd6TAO@intel.com>
Date: Tue, 08 Apr 2025 07:51:13 +0200
Message-ID: <878qobqjzi.fsf@pond.sub.org>
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

> Hi Mrkus,
>
> I'm really sorry I completely missed your reply (and your patient
> advice). It wasn't until I looked back at the lore archives that I
> realized my mistake. Thinking it over again, I see that your reply,
> which I missed, really helped clear up my confusion:

I'm glad I was able to help some!

> On Fri, Feb 07, 2025 at 02:02:44PM +0100, Markus Armbruster wrote:
>> Date: Fri, 07 Feb 2025 14:02:44 +0100
>> From: Markus Armbruster <armbru@redhat.com>
>> Subject: Re: [RFC v2 1/5] qapi/qom: Introduce kvm-pmu-filter object
>> 
>> Zhao Liu <zhao1.liu@intel.com> writes:
>> 
>> >> Let's ignore how to place it for now, and focus on where we would *like*
>> >> to place it.
>> >> 
>> >> Is it related to anything other than ObjectType / ObjectOptions in the
>> >> QMP reference manual?
>> >
>> > Yes!
>> 
>> Now I'm confused :)
>> 
>> It is related to ObjectType / ObjectType.
>> 
>> Is it related to anything else in the QMP reference manual, and if yes,
>> to what exactly is it related?
>
> I misunderstood your point. The PMU stuff and the QAPI definitions for
> ObjectType/ObjectOptions are not related. They should belong to separate
> categories or sections.
>
>> >> I guess qapi/kvm.json is for KVM-specific stuff in general, not just the
>> >> KVM PMU filter.  Should we have a section for accelerator-specific
>> >> stuff, with subsections for the various accelerators?
>> >> 
>> >> [...]
>> >
>> > If we consider the accelerator from a top-down perspective, I understand
>> > that we need to add accelerator.json, kvm.json, and kvm-pmu-filter.json.
>> >
>> > The first two files are just to include subsections without any additional
>> > content. Is this overkill? Could we just add a single kvm-pmu-filter.json
>> > (I also considered this name, thinking that kvm might need to add more
>> > things in the future)?
>> >
>> > Of course, I lack experience with the file organization here. If you think
>> > the three-level sections (accelerator.json, kvm.json, and kvm-pmu-filter.json)
>> > is necessary, I am happy to try this way. :-)
>> 
>> We don't have to create files just to get a desired section structure.
>> 
>> I'll show you how in a jiffie, but before I do that, let me stress: we
>> should figure out what we want *first*, and only then how to get it.
>> So, what section structure would make the most sense for the QMP
>> reference manual?
>
> Thank you for your patience. I have revisited and carefully considered
> the "QEMU QMP Reference Manual," especially from a reader's perspective.
> Indeed, I agree that, as you mentioned, a three-level directory
> (accelerator - kvm - kvm stuff) is more readable and easier to maintain.

Sounds good to me.

> For this question "what we want *first*, and only then how to get it", I
> think my thought is:
>
> First, the structure should be considered, and then the specific content
> can be added. Once the structure is clearly defined, categorizing items
> into their appropriate places becomes a natural process...
>
> Then for this question "what section structure would make the most sense
> for the QMP reference manual?", I understand that a top-down, clearly
> defined hierarchical directory makes the most sense, allowing readers to
> follow the structure to find what they want. Directly adding
> kvm-pmu-filter.json or kvm.json would disrupt the entire structure, because
> KVM is just one of the accelerators supported by QEMU. Using "accelerator"
> as the entry point for the documentation, similar to the "accel" directory
> in QEMU's source code, would make indexing more convenient.

I think so, too.

>> A few hints on how...
>> 
>> Consider how qapi/block.json includes qapi/block-core.json:
>> 
>>     ##
>>     # = Block devices
>>     ##
>> 
>>     { 'include': 'block-core.json' }
>> 
>>     ##
>>     # == Additional block stuff (VM related)
>>     ##
>> 
>> block-core.json starts with
>> 
>>     ##
>>     # == Block core (VM unrelated)
>>     ##
>> 
>> Together, this produces this section structure
>> 
>>     = Block devices
>>     == 
>>     ##
>> 
>> Together, this produces this section structure
>> 
>>     = Block devices
>>     == Block core (VM unrelated)
>>     == Additional block stuff (VM related)
>> 
>> Note that qapi/block-core.json isn't included anywhere else.
>> qapi/qapi-schema.json advises:
>> 
>>     # Documentation generated with qapi-gen.py is in source order, with
>>     # included sub-schemas inserted at the first include directive
>>     # (subsequent include directives have no effect).  To get a sane and
>>     # stable order, it's best to include each sub-schema just once, or
>>     # include it first right here.
>
> Thank you very much!!
>
> Based on your inspiration, I think the ideal section structure for my
> issue could be:
>
>     = accelerator
>     == KVM
>     === PMU
>
> Firstly, I should have a new accelerator.json () to include KVM stuff:
>
>     ##
>     # = Accelerator
>     ##
>
>     { 'include': 'kvm.json' }
>
> Next, in kvm.json, I could organize stuffs like:
>
>     ##
>     # == KVM
>     ##
>
>     ##
>     # === PMU stuff
>     ##
>
>     ... (the below are my current QPAI definitions.)
>
> Is such a structure reasonable?

Yes.

I'm not a fan of schema files with nothing but includes, like
accelerator.json.  But the alternative here would be putting its
contents into qapi-schema.json, which I really don't like, or keeping
the KVM contents there instead of in a separate kvm.json, which would
interfere with tracking maintainers in the MAINTAINERS file.

> Thank you again for your guidance!

You're welcome!


