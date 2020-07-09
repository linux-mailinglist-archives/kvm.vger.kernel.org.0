Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06EA421A988
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 23:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgGIVJ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 17:09:27 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52852 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726193AbgGIVJ0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 17:09:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594328964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/5qJhIS3vYBRwpwDz6NnUQ7JwhKdspJwMVlrORtRFsI=;
        b=bS9FCHInaHcVs5ht+tLqVVqbXZs6dS1Di8y6DpfSuDtWHKs5Qi/TJ4bkoRbTCFGyYdvnb/
        cSFyjumBVJwH8P+pK3egJiLDx6Gj4oTwUnw/2w54nDkyHr2efXbGj59zfVlNh32OfcETJF
        ovW05OChZNiCUYKiyAFw9Mnoj0Yj5fA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-QfgqFsSoNiS2oMFkp0ytDA-1; Thu, 09 Jul 2020 17:09:23 -0400
X-MC-Unique: QfgqFsSoNiS2oMFkp0ytDA-1
Received: by mail-qt1-f200.google.com with SMTP id e4so2599443qtd.13
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 14:09:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/5qJhIS3vYBRwpwDz6NnUQ7JwhKdspJwMVlrORtRFsI=;
        b=JrkKy0BjjFpAMuMZ6iYkZeW3zYM0dQkojyA4NMI23zyqffEt9dx7Wpv1fYte2DXxtj
         yBr9y9fysKpxn+fqzU1j3otoZgMwk57HE8/jXTlO01ZLlsAhaxaY/KWbg3objuJkwuoH
         qoDV/g4uEdaxd9VlmbXJcJz41kaDbhqjmgY7lp+dYpw4tMB4ElFdMc7eToXA0qk5x/fQ
         ++u+YqO4Bjv8a4xN51zHqeT94b6KBX/cZeXZoz+ZCMCUYWN13nnruz6uGmLxRL6MCbSG
         rpd2TjxvdEQUjPhbWoOtnV4Ulf8Anr+499Wb0f4sk/0+iwmIl7LaDMZucmb60IvMB/8A
         mlFA==
X-Gm-Message-State: AOAM531dS7ErHp1nDmDKyqeR70nsZdri8H/pONbIBOTCQAHcHRpF4k8H
        ZWTuL76JEQW7fssMbZq2veEN8Xz6cNhJ6lpYxUtRMaIzc512fqhTxjRJMSM1k4KxFHEUaYJYllD
        yuS+8sVr54Ufx
X-Received: by 2002:ae9:eb15:: with SMTP id b21mr63498662qkg.25.1594328962680;
        Thu, 09 Jul 2020 14:09:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJytMp4FZzlKADFTWMxlQgjTokjC1UG3cuT4XI3dTItP34+1t2ioJ/GoIHAk+kuY72jpqFDM/w==
X-Received: by 2002:ae9:eb15:: with SMTP id b21mr63498631qkg.25.1594328962287;
        Thu, 09 Jul 2020 14:09:22 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c8:6f::1f4f])
        by smtp.gmail.com with ESMTPSA id k194sm4993332qke.100.2020.07.09.14.09.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 14:09:21 -0700 (PDT)
Date:   Thu, 9 Jul 2020 17:09:19 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200709210919.GI199122@xz-x1>
References: <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
 <20200626180732.GB175520@xz-x1>
 <20200626181820.GG6583@linux.intel.com>
 <47b90b77-cf03-6087-b25f-fcd2fd313165@redhat.com>
 <20200630154726.GD7733@linux.intel.com>
 <20200709182220.GG199122@xz-x1>
 <20200709192440.GD24919@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200709192440.GD24919@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 09, 2020 at 12:24:40PM -0700, Sean Christopherson wrote:
> On Thu, Jul 09, 2020 at 02:22:20PM -0400, Peter Xu wrote:
> > On Tue, Jun 30, 2020 at 08:47:26AM -0700, Sean Christopherson wrote:
> > > On Sat, Jun 27, 2020 at 04:24:34PM +0200, Paolo Bonzini wrote:
> > > > On 26/06/20 20:18, Sean Christopherson wrote:
> > > > >> Btw, would it be more staightforward to check "vcpu->arch.arch_capabilities &
> > > > >> ARCH_CAP_TSX_CTRL_MSR" rather than "*ebx | (F(RTM) | F(HLE))" even if we want
> > > > >> to have such a fix?
> > > > > Not really, That ends up duplicating the check in vmx_get_msr().  From an
> > > > > emulation perspective, this really is a "guest" access to the MSR, in the
> > > > > sense that it the virtual CPU is in the guest domain, i.e. not a god-like
> > > > > entity that gets to break the rules of emulation.
> > > > 
> > > > But if you wrote a guest that wants to read MSR_IA32_TSX_CTRL, there are
> > > > two choices:
> > > > 
> > > > 1) check ARCH_CAPABILITIES first
> > > > 
> > > > 2) blindly access it and default to 0.
> > > > 
> > > > Both are fine, because we know MSR_IA32_TSX_CTRL has no
> > > > reserved/must-be-one bits.  Calling __kvm_get_msr and checking for an
> > > > invalid MSR through the return value is not breaking the rules of
> > > > emulation, it is "faking" a #GP handler.
> > > 
> > > "guest" was the wrong choice of word.  My point was that, IMO, emulation
> > > should never set host_initiated=true.
> > > 
> > > To me, accessing MSRs with host_initiated is the equivalent of loading a
> > > ucode patch, i.e. it's super duper special stuff that deliberately turns
> > > off all safeguards and can change the fundamental behavior of the (virtual)
> > > CPU.
> > 
> > This seems to be an orthogonal change against what this series tried to do.  We
> > use host_initiated=true in current code, and this series won't change that fact
> > either.  As I mentioned in the other thread, at least the rdmsr warning is
> > ambiguous when it's not initiated from the guest if without this patchset, and
> > this series could address that.
> 
> My argument is that using host_initiated=true is wrong.  
> 
> > > > So I think Peter's patch is fine, but (possibly on top as a third patch)
> > > > __must_check should be added to MSR getters and setters.  Also one
> > > > possibility is to return -EINVAL for invalid MSRs.
> > 
> > Yeah I can add another patch for that.  Also if to repost, I tend to also
> > introduce KVM_MSR_RET_[OK|ERROR] too, which seems to be cleaner when we had
> > KVM_MSR_RET_INVALID.
> > 
> > Any objections before I repost?
> 
> Heh, or perhaps "Any objections that haven't been overruled before I repost?" :-D

Again, using host_initiated or not should be a different issue?  Frankly
speaking, I don't know whether it's an issue or not, but it's different from
what this series wants to do, because it'll be the same before/after this
series. Am I right?

Or, please explain what's the "overruled objection" that you're talking about..

-- 
Peter Xu

