Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 520E6284E50
	for <lists+kvm@lfdr.de>; Tue,  6 Oct 2020 16:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgJFOuz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Oct 2020 10:50:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55548 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725947AbgJFOux (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Oct 2020 10:50:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601995852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Uj4fUmkMtECUINnHHFprDJjft1rwsVhT/Z+2WgldeIA=;
        b=bCFcRHZLff7Int/vvDvGrj24j1LazL9og1lHIgwUxfBA6eRZzHloBQ/3wv3kIPNet6C3Mn
        FRYJ/tLdQco5REFABh8FCN/eWexG7xMfiPscWm4djPawMn/I7HtYvXJaDd359rBZ8oFtrC
        sxKyImMUsyo2MS8gqvRgeBRH5k4BBQg=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-Aviv9C-MOaWwdivjQ0agwQ-1; Tue, 06 Oct 2020 10:50:48 -0400
X-MC-Unique: Aviv9C-MOaWwdivjQ0agwQ-1
Received: by mail-wm1-f69.google.com with SMTP id m14so793533wmi.0
        for <kvm@vger.kernel.org>; Tue, 06 Oct 2020 07:50:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Uj4fUmkMtECUINnHHFprDJjft1rwsVhT/Z+2WgldeIA=;
        b=EkKiVJPdZHBM8jQCw1OD7qPPWAANQMtLhtJ50jpG2IxMp9oroiqgVLJhIPv+2WVH6w
         iGPkb0ixq0gbb/U6VI4xEnjviXlfqUpkxfsb8rhmkwQdCFtxrRxrCsEzzeihu7/srKXV
         9Jbxd/U38z+DPE01FOPX2+5hfs8ZJ/ZXDqOaxGolyns/wajfvMJTIVwcb5UIJml0+XQF
         8Jx6R7fNWdZCNGAxDGkFI8ySUapoNZm6PJJj0Uk/9wF0S5MWgMsrqT0EaYInOqOMwz3X
         uIRVgy2Td4LN1WrcQmoBrUPexDanrwaIt+scePbWVjze7Nmd6xP+1Trb0YfwcZZr+cd1
         u35g==
X-Gm-Message-State: AOAM531u5m7LiYua0JcK3a10is9thTsHvc+vw47I+RQpSS08fqOaW+DO
        xh4vfDO0o14HvMM6mlrGLVOJnKd3rmAyfVk+sbjy+lgcAd9OrTdqaXhCwXJ6XCBOmQltAVnNfCq
        x2k5n9TEyn4CV
X-Received: by 2002:a5d:69cd:: with SMTP id s13mr5275239wrw.379.1601995846885;
        Tue, 06 Oct 2020 07:50:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzGD6vp5cGlUUCcdlPKU2NANyZGSalCQXuWaV8QSkc2Oo+MbMqEiVgxHozlkw+obNtWwzYCTg==
X-Received: by 2002:a5d:69cd:: with SMTP id s13mr5275210wrw.379.1601995846617;
        Tue, 06 Oct 2020 07:50:46 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id u17sm5647192wri.45.2020.10.06.07.50.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 07:50:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtio-fs-list <virtio-fs@redhat.com>, pbonzini@redhat.com
Subject: Re: [PATCH v4] kvm,x86: Exit to user space in case page fault error
In-Reply-To: <20201006141501.GC5306@redhat.com>
References: <20201002153854.GC3119@redhat.com> <20201002183036.GB24460@linux.intel.com> <20201002192734.GD3119@redhat.com> <20201002194517.GD24460@linux.intel.com> <20201002200214.GB10232@redhat.com> <20201002211314.GE24460@linux.intel.com> <20201005153318.GA4302@redhat.com> <20201005161620.GC11938@linux.intel.com> <20201006134629.GB5306@redhat.com> <877ds38n6r.fsf@vitty.brq.redhat.com> <20201006141501.GC5306@redhat.com>
Date:   Tue, 06 Oct 2020 16:50:44 +0200
Message-ID: <874kn78l2z.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Tue, Oct 06, 2020 at 04:05:16PM +0200, Vitaly Kuznetsov wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> 
>> > A. Just exit to user space with -EFAULT (using kvm request) and don't
>> >    wait for the accessing task to run on vcpu again. 
>> 
>> What if we also save the required information (RIP, GFN, ...) in the
>> guest along with the APF token
>
> Can you elaborate a bit more on this. You mean save GFN on stack before
> it starts waiting for PAGE_READY event?

When PAGE_NOT_PRESENT event is injected as #PF (for now) in the guest
kernel gets all the registers of the userspace process (except for CR2
which is replaced with a token). In case it is not trivial to extract
accessed GFN from this data we can extend the shared APF structure and
add it there, KVM has it when it queues APF.

>
>> so in case of -EFAULT we can just 'crash'
>> the guest and the required information can easily be obtained from
>> kdump? This will solve the debugging problem even for TDX/SEV-ES (if
>> kdump is possible there).
>
> Just saving additional info in guest will not help because there might
> be many tasks waiting and you don't know which GFN is problematic one.

But KVM knows which token caused the -EFAULT when we exit to userspace
(and we can pass this information to it) so to debug the situation you
take this token and then explore the kdump searching for what's
associated with this exact token.

-- 
Vitaly

