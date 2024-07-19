Return-Path: <kvm+bounces-21927-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A259377A8
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 14:21:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1DE131C21119
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 12:21:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E655812D1EA;
	Fri, 19 Jul 2024 12:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HSFage9+"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57CE91E871
	for <kvm@vger.kernel.org>; Fri, 19 Jul 2024 12:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721391674; cv=none; b=F7zQCY/+EnGacv3l+CCdE9HThuHjarreQuZq3mPbcNOzLDuTVocmqgZnVe5A1HvXVh/VU1SbePrwu/wy6l86i3A2VRwfHVisaAr4p8IpeHcCWPQhTPU/jlyZdz1mAWfGMUkcRCbZzidNX9Gorj8i0gfeuays8E1/ZLxHd18x6dg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721391674; c=relaxed/simple;
	bh=+XqGlAhsuO4SAFGl1WKnrwD4H8hw+mVijkTaMpel1LA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=D4jecZQNAaIJm+9pCNnMM4V92LBmuzRZPL2E+Pr1FdvgzPQSJbQK74b2FQYGRS5Qn3QKNcbnHhdgLA/YR8Ei08HFI3W6lf78NPzo8A4IcXcaPUl50L1ascy8Sj3PszkgzM+PKJLDQXrfOHoKcZ+llEwMy1qbbDfNSm8RyTrV4Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HSFage9+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721391671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8wdb8H9B7dXAjwpES2ljjfqGjFTVH3+0R9NofJlGwv4=;
	b=HSFage9+7Z4Mv0Qz7de7+cLknTp7y9mxT7FOAUfPq3P9qoZq+7QFGTpR/X7Awky7+u5zDB
	WBw2dlL4pk4EqZCAw07RYOtSYGpmKF5Fl33lzkYOnkB4iVZEmOiIVBJmS1lGdLvOb7/MmK
	4/vssKKanlgNW6OyM8Vxy23mvaMVdgg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-284-jEakaNN7NLKDTBuLuijVgA-1; Fri,
 19 Jul 2024 08:21:10 -0400
X-MC-Unique: jEakaNN7NLKDTBuLuijVgA-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E4DAE1955F66;
	Fri, 19 Jul 2024 12:21:07 +0000 (UTC)
Received: from localhost (unknown [10.22.8.77])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDDBE1955D4D;
	Fri, 19 Jul 2024 12:21:06 +0000 (UTC)
From: Cornelia Huck <cohuck@redhat.com>
To: Akihiko Odaki <akihiko.odaki@daynix.com>, Peter Maydell
 <peter.maydell@linaro.org>
Cc: Thomas Huth <thuth@redhat.com>, Laurent Vivier <lvivier@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org,
 qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 2/5] target/arm/kvm: Fix PMU feature bit early
In-Reply-To: <f9cf0616-34df-42c3-a753-4dec8e2d25b5@daynix.com>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20240716-pmu-v3-0-8c7c1858a227@daynix.com>
 <20240716-pmu-v3-2-8c7c1858a227@daynix.com>
 <CAFEAcA8tFtdpCQobU9ytzxvf3_y3DiA1TwNq8fWgFUtCUYT4hQ@mail.gmail.com>
 <f9cf0616-34df-42c3-a753-4dec8e2d25b5@daynix.com>
User-Agent: Notmuch/0.38.3 (https://notmuchmail.org)
Date: Fri, 19 Jul 2024 14:21:04 +0200
Message-ID: <87cyn9a7yn.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Fri, Jul 19 2024, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:

> On 2024/07/18 21:07, Peter Maydell wrote:
>> On Tue, 16 Jul 2024 at 13:50, Akihiko Odaki <akihiko.odaki@daynix.com> wrote:
>>>
>>> kvm_arm_get_host_cpu_features() used to add the PMU feature
>>> unconditionally, and kvm_arch_init_vcpu() removed it when it is actually
>>> not available. Conditionally add the PMU feature in
>>> kvm_arm_get_host_cpu_features() to save code.
>>>
>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>> ---
>>>   target/arm/kvm.c | 7 +------
>>>   1 file changed, 1 insertion(+), 6 deletions(-)
>>>
>>> diff --git a/target/arm/kvm.c b/target/arm/kvm.c
>>> index 70f79eda33cd..849e2e21b304 100644
>>> --- a/target/arm/kvm.c
>>> +++ b/target/arm/kvm.c
>>> @@ -280,6 +280,7 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>>       if (kvm_arm_pmu_supported()) {
>>>           init.features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>>>           pmu_supported = true;
>>> +        features |= 1ULL << ARM_FEATURE_PMU;
>>>       }
>>>
>>>       if (!kvm_arm_create_scratch_host_vcpu(cpus_to_try, fdarray, &init)) {
>>> @@ -448,7 +449,6 @@ static bool kvm_arm_get_host_cpu_features(ARMHostCPUFeatures *ahcf)
>>>       features |= 1ULL << ARM_FEATURE_V8;
>>>       features |= 1ULL << ARM_FEATURE_NEON;
>>>       features |= 1ULL << ARM_FEATURE_AARCH64;
>>> -    features |= 1ULL << ARM_FEATURE_PMU;
>>>       features |= 1ULL << ARM_FEATURE_GENERIC_TIMER;
>>>
>>>       ahcf->features = features;
>>> @@ -1888,13 +1888,8 @@ int kvm_arch_init_vcpu(CPUState *cs)
>>>       if (!arm_feature(env, ARM_FEATURE_AARCH64)) {
>>>           cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_EL1_32BIT;
>>>       }
>>> -    if (!kvm_check_extension(cs->kvm_state, KVM_CAP_ARM_PMU_V3)) {
>>> -        cpu->has_pmu = false;
>>> -    }
>>>       if (cpu->has_pmu) {
>>>           cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
>>> -    } else {
>>> -        env->features &= ~(1ULL << ARM_FEATURE_PMU);
>>>       }
>>>       if (cpu_isar_feature(aa64_sve, cpu)) {
>>>           assert(kvm_arm_sve_supported());
>> 
>> Not every KVM CPU is necessarily the "host" CPU type.
>> The "cortex-a57" and "cortex-a53" CPU types will work if you
>> happen to be on a host of that CPU type, and they don't go
>> through kvm_arm_get_host_cpu_features().
>
> kvm_arm_vcpu_init() will emit an error in such a situation and I think 
> it's better than silently removing a feature that the requested CPU type 
> has. A user can still disable the feature if desired.

OTOH, if we fail for the named cpu models if the kernel does not provide
the cap, but silently disable for the host cpu model in that case, that
also seems inconsistent. I'd rather keep it as it is now.


