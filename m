Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE0B8484965
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 21:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiADUn2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 15:43:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30706 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231175AbiADUn1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 4 Jan 2022 15:43:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641329007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sKCDKH8iAKV6R6bBKlfE9TSgq0EJgiwjwNLLPp/zRW0=;
        b=B8Z1+zRQmGDsNi+ticuVltSi9r5Jw4vGw8V8hNwJBDGnbjhsQhWfZx1CqLQWuTGQ2YFqdo
        gYhSmXH05QsC886gLc3GmthBuyri1/HlfIn84VBUGUfZ/heSwPkyHryBiL3mGxD8VMW4pv
        4o8KDnSuXwmwTJa5fhztuAhwtx4/b9I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-653-S7KjGhA3P2uduiHag6ZWnw-1; Tue, 04 Jan 2022 15:43:24 -0500
X-MC-Unique: S7KjGhA3P2uduiHag6ZWnw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 78B0310247AC;
        Tue,  4 Jan 2022 20:43:21 +0000 (UTC)
Received: from starship (unknown [10.40.192.177])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 74B8345D97;
        Tue,  4 Jan 2022 20:43:15 +0000 (UTC)
Message-ID: <a4fbf2ec33e7bbf81ea8c4750a5064ab67b94428.camel@redhat.com>
Subject: Re: [RFC PATCH 2/6] KVM: X86: Walk shadow page starting with
 shadow_root_level
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Date:   Tue, 04 Jan 2022 22:43:14 +0200
In-Reply-To: <c16e310f-8ae5-9c29-04c7-7355834ce803@redhat.com>
References: <20211210092508.7185-1-jiangshanlai@gmail.com>
         <20211210092508.7185-3-jiangshanlai@gmail.com>
         <YdSvbsb5wt/WURtw@google.com>
         <c16e310f-8ae5-9c29-04c7-7355834ce803@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-01-04 at 21:37 +0100, Paolo Bonzini wrote:
> On 1/4/22 21:34, Sean Christopherson wrote:
> > On Fri, Dec 10, 2021, Lai Jiangshan wrote:
> > > From: Lai Jiangshan<laijs@linux.alibaba.com>
> > > 
> > > Walking from the root page of the shadow page table should start with
> > > the level of the shadow page table: shadow_root_level.
> > > 
> > > Also change a small defect in audit_mappings(), it is believed
> > > that the current walking level is more valuable to print.
> > > 
> > > Signed-off-by: Lai Jiangshan<laijs@linux.alibaba.com>
> > > ---
> > >   arch/x86/kvm/mmu/mmu_audit.c | 5 ++---
> > 
> > I vote we remove mmu_audit.c.  It has bitrotted horribly, and none of the
> > current set of KVM developers even knows how to use it effectively.
> 
> No complaints.

I played with it once, its not that bad IMHO.

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


