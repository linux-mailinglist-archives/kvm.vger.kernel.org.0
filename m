Return-Path: <kvm+bounces-2723-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DD9A67FCE43
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 06:29:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B78B1C2102D
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 05:29:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D2AF6FD5;
	Wed, 29 Nov 2023 05:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="VHRce5Yd"
X-Original-To: kvm@vger.kernel.org
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2503019A;
	Tue, 28 Nov 2023 21:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1701235743;
	bh=GFT7EAkVpEquWEJU6kXdzQ2WWWjUfAfDnDgiMdjjeQ0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=VHRce5Yd2nHOqIegCPxwoQ5yPwiG4xdQX1p7X5l43N9KxbNOnaesBwvs5SIN2D5Qq
	 xUQm1SRPSqpEKXwQ1WyogPbdNZ4UWX4A4I+b5Kdqf8TLgAvS3Fx3xf5lKvFq3cvMay
	 kXHv1FaMOnSv8RmXb/GbQVMrKhqsZx/RkMUmRZViv7K/gEco/cWA4lldpyaD5U0ZoV
	 X4yk3Z1cMsmGYULy42scb/DriRqDNhgG6ef5ZzChaQ1BT4iv1zHmxA+oGSDVAIsVEC
	 Nrn307lKTkGIDfzwG1L/SSPPzJAtFD3x1Qt1XOm13iFsJ20rxHL0pg57rTC+/VEGzL
	 TMmRu80pHLdGw==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4Sg7Cx6LhMz4xQZ;
	Wed, 29 Nov 2023 16:29:01 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Zhao Ke =?utf-8?B?6LW1IOWPrw==?= <ke.zhao@shingroup.cn>,
 npiggin@gmail.com,
 christophe.leroy@csgroup.eu, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
 arnd@arndb.de, gregkh@linuxfoundation.org
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, shenghui.qu@shingroup.cn, luming.yu@shingroup.cn,
 dawei.li@shingroup.cn
Subject: Re: [PATCH] powerpc: Add PVN support for HeXin C2000 processor
In-Reply-To: <52743BC52E07B486+dcb66331-0993-462b-ac03-6de69a3e1fac@shingroup.cn>
References: <20231117075215.647-1-ke.zhao@shingroup.cn>
 <87sf4yk19w.fsf@mail.lhotse>
 <52743BC52E07B486+dcb66331-0993-462b-ac03-6de69a3e1fac@shingroup.cn>
Date: Wed, 29 Nov 2023 16:28:56 +1100
Message-ID: <878r6h2kmf.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Zhao Ke =E8=B5=B5 =E5=8F=AF <ke.zhao@shingroup.cn> writes:
> On 2023/11/22 9:46, Michael Ellerman wrote:
>> Zhao Ke <ke.zhao@shingroup.cn> writes:
>>> HeXin Tech Co. has applied for a new PVN from the OpenPower Community
>>> for its new processor C2000. The OpenPower has assigned a new PVN
>>> and this newly assigned PVN is 0x0066, add pvr register related
>>> support for this PVN.
>>>
>>> Signed-off-by: Zhao Ke <ke.zhao@shingroup.cn>
>>> Link: https://discuss.openpower.foundation/t/how-to-get-a-new-pvr-for-p=
rocessors-follow-power-isa/477/10
>>=20=20=20
>> Hi Zhao Ke,
>>
>> Thanks for the patch. Just a few questions.
>>
>> Are you able to provide any further detail on the processor?
>>
>> Your cputable entry claims that it's identical to the original Power8
>> core, can you comment at all on how true that is in practice?
>
> Basically, we made lots of design change for the new processor.
>
> For example:
>
>  =C2=A0=C2=A0=C2=A0 1. redesign the interconnect of the fabric, from cros=
sbar to mesh
>
>  =C2=A0=C2=A0=C2=A0 2. redesign the memory subsystem, including the modif=
ication of L2=20
> and L3 architecture
>
>  =C2=A0=C2=A0=C2=A0 3. redesign the SMP bus
>
>  =C2=A0=C2=A0=C2=A0 4. upgrade PCIe to gen5 and increase the number of la=
nes
>
>  =C2=A0=C2=A0=C2=A0 5. upgrade ddr to DDR5, dimm direct connected, and th=
e number of=20
> channels
>
>  =C2=A0=C2=A0=C2=A0 6. redesign the pervasive architecture, including deb=
ug/trace,=20
> clock&power management, etc.

OK thanks for the detail.

Given all those changes I think you should not use "Power8" as the CPU
name. Whatever the lineage of the core design is, it's no longer a
literal "Power8", not even the same design using a different process
node.

So I think you should call it "HeXin C2000" or similar.

cheers

