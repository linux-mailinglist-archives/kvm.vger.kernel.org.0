Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAFA7A4E06
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 18:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229675AbjIRQFN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 12:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbjIRQFI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 12:05:08 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21FE4698
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:03:54 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-64cca551ae2so28298476d6.0
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 09:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695052995; x=1695657795; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1AtaBW2SsBllDiJ99v10Ny7HNDE5iUEtI8mOBYM/rVQ=;
        b=QcT8VRQR0nVk6/rpvToRMTGkj1JnIolzTymFJ+HOZps7wbKs57hP8AymhKiO/C7+NF
         cly+sa77kUZvBl2zOLDMBGEpIutrPSd8cngVV6W0o3COHx+OZZFIGIiWqrtnuOiSbooZ
         avrCxZS+yY1zFMpM1/Li9lf+YyIb7QaXy0UHb1H5c0J5pxycyus+EwneOm3Hd49K/3LI
         cOYZX3SVgP4TRI2P11J0DtXIGjJRb6MIAeEoC35A0SMuhXirC1PisWBgSBBSowb9Q/k1
         +9RR27cfzUZ2uCqiO65xO/LU0dnHjWfo+wANnZh9dCpurKRHFRhN+Rwv0zn0B0+KR+++
         rOYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695052995; x=1695657795;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1AtaBW2SsBllDiJ99v10Ny7HNDE5iUEtI8mOBYM/rVQ=;
        b=rMMafUIoej9RIdYlzO6rRdD5gw7j4ji8XUXkPaPRipjommNyw8n1U5NwwxpxGfRwU2
         uSUNdxj4GU7913/3Zva5GaYqe0VvoLPV0HUV/WMaDRRzBwZ1AAemNCF1YrK4ko72xf2L
         R/Z3RJQjYyEFOFzxClXVlwBJTAt8jAMT1j/CmDdaa39rXGut8bKqDNydg3IkMvEdsvdw
         gk4zdt3ZYq+QV++/MtUEEqQcjLEhaVCW+66T2F3vZSBrMstnGMJfxGPo/3F9YKTtb2jq
         +mYJ8UKLqWO6yJJFCb/OAwsXTm76pahXe9Q3/TvLxOzXOKG+JuIsnDJmrigydJFeadm1
         Kv7A==
X-Gm-Message-State: AOJu0Yz28aeD4mirWZgHfp3HvVBuppW4zM9DeCyf1zTPrmx2qcyWSkS4
        KXuCQxzulwlqQcVLkuIYxTcvwQ==
X-Google-Smtp-Source: AGHT+IH/YnREI891cZLYoBidRStzCIsQeTayS2VX/iNCJzxAWIRbDBhzALGmOqWbEj1DKL9seHAlIw==
X-Received: by 2002:a0c:eacf:0:b0:655:78f5:bef7 with SMTP id y15-20020a0ceacf000000b0065578f5bef7mr9471806qvp.21.1695052995341;
        Mon, 18 Sep 2023 09:03:15 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id u20-20020a0cdd14000000b006581e82a628sm989437qvk.134.2023.09.18.09.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 09:03:14 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qiGiA-0005k6-DG;
        Mon, 18 Sep 2023 13:02:58 -0300
Date:   Mon, 18 Sep 2023 13:02:58 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Oliver Upton <oliver.upton@linux.dev>,
        Huacai Chen <chenhuacai@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Anish Ghulati <aghulati@google.com>,
        Venkatesh Srinivas <venkateshs@chromium.org>,
        Andrew Thornton <andrewth@google.com>
Subject: Re: [PATCH 05/26] vfio: KVM: Pass get/put helpers from KVM to VFIO,
 don't do circular lookup
Message-ID: <20230918160258.GL13795@ziepe.ca>
References: <20230916003118.2540661-1-seanjc@google.com>
 <20230916003118.2540661-6-seanjc@google.com>
 <20230918152110.GI13795@ziepe.ca>
 <ZQhxpesyXeG+qbS6@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQhxpesyXeG+qbS6@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 18, 2023 at 08:49:57AM -0700, Sean Christopherson wrote:
> On Mon, Sep 18, 2023, Jason Gunthorpe wrote:
> > On Fri, Sep 15, 2023 at 05:30:57PM -0700, Sean Christopherson wrote:
> > > Explicitly pass KVM's get/put helpers to VFIO when attaching a VM to
> > > VFIO instead of having VFIO do a symbol lookup back into KVM.  Having both
> > > KVM and VFIO do symbol lookups increases the overall complexity and places
> > > an unnecessary dependency on KVM (from VFIO) without adding any value.
> > > 
> > > Signed-off-by: Sean Christopherson <seanjc@google.com>
> > > ---
> > >  drivers/vfio/vfio.h      |  2 ++
> > >  drivers/vfio/vfio_main.c | 74 +++++++++++++++++++---------------------
> > >  include/linux/vfio.h     |  4 ++-
> > >  virt/kvm/vfio.c          |  9 +++--
> > >  4 files changed, 47 insertions(+), 42 deletions(-)
> > 
> > I don't mind this, but Christoph had disliked my prior attempt to do
> > this with function pointers..
> > 
> > The get can be inlined, IIRC, what about putting a pointer to the put
> > inside the kvm struct?
> 
> That wouldn't allow us to achieve our goal, which is to hide the details of
> "struct kvm" from VFIO (and the rest of the kernel).

> What's the objection to handing VFIO a function pointer?

Hmm, looks like it was this thread:

 https://lore.kernel.org/r/0-v1-33906a626da1+16b0-vfio_kvm_no_group_jgg@nvidia.com

Your rational looks a little better to me.

> > The the normal kvm get/put don't have to exported symbols at all?
> 
> The export of kvm_get_kvm_safe() can go away (I forgot to do that in this series),
> but kvm_get_kvm() will hang around as it's needed by KVM sub-modules (PPC and x86),
> KVMGT (x86), and drivers/s390/crypto/vfio_ap_ops.c (no idea what to call that beast).

My thought would be to keep it as an inline, there should be some way
to do that without breaking your desire to hide the bulk of the kvm
struct content. Like put the refcount as the first element in the
struct and just don't ifdef it away?.

Jason
