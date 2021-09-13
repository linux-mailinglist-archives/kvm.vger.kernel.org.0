Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB73A409EE6
	for <lists+kvm@lfdr.de>; Mon, 13 Sep 2021 23:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243773AbhIMVNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Sep 2021 17:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241948AbhIMVNM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Sep 2021 17:13:12 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A3EBC061762
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 14:11:56 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d18so6698652pll.11
        for <kvm@vger.kernel.org>; Mon, 13 Sep 2021 14:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XlbYYs1xpz35Iv85qYFjd2jgM/KVGCtGbcbWYfPgCP4=;
        b=rDor+CBYfNx9Srb9QxGYupt6qFScu9pnfYePIyjV+REzi8u/TLSom19+QJI+GEYZGS
         IK3c+VRyjTMO4Gpfzq5MJdHp55oLiukyf1EoYJTZ/JQYxNZ5WpBzPiANszDPEGQzXQHX
         uMPW6UC5k83YmImCyVEXRQr4NtxjysuwJsMg5xP7+EVxfjAg5ssfhetNp4yWET/v5XX+
         uPyQwgmoyKuppK+a/t3bCcTQDfe/x3x9ilGCtpSz0ZpGIQBooEBlYDwSwlrdl6ng9k42
         JJfACUYOxL/Xgv6L5//YEXw+uNxExk6Ckbd17k/3OCK0KEycQjd6Fm4+EuFknWWCuRoc
         EgXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XlbYYs1xpz35Iv85qYFjd2jgM/KVGCtGbcbWYfPgCP4=;
        b=7qsoj5CQ4brhMk7Xj1CeEtU0yeBFHrBSwG96mKoWAv6+3DaTkuda3PqqEB5w1hNsLB
         nGv7YhfkOMi6QN2E2+JujOuApdclWVLvDRp5aoF6Ei37Yqloj1bSa4lhgk3UqgOWQITg
         ehmrIeeYQ1CdHhAHgrf1t9BG2jkhjkmh0TpLgGxYBZ8b74I+/PuIBYN5QpUqeyh1/17w
         lGG+hJj74adkqT5qZYvfcyG4hbPjVr6zvixzRo4ugVC2IbogwrpHB4X2/QW39q6pCMg+
         sLOwnuqTO7cuC5wRK1ud3dYfLoA/goUeWwm0FWVsntBr+P4cVB9D6Gus0JM2mcWp+1xA
         M0ug==
X-Gm-Message-State: AOAM531Vr5y4hCa2VBNGuOHl0CB6dxNR0da1z2593+cuGOpil0EF3Ck4
        22S7J0KAja1jble5ZDYgJMdfp4PnxrQf4w==
X-Google-Smtp-Source: ABdhPJyDPbwAccoS6lshuqcQMWi6uDYAndD0nTMcsAQem30TsztdgQMDMlrNMjsvJBIKqI3xqCNkMg==
X-Received: by 2002:a17:90a:db17:: with SMTP id g23mr1541721pjv.193.1631567515587;
        Mon, 13 Sep 2021 14:11:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gw21sm7499946pjb.36.2021.09.13.14.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 14:11:55 -0700 (PDT)
Date:   Mon, 13 Sep 2021 21:11:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        jarkko@kernel.org, dave.hansen@linux.intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH 2/2] x86: sgx_vepc: implement SGX_IOC_VEPC_REMOVE ioctl
Message-ID: <YT++l/gSpx3FPMKL@google.com>
References: <20210913131153.1202354-1-pbonzini@redhat.com>
 <20210913131153.1202354-3-pbonzini@redhat.com>
 <50287173-0afb-36f4-058e-0960fb4017a7@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50287173-0afb-36f4-058e-0960fb4017a7@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 13, 2021, Dave Hansen wrote:
> On 9/13/21 6:11 AM, Paolo Bonzini wrote:
> > +static long sgx_vepc_remove_all(struct sgx_vepc *vepc)
> > +{
> > +	struct sgx_epc_page *entry;
> > +	unsigned long index;
> > +	long failures = 0;
> > +
> > +	xa_for_each(&vepc->page_array, index, entry)
> > +		if (sgx_vepc_remove_page(entry))
> > +			failures++;
> > +
> > +	/*
> > +	 * Return the number of pages that failed to be removed, so
> > +	 * userspace knows that there are still SECS pages lying
> > +	 * around.
> > +	 */
> > +	return failures;
> > +}
> 
> I'm not sure the retry logic should be in userspace.  Also, is this
> strictly limited to SECS pages?  It could also happen if there were
> enclaves running that used the page.  Granted, userspace can probably
> stop all the vcpus, but the *interface* doesn't prevent it being called
> like that.

The general rule for KVM is that so long as userspace abuse of running vCPUs (or
other concurrent operations) doesn't put the kernel/platform at risk, it's
userspace's responsibility to not screw up.  The main argument being that there
are myriad ways the VMM can DoS the guest without having to abuse an ioctl().

> What else can userspace do but:
> 
> 	ret = ioctl(fd, SGX_IOC_VEPC_REMOVE);
> 	if (ret)
> 		ret = ioctl(fd, SGX_IOC_VEPC_REMOVE);
> 	if (ret)
> 		printf("uh oh\n");
> 
> We already have existing code to gather up the pages that couldn't be
> EREMOVE'd and selectively EREMOVE them again.  Why not reuse that code
> here?  If there is 100GB of EPC, it's gotta be painful to run through
> the ->page_array twice when once plus a small list iteration will do.

My argument against handling this fully in the kernel is that to handle a vNUMA
setup with multiple vEPC sections, the ioctl() would need to a take a set of file
descriptors to handle the case where an SECS is pinned by a child page in a
diferent vEPC.  It would also require an extra list_head per page (or dynamic
allocations), as the list_head in sgx_epc_page will (likely, eventually) be needed
to handle EPC OOM.  In the teardown case, sgx_epc_page.list can be used because
the pages are taken off the active/allocated list as part of teardown.

Neither issue is the end of the world, but IMO it's not worth burning the memory
and taking on extra complexity in the kernel for a relatively rare operation that's
slow as dirt anyways.

> Which reminds me...  Do we need a cond_resched() in there or anything?
> That loop could theoretically get really, really long.
