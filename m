Return-Path: <kvm+bounces-37583-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BAB7FA2C32E
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 14:03:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 219081694A0
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2025 13:03:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A1561E22FA;
	Fri,  7 Feb 2025 13:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NasUUcOs"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2A51DA10C
	for <kvm@vger.kernel.org>; Fri,  7 Feb 2025 13:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738933375; cv=none; b=KKoaiUdvxOb80vNAQhXnwJhLYDrR0SRK4LJ46hE9O/pFeMl1idcTFH+fSDCoIlILYY9Wi3b6dP1DqJQQ1woxQHxinmyO5LzUSJlXk/ZVZ5GigcWoYFvaj9D53mcqha7m9CgfUMpcnz0ybYDZ02ipnpyyCXw07DobGQ2NmFUaCxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738933375; c=relaxed/simple;
	bh=ZFd825yMkVowBJr3igIFcY9Bc6VZyhfrEMSAgud6IRs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=CB8wBoOAhHtO3Oy8I5UpYJcmwe/cmFteVpYJ/6JEqHaujrW/p7OiKii3ZKOnKlGIYKEnCxHMU+IgW3Dix6T5YTPHImMfdcKnnuA7AWDeqLhvpW17m6/i8HbtsjG30ifYpcnGQLhTicXkAq726hzyLa82hC51OWRO1cizKbp6BzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NasUUcOs; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738933372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JewV+YyHcsdjAUqINIHy0lCtkJXQJZffAdLvcStJN+w=;
	b=NasUUcOsZwrw3MCw1nWppkXX9LxaCP1XvnkmbHpyOjs3IpWS/1AiqVfXg+osJ1Ma+s+1s1
	Sf9zyyDl4TZMeNPQ5II+YHIO3fM5jHzmYRXo0LDM2Eh5XBttKAnRaxa6kpXrs+ii8oNPum
	cUEE6QpIXXbqTHDf+dbiK0rBbLh6yCY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-218-ecTQ4cyJN7CaGoPy11B-QQ-1; Fri,
 07 Feb 2025 08:02:49 -0500
X-MC-Unique: ecTQ4cyJN7CaGoPy11B-QQ-1
X-Mimecast-MFC-AGG-ID: ecTQ4cyJN7CaGoPy11B-QQ
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 77BA61800875;
	Fri,  7 Feb 2025 13:02:47 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.26])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AF83D18004A7;
	Fri,  7 Feb 2025 13:02:46 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 2283221E6A28; Fri, 07 Feb 2025 14:02:44 +0100 (CET)
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
In-Reply-To: <Z6TH+ZyLg/6pgKId@intel.com> (Zhao Liu's message of "Thu, 6 Feb
	2025 22:32:25 +0800")
References: <20250122090517.294083-1-zhao1.liu@intel.com>
	<20250122090517.294083-2-zhao1.liu@intel.com>
	<871pwc3dyw.fsf@pond.sub.org> <Z6SMxlWhHgronott@intel.com>
	<87h657p8z0.fsf@pond.sub.org> <Z6TH+ZyLg/6pgKId@intel.com>
Date: Fri, 07 Feb 2025 14:02:44 +0100
Message-ID: <87v7tlhpqj.fsf@pond.sub.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Zhao Liu <zhao1.liu@intel.com> writes:

>> Let's ignore how to place it for now, and focus on where we would *like*
>> to place it.
>> 
>> Is it related to anything other than ObjectType / ObjectOptions in the
>> QMP reference manual?
>
> Yes!

Now I'm confused :)

It is related to ObjectType / ObjectType.

Is it related to anything else in the QMP reference manual, and if yes,
to what exactly is it related?

>> I guess qapi/kvm.json is for KVM-specific stuff in general, not just the
>> KVM PMU filter.  Should we have a section for accelerator-specific
>> stuff, with subsections for the various accelerators?
>> 
>> [...]
>
> If we consider the accelerator from a top-down perspective, I understand
> that we need to add accelerator.json, kvm.json, and kvm-pmu-filter.json.
>
> The first two files are just to include subsections without any additional
> content. Is this overkill? Could we just add a single kvm-pmu-filter.json
> (I also considered this name, thinking that kvm might need to add more
> things in the future)?
>
> Of course, I lack experience with the file organization here. If you think
> the three-level sections (accelerator.json, kvm.json, and kvm-pmu-filter.json)
> is necessary, I am happy to try this way. :-)

We don't have to create files just to get a desired section structure.

I'll show you how in a jiffie, but before I do that, let me stress: we
should figure out what we want *first*, and only then how to get it.
So, what section structure would make the most sense for the QMP
reference manual?

A few hints on how...

Consider how qapi/block.json includes qapi/block-core.json:

    ##
    # = Block devices
    ##

    { 'include': 'block-core.json' }

    ##
    # == Additional block stuff (VM related)
    ##

block-core.json starts with

    ##
    # == Block core (VM unrelated)
    ##

Together, this produces this section structure

    = Block devices
    == 
    ##

Together, this produces this section structure

    = Block devices
    == Block core (VM unrelated)
    == Additional block stuff (VM related)

Note that qapi/block-core.json isn't included anywhere else.
qapi/qapi-schema.json advises:

    # Documentation generated with qapi-gen.py is in source order, with
    # included sub-schemas inserted at the first include directive
    # (subsequent include directives have no effect).  To get a sane and
    # stable order, it's best to include each sub-schema just once, or
    # include it first right here.


