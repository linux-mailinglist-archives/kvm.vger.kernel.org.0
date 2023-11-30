Return-Path: <kvm+bounces-2976-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A5E197FF75B
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:56:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3759AB21123
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 16:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C20655C01;
	Thu, 30 Nov 2023 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="g2/JXp78"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3079310E2
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 08:55:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701363357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KtoN2ZvhcuCaqON5ck8JufGVlPbWB5udZtZepLtMMXU=;
	b=g2/JXp78OefX5CZCwks2adfntXSYwrlBs4qgjvouYnjMNvvcnskdefAuYx3HDNiNKe4+7Y
	gvPKlHegclOEEXK2vixc04conB3LjIpcvvbWzncQFqHBDYeJQeluKfffTYDs5eDeWhmJIS
	up9ZCCuGrJfwEa/jMG66hwPSczYQBkQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-343-KEYvOU71NxaKIsLigfrkkA-1; Thu, 30 Nov 2023 11:55:56 -0500
X-MC-Unique: KEYvOU71NxaKIsLigfrkkA-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-67a3773e271so13027726d6.3
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 08:55:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701363355; x=1701968155;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KtoN2ZvhcuCaqON5ck8JufGVlPbWB5udZtZepLtMMXU=;
        b=OH4Nloit9JM+G6DEHYaO2eKsS4eKAXi8PSgsSVxvO0NKkC3APLMvCpsoN3QqgEG1ir
         lhgm1lZeWvVSHcPOYKxk16ds8g4pmT/EUB/lWOkmA/mfkYcal42mdk4rpuRSU71wsxYk
         INntMlEKYqxDWY2ZOYqM7Hi8W61y+fWyx7hencMlCu5yDC6giWzr6f/CUdusX/+ATAWj
         vi/VGtCNyh0OfiQdgaRNF1qQBZxlrNoCKgy3//Do0H03Ibt9ECTBr1LQy96EmTUevzUN
         d5pnnNuP/3H2YafG5ZbnRSmbtDW7I+xGRIP2RCN70ffq1QX06LgK5jw147ZPDr7sMOu+
         Y9RA==
X-Gm-Message-State: AOJu0Yz+DLlzFOdIV5bzJbhiOcha+PnZ+rv4unw3kE9aHebw7PGM42R4
	TdcbgyzUMBrR2liSPJrN75pelvRS1JKLKbbKC7096TPBWR/SBTVJ9vHvEfeJn3575O6PxFQ5Z2G
	aNDlnpygHIHROrzqsBAzI
X-Received: by 2002:ad4:5988:0:b0:67a:8873:5f31 with SMTP id ek8-20020ad45988000000b0067a88735f31mr1563752qvb.31.1701363355545;
        Thu, 30 Nov 2023 08:55:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFCWIBeWhqOh5ZvE9cdWqZuBVRYzHXomkD/IZHya+Ja+xoGkrNnZgnDowpjYfCs6kp0jrQKBg==
X-Received: by 2002:ad4:5988:0:b0:67a:8873:5f31 with SMTP id ek8-20020ad45988000000b0067a88735f31mr1563741qvb.31.1701363355342;
        Thu, 30 Nov 2023 08:55:55 -0800 (PST)
Received: from rh (p200300c93f306f0016d68197cd5f6027.dip0.t-ipconnect.de. [2003:c9:3f30:6f00:16d6:8197:cd5f:6027])
        by smtp.gmail.com with ESMTPSA id d22-20020a0caa16000000b0067a17f65a9csm656796qvb.21.2023.11.30.08.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 08:55:55 -0800 (PST)
Date: Thu, 30 Nov 2023 17:55:50 +0100 (CET)
From: Sebastian Ott <sebott@redhat.com>
To: Shaoqin Huang <shahuang@redhat.com>
cc: qemu-arm@nongnu.org, Eric Auger <eauger@redhat.com>, 
    Paolo Bonzini <pbonzini@redhat.com>, 
    Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, 
    qemu-devel@nongnu.org
Subject: Re: [PATCH v3] arm/kvm: Enable support for
 KVM_ARM_VCPU_PMU_V3_FILTER
In-Reply-To: <20231129030827.2657755-1-shahuang@redhat.com>
Message-ID: <58b1095a-839d-0838-24df-f4cd532233be@redhat.com>
References: <20231129030827.2657755-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Tue, 28 Nov 2023, Shaoqin Huang wrote:
> +static void kvm_arm_pmu_filter_init(CPUState *cs)
> +{
> +    static bool pmu_filter_init = false;
> +    struct kvm_pmu_event_filter filter;
> +    struct kvm_device_attr attr = {
> +        .group      = KVM_ARM_VCPU_PMU_V3_CTRL,
> +        .attr       = KVM_ARM_VCPU_PMU_V3_FILTER,
> +        .addr       = (uint64_t)&filter,
> +    };
> +    KVMState *kvm_state = cs->kvm_state;
> +    char *tmp;
> +    char *str, act;
> +
> +    if (!kvm_state->kvm_pmu_filter)
> +        return;
> +
> +    if (kvm_vcpu_ioctl(cs, KVM_HAS_DEVICE_ATTR, attr)) {
> +        error_report("The kernel doesn't support the pmu event filter!\n");
> +        abort();
> +    }
> +
> +    /* The filter only needs to be initialized for 1 vcpu. */
> +    if (!pmu_filter_init)
> +        pmu_filter_init = true;

Imho this is missing an else to bail out. Or the shorter version

 	if (pmu_filter_init)
 		return;

 	pmu_filter_init = true;

which could also move above the other tests.

Sebastian


