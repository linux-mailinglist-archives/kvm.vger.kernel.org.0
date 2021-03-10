Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26BC2334014
	for <lists+kvm@lfdr.de>; Wed, 10 Mar 2021 15:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhCJOOa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 09:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232861AbhCJOOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 09:14:03 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 254C4C061760;
        Wed, 10 Mar 2021 06:14:03 -0800 (PST)
Received: from zn.tnic (p200300ec2f0a9900452923910729ca7d.dip0.t-ipconnect.de [IPv6:2003:ec:2f0a:9900:4529:2391:729:ca7d])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id AE4BD1EC026F;
        Wed, 10 Mar 2021 15:14:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1615385641;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TkMrmSK/gpY6OtMDP3bCzeW/KsANAPjk+GubcA0SiVk=;
        b=E5tIxCfbxV1QtJ7+kVylOOkptdMD5POD0M28l1YoZoIW5BjvRtSO1DgTJyfsd3pCigHb73
        FLUR0E5MOJBdgkckOwBZ5WRAvXqEU6lsD2TQRaNJRsdp9MwWTl+mpMOE9fP7avOddwZqi+
        MMqMSC4Aom3dQrDOqhVRCmy5BqdUCF4=
Date:   Wed, 10 Mar 2021 15:13:47 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     =?utf-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>
Cc:     xen-devel@lists.xenproject.org, x86@kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        Deep Shah <sdeep@vmware.com>,
        "VMware, Inc." <pv-drivers@vmware.com>,
        Russell King <linux@armlinux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v6 02/12] x86/paravirt: switch time pvops functions to
 use static_call()
Message-ID: <20210310141347.GF23521@zn.tnic>
References: <20210309134813.23912-1-jgross@suse.com>
 <20210309134813.23912-3-jgross@suse.com>
 <20210309185737.GE699@zn.tnic>
 <e06cc359-6300-a26b-c307-9ef8d963b0c1@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e06cc359-6300-a26b-c307-9ef8d963b0c1@suse.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 10, 2021 at 08:51:22AM +0100, Jürgen Groß wrote:
> It is combining the two needed actions: update the static call and
> set the paravirt_using_native_sched_clock boolean.

I actually meant what the point of using_native_sched_clock() is but put
this comment at the wrong place, sorry.

> Just had another idea: I could add a function to static_call.h for
> querying the current function. This would avoid the double book keeping
> and could probably be used later when switching other pv_ops calls to
> static_call, too (e.g. pv_is_native_spin_unlock()).
> 
> What do you think?

Yap, that makes sense. Alternatively, you could even add a bitfield to
pv_ops which carries that info and since pv_ops is global...

But yeah, the less bookkeeping the better.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
