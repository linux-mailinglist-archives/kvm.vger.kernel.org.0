Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3369296CF1
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 12:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S462454AbgJWKgN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 06:36:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S462256AbgJWKgN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Oct 2020 06:36:13 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16BAAC0613D2
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 03:36:13 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id c21so1043823ljj.0
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 03:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2qkq9CfQOJr8zJttsFKuFINhGnc+H3tDfc2bDWRdxKM=;
        b=fhbRPsyb8i9xNHMf4eL5ienqhn7upoD6FePa/IEF7DMBI6HisVrOD33691JnVkmeQi
         ET2W5Takymxk8FVZvUA5hEAmwX7HYwQurYbORAkttNqTL4VuRwkIkfZ0h/JLlpG+GR6u
         a6BWrna+MBVKLQ9UAl6mF4AeywD0FcFeHeltPhaw+5YZUumYlpF1v4IBLvpmcnJozg9Y
         mdYng2/8mGvFa8kUyHbVE6+aKlNVE+cfharL9bJyzKCwIk0S5XbJIlfVAvfrxBP5+Heo
         ouekvBs9rnWndDp/Nb7lQTKqSqykoCFGoOQ+zBx0i7e4ynHDUpbUISETkwzCkX6DMDnH
         3oJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2qkq9CfQOJr8zJttsFKuFINhGnc+H3tDfc2bDWRdxKM=;
        b=COBxDvt5bDXn6zYQxpLzkXPJNf0u3xfU8gm/w9cOcPaX2UTqY6lzEZY4RjO2dnvzp2
         NSS3BTNLD6vTUokiwAURE6jYXSmkOxTw+NesUIBUZM2NhbYfIHDdhZoT7g/9nb9eV+py
         TmFGWfN/DNkULKTB5bBsmUPnKeNzvw8N+hgXm8gqRVXS1eB8aOWbbx2/zlTw/cEzE9lH
         iscizj/yuY3661ZFRxN5EVol/cJfGF1rU/cX2PoI0Gma+cAbB6Qkj0KTkNwTgrSFMhCq
         cn6OzewlS8zYw/LFOstCe4jmNsZ6ReSbYq3stR+tV4m6zFpDnWInqBVmqjf0n/v270YK
         iWjQ==
X-Gm-Message-State: AOAM531GGYXGmwpFbsbbc2r1MxZtCMoMk0z1NrCHcU/2rFJBO0H5QKaQ
        sK2RGePdU3SdY/uA9rQBSGLkXA==
X-Google-Smtp-Source: ABdhPJxQnKcTu7fqc4QutnnpTAjI9nHlJriPNvSeoN91l9+74XgAkQagFMHTs4++JLMhsXVHrZdecg==
X-Received: by 2002:a2e:b889:: with SMTP id r9mr639609ljp.378.1603449371412;
        Fri, 23 Oct 2020 03:36:11 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id x18sm99408lfe.158.2020.10.23.03.36.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 03:36:10 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id D5683102F98; Fri, 23 Oct 2020 13:36:10 +0300 (+03)
Date:   Fri, 23 Oct 2020 13:36:10 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jmattson@google.com" <jmattson@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "aarcange@redhat.com" <aarcange@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "luto@kernel.org" <luto@kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "rppt@kernel.org" <rppt@kernel.org>,
        "wad@chromium.org" <wad@chromium.org>,
        "wanpengli@tencent.com" <wanpengli@tencent.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Subject: Re: [RFCv2 14/16] KVM: Handle protected memory in
 __kvm_map_gfn()/__kvm_unmap_gfn()
Message-ID: <20201023103610.facpukoiodnj5v73@box>
References: <20201020061859.18385-1-kirill.shutemov@linux.intel.com>
 <20201020061859.18385-15-kirill.shutemov@linux.intel.com>
 <8404a8802dbdbf81c8f75249039580f9e6942095.camel@intel.com>
 <20201022120645.vdmytvcmdoku73os@box>
 <4df3bb56f56f5a8d69b4b288317111046158cebb.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4df3bb56f56f5a8d69b4b288317111046158cebb.camel@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 22, 2020 at 04:59:49PM +0000, Edgecombe, Rick P wrote:
> On Thu, 2020-10-22 at 15:06 +0300, Kirill A. Shutemov wrote:
> > > I think the page could have got unmapped since the gup via the
> > > hypercall on another CPU. It could be an avenue for the guest to
> > > crash
> > > the host.
> > 
> > Hm.. I'm not sure I follow. Could you elaborate on what scenario you
> > have
> > in mind?
> 
> Kind of similar scenario as the userspace triggered oops. My
> understanding is that the protected status was gathered along with the
> gup, but after the mm gets unlocked, nothing stops the page
> transitioning to unmapped(?). At which point kmap() from a previous gup
> with !protected, would go down the regular kmap() route and return an
> address to an unmapped page.
> 
> So the guest kernel could start with a page mapped as shared via the
> hypercall. Then trigger one of the PV MSR's that kmap() on CPU0. On
> CPU1, after the gup on CPU0, it could transitioned the page to
> private/unmapped via the hypercall. So the hva_to_pfn() would find
> !protected, but by the time the kmap() happened the page would have
> been unmapped. Am I missing something?

We need to fail protection enabling if a page is pinned. That's the only
option I see. But it might be pain to debug.

-- 
 Kirill A. Shutemov
