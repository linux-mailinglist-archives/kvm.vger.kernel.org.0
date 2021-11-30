Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7F4463ADF
	for <lists+kvm@lfdr.de>; Tue, 30 Nov 2021 17:02:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243308AbhK3QFS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Nov 2021 11:05:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239833AbhK3QFP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Nov 2021 11:05:15 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9198EC061746
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 08:01:55 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z6so21071986pfe.7
        for <kvm@vger.kernel.org>; Tue, 30 Nov 2021 08:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=u7qkJO95z6PA+5n1Ta+ydAPJV1GYiaGJee3oSFozDEQ=;
        b=IFt8Tn+vxT21IpZwc1G2oIIymlaJa/rS9tPtD65lbJffdgHBV1ma5O+UrZYwQ+fpdE
         uwo6I7onE1BcdE7rFH+Hyh0hfFqAisvMusQkVDnpcHVSrvYxwu/WDFInlFXrsly+Ij2o
         2/e4EmCPBpf191/pzWGolf7xwlV4RVdA29Ob/MYDXJBNJmWraO+ef5IZrdWd5kTDzB4e
         d43mrcg7DtKvEkstc8pI3DgJG4GKmHwqmVLDDfyMhJ97ZgjBvOWiiQyopaZ3i2tEV+Wm
         Ley8rcpzQAb/T5TWz2UVrLchpAFSSyi8rw3PYzcbp2+rhJJ9SoKb3AYBUyt5a90Advl4
         9BwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=u7qkJO95z6PA+5n1Ta+ydAPJV1GYiaGJee3oSFozDEQ=;
        b=WaGGDOLOtJxeEVpxGTUuztPDTeDh0JT0pQIw2UGKvJp780GpA0AS0nQiTiVsCccXDm
         s/hOHnNUEKafcuTs54ancJzoNmAmgyOoFJa8sOW9XL91doVrvNd97U7qn4gDNSeX38TY
         Jj0g70ytOgTfnQbQxaFNGCmSdpv0raqZCMWkOZ8b4zgrmU0qd3WwbsX/JJNsXvLCRvEF
         fV4BbEjuTNeKFK4P35eKlQGnm9YPNo52ludx4l8HJsif+cRtprIXvv1XAGi6WiQ2aXaj
         T6Kl2YNXxkQXvcZunPPxQmNhJW/G3k/XON/JBS4keQeR77BKIUceTi1MhRV44iBx7M2r
         43eA==
X-Gm-Message-State: AOAM533nhSGHrtfmYnzvnXFPTAQySeXHtxFZOYxNMuDp5AGzUEzD0WjZ
        DZBOQiKqNivhQThorV/5afROZVV2HhzfFA==
X-Google-Smtp-Source: ABdhPJzONHfSHYXg+nJ0762Y3NxbBOp1zkuKvTXs/1E3XWI7EUSQt6W9dr/3AVTdAHDoxFeRyZbz9A==
X-Received: by 2002:a65:4bc6:: with SMTP id p6mr23381pgr.544.1638288114791;
        Tue, 30 Nov 2021 08:01:54 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id lp12sm3366048pjb.24.2021.11.30.08.01.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 08:01:54 -0800 (PST)
Date:   Tue, 30 Nov 2021 16:01:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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
Message-ID: <YaZK7lxaBMGfYIdz@google.com>
References: <20211115234603.2908381-1-bgardon@google.com>
 <20211115234603.2908381-16-bgardon@google.com>
 <YZ8OpQmB/8k3/Maj@xz-m1.local>
 <CANgfPd9pK83S+yoRokLg7wiroE6-OkieATTqgGn3yCCzwNFi4A@mail.gmail.com>
 <YaXSh6RUOH7NHG8G@xz-m1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YaXSh6RUOH7NHG8G@xz-m1.local>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 30, 2021, Peter Xu wrote:
> On Mon, Nov 29, 2021 at 10:31:14AM -0800, Ben Gardon wrote:
> > 2. There could be a pointer to the page table in a vCPU's paging
> > structure caches, which are similar to the TLB but cache partial
> > translations. These are also cleared out on TLB flush.
> 
> Could you elaborate what's the structure cache that you mentioned?  I thought
> the processor page walker will just use the data cache (L1-L3) as pgtable
> caches, in which case IIUC the invalidation happens when we do WRITE_ONCE()
> that'll invalidate all the rest data cache besides the writter core.  But I
> could be completely missing something..

Ben is referring to the Intel SDM's use of the term "paging-structure caches"
Intel CPUs, and I'm guessing other x86 CPUs, cache upper level entries, e.g. the
L4 PTE for a given address, to avoid having to do data cache lookups, reserved
bits checked, A/D assists, etc...   Like full VA=>PA TLB entries, these entries
are associated with the PCID, VPID, EPT4A, etc...

The data caches are still used when reading PTEs that aren't cached in the TLB,
the extra caching in the "TLB" is optimization on top.

  28.3.1 Information That May Be Cached
  Section 4.10, “Caching Translation Information” in Intel® 64 and IA-32 Architectures
  Software Developer’s Manual, Volume 3A identifies two kinds of translation-related
  information that may be cached by a logical processor: translations, which are mappings
  from linear page numbers to physical page frames, and paging-structure caches, which
  map the upper bits of a linear page number to information from the paging-structure
  entries used to translate linear addresses matching those upper bits.
