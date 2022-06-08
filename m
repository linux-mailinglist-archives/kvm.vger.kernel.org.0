Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5CE542B7A
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 11:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiFHJ0V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 05:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbiFHJZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 05:25:38 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6736ED79A;
        Wed,  8 Jun 2022 01:50:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 47E961F8B5;
        Wed,  8 Jun 2022 08:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654678208; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1xQpYTHdUzGHRsbIMiCm0hyjXxogHxF1cpWBqpO7kAM=;
        b=CE63Xf60s3EEG2UNMGVXQdb41nu7OUJuEwSbsnbkMRyGg/FTwAabDZDkcHd/v2saZam2Ho
        hQXkIuwaOiQvDpAiqvAR5+RSM0Yk0sMwQBJnRLxQfEI4py8yGPojsvP9ije2VtO75URIjW
        x4cvLxMdnSej59HGi041MbxG+vjxsWw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654678208;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1xQpYTHdUzGHRsbIMiCm0hyjXxogHxF1cpWBqpO7kAM=;
        b=ODgkIreevZKOXnL2gqmZJNWfiFmH5heOhtoQjLDarKVZ446lglgitbxLS6zSQUw5Ms4++6
        v55DFY9vzZwv6dDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id F2EBF13AD9;
        Wed,  8 Jun 2022 08:50:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XmnDOb9ioGLASwAAMHmgww
        (envelope-from <vkarasulli@suse.de>); Wed, 08 Jun 2022 08:50:07 +0000
Date:   Wed, 8 Jun 2022 10:50:06 +0200
From:   Vasant Karasulli <vkarasulli@suse.de>
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, jroedel@suse.de, kvm@vger.kernel.org,
        bp@alien8.de, x86@kernel.org, thomas.lendacky@amd.com
Subject: Re: [PATCH v6 2/4] x86/tests: Add tests for AMD SEV-ES #VC handling
 Add KUnit based tests to validate Linux's VC handling for instructions cpuid
 and wbinvd. These tests: 1. install a kretprobe on the #VC handler
 (sev_es_ghcb_hv_call, to access GHCB before/after the resulting VMGEXIT). 2.
 trigger an NAE by executing either cpuid or wbinvd. 3. check that the
 kretprobe was hit with the right exit_code available in GHCB.
Message-ID: <YqBivtMl74FGmz7r@vasant-suse>
References: <20220318094532.7023-1-vkarasulli@suse.de>
 <20220318094532.7023-3-vkarasulli@suse.de>
 <Ykzrb1uyPZ2AKWos@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ykzrb1uyPZ2AKWos@google.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mi 06-04-22 01:22:55, Sean Christopherson wrote:
> > +	if (ret) {
> > +		kunit_info(test, "Could not register kretprobe. Skipping.");
> > +		goto out;
> > +	}
> > +
> > +	test->priv = kunit_kzalloc(test, sizeof(u64), GFP_KERNEL);
>
> Allocating 8 bytes and storing the pointer an 8-byte field is rather pointless :-)
>

Actually it's necessary to allocate memory to test->priv before using according to
https://www.kernel.org/doc/html/latest/dev-tools/kunit/tips.html

> > +	if (!test->priv) {
> > +		ret = -ENOMEM;
> > +		kunit_info(test, "Could not allocate. Skipping.");
> > +		goto out;
> > +	}
> > +

--
Vasant Karasulli
Kernel generalist
www.suse.com<http://www.suse.com>
[https://www.suse.com/assets/img/social-platforms-suse-logo.png]<http://www.suse.com/>
SUSE - Open Source Solutions for Enterprise Servers & Cloud<http://www.suse.com/>
Modernize your infrastructure with SUSE Linux Enterprise servers, cloud technology for IaaS, and SUSE's software-defined storage.
www.suse.com

