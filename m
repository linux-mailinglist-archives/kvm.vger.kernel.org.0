Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD2F23FF35C
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 20:42:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347086AbhIBSm4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 14:42:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347038AbhIBSmx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Sep 2021 14:42:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EF57610A2;
        Thu,  2 Sep 2021 18:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630608115;
        bh=6BoMcP5chkSrsK2RXEOXpWWeA5RODkgv0ciR/OeFF8g=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=axDU97TcWl+9FSZON5idbTgysIzP76JnTwD2j70wq7tXEJG584bESMkUgODDcoXmG
         6h0E9pFLwN4xCMh7eji6pPQPs/K2m/m43kPVPem6kHCDQ7tk9Mlyhx++NPF3AcwXBs
         Kv3O0fGOGSPHbSOxgSBAdKOr4PG+KVRhtYEGdZBymVGSGOamZbyVNJwF6K2X+twFOl
         +FX0hC6Zsg5AfnH/DBVHfjJRIM8hYa8aVX/yf3WbDBFMM8KLCPx5Ypg05oUoyCZS9U
         BhweFV3VPwGpbLXpsnRi2iyaHG5zy3mF+GOn5ZoZ8byw5L6VBaDpcqBE7qp1TsQQNa
         4esShkL525PWA==
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     Joerg Roedel <jroedel@suse.de>
Cc:     Yu Zhang <yu.c.zhang@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
 <20210901102437.g5wrgezmrjqn3mvy@linux.intel.com>
 <f37a61ba-b7ef-c789-5763-f7f237ae41cc@kernel.org> <YTCZAjdci5yx+n6l@suse.de>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <b10b09b0-d5ea-b72a-106a-4e1b0df4dc66@kernel.org>
Date:   Thu, 2 Sep 2021 11:41:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YTCZAjdci5yx+n6l@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/2/21 2:27 AM, Joerg Roedel wrote:
> On Wed, Sep 01, 2021 at 09:07:59AM -0700, Andy Lutomirski wrote:
>> In principle, you could actually initialize a TDX guest with all of its
>> memory shared and all of it mapped in the host IOMMU.
> 
> Not sure how this works in TDX, but in SEV code fetches are always
> treated as encrypted. So this approach would not work with SEV, not to
> speak about attestation, which will not work with this approach either
> :)
> 

Oof.
