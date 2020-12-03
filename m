Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A952CD4F0
	for <lists+kvm@lfdr.de>; Thu,  3 Dec 2020 12:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729276AbgLCLw6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Dec 2020 06:52:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55480 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726814AbgLCLw4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Dec 2020 06:52:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606996289;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ScdhfDhjAuXu+GH71ihpEjaoSfXwj3jq1ZQT+u4Lu1w=;
        b=ZEbN5NsMd7tWx7gLsOeN/JJujw+o61WMxCokRQneEi7Ky2kRQ2fOQEL4XDs7iSorHoj/pw
        3LJJW4ea6cvCduz4jDNIYmK45l+scJ3yASxRTDLt+3gNhMp0SuyMIMy7P+BcqlxEryQgg1
        mpMNdFznG55lDmQBtyYpsv/nm2IN4J0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-PhTLFyMHNrWoWeCpjN9RLA-1; Thu, 03 Dec 2020 06:51:28 -0500
X-MC-Unique: PhTLFyMHNrWoWeCpjN9RLA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D192219357A8;
        Thu,  3 Dec 2020 11:51:25 +0000 (UTC)
Received: from starship (unknown [10.35.206.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AAC6860BFA;
        Thu,  3 Dec 2020 11:51:19 +0000 (UTC)
Message-ID: <77e48fe09de55fa77a9e33a2c6212e42c83556be.camel@redhat.com>
Subject: Re: [PATCH 0/2] RFC: Precise TSC migration
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Oliver Upton <oupton@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Jim Mattson <jmattson@google.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Date:   Thu, 03 Dec 2020 13:51:18 +0200
In-Reply-To: <20201201150205.GA42117@fuller.cnet>
References: <20201130133559.233242-1-mlevitsk@redhat.com>
         <20201130191643.GA18861@fuller.cnet>
         <877dq1hc2s.fsf@nanos.tec.linutronix.de>
         <20201201150205.GA42117@fuller.cnet>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2020-12-01 at 12:02 -0300, Marcelo Tosatti wrote:
> On Tue, Dec 01, 2020 at 02:48:11PM +0100, Thomas Gleixner wrote:
> > On Mon, Nov 30 2020 at 16:16, Marcelo Tosatti wrote:
> > > > Besides, Linux guests don't sync the TSC via IA32_TSC write,
> > > > but rather use IA32_TSC_ADJUST which currently doesn't participate
> > > > in the tsc sync heruistics.
> > > 
> > > Linux should not try to sync the TSC with IA32_TSC_ADJUST. It expects
> > > the BIOS to boot with synced TSCs.
> > 
> > That's wishful thinking.
> > 
> > Reality is that BIOS tinkerers fail to get it right. TSC_ADJUST allows
> > us to undo the wreckage they create.
> > 
> > Thanks,
> > 
> >         tglx
> 
> Have not seen any multicore Dell/HP systems require that.
> 
> Anyway, for QEMU/KVM it should be synced (unless there is a bug
> in the sync logic in the first place).
> 

I agree with that, and that is why I suggested to make the guest
avoid TSC syncing when KVM is detected.
 
I don't mind how to implement this.
 
It can be either done with new CPUID bit, 
or always when KVM
is detected, 
(or even when *any* hypervisor is detected)
 
I also don't mind if we only disable tsc sync logic or
set X86_FEATURE_TSC_RELIABLE which will disable it
and the clocksource watchdog.


Best regards,
	Maxim Levitsky



