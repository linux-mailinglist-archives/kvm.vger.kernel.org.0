Return-Path: <kvm+bounces-44526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 66408A9E93F
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 09:26:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DF13E3AA7EB
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 07:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BD551D61B7;
	Mon, 28 Apr 2025 07:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fH7vsYCh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C12815748F
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 07:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745825170; cv=none; b=P29y5GbncMHS1kVaCu0CXiDww0v7u3hmo4HvmEq1VpWMDOeK55z6CLCVhLn3uhQb1CzD9GRKUui9BBAt6jQ8naJ2yQvVhro56KeHfMtpyrBpWQtpiMRGADxl8Rj4F6UfypnQ+bOJuUS7Epjybtn5VXbLCDmslmsvXX3F1xgqGx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745825170; c=relaxed/simple;
	bh=9OTrNH0IAEZQT3hNnhz4blUNkf4mziUyN6+x0CwPtnI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Yba3geFNXDXQo6jwZ9GnZA2yjHjEzf4XJneete4MIoXAAAi7GB9PBPSq27qpXPzXC1psw1vKUYEmXWD9zvCTEWwvlpjlLEYLo3yUMEhEsvSmV7WHlLOqZVYn7nSrDrDRqsdbHyfykMme9dUSFHovDnOAe+qQN8SdrrmAw40pCPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fH7vsYCh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745825167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CISJnPMfG/uXMv0l6JF9iE0pkiWbduTPqPP8qKQb4lc=;
	b=fH7vsYChrAznmqO8re0AV1vJzBXPUwOgh3J2XRem4nnupixrRlVA7Qc2NgCTo45yJZhP7V
	Clfnr7ylddPvPD5c2jQPJu716wxxveSaF4e/P2qVGCdmkgDv3FA05G95nTcHoK6DZ+tYbQ
	1MxVPV7FS7ODGjIHBMzOucxCZTX74wE=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-122-P6WChWBUNwemPEoOA7SP5g-1; Mon,
 28 Apr 2025 03:26:04 -0400
X-MC-Unique: P6WChWBUNwemPEoOA7SP5g-1
X-Mimecast-MFC-AGG-ID: P6WChWBUNwemPEoOA7SP5g_1745825162
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6B09618004A7;
	Mon, 28 Apr 2025 07:26:02 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7A6E1800352;
	Mon, 28 Apr 2025 07:26:00 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id E6E6821E66C2; Mon, 28 Apr 2025 08:12:09 +0200 (CEST)
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
Subject: Re: [PATCH 2/5] i386/kvm: Support basic KVM PMU filter
In-Reply-To: <aA3sLRzZj2270cSs@intel.com> (Zhao Liu's message of "Sun, 27 Apr
	2025 16:34:53 +0800")
References: <20250409082649.14733-1-zhao1.liu@intel.com>
	<20250409082649.14733-3-zhao1.liu@intel.com>
	<878qnoha3j.fsf@pond.sub.org> <aA3sLRzZj2270cSs@intel.com>
Date: Mon, 28 Apr 2025 08:12:09 +0200
Message-ID: <87r01c3jd2.fsf@pond.sub.org>
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

> ...
>
>> > diff --git a/qemu-options.hx b/qemu-options.hx
>> > index dc694a99a30a..51a7c61ce0b0 100644
>> > --- a/qemu-options.hx
>> > +++ b/qemu-options.hx
>> > @@ -232,7 +232,8 @@ DEF("accel", HAS_ARG, QEMU_OPTION_accel,
>> >      "                eager-split-size=n (KVM Eager Page Split chunk size, default 0, disabled. ARM only)\n"
>> >      "                notify-vmexit=run|internal-error|disable,notify-window=n (enable notify VM exit and set notify window, x86 only)\n"
>> >      "                thread=single|multi (enable multi-threaded TCG)\n"
>> > -    "                device=path (KVM device path, default /dev/kvm)\n", QEMU_ARCH_ALL)
>> > +    "                device=path (KVM device path, default /dev/kvm)\n"
>> > +    "                pmu-filter=id (configure KVM PMU filter)\n", QEMU_ARCH_ALL)
>> 
>> As we'll see below, this property is actually available only for i386.
>> Other target-specific properties document this like "x86 only".  Please
>> do that for this one, too.
>
> Thanks! I'll change QEMU_ARCH_ALL to QEMU_ARCH_I386.

That would be wrong :)

QEMU_ARCH_ALL is the last argument passed to macro DEF().  It applies to
the entire option, in this case -accel.

I'd like you to mark the option parameter as "(x86 only)", like
notify-vmexit right above, and several more elsewhere.

>> As far as I can tell, the kvm-pmu-filter object needs to be activated
>> with -accel pmu-filter=... to do anything.  Correct?
>
> Yes,
>
>> You can create any number of kvm-pmu-filter objects, but only one of
>> them can be active.  Correct?
>
> Yes! I'll try to report error when user repeats to set this object, or
> mention this rule in doc.

Creating kvm-pmu-filter objects without using them should be harmless,
shouldn't it?  I think users can already create other kinds of unused
objects.

>> > +
>> > +static int kvm_install_pmu_event_filter(KVMState *s)
>> > +{
>> > +    struct kvm_pmu_event_filter *kvm_filter;
>> > +    KVMPMUFilter *filter = s->pmu_filter;
>> > +    int ret;
>> > +
>> > +    kvm_filter = g_malloc0(sizeof(struct kvm_pmu_event_filter) +
>> > +                           filter->nevents * sizeof(uint64_t));
>> 
>> Should we use sizeof(filter->events[0])?
>
> No, here I'm trying to constructing the memory accepted in kvm interface
> (with the specific layout), which is not the same as the KVMPMUFilter
> object.

You're right.  What about sizeof(kvm_filter->events[0])?

[...]


