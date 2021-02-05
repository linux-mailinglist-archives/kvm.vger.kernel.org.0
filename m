Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76EEB310FC1
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 19:18:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbhBEQgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Feb 2021 11:36:04 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22114 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233704AbhBEQdX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Feb 2021 11:33:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612548855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b+b6OD3StrUZhviTTkgah8uKJMjMpGgyYUl7CSN7rcs=;
        b=HCfVOdRqXo+n3sgTEPC6PfoLoHQz52UilSj/iQuabA3PVquLfGwb2oZK01wXOg0n4iw/td
        1qlVpt8c8+w2Pjyje7mjmhPAqq3Mg61njKaQENQH+sL3y08iFZAHd+CJugydzJhjXmOiNm
        7ND/r7vKwiJ0DE3gjU661HjQui6mJe0=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-603-w2cz47GZPHO-MzNktQxyLQ-1; Fri, 05 Feb 2021 13:14:14 -0500
X-MC-Unique: w2cz47GZPHO-MzNktQxyLQ-1
Received: by mail-qk1-f200.google.com with SMTP id y79so6540548qka.23
        for <kvm@vger.kernel.org>; Fri, 05 Feb 2021 10:14:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b+b6OD3StrUZhviTTkgah8uKJMjMpGgyYUl7CSN7rcs=;
        b=TF1VD42XrYhoO1gQliVf+ZTZv0Ggf/SHdfzaqduzVxRU+crWO5BJ5kWdhWGXR9u8Ec
         b2Bk0I+9d5riza83rOxrY6FkNyuaDqzxMuPsoVsbDCmT8HjFwx/9i8mPmZfjgZ0xJ9r2
         6ogIz8YQlIdnB2QAb09z93dL8VbBSUbHRZ/QddhaEVfeThBOzwQDh/wHwZIqN93kep/8
         DBByLdwQ7R/+cAkLY/haF6RuDM53+gPNCXqxeVNWv9wkfDsp5KKomBuIcUnoM/W/tqoA
         O3jlB8/fBZoqTj5InL8XixfHBlyCGjkk0k8P1Ys22RxIBfF/4lG/sw48IqRXh/HQtHZI
         Zf5A==
X-Gm-Message-State: AOAM531JdqOI5ExZ5kCW6PJLeO/QcDjJfSuuJc+e9UoLXP+VZvnsXbzL
        tk2PJVLHcRpyILdDVfVyeYMiAPTca9pfzyuupwLuR2Y7rCaBhcCrsVG5qp9wgJG6PfIkzHfI1/+
        6gM59WD3gzhZo
X-Received: by 2002:a05:620a:530:: with SMTP id h16mr5623529qkh.136.1612548853758;
        Fri, 05 Feb 2021 10:14:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw2dxqnZovOeKuwXlYA9ZoMH6h3WcLq3ydNuPij1rSRR/WcmyfdGA897c3rYVPJ5YdnoImrSg==
X-Received: by 2002:a05:620a:530:: with SMTP id h16mr5623516qkh.136.1612548853537;
        Fri, 05 Feb 2021 10:14:13 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-182.dsl.bell.ca. [174.93.89.182])
        by smtp.gmail.com with ESMTPSA id i65sm9921618qkf.105.2021.02.05.10.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 10:14:12 -0800 (PST)
Date:   Fri, 5 Feb 2021 13:14:11 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgg@ziepe.ca,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        dan.j.williams@intel.com
Subject: Re: [PATCH 0/2] KVM: do not assume PTE is writable after follow_pfn
Message-ID: <20210205181411.GB3195@xz-x1>
References: <20210205103259.42866-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210205103259.42866-1-pbonzini@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 05, 2021 at 05:32:57AM -0500, Paolo Bonzini wrote:
> This series is the first step towards fixing KVM's usage of follow_pfn.
> The immediate fix here is that KVM is not checking the writability of
> the PFN, which actually dates back to way before the introduction of
> follow_pfn in commit add6a0cd1c5b ("KVM: MMU: try to fix up page faults
> before giving up", 2016-07-05).  There are more changes needed to
> invalidate gfn-to-pfn caches from MMU notifiers, but this issue will
> be tackled later.
> 
> A more fundamental issue however is that the follow_pfn function is
> basically impossible to use correctly.  Almost all users for example
> are assuming that the page is writable; KVM was not alone in this
> mistake.  follow_pte, despite not being exported for modules, is a
> far saner API.  Therefore, patch 1 simplifies follow_pte a bit and
> makes it available to modules.
> 
> Please review and possibly ack for inclusion in the KVM tree,
> thanks!

FWIW, the patches look correct to me (if with patch 2 report fixed):

Reviewed-by: Peter Xu <peterx@redhat.com>

But I do have a question on why dax as the only user needs to pass in the
notifier to follow_pte() for initialization.

Indeed there're a difference on start/end init of the notifier depending on
whether it's a huge pmd but since there's the pmdp passed over too so I assume
the caller should know how to init the notifier anyways.

The thing is at least in current code we could send meaningless notifiers,
e.g., in follow_pte():

	if (range) {
		mmu_notifier_range_init(range, MMU_NOTIFY_CLEAR, 0, NULL, mm,
					address & PAGE_MASK,
					(address & PAGE_MASK) + PAGE_SIZE);
		mmu_notifier_invalidate_range_start(range);
	}
	ptep = pte_offset_map_lock(mm, pmd, address, ptlp);
	if (!pte_present(*ptep))
		goto unlock;
	*ptepp = ptep;
	return 0;
unlock:
	pte_unmap_unlock(ptep, *ptlp);
	if (range)
		mmu_notifier_invalidate_range_end(range);

The notify could be meaningless if we do the "goto unlock" path.

Ideally it seems we can move the notifier code to caller (as what most mmu
notifier users do) and we can also avoid doing that if follow_pte returned
-EINVAL.

Thanks,

-- 
Peter Xu

