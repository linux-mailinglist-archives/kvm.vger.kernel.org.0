Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04932295D7A
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 13:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897362AbgJVLhi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 07:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2444409AbgJVLhi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 07:37:38 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D252BC0613CE
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 04:37:37 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id 184so1829454lfd.6
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 04:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kV3B9d4XnVSsmv3sKzzsVoproWEhDGgfHQIXbtHyc80=;
        b=0vJSIpfHLs5Q3hF3srtH+miWg1YG4sQZe68J2f1r5Tj19mY8+VnxDOcKJKS/hXBj3h
         bEl6lwmsj7gyfoev3md9cI5h2iSLBNI2MRSRUkseK5n3SiJzDkKq4Efk6mqL6alfcBHu
         7IKMuzGUediaJOB8gVnlN1UcPjLsVk/E0n2pLGJl3TUqDGXJ/yQxKy2KVvh+TrFLAex1
         cy5kPIduOWsSLKvnp5yU9uGeKGla9JPNFgXU8O0al97cMMG41BvYZXrSZurVRuut9cF7
         jD0RJeopeBAG+CcZ8JG/xtGZPkEjRNiqGgtiOvExPLy90MMUYxy5zxM79t/9HZJdcLhu
         3YQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kV3B9d4XnVSsmv3sKzzsVoproWEhDGgfHQIXbtHyc80=;
        b=dh/EgeQDzjwI4ybEjm7c0Mmxw3DGUhhATfs+OXz6ig0GTjT7XV3ZsDJayJ0PICalrB
         V4xwhqqXpz1tJApQAYQqcJ9PpCYV7wdb/rxrCaK4rviGhoA0TTRoQON6JDlNtz66EBWC
         dHyiNlCDLE4wMJfp4xwD3UaABdYyP9zNi7QXxKBKr/djNW4cigQsFFyYUM1hRNQAu5nH
         XUSKWgCM92wZp/7nxHZtSVcRERPE2V6thORZ48aTxubPizuYdoG7pdwt8ZGz4qhITEH1
         yF4bxddl/R1KIb3/2vuRf9Pfdo1GkMem0q15HT9yQ1kgDq6miDrmAUMU9/34eVma0JsU
         SCgQ==
X-Gm-Message-State: AOAM530XLdbsrOd8zOjoXDpjQVtyGkb08QdCmGLbJcwMeNNLgxZkXiWc
        k8lLGsuvsIKXVgfTrqtxtE1xInhWAsiShA==
X-Google-Smtp-Source: ABdhPJwK+q9Ggo3sWp7d7crIXcWK5khXZu2whyTJi45nk9HdyQyARtPNihFKY0DeLGdZVdJa6l+4DQ==
X-Received: by 2002:ac2:5e6c:: with SMTP id a12mr767940lfr.568.1603366656278;
        Thu, 22 Oct 2020 04:37:36 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id l16sm230972lfg.155.2020.10.22.04.37.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 04:37:35 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 299A5102F6D; Thu, 22 Oct 2020 14:37:35 +0300 (+03)
Date:   Thu, 22 Oct 2020 14:37:35 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Ira Weiny <ira.weiny@intel.com>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>,
        Liran Alon <liran.alon@oracle.com>,
        Mike Rapoport <rppt@kernel.org>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv2 08/16] KVM: Use GUP instead of copy_from/to_user() to
 access guest memory
Message-ID: <20201022113735.ugfe6haxrd22oqjh@box>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-9-kirill.shutemov@linux.intel.com>
 <20201020172944.GA165907@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020172944.GA165907@iweiny-DESK2.sc.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 20, 2020 at 10:29:44AM -0700, Ira Weiny wrote:
> On Tue, Oct 20, 2020 at 09:18:51AM +0300, Kirill A. Shutemov wrote:
> > New helpers copy_from_guest()/copy_to_guest() to be used if KVM memory
> > protection feature is enabled.
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > ---
> >  include/linux/kvm_host.h |  4 ++
> >  virt/kvm/kvm_main.c      | 90 +++++++++++++++++++++++++++++++---------
> >  2 files changed, 75 insertions(+), 19 deletions(-)
> > 
> > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > index 05e3c2fb3ef7..380a64613880 100644
> > --- a/include/linux/kvm_host.h
> > +++ b/include/linux/kvm_host.h
> > @@ -504,6 +504,7 @@ struct kvm {
> >  	struct srcu_struct irq_srcu;
> >  	pid_t userspace_pid;
> >  	unsigned int max_halt_poll_ns;
> > +	bool mem_protected;
> >  };
> >  
> >  #define kvm_err(fmt, ...) \
> > @@ -728,6 +729,9 @@ void kvm_set_pfn_dirty(kvm_pfn_t pfn);
> >  void kvm_set_pfn_accessed(kvm_pfn_t pfn);
> >  void kvm_get_pfn(kvm_pfn_t pfn);
> >  
> > +int copy_from_guest(void *data, unsigned long hva, int len, bool protected);
> > +int copy_to_guest(unsigned long hva, const void *data, int len, bool protected);
> > +
> >  void kvm_release_pfn(kvm_pfn_t pfn, bool dirty, struct gfn_to_pfn_cache *cache);
> >  int kvm_read_guest_page(struct kvm *kvm, gfn_t gfn, void *data, int offset,
> >  			int len);
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index cf88233b819a..a9884cb8c867 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -2313,19 +2313,70 @@ static int next_segment(unsigned long len, int offset)
> >  		return len;
> >  }
> >  
> > +int copy_from_guest(void *data, unsigned long hva, int len, bool protected)
> > +{
> > +	int offset = offset_in_page(hva);
> > +	struct page *page;
> > +	int npages, seg;
> > +
> > +	if (!protected)
> > +		return __copy_from_user(data, (void __user *)hva, len);
> > +
> > +	might_fault();
> > +	kasan_check_write(data, len);
> > +	check_object_size(data, len, false);
> > +
> > +	while ((seg = next_segment(len, offset)) != 0) {
> > +		npages = get_user_pages_unlocked(hva, 1, &page, 0);
> > +		if (npages != 1)
> > +			return -EFAULT;
> > +		memcpy(data, page_address(page) + offset, seg);
> > +		put_page(page);
> > +		len -= seg;
> > +		hva += seg;
> > +		offset = 0;
> 
> Why is data not updated on each iteration?

Ouch. I guess no caller actually steps over page boundary. Will fix.

-- 
 Kirill A. Shutemov
