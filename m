Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5326640059B
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 21:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350596AbhICTQz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 15:16:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244110AbhICTQx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 15:16:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F02D6108E;
        Fri,  3 Sep 2021 19:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630696553;
        bh=BQ3atOGhagTKS/jN7T713TGmkTc5TaJTIHbqNKYO/50=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=k6URnp4SjueEReYTy8ipceiKt2Iy8AMtOH2L86uJVbhax1HCxnW4gA99NYB6DWHIk
         9Joe/Nh3PSoX22fk4xBAlSDjCDBYg/9vfRgaeUd+tnGr40r6n3m3h6bifEQyjEue7E
         hfftaBQgviQPMqvuPzzkY/R7gY8+7OfBK9hCJqBun6NyAvWZrir7Hqnlpm8yf989xc
         JzzX1MK3uSOJUdF32phEGbtKZNdQYouK38mhHIgYTnzhOK3zmTI6lMJfJWH+lxAKgM
         WW8s53fcoPLqgAAD+19j3gGemnwqs2uR5aAnqLUwJBH54L30wzHLnPau9HNDFbqlDp
         fA/ONeF3QZeKg==
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Kuppuswamy Sathyanarayanan 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <20210902184711.7v65p5lwhpr2pvk7@box.shutemov.name>
 <YTE1GzPimvUB1FOF@google.com>
 <20210903191414.g7tfzsbzc7tpkx37@box.shutemov.name>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <02806f62-8820-d5f9-779c-15c0e9cd0e85@kernel.org>
Date:   Fri, 3 Sep 2021 12:15:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210903191414.g7tfzsbzc7tpkx37@box.shutemov.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/3/21 12:14 PM, Kirill A. Shutemov wrote:
> On Thu, Sep 02, 2021 at 08:33:31PM +0000, Sean Christopherson wrote:
>> Would requiring the size to be '0' at F_SEAL_GUEST time solve that problem?
> 
> I guess. Maybe we would need a WRITE_ONCE() on set. I donno. I will look
> closer into locking next.

We can decisively eliminate this sort of failure by making the switch
happen at open time instead of after.  For a memfd-like API, this would
be straightforward.  For a filesystem, it would take a bit more thought.
