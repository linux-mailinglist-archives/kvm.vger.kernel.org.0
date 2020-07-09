Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C817C21A6C7
	for <lists+kvm@lfdr.de>; Thu,  9 Jul 2020 20:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgGISW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 14:22:28 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22947 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726290AbgGISW1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Jul 2020 14:22:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594318945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aPXiyCrH7oXeBX9QLi0so8nbm8S4tmPS8K/PlqOIwFU=;
        b=i3i/GC0FddMzUEOol9uWfQJ64H9CEGBs1NWR308YhbaMChJ5yfJBh7IO62UcVIP1Mkv/P+
        vbhgmEjuh+cshR33I1eu9NK3ROyk00KUrt1zwA6+T2WSen+H9REOc7aL9BqX2PyWVqz18j
        pOpy9b/H1giPyazgsKwNyWF7KsI8GKY=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-PL_GtNAdMu-IT1PJx8qKlQ-1; Thu, 09 Jul 2020 14:22:24 -0400
X-MC-Unique: PL_GtNAdMu-IT1PJx8qKlQ-1
Received: by mail-qk1-f197.google.com with SMTP id i145so2451045qke.2
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 11:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aPXiyCrH7oXeBX9QLi0so8nbm8S4tmPS8K/PlqOIwFU=;
        b=j4jqoOXL6A99sL1lKe9tNO+gIEd6OoMO+ipwIbypNVqug7oosQNI/73cf8G9DE1SKW
         yWo12rqqxP5Zf44IJqIg+AuCG7+wIc8Q3De6VY4tz6iD4RN5gb2LIALJTWA7e7Pa9YXP
         ZoRE+St8a6PtZ345JUQH8DyyhDW4GNLdyWseRU98O6W98zADMlEbWG6gLfaTmEI0fSVJ
         v98nQGrCjQ8piaKvzzSlSFHpGk34DymztOfPaxLRbqDFRqMNXY6v+Zp4k9IdtZanFCS8
         5aOyNYuSs73QZjjbTUCEmgItT6kC+9htOHxRuMrt2sIuC/8ex3Ullnxk0sGyxDmSzU82
         R8Qg==
X-Gm-Message-State: AOAM533jf7GCP6qo7i/yUqEsHWV8Zhu1p+MbBRyL7zHwTX35lgfSfMf7
        WoJDkGbeoGiLGEdV1/ZeDDy2+TgMy78G6LUZO2fb+wGSFYJMYzxMdyShS8u7to5bQ4HCGo32SMc
        kNRipHrnRIDfb
X-Received: by 2002:aed:2a36:: with SMTP id c51mr39636231qtd.264.1594318943269;
        Thu, 09 Jul 2020 11:22:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxqsYywhmXTQRogPqAPHeaEeyc9RZJ23AF7MNu+3uBKa8vxZOosdZtq4sQ4TcPk5Z1Polevwg==
X-Received: by 2002:aed:2a36:: with SMTP id c51mr39636203qtd.264.1594318942990;
        Thu, 09 Jul 2020 11:22:22 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c8:6f::1f4f])
        by smtp.gmail.com with ESMTPSA id y40sm4756253qtc.29.2020.07.09.11.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 11:22:22 -0700 (PDT)
Date:   Thu, 9 Jul 2020 14:22:20 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
Message-ID: <20200709182220.GG199122@xz-x1>
References: <20200622220442.21998-1-peterx@redhat.com>
 <20200622220442.21998-2-peterx@redhat.com>
 <20200625061544.GC2141@linux.intel.com>
 <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com>
 <20200626180732.GB175520@xz-x1>
 <20200626181820.GG6583@linux.intel.com>
 <47b90b77-cf03-6087-b25f-fcd2fd313165@redhat.com>
 <20200630154726.GD7733@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200630154726.GD7733@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 30, 2020 at 08:47:26AM -0700, Sean Christopherson wrote:
> On Sat, Jun 27, 2020 at 04:24:34PM +0200, Paolo Bonzini wrote:
> > On 26/06/20 20:18, Sean Christopherson wrote:
> > >> Btw, would it be more staightforward to check "vcpu->arch.arch_capabilities &
> > >> ARCH_CAP_TSX_CTRL_MSR" rather than "*ebx | (F(RTM) | F(HLE))" even if we want
> > >> to have such a fix?
> > > Not really, That ends up duplicating the check in vmx_get_msr().  From an
> > > emulation perspective, this really is a "guest" access to the MSR, in the
> > > sense that it the virtual CPU is in the guest domain, i.e. not a god-like
> > > entity that gets to break the rules of emulation.
> > 
> > But if you wrote a guest that wants to read MSR_IA32_TSX_CTRL, there are
> > two choices:
> > 
> > 1) check ARCH_CAPABILITIES first
> > 
> > 2) blindly access it and default to 0.
> > 
> > Both are fine, because we know MSR_IA32_TSX_CTRL has no
> > reserved/must-be-one bits.  Calling __kvm_get_msr and checking for an
> > invalid MSR through the return value is not breaking the rules of
> > emulation, it is "faking" a #GP handler.
> 
> "guest" was the wrong choice of word.  My point was that, IMO, emulation
> should never set host_initiated=true.
> 
> To me, accessing MSRs with host_initiated is the equivalent of loading a
> ucode patch, i.e. it's super duper special stuff that deliberately turns
> off all safeguards and can change the fundamental behavior of the (virtual)
> CPU.

This seems to be an orthogonal change against what this series tried to do.  We
use host_initiated=true in current code, and this series won't change that fact
either.  As I mentioned in the other thread, at least the rdmsr warning is
ambiguous when it's not initiated from the guest if without this patchset, and
this series could address that.

> 
> > So I think Peter's patch is fine, but (possibly on top as a third patch)
> > __must_check should be added to MSR getters and setters.  Also one
> > possibility is to return -EINVAL for invalid MSRs.

Yeah I can add another patch for that.  Also if to repost, I tend to also
introduce KVM_MSR_RET_[OK|ERROR] too, which seems to be cleaner when we had
KVM_MSR_RET_INVALID.

Any objections before I repost?

-- 
Peter Xu

