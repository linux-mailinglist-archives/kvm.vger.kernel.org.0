Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446DC57AB4D
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 03:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239226AbiGTBHM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jul 2022 21:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238171AbiGTBHK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Jul 2022 21:07:10 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186A948C87
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:07:09 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id d16so23974816wrv.10
        for <kvm@vger.kernel.org>; Tue, 19 Jul 2022 18:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RnduJRWap81e4hsQGNaqE2KBoYp4jqdU1O2gWYXksrg=;
        b=V3L6saNcxDkw3rVUZoKMT+z27A12bbuMUQUtYUo52WpG05ad/Q3Lae9kO9Ssfq5E+o
         YzXt4abwxGv+dwxD19q182Tuv+jEQ90ytCYm2jfFd5xxWwmkZBRohif67QZtCceM83oi
         NUU4ZOjD12l69pg3MEeq0C/RyCjh9aJsInnixGl/o8nH/XrKnDYI86aiat2qCbQxSf38
         THILLSqte2NlbrOatnLA0liVuydqbpDMtkQWGZdtcz8RmPPLV7Aq4cNotneTAkvZev6r
         y2dWrfTCTjX2uGv83f5rxxPvXeio8xcWjnvuLCng4BNiGhbO0l7uJp80yX01OHGv+h/M
         nrqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RnduJRWap81e4hsQGNaqE2KBoYp4jqdU1O2gWYXksrg=;
        b=AVARXi/Y4JPVkhqOo3G9P3maFSptJtl4h0KS1uhG3cL6WfkU2LTxfkKUTIJBQ5AamS
         0i1EFhUy8ya2kFE5sUrFVzo98gSiH/ywd58h/uq//JlZEUN/GGcOVjTOdfHn5zswRyAo
         VxYGkkHt/flzMIVeYAJ8v9IBdlemI2aKZKkIh+Ja4AT2FKN9nKrJ++GTFjAmuIUqOOHB
         OQcFAgzEO9mY9D0SBeRgbqZADAha0w5R4cSAHPWb7LjzAnGu1Nd7W1oyB6yovcfRCLpV
         BmAC3GuujFgR8F7E0Lvp99IAhjnuNmOysfBCOHAdKNlaKY18K074sZJdhMzMsHuFU8ud
         Ir4A==
X-Gm-Message-State: AJIora+TiydEYg5CKCDEmfWmnSVvPhtdsoR9396jkYbNWSMqJlHTRB/+
        65bX1v1WqOFU0fJoUpGbWYUy0RSvnub5dypMaVdduw==
X-Google-Smtp-Source: AGRyM1tjfS0I06AEG0F/LzOUouITmNkWGASNHqEfxR822WYDad6jgo6sBqyj7LcYSIIG+kLVswqWoffKMtf3O1YoCYM=
X-Received: by 2002:a05:6000:81d:b0:21d:a495:6e3 with SMTP id
 bt29-20020a056000081d00b0021da49506e3mr28760355wrb.502.1658279227451; Tue, 19
 Jul 2022 18:07:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220708212106.325260-1-pcc@google.com> <877d49p36n.fsf@redhat.com>
In-Reply-To: <877d49p36n.fsf@redhat.com>
From:   Peter Collingbourne <pcc@google.com>
Date:   Tue, 19 Jul 2022 18:06:55 -0700
Message-ID: <CAMn1gO65DJs8QyMs4YTmq7_b01qjLgBRhM3OLZ7aKaobEGMXDw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: support MTE in protected VMs
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Michael Roth <michael.roth@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 19, 2022 at 7:50 AM Cornelia Huck <cohuck@redhat.com> wrote:
>
> On Fri, Jul 08 2022, Peter Collingbourne <pcc@google.com> wrote:
>
> > Hi,
> >
> > This patch series contains a proposed extension to pKVM that allows MTE
> > to be exposed to the protected guests. It is based on the base pKVM
> > series previously sent to the list [1] and later rebased to 5.19-rc3
> > and uploaded to [2].
> >
> > This series takes precautions against host compromise of the guests
> > via direct access to their tag storage, by preventing the host from
> > accessing the tag storage via stage 2 page tables. The device tree
> > must describe the physical memory address of the tag storage, if any,
> > and the memory nodes must declare that the tag storage location is
> > described. Otherwise, the MTE feature is disabled in protected guests.
> >
> > Now that we can easily do so, we also prevent the host from accessing
> > any unmapped reserved-memory regions without a driver, as the host
> > has no business accessing that memory.
> >
> > A proposed extension to the devicetree specification is available at
> > [3], a patched version of QEMU that produces the required device tree
> > nodes is available at [4] and a patched version of the crosvm hypervisor
> > that enables MTE is available at [5].
>
> I'm unsure how this is supposed to work with QEMU + KVM, as your QEMU
> patch adds mte-alloc properties to regions that are exposed as a
> separate address space (which will not work with KVM). Is the magic in
> that new shared section?

Hi Cornelia,

The intent is that the mte-alloc property may be set on memory whose
allocation tag storage is not directly accessible via physical memory,
since in this case there is no need for the hypervisor to do anything
to protect allocation tag storage before exposing MTE to guests. In
the case of QEMU + KVM, I would expect the emulated system to not
expose the allocation tag storage directly, in which case it would be
able to set mte-alloc on all memory nodes without further action,
exactly as my patch implements for TCG. With the interface as
proposed, QEMU would need to reject the mte-shared-alloc option when
KVM is enabled, as there is currently no mechanism for KVM-accelerated
virtualized tag storage.

Note that these properties are only relevant for guest kernels running
under an emulated EL2 in which pKVM could conceivably run, which means
that the host would need to implement FEAT_NV2. As far as I know there
is currently no support for NV2 neither in QEMU TCG nor in the Linux
kernel, and I'm unaware of any available hardware that supports both
NV2 and MTE, so it'll be a while before any of this becomes relevant.

Peter
