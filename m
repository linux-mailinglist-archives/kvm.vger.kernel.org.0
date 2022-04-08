Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCC84F8FB9
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 09:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiDHHoP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 03:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiDHHoO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 03:44:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4CDD1B29C6
        for <kvm@vger.kernel.org>; Fri,  8 Apr 2022 00:42:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3B5D4215FE;
        Fri,  8 Apr 2022 07:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649403730; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QxwyHDZtEXM4rzJCdvrMYjBu7cW2XjJkdsdJapneQrs=;
        b=B/rD+5xQ8yzePJEmJmbTj6tpsEMBVxw0ieE44WcObgP8bJlJcRwCOvH8mf3HmtguPB1QRs
        5upNibkunxTPfkGeg4YQvvHqbuBnNi4g5QhYPfMi76jVunJqwPCFSYbwQ2pFFxRVGC9RF4
        mVplHX8Qx+iecNe40XVImeamSEviSEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649403730;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QxwyHDZtEXM4rzJCdvrMYjBu7cW2XjJkdsdJapneQrs=;
        b=qJU8zNERW/V4kx91q+AsAZJoKKcb0Qabq4ZZ4ew5ysfKQbOUot6pXxY9E++g8olgE2R+2l
        F5l1nVWWjkNBZeDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C782F13AA9;
        Fri,  8 Apr 2022 07:42:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K632LlHnT2JkFwAAMHmgww
        (envelope-from <jroedel@suse.de>); Fri, 08 Apr 2022 07:42:09 +0000
Date:   Fri, 8 Apr 2022 09:42:08 +0200
From:   Joerg Roedel <jroedel@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, drjones@redhat.com, marcorr@google.com,
        zxwang42@gmail.com, erdemaktas@google.com, rientjes@google.com,
        brijesh.singh@amd.com, Thomas.Lendacky@amd.com, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 04/11] lib: x86: Import insn decoder
 from Linux
Message-ID: <Yk/nUINKexK5mpa0@suse.de>
References: <20220224105451.5035-1-varad.gautam@suse.com>
 <20220224105451.5035-5-varad.gautam@suse.com>
 <YkzuvuLYjira8iOW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YkzuvuLYjira8iOW@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 06, 2022 at 01:37:02AM +0000, Sean Christopherson wrote:
> Do we really need Linux's decoder for this?  Linux needs a more robust decoder
> because it has to deal with userspace crud, but KUT should have full control over
> what code it encounters in a #VC handler, e.g. we should never have to worry about
> ignore prefixes on a WRMSR.  And looking at future patches, KUT is still looking
> at raw opcode bytes, e.g. 
> 
> 	/* Is it a WRMSR? */
> 	exit_info_1 = (ctxt->insn.opcode.bytes[1] == 0x30) ? 1 : 0;
> 
> and the giant switch in vc_ioio_exitinfo().
> 
> The decoder does bring a bit of cleanliness, but 2k+ lines of code that's likely
> to get stale fairly quickly is going to be a maintenance burden.  And we certainly
> don't need things like VEX prefix handling :-)
> 
> Do you happen to have data on how often each flavors of instructions is encountered?
> E.g. can we get away with a truly minimal "decoder" by modifying select tests to
> avoid hard-to-decode instructions?  Or even patch them to do VMGEXIT directly?

Is it really less pain to have this code in KUT than not having it? The
code for the instruction decoder is maintained in the kernel source
tree, and KUT just can pull in a new version if needed.

I think it is much better to include this code than to work around its
absence every time it is needed, even when it is capable of doing more
than is needed in this context.

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

