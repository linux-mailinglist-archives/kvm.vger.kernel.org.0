Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD540464591
	for <lists+kvm@lfdr.de>; Wed,  1 Dec 2021 04:45:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244955AbhLADs6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 22:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhLADsv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 22:48:51 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD22C061746
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 19:45:31 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id s37so12447773pga.9
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 19:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OguKkgibJx2pCTUQ2tCxqwka6Uxy76Xdi47x9CCBEn8=;
        b=KPHLA9BhW5UhVpBxTUx98RG5YH9r8nNlfMM9Xy4vL9t2UReT7Z4NbvfFlBoNgJbc0Y
         K3Nw/5fFV//+6H+loZJlSuHkH9zMdeVkHwlW8XJzCaEsgLa3GT/Gb/HrC7EpGXk6X2am
         jn8xOs78y/PtkGGidPcI9KgTyPb0ok7Gg7oEHxPWaCZw6cCdtvC6RSyWlMcgQEomFuLR
         PQtIFYywB2WK29OdoC+4r75fq1zSOn4Qaz4ICmEr67CT0kA8rwbQyhdbrB/VzJRqNhfa
         6oeoUpeMAeq5Tm1xn7ZKZvXhtb/L/tER4zGWtEx5uHwAJ5jKCXv8nxjMni3MQxTjrgQq
         eAKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OguKkgibJx2pCTUQ2tCxqwka6Uxy76Xdi47x9CCBEn8=;
        b=TrXIAsdAfM+va/bDGNAvLU/JUokkbangORrRDjUgR3VpSs9VewBNcHtHmsW4Gnbscv
         j+HiTgIYLj5jdZTWAQ/MhRHrbYP++Mp/3cqCj4Z7LGLlIltAQVsZij9jI0xqDnibZuHM
         pVgldaBUJs55vDHf5cm8HNm6OEsPZ82K+0KNgyZ+1ZgwUQE/CXy4y2UqNT0uuofh/Hdh
         sAcMExfmHNhHvIX7MDBsjYE+2nVbwmHGQrwh5gdQMEcinnvUvZiW4ntWV9b8sGAk+Ff3
         auZNjX3f5gy4xAiZcu64E09ZyDvtBmEYb5DQdjow9OKngruDi/5piR/M+q1f2U4fv/vT
         pcIg==
X-Gm-Message-State: AOAM533zRxpE7vazHVtSsGnOOiXFCUTEqsQB8bhcdPQs5GjXcsbxTX8b
        H35u6Kt2huvSERYewqM126qhFw==
X-Google-Smtp-Source: ABdhPJzJ1yck47dY17+1HUakTMFxxWcRQpm2sFOZp9ygJXx4XlKeLbWCyS9f85yLP9dfdWUlgYJyNA==
X-Received: by 2002:a63:86c7:: with SMTP id x190mr2712146pgd.230.1638330330627;
        Tue, 30 Nov 2021 19:45:30 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c5sm3835589pjm.52.2021.11.30.19.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 19:45:30 -0800 (PST)
Date:   Wed, 1 Dec 2021 03:45:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
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
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        Ben Gardon <bgardon@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/29] KVM: Scalable memslots implementation
Message-ID: <Yabv1il1fAVcR0se@google.com>
References: <cover.1638304315.git.maciej.szmigiero@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1638304315.git.maciej.szmigiero@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
> 
> This series contains the sixth iteration of the scalable memslots patch set.
> It is based on Sean's version "5.5", but with integrated patches for issues
> that arose during its review round.
> 
> In addition to that, the kvm_for_each_memslot_in_gfn_range() implementation
> was reworked to return only strictly overlapping memslots and to use
> iterators.
> 
> However, I've dropped a similar kvm_for_each_memslot_in_hva_range() rework
> since the existing implementation was already returning only strictly
> overlapping memslots and it was already based on interval tree iterators,
> so wrapping them in another layer of iterators would only add unnecessary
> complexity.
> The code in this "for"-like macro is also self-contained and very simple,
> so let's keep it this way.

If kvm_for_each_memslot_in_hva_range() ever gains a user outside of kvm_main.c
it should definitely get an iterator container so that callers don't need to do
the container_of() stuff.  I'd still prefer a container even now, but it's not a
sticking point.
