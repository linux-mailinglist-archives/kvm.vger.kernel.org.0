Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9AF545C97A
	for <lists+kvm@lfdr.de>; Wed, 24 Nov 2021 17:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241998AbhKXQG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Nov 2021 11:06:57 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:52948 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241205AbhKXQGv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Nov 2021 11:06:51 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0DED12193C;
        Wed, 24 Nov 2021 16:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1637769819; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+K9X0gnKgAVGvjlnxJQwG5HJjl9FzPuLLZJhp/rDicQ=;
        b=TjZVpHr9twy3p2Y6wNd56k9PHBwLZ/ZwTJcdY5ck7SQC6QEFdmOB4fP7mqMyJh4Ghd/s9x
        oXYxD2FTZuUY5Mf8Gba2dcolshwOfCtr0a3a94gACWGcxWy+Ws87hC9rnGdoOtHGhpYX2p
        qs7i1nsaNkE2+nxUpjCfNXjcS9QXdwc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1637769819;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+K9X0gnKgAVGvjlnxJQwG5HJjl9FzPuLLZJhp/rDicQ=;
        b=/EU59iTj2EaHMP94a0Q2XP7zqwHQjqdwjcOzxkGdeGbZaNwurBRsabWvcMiJH1fbVskYZx
        63iV1KbmQrrX4iDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E5DC513F2A;
        Wed, 24 Nov 2021 16:03:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uNpjNllinmHoGAAAMHmgww
        (envelope-from <jroedel@suse.de>); Wed, 24 Nov 2021 16:03:37 +0000
Date:   Wed, 24 Nov 2021 17:03:36 +0100
From:   Joerg Roedel <jroedel@suse.de>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Peter Gonda <pgonda@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Borislav Petkov <bp@alien8.de>,
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZ5iWJuxjSCmZL5l@suse.de>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
 <d673f082-9023-dafb-e42e-eab32a3ddd0c@intel.com>
 <f15597a0-e7e0-0a57-39fd-20715abddc7f@amd.com>
 <5f3b3aab-9ec2-c489-eefd-9136874762ee@intel.com>
 <d83e6668-bec4-8d1f-7f8a-085829146846@amd.com>
 <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Nov 22, 2021 at 02:51:35PM -0800, Dave Hansen wrote:
> My preference would be that we never have SEV-SNP code in the kernel
> that can panic() the host from guest userspace.  If that means waiting
> until there's common guest unmapping infrastructure around, then I think
> we should wait.

Can you elaborate how to crash host kernel from guest user-space? If I
understood correctly it was about crashing host kernel from _host_
user-space.

I think the RMP-fault path in the page-fault handler needs to take the
uaccess exception tables into account before actually causing a panic.
This should solve most of the problems discussed here.

Maybe we also need the previously suggested copy_from/to_guest()
interfaces.

Regards,

-- 
Jörg Rödel
jroedel@suse.de

SUSE Software Solutions Germany GmbH
Maxfeldstr. 5
90409 Nürnberg
Germany
 
(HRB 36809, AG Nürnberg)
Geschäftsführer: Ivo Totev

