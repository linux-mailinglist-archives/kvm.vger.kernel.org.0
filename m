Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A564293B14
	for <lists+kvm@lfdr.de>; Tue, 20 Oct 2020 14:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394272AbgJTMSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Oct 2020 08:18:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40217 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394178AbgJTMSz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 20 Oct 2020 08:18:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603196334;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pRFnW5gWRuNF8oIJWmD5GYqoHTlkBEqfo58HkD0f8TY=;
        b=W+wZU3uqsZjbO3V+Tg5z1dVevAvzbTE0HiWu+RH4HGSf1QwfTASbse8iGyEFZ9I5AkTeOJ
        oNVBZRKcd92r+4nWHPjq24Xp/xWCsG+FNv3gl1Uu2WFrkqxmgk9yBjX8x9SExmOoVmSPd7
        kwoaBOwoVVbw6vxp+M89vn7no0pbj2c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-2PWSTa4ePPS2qoetoKllmg-1; Tue, 20 Oct 2020 08:18:52 -0400
X-MC-Unique: 2PWSTa4ePPS2qoetoKllmg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74C3F8049DB;
        Tue, 20 Oct 2020 12:18:49 +0000 (UTC)
Received: from [10.36.114.141] (ovpn-114-141.ams2.redhat.com [10.36.114.141])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3C896EF44;
        Tue, 20 Oct 2020 12:18:43 +0000 (UTC)
Subject: Re: [RFCv2 15/16] KVM: Unmap protected pages from direct mapping
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mike Rapoport <rppt@linux.ibm.com>
Cc:     David Rientjes <rientjes@google.com>,
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
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-16-kirill.shutemov@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <f153ef1a-a758-dec7-b39c-9990aac9d653@redhat.com>
Date:   Tue, 20 Oct 2020 14:18:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201020061859.18385-16-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20.10.20 08:18, Kirill A. Shutemov wrote:
> If the protected memory feature enabled, unmap guest memory from
> kernel's direct mappings.

Gah, ugly. I guess this also defeats compaction, swapping, ... oh gosh.
As if all of the encrypted VM implementations didn't bring us enough
ugliness already (SEV extensions also don't support reboots, but can at
least kexec() IIRC).

Something similar is done with secretmem [1]. And people don't seem to
like fragmenting the direct mapping (including me).

[1] https://lkml.kernel.org/r/20200924132904.1391-1-rppt@kernel.org

-- 
Thanks,

David / dhildenb

