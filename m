Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8AD4F1B6B
	for <lists+kvm@lfdr.de>; Mon,  4 Apr 2022 23:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379635AbiDDVUT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Apr 2022 17:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379414AbiDDRIp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Apr 2022 13:08:45 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15ED240A25
        for <kvm@vger.kernel.org>; Mon,  4 Apr 2022 10:06:48 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ku13-20020a17090b218d00b001ca8fcd3adeso3746666pjb.2
        for <kvm@vger.kernel.org>; Mon, 04 Apr 2022 10:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gIH+kCrSXmFI+fUc29mzPw+H1akkAs2ZuFoVFSP0vxU=;
        b=Rr+FaoMffwErSOq6pRJ5Va7RKsFxClc5D23MZTexTKDgRmNLw+QXPH7HgVaF+gPlsH
         VVR7VJA+skjtzQ0GECeuU2WVaa0asrNgHkDBl6tstbwCf7C6oMyBne0DAlcAXCdcVL7g
         YrXAno9IHlxoD/YmxzSY5HC12atdMPGZ+Q8N6kZHZabK4TNxokJ7fJfCa2Z4Dji8u6pl
         3dHXlOPQbLuOhlHnPj7HtE/XDcufKULa7gV7RWaa0It/x7X/ULWQS6QyjSSWicyoNFMA
         ahGu94J7u389AK59eb7k4Mps25d3P18aXb3oZxp/f/pFl16fpYmLG3tkL22HLs/vsOZL
         l1Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gIH+kCrSXmFI+fUc29mzPw+H1akkAs2ZuFoVFSP0vxU=;
        b=AFwle+sL/1kaEjUcjXgEFeGy42IwNuUw1E8R3nejeBIbVhZD6/5Ttu3hxTfbpX4I9m
         TzMCpumV6FZVeZC9CYhBUI3+zXz/05PEUor6lxaJ02MTKrNh6cVeU+ZUZC+0flOTRBdQ
         H8+2yRxo2AI+mSlRhoZfGb+KBoAPuq1TiJBN/X1KSOUpvl70nooHYi0p/itD4GTht0Qc
         dLMOSHnIXbrkI9g92C5MXYGTsHHktSyDH7eeIE4H/jq7c8B9YyNZE2GvoPAsD1i76F0n
         oKyC2I4LfJtN3g14QRiDnfUIEdgJh5Y1epJZTD6YP7zbJ2xr2MTT+/UDvIudzBgnWrg7
         jfJA==
X-Gm-Message-State: AOAM5322/HYlYCbrnXT/3A5r1aW0v6XHyhMm55SPPlfokf22hFfe3Urf
        zgNMQz3bTeR/eO+5YBJWuTgdFg==
X-Google-Smtp-Source: ABdhPJxR0cMYn6++nMtTapD/RTNavycubKSgeugDdrZDDJ6GPqebAjtiOfHHZgX3JbxNGnvGjPUvmw==
X-Received: by 2002:a17:902:7247:b0:156:9d3d:756d with SMTP id c7-20020a170902724700b001569d3d756dmr687366pll.6.1649092007999;
        Mon, 04 Apr 2022 10:06:47 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id x9-20020a17090a970900b001ca6c59b350sm428753pjo.2.2022.04.04.10.06.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 10:06:47 -0700 (PDT)
Date:   Mon, 4 Apr 2022 17:06:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Quentin Perret <qperret@google.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Steven Price <steven.price@arm.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>, qemu-devel@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        the arch/x86 maintainers <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Hugh Dickins <hughd@google.com>,
        Jeff Layton <jlayton@kernel.org>,
        "J . Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@kernel.org>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Vlastimil Babka <vbabka@suse.cz>,
        Vishal Annapurve <vannapurve@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 00/13] KVM: mm: fd-based approach for supporting KVM
 guest private memory
Message-ID: <Ykslo2eo2eRXrpFR@google.com>
References: <YkH32nx+YsJuUbmZ@google.com>
 <YkIFW25WgV2WIQHb@google.com>
 <YkM7eHCHEBe5NkNH@google.com>
 <88620519-029e-342b-0a85-ce2a20eaf41b@arm.com>
 <YkQzfjgTQaDd2E2T@google.com>
 <YkSaUQX89ZEojsQb@google.com>
 <80aad2f9-9612-4e87-a27a-755d3fa97c92@www.fastmail.com>
 <YkcTTY4YjQs5BRhE@google.com>
 <83fd55f8-cd42-4588-9bf6-199cbce70f33@www.fastmail.com>
 <YksIQYdG41v3KWkr@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YksIQYdG41v3KWkr@google.com>
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

On Mon, Apr 04, 2022, Quentin Perret wrote:
> On Friday 01 Apr 2022 at 12:56:50 (-0700), Andy Lutomirski wrote:
> FWIW, there are a couple of reasons why I'd like to have in-place
> conversions:
> 
>  - one goal of pKVM is to migrate some things away from the Arm
>    Trustzone environment (e.g. DRM and the likes) and into protected VMs
>    instead. This will give Linux a fighting chance to defend itself
>    against these things -- they currently have access to _all_ memory.
>    And transitioning pages between Linux and Trustzone (donations and
>    shares) is fast and non-destructive, so we really do not want pKVM to
>    regress by requiring the hypervisor to memcpy things;

Is there actually a _need_ for the conversion to be non-destructive?  E.g. I assume
the "trusted" side of things will need to be reworked to run as a pKVM guest, at
which point reworking its logic to understand that conversions are destructive and
slow-ish doesn't seem too onerous.

>  - it can be very useful for protected VMs to do shared=>private
>    conversions. Think of a VM receiving some data from the host in a
>    shared buffer, and then it wants to operate on that buffer without
>    risking to leak confidential informations in a transient state. In
>    that case the most logical thing to do is to convert the buffer back
>    to private, do whatever needs to be done on that buffer (decrypting a
>    frame, ...), and then share it back with the host to consume it;

If performance is a motivation, why would the guest want to do two conversions
instead of just doing internal memcpy() to/from a private page?  I would be quite
surprised if multiple exits and TLB shootdowns is actually faster, especially at
any kind of scale where zapping stage-2 PTEs will cause lock contention and IPIs.

>  - similar to the previous point, a protected VM might want to
>    temporarily turn a buffer private to avoid ToCToU issues;

Again, bounce buffer the page in the guest.

>  - once we're able to do device assignment to protected VMs, this might
>    allow DMA-ing to a private buffer, and make it shared later w/o
>    bouncing.

Exposing a private buffer to a device doesn't requring in-place conversion.  The
proper way to handle this would be to teach e.g. VFIO to retrieve the PFN from
the backing store.  I don't understand the use case for sharing a DMA'd page at a
later time; with whom would the guest share the page?  E.g. if a NIC has access to
guest private data then there should never be a need to convert/bounce the page.
