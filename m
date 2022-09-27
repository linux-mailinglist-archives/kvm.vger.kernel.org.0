Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A17A5ECC15
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 20:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiI0SVQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 14:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiI0SVL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 14:21:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51903F5097
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 11:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664302866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QY/wexCISEH5Yn9ulasiSSxdGASp9NhnFDcBt09AGSE=;
        b=FSiWTXLyBKR4+rHrpsZ6BEgnS7Clas3WxECMiVgnbL02lCbvKbGRHXhTx3aojQY6hrkT4u
        s6zU+IS8qD9gAuYpAywrMoFGbNxaHMivkthzdKB88CycgQpmwBkFUqs9an/3WyDzm9oKl0
        dIzz1dLTu928NRsmt+NM9WdbSJLUn98=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-171-bjd58P5UPnew1IbPYs0Jqw-1; Tue, 27 Sep 2022 14:21:05 -0400
X-MC-Unique: bjd58P5UPnew1IbPYs0Jqw-1
Received: by mail-qt1-f197.google.com with SMTP id fx6-20020a05622a4ac600b0035a70ba1cbcso7430900qtb.21
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 11:21:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=QY/wexCISEH5Yn9ulasiSSxdGASp9NhnFDcBt09AGSE=;
        b=op0bcsLMSfctpSa/O1KtjppybJrxcVwnPBxJfgr3Cysj5P+dq84Ej8V3ewQ2KlTTYA
         TfQgAdILwohbj+s8zflkffvmrbv524HvZNQVZTzNLHkodjBmIZS0o2m/LAXGzb2GqJ4Q
         9qEmTzvc1c0OEny1ihVyWkv6aiZOzmxP+FEZbJWSJk0wxkvaaA//yrTFih80MO8AJmX6
         VISPTWUmVJtKHErZj/ir/eoEUxCV6StA4/aMKsSR3rcsjeripEvPRroAGQnxKCIJFBeI
         PwenWIPOHfl8w65FpZAipJdI8sDWb9wdmf5jjqqIzEhC9K6sZRzN2PSpgx56WFdjJrWc
         +log==
X-Gm-Message-State: ACrzQf14+a7lY2gZ/HexFdQH5nkGm/zg/cRWK9497Un/P9IXP+MS9FWu
        oJWa0oESyEW14SeoYjupmvdhFRRI4EPDgGiAEUqKUEyU37roFE3rZIGyNK+H1skY5S5wMw8mUCQ
        ir0EvhMhMB8zv
X-Received: by 2002:a05:620a:1929:b0:6ce:f8b0:6de0 with SMTP id bj41-20020a05620a192900b006cef8b06de0mr19149808qkb.489.1664302864488;
        Tue, 27 Sep 2022 11:21:04 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6tmXzpi6e6VsMU3bm+k4T40OUsVM/7nTV5fmstSLxyFluQ1CU5YAxtcJF6kpYrDafr4b9odw==
X-Received: by 2002:a05:620a:1929:b0:6ce:f8b0:6de0 with SMTP id bj41-20020a05620a192900b006cef8b06de0mr19149790qkb.489.1664302864293;
        Tue, 27 Sep 2022 11:21:04 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id a2-20020ac81082000000b0035d1f846b91sm1214262qtj.64.2022.09.27.11.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 11:21:03 -0700 (PDT)
Date:   Tue, 27 Sep 2022 14:21:00 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Gavin Shan <gshan@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, catalin.marinas@arm.com, bgardon@google.com,
        shuah@kernel.org, andrew.jones@linux.dev, will@kernel.org,
        dmatlack@google.com, pbonzini@redhat.com, zhenyzha@redhat.com,
        shan.gavin@gmail.com, james.morse@arm.com, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, oliver.upton@linux.dev
Subject: Re: [PATCH v4 3/6] KVM: arm64: Enable ring-based dirty memory
 tracking
Message-ID: <YzM/DFV1TgtyRfCA@x1n>
References: <20220927005439.21130-1-gshan@redhat.com>
 <20220927005439.21130-4-gshan@redhat.com>
 <YzMerD8ZvhvnprEN@x1n>
 <86sfkc7mg8.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <86sfkc7mg8.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 27, 2022 at 01:32:07PM -0400, Marc Zyngier wrote:
> On Tue, 27 Sep 2022 12:02:52 -0400,
> Peter Xu <peterx@redhat.com> wrote:
> > 
> > On Tue, Sep 27, 2022 at 08:54:36AM +0800, Gavin Shan wrote:
> > > Enable ring-based dirty memory tracking on arm64 by selecting
> > > CONFIG_HAVE_KVM_DIRTY_RING_ACQ_REL and providing the ring buffer's
> > > physical page offset (KVM_DIRTY_LOG_PAGE_OFFSET).
> > > 
> > > Signed-off-by: Gavin Shan <gshan@redhat.com>
> > 
> > Gavin,
> > 
> > Any decision made on how to tackle with the GIC status dirty bits?
> 
> Which dirty bits? Are you talking of the per-RD pending bits?

Gavin found that some dirty pfn path may not have vcpu context for aarch64
offlist.

Borrowing Gavin's trace dump:

  el0t_64_sync
  el0t_64_sync_handler
  el0_svc
  do_el0_svc
  __arm64_sys_ioctl
  kvm_device_ioctl
  vgic_its_set_attr
  vgic_its_save_tables_v0
  kvm_write_guest
  __kvm_write_guest_page
  mark_page_dirty_in_slot

With current code it'll trigger the warning in mark_page_dirty_in_slot.

An userspace approach is doable by setting these pages as always dirty in
userspace (QEMU), but even if so IIUC we'll need to drop the warning
message in mark_page_dirty_in_slot() then we take no-vcpu dirty as no-op
and expected.

I'll leave the details to Gavin.

Thanks,

-- 
Peter Xu

