Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1EC232F262
	for <lists+kvm@lfdr.de>; Fri,  5 Mar 2021 19:23:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhCESWj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Mar 2021 13:22:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCESWW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Mar 2021 13:22:22 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B78C061756
        for <kvm@vger.kernel.org>; Fri,  5 Mar 2021 10:22:22 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id u11so1797949plg.13
        for <kvm@vger.kernel.org>; Fri, 05 Mar 2021 10:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PcN5dzqB1NMHlTC3giiCYf0hVHQirhT84sv3ElkGB2s=;
        b=LGD9gCkJz+prgQBHDfPGxwdtD2dNAXggbtB8rDhoVFbdbMDkeuy0STGKqI/EqiTCrR
         QGnz7EcEwuRGiwmCZxq51oqYa/iPV4TPafMJ3AJ2kBlWXM+Ug5exn+vC8BX/3m8/B7Ex
         t/IFY3VRvugn6+AiW+jj16J7nin8t0JvSkPg31O3bxbk2P7tpeP2xMd1RQ7C0JtMd4cr
         YqQFdGGOJdpDVzrJVyfbpwPV3/KoyUZXysqhrKSbj85yTNJ02MgFAAbx8n7QVhG9wcKB
         wr5pE7pZTIbyUfxoOdZUuC7aB2GbxVzCGMTfGY0l4979m+kYr1T6frHx4ZiMbKQIdGdx
         /bSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PcN5dzqB1NMHlTC3giiCYf0hVHQirhT84sv3ElkGB2s=;
        b=hZ6DlEAXCYTYLod2+JizZIUAwtUXtsqAXoXFjkqxHEghdrE/cIfm08b6XYlhosb5pl
         jmdvDQGliRV4RqmkzI0OZH3+E5HBjehERbhpk43OmmYa1+lBjxNI+ynGAR8luspNhSML
         j6fGioJrdrbHoMzOR0n0PBiOg8MvRW9D8nkVOu4c4ccYMOkTWNxUSmHVykuTpS780mdI
         YqSn3HOyhipoaxapBOG9dgqs17xQKdzJxQSm0AFHrxWBUC3UWN/zyGdIxtcWNohTQsjz
         szxefcV5iPM00RjWvJmlrdSqEqyBRmW85Yf7m570OSE8QE/APaHzRBJ6x7+56Yv31GfB
         uBLw==
X-Gm-Message-State: AOAM531G9LB80TLIspOBDlXHXM8Qe+tLpQfNEXGuWUbf8r/bdBrqNEkS
        xcWvRkqdZS45CbDzHjKnjWQSjA==
X-Google-Smtp-Source: ABdhPJzsZ9k6lIxmm3Nhd4VwcvASrmPVCpthPebGsI9CUjQjwuyOmz/OZXWUQ4WpuXmQk4dLik1foQ==
X-Received: by 2002:a17:90a:d590:: with SMTP id v16mr11214955pju.118.1614968541536;
        Fri, 05 Mar 2021 10:22:21 -0800 (PST)
Received: from google.com ([2620:15c:f:10:9857:be95:97a2:e91c])
        by smtp.gmail.com with ESMTPSA id h27sm3234348pfq.32.2021.03.05.10.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 10:22:20 -0800 (PST)
Date:   Fri, 5 Mar 2021 10:22:14 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 09/17] KVM: x86/mmu: Use '0' as the one and only value
 for an invalid PAE root
Message-ID: <YEJ21vvQfBXnvlP8@google.com>
References: <20210305011101.3597423-1-seanjc@google.com>
 <20210305011101.3597423-10-seanjc@google.com>
 <63d2a610-f897-805c-23a7-488a65485f36@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63d2a610-f897-805c-23a7-488a65485f36@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 05, 2021, Paolo Bonzini wrote:
> On 05/03/21 02:10, Sean Christopherson wrote:
> > Use '0' to denote an invalid pae_root instead of '0' or INVALID_PAGE.
> > Unlike root_hpa, the pae_roots hold permission bits and thus are
> > guaranteed to be non-zero.  Having to deal with both values leads to
> > bugs, e.g. failing to set back to INVALID_PAGE, warning on the wrong
> > value, etc...
> 
> I don't dispute this is a good idea, but it deserves one or more comments.

Agreed.   What about adding macros?

/* Comment goes here. */
#define INVALID_PAE_ROOT	0
#define IS_VALID_PAE_ROOT(x)	(!!(x))


Also, I missed this pattern in mmu_audit.c's mmu_spte_walk():

	for (i = 0; i < 4; ++i) {
		hpa_t root = vcpu->arch.mmu->pae_root[i];

		if (root && VALID_PAGE(root)) {
			root &= PT64_BASE_ADDR_MASK;
			sp = to_shadow_page(root);
			__mmu_spte_walk(vcpu, sp, fn, 2);
		}
	}
