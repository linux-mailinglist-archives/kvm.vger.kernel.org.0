Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED03F462D79
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 08:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239030AbhK3Hbl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 02:31:41 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23085 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233413AbhK3Hbk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 30 Nov 2021 02:31:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638257301;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QYG0xlXta5uqZ69e7PNkPe7Wbsl/KNZHtSSSmrsdMFw=;
        b=PFx7Oh+p5R0dpQmGsS6sdUi+mK2wv6lJdJuz1MYgj297h8wvZr8+/KumA5IWy0duFNMnyk
        5Eexf8degRWrxDquD2cz06T4tvqftFxltIvRDl+6pUXLJNKNJ0+qRX+U8fVF+ziO9Ga9c/
        kyqH7x50FjeIAOsRvqWWCwCupWmzhnc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-20-I94cH0tEMPCq8hstjQ6wKA-1; Tue, 30 Nov 2021 02:28:18 -0500
X-MC-Unique: I94cH0tEMPCq8hstjQ6wKA-1
Received: by mail-wm1-f69.google.com with SMTP id z138-20020a1c7e90000000b003319c5f9164so13283587wmc.7
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 23:28:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QYG0xlXta5uqZ69e7PNkPe7Wbsl/KNZHtSSSmrsdMFw=;
        b=XlcxZ/oq9U/gLh73ulNPzu1BHlnFTxSM3w45b0BNyqDk7T014n3tEcJKMov643ec+5
         d4j3NtSLnHQIUMCn32ZN2UzO3qFVWtivAcJVH1HGmjSEanfluhQRNU29u/9ObH8qoBl/
         5lfIx7n8V5ZNnt9KT2UvQs4D1rElBoqJz6y2lqHUo53Fd999i+6UR1pmEVmz85i2+PtQ
         xpEAqCqYNSpNo2+xA/VG05pODfgGXrKyxrXFfuXjmPwP/ekkXm88C68duKuS7QlC57f3
         x83oKUMD8Cf5hK6UetgjemtdArSxsB6AhdNEUf43DRObc6RKUfvBCONbKNDT3HTNsD56
         CV6A==
X-Gm-Message-State: AOAM533xIYAQ3Mgz3wZvqKCGX67VZFLfxao1/FGYZqTs4lNjrTiSOu3p
        s4AISW78o3DC2fRbMaYWV7oljSBdFo27OJG+zDEirCO0wHCKsnewpfjML4JDQG0VyXk88UVIaFE
        6qEXUdIm3Ua3I
X-Received: by 2002:a7b:ce16:: with SMTP id m22mr2979792wmc.39.1638257297487;
        Mon, 29 Nov 2021 23:28:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxK2rwcIrtv4RtfQ983prRIkRD0ZG7sfC5n89ECduXultLEnEEQ2+nrWzvlBkIc4L2PPkSzQA==
X-Received: by 2002:a7b:ce16:: with SMTP id m22mr2979769wmc.39.1638257297217;
        Mon, 29 Nov 2021 23:28:17 -0800 (PST)
Received: from xz-m1.local ([85.203.46.194])
        by smtp.gmail.com with ESMTPSA id g198sm1574235wme.23.2021.11.29.23.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 23:28:16 -0800 (PST)
Date:   Tue, 30 Nov 2021 15:28:07 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH 15/15] KVM: x86/mmu: Promote pages in-place when
 disabling dirty logging
Message-ID: <YaXSh6RUOH7NHG8G@xz-m1.local>
References: <20211115234603.2908381-1-bgardon@google.com>
 <20211115234603.2908381-16-bgardon@google.com>
 <YZ8OpQmB/8k3/Maj@xz-m1.local>
 <CANgfPd9pK83S+yoRokLg7wiroE6-OkieATTqgGn3yCCzwNFi4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANgfPd9pK83S+yoRokLg7wiroE6-OkieATTqgGn3yCCzwNFi4A@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 29, 2021 at 10:31:14AM -0800, Ben Gardon wrote:
> > As comment above handle_removed_tdp_mmu_page() showed, at this point IIUC
> > current thread should have exclusive ownership of this orphaned and abandoned
> > pgtable page, then why in handle_removed_tdp_mmu_page() we still need all the
> > atomic operations and REMOVED_SPTE tricks to protect from concurrent access?
> > Since that's cmpxchg-ed out of the old pgtable, what can be accessing it
> > besides the current thread?
> 
> The cmpxchg does nothing to guarantee that other threads can't have a
> pointer to the page table, only that this thread knows it's the one
> that removed it from the page table. Other threads could still have
> pointers to it in two ways:
> 1. A kernel thread could be in the process of modifying an SPTE in the
> page table, under the MMU lock in read mode. In that case, there's no
> guarantee that there's not another kernel thread with a pointer to the
> SPTE until the end of an RCU grace period.

Right, I definitely missed that whole picture of the RCU usage.  Thanks.

> 2. There could be a pointer to the page table in a vCPU's paging
> structure caches, which are similar to the TLB but cache partial
> translations. These are also cleared out on TLB flush.

Could you elaborate what's the structure cache that you mentioned?  I thought
the processor page walker will just use the data cache (L1-L3) as pgtable
caches, in which case IIUC the invalidation happens when we do WRITE_ONCE()
that'll invalidate all the rest data cache besides the writter core.  But I
could be completely missing something..

> Sean's recent series linked the RCU grace period and TLB flush in a
> clever way so that we can ensure that the end of a grace period
> implies that the necessary flushes have happened already, but we still
> need to clear out the disconnected page table with atomic operations.
> We need to clear it out mostly to collect dirty / accessed bits and
> update page size stats.

Yes, this sounds reasonable too.

-- 
Peter Xu

