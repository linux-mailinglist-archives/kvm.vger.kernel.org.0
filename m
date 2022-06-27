Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9F455DD19
	for <lists+kvm@lfdr.de>; Tue, 28 Jun 2022 15:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237335AbiF0Pzo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jun 2022 11:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236563AbiF0Pzn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jun 2022 11:55:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1120026F1
        for <kvm@vger.kernel.org>; Mon, 27 Jun 2022 08:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656345341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HuLM69wVueZYYIAkbfqpnLdfUqCDZ1pi8iyqjjngfEM=;
        b=hqlq9dz/afRjmgRiYQ0+f0iDo77pfK9gNCP5k3O+Ise0ED2UgRrmA/+9SN+eIdOEMqcG0x
        fgVhSadh3wnk+w7CLUHzY9WLyAahxQ82/w437CA89OU71sxFDMSvAvnohRLIFsN0OivAHb
        EilMHdZUAiY50JCEgNH7yIlK5Xbsdus=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-296-xBsmTYLoN0ep9wZPhvZvJA-1; Mon, 27 Jun 2022 11:55:36 -0400
X-MC-Unique: xBsmTYLoN0ep9wZPhvZvJA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D72CE3C11E6A;
        Mon, 27 Jun 2022 15:55:35 +0000 (UTC)
Received: from localhost (unknown [10.39.192.87])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 709C5492CA3;
        Mon, 27 Jun 2022 15:55:35 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Steven Price <steven.price@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Peter Collingbourne <pcc@google.com>
Cc:     kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
        kvm@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        linux-arm-kernel@lists.infradead.org,
        Michael Roth <michael.roth@amd.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Will Deacon <will@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>
Subject: Re: [PATCH] KVM: arm64: permit MAP_SHARED mappings with MTE enabled
In-Reply-To: <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
Organization: Red Hat GmbH
References: <20220623234944.141869-1-pcc@google.com>
 <YrXu0Uzi73pUDwye@arm.com> <14f2a69e-4022-e463-1662-30032655e3d1@arm.com>
User-Agent: Notmuch/0.36 (https://notmuchmail.org)
Date:   Mon, 27 Jun 2022 17:55:33 +0200
Message-ID: <875ykmcd8q.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[I'm still in the process of trying to grok the issues surrounding
MTE+KVM, so apologies in advance if I'm muddying the waters]

On Sat, Jun 25 2022, Steven Price <steven.price@arm.com> wrote:

> On 24/06/2022 18:05, Catalin Marinas wrote:
>> + Steven as he added the KVM and swap support for MTE.
>> 
>> On Thu, Jun 23, 2022 at 04:49:44PM -0700, Peter Collingbourne wrote:
>>> Certain VMMs such as crosvm have features (e.g. sandboxing, pmem) that
>>> depend on being able to map guest memory as MAP_SHARED. The current
>>> restriction on sharing MAP_SHARED pages with the guest is preventing
>>> the use of those features with MTE. Therefore, remove this restriction.
>> 
>> We already have some corner cases where the PG_mte_tagged logic fails
>> even for MAP_PRIVATE (but page shared with CoW). Adding this on top for
>> KVM MAP_SHARED will potentially make things worse (or hard to reason
>> about; for example the VMM sets PROT_MTE as well). I'm more inclined to
>> get rid of PG_mte_tagged altogether, always zero (or restore) the tags
>> on user page allocation, copy them on write. For swap we can scan and if
>> all tags are 0 and just skip saving them.
>> 
>> Another aspect is a change in the KVM ABI with this patch. It's probably
>> not that bad since it's rather a relaxation but it has the potential to
>> confuse the VMM, especially as it doesn't know whether it's running on
>> older kernels or not (it would have to probe unless we expose this info
>> to the VMM in some other way).

Which VMMs support KVM+MTE so far? (I'm looking at adding support in QEMU.)

>> 
>>> To avoid races between multiple tasks attempting to clear tags on the
>>> same page, introduce a new page flag, PG_mte_tag_clearing, and test-set it
>>> atomically before beginning to clear tags on a page. If the flag was not
>>> initially set, spin until the other task has finished clearing the tags.
>> 
>> TBH, I can't mentally model all the corner cases, so maybe a formal
>> model would help (I can have a go with TLA+, though not sure when I find
>> a bit of time this summer). If we get rid of PG_mte_tagged altogether,
>> this would simplify things (hopefully).
>> 
>> As you noticed, the problem is that setting PG_mte_tagged and clearing
>> (or restoring) the tags is not an atomic operation. There are places
>> like mprotect() + CoW where one task can end up with stale tags. Another
>> is shared memfd mappings if more than one mapping sets PROT_MTE and
>> there's the swap restoring on top.
>> 
>>> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
>>> index f6b00743c399..8f9655053a9f 100644
>>> --- a/arch/arm64/kernel/mte.c
>>> +++ b/arch/arm64/kernel/mte.c
>>> @@ -57,7 +57,18 @@ static void mte_sync_page_tags(struct page *page, pte_t old_pte,
>>>  	 * the new page->flags are visible before the tags were updated.
>>>  	 */
>>>  	smp_wmb();
>>> -	mte_clear_page_tags(page_address(page));
>>> +	mte_ensure_page_tags_cleared(page);
>>> +}
>>> +
>>> +void mte_ensure_page_tags_cleared(struct page *page)
>>> +{
>>> +	if (test_and_set_bit(PG_mte_tag_clearing, &page->flags)) {
>>> +		while (!test_bit(PG_mte_tagged, &page->flags))
>>> +			;
>>> +	} else {
>>> +		mte_clear_page_tags(page_address(page));
>>> +		set_bit(PG_mte_tagged, &page->flags);
>>> +	}
>
> I'm pretty sure we need some form of barrier in here to ensure the tag
> clearing is visible to the other CPU. Otherwise I can't immediately see
> any problems with the approach of a second flag (it was something I had
> considered). But I do also think we should seriously consider Catalin's
> approach of simply zeroing tags unconditionally - it would certainly
> simplify the code.

What happens in kvm_vm_ioctl_mte_copy_tags()? I think we would just end
up copying zeroes?

That said, do we make any assumptions about when KVM_ARM_MTE_COPY_TAGS
will be called? I.e. when implementing migration, it should be ok to
call it while the vm is paused, but you probably won't get a consistent
state while the vm is running?

[Postcopy needs a different interface, I guess, so that the migration
target can atomically place a received page and its metadata. I see
https://lore.kernel.org/all/CAJc+Z1FZxSYB_zJit4+0uTR-88VqQL+-01XNMSEfua-dXDy6Wg@mail.gmail.com/;
has there been any follow-up?]

