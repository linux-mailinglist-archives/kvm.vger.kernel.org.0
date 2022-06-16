Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A07AE54E05F
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 13:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiFPL4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 07:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiFPL4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 07:56:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26C0556777
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 04:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655380612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rTS4Ru6q5wkfAFGdhOcOOtweGcTY99abymNwrQxupEs=;
        b=dG9bRtPcVroFj/r6wSQqnniWqVpNQRH2r9/ntwNCKmrNFi9xvsWyJT5sPC9KYLE0KPK62v
        01rbMwYAagH7Eu5EzlSA90OyXsOkBtn0Nn9e6TnzfgqLnyRxFxGDKsBJJGAnpswaWmYNIf
        kn0+X4UiRZeiZEJMAUi7/UHiSzkp3/Q=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-574-jkgYVybiMquQ0VMz8NH0Fw-1; Thu, 16 Jun 2022 07:56:51 -0400
X-MC-Unique: jkgYVybiMquQ0VMz8NH0Fw-1
Received: by mail-ed1-f72.google.com with SMTP id y13-20020a056402358d00b0042dfb820070so1109009edc.6
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 04:56:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rTS4Ru6q5wkfAFGdhOcOOtweGcTY99abymNwrQxupEs=;
        b=Kjnf2R55w0wHsPyEokhjxrc8s9CVYGw3oTkksPFDWnU/JHgUGFNJev4HoSJ4ZtGNGO
         O2MLb5O693uV/geiFKNlOys+xa0vbB5l3+QPw1IjjsYuKe7LUEl3I2j/TvhQKKH9S5Wd
         tVT1g98vuYs+xrSf5+FUO05JmPk4lb78HLJ+jbmRlO59L+2f7c9YYnk4McoE4wXOIlbx
         7cn6kqSa5ZW47WE4T0Z1kAw88Tb+eycKCrJSxIW6HoD4gG59SgdT6Z3Ql/0imW44DS56
         bbsdOEGFyL7+mi8N4Gq18BbXrzByFMLYvytBxsZAk4110byFzZHHUBfttWcKTgl11cjT
         UNzw==
X-Gm-Message-State: AJIora/3Afo3bA+lCP3FcIaFxXpUk7Ggg3i/o1WpZll3wLCdoJbXeIJ+
        emYwJT1ryKtqvmJIwoRI6RZIrPfUkB2P61FEx8ZLKQnAWaTjcyWgaVpNpmVgyzbjcFi1CNEU32t
        UkuHc1Lx1fd2U
X-Received: by 2002:a17:906:3bd9:b0:6ff:4b5:4a8f with SMTP id v25-20020a1709063bd900b006ff04b54a8fmr4307477ejf.139.1655380608860;
        Thu, 16 Jun 2022 04:56:48 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uGpra585Vb8v5dAS/elhzOAjRLEQ1D6qvI1AvZ8kfeI9cCaypkcfA5Fji5/hH8AnDxc9FJPw==
X-Received: by 2002:a17:906:3bd9:b0:6ff:4b5:4a8f with SMTP id v25-20020a1709063bd900b006ff04b54a8fmr4307465ejf.139.1655380608690;
        Thu, 16 Jun 2022 04:56:48 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id c6-20020a170906170600b00706242d297fsm656208eje.212.2022.06.16.04.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 04:56:48 -0700 (PDT)
Date:   Thu, 16 Jun 2022 13:56:46 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Varad Gautam <varad.gautam@suse.com>, kvm@vger.kernel.org,
        pbonzini@redhat.com, marcorr@google.com, zxwang42@gmail.com,
        erdemaktas@google.com, rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 02/11] x86: Move ap_init() to smp.c
Message-ID: <20220616115646.7u2bgbyppgzjivk6@gator>
References: <20220426114352.1262-1-varad.gautam@suse.com>
 <20220426114352.1262-3-varad.gautam@suse.com>
 <YqpPmz2SUP5nsUL+@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqpPmz2SUP5nsUL+@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022 at 09:31:07PM +0000, Sean Christopherson wrote:
> On Tue, Apr 26, 2022, Varad Gautam wrote:
> > +	printf("smp: waiting for %d APs\n", _cpu_count - 1);
> 
> Oof, this breaks run_test.sh / runtime.bash.  runtime.bash has a godawful hack
> to detect that dummy.efi ran cleanly; it looks for "enabling apic" as the last
> line to detect success.  I'll add a patch to fix this by having dummy.c print an
> explicit magic string, e.g. Dummy Hello World!.
>

powerpc and s390x always exit with

 printf("\nEXIT: STATUS=%d\n", ((code) << 1) | 1);

It's because they can only exit with exit code zero, but maybe it's worth
adopting the same line and format for EFI tests?

Thanks,
drew

