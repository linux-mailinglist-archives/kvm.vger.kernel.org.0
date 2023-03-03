Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FE96A9A9D
	for <lists+kvm@lfdr.de>; Fri,  3 Mar 2023 16:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjCCP2o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Mar 2023 10:28:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbjCCP2n (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Mar 2023 10:28:43 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E753418B23;
        Fri,  3 Mar 2023 07:28:41 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 90ABA22CB1;
        Fri,  3 Mar 2023 15:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1677857320; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8AyWiAIq00eH63iNHHtdW6GZAdQH8mZn7Eq8c9MeEw=;
        b=dr+oLHzclmXO04/iJ9ki90C5t7maT5EUjsDO6UqNQmS5qsM/U7HsjCoKEqAvk+b7yRS8Z9
        UMOWnaO0czslTE9wwRStMuiaT/Sh91vSWzXHUJEk9yN6dpWvKs9efWAMDYY5sUBSAK5qSE
        +emINk7vBQu5tSZFQK3v29U9GUdLS2E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1677857320;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8AyWiAIq00eH63iNHHtdW6GZAdQH8mZn7Eq8c9MeEw=;
        b=933j/fR/dfZkxvtKeDKbP5LGrgSyjKVLpT6IWqNfB6CdpD5bcQLSgbzDx1PslqcBl2CETr
        +HLaOVsTiknBfLAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 074B0139D3;
        Fri,  3 Mar 2023 15:28:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id hsfpACgSAmQHOwAAMHmgww
        (envelope-from <vbabka@suse.cz>); Fri, 03 Mar 2023 15:28:40 +0000
Message-ID: <b48ad925-eff0-8421-730a-6da13bf93ab6@suse.cz>
Date:   Fri, 3 Mar 2023 16:28:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH RFC v8 12/56] x86/sev: Add RMP entry lookup helpers
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
        nikunj.dadhania@amd.com, Brijesh Singh <brijesh.singh@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
 <20230220183847.59159-13-michael.roth@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230220183847.59159-13-michael.roth@amd.com>
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
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
> entry for a given page. The RMP entry format is documented in AMD PPR, see
> https://bugzilla.kernel.org/attachment.cgi?id=296015.
> 
> Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---

> +/*
> + * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
> + * and -errno if there is no corresponding RMP entry.
> + */

Hmm IMHO the kernel's idiomatic way is to return 0 on "success" and I'd
assume the more intuitive expectation of success here if the entry is
assigned? The various callers seem to differ though so I guess it depends on
context. Some however don't distinguish their "failure" from an ERR and
maybe they should, at least for the purposes of the various printks?

> +int snp_lookup_rmpentry(u64 pfn, int *level)
> +{
> +	struct rmpentry *e;
> +
> +	e = __snp_lookup_rmpentry(pfn, level);
> +	if (IS_ERR(e))
> +		return PTR_ERR(e);
> +
> +	return !!rmpentry_assigned(e);
> +}
> +EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);

