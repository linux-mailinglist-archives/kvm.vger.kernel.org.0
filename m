Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D790E3D8E01
	for <lists+kvm@lfdr.de>; Wed, 28 Jul 2021 14:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235040AbhG1Mjk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jul 2021 08:39:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:34142 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234771AbhG1Mji (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Jul 2021 08:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627475976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D9Qexy3vyQ1WT2G4JaMh1Amg9BsqkfUkZn1xzPofcxE=;
        b=GodU87qe0NujaBMDb7x7SPl09MGw5xzZlH1yTpTUjNbzYKra/ddaEjDUqB6kePcQBCd1dZ
        yEHLQd7KRqhg0KSiA5kXBrtmLcVMA8eEy+NYksP+tyhAvq0hdUQRR4OEnikJqsFEOfguQE
        stWEjuX+VtBt/pNFFJSCpxGbJqHu+NU=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-eOPeZjiCO3-wpHypXUBQfQ-1; Wed, 28 Jul 2021 08:39:35 -0400
X-MC-Unique: eOPeZjiCO3-wpHypXUBQfQ-1
Received: by mail-wm1-f69.google.com with SMTP id r125-20020a1c2b830000b0290197a4be97b7so886846wmr.9
        for <kvm@vger.kernel.org>; Wed, 28 Jul 2021 05:39:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D9Qexy3vyQ1WT2G4JaMh1Amg9BsqkfUkZn1xzPofcxE=;
        b=nETxN0T5vd1DPbmYEngDJQsIrmFISTS0R1+ozXoJZcMjzJW1etqY/tkcD3IJ3uJlI2
         AMKDpqzAG5FVWT4BP1S18p0BJ8xiTzxomB12H8RQ7Sy7GyqilpURwLVc9Tl4Fr1BFD0u
         yeRryWyfSEYdKq4W/9VEG2L/h8SRn26vHeG72owBMTqieGEtS9hS5v+1777B6HDz5i4s
         hR+C50jI6YKWC4RtCHAwEnkn3UomhWToouaEIOUdTR1sN87cpSpx9B/lD0yA5utg1xKn
         eV/69jHWvWDQTvV+iy7x98tuFIhEEMk2PwznYVXW/Wl1RXXoC2N8697RjRb11GheD1uG
         DGvw==
X-Gm-Message-State: AOAM533xqNm8h5IX0Y7IJmbcj7hGFjySAws2XMIMxhnEAnposLlVBoHI
        nZK4Vluc8mE0aFGGJaappmorFJJvcVYlWC92M6wsZXURu7nW0w04IFk4xtvcz3EjWjOUvNqXE4J
        swOMJKNTpbFQj
X-Received: by 2002:adf:f704:: with SMTP id r4mr13879922wrp.389.1627475974156;
        Wed, 28 Jul 2021 05:39:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxBwPBFLdhkJq8OBYdht9qNvQIxgBrDCuzNOysb/Vo1XYrh6/2bfMLDy3iDKWAOM2A9XgZkVQ==
X-Received: by 2002:adf:f704:: with SMTP id r4mr13879894wrp.389.1627475973976;
        Wed, 28 Jul 2021 05:39:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id f26sm6805370wrd.41.2021.07.28.05.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 05:39:33 -0700 (PDT)
Subject: Re: [PATCH v1 1/4] KVM: stats: Support linear and logarithmic
 histogram statistics
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
References: <20210706180350.2838127-1-jingzhangos@google.com>
 <20210706180350.2838127-2-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8b6f442e-c8bd-d175-471e-6e28b4548c3e@redhat.com>
Date:   Wed, 28 Jul 2021 14:39:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706180350.2838127-2-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/07/21 20:03, Jing Zhang wrote:
> +#define LINHIST_SIZE_SMALL		10
> +#define LINHIST_SIZE_MEDIUM		20
> +#define LINHIST_SIZE_LARGE		50
> +#define LINHIST_SIZE_XLARGE		100
> +#define LINHIST_BUCKET_SIZE_SMALL	10
> +#define LINHIST_BUCKET_SIZE_MEDIUM	100
> +#define LINHIST_BUCKET_SIZE_LARGE	1000
> +#define LINHIST_BUCKET_SIZE_XLARGE	10000
> +
> +#define LOGHIST_SIZE_SMALL		8
> +#define LOGHIST_SIZE_MEDIUM		16
> +#define LOGHIST_SIZE_LARGE		32
> +#define LOGHIST_SIZE_XLARGE		64
> +#define LOGHIST_BASE_2			2

I'd prefer inlining all of these.  For log histograms use 2 directly in 
STATS_DESC_LOG_HIST, since the update function below uses fls64.

> 
> + */
> +void kvm_stats_linear_hist_update(u64 *data, size_t size,
> +				  u64 value, size_t bucket_size)
> +{
> +	size_t index = value / bucket_size;
> +
> +	if (index >= size)
> +		index = size - 1;
> +	++data[index];
> +}
> +

Please make this function always inline, so that the compiler optimizes 
the division.

Also please use array_index_nospec to clamp the index to the size, in 
case value comes from a memory access as well.  Likewise for 
kvm_stats_log_hist_update.

Paolo

