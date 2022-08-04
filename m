Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00E4E589AA1
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 12:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239158AbiHDK4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Aug 2022 06:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239183AbiHDK40 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Aug 2022 06:56:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5ED13E33;
        Thu,  4 Aug 2022 03:56:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 84CC520EDD;
        Thu,  4 Aug 2022 10:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1659610583; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mlktYDm7Q9WWK6B+W/bogBPhH4hH8aSA3B4MxQAXBh8=;
        b=TPP8b3t9rP/4eLEeZXO6gehvwrqcL7GwZPmNp1ThS0tbE/j1542zCGpq07mMbmExjzmwlX
        lXfgzuJ0CY6iYJqXmo4ApAu9S70VWGRjriAiRy5aI4x0SlodVrU8dHzjD3ON/ppZumNNz6
        +x3nxSFky7Yjy+JgErlSstlF1EA2l8I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1659610583;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mlktYDm7Q9WWK6B+W/bogBPhH4hH8aSA3B4MxQAXBh8=;
        b=o817tBQaO2BN6keT74Cjjte1SJotvXncGsbi9oVX1SnL7Y2Brd2tIf1H/kzQQWeXDBGYly
        BMVwf/IvHGGT+ZCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 06ED513A94;
        Thu,  4 Aug 2022 10:56:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YtDiANel62J/GwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 04 Aug 2022 10:56:23 +0000
Message-ID: <5c6e8435-22bb-234a-87a1-96c9f4e93dc9@suse.cz>
Date:   Thu, 4 Aug 2022 12:56:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
Subject: Re: [PATCH Part2 v6 27/49] KVM: SVM: Mark the private vma unmerable
 for SEV-SNP guests
Content-Language: en-US
To:     Ashish Kalra <Ashish.Kalra@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org
Cc:     tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de,
        thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        jmattson@google.com, luto@kernel.org, dave.hansen@linux.intel.com,
        slp@redhat.com, pgonda@google.com, peterz@infradead.org,
        srinivas.pandruvada@linux.intel.com, rientjes@google.com,
        dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de,
        michael.roth@amd.com, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org
References: <cover.1655761627.git.ashish.kalra@amd.com>
 <bb10f0a4c5eb13a5338f77ef34f08f1190d4ae30.1655761627.git.ashish.kalra@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <bb10f0a4c5eb13a5338f77ef34f08f1190d4ae30.1655761627.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/22 01:08, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> When SEV-SNP is enabled, the guest private pages are added in the RMP
> table; while adding the pages, the rmp_make_private() unmaps the pages
> from the direct map. If KSM attempts to access those unmapped pages then
> it will trigger #PF (page-not-present).
> 
> Encrypted guest pages cannot be shared between the process, so an
> userspace should not mark the region mergeable but to be safe, mark the
> process vma unmerable before adding the pages in the RMP table.
> 
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Note this doesn't really mark the vma unmergeable, rather it unmarks it as
mergeable, and unmerges any already merged pages.
Which seems like a good idea. Is snp_launch_update() the only place that
needs it or can private pages be added elsewhere too?

However, AFAICS nothing stops userspace to do another
madvise(MADV_MERGEABLE) afterwards, so we should make somehow sure that ksm
will still be prevented, as we should protect the kernel even from a buggy
userspace. So either we stop it with a flag at vma level (see ksm_madvise()
for which flags currently stop it), or page level - currently only
PageAnon() pages are handled. The vma level is probably easier/cheaper.

It's also possible that this will solve itself with the switch to UPM as
those vma's or pages might be incompatible with ksm naturally (didn't check
closely), and then this patch can be just dropped. But we should double-check.

