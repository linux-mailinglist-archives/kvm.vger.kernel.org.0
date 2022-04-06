Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 272824F6582
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 18:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbiDFQcL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 12:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237328AbiDFQbB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 12:31:01 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D17C2A4FB3
        for <kvm@vger.kernel.org>; Tue,  5 Apr 2022 18:37:07 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id x31so1110387pfh.9
        for <kvm@vger.kernel.org>; Tue, 05 Apr 2022 18:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2IVjXpqdnyNh0nj91yzDQ7XdIq9/i/b6orJoDATZyIM=;
        b=IZxfcovyf3hiu+JalD416J6B4FRgWyKfXB5fNfBr1lw8g+2fV8F8qH0+AceeKqL4aW
         DSUzScrW2SFagkoo41IqwpM2XaV72KSbfeH+bJMioNmMhOZZFF860Dhl5F1EE74Xww3K
         FeKgdQNxvB/AuDWtcKfFJTjfblIkdZ+Cb81UvVWO3inSHN1ZFJSU9Fi7I+L5uwE0+So8
         27B8ZA/LymthP8Z1Qf/kkQl/yxuvMRll9NzOKDZJfZbjcFUI0SfDvkG76C8XzGnJmoAm
         V4suKL1ZOR406wcPa/V7zRZwh/cJSUP+osSXxNYbYy6My03Zks+ETCnnuWOgbrU3Ycho
         lhxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2IVjXpqdnyNh0nj91yzDQ7XdIq9/i/b6orJoDATZyIM=;
        b=r+PDuvMOchYw4s3/2Jbbm2khsaFWsidUmNSFhhBYOF3eI2My7kptmSCIZ8YvVJM/Q4
         iFr5E96SZS6yoG2pTdrBf8E51kbO/VGbZUKdmUOjMVKZqnqwdpIqcYF19ROiVTVd4u+k
         wmrhmXRIB5Dvh35L0+ioPurP7o4gOjcUSD1tW1UCH0YTvssX8knStssuhOYE0F5yfrx7
         p4v1vCjA3ZA0hN20aJe5Jppwsf7j7MpEuPJllYLKbaP4cizNj0wQZsHjUQgcNjJ8ANvJ
         x/75ci/hIsGI1UhgJfw3cXF/91w4S5bQ2jqVvCM0lROe533H7ozb/XLOyhFfZQk8R6VM
         021g==
X-Gm-Message-State: AOAM531AYHFRArT4w9ALDXT9hnubBpeglv22HxxCQGogFVuvTvuk9mAa
        udSeRq1Pv9muWU8pAUPjJufjKQ==
X-Google-Smtp-Source: ABdhPJxVi161nGKxjVwrZ2YmGzyw5zhSrR5oqzsP/KMw36fpl/A0I/m2FQ56iq3TUoRaK9KLPhh3ow==
X-Received: by 2002:a63:af4b:0:b0:373:a2a1:bf9a with SMTP id s11-20020a63af4b000000b00373a2a1bf9amr5189710pgo.369.1649209026558;
        Tue, 05 Apr 2022 18:37:06 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id n11-20020a638f0b000000b00398b4d7b9dbsm14320028pgd.75.2022.04.05.18.37.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Apr 2022 18:37:05 -0700 (PDT)
Date:   Wed, 6 Apr 2022 01:37:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 04/11] lib: x86: Import insn decoder
 from Linux
Message-ID: <YkzuvuLYjira8iOW@google.com>
References: <20220224105451.5035-1-varad.gautam@suse.com>
 <20220224105451.5035-5-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224105451.5035-5-varad.gautam@suse.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 24, 2022, Varad Gautam wrote:
> Processing #VC exceptions on AMD SEV-ES requires instruction decoding
> logic to set up the right GHCB state before exiting to the host.
> 
> Pull in the instruction decoder from Linux for this purpose.

Do we really need Linux's decoder for this?  Linux needs a more robust decoder
because it has to deal with userspace crud, but KUT should have full control over
what code it encounters in a #VC handler, e.g. we should never have to worry about
ignore prefixes on a WRMSR.  And looking at future patches, KUT is still looking
at raw opcode bytes, e.g. 

	/* Is it a WRMSR? */
	exit_info_1 = (ctxt->insn.opcode.bytes[1] == 0x30) ? 1 : 0;

and the giant switch in vc_ioio_exitinfo().

The decoder does bring a bit of cleanliness, but 2k+ lines of code that's likely
to get stale fairly quickly is going to be a maintenance burden.  And we certainly
don't need things like VEX prefix handling :-)

Do you happen to have data on how often each flavors of instructions is encountered?
E.g. can we get away with a truly minimal "decoder" by modifying select tests to
avoid hard-to-decode instructions?  Or even patch them to do VMGEXIT directly?
