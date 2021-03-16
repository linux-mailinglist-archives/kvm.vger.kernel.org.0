Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7180733DB9C
	for <lists+kvm@lfdr.de>; Tue, 16 Mar 2021 18:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbhCPRz2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Mar 2021 13:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239448AbhCPRzE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Mar 2021 13:55:04 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DA5C06174A
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 10:55:04 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q12so6845833plr.1
        for <kvm@vger.kernel.org>; Tue, 16 Mar 2021 10:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SXXfUbxitLxem4y5IOmlGNcXjSvMqPDKJf33Q5FpRTM=;
        b=WKpOqCF2yNa6NbXAk4agTwGEwEFghqxwPSDrHSduOe7200kg90HR301qhsVIL4nG5j
         Q1smXNi9Mrp30eaInSJYZBVYsBvKiKQRDvWi/i6cDWyScxsO+MiXkFDFP0ry9N4s4BbG
         o2TPjVS2zkSOujnaHEV8H1hCj8qI7Wg9GPEgH+tPbaOx33d+eTGEOT7eYwf34xrSnURM
         LjY85t36WyaTAyCPrPOegGaUlTcpzA50K+y04TTbp9kcHvQ5v0w7+loSfEQGSHVCIO/W
         2eCQ19e2xqhYCpfsh6asfu4Hu+rG/cypocGOEx+rf15jHeeuZEjLQz0K3cglGyn3jSTL
         1DJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SXXfUbxitLxem4y5IOmlGNcXjSvMqPDKJf33Q5FpRTM=;
        b=Zx6LZWLZ/AkYEt9+dUEO/DgQlSBZ02PglWKsPwGK7bd/DhspSTTpVoKl1DY+k3TAxY
         yhI5ZjX58feEPW4nUaLhxhGxWB8+FCjqjdQR7/u+SBkixRiWiN5w9+rb6sHR2kqfLzMX
         A2YeLwqsw/khiNSx3m/kQ60/aUQRxtoEQ47qfzWqTZaLzVio7kcni/1U9s/uHCvoifnA
         g+a4mi2iHGcYlGyjlFLW2EgyG0rH2qUdD3dpAz48PQ99TNflrRYYFfAO91RMvAtfoxmW
         M978ER0mTZKJgybdgxnJqgsmlERT2xYDbrx9LuZoujfELNA5efxu3vJ9TdyZzmLqsFHT
         z7Kg==
X-Gm-Message-State: AOAM5334g3vztQ2z7DB4ckjg4pEiWT1AC/C1wa2pNcr6CoNtWw5iDu0L
        ntCudKL7HITfUs37B6JKU6zsFULItpXVBA==
X-Google-Smtp-Source: ABdhPJz8/SDeSpcGidRjCZbld8vpoMWRnFLtdVkni4anFrrGeMm2W+Kiyse612dNA+S0YGp1yo8nxQ==
X-Received: by 2002:a17:90a:b007:: with SMTP id x7mr231047pjq.27.1615917303570;
        Tue, 16 Mar 2021 10:55:03 -0700 (PDT)
Received: from google.com ([2620:15c:f:10:e113:95c2:2d1:e304])
        by smtp.gmail.com with ESMTPSA id v1sm97126pjt.1.2021.03.16.10.55.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 10:55:02 -0700 (PDT)
Date:   Tue, 16 Mar 2021 10:54:56 -0700
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v3 2/4] KVM: x86/mmu: Fix RCU usage when atomically
 zapping SPTEs
Message-ID: <YFDw8CL1kvVbE90Z@google.com>
References: <20210315233803.2706477-1-bgardon@google.com>
 <20210315233803.2706477-3-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315233803.2706477-3-bgardon@google.com>
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
