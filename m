Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0DC744ECAC
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 19:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbhKLSiZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 13:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbhKLSiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Nov 2021 13:38:24 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2882FC061767
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 10:35:33 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id r132so6613884pgr.9
        for <kvm@vger.kernel.org>; Fri, 12 Nov 2021 10:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aRpdsQJUDByg0HBGIuAmTxG9SQVrfVKDPlTbuTeIEko=;
        b=nfkjBxzgjU7zq1OYl9fbzZhnEzb6x7Y0eXcPAWnNHPZ+LL/N53U5aUJB8TIhXZxOSu
         xqNh3ZY4x9VHG+rcJ5yZKXueX2GdKWK2nBLclHiiER+pkvIjvVTnrinJNfhv3T7rTxTU
         T1iUX3jdunqhW2mGhwpswsKH+X2s5z+/5hbhiJ0RKTABHnQvpX+9RdjILEwHg9aOKm/Z
         sVNf+dmHoGCLb4NQgsWw1VvCd17kJX/9nFLPX5Fp1jUBqbh1YiyBKD1LRqduuM8Ps0SX
         wsY0Yl/gBFCR4UoQZ22Hmp8whxniu261fjsWie7/Wf9lJgczj0VjU99YmxDsJKkUIm79
         mrxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aRpdsQJUDByg0HBGIuAmTxG9SQVrfVKDPlTbuTeIEko=;
        b=2puc2TF++7iM9TZeyS1CrnXyH+ovqYlk16UfsRX8ruwDY2jqCH8K0ZR/uzLpp9Ycee
         gWR5ZLdlZbNOj0kspxqtAfSflxJp+2JeQeSxp0hf5jQhCaQlTvH6z6b2J9T2bP+kiFVQ
         sceZ9QjayD3JYy3Kfnm+OIFX9RVP5TxVvdBqRvbzjrw9UoFl3AH+i0Hf12Ap/hPLvSJx
         4/tQiaSx74LC76rDdCYvbwi1K8JhA4DAbRiMU9JokEdcrzuKsUKhmwkpMPOKc41X4Osj
         FoJeF92Kdg2Mq2H/3MjfLLnXMWpu5cAQtnvxc3x9iO+eNAWsOVNy8Hs4/G/a3O7kho58
         eoQw==
X-Gm-Message-State: AOAM531VpnlMLbI5ZkFJBTdHH2vqKCFTKYL4QiEocXW1dIV65jdVXwXd
        N62M6adkemoYg5xMppCuT2ihTw==
X-Google-Smtp-Source: ABdhPJyv/NLYkBqIpIYH/axU4ys+po0FKfQNRAO7lypMlrU/thyWCU5gg7alRH13F7Msjx1FT5xhDg==
X-Received: by 2002:aa7:8e12:0:b0:47b:dcda:658 with SMTP id c18-20020aa78e12000000b0047bdcda0658mr15611860pfr.46.1636742132503;
        Fri, 12 Nov 2021 10:35:32 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id w24sm5566787pgi.81.2021.11.12.10.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 10:35:31 -0800 (PST)
Date:   Fri, 12 Nov 2021 18:35:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        isaku.yamahata@intel.com, Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH 07/11] KVM: x86: Disable SMM for TDX
Message-ID: <YY6z8NoXyv4C2X9Z@google.com>
References: <20211112153733.2767561-1-xiaoyao.li@intel.com>
 <20211112153733.2767561-8-xiaoyao.li@intel.com>
 <YY6stGpsmZawyRy5@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YY6stGpsmZawyRy5@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 12, 2021, Sean Christopherson wrote:
> On Fri, Nov 12, 2021, Xiaoyao Li wrote:
> This patch neglects to disallow SMI via IPI.  Ditto for INIT+SIPI in the next
> patch.  And no small part of me thinks we shouldn't even bother handling the
> delivery mode in the MSI routing.  If we reject MSI configuration, then to be
> consistent we should also technically reject guest attempts to configure LVT
> entries.  Sadly, KVM doesn't handle any of that stuff correctly as there are
> assumptions left and right about how the guest will configure things like LVTT,
> but from an architctural perspective it is legal to configure LVT0, LVT1, LVTT,
> etc... to send SMI, NMI, INIT, etc...
> 
> The kvm_eoi_intercept_disallowed() part is a little different, since KVM can
> deliver the interrupt, it just can handle the backend correctly.  Dropping an
> event on the floor is a bit gross, but on the other hand I really don't want to
> sign up for a game of whack-a-mole for all the paths that can get to
> __apic_accept_irq().

...

> >  static int kvm_vcpu_ioctl_smi(struct kvm_vcpu *vcpu)
> >  {
> > +	if (kvm_smm_unsupported(vcpu->kvm))
> > +		return -EINVAL;
> > +

Oh, and despite saying we should "allow" the MSI routing, I do think we should
reject this ioctl().  The difference in my mind is that for the ioctl(), it's KVM's
"architecture" and we can define it as we see fit, whereas things like APIC delivery
mode are x86 architecture and we should do our best to avoid making things up.

We're obviously still making up behavior to some extent, but it's at least somewhat
aligned with hardware since I believe the architcture just says "undefined behavior"
for invalid modes/combinations, and AFAIK configuring invalid/reserved delivery modes
will "succeed" in the sense that the CPU won't explode on the write and the APIC
won't catch fire.
