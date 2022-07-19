Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E678657A266
	for <lists+kvm@lfdr.de>; Tue, 19 Jul 2022 16:50:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239323AbiGSOuu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 10:50:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238133AbiGSOuZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 10:50:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 00D4A108C
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 07:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658242221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jctjcs10cXLC6Fgs+ejM2KhG7RRpw0OENqiwSYLGZwM=;
        b=MrohsGH5lkxtHeRiTjObEkAw9wDdrJN1UCJOkfcyqa5A/dPjBQ9fnHm1h9yLNM7kCs0QZw
        SnnkDMwOowSecczrLgQjE2rsc3Ysnp226pGSxGn7gDR+U23E6AeQ601OKd6F+IIrSpXgOb
        89iBKllqiSfZc8ZKvFcGX/f21676HEM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-kkwaFwbkMtGGia0WGtTbbg-1; Tue, 19 Jul 2022 10:50:10 -0400
X-MC-Unique: kkwaFwbkMtGGia0WGtTbbg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5D11811E76;
        Tue, 19 Jul 2022 14:50:09 +0000 (UTC)
Received: from localhost (unknown [10.39.195.12])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63DF040CFD0A;
        Tue, 19 Jul 2022 14:50:09 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Collingbourne <pcc@google.com>, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: support MTE in protected VMs
In-Reply-To: <20220708212106.325260-1-pcc@google.com>
Organization: Red Hat GmbH
References: <20220708212106.325260-1-pcc@google.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Tue, 19 Jul 2022 16:50:08 +0200
Message-ID: <877d49p36n.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08 2022, Peter Collingbourne <pcc@google.com> wrote:

> Hi,
>
> This patch series contains a proposed extension to pKVM that allows MTE
> to be exposed to the protected guests. It is based on the base pKVM
> series previously sent to the list [1] and later rebased to 5.19-rc3
> and uploaded to [2].
>
> This series takes precautions against host compromise of the guests
> via direct access to their tag storage, by preventing the host from
> accessing the tag storage via stage 2 page tables. The device tree
> must describe the physical memory address of the tag storage, if any,
> and the memory nodes must declare that the tag storage location is
> described. Otherwise, the MTE feature is disabled in protected guests.
>
> Now that we can easily do so, we also prevent the host from accessing
> any unmapped reserved-memory regions without a driver, as the host
> has no business accessing that memory.
>
> A proposed extension to the devicetree specification is available at
> [3], a patched version of QEMU that produces the required device tree
> nodes is available at [4] and a patched version of the crosvm hypervisor
> that enables MTE is available at [5].

I'm unsure how this is supposed to work with QEMU + KVM, as your QEMU
patch adds mte-alloc properties to regions that are exposed as a
separate address space (which will not work with KVM). Is the magic in
that new shared section?

>
> v2:
> - refcount the PTEs owned by NOBODY
>
> [1] https://lore.kernel.org/all/20220519134204.5379-1-will@kernel.org/
> [2] https://android-kvm.googlesource.com/linux/ for-upstream/pkvm-base-v2
> [3] https://github.com/pcc/devicetree-specification mte-alloc
> [4] https://github.com/pcc/qemu mte-shared-alloc
> [5] https://chromium-review.googlesource.com/c/chromiumos/platform/crosvm/+/3719324
>
> Peter Collingbourne (3):
>   KVM: arm64: add a hypercall for disowning pages
>   KVM: arm64: disown unused reserved-memory regions
>   KVM: arm64: allow MTE in protected VMs if the tag storage is known
>
>  arch/arm64/include/asm/kvm_asm.h              |  1 +
>  arch/arm64/include/asm/kvm_host.h             |  6 ++
>  arch/arm64/include/asm/kvm_pkvm.h             |  4 +-
>  arch/arm64/kernel/image-vars.h                |  3 +
>  arch/arm64/kvm/arm.c                          | 83 ++++++++++++++++++-
>  arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  1 +
>  arch/arm64/kvm/hyp/include/nvhe/pkvm.h        |  1 +
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c            |  9 ++
>  arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 11 +++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c                |  8 +-
>  arch/arm64/kvm/mmu.c                          |  4 +-
>  11 files changed, 123 insertions(+), 8 deletions(-)

