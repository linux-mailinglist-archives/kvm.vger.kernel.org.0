Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89C66316BD3
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 17:56:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbhBJQzE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 11:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232776AbhBJQxN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 11:53:13 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6EEC061756
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 08:52:33 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id o38so1594918pgm.9
        for <kvm@vger.kernel.org>; Wed, 10 Feb 2021 08:52:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kzbr6goRS69+ZiiSMq5gwv7kmN9mL136qYSfdZ++e7I=;
        b=sBD+p1x+Om9I07UVRmIOL81iFgdGxQs87RIfw0PlJNJdhEcZQxWueLg/J5pZnBnQFY
         uPjI7Rj+EbAbziJqiLm/BPZTzyA3udAlsicmcbG9aseNBkKcgFgha5TJWHgm7767d8uW
         UG9VZo/CWAXN+ESJvS3YSf01lSBg0UNfx/T/ldM/8iwkIJkTfh+C4NHHH4WEejWZuhMm
         o4yf12vdQAkibNC8uDQANWro7LmeeFMLA0KlZ62/oGfjzwOPqH56TrJuVQExwROr+3uY
         99+lfsh3h7Ikq5MLyxQ245CveYnFz9z9E3eumK5tcS0ROI0KKCXBm1BtOfRp+KPRWfdl
         Jhuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kzbr6goRS69+ZiiSMq5gwv7kmN9mL136qYSfdZ++e7I=;
        b=ZnebbiP/l6MySoAFgFDYAEJ63p/Gx897z5MfoKeYciDr33V2UiEekLZIG4XqMxr1Og
         aVdNzSh3mh8viMDHZE9ps3jN7swNVKSdevAI8PJ6ftmgEzRQMWdFzUvnsibmrWvD2kRv
         g7CN0/wrfCgquQzbduEGc30KFbYjiuOeS3Kbr0XsKVfxVFYfcWq5TlZPrmlZhlOBNJbI
         b6J6rhIvs7ioxqPA21SCz4vi46BhlbVHcbGvgYDCUpsmMalX/a9B3hBng1CTdBmM/un4
         6U9e6GAVjLr/UEJ5kqjZgoQWQ/fTACrtcozEssTqkJK7IgMsiyM2dkAD0HIVQWJchiS1
         sJQg==
X-Gm-Message-State: AOAM532ntqDYn64L3knhbtNgwL/Ltn02koLWo9QcIO4Q3YmguRoXSMI6
        XNNTx3qyu70BEzonfkCTFXnDsQ==
X-Google-Smtp-Source: ABdhPJwun1z3tmYqGzKUbqmrTiAPAtIeg9j6D0sl5TNlKMlU/beqhpLVR4XHFJB5V2RtuOUd+Alh2A==
X-Received: by 2002:aa7:9596:0:b029:1be:28cc:cfe8 with SMTP id z22-20020aa795960000b02901be28cccfe8mr4054281pfj.49.1612975953097;
        Wed, 10 Feb 2021 08:52:33 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1513:9e6:21c3:30d3])
        by smtp.gmail.com with ESMTPSA id m5sm2880486pgj.11.2021.02.10.08.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 08:52:32 -0800 (PST)
Date:   Wed, 10 Feb 2021 08:52:25 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, luto@kernel.org,
        rick.p.edgecombe@intel.com, haitao.huang@intel.com,
        pbonzini@redhat.com, bp@alien8.de, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v4 05/26] x86/sgx: Introduce virtual EPC for use by
 KVM guests
Message-ID: <YCQPSUNFlWd/s+up@google.com>
References: <cover.1612777752.git.kai.huang@intel.com>
 <11a923a314accf36a82aac4b676310a4802f5c75.1612777752.git.kai.huang@intel.com>
 <YCL8ErAGKNSnX2Up@kernel.org>
 <YCL8eNNfuo2k5ghO@kernel.org>
 <9aebc8e6-cff5-b2b4-04af-d3968a3586dc@intel.com>
 <ec9604199072e185de4b6b74209e84f30423c5e3.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec9604199072e185de4b6b74209e84f30423c5e3.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 10, 2021, Kai Huang wrote:
> On Tue, 2021-02-09 at 13:36 -0800, Dave Hansen wrote:
> > On 2/9/21 1:19 PM, Jarkko Sakkinen wrote:
> > > > Without that clearly documented, it would be unwise to merge this.
> > > E.g.
> > > 
> > > - Have ioctl() to turn opened fd as vEPC.
> > > - If FLC is disabled, you could only use the fd for creating vEPC.
> > > 
> > > Quite easy stuff to implement.

...

> What's your opinion? Did I miss anything?

Frankly, I think trying to smush them together would be a complete trainwreck.

The vast majority of flows would need to go down completely different paths, so
you'd end up with code like this:

diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
index f2eac41bb4ff..5128043c7871 100644
--- a/arch/x86/kernel/cpu/sgx/driver.c
+++ b/arch/x86/kernel/cpu/sgx/driver.c
@@ -46,6 +46,9 @@ static int sgx_release(struct inode *inode, struct file *file)
        struct sgx_encl *encl = file->private_data;
        struct sgx_encl_mm *encl_mm;
 
+       if (encl->not_an_enclave)
+               return sgx_virt_epc_release(encl);
+
        /*
         * Drain the remaining mm_list entries. At this point the list contains
         * entries for processes, which have closed the enclave file but have
@@ -83,6 +86,9 @@ static int sgx_mmap(struct file *file, struct vm_area_struct *vma)
        struct sgx_encl *encl = file->private_data;
        int ret;
 
+       if (encl->not_an_enclave)
+               return sgx_virt_epc_mmap(encl, vma);
+
        ret = sgx_encl_may_map(encl, vma->vm_start, vma->vm_end, vma->vm_flags);
        if (ret)
                return ret;
@@ -104,6 +110,11 @@ static unsigned long sgx_get_unmapped_area(struct file *file,
                                           unsigned long pgoff,
                                           unsigned long flags)
 {
+       struct sgx_encl *encl = file->private_data;
+
+       if (encl->not_an_enclave)
+               return sgx_virt_epc_mmap(encl, addr, len, pgoff, flags);
+
        if ((flags & MAP_TYPE) == MAP_PRIVATE)
                return -EINVAL;

I suspect it would also be tricky to avoid introducing races, since anything that
is different for virtual EPC would have a dependency on the ioctl() being called.

This would also prevent making /dev/sgx_enclave root-only while allowing users
access to /dev/sgx_vepc.  Forcing admins to use LSMs to do the same is silly.

For the few flows that can share code, just split out the common bits to helpers.
