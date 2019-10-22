Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D194BE0244
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2019 12:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731828AbfJVKrR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Oct 2019 06:47:17 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28179 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730197AbfJVKrR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Oct 2019 06:47:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571741235;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=HTbnzNCtOppqAIupH8V/pMGxUXq85ReOJIxDUGQeUjo=;
        b=MOAZjpVsGsNYpEyv3N6AqowghcCwh6+yt74Yvn9y8Fi3IBwGbnjG+N5tV3Rh60UXAZ8BDW
        Me9HulyZfODZv2Q0ZOdEM2vW8dIlhZIOAjWTc0kAJETRRdzoZfHU/MXmJKo7pgFPxNuibc
        wcupSYpgNsUJZAXEYTYrboBuTAOUctE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-213-YyJAUBnONQqQVDsAtwIEOg-1; Tue, 22 Oct 2019 06:47:13 -0400
Received: by mail-wr1-f72.google.com with SMTP id l4so6277594wru.10
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2019 03:47:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8zCq6QLAMRjL/CHEEMgWUvZyUh8kWvlSdVdD6Q6SWo0=;
        b=LC7leEPrMrEvefkgd0XrhAIiK1u3OQWnLIFkOU8PsPPTJk4Cu6Cam4uCFcNLO1AYNO
         g3eR8O5FT5Pu+BNb4wyEgsSGFt0HJ8j3unVeJldSZdzfJlesNXaEVM9IXVEG2iqGWbtR
         eu0AY1kGPswF6Ts3zVZ0LFtHWnQVxw2NSPTQbg9R3fllLye86ExZiVMkGft1H3pg9edl
         y3SFy02Y9gdwWkOQPjKCmZvfz7uRS1PGjmTAY9j6+CAzrtwAULkxN7VU8aVQEtX93QuC
         7ah2/pi4Khr/QWOMmZaSPtXvWvA2FWfnUg4N6mTg3+WzZQKGFOK1J0ZBUSR1c+wBRjbP
         9hSg==
X-Gm-Message-State: APjAAAU0yFiCyVktW8bgWgn34vatb6sxp9VzMhSkOmQrAMZUZXsdyomQ
        Doa0VQsPqoJIeMKELjQt65bM9CFLrwCjXfc7pGcufKlHu2jcx8L5LYICe75AAGZ62dlZfsTB5Ny
        8/LWn+roj8Slj
X-Received: by 2002:a05:600c:22d7:: with SMTP id 23mr2363977wmg.31.1571741232404;
        Tue, 22 Oct 2019 03:47:12 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxmt/TPxoHGsfz2ZLkS3GfXvsQS9YJWhWM+xuxarVHcPZp4Pw3oXisS5P3+nqsdpibJx7RdwA==
X-Received: by 2002:a05:600c:22d7:: with SMTP id 23mr2363951wmg.31.1571741232110;
        Tue, 22 Oct 2019 03:47:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:45c:4f58:5841:71b2? ([2001:b07:6468:f312:45c:4f58:5841:71b2])
        by smtp.gmail.com with ESMTPSA id u1sm16024041wmc.38.2019.10.22.03.47.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Oct 2019 03:47:11 -0700 (PDT)
Subject: Re: [PATCH v3 6/6] KVM: x86/vPMU: Add lazy mechanism to release
 perf_event per vPMC
To:     Like Xu <like.xu@linux.intel.com>, peterz@infradead.org,
        kvm@vger.kernel.org
Cc:     like.xu@intel.com, linux-kernel@vger.kernel.org,
        jmattson@google.com, sean.j.christopherson@intel.com,
        wei.w.wang@intel.com, kan.liang@intel.com
References: <20191021160651.49508-1-like.xu@linux.intel.com>
 <20191021160651.49508-7-like.xu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c17a9d77-2c30-b3c0-4652-57f0b9252f3b@redhat.com>
Date:   Tue, 22 Oct 2019 12:47:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191021160651.49508-7-like.xu@linux.intel.com>
Content-Language: en-US
X-MC-Unique: YyJAUBnONQqQVDsAtwIEOg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/10/19 18:06, Like Xu wrote:
> =20
> +=09=09__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
>  =09=09reprogram_fixed_counter(pmc, new_ctrl, i);
>  =09}
> =20
> @@ -329,6 +330,11 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
>  =09    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) =
&&
>  =09    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
>  =09=09pmu->reserved_bits ^=3D HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;
> +
> +=09bitmap_set(pmu->all_valid_pmc_idx,
> +=09=090, pmu->nr_arch_gp_counters);
> +=09bitmap_set(pmu->all_valid_pmc_idx,
> +=09=09INTEL_PMC_MAX_GENERIC, pmu->nr_arch_fixed_counters);

The offset needs to be INTEL_PMC_IDX_FIXED for GP counters, and 0 for
fixed counters, otherwise pmc_in_use and all_valid_pmc_idx are not in sync.

Paolo

