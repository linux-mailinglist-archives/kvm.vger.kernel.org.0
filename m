Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BBD63FF536
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 22:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347277AbhIBU6P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 16:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347179AbhIBU6N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 16:58:13 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A1FC061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 13:57:14 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id c17so3338443pgc.0
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 13:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AKvoBglyKyX6FOVMBLB/URNeY80PWCKE3Lo+SAFXI3k=;
        b=I0126LUhSD04CPCw4NfU0xi6Grfk2wjNYQRqWhZ2iOjuKglbP3AD/1E2rxglR4eqNc
         DdX3w8JzqQQH3hNWFfvTPXXjh2+dFfbeO4FA6jCRnlTCTjMeF2NpPBumA3HEr0NrUdxf
         S0DkZDKDTD3ejQMUECTQNJO8OHQhjM3R33UV68hmzRwCApTNPwt+XBesICvcgmKy+uO2
         I3PyHC2gE0qNX6iNXg0+5XhUPuJSKAIiG5L700Ho3x/W/1j1mr0SY++iz+nLz2vYjnZ3
         ytFh15AkqwWicUz1FlSAPt6vWCeIrjsSHPFXb6RYhApDX/a93eOR2oNaSdqJ9P+BFRHW
         5TYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AKvoBglyKyX6FOVMBLB/URNeY80PWCKE3Lo+SAFXI3k=;
        b=hYe2PyUaCJt0p2hHTqOgnV1+IvzkJvLC2nKaAJD6nb676eYPdMcam5XcPftkoIzylX
         6ERR+8+5T/vG8Bv8XsteuiNiAahZP5e9iR8GI9/wpZoqsxVwbkncyF+Tvs1+C6dgN6Fx
         o9YFxVUVMBM1D08Th1QEkJ9+nQSLX3DVl8ssM/EclVSmBg5hhc8Zj4DPctFCjMd7/mEn
         D/to8B4Y5qTGi/VUbbJ+M+Ab0LZ6WP4I+jHrkBWsWxoKH/z0hgOa6cSyErYGPxFCtAB+
         dBL5SVDrqhL9G4gLrn/TvzKBKCf5B9PyrrfGKfu/HI3Ai/dfB+4voTgPT3AT1E5uRnJg
         nPdg==
X-Gm-Message-State: AOAM531PstjYy2gbsdzKWm5ky0uSYAP0EIabO1bQFWrubWsxTehjcgK+
        HufQ1qL1sQKdxm12reqMseYUhQ==
X-Google-Smtp-Source: ABdhPJxzTD7xp5K/i9sHGH587GJ8tZkJXnLGOqiJwoNVv8Rls8D2cm5udFmcc86bB3yp/lT+Rd2yLA==
X-Received: by 2002:a63:4917:: with SMTP id w23mr271248pga.344.1630616234252;
        Thu, 02 Sep 2021 13:57:14 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x16sm3647924pgc.49.2021.09.02.13.57.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 13:57:13 -0700 (PDT)
Date:   Thu, 2 Sep 2021 20:57:10 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/8] KVM: x86: hyper-v: Avoid calling
 kvm_make_vcpus_request_mask() with vcpu_mask==NULL
Message-ID: <YTE6pk22mslvIDr6@google.com>
References: <20210827092516.1027264-1-vkuznets@redhat.com>
 <20210827092516.1027264-4-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827092516.1027264-4-vkuznets@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 27, 2021, Vitaly Kuznetsov wrote:
> In preparation to making kvm_make_vcpus_request_mask() use for_each_set_bit()
> switch kvm_hv_flush_tlb() to calling kvm_make_all_cpus_request() for 'all cpus'
> case.
> 
> Note: kvm_make_all_cpus_request() (unlike kvm_make_vcpus_request_mask())
> currently dynamically allocates cpumask on each call and this is suboptimal.
> Both kvm_make_all_cpus_request() and kvm_make_vcpus_request_mask() are
> going to be switched to using pre-allocated per-cpu masks.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
