Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763FD7A11E3
	for <lists+kvm@lfdr.de>; Fri, 15 Sep 2023 01:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjINXg1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 19:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbjINXgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 19:36:17 -0400
Received: from mail.zytor.com (unknown [IPv6:2607:7c80:54:3::138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2B71FE5;
        Thu, 14 Sep 2023 16:36:13 -0700 (PDT)
Received: from [127.0.0.1] ([98.35.210.218])
        (authenticated bits=0)
        by mail.zytor.com (8.17.1/8.17.1) with ESMTPSA id 38ENYgxH3601720
        (version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
        Thu, 14 Sep 2023 16:34:43 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 38ENYgxH3601720
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
        s=2023091101; t=1694734484;
        bh=HfDqs1jBqLi+wrOAc4wIZvejTylBZZBdkCZqJwfRfd0=;
        h=Date:From:To:CC:Subject:In-Reply-To:References:From;
        b=h+aH6y0bTuApWxxD0FGjLZCir3TsFygt5Z9SAiZwA3JAE+f+OJHnzcCQksobB7fOf
         5t1gZi7cIwWXVEB01lFLGAHBgIpv4fcHjY9QNMiSrQuPZeBGcRpKbeMXty4ZIfYedU
         1tv3IuQNIPxZHrs7YDo6Vrvah8hW583SZzsPGiIls3jmL6PB3fn61Gr3Vh2AL8DSxq
         tVtSK31u2cUqkmrWiK8GuIEiYQtSyKLVTjVkXiAhLjIKrXRZsdB84Y60zEamLvptpU
         8+0m+otGzcTNZ6tpxE8ZrDlZRbLCc1IY2zJrzBoIqmGOuc6Ks130pSbhAGP0zlb08L
         0YHA1+0T0R5WA==
Date:   Thu, 14 Sep 2023 16:34:40 -0700
From:   "H. Peter Anvin" <hpa@zytor.com>
To:     Thomas Gleixner <tglx@linutronix.de>, andrew.cooper3@citrix.com,
        Xin Li <xin3.li@intel.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org,
        linux-hyperv@vger.kernel.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org
CC:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, luto@kernel.org, pbonzini@redhat.com,
        seanjc@google.com, peterz@infradead.org, jgross@suse.com,
        ravi.v.shankar@intel.com, mhiramat@kernel.org,
        jiangshanlai@gmail.com
Subject: Re: [PATCH v10 03/38] x86/msr: Add the WRMSRNS instruction support
User-Agent: K-9 Mail for Android
In-Reply-To: <87y1h81ht4.ffs@tglx>
References: <20230914044805.301390-1-xin3.li@intel.com> <20230914044805.301390-4-xin3.li@intel.com> <6f5678ff-f8b1-9ada-c8c7-f32cfb77263a@citrix.com> <87y1h81ht4.ffs@tglx>
Message-ID: <B93766B5-563E-401D-A1EF-579077CAEE82@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On September 14, 2023 4:00:39 PM PDT, Thomas Gleixner <tglx@linutronix=2Ede=
> wrote:
>Andrew!
>
>On Thu, Sep 14 2023 at 15:05, andrew wrote:
>> On 14/09/2023 5:47 am, Xin Li wrote:
>>> +static __always_inline void wrmsrns(u32 msr, u64 val)
>>> +{
>>> +	__wrmsrns(msr, val, val >> 32);
>>> +}
>>
>> This API works in terms of this series where every WRMSRNS is hidden
>> behind a FRED check, but it's an awkward interface to use anywhere else
>> in the kernel=2E
>
>Agreed=2E
>
>> I fully understand that you expect all FRED capable systems to have
>> WRMSRNS, but it is not a hard requirement and you will end up with
>> simpler (and therefore better) logic by deleting the dependency=2E
>
>According to the CPU folks FRED systems are guaranteed to have WRMSRNS -
>I asked for that :)=2E It's just not yet documented=2E
>
>But that I aside, I agree that we should opt for the safe side with a
>fallback like the one you have in XEN even for the places which are
>strictly FRED dependent=2E
>
>> As a "normal" user of the WRMSR APIs, the programmer only cares about:
>>
>> 1) wrmsr() -> needs to be serialising
>> 2) wrmsr_ns() -> safe to be non-serialising
>
>Correct=2E
>
>> In Xen, I added something of the form:
>>
>> /* Non-serialising WRMSR, when available=2E=C2=A0 Falls back to a seria=
lising
>> WRMSR=2E */
>> static inline void wrmsr_ns(uint32_t msr, uint32_t lo, uint32_t hi)
>> {
>> =C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0 * WRMSR is 2 bytes=2E=C2=A0 WRMSRNS is 3 bytes=
=2E=C2=A0 Pad WRMSR with a redundant CS
>> =C2=A0=C2=A0=C2=A0=C2=A0 * prefix to avoid a trailing NOP=2E
>> =C2=A0=C2=A0=C2=A0=C2=A0 */
>> =C2=A0=C2=A0=C2=A0 alternative_input("=2Ebyte 0x2e; wrmsr",
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "=2Ebyte 0x0f,0x0=
1,0xc6", X86_FEATURE_WRMSRNS,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 "c" (msr), "a" (l=
o), "d" (hi));
>> }
>>
>> and despite what Juergen said, I'm going to recommend that you do wire
>> this through the paravirt infrastructure, for the benefit of regular
>> users having a nice API, not because XenPV is expecting to do something
>> wildly different here=2E
>
>I fundamentaly hate adding this to the PV infrastructure=2E We don't want
>more PV ops, quite the contrary=2E
>
>For the initial use case at hand, there is an explicit FRED dependency
>and the code in question really wants to use WRMSRNS directly and not
>through a PV function call=2E
>
>I agree with your reasoning for the more generic use case where we can
>gain performance independent of FRED by using WRMSRNS for cases where
>the write has no serialization requirements=2E
>
>But this made me look into PV ops some more=2E For actual performance
>relevant code the current PV ops mechanics are a horrorshow when the op
>defaults to the native instruction=2E
>
>Let's look at wrmsrl():
>
>wrmsrl(msr, val
> wrmsr(msr, (u32)val, (u32)val >> 32))
>  paravirt_write_msr(msr, low, high)
>    PVOP_VCALL3(cpu=2Ewrite_msr, msr, low, high)
>
>Which results in
>
>	mov	$msr, %edi
>	mov	$val, %rdx
>	mov	%edx, %esi
>	shr	$0x20, %rdx
>	call	native_write_msr
>
>and native_write_msr() does at minimum:
>
>	mov    %edi,%ecx
>	mov    %esi,%eax
>	wrmsr
>        ret
>
>In the worst case 'ret' is going through the return thunk=2E Not to talk
>about function prologues and whatever=2E
>
>This becomes even more silly for trivial instructions like STI/CLI or in
>the worst case paravirt_nop()=2E
>
>The call makes only sense, when the native default is an actual
>function, but for the trivial cases it's a blatant engineering
>trainwreck=2E
>
>I wouldn't care at all if CONFIG_PARAVIRT_XXL would be the esoteric use
>case, but AFAICT it's default enabled on all major distros=2E
>
>So no=2E I'm fundamentally disagreeing with your recommendation=2E The wa=
y
>forward is:
>
>  1) Provide the native variant for wrmsrns(), i=2Ee=2E rename the propos=
ed
>     wrmsrns() to native_wrmsr_ns() and have the X86_FEATURE_WRMSRNS
>     safety net as you pointed out=2E
>
>     That function can be used in code which is guaranteed to be not
>     affected by the PV_XXL madness=2E
>
>  2) Come up with a sensible solution for the PV_XXL horrorshow
>
>  3) Implement a sane general variant of wrmsr_ns() which handles
>     both X86_FEATURE_WRMSRNS and X86_MISFEATURE_PV_XXL
>
>  4) Convert other code which benefits from the non-serializing variant
>     to wrmsr_ns()
>
>Thanks,
>
>        tglx
>

With regards to (2), the IMO only sensible solution is to have the ABI be =
the one of the native instruction, and to have the PVXXL users take the ful=
l brunt of the overhead=2E That means that on a native or HVM machine, the =
proper code gets patched in inline, and the PVXXL code becomes a call to a =
stub to do the parameter marshalling before walking off back into C ABI lan=
d=2E The pvop further has to bear the full cost of providing the full nativ=
e semantics unless otherwise agreed with the native maintainers and explici=
tly documented what the modified semantics are (notably, having excplicit s=
tubs for certain specific MSRs is entirely reasonable=2E)

In case this sounds familiar, it is the pvops we were promised over 15 yea=
rs ago, and yet somehow never really got there=2E It *also* is similar in a=
n inside-out way of the ABI marshalling used for legacy BIOS functions in t=
he 16-bit startup code=2E

In-place "fat" paravirtualization in the Linux kernel has been a horror sh=
ow, with the notable exception of UML, which is almost universally ignored =
but yet manages to stay out of the way and keep working=2E

This is a classic case of Tragedy of The Commons, much like burning coal f=
or power=2E

