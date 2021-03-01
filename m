Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEBE3298AA
	for <lists+kvm@lfdr.de>; Tue,  2 Mar 2021 11:00:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238200AbhCAXoU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Mar 2021 18:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245409AbhCAWeu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Mar 2021 17:34:50 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F4EC06178A
        for <kvm@vger.kernel.org>; Mon,  1 Mar 2021 14:34:08 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id a4so12525845pgc.11
        for <kvm@vger.kernel.org>; Mon, 01 Mar 2021 14:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/AwKDtv+GHa7MHunk/c29uxwQVds8fgP8tOf9dSrqJA=;
        b=rEWXvFMYmBv6dncujhbwJ+VzGxtQNkur08Sj/C2v8MwzMmAzcIHW9PminN8h4aktnS
         4OR+f6sa6+84Ad3Mch/48AwghE8o82uh3M/TuO+51/JGLAvuK9d8kAngISagiMzrAkJL
         AWhcLzIngiasFXpQmULKnogHY1Z0Px6DkplZlLhqEg8ey7MQtXqvIxRl0gQOtVqY7oE5
         vOadraRURss1IYLQ1k3yzbuKK8cgs5pgDnp8lpY0UBechIhhC/oqG9pv+NpSsYByIUFb
         d6Den2mTKfnPXFzC4p1lRSGcesiLpSJR1sn48Wny4YV4NgHNKHTrQJ2fSMFHysZ8UjeE
         OZQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/AwKDtv+GHa7MHunk/c29uxwQVds8fgP8tOf9dSrqJA=;
        b=NCS9ikDVauoRME0p0tSKeTZ0CEEBO5HC41hUGC4ZacdUb9KLYA0gA2fvS7aB54g7GO
         q1m/y06sCrm1B1RsNzCZ/zwJIjQ7r6JZnLYpYXFaCJTb06hQnpSGjRhFcIRLvkttMd1T
         H2U9yvfhemVTxGqL5W1tDJSOZwbUHSJcg6/rFkAgx11q3RLKD2IcUY8aX7rwIDdiLWFg
         4bjLjNKTKNka+sjLlZ/dKxJ5ulKCcCZLmub/aExC3dgwafGthSueHmshEDxOzsBCEyJN
         br9UhqT9dWCEweE1WIdqJXAEabvDaPFqKEABASbgVys+ikq8Qd/g+6PGmZQRs5Ikj3Bi
         LfKw==
X-Gm-Message-State: AOAM5311v0tMpv8EGDw8KpLkx/ETgHHVoMBx6ZbifK/FFPCX+gVSz8EK
        dv+FiZbqOCZ+p53JKAlt3ZJQmA==
X-Google-Smtp-Source: ABdhPJyAPnkIsb6b/0CFbgCmrG8poAEIKGGC2AqntUJXHhhCLrC0LVGAJHlM0XihZb79Ms0NM6OGYw==
X-Received: by 2002:a63:6dc3:: with SMTP id i186mr8303678pgc.314.1614638047291;
        Mon, 01 Mar 2021 14:34:07 -0800 (PST)
Received: from google.com ([2620:15c:f:10:5d06:6d3c:7b9:20c9])
        by smtp.gmail.com with ESMTPSA id 63sm4128729pfg.187.2021.03.01.14.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 14:34:06 -0800 (PST)
Date:   Mon, 1 Mar 2021 14:34:00 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] KVM: vmx/pmu: Add MSR_ARCH_LBR_DEPTH emulation
 for Arch LBR
Message-ID: <YD1r2G1UQjVXkUk5@google.com>
References: <20210203135714.318356-1-like.xu@linux.intel.com>
 <20210203135714.318356-2-like.xu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210203135714.318356-2-like.xu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 03, 2021, Like Xu wrote:
> @@ -348,10 +352,26 @@ static bool intel_pmu_handle_lbr_msrs_access(struct kvm_vcpu *vcpu,
>  	return true;
>  }
>  
> +/*
> + * Check if the requested depth values is supported
> + * based on the bits [0:7] of the guest cpuid.1c.eax.
> + */
> +static bool arch_lbr_depth_is_valid(struct kvm_vcpu *vcpu, u64 depth)
> +{
> +	struct kvm_cpuid_entry2 *best;
> +
> +	best = kvm_find_cpuid_entry(vcpu, 0x1c, 0);
> +	if (depth && best)

> +		return (best->eax & 0xff) & (1ULL << (depth / 8 - 1));

I believe this will genereate undefined behavior if depth > 64.  Or if depth < 8.
And I believe this check also needs to enforce that depth is a multiple of 8.

   For each bit n set in this field, the IA32_LBR_DEPTH.DEPTH value 8*(n+1) is
   supported.

Thus it's impossible for 0-7, 9-15, etc... to be legal depths.


> +
> +	return false;
> +}
> +

