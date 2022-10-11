Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB8005FAB78
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 05:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbiJKD4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Oct 2022 23:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiJKD4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Oct 2022 23:56:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C857437D
        for <kvm@vger.kernel.org>; Mon, 10 Oct 2022 20:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665460594;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jT4B4+nLwhdk058DSBmtM9jFtuoC91qYN182nNDbcXQ=;
        b=gJAP3yfXsQ/9maCYCf9HSdd9S5WR/HGarnAj8qCDLICaB+aTHR8fy1vccWjYWrKwLq6+sT
        NXyasSzbv5iC3ib61ceC1FK5gSI+DPcFq0CC/chk/iVWAk87LP3wRkI23JutiAFTGtMXRj
        yylwmTrKsax4C2v/znH5KKAVRrJyU6E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10-_wXVCgQ1PsCtvVyJaUGwOg-1; Mon, 10 Oct 2022 23:56:30 -0400
X-MC-Unique: _wXVCgQ1PsCtvVyJaUGwOg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 5A927185A792;
        Tue, 11 Oct 2022 03:56:29 +0000 (UTC)
Received: from [10.64.54.52] (vpn2-54-52.bne.redhat.com [10.64.54.52])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C646404CD98;
        Tue, 11 Oct 2022 03:56:23 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v5 3/7] KVM: x86: Allow to use bitmap in ring-based dirty
 page tracking
To:     Oliver Upton <oliver.upton@linux.dev>, Peter Xu <peterx@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, seanjc@google.com, shan.gavin@gmail.com
References: <20221005004154.83502-1-gshan@redhat.com>
 <20221005004154.83502-4-gshan@redhat.com> <Yz86gEbNflDpC8As@x1n>
 <a5e291b9-e862-7c71-3617-1620d5a7d407@redhat.com> <Y0A4VaSwllsSrVxT@x1n>
 <Y0SoX2/E828mbxuf@google.com> <Y0SvexjbHN78XVcq@xz-m1.local>
 <Y0SxnoT5u7+1TCT+@google.com> <Y0S2zY4G7jBxVgpu@xz-m1.local>
 <Y0TDCxfVVme8uPGU@google.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <6440b74c-9ebc-12f4-dd4e-469376a434f2@redhat.com>
Date:   Tue, 11 Oct 2022 11:56:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <Y0TDCxfVVme8uPGU@google.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/11/22 9:12 AM, Oliver Upton wrote:
> On Mon, Oct 10, 2022 at 08:20:29PM -0400, Peter Xu wrote:
>> On Mon, Oct 10, 2022 at 11:58:22PM +0000, Oliver Upton wrote:
>>> I think this further drives the point home -- there's zero need for the
>>> bitmap with dirty ring on x86, so why even support it? The proposal of
>>> ALLOW_BITMAP && DIRTY_RING should be arm64-specific. Any other arch that
>>> needs to dirty memory outside of a vCPU context can opt-in to the
>>> behavior.
>>
>> Yeah that sounds working too, but it'll be slightly hackish as then the
>> user app will need some "#ifdef ARM64" blocks for e.g. sync dirty bitmap.
>> With the new cap the user app can implement the whole ring with generic
>> code.
> 
> Isn't the current route of exposing ALLOW_BITMAP on other arches for no
> reason headed in exactly that direction? Userspace would need to know if
> it _really_ needs the dirty bitmap in addition to the dirty ring, which
> could take the form of architecture ifdeffery.
> 
> OTOH, if the cap is only exposed when it is absolutely necessary, an
> arch-generic live migration implementation could enable the cap whenever
> it is advertized and scan the bitmap accordingly.
> 
> The VMM must know something about the architecture it is running on, as
> it calls KVM_DEV_ARM_ITS_SAVE_TABLES after all...
> 

It looks good to me by using CONFIG_HAVE_KVM_DIRTY_RING_USE_BITMAP to
opt-in KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP. The most important point is
to ensure 'kvm->dirty_ring_with_bitmap == true' when dirty ring capability
is enabled. In this way, we can fail early when KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP
isn't enabled on attempt to enable dirty ring capability.

If both of you agree, I will integrate the suggested code changes in
next respin, with necessary tweak.

- In kvm_vm_ioctl_enable_cap_generic(), 'kvm->dirty_ring_with_bitmap' is
   updated to 'true' unconditionally.

   static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
                                              struct kvm_enable_cap *cap)
   {
       :
       case KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP:
            kvm->dirty_ring_with_bitmap = true;
            return 0;
   }

- In mark_page_dirty_in_slot(), we need comprehensive checks like below.

   void mark_page_dirty_in_slot(struct kvm *kvm,
                                const struct kvm_memory_slot *memslot,
                                gfn_t gfn)
   {
#ifdef CONFIG_HAVE_KVM_DIRTY_RING
       if (WARN_ON_ONCE(vcpu && vcpu->kvm != kvm))
           return;

#ifndef CONFIG_HAVE_KVM_DIRTY_RING_WITH_BITMAP
       if (WARN_ON_ONCE(!vcpu))
           return;
#endif
#endif

   }

- Use kvm_dirty_ring_exclusive(), which was suggested by Peter before.
   The function is used in various spots to allow the dirty bitmap is
   created and accessed.

   bool kvm_dirty_ring_exclusive(struct kvm *kvm)
   {
       return kvm->dirty_ring_size && !kvm->dirty_ring_with_bitmap;
   }


>> Also more flexible to expose it as generic cap? E.g., one day x86 can
>> enable this too for whatever reason (even though I don't think so..).
> 
> I had imagined something like this patch where the arch opts-in to some
> generic construct if it *requires* the use of both the ring and bitmap
> (very rough sketch).
> 

Thanks,
Gavin



