Return-Path: <kvm+bounces-2422-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id ADDEA7F6E6F
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 09:40:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4E22BB2107E
	for <lists+kvm@lfdr.de>; Fri, 24 Nov 2023 08:40:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 896684436;
	Fri, 24 Nov 2023 08:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF7B091;
	Fri, 24 Nov 2023 00:40:07 -0800 (PST)
X-QQ-mid: bizesmtp75t1700815181tn312kbv
Received: from [127.0.0.1] ( [125.94.202.196])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 24 Nov 2023 16:39:39 +0800 (CST)
X-QQ-SSF: 01400000000000B0B000000A0000000
X-QQ-FEAT: 7YFKcddXagjsJLt4wZABMUUDAYXCRnXo8g21GUIbQbqARChcnMawpeCfxN5Fh
	FAL082/zTRzsvaYPmnb+ltvg7D100sX+qcklM2YJd+L8vMbcjpY9OqL2eOqhW1p8Cvdc6+S
	n3X0wLAhgXvnScdmZmMjoMswETTFn/mVftkuT6WEGmZxAeP176I2oNHLa56qSaBNY2zkPnV
	LG/ekKJr+W8uKDUe2TsrZtHezH3aWd6GKL0a1CrjhNx7iIrqc9e/TJPwUWvJ+S/sGB+QBnN
	+VOvetNSVcAibP8cry0np7W6aAPaNzNIzGK3LUZ0PIax9d30jQgBbSUxYORpDCQMzSpElHf
	oBn4V0aQ3rzyd4jviheIVNYpbQbGapXJhrdHfQNsxs4A+bcu9hddYlMiC3/u3vCkz4UNtbs
	2bdxPaOa/uyDJUbaeEZ7rw==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 14761653264302342047
Message-ID: <F19DC40ACB796694+78dfb71e-a2db-473d-a9fc-fa35c5e61a27@shingroup.cn>
Date: Fri, 24 Nov 2023 16:39:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] powerpc: Add PVN support for HeXin C2000 processor
To: Michael Ellerman <mpe@ellerman.id.au>, gregkh@linuxfoundation.org
References: <20231123093611.98313-1-ke.zhao@shingroup.cn>
 <2023112317-ebook-dreamless-0cfe@gregkh> <871qcgspf8.fsf@mail.lhotse>
Content-Language: en-US
Cc: npiggin@gmail.com, christophe.leroy@csgroup.eu, fbarrat@linux.ibm.com,
 ajd@linux.ibm.com, arnd@arndb.de, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, shenghui.qu@shingroup.cn,
 luming.yu@shingroup.cn, dawei.li@shingroup.cn
From: =?UTF-8?B?WmhhbyBLZSDotbUg5Y+v?= <ke.zhao@shingroup.cn>
In-Reply-To: <871qcgspf8.fsf@mail.lhotse>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:shingroup.cn:qybglogicsvrsz:qybglogicsvrsz3a-0

Hi Michael and Greg,

On 2023/11/23 19:02, Michael Ellerman wrote:
> Greg KH <gregkh@linuxfoundation.org> writes:
>> On Thu, Nov 23, 2023 at 05:36:11PM +0800, Zhao Ke wrote:
>>> HeXin Tech Co. has applied for a new PVN from the OpenPower Community
>>> for its new processor C2000. The OpenPower has assigned a new PVN
>>> and this newly assigned PVN is 0x0066, add pvr register related
>>> support for this PVN.
>>>
>>> Signed-off-by: Zhao Ke <ke.zhao@shingroup.cn>
>>> Link: https://discuss.openpower.foundation/t/how-to-get-a-new-pvr-for-processors-follow-power-isa/477/10
>>> ---
>>> 	v0 -> v1:
>>> 	- Fix .cpu_name with the correct description
>>> ---
>>> ---
>>>   arch/powerpc/include/asm/reg.h            |  1 +
>>>   arch/powerpc/kernel/cpu_specs_book3s_64.h | 15 +++++++++++++++
>>>   arch/powerpc/kvm/book3s_pr.c              |  1 +
>>>   arch/powerpc/mm/book3s64/pkeys.c          |  3 ++-
>>>   arch/powerpc/platforms/powernv/subcore.c  |  3 ++-
>>>   drivers/misc/cxl/cxl.h                    |  3 ++-
>>>   6 files changed, 23 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
>>> index 4ae4ab9090a2..7fd09f25452d 100644
>>> --- a/arch/powerpc/include/asm/reg.h
>>> +++ b/arch/powerpc/include/asm/reg.h
>>> @@ -1361,6 +1361,7 @@
>>>   #define PVR_POWER8E	0x004B
>>>   #define PVR_POWER8NVL	0x004C
>>>   #define PVR_POWER8	0x004D
>>> +#define PVR_HX_C2000	0x0066
>>>   #define PVR_POWER9	0x004E
>>>   #define PVR_POWER10	0x0080
>>>   #define PVR_BE		0x0070
>> Why is this not in sorted order?
> It's semantically sorted :D
> ie. HX_C2000 is most similar to POWER8, but is newer than it.
Yes. This is what I mean. If you prefer to sort in another order, please 
tell me and I will update this.
>
> PVR_BE is out of place, I'll fix that.
>
> cheers
>


