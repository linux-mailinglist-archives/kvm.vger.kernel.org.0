Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A42706E9988
	for <lists+kvm@lfdr.de>; Thu, 20 Apr 2023 18:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbjDTQb1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Apr 2023 12:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjDTQbY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Apr 2023 12:31:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E50DE77;
        Thu, 20 Apr 2023 09:31:21 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 977FF21A14;
        Thu, 20 Apr 2023 16:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1682008279; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2vbLoApHWWuDvlIYJY/7MrXOyrVieSuLGNdDWo7gZ4I=;
        b=S9pFjdEC0JTo/RCJM5CnYDyb/QoYQOzQy/CvitLpsvwmcChEObw0XZLw617Gw56a7+j3iD
        QpNsvrBE2AH/XaMx3KKlx48T0A9CzZXR8wcDodYGqxs33GkoK5DQNzxuCt8PfiwgwxAy7d
        j67iCDamnbETaMdR6k2EO0O2uU18DWU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1682008279;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2vbLoApHWWuDvlIYJY/7MrXOyrVieSuLGNdDWo7gZ4I=;
        b=kRdOKfwlpUyj0B8yvJsIRfqkatWgwOj9y7NQ2vqZDh088EhuZrNAMvaTHSqbYsT2uJTAxv
        aSNaixUKPGBz0zCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1789313584;
        Thu, 20 Apr 2023 16:31:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vCD/BNdoQWSpegAAMHmgww
        (envelope-from <vbabka@suse.cz>); Thu, 20 Apr 2023 16:31:19 +0000
Message-ID: <9c8829f6-8049-2c83-49a4-285757cc9259@suse.cz>
Date:   Thu, 20 Apr 2023 18:31:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH RFC v8 12/56] x86/sev: Add RMP entry lookup helpers
Content-Language: en-US
To:     Michael Roth <michael.roth@amd.com>
Cc:     kvm@vger.kernel.org, linux-coco@lists.linux.dev,
        linux-mm@kvack.org, linux-crypto@vger.kernel.org, x86@kernel.org,
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
 <b48ad925-eff0-8421-730a-6da13bf93ab6@suse.cz>
 <20230329225958.4s3nwcqyjwzydwsf@amd.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20230329225958.4s3nwcqyjwzydwsf@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/23 00:59, Michael Roth wrote:
> On Fri, Mar 03, 2023 at 04:28:39PM +0100, Vlastimil Babka wrote:
>> On 2/20/23 19:38, Michael Roth wrote:
>> > From: Brijesh Singh <brijesh.singh@amd.com>
>> > 
>> > The snp_lookup_page_in_rmptable() can be used by the host to read the RMP
>> > entry for a given page. The RMP entry format is documented in AMD PPR, see
>> > https://bugzilla.kernel.org/attachment.cgi?id=296015.
>> > 
>> > Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
>> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
>> > Signed-off-by: Michael Roth <michael.roth@amd.com>
>> > ---
>> 
>> > +/*
>> > + * Return 1 if the RMP entry is assigned, 0 if it exists but is not assigned,
>> > + * and -errno if there is no corresponding RMP entry.
>> > + */
>> 
>> Hmm IMHO the kernel's idiomatic way is to return 0 on "success" and I'd
>> assume the more intuitive expectation of success here if the entry is
>> assigned?
> 
> In general I'd agree. Here's it's a little awkward though.
> snp_lookup_rmpentry() sort of wants to be a bool, where true indicates
> an assigned entry was found, false indicates no assigned entry.
> 
> But it also has to deal with error values, so the most direct way to
> encapsulate that is true == 1, false == 0, and < 0 for errors.
> 
> Inverting it to align more with kernel expections of 0 == success/true
> gets awkward too, because stuff like:
> 
>   if (snp_lookup_rmpentry(...))
>     //error
> 
> still doesn't work the way most other functions written in this way
> would since it could still be "successful" if we were expecting PFN to
> be in shared state. So the return value needs special handling there
> too.
> 
> Would it make sense to define it something like this?:
> 
>   /*
>    * Query information about the RMP entry corresponding to the given
>    * PFN.
>    * 
>    * Returns 0 on success, and -errno if there was a problem accessing
>    * the RMP entry.
>    */
>   int snp_lookup_rmpentry(u64 pfn, int *level, bool *assigned)

Yeah that looks fine to me. Hope you find out it makes it easier to work
with in the callers too.

> 
>> The various callers seem to differ though so I guess it depends on
>> context. Some however don't distinguish their "failure" from an ERR and
>> maybe they should, at least for the purposes of the various printks?
> 
> Yes, regardless of what we decide above, the call-sites should properly
> distinguish between failure/assigned/not-assigned and report the
> information accordingly. I'll get those fixed up where needed.

Great, thanks!

> Thanks,
> 
> -Mike
> 
>> 
>> > +int snp_lookup_rmpentry(u64 pfn, int *level)
>> > +{
>> > +	struct rmpentry *e;
>> > +
>> > +	e = __snp_lookup_rmpentry(pfn, level);
>> > +	if (IS_ERR(e))
>> > +		return PTR_ERR(e);
>> > +
>> > +	return !!rmpentry_assigned(e);
>> > +}
>> > +EXPORT_SYMBOL_GPL(snp_lookup_rmpentry);
>> 

