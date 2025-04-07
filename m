Return-Path: <kvm+bounces-42798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 195CBA7D673
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 09:44:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1F623425461
	for <lists+kvm@lfdr.de>; Mon,  7 Apr 2025 07:39:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A259E226CE0;
	Mon,  7 Apr 2025 07:38:21 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mx1.zhaoxin.com (MX1.ZHAOXIN.COM [210.0.225.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF68E2253A7
	for <kvm@vger.kernel.org>; Mon,  7 Apr 2025 07:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.0.225.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744011501; cv=none; b=sI4u7UTs8EkPDe/2jTd5KF4bhveT0zpxQxZz9PZcnYVUO7zy4polsLLPCc19ow/ks/RaxxwRiq3/ysyP/4D/VLI2dB3cuIE1bXvmzSMSfSifWa6PMdN0JbKmzes0GI+9paH1S+lCt6um9TFukc07EtC4GnCa1IIZsqCerAd8jGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744011501; c=relaxed/simple;
	bh=DuK3bifKObUj/1hjDahLrFJvEo4z68yicijyl+kid9k=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=TIiCESfWmPjY4CxQvqLREMNg4Vh7epb+7NJ6HqPvtL+QIdz8Fm9nxB4s5y76tEdut5h/y4x4KRj2yBTIYh2XUXwr7FnqDYxuvStHgfrKXqPbpbt5x97RpbbGQK75rYWHX4bsVEV9QBG7Oq289GxuHg3IZBoX/dy0zO6h7zgKqSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=210.0.225.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1744011490-086e2365b944450001-HEqcsx
Received: from ZXSHMBX1.zhaoxin.com (ZXSHMBX1.zhaoxin.com [10.28.252.163]) by mx1.zhaoxin.com with ESMTP id kLJek5uXD4GYIZIg (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO); Mon, 07 Apr 2025 15:38:10 +0800 (CST)
X-Barracuda-Envelope-From: LiamNi-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from ZXSHMBX3.zhaoxin.com (10.28.252.165) by ZXSHMBX1.zhaoxin.com
 (10.28.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.44; Mon, 7 Apr
 2025 15:38:10 +0800
Received: from ZXSHMBX3.zhaoxin.com ([fe80::8cc5:5bc6:24ec:65f2]) by
 ZXSHMBX3.zhaoxin.com ([fe80::8cc5:5bc6:24ec:65f2%6]) with mapi id
 15.01.2507.044; Mon, 7 Apr 2025 15:38:09 +0800
X-Barracuda-RBL-Trusted-Forwarder: 10.28.252.163
Received: from [10.28.66.46] (10.28.66.46) by ZXBJMBX02.zhaoxin.com
 (10.29.252.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.44; Mon, 7 Apr
 2025 10:19:32 +0800
Message-ID: <fb523153-5185-4ec3-941c-3abf1a6eeac8@zhaoxin.com>
Date: Mon, 7 Apr 2025 10:19:31 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86:Cancel hrtimer in the process of saving PIT
 state to reduce the performance overhead caused by hrtimer during guest stop.
To: Sean Christopherson <seanjc@google.com>
X-ASG-Orig-Subj: Re: [PATCH] KVM: x86:Cancel hrtimer in the process of saving PIT
 state to reduce the performance overhead caused by hrtimer during guest stop.
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
	<pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <hpa@zytor.com>,
	<LiamNi@zhaoxin.com>, <CobeChen@zhaoxin.com>, <LouisQi@zhaoxin.com>,
	<EwanHai@zhaoxin.com>, <FrankZhu@zhaoxin.com>
References: <20250317091917.72477-1-liamni-oc@zhaoxin.com>
 <Z9gl5dbTfZsUCJy-@google.com>
 <676ed22f-9c3f-4013-99d8-37c4c73bb9ac@zhaoxin.com>
 <Z-_xNpgsYDW0_4Jn@google.com>
From: LiamNioc <LiamNi-oc@zhaoxin.com>
In-Reply-To: <Z-_xNpgsYDW0_4Jn@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 ZXBJMBX02.zhaoxin.com (10.29.252.6)
X-Moderation-Data: 4/7/2025 3:38:08 PM
X-Barracuda-Connect: ZXSHMBX1.zhaoxin.com[10.28.252.163]
X-Barracuda-Start-Time: 1744011490
X-Barracuda-Encrypted: ECDHE-RSA-AES128-GCM-SHA256
X-Barracuda-URL: https://10.28.252.35:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2798
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.139610
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------



On 2025/4/4 22:48, Sean Christopherson wrote:
>=20
>=20
> [=E8=BF=99=E5=B0=81=E9=82=AE=E4=BB=B6=E6=9D=A5=E8=87=AA=E5=A4=96=E9=83=A8=
=E5=8F=91=E4=BB=B6=E4=BA=BA =E8=B0=A8=E9=98=B2=E9=A3=8E=E9=99=A9]
>=20
> On Tue, Mar 25, 2025, LiamNioc wrote:
>> On 2025/3/17 21:38, Sean Christopherson wrote:
>>> On Mon, Mar 17, 2025, Liam Ni wrote:
>>>> When using the dump-guest-memory command in QEMU to dump
>>>> the virtual machine's memory,the virtual machine will be
>>>> paused for a period of time.If the guest (i.e., UEFI) uses
>>>> the PIT as the system clock,it will be observed that the
>>>> HRTIMER used by the PIT continues to run during the guest
>>>> stop process, imposing an additional burden on the system.
>>>> Moreover, during the guest restart process,the previously
>>>> established HRTIMER will be canceled,and the accumulated
>>>> timer events will be flushed.However, before the old
>>>> HRTIMER is canceled,the accumulated timer events
>>>> will "surreptitiously" inject interrupts into the guest.
>>>>
>>>> SO during the process of saving the KVM PIT state,
>>>> the HRTIMER need to be canceled to reduce the performance overhead
>>>> caused by HRTIMER during the guest stop process.
>>>>
>>>> i.e. if guest
>>>>
>>>> Signed-off-by: Liam Ni <liamni-oc@zhaoxin.com>
>>>> ---
>>>>    arch/x86/kvm/x86.c | 4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index 045c61cc7e54..75355b315aca 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -6405,6 +6405,8 @@ static int kvm_vm_ioctl_get_pit(struct kvm *kvm,=
 struct kvm_pit_state *ps)
>>>>
>>>>         mutex_lock(&kps->lock);
>>>>         memcpy(ps, &kps->channels, sizeof(*ps));
>>>> +     hrtimer_cancel(&kvm->arch.vpit->pit_state.timer);
>>>> +     kthread_flush_work(&kvm->arch.vpit->expired);
>>>
>>> KVM cannot assume userspace wants to stop the PIT when grabbing a snaps=
hot.  It's
>>> a significant ABI change, and not desirable in all cases.
>>
>> When VM Pause, all devices of the virtual machine are frozen, so the PIT
>> freeze only saves the PIT device status, but does not cancel HRTIMER, bu=
t
>> chooses to cancel HRTIMER when VM resumes and refresh the pending task.
>> According to my observation, before refreshing the pending task, these
>> pending tasks will secretly inject interrupts into the guest.
>>
>> So do we need to cancel the HRTIMER when VM pause=EF=BC=9F
>=20
> The problem is that KVM has no real concept of pausing a VM.  There are a=
 variety
> of hacky hooks here and there, but no KVM-wide notion of "pause".
>=20
> For this case, after getting PIT state, you should be able to use KVM_SET=
_PIT2 to
> set the mode of channel[0] to 0xff, which call destroy_pit_timer() via
> pit_load_count().

Got it.
so i need to modify the behavior of QEMU's code.





