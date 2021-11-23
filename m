Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDCE45A693
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 16:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbhKWPjs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Nov 2021 10:39:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhKWPjr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Nov 2021 10:39:47 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C266BC061574
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 07:36:39 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u11so17400106plf.3
        for <kvm@vger.kernel.org>; Tue, 23 Nov 2021 07:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5VVg5sF/i5gU/ki52+bDwZvmQKpTX8HJeSrAf6kcWFQ=;
        b=U6HSgDxCZz53CGLYrJ7O5A0XNm09HecVxGKIpmb1gkV3apRWZ25N2jA23Ttyp2MYKZ
         K7PCL8IziOVl3IGVvcEKWxmZ7N5WFdDKaeFnFWDdTQL8q+kbkqylzTzEvEGM/qub8VsW
         0kNCx9MqyC2snH1QR5CdErs3MA8OmHVtnhGLtP4QLDC7rwwGeLp30owwNo0TxBfgzp/4
         z9A4yJ5wtwLQDky0itThd+HFGg3KslkVzZMf+De/ppvd/GGnqEzg8bvzIdr3jjCW1Wdw
         esOXbQYxDR8uPmd7RrzvIegmxMJgPyMy2od9otejx7jL7aU+uOEan4lmnuCo0jVl028f
         on6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5VVg5sF/i5gU/ki52+bDwZvmQKpTX8HJeSrAf6kcWFQ=;
        b=Ok8Au79Nbp/wdUkKOrqiD3iho6RbspHKvkiK/QAjWuQspOCoP0bgVIEKtlIfhGXXH+
         bt8ZDd/Cro6p4/31BhEkRbdNF2JWAPZba95nktAhWBVCGwQ89zD5GXbcaQfHbuxiwV5R
         xp1yEZ23Q6ztqDQW9Rfmzh9POYny4Wdhx2F8b4saSx9BYP8WzErZgFFYvgN1jcx/BY1k
         OnFuRSPGY/ts5ddYHCLL/61HLNkusGcGlKuuIdkT5Lxh3hdiwn8tMeT4VtK/f8bCarSa
         ogrSSL0iZsVRthkt8Z4I5nlAc9H/DxG/+aY7Xr3/1rENMACaGrbRyZDF1aNA2E7BRgM7
         2bfA==
X-Gm-Message-State: AOAM532CmEpjDasVT0l4tyr5xKPCmI6Q2ce+2bZyBIYhBAScIWjqQlH8
        mOfgFFu+wPfr3HvSgjTaMeTJVg==
X-Google-Smtp-Source: ABdhPJzN3VZxkHeunJB6N/YPoYEM/c03A9bU/hzxt4O7jM4g9pvIKKtkf8VdyZ1rwnxZzh/blb4dBw==
X-Received: by 2002:a17:902:c78a:b0:142:1b7a:930 with SMTP id w10-20020a170902c78a00b001421b7a0930mr7959825pla.8.1637681799124;
        Tue, 23 Nov 2021 07:36:39 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k14sm9384097pga.65.2021.11.23.07.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 07:36:38 -0800 (PST)
Date:   Tue, 23 Nov 2021 15:36:35 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Peter Gonda <pgonda@google.com>, x86@kernel.org,
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
        Michael Roth <michael.roth@amd.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com,
        marcorr@google.com, sathyanarayanan.kuppuswamy@linux.intel.com
Subject: Re: [PATCH Part2 v5 00/45] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <YZ0KgymKvLC2HcIk@google.com>
References: <20210820155918.7518-1-brijesh.singh@amd.com>
 <CAMkAt6o0ySn1=iLYsH0LCnNARrUbfaS0cvtxB__y_d+Q6DUzfA@mail.gmail.com>
 <daf5066b-e89b-d377-ed8a-9338f1a04c0d@amd.com>
 <d673f082-9023-dafb-e42e-eab32a3ddd0c@intel.com>
 <f15597a0-e7e0-0a57-39fd-20715abddc7f@amd.com>
 <5f3b3aab-9ec2-c489-eefd-9136874762ee@intel.com>
 <d83e6668-bec4-8d1f-7f8a-085829146846@amd.com>
 <38282b0c-7eb5-6a91-df19-2f4cfa8549ce@intel.com>
 <YZyVx38L6gf689zq@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZyVx38L6gf689zq@zn.tnic>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 23, 2021, Borislav Petkov wrote:
> On Mon, Nov 22, 2021 at 02:51:35PM -0800, Dave Hansen wrote:
> > By "supporting", do you mean doing something functional?  I don't really
> > care if ptrace() to guest private memory returns -EINVAL or whatever.
> > The most important thing is not crashing the host.
> > 
> > Also, as Sean mentioned, this isn't really about ptrace() itself.  It's
> > really about ensuring that no kernel or devices accesses to guest
> > private memory can induce bad behavior.
> 
> I keep repeating this suggestion of mine that we should treat
> guest-private pages as hw-poisoned pages which have experienced a
> uncorrectable error in the past.
> 
> mm already knows how to stay away from those.

Kirill posted a few RFCs that did exactly that.  It's definitely a viable approach,
but it's a bit of a dead end, e.g. doesn't help solve page migration, is limited to
struct page, doesn't capture which KVM guest owns the memory, etc...

https://lore.kernel.org/kvm/20210416154106.23721-1-kirill.shutemov@linux.intel.com/
