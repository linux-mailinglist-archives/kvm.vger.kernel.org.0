Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92EDB6A990C
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 15:05:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjCCOFQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 09:05:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbjCCOFN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 09:05:13 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE1761529;
        Fri,  3 Mar 2023 06:05:12 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C2E3622C72;
        Fri,  3 Mar 2023 14:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1677852310; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAyHMSLU+ZAjg+fVvvS8HIYSzMW9bXu596gR+RmZV28=;
        b=OZYIFFVuw6oXAahfgkiI7/oLV2HorUHQKPuVFaHGSV1FQ52eFfviWY2ZVhsnGfMusLRBwh
        XNXKwNKDuGNdpnGWkW8BEKQlrdyPGJaLI9pNPW9letJQ+REJvnFOvGTr16yTDXowK8Z5GK
        1lrkSdwl4PbTp+XEm8ZjRfHUbolU9IE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1677852310;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qAyHMSLU+ZAjg+fVvvS8HIYSzMW9bXu596gR+RmZV28=;
        b=wpl6VlszaaUCfBqWylPJmkDjE6mriL1Af0Up1NXNdbJQ/AFxPePwT34tA2etKFMg1HPZ2N
        p9f0BEq5bCbeLUDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3977E1329E;
        Fri,  3 Mar 2023 14:05:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eOLlC5b+AWQ8DQAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 03 Mar 2023 14:05:10 +0000
Message-ID: <8670a645-f48f-1d64-e5a5-291f2593643a@suse.cz>
Date:   Fri, 3 Mar 2023 15:05:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v8 09/56] KVM: SEV: Handle memory backed by restricted
 memfd
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
        nikunj.dadhania@amd.com, Nikunj A Dadhania <nikunj@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-10-michael.roth@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230220183847.59159-10-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/20/23 19:38, Michael Roth wrote:
> From: Nikunj A Dadhania <nikunj@amd.com>
> 
> Do not pin the guest memory backed by a restrictedmem backend, as
> pages in the restrictedmem are already pinned. Instead, populate the
> pages array for these guests using the already-pinned pages provided by

IIUC the "already pinned" became "effectively unmovable and unevictable"
since the earlier versions, so that would be more accurate now?

> +static int sev_private_mem_get_pages(struct kvm *kvm, unsigned long addr,
> +				     unsigned long size, unsigned long npages,
> +				     struct page **pages)
> +{
> +	return kvm_vm_do_hva_range_op(kvm, addr, addr + size,
> +				      sev_private_mem_get_pages_handler, pages);
> +}
> +
>  /*
>   * Legacy SEV guest pin the pages and return the array populated with pinned
>   * pages.
> + *
> + * SEV guests using restricted memfd backend, pages are already marked as
> + * unmovable and unevictable. Populate the pages array for these guests using
> + * restrictedmem get_pfn.

Right.


