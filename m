Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF733DDC00
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 17:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234834AbhHBPMT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 11:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234581AbhHBPMS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Aug 2021 11:12:18 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04024C06175F
        for <kvm@vger.kernel.org>; Mon,  2 Aug 2021 08:12:09 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so32144915pjb.3
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 08:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=klAhZ2sU9gQG5ENBY3HDvrJiKEjR8pMVXktb66OKWL0=;
        b=jKEiC+1+wv6ZB11QhU5jHhEwmc9DVdSPRgnk67Rt2w0A5wqNOr4tNqhVt6lusxC9Ah
         5d1+hCyOHE+fLf+Gy3bXEg20t7HU24ziIxYynA89ykCfIW7ypTWg+MW55U55NeSeUEXj
         UsRzILNoY6I72xAtKWPZe3vOzlaD7jx5hIkbWQqRXqJtLjYsTxXdd/E9tS+x8Mc2PKI0
         2UBFV8fnPQPN900/dc+OftFuW+KjvWlM5Cksvjbdj1C+rtQY7sOvvbRycHZ80VVqzuE2
         G0AFgRaNy/GyFwNIXOX+jekapwkzhJ5M3JIIoHArBthZxjDJZ70beVvEuqcmwBt8/7Tt
         wRYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=klAhZ2sU9gQG5ENBY3HDvrJiKEjR8pMVXktb66OKWL0=;
        b=S4OtIoVG7dSi87hG6sxvbd6clWasvGpqDYwwqA2ttqmhCkUl62Gwf4tnCteUACWQq1
         1sokiewvYGPkzTlbh8GIeZvasw3UKm59FJX6/bTF9Jg4w8Y8P0gtjlzm0yBPVG8160KE
         iWDABcDvkNFXN7c4noAab46pYUUk3s8pPLW0qglOCjHgxhhfma668UwIEZldTLvTMHO2
         e1HWeQO4Ks4d0Zn7UUXuPFmzWerORsNKwD55K391+m/t4wj9oBAq4dudDhiCsCOJ6T3+
         WkluEwC611rmSQvRvRXGUxXlF6l6X8tY/dxAcVSs2/D6xu11MRmD7fUu6pD4i5gEoiTq
         2F7g==
X-Gm-Message-State: AOAM533xv14heKo5DPJNFqQr8fAPe8oqy21SeT1uCIWGNJtCCbZ9DHxD
        lG9eb4peGk830oU5oUipE/jFeQ==
X-Google-Smtp-Source: ABdhPJx4We5Vp8zurMbskwONkrhJTYkjFYQ4XojOsZi/g68Rn9EvVwc7Nu0w9PCvFt0O1Y726aW4uQ==
X-Received: by 2002:a63:5fd4:: with SMTP id t203mr1490500pgb.141.1627917128408;
        Mon, 02 Aug 2021 08:12:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id 198sm9797349pfu.32.2021.08.02.08.12.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 08:12:07 -0700 (PDT)
Date:   Mon, 2 Aug 2021 15:12:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v2 00/69] KVM: X86: TDX support
Message-ID: <YQgLRLPz3YNiIVK6@google.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <0d453d76-11e7-aeb9-b890-f457afbb6614@redhat.com>
 <YQGLJrvjTNZAqU61@google.com>
 <dc4c3fce-4d10-349c-7b21-00a64eaa9f71@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc4c3fce-4d10-349c-7b21-00a64eaa9f71@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 02, 2021, Paolo Bonzini wrote:
> On 28/07/21 18:51, Sean Christopherson wrote:
> > I strongly object to merging these two until we see the new SEAMLDR code:
> > 
> >    [RFC PATCH v2 02/69] KVM: X86: move kvm_cpu_vmxon() from vmx.c to virtext.h
> >    [RFC PATCH v2 03/69] KVM: X86: move out the definition vmcs_hdr/vmcs from kvm to x86
> > 
> > If the SEAMLDR code ends up being fully contained in KVM, then this is unnecessary
> > churn and exposes code outside of KVM that we may not want exposed (yet).  E.g.
> > setting and clearing CR4.VMXE (in the fault path) in cpu_vmxon() may not be
> > necessary/desirable for SEAMLDR, we simply can't tell without seeing the code.
> 
> Fair enough (though, for patch 2, it's a bit weird to have vmxoff in
> virtext.h and not vmxon).

I don't really disagree, but vmxoff is already in virtext.h for the emergency
reboot stuff.  This series only touches the vmxon code.
