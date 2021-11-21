Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D787F458146
	for <lists+kvm@lfdr.de>; Sun, 21 Nov 2021 01:05:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbhKUAI3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Nov 2021 19:08:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhKUAI2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Nov 2021 19:08:28 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF949C06173E
        for <kvm@vger.kernel.org>; Sat, 20 Nov 2021 16:05:24 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id t6so14172387qkg.1
        for <kvm@vger.kernel.org>; Sat, 20 Nov 2021 16:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6kf0/w3Hs1LmxnVhawaFCuKI3Bol3tZdSQQzWs8byfA=;
        b=Eu9tUAhvgTI39XRCgxe+Jp08cFeT8T3hFyVYcEyCfpJZ/9//e91DHQodhxUFFVeKX3
         EAh2D7HiMmk/XJO8/23Bwbc2IMWKufpGX3TuMxYxmYEBo3fxYPh4XbxA3/yi35ppr7UR
         MeW0iep4uj/s+PfeXw4Oi6o9pzpyPILyXGe9p3fMK7gVYs3IQsE07bDSYmKDvRU31xsH
         I9AszubKwbiVvIidR65oTOi4Jwh4aBuq0HiZv70UZ/E+uUKx+HexzvVkG7BbnnMUW75G
         kisyixitbh8q4pERKXhJRTrw/dKmm5p2xbgLCDLTGzMursE/1dxcHdo5PSugqhx71NsJ
         U6Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6kf0/w3Hs1LmxnVhawaFCuKI3Bol3tZdSQQzWs8byfA=;
        b=GkB6Nq62gz6H94gfSjHpZp/tXqKuB+Flz1szSufCsHeppxTDk6o/h6EG/FgEdU6Z7x
         YnUQmEY4udKQQffFNhxKl1ssuro2VlR7SmhQDbZ4T08/qS4CJnBjlk3SvaLnUDfCrr4P
         Sabzh/4Uo3SoiT6Qvgb8kdgN6x/CPrzqFbmG8/KRlVEl4Kn0uw2qeBj2iWyst84BK2e4
         DyNoIWmKhINuL2DYy4Wczl/lkKelk+8MzfuIcAqjFjMhIR/469JbN1ihcmPVoiXFp71F
         il8KJsdWykLvC7Fnlx4X5uc26CIBpjJzbd/to9ef9fiu5cY476/bqD2wTstZuTDa6l0r
         NDxw==
X-Gm-Message-State: AOAM530FYGCRWHeYYsr3YgaNJdrjBJSecAjsFOpRJLYrcv46Koj1lvWS
        HHwugF9mJjQ+Yxsd++82h0zoEg==
X-Google-Smtp-Source: ABdhPJzZj9ReBVUwh/WgmkPvKfwGr6/EBPjNWPCz36F6uolqc0T3L8/Tzkwwaj4TEzJoCDzGgJ3vxw==
X-Received: by 2002:a05:620a:1029:: with SMTP id a9mr37789932qkk.186.1637453124120;
        Sat, 20 Nov 2021 16:05:24 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id a16sm2114487qta.94.2021.11.20.16.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Nov 2021 16:05:23 -0800 (PST)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1moaME-00DLbk-EV; Sat, 20 Nov 2021 20:05:22 -0400
Date:   Sat, 20 Nov 2021 20:05:22 -0400
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Sean Christopherson <seanjc@google.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Chao Peng <chao.p.peng@linux.intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
        Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        luto@kernel.org, john.ji@intel.com, susie.li@intel.com,
        jun.nakajima@intel.com, dave.hansen@intel.com, ak@linux.intel.com
Subject: Re: [RFC v2 PATCH 01/13] mm/shmem: Introduce F_SEAL_GUEST
Message-ID: <20211121000522.GP876299@ziepe.ca>
References: <20211119134739.20218-1-chao.p.peng@linux.intel.com>
 <20211119134739.20218-2-chao.p.peng@linux.intel.com>
 <20211119151943.GH876299@ziepe.ca>
 <df11d753-6242-8f7c-cb04-c095f68b41fa@redhat.com>
 <YZf4aAlbyeWw8wUk@google.com>
 <20211119194746.GM876299@ziepe.ca>
 <YZgjc5x6FeBxOqbD@google.com>
 <20211119233312.GO876299@ziepe.ca>
 <YZhOBD6vlkBEyq8t@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZhOBD6vlkBEyq8t@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Nov 20, 2021 at 01:23:16AM +0000, Sean Christopherson wrote:
> On Fri, Nov 19, 2021, Jason Gunthorpe wrote:
> > On Fri, Nov 19, 2021 at 10:21:39PM +0000, Sean Christopherson wrote:
> > > On Fri, Nov 19, 2021, Jason Gunthorpe wrote:
> > > > On Fri, Nov 19, 2021 at 07:18:00PM +0000, Sean Christopherson wrote:
> > > > > No ideas for the kernel API, but that's also less concerning since
> > > > > it's not set in stone.  I'm also not sure that dedicated APIs for
> > > > > each high-ish level use case would be a bad thing, as the semantics
> > > > > are unlikely to be different to some extent.  E.g. for the KVM use
> > > > > case, there can be at most one guest associated with the fd, but
> > > > > there can be any number of VFIO devices attached to the fd.
> > > > 
> > > > Even the kvm thing is not a hard restriction when you take away
> > > > confidential compute.
> > > > 
> > > > Why can't we have multiple KVMs linked to the same FD if the memory
> > > > isn't encrypted? Sure it isn't actually useful but it should work
> > > > fine.
> > > 
> > > Hmm, true, but I want the KVM semantics to be 1:1 even if memory
> > > isn't encrypted.
> > 
> > That is policy and it doesn't belong hardwired into the kernel.
> 
> Agreed.  I had a blurb typed up about that policy just being an "exclusive" flag
> in the kernel API that KVM would set when creating a confidential
> VM,

I still think that is policy in the kernel, what is wrong with
userspace doing it?

> > Your explanation makes me think that the F_SEAL_XX isn't defined
> > properly. It should be a userspace trap door to prevent any new
> > external accesses, including establishing new kvms, iommu's, rdmas,
> > mmaps, read/write, etc.
> 
> Hmm, the way I was thinking of it is that it the F_SEAL_XX itself would prevent
> mapping/accessing it from userspace, and that any policy beyond that would be
> done via kernel APIs and thus handled by whatever in-kernel agent can access the
> memory.  E.g. in the confidential VM case, without support for trusted devices,
> KVM would require that it be the sole owner of the file.

And how would kvm know if there is support for trusted devices?
Again seems like policy choices that should be left in userspace.

Especially for what could be a general in-kernel mechanism with many
users and not tightly linked to KVM as imagined here.

Jason
