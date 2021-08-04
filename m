Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533C53E0AD8
	for <lists+kvm@lfdr.de>; Thu,  5 Aug 2021 01:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbhHDXbf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 19:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbhHDXbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Aug 2021 19:31:34 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABD86C061798
        for <kvm@vger.kernel.org>; Wed,  4 Aug 2021 16:31:20 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id pj14-20020a17090b4f4eb029017786cf98f9so5906667pjb.2
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 16:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Zd+uox/EZ4rv4qm3Tkl9ksk48grG3CU/Mqm/t6eMNV4=;
        b=iA1EQu0Ghv3f7PId5bp+Rvi6PVKtnJbWbyEiz8T7P3j0Xpt4ahJBNYbtSzVpyVDTxG
         +SI8zAXY1HZR/by1oqDjUyb/mfdt7P7+tdn04mUml7O4deCPB0ea3j9B/EmMoBRCLKtt
         NB+LdF73NIjLPhRQiqlOE6GpJXLBUX7FCG5afve3IS4xuWlHb3fJAEfaNTYoDGMr7dO1
         vZ2voSgbpHU7gh8vWqjmyc3YJ235f3o611ku6DoVeVTRZzC16jLUjlXIHkUBPGG58c1e
         4F8zpYzudPOX3k9vdHzBwz23fKCXCrdBvd7OoaUStQeZ0Z+Lo169jF9bXKi8nUIv94Yo
         xEDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Zd+uox/EZ4rv4qm3Tkl9ksk48grG3CU/Mqm/t6eMNV4=;
        b=a62M4WUP5Y0zaZaM8Xk2LgygnY8DjYiYq+fQUiBmulZ/UQvW8rsExEVaR7Ske1K1xM
         lKnmIom2ZRUptAH5aExwrYR/A117lXM8Q2gsKzT9qHjHxmBwOeHmJ2X5vqjkGp4Ux7N3
         ox9rK+7mlQgZ/WUfRfweZD0VZEC3zo29j924U9HdESKn85qdQsxhBRoT2x8+fyUPLHEH
         5Omr78sqAlnjRMHdEhXrvNNw8DiL6Kc49tuBjG9G418/vHnfQ6PJKTmjDtSNmXLVoydl
         f+M3cphtbrj2EKgaIlIa+Lqz0rejnVIfdlFseQ+0oDv5ifPESo7bL7ZGfCNuVHdC3jDu
         JGkQ==
X-Gm-Message-State: AOAM533BUXnoly3RHY0+DBv+pyz/uFS1m3F2BWgrE4qWNW5//u9oR+Zv
        K27vnlNmlTO9kPsD5LRhfHGqbg==
X-Google-Smtp-Source: ABdhPJxssIOCNPZAbfOxrf/IMA12h60LqOvcCTi+PK0UppFpa1s1eenr1lxdNpE5vVyd5Co6NOsJsA==
X-Received: by 2002:a17:902:b407:b029:12c:aadd:90d7 with SMTP id x7-20020a170902b407b029012caadd90d7mr1349877plr.79.1628119879991;
        Wed, 04 Aug 2021 16:31:19 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f15sm3585612pjt.3.2021.08.04.16.31.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 16:31:19 -0700 (PDT)
Date:   Wed, 4 Aug 2021 23:31:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Erdem Aktas <erdemaktas@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        linux-kselftest@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>, Sagi Shahar <sagis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Jim Mattson <jmattson@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Shier <pshier@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Zhenzhong Duan <zhenzhong.duan@intel.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Like Xu <like.xu@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Subject: Re: [RFC PATCH 1/4] KVM: selftests: Add support for creating
 non-default type VMs
Message-ID: <YQsjQ5aJokV1HZ8N@google.com>
References: <20210726183816.1343022-1-erdemaktas@google.com>
 <20210726183816.1343022-2-erdemaktas@google.com>
 <e1651746-aa46-31e7-e1c0-99f3faaf1586@intel.com>
 <ede70f11e713ee0140c0e684c3d46b3aa1176e5e.camel@redhat.com>
 <42a812a9-7f17-2a26-d289-1f921408a469@intel.com>
 <c82a3abe00d387985ac806c8ff062cc29e192bbd.camel@redhat.com>
 <CAAYXXYx_CFKBhFjqfz_wyh6bPPbWpTPCDfGmmLGqiugvfqA3Dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAYXXYx_CFKBhFjqfz_wyh6bPPbWpTPCDfGmmLGqiugvfqA3Dg@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 04, 2021, Erdem Aktas wrote:
> Thank you all for all that great feedback! I will include them in my v2.
> 
> On Wed, Aug 4, 2021 at 7:46 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> >
> > > > > Can we pass KVM_X86_LEGACY_VM (whatever name when it's upstreamed)
> > > > > instead of 0?
> > > >
> I was originally thinking of doing this but Sean has suggested that we
> should use 0 to make it  arch-agnostic for creating default VMs.
> +Sean Christopherson : What do you think?

I hate passing '0', but KVM_X86_LEGACY_VM is worse because it's nonsensical for
other architectures.
 
> >
> > KVM_X86_NORMAL_VM is a very good name IMHO as well.

But that implies protected guests are abnormal!  And KVM_X86_STANDARD_VM would
imply protected guests are sub-standard!  I'm only half-joking, e.g. if we get
to the point where the majority of guests being run are protected guests, then
!protected guests are no longer the "standard".

Looking at other architectures, I think the least awful option is a generic
KVM_VM_TYPE_AUTO, or maybe KVM_VM_TYPE_DEFAULT.  That aligns with how '0' is used
by PPC, MIPS, and arm64[*], and would work for x86 as well without implying what's
normal/standard.

[*] arm64 uses the type to specify the IPA width (I'm not even sure what that is),
    but thankfully interprets '0' as a default.
