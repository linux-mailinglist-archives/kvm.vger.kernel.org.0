Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F306666B0D3
	for <lists+kvm@lfdr.de>; Sun, 15 Jan 2023 12:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjAOL5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 06:57:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbjAOL5N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 06:57:13 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B327798
        for <kvm@vger.kernel.org>; Sun, 15 Jan 2023 03:56:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673783787;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lSQrPdLV6G9z2amp0pJ8LQmTnVYoXS9uDkE1TGTw7hM=;
        b=Il+xTSd6CFDuAiSEEgxqUQwb5K02AhOjf/yfHTvBBdMhWP43ceTb82ki+W3qAOlHQbKfp0
        i7X646H8Bvv7UaRJXK/pLt7bWCEKP1ekrQ8YFrSd9VF8NcG3ut1tWUY+6K144MqqY/dkUv
        kWtGumFIAhLXxJDgMCHt0fBkD9kh0ac=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-r4liBy6fPke1AFfvW9QXWw-1; Sun, 15 Jan 2023 06:56:24 -0500
X-MC-Unique: r4liBy6fPke1AFfvW9QXWw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AA366185A794;
        Sun, 15 Jan 2023 11:56:23 +0000 (UTC)
Received: from [10.64.54.98] (vpn2-54-98.bne.redhat.com [10.64.54.98])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF8542026D4B;
        Sun, 15 Jan 2023 11:56:16 +0000 (UTC)
Reply-To: Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH v10 4/7] KVM: arm64: Enable ring-based dirty memory
 tracking
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, maz@kernel.org, seanjc@google.com,
        shuah@kernel.org, catalin.marinas@arm.com, andrew.jones@linux.dev,
        ajones@ventanamicro.com, bgardon@google.com, dmatlack@google.com,
        will@kernel.org, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        pbonzini@redhat.com, peterx@redhat.com, oliver.upton@linux.dev,
        zhenyzha@redhat.com, shan.gavin@gmail.com
References: <20221110104914.31280-1-gshan@redhat.com>
 <20221110104914.31280-5-gshan@redhat.com>
 <e28ede67-1bc4-fb1e-9bea-60cc9bd85190@huawei.com>
From:   Gavin Shan <gshan@redhat.com>
Message-ID: <e3414ca2-c4a6-07b5-df41-9999fdb2445a@redhat.com>
Date:   Sun, 15 Jan 2023 22:56:13 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <e28ede67-1bc4-fb1e-9bea-60cc9bd85190@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Zenghui,

On 1/15/23 10:20 PM, Zenghui Yu wrote:
> On 2022/11/10 18:49, Gavin Shan wrote:
>> Enable ring-based dirty memory tracking on ARM64:
>>
>>   - Enable CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL.
>>
>>   - Enable CONFIG_NEED_KVM_DIRTY_RING_WITH_BITMAP.
>>
>>   - Set KVM_DIRTY_LOG_PAGE_OFFSET for the ring buffer's physical page
>>     offset.
>>
>>   - Add ARM64 specific kvm_arch_allow_write_without_running_vcpu() to
>>     keep the site of saving vgic/its tables out of the no-running-vcpu
>>     radar.
> 
> And we have KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES.. On receiving it, the
> emulated VGIC will write all pending bits (if any) into pending tables
> (which reside in guest memory) and doesn't require a running vcpu
> context.
> 
> The no-running-vcpu WARN can be triggered with the
> kvm-unit-tests/its-pending-migration case. I run it using QEMU, which
> has nothing to do with the dirty ring atm.
> 
> Or are there already discussions about it that I haven't noticed?
> 
> |void mark_page_dirty_in_slot(struct kvm *kvm,
> |                 const struct kvm_memory_slot *memslot,
> |                 gfn_t gfn)
> |{
> |    WARN_ON_ONCE(!vcpu && !kvm_arch_allow_write_without_running_vcpu(kvm));
> 

It's a new case we never noticed. Could you please share the QEMU command lines
to start the guest? I need to reproduce the issue on my side firstly.

The fix would be simply to extending kvm->arch.vgic.save_its_tables_in_progress
from 'bool' to a bit map (e.g. kvm->arch.vgic.dirty_guest_memory_flags) and introduce
two separate flags for ITS table and VGIC3 pending bits separately. Alternatively,
we can also introduce another 'bool kvm->arch.vgic.save_vgic_v3_tables_in_progress'
to cover the new case.


Thanks,
Gavin

