Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4333DC121
	for <lists+kvm@lfdr.de>; Sat, 31 Jul 2021 00:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbhG3Wez (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jul 2021 18:34:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233153AbhG3Wes (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jul 2021 18:34:48 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C588C06175F
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:34:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j1so17248188pjv.3
        for <kvm@vger.kernel.org>; Fri, 30 Jul 2021 15:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2B8bmMK1MWV0IKBzZFhJ4QQnRCCDWLQwwtmcrrRzShw=;
        b=UfW+Uyhy937lSOvlfCbvzUSHfPBdVvhcTOaILHqlmzjEQeZkE7CJS1pDjY85yLeTrk
         ZUbJvCXGnG9V4YR8YvLqiCoHxoAuC0RJHo8xznM5u3dhr6dkJI9BNq9mI/HgcDxL19UV
         T0+Bsg6O2a3etVDRUOMu6je3JU33B5pFqiYpolqwzc84ASrmmPyryuwH24+FPODl2NK0
         /jswqbw3cLYGC3s8tw+3+64iNj05CofMOCHjsjPmhNsSGF6fZGX5s2X6UpkAmOT82yEf
         KD+vMh5N6wzurqnoLV7GP3bDuQRiamzrkbH5J6wxueQVfjy9YKlsV1lqKUCTBLbTMy1G
         tbIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2B8bmMK1MWV0IKBzZFhJ4QQnRCCDWLQwwtmcrrRzShw=;
        b=o5B2LeNG+0I/jW+0el3uqs0kxvFIMjXlq1QY1MydI/XMwmU7juwrMdGpS6Ki/1FZpB
         a07VBcdNIizuf+S9EHlchEdT4Gg7bTF0r/BkvtwKFdZKUb8ItHEso2RUbLN4EwrVnfUh
         8rdbepumoJ0HmXGAbQf3lqwQ8LZMY0Q4N2LAMmazzArGkd/bWr4oXfL4aCfB4HNaG9Fi
         410r5/e+Xdx1tlqNzWlElt75+VVIaF/wey3/S5UwIRRozfrztBrZ2hE4b0t3EAjdYdcf
         xrC3BdYnCzycqwxUJ0Wnxlv927HlsNGZnH099+3zpRNwKIdcGOQREmLblRZ1hjpHxCoT
         yW0w==
X-Gm-Message-State: AOAM530SePDvOg3VLAHlN9MmQM9X6ZFh34QNW1k+GhqM/+/7nj7qU0jD
        rOYcG5duQ2LvFDbtg6MwPPjtQA==
X-Google-Smtp-Source: ABdhPJzSqN3B7Go3MtNjE9VY5h0clk+hYXj3ladZ5/S+PnXE8W92M9c05HKB4nGF1ekuX4eoULgjrQ==
X-Received: by 2002:a17:90b:1bcc:: with SMTP id oa12mr5239612pjb.113.1627684481796;
        Fri, 30 Jul 2021 15:34:41 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b184sm3525033pfg.72.2021.07.30.15.34.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 15:34:41 -0700 (PDT)
Date:   Fri, 30 Jul 2021 22:34:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-efi@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-graphics-maintainer@vmware.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Andi Kleen <ak@linux.intel.com>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Tianyu Lan <Tianyu.Lan@microsoft.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Maxime Ripard <mripard@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Will Deacon <will@kernel.org>, Dave Young <dyoung@redhat.com>,
        Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH 07/11] treewide: Replace the use of mem_encrypt_active()
 with prot_guest_has()
Message-ID: <YQR+ffO92gMfGDbs@google.com>
References: <cover.1627424773.git.thomas.lendacky@amd.com>
 <029791b24c6412f9427cfe6ec598156c64395964.1627424774.git.thomas.lendacky@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <029791b24c6412f9427cfe6ec598156c64395964.1627424774.git.thomas.lendacky@amd.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 27, 2021, Tom Lendacky wrote:
> @@ -451,7 +450,7 @@ void __init mem_encrypt_free_decrypted_mem(void)
>  	 * The unused memory range was mapped decrypted, change the encryption
>  	 * attribute from decrypted to encrypted before freeing it.
>  	 */
> -	if (mem_encrypt_active()) {
> +	if (sme_me_mask) {

Any reason this uses sme_me_mask?  The helper it calls, __set_memory_enc_dec(),
uses prot_guest_has(PATTR_MEM_ENCRYPT) so I assume it's available?

>  		r = set_memory_encrypted(vaddr, npages);
>  		if (r) {
>  			pr_warn("failed to free unused decrypted pages\n");

