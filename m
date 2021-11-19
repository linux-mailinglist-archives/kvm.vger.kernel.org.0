Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E30A456D0B
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 11:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234431AbhKSKQK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 05:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhKSKQJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 05:16:09 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E952C061574;
        Fri, 19 Nov 2021 02:13:08 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637316785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gw6I5YRsRkInKGssu3hTG28k+kByLo0r97DM9DJAbD0=;
        b=VviHMEuB0eshwGTkl6haVfYC0qheJK1afTCgDQSuuybk7NFkxDOwOaZjhZAa+7fmMG/tnL
        HrKcO+ulWy/jPJsBP0kZG/NyKEFQEIZ1CaOhROHCPOFPb9oWouK78RYF4K9fLQZXI/Darq
        WTVQuUNQ2Cc8nYsjVGAwIavk31Q/cvhAVglvN2wZHFaojeGCNYAMohtowVjWcdyJjE8Q+p
        wYvLqh9R52e7dqXb04EBcQzJo9JCVgm8EU73fKH7xd8fehOuVhOlH0PCxDIUgOns7veUQ7
        kwWb4IRnpi68Wg520Cp4tc+hY9yByd0fzE1ZsEhdDsiDddKjd1/AN9S/fhithw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637316785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gw6I5YRsRkInKGssu3hTG28k+kByLo0r97DM9DJAbD0=;
        b=2fXk1DsLX+ZDmRpdY3tY+0C+GkktADbH+W1HbNsaZM/nUI4sKrG3qF24Yss5mOEZziJRNv
        gbWEQbGx57Nn3ZDA==
To:     "Nakajima, Jun" <jun.nakajima@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Jing2" <jing2.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>,
        "Cooper, Andrew" <andrew.cooper3@citrix.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>
Subject: Re: Thoughts of AMX KVM support based on latest kernel
In-Reply-To: <D93C093C-8420-45DA-99F5-0A5318ADBBEF@intel.com>
References: <BYAPR11MB325685AB8E3DFD245846F854A9939@BYAPR11MB3256.namprd11.prod.outlook.com>
 <878rxn6h6t.ffs@tglx> <16BF8BE6-B7B1-4F3E-B972-9D82CD2F23C8@intel.com>
 <2e2ab02c-b324-e136-924a-0376040163a8@redhat.com>
 <BN9PR11MB5433D6A1368904D9B748846B8C9A9@BN9PR11MB5433.namprd11.prod.outlook.com>
 <c7d87723-5533-257f-fbf0-ecd3a0b96602@redhat.com>
 <D93C093C-8420-45DA-99F5-0A5318ADBBEF@intel.com>
Date:   Fri, 19 Nov 2021 11:13:05 +0100
Message-ID: <87sfvslaha.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Jun,

On Thu, Nov 18 2021 at 23:17, Jun Nakajima wrote:
> On Nov 17, 2021, at 4:53 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> It doesn't have to happen in current processors, but it should be
>> architecturally valid behavior to clear the processor's state as soon
>> as a bit in XFD is set to 1.
>
> 3.3 RECOMMENDATIONS FOR SYSTEM SOFTWARE
>
> System software may disable use of Intel AMX by clearing XCR0[18:17],
> by clearing CR4.OSXSAVE, or by setting IA32_XFD[18]. It is recommended
> that system software initialize AMX state (e.g., by executing
> TILERELEASE) before doing so. This is because maintaining AMX state in
> a non-initialized state may have negative power and performance
> implications.
>
> System software should not use XFD to implement a =E2=80=9Clazy restore=
=E2=80=9D
> approach to management of the XTILEDATA state component. This approach
> will not operate correctly for a variety of reasons. One is that the
> LDTILECFG and TILERELEASE instructions initialize XTILEDATA and do not
> cause an #NM exception. Another is that an execution of XSAVE by a
> user thread will save XTILEDATA as initialized instead of the data
> expected by the user thread.

Can this pretty please be reworded so that it says:

  When setting IA32_XFD[18] the AMX register state is not guaranteed to
  be preserved. The resulting register state depends on the
  implementation.

Also it's a real design disaster that component 17 cannot be fenced off
via XFD. That's really inconsistent and leads exactly to this half
defined state.

Thanks,

        tglx
