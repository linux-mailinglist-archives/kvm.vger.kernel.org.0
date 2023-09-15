Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0F47A12C4
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 03:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjIOBHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 21:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbjIOBHP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 21:07:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319D01FE8;
        Thu, 14 Sep 2023 18:07:11 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1694740029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cRPJbRPbpPyl0DIKbunWuB6+IYtaMtGVInY/dfsbq0=;
        b=YUWamJ5Utp3OQKs0c96zn7z7qwtq5o7oz8CSYdDscALYnuLUGz8SVTh1fz7twIzwmSpsjE
        vsB7w4hBDv0GFnE1NN3xIKfUwohwgKJpgAgZtmggKQQqDjhO+FNlFRQL/GB+Kh6EPdNzpk
        zRoYVcfu1QT7x79DLIjnLloBqPeETIiVgYs2saYJniSZNoOL1AkKr2CHD3knl35LxG/dAt
        vl6bKdoPy0wCFCYinek/JPK3YjMQeQzqL0G4ogM7a0qh4LFhznuacNFS7LjyPTQFfrPXf8
        6OJcRCfY0/JSCSl7MingVERa+6SpAnCJXhzq6Sz5oSfPHvpIl+lN69R9ABcy8w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1694740029;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cRPJbRPbpPyl0DIKbunWuB6+IYtaMtGVInY/dfsbq0=;
        b=YgXAAcfI7PqVQfPd3GS4BbveJ65cq2aLT9IHq5xExXqf946ewsDrQfSvPRljDdyjnuMZ8G
        TM8nzdItAHQpybAg==
To:     andrew.cooper3@citrix.com, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, luto@kernel.org,
        pbonzini@redhat.com, seanjc@google.com, peterz@infradead.org,
        ravi.v.shankar@intel.com, mhiramat@kernel.org,
        jiangshanlai@gmail.com, Xin Li <xin3.li@intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH v10 08/38] x86/cpufeatures: Add the cpu feature bit for
 FRED
In-Reply-To: <7d907488-d626-0801-3d4b-af42d00a5537@citrix.com>
References: <20230914044805.301390-1-xin3.li@intel.com>
 <20230914044805.301390-9-xin3.li@intel.com>
 <d98a362d-d806-4458-9473-be5bea254db7@suse.com>
 <77ca8680-02e2-cdaa-a919-61058e2d5245@suse.com>
 <7d907488-d626-0801-3d4b-af42d00a5537@citrix.com>
Date:   Fri, 15 Sep 2023 03:07:09 +0200
Message-ID: <87o7i41bya.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14 2023 at 14:15, andrew wrote:
> PV guests are never going to see FRED (or LKGS for that matter) because
> it advertises too much stuff which simply traps because the kernel is in
> CPL3.
>
> That said, the 64bit PV ABI is a whole lot closer to FRED than it is to
> IDT delivery.=C2=A0 (Almost as if we decided 15 years ago that giving the=
 PV
> guest kernel a good stack and GSbase was the right thing to do...)

No argument about that.

> In some copious free time, I think we ought to provide a
> minorly-paravirt FRED to PV guests because there are still some
> improvements available as low hanging fruit.
>
> My plan was to have a PV hypervisor leaf advertising paravirt versions
> of hardware features, so a guest could see "I don't have architectural
> FRED, but I do have paravirt-FRED which is as similar as we can
> reasonably make it".=C2=A0 The same goes for a whole bunch of other featu=
res.

*GROAN*

I told you before that we want less paravirt nonsense and not more. I'm
serious about that. XENPV CPL3 virtualization is a dead horse from a
technical POV. No point in wasting brain cycles to enhance the zombie
unless you can get rid of the existing PV nonsense, which you can't for
obvious reasons.

That said, we can debate this once the more fundamental issues of
XEN[PV] have been addressed. I expect that to happen quite some time
after I retired :)

Thanks,

        tglx
