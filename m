Return-Path: <kvm+bounces-44587-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 98C68A9F5BF
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 18:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E223E1A84015
	for <lists+kvm@lfdr.de>; Mon, 28 Apr 2025 16:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BF2A27B506;
	Mon, 28 Apr 2025 16:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JEwtyIje"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B2027A124
	for <kvm@vger.kernel.org>; Mon, 28 Apr 2025 16:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745857509; cv=none; b=Ol0sF/ksZSi4ENMYxW2hMfnBOovxgb9/l3SW7ilO1Q5yJJNfmgH+jXYOLKLTgA3ZnGgs/77hm/s2YrfGdH/3NYYF441ih5r81GKF4lLBSjfsp3GtAxB6DmVgoxfmfL7x8R0dWYpCEQgjQR1xW2y0092h7/Gqe2RwFXx2xXh1uGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745857509; c=relaxed/simple;
	bh=hZbInvfWyOOuQzlA02StkOq30lHDiWC6Q8biqlq9ZkQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=UFAsMa+s73y+yEdkIeC85JHIKCjL585XfdL/x/r5gZpnaabuafE2XwBgBX/LwfzQvuTss6QV5pzPKcy+XZf38bmnnoCVRcI/RtZIAFGvFpWRuQctMOTYqLEkkZ6s9rJzrFT75QDVL8TbKZ7YhJQUCHgaAjcJPlT31ddjQYzVW1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JEwtyIje; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745857506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=26jfT4yYws4ox9C/3roTpInDX9JvbAHrajw/qRQX6u8=;
	b=JEwtyIjeundXZa1jYGE2ixYfaJkyP2LzBneWT4M/Xo59/DLKZg5RHGdN7vvtr8+K87jCVO
	nrYi2rfcxFHSqruXdl7y3NRHSONSHEvYjF6g+zF3BLmCd7MwR9rwLWdrDHqWTWnqBcOmdS
	UAp/rSnzNPg3y0jj2DM8xNG/5EqsQQU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-370-ReANHy3WO9utRsUTJJy7fw-1; Mon,
 28 Apr 2025 12:25:02 -0400
X-MC-Unique: ReANHy3WO9utRsUTJJy7fw-1
X-Mimecast-MFC-AGG-ID: ReANHy3WO9utRsUTJJy7fw_1745857500
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 35B3E1955E79;
	Mon, 28 Apr 2025 16:24:59 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.45.242.27])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E3FDA19560A3;
	Mon, 28 Apr 2025 16:24:57 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id 94FBC21E66C2; Mon, 28 Apr 2025 18:24:55 +0200 (CEST)
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
  Dapeng Mi <dapeng1.mi@intel.com>,  Yi Lai <yi1.lai@intel.com>,  Philippe
 =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
  pierrick.bouvier@linaro.org
Subject: Re: [PATCH 3/5] i386/kvm: Support event with select & umask format
 in KVM PMU filter
In-Reply-To: <aA+Ty2IqnE4zQhJv@intel.com> (Zhao Liu's message of "Mon, 28 Apr
	2025 22:42:19 +0800")
References: <20250409082649.14733-1-zhao1.liu@intel.com>
	<20250409082649.14733-4-zhao1.liu@intel.com>
	<87frhwfuv1.fsf@pond.sub.org> <aA3TeaYG9mNMdEiW@intel.com>
	<87h6283g9g.fsf@pond.sub.org> <aA+Ty2IqnE4zQhJv@intel.com>
Date: Mon, 28 Apr 2025 18:24:55 +0200
Message-ID: <87ldrks17s.fsf@pond.sub.org>
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

> On Mon, Apr 28, 2025 at 09:19:07AM +0200, Markus Armbruster wrote:
>> Date: Mon, 28 Apr 2025 09:19:07 +0200
>> From: Markus Armbruster <armbru@redhat.com>
>> Subject: Re: [PATCH 3/5] i386/kvm: Support event with select & umask format
>>  in KVM PMU filter
>> 
>> Zhao Liu <zhao1.liu@intel.com> writes:
>> 
>> > Hi Markus,
>> >
>> >> > +        case KVM_PMU_EVENT_FORMAT_X86_SELECT_UMASK: {
>> >> > +            if (event->u.x86_select_umask.select > UINT12_MAX) {
>> >> > +                error_setg(errp,
>> >> > +                           "Parameter 'select' out of range (%d).",
>> >> > +                           UINT12_MAX);
>> >> > +                goto fail;
>> >> > +            }
>> >> > +
>> >> > +            /* No need to check the range of umask since it's uint8_t. */
>> >> > +            break;
>> >> > +        }
>> >> 
>> >> As we'll see below, the new x86-specific format is defined in the QAPI
>> >> schema regardless of target.
>> >> 
>> >> It is accepted here also regardless of target.  Doesn't matter much
>> >> right now, as the object is effectively useless for targets other than
>> >> x86, but I understand that will change.
>> >> 
>> >> Should we reject it unless the target is x86?
>> >
>> > I previously supposed that different architectures should implement
>> > their own kvm_arch_check_pmu_filter(), which is the `check` hook of
>> > object_class_property_add_link():
>> >
>> >     object_class_property_add_link(oc, "pmu-filter",
>> >                                    TYPE_KVM_PMU_FILTER,
>> >                                    offsetof(KVMState, pmu_filter),
>> >                                    kvm_arch_check_pmu_filter,
>> >                                    OBJ_PROP_LINK_STRONG);
>> 
>> This way, the checking happens only when you actually connect the
>> kvm-pmu-filter object to the accelerator.
>> 
>> Have you considered checking in the kvm-pmu-filter object's complete()
>> method?  Simple example of how to do that: qauthz_simple_complete() in
>> authz/simple.c.
>
> Thank you, I hadn't noticed it before. Now I study it carefully, and yes,
> this is a better way than `check` hook. Though in the following we are
> talking about other ways to handle target-specific check, this helper
> may be still useful as I proposed to help check accel-specific cases in
> the reply to Philip [*].
>
> [*]: https://lore.kernel.org/qemu-devel/aA3cHIcKmt3vdkVk@intel.com/
>
>> > For x86, I implemented kvm_arch_check_pmu_filter() in target/i386/kvm/
>> > kvm.c and checked the supported formats (I also supposed arch-specific
>> > PMU filter could reject the unsupported format in
>> > kvm_arch_check_pmu_filter().)
>> >
>> > But I think your idea is better, i.e., rejecting unsupported format
>> > early in pmu-filter parsing.
>> >
>> > Well, IIUC, there is no way to specify in QAPI that certain enumerations
>> > are generic and certain enumerations are arch-specific,
>> 
>> Here's how to make enum values conditional:
>> 
>>     { 'enum': 'KvmPmuEventFormat',
>>       'data': ['raw',
>>                { 'name': 'x86-select-umask', 'if': 'TARGET_I386' }
>>                { 'name': 'x86-masked-entry', 'if': 'TARGET_I386' } ] }
>
> What I'm a bit hesitant about is that, if different arches add similar
> "conditional" enumerations later, it could cause the enumeration values
> to change under different compilation conditions (correct? :-)). Although
> it might not break anything, since we don't rely on the specific numeric
> values.

Every binary we create contains target-specific code for at most one
target.  Therefore, different numerical encodings for different targets
are fine.

Same argument for struct members, by the way.  Consider

    { 'struct': 'CpuModelExpansionInfo',
      'data': { 'model': 'CpuModelInfo',
                'deprecated-props' : { 'type': ['str'],
                                       'if': 'TARGET_S390X' } },
      'if': { 'any': [ 'TARGET_S390X',
                       'TARGET_I386',
                       'TARGET_ARM',
                       'TARGET_LOONGARCH64',
                       'TARGET_RISCV' ] } }

This generates

    #if defined(TARGET_S390X) || defined(TARGET_I386) || defined(TARGET_ARM) || defined(TARGET_LOONGARCH64) || defined(TARGET_RISCV)
    struct CpuModelExpansionInfo {
        CpuModelInfo *model;
    #if defined(TARGET_S390X)
        strList *deprecated_props;
    #endif /* defined(TARGET_S390X) */
    };
    #endif /* defined(TARGET_S390X) || defined(TARGET_I386) || defined(TARGET_ARM) || defined(TARGET_LOONGARCH64) || defined(TARGET_RISCV) */

The struct's size depends on the target.  If we ever add members after
@deprecated_props, their offset depends on the target, too.

The single binary work will invalidate the "at most one target"
property.  We need to figure out how to best deal with that, but not in
this thread.

[...]


