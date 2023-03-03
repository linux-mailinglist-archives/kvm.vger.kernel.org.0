Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B2F6A9AB8
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 16:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjCCPcE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 10:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjCCPcC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 10:32:02 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A1D2312A;
        Fri,  3 Mar 2023 07:32:01 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 26E9422CB2;
        Fri,  3 Mar 2023 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1677857520; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DSoHdPcyObvsTluGoWuHF5NVQ3++ls8GhPdaBUb6qDE=;
        b=xWKYoPkqeefli/1vYLhDI4s8HE7WrAvJpUa3qKXByCEZB6657JSzIKaxlVCTW/8kZuoLii
        S8vtssyaz4Cv5eJzA7ckOZU4vZG4TBrQQuvzc8XsTpsXhaP2u2O37sjpuw7l/bO+rN+DBH
        10NeHu/nlMf5DdX3e7AWZ28RF7kWBvU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1677857520;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DSoHdPcyObvsTluGoWuHF5NVQ3++ls8GhPdaBUb6qDE=;
        b=jL0MqPH3l6f4U3fs78svw5HTblwFbZKZKsjF1NQaUTOrXQ2TB7WIdX78CV4QCpze5UHsCr
        Q6XNqBFBN8/TksCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8B3CA139D3;
        Fri,  3 Mar 2023 15:31:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 5xRJIe8SAmT3PAAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 03 Mar 2023 15:31:59 +0000
Message-ID: <846ff1ae-ba1e-8c57-f727-511c09ac0807@suse.cz>
Date:   Fri, 3 Mar 2023 16:31:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v8 17/56] x86/fault: Add support to handle the RMP
 fault for user address
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>, kvm@vger.kernel.org
Cc:     linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        jroedel@suse.de, thomas.lendacky@amd.com, hpa@zytor.com,
        ardb@kernel.org, pbonzini@redhat.com, seanjc@google.com,
        vkuznets@redhat.com, jmattson@google.com, luto@kernel.org,
        dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com,
        peterz@infradead.org, srinivas.pandruvada@linux.intel.com,
        rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com,
        bp@alien8.de, kirill@shutemov.name, ak@linux.intel.com,
        tony.luck@intel.com, marcorr@google.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com,
        dgilbert@redhat.com, jarkko@kernel.org, ashish.kalra@amd.com,
        nikunj.dadhania@amd.com, Brijesh Singh <brijesh.singh@amd.com>,
        Jarkko Sakkinen <jarkko.sakkinen@profian.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-18-michael.roth@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230220183847.59159-18-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 19:38, Michael Roth wrote:
> +static int handle_user_rmp_page_fault(struct pt_regs *regs, unsigned long error_code,
> +				      unsigned long address)
> +{
> +	int rmp_level, level;
> +	pgd_t *pgd;
> +	pte_t *pte;
> +	u64 pfn;
> +
> +	pgd = __va(read_cr3_pa());
> +	pgd += pgd_index(address);
> +
> +	pte = lookup_address_in_pgd(pgd, address, &level);
> +
> +	/*
> +	 * It can happen if there was a race between an unmap event and
> +	 * the RMP fault delivery.
> +	 */
> +	if (!pte || !pte_present(*pte))
> +		return RMP_PF_UNMAP;
> +
> +	/*
> +	 * RMP page fault handler follows this algorithm:
> +	 * 1. Compute the pfn for the 4kb page being accessed
> +	 * 2. Read that RMP entry -- If it is assigned then kill the process
> +	 * 3. Otherwise, check the level from the host page table
> +	 *    If level=PG_LEVEL_4K then the page is already smashed
> +	 *    so just retry the instruction
> +	 * 4. If level=PG_LEVEL_2M/1G, then the host page needs to be split
> +	 */
> +
> +	pfn = pte_pfn(*pte);
> +
> +	/* If its large page then calculte the fault pfn */
> +	if (level > PG_LEVEL_4K)
> +		pfn = pfn | PFN_DOWN(address & (page_level_size(level) - 1));
> +
> +	/*
> +	 * If its a guest private page, then the fault cannot be resolved.
> +	 * Send a SIGBUS to terminate the process.
> +	 *
> +	 * As documented in APM vol3 pseudo-code for RMPUPDATE, when the 2M range
> +	 * is covered by a valid (Assigned=1) 2M entry, the middle 511 4k entries
> +	 * also have Assigned=1. This means that if there is an access to a page
> +	 * which happens to lie within an Assigned 2M entry, the 4k RMP entry
> +	 * will also have Assigned=1. Therefore, the kernel should see that
> +	 * the page is not a valid page and the fault cannot be resolved.
> +	 */
> +	if (snp_lookup_rmpentry(pfn, &rmp_level)) {
> +		pr_info("Fatal RMP page fault, terminating process, entry assigned for pfn 0x%llx\n",
> +			pfn);
> +		do_sigbus(regs, error_code, address, VM_FAULT_SIGBUS);
> +		return RMP_PF_RETRY;
> +	}

WRT my reply to 12/56, for example here it might be useful to distinguish
the rmp being assigned from an error of snp_lookup_rmpentry()?

> +
> +	/*
> +	 * The backing page level is higher than the RMP page level, request
> +	 * to split the page.
> +	 */
> +	if (level > rmp_level)
> +		return RMP_PF_SPLIT;
> +
> +	return RMP_PF_RETRY;
> +}
> +
>  /*

