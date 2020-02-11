Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85F3C158D8A
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2020 12:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728501AbgBKL0T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Feb 2020 06:26:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:38844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgBKL0T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Feb 2020 06:26:19 -0500
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34C7C206D7;
        Tue, 11 Feb 2020 11:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581420378;
        bh=2L9bSGf+TLqSURpvqdOD5PgYiQUSnDassNwBUiYrriI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zIMcq8PuF7naKYNRnYV/McurYaFZkvc8Q3bRjAQVY5mvkTZ9RRGI3NbU4k3dZKCHv
         8x6Ta7MIr5rRbWpvYs1wlmzPSa1vzb9LQXMh+3hd3Q3xIfyrKIr7fQ6N8Wrs/4JeEj
         he5z9/2Q+RthfSvQrj7PFLFiV0R2GUju758R0708=
Date:   Tue, 11 Feb 2020 11:26:11 +0000
From:   Will Deacon <will@kernel.org>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Janosch Frank <frankja@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        KVM <kvm@vger.kernel.org>, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Ulrich Weigand <Ulrich.Weigand@de.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Michael Mueller <mimu@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
        kvm-ppc@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        mark.rutland@arm.com, qperret@google.com, palmerdabbelt@google.com
Subject: Re: [PATCH 01/35] mm:gup/writeback: add callbacks for inaccessible
 pages
Message-ID: <20200211112611.GD8560@willie-the-truck>
References: <20200207113958.7320-1-borntraeger@de.ibm.com>
 <20200207113958.7320-2-borntraeger@de.ibm.com>
 <28792269-e053-ac70-a344-45612ee5c729@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28792269-e053-ac70-a344-45612ee5c729@de.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 10, 2020 at 06:27:04PM +0100, Christian Borntraeger wrote:
> CC Marc Zyngier for KVM on ARM.  Marc, see below. Will there be any
> use for this on KVM/ARM in the future?

I can't speak for Marc, but I can say that we're interested in something
like this for potentially isolating VMs from a KVM host in Android.
However, we've currently been working on the assumption that the memory
removed from the host won't usually be touched by the host (i.e. no
KSM or swapping out), so all we'd probably want at the moment is to be
able to return an error back from arch_make_page_accessible(). Its return
code is ignored in this patch :/

One thing I don't grok about the ultravisor encryption is how it avoids
replay attacks when paging back in. For example, if the host is compromised
and replaces the page contents with an old encrypted value. Are you storing
per-page metadata somewhere to ensure "freshness" of the encrypted data?

Will
