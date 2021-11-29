Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC5F462457
	for <lists+kvm@lfdr.de>; Mon, 29 Nov 2021 23:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233785AbhK2WRl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Nov 2021 17:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbhK2WQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Nov 2021 17:16:56 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F7AC0048DF
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 10:23:41 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id y7so12898505plp.0
        for <kvm@vger.kernel.org>; Mon, 29 Nov 2021 10:23:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ieSn6CI4O2ZLeLlECiGDLKzxg/GtHx0Kn0OdLIkrPs8=;
        b=I42OIB8Tn0Kh3k4AbnHLbuRddHu0E2lCAIKiefyjD2VTpViiDcXGJ02muiwA7dHbX0
         pwT+ViUYAviPVahPNOqA0mCXULr8XhFRLJddPEV7xpwj4fcgcCZGiniR04ckN3+UwnzF
         pdAF7qjoYwgd9RUvYjgn0qJ7IaVWzneCHsFF61+ZqcW9fVBj7K/IAGGiZZ8/FSAYthnZ
         VQvb61hOqu9UKDG2IGdIgmR4pKokTwA/3tqKmbkDf/0vXHazLzuMopwMN9b82Fqz+19t
         NddG8U3dNtEcEUJBotClzD5ZWr4gzJwZ+ls1I+dHRKgeOBM2232yGVKwKkJ1lY4lcHdk
         pPgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ieSn6CI4O2ZLeLlECiGDLKzxg/GtHx0Kn0OdLIkrPs8=;
        b=RvKe5batQflLNrdqZtxTiuVs7iNHuf3qDyeEG4W3mgjp74V2d2PI1QnKAlM2pJSYhu
         YLxKYedovkcfsfP2BoUbW5yZNmwxCxjVA/raQYwwFDJnItC7KGknMV3Ev6+LxfTnLHnZ
         i17EnuxZlWgzEPDIiVuKNhpJqdVzAky9pdE973tek2ilONX8VqiZs6dVl3hJX/maRMKH
         r+W5aseI+ts7JxK/JPQkfq3HcbphIPLn+SpR4HJMd5HxuHgn0ZEM6aEZA05yQcTLLNwc
         9SFxvhq6HE2N6X37aq5Ku9UQvsl4BFpV1npHNRWn25zYod3xst5XHBgvMrvLGHZkFjrl
         uUVg==
X-Gm-Message-State: AOAM531hLS1Pc+4+k7Kn27C6kuD8Nl5wkOwlupv8PKZi2bC5jq2gJmce
        bNj1mPr1z8cNsGv0Tnd4+qcd1w==
X-Google-Smtp-Source: ABdhPJy0eOYRLQITkw9U0pff+97vxzgm8hmIub7itZ9EEtr3SCgjyDhTUMe2DGGaWbUWbAV6gASeRw==
X-Received: by 2002:a17:90a:fd93:: with SMTP id cx19mr30827pjb.190.1638210221054;
        Mon, 29 Nov 2021 10:23:41 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y4sm19146496pfi.178.2021.11.29.10.23.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 10:23:40 -0800 (PST)
Date:   Mon, 29 Nov 2021 18:23:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>, isaku.yamahata@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [RFC PATCH v3 46/59] KVM: VMX: Move register caching logic to
 common code
Message-ID: <YaUaqTfzSUB2tpkR@google.com>
References: <cover.1637799475.git.isaku.yamahata@intel.com>
 <2f3c1207f66f44fdd2f3eb0809d552f5632e4b41.1637799475.git.isaku.yamahata@intel.com>
 <87mtlshu66.ffs@tglx>
 <620e127f-59d3-ccad-e0f6-39ca9ee7098e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <620e127f-59d3-ccad-e0f6-39ca9ee7098e@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 25, 2021, Paolo Bonzini wrote:
> On 11/25/21 21:11, Thomas Gleixner wrote:
> > > 
> > > Use kvm_x86_ops.cache_reg() in ept_update_paging_mode_cr0() rather than
> > > trying to expose vt_cache_reg() to vmx.c, even though it means taking a
> > > retpoline.  The code runs if and only if EPT is enabled but unrestricted
> > > guest.
> > This sentence does not parse because it's not a proper sentence.

Heh, supposed to be "... but unrestricted guest is disabled".

> > > Only one generation of CPU, Nehalem, supports EPT but not
> > > unrestricted guest, and disabling unrestricted guest without also
> > > disabling EPT is, to put it bluntly, dumb.
> > This one is only significantly better and lacks an explanation what this
> > means for the dumb case.
> 
> Well, it means a retpoline (see paragraph before).

No, the point being made is that, on a CPU that supports Unrestricted Guest (UG),
disabling UG without disabling EPT is really, really stupid.  UG requires EPT, so
disabling EPT _and_ UG is reasonable as there are scenarios where using shadow
paging is desirable.  But inentionally disabling UG and enabling EPT makes no
sense.  It forces KVM to emulate non-trivial amounts of guest code and has zero
benefits for anything other than testing KVM itself.

> why it one wouldn't create a vt.h header with all vt_* functions.
> 
> Paolo
> 
