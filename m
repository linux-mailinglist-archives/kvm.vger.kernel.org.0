Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9612346E021
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 02:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239072AbhLIBUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 20:20:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhLIBUB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Dec 2021 20:20:01 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F872C0617A1
        for <kvm@vger.kernel.org>; Wed,  8 Dec 2021 17:16:28 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v23so3219667pjr.5
        for <kvm@vger.kernel.org>; Wed, 08 Dec 2021 17:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ngoPwqqbhfOLLeyaWlockMByhsnvfUz95KBFPY/FjQE=;
        b=THMEvCQ4OgR2pWehVPf4SjhgrdSd0hwGC+zK3eOQX6gtv7UbSwvQZnNFnegvWv5SCl
         BN6nVQIemMjAC0X1lgvEubz33RbIClBv/bbS51nFydO17TKYOEeA/qEw9O5eugFQLQOO
         T8vWUQgc1p3bub/SpNfSLPraTa/vrsIyt142Eg4KVh/OZvCJ/duvL1aAhpbiovo+XzGc
         DCCy6cDK3JySX7UOlITdWRKpGeZzQDEDTyn2eOjY5WzIT+VJBczBwib04FlNNahwLU1q
         XR0yoRSsQFTsAe4hUQvyn7rqae8ZIYwonPlexVl9ZHco1YzI//sqilUpLp/0IqD2kFUL
         UxHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ngoPwqqbhfOLLeyaWlockMByhsnvfUz95KBFPY/FjQE=;
        b=rO/LJWjk6g9MSy+5YbR798K97bZiAzSKPggiIwVqNbaPj1B7vYNNnFbjOJx8KHoS/U
         HfN8f5haDu2EFlUb7HEycl6hRiLpUZ3oUjnG19fJ+ssOXYhU27QzkYd9+mxuqGV2tORe
         ZshMdkeBV9QpMEblqI2dS1in/664J+xlq1fCBA8LLjwnq33BWhVHMJ3AA4thWCyG7OPH
         ZmP+v3FwU+A/0vTWTPLhqHwWOqvkh+K6kO/mpVfzU4f7VIgCisiA1MeBPFaI3XF9SYFB
         /2oQPvm0JAKOWF1fErKea8waSvCC3PKsyibl58Rtdb8XhOb0/0efuJwVwwa9zIh5v4WI
         WMFg==
X-Gm-Message-State: AOAM531Pq/i55Eia+o+2+ozEE786lYtRAObvU3HshE5Cq4vCq0ccVr9v
        WprmG5juFCuVClLMoIFr4Hm+GQ==
X-Google-Smtp-Source: ABdhPJxsVffgoFVWKf4rmd52sXQPLLkExYCQayiNn1FIpOuQK1LnqxzzkxJ7jmZOXIFUuuYuPgXl2g==
X-Received: by 2002:a17:90b:4d08:: with SMTP id mw8mr11845971pjb.236.1639012587943;
        Wed, 08 Dec 2021 17:16:27 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q6sm3561347pgs.19.2021.12.08.17.16.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 17:16:27 -0800 (PST)
Date:   Thu, 9 Dec 2021 01:16:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH 1/12] KVM: X86: Fix when shadow_root_level=5 && guest
 root_level<4
Message-ID: <YbFY533IT3XSIqAK@google.com>
References: <20211124122055.64424-1-jiangshanlai@gmail.com>
 <20211124122055.64424-2-jiangshanlai@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124122055.64424-2-jiangshanlai@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 24, 2021, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> If the is an L1 with nNPT in 32bit, the shadow walk starts with
> pae_root.
> 
> Fixes: a717a780fc4e ("KVM: x86/mmu: Support shadowing NPT when 5-level paging is enabled in host)

Have you actually run with 5-level nNPT?  I don't have access to hardware, at least
not that I know of :-)

I'm staring at kvm_mmu_sync_roots() and don't see how it can possibly work for
5-level nNPT with a 4-level NPT guest.
