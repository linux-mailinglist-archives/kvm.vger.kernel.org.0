Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9EC933C959
	for <lists+kvm@lfdr.de>; Mon, 15 Mar 2021 23:27:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhCOW0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Mar 2021 18:26:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232898AbhCOW0P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Mar 2021 18:26:15 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3EECC061762
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 15:26:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id s21so9573011pjq.1
        for <kvm@vger.kernel.org>; Mon, 15 Mar 2021 15:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SXXfUbxitLxem4y5IOmlGNcXjSvMqPDKJf33Q5FpRTM=;
        b=udaXDZY+TsOUgxc0zzqYXJLMT2zq5mhWq00mizdMMzE6C8T29RJnXAekUi0TO0leGc
         dNavq6Cts3q4Y8NJ0SqSgh4oSvYYxApdJYk4nvT/eeSZYx4uBPadoNfTwfUsH1DAuTQD
         kqGwC6g7+7Mxw8SaR3TXca5fIpGCSCdVuSEy+T7BELjBM+zFKVa+pKgU2C0Wy0wxzDtI
         g2NHLGceeMUk7DW06dUEFrjYcA21JCFXBqRQTGaM/0ap7F6VOw6CHBdFnAPO35kfk118
         YndXAbahqkgoPlGsd57fl4sn964/VS7GWsm+tl4q+v3r08mF51IMIsSB/HJcNSwUdGyA
         TbEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SXXfUbxitLxem4y5IOmlGNcXjSvMqPDKJf33Q5FpRTM=;
        b=CPyiMTxtGjN6QVy+yLgrcK9fu0j/L9s6RN3E5a+cEbRi3fKyX5Eq7hE/f998+9m5ku
         vykdqwasb1HrHbY0v0yYoE0sEeFmAA/62DV6bd7iy/gv/Z+UmCXGfIV8d14GT0evv+tM
         dc6fG7MBaeaA+ktYe6PO8h+R9a7EYNQaBJZU3Y+MzTgzk2uZobbnJ8eE7AhVT07Pv0Dt
         dGD6SbzD91oNgIjit8rSoTzsMeVR8+zUZII/T48C6FP8tFSzGA+jNyyvsn34Qrx/zSa9
         2knEKrWFpYcWiXEJzrASeOkA9+/L1fmHr4RTc9XRjGMNft8uaBg7TXY9IGazwF5yUrjk
         ECsw==
X-Gm-Message-State: AOAM532167eXu6xPejsX+1NdW/UO2Sulnvchxl83gjKH6OdikDked+4k
        6oZyc/MYgsOoOhsCCAu6sqUyXQ==
X-Google-Smtp-Source: ABdhPJzbRrLp4UqUBBV/1iVunsJ7Ia5up2kgNLKYTf6vRlt9VH19h4d1D6DqoUUSnWjHiOffkRH5Tw==
X-Received: by 2002:a17:90b:1950:: with SMTP id nk16mr1333994pjb.140.1615847173500;
        Mon, 15 Mar 2021 15:26:13 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:3d60:4c70:d756:da57])
        by smtp.gmail.com with ESMTPSA id 23sm16026771pge.0.2021.03.15.15.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 15:26:12 -0700 (PDT)
Date:   Mon, 15 Mar 2021 15:26:06 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2 2/4] KVM: x86/mmu: Fix RCU usage when atomically
 zapping SPTEs
Message-ID: <YE/e/sE6FQtuuRLG@google.com>
References: <20210315182643.2437374-1-bgardon@google.com>
 <20210315182643.2437374-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315182643.2437374-3-bgardon@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 15, 2021, Ben Gardon wrote:
> Fix a missing rcu_dereference in tdp_mmu_zap_spte_atomic.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
