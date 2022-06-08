Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E20E5432B6
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 16:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241449AbiFHOgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 10:36:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241254AbiFHOgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 10:36:03 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B72F4C7AC
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 07:35:59 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o6-20020a17090a0a0600b001e2c6566046so24004651pjo.0
        for <kvm@vger.kernel.org>; Wed, 08 Jun 2022 07:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sM0vOKDLuM2x2RGbr6R+WhU1WWlFw1qcwPB+NSg5ZHw=;
        b=ko20Wf2JiZcVDdP5ORLDqH5pV/VsUw6wkNmHKdQozby+SJ3T6C5fskDheWX12bDXCJ
         N+FQPua/+3TyfhjSHvTn1wRv0yc8nBU3ae9xXRfy6Y+U/tt0fnBt95SFHGWvxzVzxK/N
         OgFVuSzrQuOfq49/KiA9i5VnFpd+5OWPBgxbu1Nt0PUmbPe2xZjHEo7+ZM+79bA1VZkL
         xCyBOIFAutdc9RKxzHKFt0ut1l3fPOrtusEaZY+sHv6m9e3cZLqEaiAXq2boyb55NHho
         JJHcgrDgeFnt/lHI/UtBD15D6WceAZ+RWSfG/kwp8Eg/Xpgin2tZ22BZ7DonSvSHfHe6
         6o0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sM0vOKDLuM2x2RGbr6R+WhU1WWlFw1qcwPB+NSg5ZHw=;
        b=YA5b9GLvUD9msvNK2JCggMkHn3N6VkJDeolf5V3o6bXn8evnpXHNPf+vzEt885+mV7
         E4lk3PLwjaZx7RnNclp998jdbWGrc392cWgzRDVJ6aglUV0M+QHz/3GeozbKJWowuwlN
         JEJIglF2cp9/0XSP73EZNk/fM13dTrZw7g1zxC5VReAEd1EDE1KhN68mMwyd1oxKsv86
         rjLujS8cBVpWXnL8KvAc4A77GH2g691/GWI+OXArKv4/MclOcKrcNJ+e/DNot+QW3SAk
         l+GQqpluUKilsY05QilStfHVI0E8uY9BTO4jpTs8VtRmtPcwm8284GDInRy73hVjARfs
         bCLQ==
X-Gm-Message-State: AOAM5317TAiBOqw6qKbuIdspDC+QR5IIOUixX08JJPNWY1AVOZZaUCZO
        gzmBmgqJCGVp1P1QEHMn40Z7Ew==
X-Google-Smtp-Source: ABdhPJxJAqZcmDfalnGoe0B/xnu7nRMEbGz+uHvJu+Sj7j8FrGcHTLMVInI/TL1CUggwLMU/04AX6Q==
X-Received: by 2002:a17:902:7005:b0:163:ffe7:32eb with SMTP id y5-20020a170902700500b00163ffe732ebmr34934970plk.18.1654698958908;
        Wed, 08 Jun 2022 07:35:58 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h1-20020a655181000000b003fbaae74971sm15021736pgq.72.2022.06.08.07.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 07:35:58 -0700 (PDT)
Date:   Wed, 8 Jun 2022 14:35:55 +0000
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
Message-ID: <YqCzy5Kngj+OgD2h@google.com>
References: <20220318094532.7023-1-vkarasulli@suse.de>
 <20220318094532.7023-3-vkarasulli@suse.de>
 <Ykzrb1uyPZ2AKWos@google.com>
 <YqBivtMl74FGmz7r@vasant-suse>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqBivtMl74FGmz7r@vasant-suse>
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

On Wed, Jun 08, 2022, Vasant Karasulli wrote:
> On Mi 06-04-22 01:22:55, Sean Christopherson wrote:
> > > +	if (ret) {
> > > +		kunit_info(test, "Could not register kretprobe. Skipping.");
> > > +		goto out;
> > > +	}
> > > +
> > > +	test->priv = kunit_kzalloc(test, sizeof(u64), GFP_KERNEL);
> >
> > Allocating 8 bytes and storing the pointer an 8-byte field is rather pointless :-)
> >
> 
> Actually it's necessary to allocate memory to test->priv before using according to
> https://www.kernel.org/doc/html/latest/dev-tools/kunit/tips.html

If priv points at structure of some form, sure, but you're storing a simple value.
