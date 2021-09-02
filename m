Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653B43FF369
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 20:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347136AbhIBSsN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 14:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347090AbhIBSsM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 14:48:12 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C8DC061575
        for <kvm@vger.kernel.org>; Thu,  2 Sep 2021 11:47:13 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id h1so5367824ljl.9
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 11:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wzO6lGJGjHrf6YXLUu+Gtn4cGYG6w0mu1s+nUPgqR5I=;
        b=l4l5kxrvVgdfFTZsPcPQbbvRON66shVccX3faBj7qxoYuG72tr7RGAyPpBToisL5DW
         IfwffJluMlCD44kAfRGKj0Wy/DfQhuqdEKOpaygQVRjfOLtsfVhlmLEaYmzWZpLw+/s9
         19sMx9GezN0uaxJwmMEgTaU4zh0hGLI9z2N8Ssxptn6qfaCTXeQOEBZApi4PVtuuy4ub
         YTIeCMWubNHM2sRGLBl0rYvxHgTQyJgnY4WGva5xegj+JfAkPNY7OwtSupLytpQWe4o2
         zoWMHF02BFhTYeDYNJ4HNiiWYzuoPHy06AlmedEy5+6d9J22t9TjVKExAWMqUa0mBuTg
         6Yjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wzO6lGJGjHrf6YXLUu+Gtn4cGYG6w0mu1s+nUPgqR5I=;
        b=eGEftHcP05FtwTmFeV7Wupsj/Az46+ctPHnWxUCDSSL31CxgSR2/iHPZ3fwAtdF9mh
         OZ9OEk3CjrmiR75dx5kRoy6ttZIbMMpf1xFGXOQq/dKv/i9i0p1sS0VTVQF00tTqXzOF
         F9Y/CrSyx8FyM2GcUh+faaT3OUlNua8zLD5h9Z5UCFnz5iS6LzAdCX1vjyDEwpZbfEGR
         Sa3as3vmsEWlmbj9tO8a4E5L5cmcXV/A7DLnbfMTJunLf1MGBX5yS2nAwAe38Ctio3Hw
         CwC3M3mm7r9IpzIOzFpntcvqiVuP6IBwjvzCRTJ3wMr30lIh1hB51B71Y7kscY6JcUXx
         Bh0A==
X-Gm-Message-State: AOAM530SadPvcG/CyrZfV6HFHhLTWadJ0D75yOftaa5wEM5svgRlOp96
        SzQQhJPKAfg3WCYaXwlK/vGB0w==
X-Google-Smtp-Source: ABdhPJyG/b3okzmXZ9mB5SnG83gp5BkkogDqf6wXBq+2miVaUHumYCZIm+43gDmCOlx8maZ2WhXPOA==
X-Received: by 2002:a2e:86d1:: with SMTP id n17mr3714548ljj.237.1630608432210;
        Thu, 02 Sep 2021 11:47:12 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id w18sm295786lfa.50.2021.09.02.11.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 11:47:11 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 0142A102E9A; Thu,  2 Sep 2021 21:47:11 +0300 (+03)
Date:   Thu, 2 Sep 2021 21:47:11 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andy Lutomirski <luto@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest
 private memory
Message-ID: <20210902184711.7v65p5lwhpr2pvk7@box.shutemov.name>
References: <20210824005248.200037-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824005248.200037-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi folks,

I try to sketch how the memfd changes would look like.

I've added F_SEAL_GUEST. The new seal is only allowed if there's no
pre-existing pages in the fd (i_mapping->nrpages check) and there's
no existing mapping of the file (RB_EMPTY_ROOT(&i_mapping->i_mmap.rb_root check).

After the seal is set, no read/write/mmap from userspace is allowed.

Although it's not clear how to serialize read check vs. seal setup: seal
is protected with inode_lock() which we don't hold in read path because it
is expensive. I don't know yet how to get it right. For TDX, it's okay to
allow read as it cannot trigger #MCE. Maybe we can allow it?

Truncate and punch hole are tricky.

We want to allow it to save memory if substantial range is converted to
shared. Partial truncate and punch hole effectively writes zeros to
partially truncated page and may lead to #MCE. We can reject any partial
truncate/punch requests, but it doesn't help the situation with THPs.

If we truncate to the middle of THP page, we try to split it into small
pages and proceed as usual for small pages. But split is allowed to fail.
If it happens we zero part of THP.
I guess we may reject truncate if split fails. It should work fine if we
only use it for saving memory.

We need to modify truncation/punch path to notify kvm that pages are about
to be freed. I think we will register callback in the memfd on adding the
fd to KVM memslot that going to be called for the notification. That means
1:1 between memfd and memslot. I guess it's okay.

Migration going to always fail on F_SEAL_GUEST for now. Can be modified to
use a callback in the future.

Swapout will also always fail on F_SEAL_GUEST. It seems trivial. Again, it
can be a callback in the future.

For GPA->PFN translation KVM could use vm_ops->fault(). Semantically it is
a good fit, but we don't have any VMAs around and ->mmap is forbidden for
F_SEAL_GUEST.
Other option is call shmem_getpage() directly, but it looks like a
layering violation to me. And it's not available to modules :/

Any comments?

-- 
 Kirill A. Shutemov
