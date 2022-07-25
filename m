Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 461C957FE34
	for <lists+kvm@lfdr.de>; Mon, 25 Jul 2022 13:19:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbiGYLTb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Jul 2022 07:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiGYLTa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Jul 2022 07:19:30 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE3C15802;
        Mon, 25 Jul 2022 04:19:29 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C9DD237784;
        Mon, 25 Jul 2022 11:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1658747967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fsGXEvpXgpa8MJd9I5kGhBSqRiO/o6Xz4MHAqkV7RDk=;
        b=Gz71EENsDg6dNC88X0BdB9GDBrjspBCS9qbzDEOQ/iWz0SiagzJivwYHMaMeD41PQ+dlI+
        VHsHpr0zFlH6d8P8n6f1sU2dUl9yslL+1EaJe+/Sh+n1ohih6dj7woa2MyYq86/ACCNjDA
        5KAODZQYHvrt8J14qJDocRHImGDT9do=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1658747967;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fsGXEvpXgpa8MJd9I5kGhBSqRiO/o6Xz4MHAqkV7RDk=;
        b=6rKjRPkY2Y/kcUjOc6t9q/asPWGv1DEJ7cIAFX4WwWDU5cWaY9XiR/3aYOhnWbAtwNH/Rk
        /FythNPbFou+dkBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5997D13ABB;
        Mon, 25 Jul 2022 11:19:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id t8RXFT983mLUQgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Mon, 25 Jul 2022 11:19:27 +0000
Message-ID: <a0774cc5-17f8-94ca-a490-1a06a5dec1fd@suse.cz>
Date:   Mon, 25 Jul 2022 13:19:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH Part2 v6 33/49] KVM: x86: Update page-fault trace to log
 full 64-bit error code
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
 <a937386611dc7d38981c8a08255c4a71f1295d9a.1655761627.git.ashish.kalra@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <a937386611dc7d38981c8a08255c4a71f1295d9a.1655761627.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/21/22 01:10, Ashish Kalra wrote:
> From: Brijesh Singh <brijesh.singh@amd.com>
> 
> The #NPT error code is a 64-bit value but the trace prints only the
> lower 32-bits. Some of the fault error code (e.g PFERR_GUEST_FINAL_MASK)
> are available in the upper 32-bits.
> 
> Cc: <stable@kernel.org>

Why stable?

> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> ---
>  arch/x86/kvm/trace.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/trace.h b/arch/x86/kvm/trace.h
> index e3a24b8f04be..9b9bc5468103 100644
> --- a/arch/x86/kvm/trace.h
> +++ b/arch/x86/kvm/trace.h
> @@ -383,12 +383,12 @@ TRACE_EVENT(kvm_inj_exception,
>   * Tracepoint for page fault.
>   */
>  TRACE_EVENT(kvm_page_fault,
> -	TP_PROTO(unsigned long fault_address, unsigned int error_code),
> +	TP_PROTO(unsigned long fault_address, u64 error_code),
>  	TP_ARGS(fault_address, error_code),
>  
>  	TP_STRUCT__entry(
>  		__field(	unsigned long,	fault_address	)
> -		__field(	unsigned int,	error_code	)
> +		__field(	u64,		error_code	)
>  	),
>  
>  	TP_fast_assign(
> @@ -396,7 +396,7 @@ TRACE_EVENT(kvm_page_fault,
>  		__entry->error_code	= error_code;
>  	),
>  
> -	TP_printk("address %lx error_code %x",
> +	TP_printk("address %lx error_code %llx",
>  		  __entry->fault_address, __entry->error_code)
>  );
>  

