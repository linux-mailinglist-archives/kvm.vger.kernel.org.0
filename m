Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC60254D4FD
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 01:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347839AbiFOXNn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 19:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346887AbiFOXNl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 19:13:41 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 834AB2E9D2
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:13:40 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id f65so12733634pgc.7
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 16:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/ALvs73vYSvdpYoHFhN5IctBnqUtOgNsLzN+VqtnNT0=;
        b=h1E2PmR8byBttk6rCTAeQY101X9RUN0lUMKLIWap+snfWXTzRTGJR4syrXw2RtQvsd
         /qUVrrXqkkfFid63YuMw0S1yQ0CLPzajGM0LxHi4FkUdD55ug4F3BljGyr6LY5O6G7mB
         fiRyUsR6FuB61+1kLMttqMTXjWPCvnFh9TCt3zJS9UUqEMpXnaMqCGjfejgx8s1OZq7f
         r38lpEOEeRkngFNlq1SvE4JyWF7SGhYh+3UBRM80yGFXXtVhtcUNpxVkhGIY0RBgqYzD
         2Z85KmUPIBDWPMUqlDfOwsm05d8wkZdUY+1xsXhD+4JUG9CzYsREVIOCZTihOksNgYKU
         VT8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/ALvs73vYSvdpYoHFhN5IctBnqUtOgNsLzN+VqtnNT0=;
        b=conAXY/DP/uKlpYLkTEHISNlc0QZha9JwQh+zjfd3i10Tj6ohr6TcscFjr/oBoYMz0
         B6ZVEvmM9kL9m3P1hJbXh0tvceVWaLdxqQAafjDhcOOX9rFlypXjI7/aWht6GRwv9640
         fTWEmpHlHiMva189lrc7Ayu8L29lJpX279R28Cm5+6pK5KGGvxBtCWQG8cfeYZHMJivg
         iGjoU7d88p1tY76OoLcQdMJRg4qxFNieT9FJttTvXv6hQo3fVngYB6dL+iFeyDjOgKI+
         DeT0ZJlSKBCaL254gV7XJu9cB9J3lV1oLOcgVUo/s5xsnh2lRbR5R08AB5QYFXjobfUp
         ZozQ==
X-Gm-Message-State: AJIora9GBPdTIgEedHOpx4zr0UoINxyT/Ud7bjcx8H640JVx9nZSzXTU
        MWFSarL5prWtdtdEm/nFWwkFjQ==
X-Google-Smtp-Source: AGRyM1tDgKAdNkhIjqCWq8pEFAtjB6CuyAbD+SKfpaTkA6QodrleMrBse60KNuwzwyo5OVlcUENvBA==
X-Received: by 2002:aa7:8890:0:b0:51c:454f:c93f with SMTP id z16-20020aa78890000000b0051c454fc93fmr1773732pfe.35.1655334819802;
        Wed, 15 Jun 2022 16:13:39 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id c9-20020a62f849000000b0051b32c2a5a7sm166769pfm.138.2022.06.15.16.13.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 16:13:39 -0700 (PDT)
Date:   Wed, 15 Jun 2022 23:13:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v3 11/11] x86: Provide a common 64-bit AP
 entrypoint for EFI and non-EFI
Message-ID: <YqpnoHntuPDggAKc@google.com>
References: <20220426114352.1262-1-varad.gautam@suse.com>
 <20220426114352.1262-12-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426114352.1262-12-varad.gautam@suse.com>
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

On Tue, Apr 26, 2022, Varad Gautam wrote:
> +void ap_start64(void)
> +{
> +	setup_gdt_tss();
> +	reset_apic();
> +	load_idt();
> +	save_id();
> +	enable_apic();
> +	enable_x2apic();
> +	sti();
> +	asm volatile ("nop");
> +	printf("setup: AP %d online\n", apic_id());
> +	atomic_inc(&cpu_online_count);
> +	while (1) {

Unnecessary curly braces.  And rather then spin, let's do "hlt", that way everything
from the sti onwards can be moved to a common helper, e.g. ap_online().
