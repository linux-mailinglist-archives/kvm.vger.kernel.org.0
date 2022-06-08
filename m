Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01342543D26
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 21:57:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbiFHT5x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 15:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiFHT5w (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 15:57:52 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 586513FBC0
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 12:57:51 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id o6so13479336plg.2
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 12:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KCcIdF4bqdmfr8ubKRfkXyFIonUIza6ThNxpED8m3mo=;
        b=EOXfKPxvRILHWhdHwsHEIz0IgPWoErm0CvypbNn+YmMYE1wCIOPFYQLM5Pjk0r5j0U
         7DrOiTQ6TZhE6eK6wCbVnTHJtVCvCSUXWFSyv81DNZrUaFNqIJysBDGR36/AQmBX7E3G
         Hl019QYZtmfuD77J90sL9H6QrAHCb0CaQPp9M1MNrjF5UfnRLIxbj/hCs0VRSpHP07wk
         d51WaCUhggbI59F99DCRy6t0iH2OGmoau9fUJp4sWnj+b1qN1xA1ZAPhTI3p+EnLSvQW
         DnTo1Aox2U8y8UuHD8AhXUre45jrt46WN9rUhy+NIceq3Lq6KFII62VO8LTRhy324N/I
         Zzpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KCcIdF4bqdmfr8ubKRfkXyFIonUIza6ThNxpED8m3mo=;
        b=pX02VX3VuKjW4AygEsNt+/SFEm+S9od9cT+x9Z+WMS9eIA3Q4JUjn/Xodp1XYxoPcu
         KqpnNva+JpoAa5wv49LKACXyBmrZ1cb0tetK+Bcph8whF3KDPho4hSHjWRo7ucwoLgvd
         hzuJJ1pxurS9EVOVXS0SRmcJTsvZ1gopkpdP/46Ee3Iv6Ib5eXIl7yDavZtEF3Tep10l
         SVkQXQCTebdHqmaah9Lkuk+cu3bf3wheqJT49tAZme6ddDXDJxsddnd7cUmgP2uTFAIm
         lNvz0ek0Dklrrgu/NDiEk+ug/5VDLjcDvVjSp2Hz/rI3NBE2F/P/MMyWJef1+a346rzz
         +Yfw==
X-Gm-Message-State: AOAM5306fsR+N4fve5WGUAGboO7hO7Kk+VxBWmA0miiGA5IlcX6y60Mg
        k4C5N1GfGpSdJpxePJh4LZ2/4A==
X-Google-Smtp-Source: ABdhPJzme/8tg/Dp9s2wqqCOyNvtCvz6tGbPMASz1ZpKobwC+W6OShIKP4aG0TVY5OF8A9rtobE7Lw==
X-Received: by 2002:a17:90b:180b:b0:1e3:2844:5f63 with SMTP id lw11-20020a17090b180b00b001e328445f63mr883477pjb.164.1654718270681;
        Wed, 08 Jun 2022 12:57:50 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gq20-20020a17090b105400b001e26da0d28csm14332578pjb.32.2022.06.08.12.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 12:57:49 -0700 (PDT)
Date:   Wed, 8 Jun 2022 19:57:45 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vasant Karasulli <vkarasulli@suse.de>
Cc:     linux-kernel@vger.kernel.org, jroedel@suse.de, kvm@vger.kernel.org,
        bp@alien8.de, x86@kernel.org, thomas.lendacky@amd.com
Subject: Re: [PATCH v6 2/4] x86/tests: Add tests for AMD SEV-ES #VC handling
 Add KUnit based tests to validate Linux's VC handling for instructions cpuid
 and wbinvd. These tests: 1. install a kretprobe on the #VC handler
 (sev_es_ghcb_hv_call, to access GHCB before/after the resulting VMGEXIT). 2.
 trigger an NAE by executing either cpuid or wbinvd. 3. check that the
 kretprobe was hit with the right exit_code available in GHCB.
Message-ID: <YqD/ObG9ae9YQVNy@google.com>
References: <20220318094532.7023-1-vkarasulli@suse.de>
 <20220318094532.7023-3-vkarasulli@suse.de>
 <Ykzrb1uyPZ2AKWos@google.com>
 <YqBivtMl74FGmz7r@vasant-suse>
 <YqCzy5Kngj+OgD2h@google.com>
 <YqDD/0IWnoMXEAWg@vasant-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqDD/0IWnoMXEAWg@vasant-suse>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 08, 2022, Vasant Karasulli wrote:
> On Mi 08-06-22 14:35:55, Sean Christopherson wrote:
> > On Wed, Jun 08, 2022, Vasant Karasulli wrote:
> > > On Mi 06-04-22 01:22:55, Sean Christopherson wrote:
> > > > > +	if (ret) {
> > > > > +		kunit_info(test, "Could not register kretprobe. Skipping.");
> > > > > +		goto out;
> > > > > +	}
> > > > > +
> > > > > +	test->priv = kunit_kzalloc(test, sizeof(u64), GFP_KERNEL);
> > > >
> > > > Allocating 8 bytes and storing the pointer an 8-byte field is rather pointless :-)
> > > >
> > >
> > > Actually it's necessary to allocate memory to test->priv before using according to
> > > https://www.kernel.org/doc/html/latest/dev-tools/kunit/tips.html
> >
> > If priv points at structure of some form, sure, but you're storing a simple value.
> 
> Yes, I agree. The reason it was done this way I guess is that type of priv is a
> void pointer and storing a u64 value results in a compiler warning:
> cast from pointer to integer of different size [-Wpointer-to-int-cast].

An intermediate cast to "unsigned long" should make that go away.
