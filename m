Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95DF44EEC2
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 22:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhKLVns (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 16:43:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235783AbhKLVnr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 16:43:47 -0500
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAB4C061767
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 13:40:56 -0800 (PST)
Received: by mail-ot1-x32d.google.com with SMTP id u18-20020a9d7212000000b00560cb1dc10bso15794306otj.11
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 13:40:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sloIfHJE+iKk44+AlxrE6ZUAY0xZ35xpRmFUJf3Gn7g=;
        b=jbcHJF+9hw4eupohwgwDHSMp00T1Og3E98oOfGaje91bd+dB1KH7tEeFB5c9b12QZf
         M4SfUDdzJh6g/h8SHtMEiY/OpXQgZa1mp35EAXj0B5F0TgrglUAjwdbZeXKRKexgpfYO
         JeOnZeMhhCE8gyh2sFfqBX7/I9k4lZqXwrlsBgSoRfE0SUOzqVQ4eVF+1qCFkBMQh1kK
         298qvzCaX1ue3cAtufn+eVTZhGsynUII+gkPfNYusg3eSIIg+qWAWt/vCVbxhZ82tHZc
         cGcYM6mp+5vX6aBy1DxY0HXVj3TuSIbR+XqrVr1amrcn02wI48UBN3Yh804aRilPcDTK
         ws/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sloIfHJE+iKk44+AlxrE6ZUAY0xZ35xpRmFUJf3Gn7g=;
        b=J6glPfoS3pg1ajGglXALqA96g1q11Cr6QDg12gRhlWEbL3aocCR4GMNArQhApZ5IDc
         OYKGgyiNJaC0sPFAIlYBjaUmja1Z2EzGdhHj6EuERjaCcuhZ8TPrrkw8w8EbMv56k2a6
         kfLqNLAs0BcYy4lNvvXFsNDpTpJCWbWxQRIvmaJB3XvH3Eyd9/JnEbluaykgUYCUHAy6
         N2O1zlB78Dm6IVtjDoTvNbW95f4ZHl3Z0je8+JG3zZByT+RvIwEA5q8c2DRJoyq7e1ai
         TuvgMuUPTp36Q23UnoAEy1KcB+sSILx8Ol1E9/geqVqJr80LHyREJbihbHNEVolbrln3
         BEyw==
X-Gm-Message-State: AOAM5311+8bJtxSut+AV2hcbqI2OMQqzVzLZ5oac6cdyBzPmSHAuY4/U
        rz7VxH0MZ1QuYemayNCK3D0zqexwfSU6wYaFieWYHw==
X-Google-Smtp-Source: ABdhPJzJAeqA1sayja54+gOvTJNTZu3qoAAJtDM/QZXI4YyzJUymLHcSZzFuIQbvvaE/f6iQ+J28yRbXzpfZhgNiSG4=
X-Received: by 2002:a05:6830:1aee:: with SMTP id c14mr15114563otd.25.1636753255031;
 Fri, 12 Nov 2021 13:40:55 -0800 (PST)
MIME-Version: 1.0
References: <20210820155918.7518-1-brijesh.singh@amd.com> <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <061ccd49-3b9f-d603-bafd-61a067c3f6fa@intel.com> <YY6z5/0uGJmlMuM6@zn.tnic>
 <YY7FAW5ti7YMeejj@google.com> <YY7I6sgqIPubTrtA@zn.tnic> <YY7Qp8c/gTD1rT86@google.com>
 <CAA03e5GwHMPYHHq3Nkkq1HnEJUUsw-Vk+5wFCott3pmJY7WuAw@mail.gmail.com> <48e20b96-3995-6998-56cf-3f15694c5db2@intel.com>
In-Reply-To: <48e20b96-3995-6998-56cf-3f15694c5db2@intel.com>
From:   Marc Orr <marcorr@google.com>
Date:   Fri, 12 Nov 2021 13:40:43 -0800
Message-ID: <CAA03e5GEkpit7ipvm-di-aQ49Wv+YDT2CFj5SzBTjcEa2F3n2Q@mail.gmail.com>
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>,
        Peter Gonda <pgonda@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-coco@lists.linux.dev, linux-mm@kvack.org,
        linux-crypto@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <Thomas.Lendacky@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sergio Lopez <slp@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Tobin Feldman-Fitzthum <tobin@ibm.com>,
        Michael Roth <Michael.Roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021 at 1:38 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 11/12/21 1:30 PM, Marc Orr wrote:
> > In this proposal, consider a guest driver instructing a device to DMA
> > write a 1 GB memory buffer. A well-behaved guest driver will ensure
> > that the entire 1 GB is marked shared. But what about a malicious or
> > buggy guest? Let's assume a bad guest driver instructs the device to
> > write guest private memory.
> >
> > So now, the virtual device, which might be implemented as some host
> > side process, needs to (1) check and lock all 4k constituent RMP
> > entries (so they're not converted to private while the DMA write is
> > taking palce), (2) write the 1 GB buffer, and (3) unlock all 4 k
> > constituent RMP entries? If I'm understanding this correctly, then the
> > synchronization will be prohibitively expensive.
>
> Are you taking about a 1GB *mapping* here?  As in, something us using a
> 1GB page table entry to map the 1GB memory buffer?  That was the only
> case where I knew we needed coordination between neighbor RMP entries
> and host memory accesses.
>
> That 1GB problem _should_ be impossible.  I thought we settled on
> disabling hugetlbfs and fracturing the whole of the direct map down to 4k.

No. I was trying to give an example where a host-side process is
virtualizing a DMA write over a large buffer that consists of a lot of
4k or 2MB RMP entries. I picked 1 GB as an arbitrary example.
