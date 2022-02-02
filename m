Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0765A4A74FA
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 16:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345602AbiBBPyF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 10:54:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234216AbiBBPyD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 10:54:03 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D291C06173D
        for <kvm@vger.kernel.org>; Wed,  2 Feb 2022 07:54:03 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id j10so18648625pgc.6
        for <kvm@vger.kernel.org>; Wed, 02 Feb 2022 07:54:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QhI0g3H91MNQawpFWeFiSZKM1lUpHcArsiuPvxg5hME=;
        b=THsSc61G6LQn9DjlHLxzAdXdveyIDLT4naDOiIPkZZ6oCHaBDDeGkPOI/cGeSgWxe7
         5wGjpfMyTtXYT3tcQJPNI4Kd5y0gTPTb+QKyR2OdQ2H1unV1EAJImgs8G/JuyvoFqjIR
         K8f/VXTH6kihyc7vNqUMgDehtzCrtsTmNKV1aCrUNtU1W2uPfwar4mM+CeK+dFWM0+Ee
         2nHF54cQX4Ixt7q4g28Rsb5/VWGRQIlL5DdGRoly8SUpGrtZWiJNbLVrsGH9XFmq6Tf+
         avJcS11nFMMRehH5rbZ1+RQ7q+zWmAum5wpfbiHv6tzbFNL6/YW6t6svmWHnjzQfG6lk
         RMgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QhI0g3H91MNQawpFWeFiSZKM1lUpHcArsiuPvxg5hME=;
        b=xrGkv3k8pCcnZkA/esOd06YwWkpOI5s7jY5tbUZRXamZh1r3XqpGuWe7Y/pep1zWPh
         AfIFwh/72fjg37to3MchWridvIRJozKxEQtKSo10z0ak1F5vgc8lUFTo9uCyoEB+lhln
         hr7pkj8Vite00cxCaBt725+c42pT6LN/IcmHq6PnnRARXS6e3SEq9RlacVseSJF1nURp
         xA87GJiaSVIgmQlM1cBttLwNkitfFiYmfWaQsxMev29zcxJVyI9wLlX8Lzyow7qpdqeW
         GspQi6jDx8qNvOlyZDy2X7Yflilophj2u2oZXQGGig8nF2RHjqyjqJFsj1kdbFVxF93t
         4JZA==
X-Gm-Message-State: AOAM5335K8I4vTAgp9wZJZrKIZKRON0xY0TELlfHTxJ3y0VEOgkfXKcW
        jMN7MHHt3j7N2q8cQ2ZzG96MKA==
X-Google-Smtp-Source: ABdhPJx2D8mRIETLkmJLR3ervdkS8DPHKNlRK6mFJPmaIJuxHrAE6u9fd7+WMg46WVWi8Mvypr7n+w==
X-Received: by 2002:a63:1d4:: with SMTP id 203mr15823549pgb.462.1643817242784;
        Wed, 02 Feb 2022 07:54:02 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id l78sm8018284pfd.131.2022.02.02.07.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 07:54:02 -0800 (PST)
Date:   Wed, 2 Feb 2022 15:53:58 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Suthikulpanit, Suravee" <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, joro@8bytes.org, mlevitsk@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        peterz@infradead.org, hpa@zytor.com, thomas.lendacky@amd.com,
        jon.grimm@amd.com
Subject: Re: [PATCH v3 3/3] KVM: SVM: Extend host physical APIC ID field to
 support more than 8-bit
Message-ID: <YfqpFt5raCd/LZzr@google.com>
References: <20211213113110.12143-1-suravee.suthikulpanit@amd.com>
 <20211213113110.12143-4-suravee.suthikulpanit@amd.com>
 <Yc3qt/x1YPYKe4G0@google.com>
 <34a47847-d80d-e93d-a3fe-c22382977c1c@amd.com>
 <Yfms5evHbN8JVbVX@google.com>
 <9d2ca4ab-b945-6356-5e4b-265b1a474657@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d2ca4ab-b945-6356-5e4b-265b1a474657@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022, Suthikulpanit, Suravee wrote:
> As I mentioned, the APM will be corrected to remove the word "x2APIC".

Ah, I misunderstood what part was being amended.

> Essentially, it will be changed to:
> 
>  * 7:0  - For systems w/ max APIC ID upto 255 (a.k.a old system)
>  * 11:8 - For systems w/ max APIC ID 256 and above (a.k.a new system). Otherwise, reserved and should be zero.
> 
> As for the required number of bits, there is no good way to tell what's the max
> APIC ID would be on a particular system. Hence, we utilize the apic_get_max_phys_apicid()
> to figure out how to properly program the table (which is leaving the reserved field
> alone when making change to the table).
> 
> The avic_host_physical_id_mask is not just for protecting APIC ID larger than
> the allowed fields. It is also currently used for clearing the old physical APIC ID table entry
> before programing it with the new APIC ID.

Just clear 11:0 unconditionally, the reserved bits are Should Be Zero.

> So, What if we use the following logic:
> 
> +	u32 count = get_count_order(apic_get_max_phys_apicid());
> +
> +	/*
> +	 * Depending on the maximum host physical APIC ID available
> +	 * on the system, AVIC can support upto 8-bit or 12-bit host
> +	 * physical APIC ID.
> +	 */
> +	if (count <= 8)
> +		avic_host_physical_id_mask = GENMASK(7, 0);
> +	else if (count <= 12)
> +		avic_host_physical_id_mask = GENMASK(11, 0);
> +	else
> +		/* Warn and Disable AVIC here due to unable to satisfy APIC ID requirement */

I still don't see the point.  It's using the max APIC ID to verify that the max
APIC ID is valid.  Either we trust hardware to not screw up assigning APIC IDs,
or we don't use AVIC.
