Return-Path: <kvm+bounces-46181-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 885D4AB3B44
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 16:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D2323B15D5
	for <lists+kvm@lfdr.de>; Mon, 12 May 2025 14:47:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17CEE22C356;
	Mon, 12 May 2025 14:47:25 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C61822AE45
	for <kvm@vger.kernel.org>; Mon, 12 May 2025 14:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=152.66.115.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747061244; cv=none; b=hgaAVlrY8XbxkfGU+hAT+LnotGMnSMiDlzuznLYCPQihA9E31MgUaIqdWCmARwdAHGHDsKFxTVBckiqGtKeSi7AoJg0zefAvVt5alAAgs+3rM/hqHSK9eTq/c23helBHHeqglM7ZfsBP/ntiiiO+WkF4yoDkfj+iRDiZV4Zxmjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747061244; c=relaxed/simple;
	bh=ZZkH8XvmFmUK4WxBZmsZnVm4mP+x69PKN5vGewkrDFI=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=utUL5/2UTlr+3TJpNtE/7ZrMmcaX5aNRSSCXmcnbu9PTIs07xJ2Gnr49C9237P7zS4QLJ8Jt1AXG1g7tPrSH47OPmahx57Y+Qp0yqLa8MMu59YicYDie2Ou2dmfH9gYPHyO+RQ/LmrNs7aGtU2u2WqLK22bmywG+bLttinYn+W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu; spf=pass smtp.mailfrom=eik.bme.hu; arc=none smtp.client-ip=152.66.115.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=eik.bme.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=eik.bme.hu
Received: from zero.eik.bme.hu (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id 0683755BC03;
	Mon, 12 May 2025 16:41:03 +0200 (CEST)
X-Virus-Scanned: amavisd-new at eik.bme.hu
Received: from zero.eik.bme.hu ([127.0.0.1])
 by zero.eik.bme.hu (zero.eik.bme.hu [127.0.0.1]) (amavisd-new, port 10028)
 with ESMTP id Z7rQEdTdCDjh; Mon, 12 May 2025 16:41:00 +0200 (CEST)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
	id DEB0955BC02; Mon, 12 May 2025 16:41:00 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zero.eik.bme.hu (Postfix) with ESMTP id DB06B745682;
	Mon, 12 May 2025 16:41:00 +0200 (CEST)
Date: Mon, 12 May 2025 16:41:00 +0200 (CEST)
From: BALATON Zoltan <balaton@eik.bme.hu>
To: Xiaoyao Li <xiaoyao.li@intel.com>
cc: Markus Armbruster <armbru@redhat.com>, 
    =?ISO-8859-15?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>, 
    Peter Maydell <peter.maydell@linaro.org>, Thomas Huth <thuth@redhat.com>, 
    Zhao Liu <zhao1.liu@intel.com>, 
    =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>, 
    Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org, 
    Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org, 
    Gerd Hoffmann <kraxel@redhat.com>, Laurent Vivier <lvivier@redhat.com>, 
    Jiaxun Yang <jiaxun.yang@flygoat.com>, Yi Liu <yi.l.liu@intel.com>, 
    "Michael S. Tsirkin" <mst@redhat.com>, 
    Eduardo Habkost <eduardo@habkost.net>, 
    Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, 
    Alistair Francis <alistair.francis@wdc.com>, 
    Daniel Henrique Barboza <dbarboza@ventanamicro.com>, 
    Marcelo Tosatti <mtosatti@redhat.com>, qemu-riscv@nongnu.org, 
    Weiwei Li <liwei1518@gmail.com>, Amit Shah <amit@kernel.org>, 
    Yanan Wang <wangyanan55@huawei.com>, Helge Deller <deller@gmx.de>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Ani Sinha <anisinha@redhat.com>, 
    Igor Mammedov <imammedo@redhat.com>, Fabiano Rosas <farosas@suse.de>, 
    Liu Zhiwei <zhiwei_liu@linux.alibaba.com>, 
    =?ISO-8859-15?Q?Cl=E9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>, 
    qemu-arm@nongnu.org, 
    =?ISO-8859-15?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>, 
    Huacai Chen <chenhuacai@kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: How to mark internal properties
In-Reply-To: <e5a305cc-4c8b-48df-99fe-539ebd9b72f9@intel.com>
Message-ID: <f342557b-e589-f51d-cfd8-04f97e9c5efd@eik.bme.hu>
References: <20250508133550.81391-1-philmd@linaro.org> <20250508133550.81391-13-philmd@linaro.org> <23260c74-01ba-45bc-bf2f-b3e19c28ec8a@intel.com> <aB2vjuT07EuO6JSQ@intel.com> <2f526570-7ab0-479c-967c-b3f95f9f19e3@redhat.com>
 <CAFEAcA-kuHvxjuV_cMh-Px3C-k2Gd51jFqhwndO52vm++M_jAA@mail.gmail.com> <aCG6MuDLrQpoTqpg@redhat.com> <87jz6mqeu5.fsf@pond.sub.org> <e5a305cc-4c8b-48df-99fe-539ebd9b72f9@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3866299591-2120470484-1747060860=:11021"

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--3866299591-2120470484-1747060860=:11021
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Mon, 12 May 2025, Xiaoyao Li wrote:
> On 5/12/2025 6:54 PM, Markus Armbruster wrote:
>> Daniel P. Berrangé<berrange@redhat.com> writes:
>>> On Mon, May 12, 2025 at 09:46:30AM +0100, Peter Maydell wrote:
>>>> On Fri, 9 May 2025 at 11:04, Thomas Huth<thuth@redhat.com> wrote:
>>>>> Thanks for your clarifications, Zhao! But I think this shows again the
>>>>> problem that we have hit a couple of times in the past already: 
>>>>> Properties
>>>>> are currently used for both, config knobs for the users and internal
>>>>> switches for configuration of the machine. We lack a proper way to say 
>>>>> "this
>>>>> property is usable for the user" and "this property is meant for 
>>>>> internal
>>>>> configuration only".
>>>>> 
>>>>> I wonder whether we could maybe come up with a naming scheme to better
>>>>> distinguish the two sets, e.g. by using a prefix similar to the "x-" 
>>>>> prefix
>>>>> for experimental properties? We could e.g. say that all properties 
>>>>> starting
>>>>> with a "q-" are meant for QEMU-internal configuration only or something
>>>>> similar (and maybe even hide those from the default help output when 
>>>>> running
>>>>> "-device xyz,help" ?)? Anybody any opinions or better ideas on this?
>>>> I think a q-prefix is potentially a bit clunky unless we also have
>>>> infrastructure to say eg DEFINE_INTERNAL_PROP_BOOL("foo", ...)
>>>> and have it auto-add the prefix, and to have the C APIs for
>>>> setting properties search for both "foo" and "q-foo" so you
>>>> don't have to write qdev_prop_set_bit(dev, "q-foo", ...).
>
>> If we make intent explicit with DEFINE_INTERNAL_PROP_FOO(), is repeating
>> intent in the name useful?
>
> +1 for DEFINE_INTERNAL_PROP_FOO(). I have the same thought.
>
> We need something in code to restrict the *internal* property really 
> internal, i.e., not user settable. What the name of the property is doesn't 
> matter.

What's an internal property? Properties are there to make some field of an 
object introspectable and settable from command line and QEMU monitor or 
other external interfaces. If that's not needed for something why is it 
defined as a property in the first place and not just e.g. C accessor 
functions as part of the device's interface instead? I think this may be 
overusing QOM for things that may not need it and adding complexity where 
not needed. It reminds me of patches that wanted to export via-ide IRQs or 
ISA IRQs just to be able to connect them to other parts _of the same chip_ 
becuase this chip is modeled as multiple QOM objects for reusing code from 
those. But in reality the chip does not have such pins and these are 
internal connections so I think it would be better to model these as 
functions and not QOM constructs that the user can change. In general, if 
the device or object has an external connection or a knob that the user 
may need to change or connect to another device (like building a board 
from parts you can wire pins together) then those need properties or 
qemu_irqs but other "internal properties" may need some other way to 
access and often simple accessor functions are enough for this as these 
internal properties are only accessed form the code. That way we would not 
need even more complexity to hide these from the user, instead of that 
just don't expose them but use something else where a property is not 
needed. A property is just like an accessor function with additional 
complexity to expose it to other interfaces so it's externally settable 
and introspectable but we don't need those for internal properties so we 
can drop that complexity and get back to the accessor function at the 
bottom of it.

Regards,
BALATON Zoltan
--3866299591-2120470484-1747060860=:11021--

