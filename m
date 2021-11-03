Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B4AC4443D0
	for <lists+kvm@lfdr.de>; Wed,  3 Nov 2021 15:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhKCOuc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Nov 2021 10:50:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230282AbhKCOuc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Nov 2021 10:50:32 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E113DC061203
        for <kvm@vger.kernel.org>; Wed,  3 Nov 2021 07:47:55 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id u33so2567144pfg.8
        for <kvm@vger.kernel.org>; Wed, 03 Nov 2021 07:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C0wf2K0rKG8C1RSWcaFIUVVK/MmFwAdNj5eu/GP5eZg=;
        b=B9VpNWuxUqohM9ynGgVOtGz8t7EVldEXvn3TpJhPxTpkMNfKclNBrxgJdXzCq0J3Ep
         uWL792cWDfDzfIAEEqij34sAHWOzPFONgEN5oY3XdM3Z9T90FapJZn8rOwaJFelsuFXR
         GNNBiMkKbp7bWV0FyPlxCmbbFyFs/FJC6AOWaqUo89Vce/oTS/6ZKuvmPV8J3HtPVW7j
         de88q1nuq/CKP2qgl14Xr/dB72CqhnsXK7AcNa9DCMkHKx9I6wDsnCIGDHnDfpyaSmON
         l3onlOy36NkkWlhejiCAwar3Jx/gMyH+GKDuHmP9AbS9gcqx/shdiJUH1yBB4AFvHC98
         VjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C0wf2K0rKG8C1RSWcaFIUVVK/MmFwAdNj5eu/GP5eZg=;
        b=S2WbcvuF0FccLXKiESuAQ9FQs+I5P10C8Tsc/GIWC70BJGV8emMliwHNzYGacCgRhu
         7Nb/XJ2cnPfcLLusouPiQSdEx1lh/7KLBXr95OedrtaOgLDPxEuzRQ5fYytFHc35E8OK
         fim6hPc+dYWCdI7Ks+RJVC9DcZQsP3uGVXwAYVkMfI88WIaw4sWgh+jJjM9Ysga4Cpw1
         DexwnhqrNikQSIVcgjcq3WuyJV6bPobE2sL7DDIFtDIysTQ34qaMQDuHZ8qzTpBQsJFt
         sOBxzh8dt+PMeAm5b2athsToDjrb4nmVAkEfiLHcN6X6/H5ZDKOlGauedkYC/SLVJBQP
         xshQ==
X-Gm-Message-State: AOAM532Qj1B+BKwWT9Ca0qlvx4lbchvApRgH+EhdrvZR2pvZS0p6RJWS
        5kuva0gcxXPgDYJGZzrA3bxwJA==
X-Google-Smtp-Source: ABdhPJzlbiudLiylGp+N6jM6RDpt8UXV/HrVtNYeDnS3T2Pwf6PWIN+DJCztrwLJs+wcqW2qDqMztw==
X-Received: by 2002:a63:556:: with SMTP id 83mr22917640pgf.222.1635950874972;
        Wed, 03 Nov 2021 07:47:54 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id e24sm2586994pfn.8.2021.11.03.07.47.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 07:47:54 -0700 (PDT)
Date:   Wed, 3 Nov 2021 14:47:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 01/13] KVM: x86: Cache total page count to avoid
 traversing the memslot array
Message-ID: <YYKhFhoSa/8SHxJB@google.com>
References: <cover.1632171478.git.maciej.szmigiero@oracle.com>
 <d07f07cdd545ab1a495a9a0da06e43ad97c069a2.1632171479.git.maciej.szmigiero@oracle.com>
 <YW9Fi128rYxiF1v3@google.com>
 <e618edce-b310-6d9a-3860-d7f4d8c0d98f@maciej.szmigiero.name>
 <YXBnn6ZaXbaqKvOo@google.com>
 <YYBqMipZT9qcwDMt@google.com>
 <8017cf9d-2b03-0c27-b78a-41b3d03c308b@maciej.szmigiero.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8017cf9d-2b03-0c27-b78a-41b3d03c308b@maciej.szmigiero.name>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 03, 2021, Maciej S. Szmigiero wrote:
> Capping total n_memslots_pages makes sense to me to avoid the (existing)
> nr_mmu_pages wraparound issue, will update the next patchset version
> accordingly.

No need to do it yourself.  I have a reworked version of the series with a bunch
of cleanups before and after the meat of your series, as well non-functional changes
(hopefully) to the "Resolve memslot ID via a hash table" and "Keep memslots in
tree-based structures" to avoid all the swap() behavior and to provide better
continuity between the aforementioned patches.  Unless something goes sideways in
the last few touchups, I'll get it posted today.
