Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E65A356E28
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 16:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbhDGOJz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 10:09:55 -0400
Received: from mga17.intel.com ([192.55.52.151]:5732 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235632AbhDGOJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 10:09:10 -0400
IronPort-SDR: kyZyT5tZA4FKdE/ZwhTZN/ZICh/I0boBgrzLhUi7V3yf5xyKvewFs/TZGhvdfPxH8D2rAbWG9M
 R8m1VXW+CBnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="173392698"
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="173392698"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 07:09:00 -0700
IronPort-SDR: hPxEBTTpnEm6zCPwBedLV0vjmkvgtbOhKY4mExcIZZRx2HqXB1MOx29/5/ldkfN3f6QDqEi56e
 +EMb5TDMGXiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,203,1613462400"; 
   d="scan'208";a="530217945"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.54.74.11])
  by orsmga004.jf.intel.com with ESMTP; 07 Apr 2021 07:09:00 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 42C653001E2; Wed,  7 Apr 2021 07:09:00 -0700 (PDT)
From:   Andi Kleen <ak@linux.intel.com>
To:     Christophe de Dinechin <cdupontd@redhat.com>
Cc:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        David Hildenbrand <david@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Rientjes <rientjes@google.com>,
        "Edgecombe\, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen\, Andi" <andi.kleen@intel.com>,
        "Yamahata\, Isaku" <isaku.yamahata@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [RFCv1 7/7] KVM: unmap guest memory using poisoned pages
In-Reply-To: <C841A818-7BBE-48B5-8CCB-1F8850CA52AD@redhat.com> (Christophe de
        Dinechin's message of "Wed, 7 Apr 2021 15:31:28 +0200")
References: <20210402152645.26680-1-kirill.shutemov@linux.intel.com>
        <20210402152645.26680-8-kirill.shutemov@linux.intel.com>
        <c5f2580d-0733-4523-d1e8-c43b487f0aaf@redhat.com>
        <52518f09-7350-ebe9-7ddb-29095cd3a4d9@intel.com>
        <d94d3042-098a-8df7-9ef6-b869851a4134@redhat.com>
        <20210407131647.djajbwhqsmlafsyo@box.shutemov.name>
        <C841A818-7BBE-48B5-8CCB-1F8850CA52AD@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
Date:   Wed, 07 Apr 2021 07:09:00 -0700
Message-ID: <87zgyauqyr.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Christophe de Dinechin <cdupontd@redhat.com> writes:

> Is there even a theoretical way to restore an encrypted page e.g. from (host)
> swap without breaking the integrity check? Or will that only be possible with
> assistance from within the encrypted enclave?

Only the later.

You would need balloning. It's in principle possible, but currently
not implemented.

In general host swap without balloning is usually a bad idea anyways
because it often just swaps a lot of cache data that could easily be
thrown away instead.

-andi
