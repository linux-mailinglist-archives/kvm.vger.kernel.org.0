Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C1D48470E
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 18:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235820AbiADRio (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 12:38:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234314AbiADRin (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 12:38:43 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13267C061785
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 09:38:43 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id w7so27035391plp.13
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 09:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lyYzwxTZWc2pKk20hwF7g02tZU/8D7vFzmqot46zr3o=;
        b=hF4kd1Mq//yjpl61nrYwvKMLJT6MIhV0E6IJ7zAD3JWlI+Lf9Kl7EjPWqG9SBDfEF8
         bLQriumtvq/d4LPMxq+QOQ59vvcAi7NGeWaxhSlxlkxdhBfO29QiUCBdFlPXpq95IOxu
         JnrHN+97F5CEcTUWcX51rjIW0pyoQQer1CQy1E5p5jQtDlIK/mVO/JhHG7vsEQcySXvf
         BNaUi94Me+iu/Cekap3IlPAukuOJezwMa5QK5Oa7ly7GCgO/RioM5k2JBuseJG/0A/de
         MBbrQnE1pKQwoHwCb9W1/cXrW4NS+qeUQ6HoMhdMIjuDjY1Jis5Xz1s308oEz41ERKbt
         +qzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lyYzwxTZWc2pKk20hwF7g02tZU/8D7vFzmqot46zr3o=;
        b=RxeLynVQnAEc0TLqmh2CXfNhU+4zvqf2Jtntdon4aGGpJkY5lXMfZ1Mq8Hz1+e5AIJ
         50NdtHMKQ1HrQlT/+v4mWGXFOqBui9SX9O4bKS/A1UVZRGQ7N9/euUCnRaaC3rizavvA
         5Der/wB2akMHZMBMQTZB2t0zd6g/sD77mVeUU0higDEJLgyyl0RPagwZBI1N300TokwE
         me6s4+4d3/9W5owIhSBl2sSmbb4e/cp2yj8fe1my/ZNqVqkRFS7rUuJqMgFdzwEIBSJE
         TNspDzNRrYCAB2N0lrJRV4HdQuPWWIkTpXV6ORCXnZxaZDx3jCDlskeP6F+OoU8ynPzt
         9GMA==
X-Gm-Message-State: AOAM531cNBNoe1+SbRxOd/Igwp+EPkzt4FoJkLMYMFdNRro0zpNxCHAt
        Ski4uHgqhOJmqBvE7PJv3nfm1Q==
X-Google-Smtp-Source: ABdhPJzjgo+EqH45rd3keKS/UyOltBLQmBVP2JYcV5J6T2Al78JIvydxac3UZxoz6wC2BU8T/FSzTQ==
X-Received: by 2002:a17:90b:4d86:: with SMTP id oj6mr61729268pjb.185.1641317922423;
        Tue, 04 Jan 2022 09:38:42 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k23sm407842pji.3.2022.01.04.09.38.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 09:38:41 -0800 (PST)
Date:   Tue, 4 Jan 2022 17:38:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Peng <chao.p.peng@linux.intel.com>
Cc:     Robert Hoo <robert.hu@linux.intel.com>, kvm@vger.kernel.org,
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
        jun.nakajima@intel.com, dave.hansen@intel.com, ak@linux.intel.com,
        david@redhat.com
Subject: Re: [PATCH v3 kvm/queue 03/16] mm/memfd: Introduce MEMFD_OPS
Message-ID: <YdSGHnMFV5Mu9vdF@google.com>
References: <20211223123011.41044-1-chao.p.peng@linux.intel.com>
 <20211223123011.41044-4-chao.p.peng@linux.intel.com>
 <95d13ac7da32aa1530d6883777ef3279e4ad825d.camel@linux.intel.com>
 <20211231023853.GB7255@chaop.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211231023853.GB7255@chaop.bj.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 31, 2021, Chao Peng wrote:
> On Fri, Dec 24, 2021 at 11:53:15AM +0800, Robert Hoo wrote:
> > On Thu, 2021-12-23 at 20:29 +0800, Chao Peng wrote:
> > > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > >  
> > > +static void notify_fallocate(struct inode *inode, pgoff_t start,
> > > pgoff_t end)
> > > +{
> > > +#ifdef CONFIG_MEMFD_OPS
> > > +	struct shmem_inode_info *info = SHMEM_I(inode);
> > > +	const struct memfd_falloc_notifier *notifier;
> > > +	void *owner;
> > > +	bool ret;
> > > +
> > > +	if (!info->falloc_notifier)
> > > +		return;
> > > +
> > > +	spin_lock(&info->lock);
> > > +	notifier = info->falloc_notifier;
> > > +	if (!notifier) {
> > > +		spin_unlock(&info->lock);
> > > +		return;
> > > +	}
> > > +
> > > +	owner = info->owner;
> > > +	ret = notifier->get_owner(owner);
> > > +	spin_unlock(&info->lock);
> > > +	if (!ret)
> > > +		return;
> > > +
> > > +	notifier->fallocate(inode, owner, start, end);
> > 
> > I see notifier->fallocate(), i.e. memfd_fallocate(), discards
> > kvm_memfd_fallocate_range()'s return value. Should it be checked?
> 
> I think we can ignore it, just like how current mmu_notifier does,
> the return value of __kvm_handle_hva_range is discarded in
> kvm_mmu_notifier_invalidate_range_start(). Even when KVM side failed,
> it's not fatal, it should not block the operation in the primary MMU.

If the return value is ignored, it'd be better to have no return value at all so
that it's clear fallocate() will continue on regardless of whether or not the
secondary MMU callback succeeds.  E.g. if KVM can't handle the fallocate() for
whatever reason, then knowing that fallocate() will continue on means KVM should
mark the VM as dead so that the broken setup cannot be abused by userspace.
