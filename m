Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C1E41179B
	for <lists+kvm@lfdr.de>; Mon, 20 Sep 2021 16:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234660AbhITOyR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Sep 2021 10:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235629AbhITOyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 Sep 2021 10:54:14 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30553C061574
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:52:47 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id s11so17584864pgr.11
        for <kvm@vger.kernel.org>; Mon, 20 Sep 2021 07:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pdz88Zm4WEbtE1IfyklsAUW4ocVL7dpB+GFzyMWI5t8=;
        b=M33vtkFMPqwGndSGqOqdjoHCy3S1jLV/tX2XnNLyBS+0H4jVlK9lVI3YrhmQ4d4nup
         Vw+PCLCxaj9UBZlGZYJdqxxJatED8c5WLkwLX4Qi/UZ1owSns9u7odq2cfEaHedow5GS
         gj8mzyAe2TCnhgAOwEYNhGTBdkuaDUD21+vfzZRrfCZhkV8BKQGZjiRyaWk6WHlaLsfs
         mEdq+tLZLLGcchVXg3etQJ7mkfphqY7w9h2DH/1eC+3jfbYABQWbCpKo3wgRlGs507HC
         gEy2HmQGeE07TuSbCiMrsOuYiC+V74g7Y4A2f56WhCc3z/52GL3sgJ64eWYFHTMPVchM
         IAwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pdz88Zm4WEbtE1IfyklsAUW4ocVL7dpB+GFzyMWI5t8=;
        b=tWv/Q8vcEFsvQadBI8e5D95e12UrLZB+JmUS5ZL7+Qvr/IgVCBT7UplcTZAXMEthSO
         6mPt4ZUhOH2zkqrm1c8pjpdJnifMF2mLJ/a8Of/XEYxuqd7xZN/4fjLXXQ2z7oPzHQwB
         mAiZchwagyL9Of0soE1o7mUoFbptYUcNuIGSelpZyHfx4adZAmbo/LZfNAxnblEcFRY5
         /tsODXBJTsW8kAojKnjvfx/rLpAqlG7x5xK7P86VzsPWUPffTmA9fltaSGprZTcC6OMU
         RVP+VBLzPHuYAUIvlrl/x2PhKqLHxEA6awi4EediQ7piISaPDunb20eZCtIN2H0/stnM
         adXA==
X-Gm-Message-State: AOAM533msISSybdCm5dGGzrWMRZ7dFV5WjCyegsrMl3Gt8CRzGXtnihn
        6rkna33uMoZxu3CpAyG9BXzOVg==
X-Google-Smtp-Source: ABdhPJxJQJi29JAY+MdQUcy5gsI30oApdiOFCqybl1lekSxLJT+gjVoRTKIpclgf5g0aizfS8oEwPw==
X-Received: by 2002:a63:391:: with SMTP id 139mr23904978pgd.410.1632149566474;
        Mon, 20 Sep 2021 07:52:46 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x1sm15157247pfc.53.2021.09.20.07.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 07:52:45 -0700 (PDT)
Date:   Mon, 20 Sep 2021 14:52:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chenyi Qiang <chenyi.qiang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Xiaoyao Li <xiaoyao.li@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] KVM: nVMX: Fix nested bus lock VM exit
Message-ID: <YUigOQ6wL/NSXqjO@google.com>
References: <20210914095041.29764-1-chenyi.qiang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210914095041.29764-1-chenyi.qiang@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 14, 2021, Chenyi Qiang wrote:
> Nested bus lock VM exits are not supported yet. If L2 triggers bus lock
> VM exit, it will be directed to L1 VMM, which would cause unexpected
> behavior. Therefore, handle L2's bus lock VM exits in L0 directly.
> 
> Fixes: fe6b6bc802b4 ("KVM: VMX: Enable bus lock VM exit")

Cc: stable@vger.kernel.org

> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
> 
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
