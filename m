Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0437A4BE0
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 17:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239718AbjIRPXR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 11:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238605AbjIRPXO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 11:23:14 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D48CF1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 08:21:36 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id af79cd13be357-76f08e302a1so302429485a.1
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 08:21:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1695050472; x=1695655272; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9iwt12QdmH2nPtcjR0iEq1G+1D18erLjJ1cQj58qe4I=;
        b=Q/2lfiKYNE/5K44PTGLhus4LlnlDi7yhqp/bgjYuFQ0srmDvs9Vtf+YrDz+IMsI1HW
         8WvtWWsMgjFnPgsBGQaoAkFmfzAva1/GK+AfQarXQ6qfMQV0DGj8+Gy8CfKOOwJovRTu
         k8biRM6eQ1SdamNDRhZcNmwefP1gxTQZAevYCGXlMHDNI02s5j/dcovffbbAJuSz5x79
         pvDtijN5fAs8mvNBahRLnCvozpxm7uSEkD1oz0Bb1GySdXnLQq9/IXTZRMsUXFfq74BR
         pKjFQ6T951q3tMjM6MNkEuZBLWQ3Yu/qzjivb8N9rDCwpFzpjjj9OFyIEvF2qF8qG2yP
         Fw0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695050472; x=1695655272;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9iwt12QdmH2nPtcjR0iEq1G+1D18erLjJ1cQj58qe4I=;
        b=ScdkoVJWNQhZ8kJNf6sRQHnRk+KyhZdQuLvOfg9SXfQ/2nA1oKEFrB8XTFJZZxWRyz
         vwuSrYJeTsuAHY3vD3u/jelRk2Ym91P1Fcub+BlwmJ9ERMbixnPVYPnplq66i0ilQT7C
         OvOGJgVBFekls56Gy0BFe+AGij/u60miQOL83eY5WLzORNTLdUJPMKVnMVjkWhg9Z9id
         A6oKijU6M/54YjHJWJhqLnVQejpMuj6lBtVo6GhHz4yg6WKSldf9vSF+scz6RnlvCcoR
         Ak1HWleq4tmD6t/WYi6JWzk9LDZyz5YPochIsMh05NA/d9ibJzlz6aXTlxl/4ZcwQ/3Q
         gKZQ==
X-Gm-Message-State: AOJu0YySl4YPwjlsvJan4gy6WCo34lCDI69MjrTEyvSdxrBZ8CbCJe/G
        q3JAB4XoF7srsQI+zYgP1mDGuw==
X-Google-Smtp-Source: AGHT+IEUJFa3aXEX1YodKfdMrwJPEEuzBhbA2hgycHy86i8DANtxQ0UmL29SlN96YZ1Wg+zGpbaj/w==
X-Received: by 2002:a05:620a:31a8:b0:76d:a110:856d with SMTP id bi40-20020a05620a31a800b0076da110856dmr11089993qkb.0.1695050471902;
        Mon, 18 Sep 2023 08:21:11 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-26-201.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.26.201])
        by smtp.gmail.com with ESMTPSA id i20-20020a05620a145400b0076f18be9a64sm3220186qkl.81.2023.09.18.08.21.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Sep 2023 08:21:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qiG3i-0005PK-IY;
        Mon, 18 Sep 2023 12:21:10 -0300
Date:   Mon, 18 Sep 2023 12:21:10 -0300
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
Message-ID: <20230918152110.GI13795@ziepe.ca>
References: <20230916003118.2540661-1-seanjc@google.com>
 <20230916003118.2540661-6-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230916003118.2540661-6-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 15, 2023 at 05:30:57PM -0700, Sean Christopherson wrote:
> Explicitly pass KVM's get/put helpers to VFIO when attaching a VM to
> VFIO instead of having VFIO do a symbol lookup back into KVM.  Having both
> KVM and VFIO do symbol lookups increases the overall complexity and places
> an unnecessary dependency on KVM (from VFIO) without adding any value.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/vfio/vfio.h      |  2 ++
>  drivers/vfio/vfio_main.c | 74 +++++++++++++++++++---------------------
>  include/linux/vfio.h     |  4 ++-
>  virt/kvm/vfio.c          |  9 +++--
>  4 files changed, 47 insertions(+), 42 deletions(-)

I don't mind this, but Christoph had disliked my prior attempt to do
this with function pointers..

The get can be inlined, IIRC, what about putting a pointer to the put
inside the kvm struct?

The the normal kvm get/put don't have to exported symbols at all?

Jason
