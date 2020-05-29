Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4AA1E8B29
	for <lists+kvm@lfdr.de>; Sat, 30 May 2020 00:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgE2WT2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 18:19:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:60572 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbgE2WT1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 18:19:27 -0400
IronPort-SDR: MEX4v9HReDxweBks71iPW7kM2NHQWCqnaRCpEKCGIUc/Wnk/ZOhob/9pJi1ltYGECUOkijAav9
 6zJjnE2Dc7Dg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2020 15:19:26 -0700
IronPort-SDR: 8fsBnJ8/eVoxsb0uNjg6+LtIBoIDkvbbx2dRkZ02g8tdonPt1pulU3aJFOiVwrMeUtOnyIWz/P
 cbGQOEhN0mfQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,450,1583222400"; 
   d="scan'208";a="469643380"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.152])
  by fmsmga006.fm.intel.com with ESMTP; 29 May 2020 15:19:26 -0700
Date:   Fri, 29 May 2020 15:19:26 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        qemu-ppc@nongnu.org, kvm@vger.kernel.org,
        mdroth@linux.vnet.ibm.com, cohuck@redhat.com,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: Re: [RFC v2 00/18] Refactor configuration of guest memory protection
Message-ID: <20200529221926.GA3168@linux.intel.com>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521034304.340040-1-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 21, 2020 at 01:42:46PM +1000, David Gibson wrote:
> A number of hardware platforms are implementing mechanisms whereby the
> hypervisor does not have unfettered access to guest memory, in order
> to mitigate the security impact of a compromised hypervisor.
> 
> AMD's SEV implements this with in-cpu memory encryption, and Intel has
> its own memory encryption mechanism.  POWER has an upcoming mechanism
> to accomplish this in a different way, using a new memory protection
> level plus a small trusted ultravisor.  s390 also has a protected
> execution environment.
> 
> The current code (committed or draft) for these features has each
> platform's version configured entirely differently.  That doesn't seem
> ideal for users, or particularly for management layers.
> 
> AMD SEV introduces a notionally generic machine option
> "machine-encryption", but it doesn't actually cover any cases other
> than SEV.
> 
> This series is a proposal to at least partially unify configuration
> for these mechanisms, by renaming and generalizing AMD's
> "memory-encryption" property.  It is replaced by a
> "guest-memory-protection" property pointing to a platform specific
> object which configures and manages the specific details.
> 
> For now this series covers just AMD SEV and POWER PEF.  I'm hoping it
> can be extended to cover the Intel and s390 mechanisms as well,
> though.
> 
> Note: I'm using the term "guest memory protection" throughout to refer
> to mechanisms like this.  I don't particular like the term, it's both
> long and not really precise.  If someone can think of a succinct way
> of saying "a means of protecting guest memory from a possibly
> compromised hypervisor", I'd be grateful for the suggestion.

Many of the features are also going far beyond just protecting memory, so
even the "memory" part feels wrong.  Maybe something like protected-guest
or secure-guest?

A little imprecision isn't necessarily a bad thing, e.g. memory-encryption
is quite precise, but also wrong once it encompasses anything beyond plain
old encryption.
