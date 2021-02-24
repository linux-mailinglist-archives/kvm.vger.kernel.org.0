Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5577B32456C
	for <lists+kvm@lfdr.de>; Wed, 24 Feb 2021 21:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbhBXUlZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Feb 2021 15:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbhBXUlG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Feb 2021 15:41:06 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC883C061756
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 12:40:25 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gm18so2119807pjb.1
        for <kvm@vger.kernel.org>; Wed, 24 Feb 2021 12:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VFxShBzJBKwIv3itsmWVkegV7IoKFluKjrJvY+J4Dkw=;
        b=LshVzGHOI6rEiOwFaGcmofK3UPPprdyi9CyVz3sxdLCZyw6TRPM+zNYnXY0vqcvpXr
         a698fRl+hOyA4PMWDtImni2n8GmBHtceKC8vZpulD4lsexTvALuOIDGnoBTg5ISDjor9
         sjdRe4sxNy90o9jUU+qhlPpyWyxc1doB5z3E6r0sPS+El3VgDVwA6GHTAt0yRf1OW2BF
         BX3TD4T1QkP3yBcteJktqVeuI/4N/khDksVMZ7g895dTDNZthKwueuXmPjTbAWprBWwR
         ozwE1ZZ7/5UAn6BH2LQTTnHKhT+QdGEtbooHSLJvMDUNaIYhTS+8JBQGcXsTBiad3cQ3
         cGAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VFxShBzJBKwIv3itsmWVkegV7IoKFluKjrJvY+J4Dkw=;
        b=LvQ2k1LKUY20puPHKibDe0CM4QfcB5CvgOt/Nc1laa1AufkIM6O1C1SU1KtdAabSng
         dviCBpy12NQAgkuW17nwvfn+cylH9cDaOQJZQBjC7pnNUU37kHTAkCL7gL71/PxzRCLk
         ouLnOOgaVU7JxDQklAzn2374HAYozAAq6dwd5TASqJxuNMyqWGApN53iBwEkReVs7Oqe
         s77fWnggPG+GcqdPoJeWwS6iSDpnE3zpb84HHEgrTq4QjyduU9py6YxFgdK/SpN/KC73
         SUaHxHdy/CrTAEdJZB1xUTf6HQUyCk++CCqN9VA51J6cQtnXeep+ohRA0dwFVgLuJvrU
         bVHg==
X-Gm-Message-State: AOAM530JlXS9gNI5OEBEXS2l7SePbyO/E5nvqEYwXqNTDL/NjTMEzAGi
        5Mb2i16HTwTrgG6aUh0RKzPP4A==
X-Google-Smtp-Source: ABdhPJzdYnU+yL6HTSAmOEMSD2rk6IG4JMtg2BMrRbRPCYLdcJksM52ujfUoRL+QS7B5W+/HiN4FSA==
X-Received: by 2002:a17:90a:9f96:: with SMTP id o22mr6190038pjp.119.1614199225349;
        Wed, 24 Feb 2021 12:40:25 -0800 (PST)
Received: from google.com ([2620:15c:f:10:385f:4012:d20f:26b5])
        by smtp.gmail.com with ESMTPSA id u15sm3471033pfk.128.2021.02.24.12.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 12:40:24 -0800 (PST)
Date:   Wed, 24 Feb 2021 12:40:17 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Liu, Jing2" <jing2.liu@linux.intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, pbonzini@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] kvm: x86: Revise guest_fpu xcomp_bv field
Message-ID: <YDa5saYSU+Zrr8e+@google.com>
References: <20210208161659.63020-1-jing2.liu@linux.intel.com>
 <4e4b37d1-e2f8-6757-003c-d19ae8184088@intel.com>
 <YCFzztFESzcnKRqQ@google.com>
 <c33335d3-abbe-04e0-2fa1-47f57ad154ac@linux.intel.com>
 <YDPWn70DTA64psQb@google.com>
 <9d23ae5b-9b85-88d7-a2d7-44fd75a068b9@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d23ae5b-9b85-88d7-a2d7-44fd75a068b9@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 23, 2021, Liu, Jing2 wrote:
> XCOMP_BV[63] field indicates that the save area is in the
> compacted format and XCOMP_BV[62:0] indicates the states that
> have space allocated in the save area, including both XCR0
> and XSS bits enable by the host kernel. Use xfeatures_mask_all
> for calculating xcomp_bv and reuse XCOMP_BV_COMPACTED_FORMAT
> defined by kernel.

Works for me, just please wrap at ~73-75 chars, not ~64.

Thanks!
