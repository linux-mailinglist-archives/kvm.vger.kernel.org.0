Return-Path: <kvm+bounces-11190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EB5D873FB5
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 19:38:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B913628166D
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 18:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13E51143752;
	Wed,  6 Mar 2024 18:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bd78ICi8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01C113790F
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 18:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709749820; cv=none; b=pYMAzRxrHErvMb+KOP9T6Vb4kWjinaS9vbmAKnnPEO6FR/F2qNRMbUfgl39RsySDXuHcqnp+99VP0nmhs0y+60g4mSl6wunbxEYRlGWq9S8rv8FdO9WvRtHBGhf5n3A6G3e0ZgaI1Jyknfn1u878VCJTAKaqej3V9vWoqnO20XA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709749820; c=relaxed/simple;
	bh=aXZKjsNpEgJ0PMygu9fmYGwPhzAz24nUfVnTZjCVTNg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EvOzZtLVRgTW+cyfTLgslDQM7HxVmxT1dNg+x4uzx0cH90z17iiBukdCtjtrosKQOCTPAUdz8P35rjLwu8hnwISexUNK6P8Yyp8wmmGKPa0P5uhBuHRy8ajQOTWRqCfviycLVpO6iQW1bo6XLGHAdjk0d21G2IXUhadxYjNJ3+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bd78ICi8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709749817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=k7KgayFbR+hNyRj6m2G0t2A8yhp89iJhEkkZnVmMqZg=;
	b=bd78ICi8Ka/TOfMtRHsOc9vDv1dVQatZxMcipNsNQY19Z2wcb3YUo6bpeuoJaYjLMXzNNP
	mRkSsTyv/6k9ciNH/MrGR6ybpNK7skUQa8GOonmMboj4Ow2+1jNvbi44GvPT9p7LnQqMFS
	FBXinS5gisGWYhsZYh4tHTM2B89XcFM=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-516-sEVEJ5DHNOWTFq2JJtNw-A-1; Wed, 06 Mar 2024 13:30:16 -0500
X-MC-Unique: sEVEJ5DHNOWTFq2JJtNw-A-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-51337da375dso4811368e87.3
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 10:30:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709749814; x=1710354614;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k7KgayFbR+hNyRj6m2G0t2A8yhp89iJhEkkZnVmMqZg=;
        b=eNqE8ficzlwQ9thk18nIE795FDLRTt6gZW8cg2QsHYMGP2mcIeGjny4EpRN0Plt62a
         jfIIq2NOBJw9niXQOmVTNidGeRlnUX8AwJaiclQ5w4SkqRANzxUZF4NaTfdWSITiixuE
         qwIE9QJpP/lN8lXD5BL7xTa46sx81BHjiW6woPn3RiIz3aL8hI+N3CapdsTxo8JnB+bm
         0NMGux9/5aHRKI0yApztQt4Ma7WjoAiJJokxz3EwF/ONeW8yM5DvstjZ3rgpmp+/QjKg
         Z/dGjbM73zLKNxrJ4V/zSaASuuKf/Id1gMKMk5kPb4n7wXeFUtzqJsKIOsSXs6irIVg0
         RARQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7bCR/2K7coTN1ZE3PAZbe8mRGlwWKgkb9J86qZGBkwG9P9a0UEbMk33kEkxs4CbHtQR5k0cbHCsowQKog/acdXcQU
X-Gm-Message-State: AOJu0YwVjhJkWmxWvfXvGSl8ymA20e8ELfd7e422F1j4+r+7N7SvOqMQ
	PwPMAzKI7qIJnPjRktPftX/0q3lbvBvdKGGoHFJsmJjfhDtx/8Sg5PR+I33VyXqeiAnZcNU1lWP
	443vrEwGuMdbrm8eSyH173z2WbADVimjZ3eaOPGSaWfez7HJz8A==
X-Received: by 2002:a05:6512:148:b0:513:26fd:5c13 with SMTP id m8-20020a056512014800b0051326fd5c13mr3863709lfo.52.1709749814717;
        Wed, 06 Mar 2024 10:30:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnQWxdZjVtvijqTnq9PdLFe6OMtKx6FhU+4/c9ObET/W6uD/MiWEzV38Iq+/ZhCVVhBmHZwA==
X-Received: by 2002:a05:6512:148:b0:513:26fd:5c13 with SMTP id m8-20020a056512014800b0051326fd5c13mr3863688lfo.52.1709749814363;
        Wed, 06 Mar 2024 10:30:14 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-151.web.vodafone.de. [109.43.178.151])
        by smtp.gmail.com with ESMTPSA id gc9-20020a170906c8c900b00a4498726bb9sm6255742ejb.173.2024.03.06.10.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 10:30:14 -0800 (PST)
Message-ID: <c66d3c14-962d-439d-bc33-6d52d0f776be@redhat.com>
Date: Wed, 6 Mar 2024 19:30:12 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 17/18] target/i386: Remove
 X86CPU::kvm_no_smi_migration field
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, devel@lists.libvirt.org,
 David Hildenbrand <david@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>
References: <20240305134221.30924-1-philmd@linaro.org>
 <20240305134221.30924-18-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240305134221.30924-18-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/03/2024 14.42, Philippe Mathieu-Daudé wrote:
> X86CPU::kvm_no_smi_migration was only used by the
> pc-i440fx-2.3 machine, which got removed. Remove it
> and simplify kvm_put_vcpu_events().
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   target/i386/cpu.h     | 3 ---
>   target/i386/cpu.c     | 2 --
>   target/i386/kvm/kvm.c | 6 ------
>   3 files changed, 11 deletions(-)
> 
> diff --git a/target/i386/cpu.h b/target/i386/cpu.h
> index 952174bb6f..bdc640e844 100644
> --- a/target/i386/cpu.h
> +++ b/target/i386/cpu.h
> @@ -2018,9 +2018,6 @@ struct ArchCPU {
>       /* if set, limit maximum value for phys_bits when host_phys_bits is true */
>       uint8_t host_phys_bits_limit;
>   
> -    /* Stop SMI delivery for migration compatibility with old machines */
> -    bool kvm_no_smi_migration;
> -
>       /* Forcefully disable KVM PV features not exposed in guest CPUIDs */
>       bool kvm_pv_enforce_cpuid;
>   
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 2666ef3808..0e3ad8db2b 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -7905,8 +7905,6 @@ static Property x86_cpu_properties[] = {
>       DEFINE_PROP_BOOL("x-vendor-cpuid-only", X86CPU, vendor_cpuid_only, true),
>       DEFINE_PROP_BOOL("lmce", X86CPU, enable_lmce, false),
>       DEFINE_PROP_BOOL("l3-cache", X86CPU, enable_l3_cache, true),
> -    DEFINE_PROP_BOOL("kvm-no-smi-migration", X86CPU, kvm_no_smi_migration,
> -                     false),
>       DEFINE_PROP_BOOL("kvm-pv-enforce-cpuid", X86CPU, kvm_pv_enforce_cpuid,
>                        false),
>       DEFINE_PROP_BOOL("vmware-cpuid-freq", X86CPU, vmware_cpuid_freq, true),
> diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
> index 42970ab046..571cbbf1fc 100644
> --- a/target/i386/kvm/kvm.c
> +++ b/target/i386/kvm/kvm.c
> @@ -4344,12 +4344,6 @@ static int kvm_put_vcpu_events(X86CPU *cpu, int level)
>               events.smi.pending = 0;
>               events.smi.latched_init = 0;
>           }
> -        /* Stop SMI delivery on old machine types to avoid a reboot
> -         * on an inward migration of an old VM.
> -         */
> -        if (!cpu->kvm_no_smi_migration) {
> -            events.flags |= KVM_VCPUEVENT_VALID_SMM;
> -        }

Shouldn't it be the other way round, i.e. that the flag is now always set?

pc_compat_2_3[] had:

     { TYPE_X86_CPU, "kvm-no-smi-migration", "on" },

... so I think kvm_no_smi_migration was set to true for the old machines?

  Thomas


