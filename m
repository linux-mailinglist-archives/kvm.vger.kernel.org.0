Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E623655B1
	for <lists+kvm@lfdr.de>; Tue, 20 Apr 2021 11:47:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231422AbhDTJrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Apr 2021 05:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbhDTJrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Apr 2021 05:47:49 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FC23C06174A;
        Tue, 20 Apr 2021 02:47:17 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0e52003145dfcc247b909a.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:5200:3145:dfcc:247b:909a])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 211971EC0103;
        Tue, 20 Apr 2021 11:47:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1618912036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RA9OKky7ZNF04E7Df2ew/ZUVIaSCqLlCAKVZUi2ytbI=;
        b=Z5IPqA3Dj6rCvU1FW2fGNMookHdlY3WCXL8wnlBGmBbAxD8xvtvmKnj12I48HYvUriAZsC
        G89fIO73z1hh67u8EpWSsatS5UBQw5Jtz0yO0eAqVnk16vi6/F5PanO7+uMQtQZFkfrWjH
        Xl7nUdtgHXMWRtFUk6la5ReMnUTPZJY=
Date:   Tue, 20 Apr 2021 11:47:13 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, ak@linux.intel.com,
        herbert@gondor.apana.org.au, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        David Rientjes <rientjes@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [RFC Part2 PATCH 04/30] x86/mm: split the physmap when adding
 the page in RMP table
Message-ID: <20210420094713.GD5029@zn.tnic>
References: <20210324170436.31843-1-brijesh.singh@amd.com>
 <20210324170436.31843-5-brijesh.singh@amd.com>
 <20210419123226.GC9093@zn.tnic>
 <befbe586-1c45-ebf7-709a-00150365e7ec@amd.com>
 <20210419165214.GF9093@zn.tnic>
 <30bff969-e8cf-a991-7660-054ea136855a@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <30bff969-e8cf-a991-7660-054ea136855a@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 19, 2021 at 12:46:53PM -0500, Brijesh Singh wrote:
> - KVM calls  alloc_page() to allocate a VMSA page. The allocator returns
> 0xffffc80000200000 (PFN 0x200, page-level=2M). The VMSA page is private
> page so KVM will call RMPUPDATE to add the page as a private page in the
> RMP table. While adding the RMP entry the KVM will use the page level=4K.

Right, and *here* we split the 2M page on the *host* so that there's no
discrepancy between the host pagetable and the RMP. I guess your patch
does exactly that. :)

And AFAIR, set_memory.c doesn't have the functionality to coalesce 4K
pages back into the corresponding 2M page. Which means, the RMP table is
in sync, more or less.

Thx and thanks for elaborating.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
