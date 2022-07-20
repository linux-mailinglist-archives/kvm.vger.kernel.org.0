Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE64057BB58
	for <lists+kvm@lfdr.de>; Wed, 20 Jul 2022 18:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240860AbiGTQWC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jul 2022 12:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240332AbiGTQV7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Jul 2022 12:21:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 75B3261B0C
        for <kvm@vger.kernel.org>; Wed, 20 Jul 2022 09:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658334115;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RNk6IAipo4mh8LBH8MtO8K18i9SdfeqIGL3OSdVhBzg=;
        b=baJ5f2YOzwaFeqAvuQVYhAM+XQp9IG21OiA7wLswgsgEgySmmtBMoBcrN3cNF9ksYII6zL
        6IIEkr/p06anJU+I4IxvdQDxZ8RU8IsUg4EKjnz+C5nIOsgYAkl69JxYEUG9jlEcgBVvFo
        72H2gOUjpHVUyqHT77fetn0tsGTEalQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-120-RHYrurhEO5S1XqoXofI7Cw-1; Wed, 20 Jul 2022 12:21:49 -0400
X-MC-Unique: RHYrurhEO5S1XqoXofI7Cw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1877A8037AF;
        Wed, 20 Jul 2022 16:21:49 +0000 (UTC)
Received: from localhost (unknown [10.39.193.129])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B2D4E2026614;
        Wed, 20 Jul 2022 16:21:48 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Collingbourne <pcc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Michael Roth <michael.roth@amd.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: support MTE in protected VMs
In-Reply-To: <CAMn1gO65DJs8QyMs4YTmq7_b01qjLgBRhM3OLZ7aKaobEGMXDw@mail.gmail.com>
Organization: Red Hat GmbH
References: <20220708212106.325260-1-pcc@google.com>
 <877d49p36n.fsf@redhat.com>
 <CAMn1gO65DJs8QyMs4YTmq7_b01qjLgBRhM3OLZ7aKaobEGMXDw@mail.gmail.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Wed, 20 Jul 2022 18:21:47 +0200
Message-ID: <87k087oiuc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 19 2022, Peter Collingbourne <pcc@google.com> wrote:

> On Tue, Jul 19, 2022 at 7:50 AM Cornelia Huck <cohuck@redhat.com> wrote:
>>
>> On Fri, Jul 08 2022, Peter Collingbourne <pcc@google.com> wrote:
>>
>> > Hi,
>> >
>> > This patch series contains a proposed extension to pKVM that allows MTE
>> > to be exposed to the protected guests. It is based on the base pKVM
>> > series previously sent to the list [1] and later rebased to 5.19-rc3
>> > and uploaded to [2].
>> >
>> > This series takes precautions against host compromise of the guests
>> > via direct access to their tag storage, by preventing the host from
>> > accessing the tag storage via stage 2 page tables. The device tree
>> > must describe the physical memory address of the tag storage, if any,
>> > and the memory nodes must declare that the tag storage location is
>> > described. Otherwise, the MTE feature is disabled in protected guests.
>> >
>> > Now that we can easily do so, we also prevent the host from accessing
>> > any unmapped reserved-memory regions without a driver, as the host
>> > has no business accessing that memory.
>> >
>> > A proposed extension to the devicetree specification is available at
>> > [3], a patched version of QEMU that produces the required device tree
>> > nodes is available at [4] and a patched version of the crosvm hypervisor
>> > that enables MTE is available at [5].
>>
>> I'm unsure how this is supposed to work with QEMU + KVM, as your QEMU
>> patch adds mte-alloc properties to regions that are exposed as a
>> separate address space (which will not work with KVM). Is the magic in
>> that new shared section?
>
> Hi Cornelia,
>
> The intent is that the mte-alloc property may be set on memory whose
> allocation tag storage is not directly accessible via physical memory,
> since in this case there is no need for the hypervisor to do anything
> to protect allocation tag storage before exposing MTE to guests. In
> the case of QEMU + KVM, I would expect the emulated system to not
> expose the allocation tag storage directly, in which case it would be
> able to set mte-alloc on all memory nodes without further action,
> exactly as my patch implements for TCG. With the interface as
> proposed, QEMU would need to reject the mte-shared-alloc option when
> KVM is enabled, as there is currently no mechanism for KVM-accelerated
> virtualized tag storage.

Ok, that makes sense.

>
> Note that these properties are only relevant for guest kernels running
> under an emulated EL2 in which pKVM could conceivably run, which means
> that the host would need to implement FEAT_NV2. As far as I know there
> is currently no support for NV2 neither in QEMU TCG nor in the Linux
> kernel, and I'm unaware of any available hardware that supports both
> NV2 and MTE, so it'll be a while before any of this becomes relevant.

Nod.

I'm mostly interested because I wanted to figure out how this feature
might interact with enabling MTE for QEMU+KVM. I'll keep it in mind.

Thanks!

