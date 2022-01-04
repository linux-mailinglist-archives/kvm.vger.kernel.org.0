Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5347C484707
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 18:35:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235740AbiADRe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 12:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiADRe4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 12:34:56 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D91FC061761
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 09:34:56 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id t123so32767359pfc.13
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 09:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=whSHyDkf0XZc1mjjjqOGE1/cp29qdWazioE+cyFAqO0=;
        b=AKGtA6ul6yuij5z+AvEU6YGN7uC/zmR1Z3AA2eavQwv49exOo937KC2cThIO1M5x5R
         ld8sDO2VSHM/RDAO9u2p+XO+70K8kcxVOrir1Y0yigapUXNM0Ylp9TZuzLp8opNiwQ7F
         AnKU33bHmO0NaKXzOI53pZm3IA1/NzLaG7sHnIF4oNjbhA1aPFUnql4JxyGrCHn6JbAR
         SUbiQLLvznmxlgAa1lOw1puG4OnmRONMmAC/E92187ZUZ0u1IfwKfyQOhRxiduWbOsmw
         QfJOYMgQVQMBG6eYUimmH+OiBuy14zVxqAM71F46TwcrfoWBadi7V6J39TzjtU+srhbw
         QcaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=whSHyDkf0XZc1mjjjqOGE1/cp29qdWazioE+cyFAqO0=;
        b=L61diyuI5kARD6Hd15/EMYjTRKgTmJ7UVFlGk7vHXqH1b+U9rOwbB5RgCigOHUl+Wg
         5gQUcH++osRCdlEcoq0ciR/vTKITSZqFhTONnlvPAhi1suBAhW68ONwuT523+a6cE1Zh
         JEHpiGEWgyOofZCe6ljvJvh/GsxRQKvb/D15RD0iso5I3C26iNL644zA6VBRkPvw8v6l
         yYus6cAX5S2SZ7kdsFUcKgZ1HZ5l+m7zz/Sr04cdY0GCyQWaLoY/qCq90E2MhBpIxY8F
         i2sTCu1HxZBR/dn8HKJubbrILRjIsWsqjNdi+Yo6XPkEBuvJrj2VTc+fiWHkw1aRArWw
         sfhQ==
X-Gm-Message-State: AOAM533BPfO47/A/L179Tjbsk5mbTsG2FCwtOoKYBMDEwaqdUuev4Hh+
        ab8bWCLUm/dPVYg+3v/YdnFHfw==
X-Google-Smtp-Source: ABdhPJzZB3uUldS3H3PomxXInau17VQRCQJ4/BUX9qRXpwldcK2cYuphdyVvLg2cunzd1cVS/euxnw==
X-Received: by 2002:a63:87c3:: with SMTP id i186mr45003143pge.507.1641317695407;
        Tue, 04 Jan 2022 09:34:55 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k23sm401859pji.3.2022.01.04.09.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 09:34:54 -0800 (PST)
Date:   Tue, 4 Jan 2022 17:34:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        qemu-devel@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
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
        jun.nakajima@intel.com, dave.hansen@intel.com, ak@linux.intel.com,
        david@redhat.com
Subject: Re: [PATCH v3 kvm/queue 04/16] KVM: Extend the memslot to support
 fd-based private memory
Message-ID: <YdSFO2fAHhdGsPLG@google.com>
References: <20211223123011.41044-1-chao.p.peng@linux.intel.com>
 <20211223123011.41044-5-chao.p.peng@linux.intel.com>
 <YcSzafzpjMy6m28B@google.com>
 <20211231025344.GC7255@chaop.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231025344.GC7255@chaop.bj.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 31, 2021, Chao Peng wrote:
> On Thu, Dec 23, 2021 at 05:35:37PM +0000, Sean Christopherson wrote:
> > On Thu, Dec 23, 2021, Chao Peng wrote:
> > > diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> > > index 1daa45268de2..41434322fa23 100644
> > > --- a/include/uapi/linux/kvm.h
> > > +++ b/include/uapi/linux/kvm.h
> > > @@ -103,6 +103,17 @@ struct kvm_userspace_memory_region {
> > >  	__u64 userspace_addr; /* start of the userspace allocated memory */
> > >  };
> > >  
> > > +struct kvm_userspace_memory_region_ext {
> > > +	__u32 slot;
> > > +	__u32 flags;
> > > +	__u64 guest_phys_addr;
> > > +	__u64 memory_size; /* bytes */
> > > +	__u64 userspace_addr; /* hva */
> > 
> > Would it make sense to embed "struct kvm_userspace_memory_region"?
> > 
> > > +	__u64 ofs; /* offset into fd */
> > > +	__u32 fd;
> > 
> > Again, use descriptive names, then comments like "offset into fd" are unnecessary.
> > 
> > 	__u64 private_offset;
> > 	__u32 private_fd;
> 
> My original thought is the same fields might be used for shared memslot
> as well in future (e.g. there may be another KVM_MEM_* bit can reuse the
> same fields for shared slot) so non private-specific name may sound
> better. But definitely I have no objection and can use private_* names
> for next version unless there is other objection.

If that does happen, it's easy enough to wrap them in a union.
