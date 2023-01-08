Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D750661A95
	for <lists+kvm@lfdr.de>; Sun,  8 Jan 2023 23:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233826AbjAHWtb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 8 Jan 2023 17:49:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231313AbjAHWt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 8 Jan 2023 17:49:28 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 665606380
        for <kvm@vger.kernel.org>; Sun,  8 Jan 2023 14:49:26 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y1so7657840plb.2
        for <kvm@vger.kernel.org>; Sun, 08 Jan 2023 14:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+2EwBkT4ghB1jNt4S3UOpy3yeEZLhAzU9lSbZIAM7I4=;
        b=IjbxJtzUDxQwTlGXvZfUXOkwvqxSafaHnYeSIIG1WzG669+JyAc4qXN/gkvArxh5SD
         KsO/Gv3wxOSLuyRYLl7m++Sq+g2drIqTdrxHsBlUpfTotBCSHg6+bVEfSVH1azliE2T6
         kMuxAfKCDqnPkj6ErNSZQcpYqqgzNbw1dL0XfJp7+zFUEPB+EvTlPWcm9HtX7LUVmzhd
         ByL2BLxvkd6E8hMF+wBGoDQ8BbnAEINIRyGfhoWVJejIo8RthJBu2RF2L6c+QtHw++DZ
         CTAC17nlepfakuYDSfZnfsWM8iXclE/CuFhCDYSVdCMCN+ZnCAMp5X+ACqqFzjacfUKi
         t5iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+2EwBkT4ghB1jNt4S3UOpy3yeEZLhAzU9lSbZIAM7I4=;
        b=XhmTEWbeDwDt3iVera14DbrpexFUSzqq3K3W7EesrFtCq5GBOv4MDAAnMzWwM3fKn9
         nS74AFhFWM1kfp8i9GmyXkCzAjM8lasVzKcICvYQnYwDDnC0HDpeWrAFKrzoylT4Udsg
         YTiMcR7yplUFZffrom8fKRi5L6ytc1UkqWhRsDorVAv1V9bzk5hXhNGRgc6/hVKQeAs2
         habrrKjWVR8OcLsBPLD8lgIAQvCZQCaSqublA6c70z9n+M5tZe3o6w4aVNlHcpzK17Mf
         +H7j3c900zIB8iTKjF3bPE7+x6Gsf2b6RYUzJj1AX9NcTnTbVB81XzAaLrMFjD/5KwJK
         +wDw==
X-Gm-Message-State: AFqh2krasOwB1ib3lN+uxIrnRTEBr3NxpyYGgkUA2cAzFN0EsHOdHPb7
        539bn156FtUcXc+A0L87EmzYGw==
X-Google-Smtp-Source: AMrXdXvFomA3pBImLcMEFvQje52p88TQ7bSKJjQem9k+a9RDK9TT4WhVZ39yoEM1TO2IIQGIx51y+w==
X-Received: by 2002:a17:90b:3d03:b0:226:59d6:8219 with SMTP id pt3-20020a17090b3d0300b0022659d68219mr393178pjb.0.1673218165776;
        Sun, 08 Jan 2023 14:49:25 -0800 (PST)
Received: from [2620:15c:29:203:dfeb:5ed2:4968:d28b] ([2620:15c:29:203:dfeb:5ed2:4968:d28b])
        by smtp.gmail.com with ESMTPSA id r23-20020a17090b051700b002271f55157bsm22569pjz.9.2023.01.08.14.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 14:49:25 -0800 (PST)
Date:   Sun, 8 Jan 2023 14:49:24 -0800 (PST)
From:   David Rientjes <rientjes@google.com>
To:     Jarkko Sakkinen <jarkko@profian.com>
cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)" 
        <kvm@vger.kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "open list:AMD CRYPTOGRAPHIC COPROCESSOR (CCP) DRIVER - SE..." 
        <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v2] crypto: ccp: Sanitize sev_platform_init() error
 messages
In-Reply-To: <20230108202407.104963-1-jarkko@profian.com>
Message-ID: <30d6aa4c-3af9-9e4c-748e-c7378b519504@google.com>
References: <20230108202407.104963-1-jarkko@profian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 8 Jan 2023, Jarkko Sakkinen wrote:

> The following functions end up calling sev_platform_init() or
> __sev_platform_init_locked():
> 
> * sev_guest_init()
> * sev_ioctl_do_pek_csr
> * sev_ioctl_do_pdh_export()
> * sev_ioctl_do_pek_import()
> * sev_ioctl_do_pek_pdh_gen()
> * sev_pci_init()
> 
> However, only sev_pci_init() prints out the failed command error code, and
> even there the error message does not specify, SEV which command failed.
> 
> Address this by printing out the SEV command errors inside
> __sev_platform_init_locked(), and differentiate between DF_FLUSH, INIT and
> INIT_EX commands.  As a side-effect, @error can be removed from the
> parameter list.
> 
> This extra information is particularly useful if firmware loading and/or
> initialization is going to be made more robust, e.g. by allowing firmware
> loading to be postponed.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko@profian.com>

Acked-by: David Rientjes <rientjes@google.com>
