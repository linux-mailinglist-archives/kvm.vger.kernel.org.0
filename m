Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF8D376979
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 19:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbhEGRYa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 13:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbhEGRY3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 May 2021 13:24:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA11AC061574
        for <kvm@vger.kernel.org>; Fri,  7 May 2021 10:23:29 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t2-20020a17090ae502b029015b0fbfbc50so5600367pjy.3
        for <kvm@vger.kernel.org>; Fri, 07 May 2021 10:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qKsbxM0NOn3sUuVqM7zk4fAmHoCca2YmurbXxzp/4eM=;
        b=jvdh07sSAyCSV3l9hZOaKSp6ZVLqf3mV3BIpas+TejSLOXeKYg8wHWzW7wzbujdncD
         LXQeFI9dK8eKu8wc77f1qxFhjIEOWEPCvxWaehIJBS9pMltpiYzQh7xrr7p0ihNkenLC
         /V+e/levDhqiYjlBcfrjjrqhSTYnZDYldpffJuo4zC1zQHJiXMaBi8wZnkLmpQudJmej
         t/hiaeyh39iK64OvUwwybGFj+uF7m4S14DwO/Asbe+2J+qbLm3zXJT4rc0r8SrHC1iVB
         YYsxF69GtEz252us0RgdcBihRmR1I0KlNdXUwl6aMTVXzsNIBEuW8U7B9fIsUIZV+6rz
         3ZiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qKsbxM0NOn3sUuVqM7zk4fAmHoCca2YmurbXxzp/4eM=;
        b=MgDZhldjqNLxC7Fsje/621veDvJHCAn+pnE9m1l44YDDedQxxQKT2V9qd2bf0P3bOZ
         jCQ+FcBtC+Sqp+G6DhoRJPc6jKqUi6oWQuO9AnwoUpvH3SeGmSMCW9r/M7LnZEGCcrNm
         U01jqrSyK0ZDK+VcyxDA1PoIKaeB9iLwAId5+065U5+O7AM8i/FEayazbekBsnI9bVP5
         AlII8gL2vanxe9Zjf8XgZyZxxndIJNtIFYSEefs5RHYJzcImaBOD+xpQERCScF4GEzdJ
         hIgYv8orIIVoIrteKRfPtZVLUlDc0mR2MZluzf9BDMBUqyOjE7ob+EuKiNJKUMprGdtV
         jQdQ==
X-Gm-Message-State: AOAM532Egcb9uXo4Qm7FvTF2Ct5YkiiEdx+UaVxrDk5344WF64/6dogf
        JOZyBqXgRCj/bw+p76CN/EBIQB8AJUY1Pg==
X-Google-Smtp-Source: ABdhPJw4dRxO9+t9G0390L10GS3912LucjMNHKEVK4C21J/5mCQJJ1Us2jv1nsoE+eyGc6LflB/kpA==
X-Received: by 2002:a17:90a:fe01:: with SMTP id ck1mr22271149pjb.146.1620408209287;
        Fri, 07 May 2021 10:23:29 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id d8sm4826137pfl.156.2021.05.07.10.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 10:23:28 -0700 (PDT)
Date:   Fri, 7 May 2021 17:23:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, bgardon@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org
Subject: Re: [PATCH v2 2/3] KVM: x86/mmu: Fix pf_fixed count in
 tdp_mmu_map_handle_target_level()
Message-ID: <YJV3jTPCj6NoPZVY@google.com>
References: <cover.1620343751.git.kai.huang@intel.com>
 <76406bd7aad0cec458e832639c7a2de963e70990.1620343751.git.kai.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76406bd7aad0cec458e832639c7a2de963e70990.1620343751.git.kai.huang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 07, 2021, Kai Huang wrote:
> Currently pf_fixed is not increased when prefault is true.  This is not
> correct, since prefault here really means "async page fault completed".
> In that case, the original page fault from the guest was morphed into as
> async page fault and pf_fixed was not increased.  So when prefault
> indicates async page fault is completed, pf_fixed should be increased.
> 
> Additionally, currently pf_fixed is also increased even when page fault
> is spurious, while legacy MMU increases pf_fixed when page fault returns
> RET_PF_EMULATE or RET_PF_FIXED.
> 
> To fix above two issues, change to increase pf_fixed when return value
> is not RET_PF_SPURIOUS (RET_PF_RETRY has already been ruled out by
> reaching here).
> 
> More information:
> https://lore.kernel.org/kvm/cover.1620200410.git.kai.huang@intel.com/T/#mbb5f8083e58a2cd262231512b9211cbe70fc3bd5
> 
> Fixes: bb18842e2111 ("kvm: x86/mmu: Add TDP MMU PF handler")
> Signed-off-by: Kai Huang <kai.huang@intel.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
