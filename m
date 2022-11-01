Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3A4614EE5
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 17:13:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiKAQNp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 12:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKAQNn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 12:13:43 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69E61C42C
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 09:13:42 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id v4-20020a17090a088400b00212cb0ed97eso13302622pjc.5
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 09:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nk9Zj5yWhkiJNSaUjwt3uwdSYsNnenBADlut1qfzb/c=;
        b=Qf7LaT+jXyZwyffGV6Uu8kqE/SPSE05I5EbEGO9LMigJW9/fR0LAB99WBDeXmcmL/5
         nPfRl//7Ed3WD18z9qPaUbZlLHQaTSFzoo/c6+D6xsTajkEsC34NizVHSNc8xaNBN9QI
         UlqtsRTNt0Sxumz1pyaM6UXCDohIPRcdqmgQAdqkSUNb2dxxNSrYI9GOReyYthxC+Li/
         nFuO7fEvjWOBlxNSXpI6/YBTnPZfLavMFbChtL2Iua+OyUmNLgKK4RbPidnJNgVrfZU4
         mbIkwkLtM8WiiHorTY+MGYZxiiqv3Dy8eiyaSpG0gB+NBfCHopz9IITjPHpNvMvcWROL
         kwOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nk9Zj5yWhkiJNSaUjwt3uwdSYsNnenBADlut1qfzb/c=;
        b=pTsvjrBdS5l7XZ14qKx9T0qI6Qc8h9QHYcnZs49CbNNaSSvuQXajvVGABn4/QWQ+b7
         HUtgh3HfQNngz5cyZi+9N9aoYnupr6bx70YpMeQqAqOslLJIIkgtXjNuz6Kr0cXA1818
         dSfSeZjqR3x5pTMZaOmUQt8odLYHLNIysorZhu/51WMA4m/La59njoaSz6wgQ1vdsJTM
         4c7e2x8mpghHWFxczpjze8GEqKKbMkCAB1UXYzGZRUx2t33EQmHVvx8TevZFe9+Qcv50
         xbObhNW0vBkA7AzCXEeejzMrCUwhA48ZYXZcxlWKqVt/pU0p0Hh/XWaCVClBxNN4xrDz
         9RSQ==
X-Gm-Message-State: ACrzQf1ZzQJtM6pQRNBEU6WBHq+Jg1tKliiT6BWBWjUvuAxJTp9p5k9P
        YrzEr65W5QHrysAdqQd27Zxu4A==
X-Google-Smtp-Source: AMsMyM5sMc6G6Axs5CplqsNMfpyQ4uSMH9AtzNaScglfsBB2PnXGH0+Ty0kIPYt4vCV1C8OSn3UKzQ==
X-Received: by 2002:a17:902:d48d:b0:186:cf83:4be3 with SMTP id c13-20020a170902d48d00b00186cf834be3mr20033880plg.22.1667319222319;
        Tue, 01 Nov 2022 09:13:42 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s16-20020aa78bd0000000b0056b88187374sm6694607pfd.85.2022.11.01.09.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 09:13:42 -0700 (PDT)
Date:   Tue, 1 Nov 2022 16:13:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 41/48] KVM: selftests: Split off load_evmcs() from
 load_vmcs()
Message-ID: <Y2FFstEvVhUTrtxD@google.com>
References: <20221101145426.251680-1-vkuznets@redhat.com>
 <20221101145426.251680-42-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101145426.251680-42-vkuznets@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 01, 2022, Vitaly Kuznetsov wrote:
> +	/* Setup shadow VMCS, do not load it yet. */
> +	*(uint32_t *)(vmx->shadow_vmcs) =
> +		vmcs_revision() | 0x80000000ul;

In case another version is sent, or if Paolo feels like doing fixup when applying,
this wrap is no longer necessary.
