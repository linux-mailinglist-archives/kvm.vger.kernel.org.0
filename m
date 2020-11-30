Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB352C8E26
	for <lists+kvm@lfdr.de>; Mon, 30 Nov 2020 20:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729851AbgK3Tfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Nov 2020 14:35:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbgK3Tfk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Nov 2020 14:35:40 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C538FC061A49
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 11:35:24 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id u2so7038031pls.10
        for <kvm@vger.kernel.org>; Mon, 30 Nov 2020 11:35:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P2JAtkf1gp7Yf1H5qMpHVhFTHg5rB+CUXS9hxTq7SNI=;
        b=NxXmrbpDRHsldZTSsy0qE8vgOBTXLxOjMsnknxQQmDK3ngRn9DeklqrZntmKGe336V
         PYcy6x37/WGVPR99++qUet3IX2DSV8yQ86gipBOngnu8ogVhs/PZvb1tzSl1JLMcmOJy
         n9kvgQA9gderMszFPhEFdt2zyJfwiWDeQKqKdqhsj/QSn6lEN7lZ0v/WsMizgrFAO7L1
         TYV+W7i+T+NkctnB/0dahbFAciISfVT99LNI/DJ+/cfVPJ5jDKhDSNljWuY92DEkSo5Z
         j6bE8j0zHFoVIQPX5U+UjzNuozZGfsAO5PK5BN/If6+oLq2Vb8sUQ1jDl+HpxbgczSqp
         JvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P2JAtkf1gp7Yf1H5qMpHVhFTHg5rB+CUXS9hxTq7SNI=;
        b=fOi/E7VO0mq0PBtjpGyRmOgzZHj6if5nnHdPIagvD+8orCekJTqW70ASf9YCSj52yB
         iMpxQ0BCiBbaiJV2okQmc0sT/ZLU/1VFN0swM7k5XrKsg9F1esvjWEJccTsgoziujFD5
         aiWIVwWPPXwSmmYlRaIFUf/6WTSm20h6sY98L9bPCDdasVsXBQfWZ7fZqQC7zlX86Jej
         RNN17Ak8ot/smkPWbRY4n6NUfr4wENLzST29PzdOVj93ebeYJ49gkpuMq8uQsaXriD4q
         ihJCwf0ucdi4ZgvBHSi8QLVdHscIWk6mgsOdCWmlBOcRj2Zz4RJk64vl9a2xBixMm2OR
         f3lQ==
X-Gm-Message-State: AOAM531CF0ORcDqeZRJU8NvUMhLjeWiu4UXdSHP0et1IiK7hLA+Hmazi
        JBdyiMuLtHWyECS215YtIAFR+Q==
X-Google-Smtp-Source: ABdhPJxxgSW5IU4tyt7wcB4qR3mvypBTZvljWcm/e4RwZlg8aeE/2iKg/BjLuMZ5v1EETtQ9aGzK7A==
X-Received: by 2002:a17:902:8b89:b029:d6:df6e:54df with SMTP id ay9-20020a1709028b89b02900d6df6e54dfmr20239687plb.0.1606764924152;
        Mon, 30 Nov 2020 11:35:24 -0800 (PST)
Received: from google.com (242.67.247.35.bc.googleusercontent.com. [35.247.67.242])
        by smtp.gmail.com with ESMTPSA id q19sm17552238pff.101.2020.11.30.11.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 11:35:23 -0800 (PST)
Date:   Mon, 30 Nov 2020 19:35:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>
Subject: Re: [RFC PATCH 00/35] SEV-ES hypervisor support
Message-ID: <X8VJdxTKKkC7uEMh@google.com>
References: <cover.1600114548.git.thomas.lendacky@amd.com>
 <20200914225951.GM7192@sjchrist-ice>
 <bee6fdda-d548-8af5-f029-25c22165bf84@amd.com>
 <20200916001925.GL8420@sjchrist-ice>
 <60cbddaf-50f3-72ca-f673-ff0b421db3ad@redhat.com>
 <X8U2gyj7F2wFU3JI@google.com>
 <8759948d-aa0b-3929-bda6-488b6788489a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8759948d-aa0b-3929-bda6-488b6788489a@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Isaku and Xiaoyao

On Mon, Nov 30, 2020, Paolo Bonzini wrote:
> On 30/11/20 19:14, Sean Christopherson wrote:
> > > > TDX also selectively blocks/skips portions of other ioctl()s so that the
> > > > TDX code itself can yell loudly if e.g. .get_cpl() is invoked.  The event
> > > > injection restrictions are due to direct injection not being allowed (except
> > > > for NMIs); all IRQs have to be routed through APICv (posted interrupts) and
> > > > exception injection is completely disallowed.
> > > > 
> > > >     kvm_vcpu_ioctl_x86_get_vcpu_events:
> > > > 	if (!vcpu->kvm->arch.guest_state_protected)
> > > >           	events->interrupt.shadow = kvm_x86_ops.get_interrupt_shadow(vcpu);
> > > Perhaps an alternative implementation can enter the vCPU with immediate exit
> > > until no events are pending, and then return all zeroes?
> > 
> > This can't work.  If the guest has STI blocking, e.g. it did STI->TDVMCALL with
> > a valid vIRQ in GUEST_RVI, then events->interrupt.shadow should technically be
> > non-zero to reflect the STI blocking.  But, the immediate exit (a hardware IRQ
> > for TDX guests) will cause VM-Exit before the guest can execute any instructions
> > and thus the guest will never clear STI blocking and never consume the pending
> > event.  Or there could be a valid vIRQ, but GUEST_RFLAGS.IF=0, in which case KVM
> > would need to run the guest for an indeterminate amount of time to wait for the
> > vIRQ to be consumed.
> 
> Delayed interrupts are fine, since they are injected according to RVI and
> the posted interrupt descriptor.  I'm thinking more of events (exceptions
> and interrupts) that caused an EPT violation exit and were recorded in the
> IDT-vectored info field.

Ah.  As is, I don't believe KVM has access to this information.  TDX-Module
handles the actual EPT violation, as well as event reinjection.  The EPT
violation reported by SEAMRET is synthesized, and IIRC the IDT-vectoring field
is not readable.

Regardless, is there an actual a problem with having a "pending" exception that
isn't reported to userspace?  Obviously the info needs to be migrated, but that
will be taken care of by virtue of migrating the VMCS.
