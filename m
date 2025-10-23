Return-Path: <kvm+bounces-60897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 27709C02AC7
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 19:11:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CD86E4FA18E
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 17:04:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02D74342CBC;
	Thu, 23 Oct 2025 17:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dzf0QyiE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB38D303A2A
	for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 17:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761238989; cv=none; b=TEXMPEwemkjFHszORNDA2KYvpYKA/nfoUTrzAXXE2E3qDEJ6ANSOBqy79wb4S+H2gWUJVDWgVcjvlVr4TBUsedmRuClW9LZKe5bUlOEoE1L/Y1BucgSvI7x0Z5XEmnBwMV6dXcSgvKZgOZqXDczgQNmkQlTsqiwAeHJ4KEvh/Ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761238989; c=relaxed/simple;
	bh=uGlyZr2Hhfcphm3qOptTGIL4smMWr1vVuG3WsGrG1oQ=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=lTkxbmU/NiK6i+JC2fnbB07kpUadX4q1/WDhSeF+FtIufSpJPUH0nyaty/SEXyBpUY9QfdaEhEBmLOWP6Bo6qd+byUogZdztG/RxczRJGyW16/9szx2j+qvNNqql77aNotPfg0MgzzmLUWIZRT8Kj5oqLLnPiSz8WboWyDR5TXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dzf0QyiE; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b6d5e04e0d3so103591366b.2
        for <kvm@vger.kernel.org>; Thu, 23 Oct 2025 10:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761238983; x=1761843783; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lRFOS9vWQLsIf7YSp0CpPuUhihCN5JPDMh7Wa4ZB3VY=;
        b=Dzf0QyiElhKoU4jo8NuM0yH6lRDlPzJ1KCGeOLxi02X4UfeknYa4rJTZl1gfamkEYD
         SAwabO/KvjWf6UxvgQOzsRp/Ppen8ImZwjy6aPZLUv5KdSPDawzFDBgF1mFFGqEgr8ZJ
         0ruae15bJPM4HLfaIh8vKYM0i26Wim9vLiltG9z1wjfFoa4klZWTLCGL/5MFNIHL6mAu
         k1UzOMY3bIO/xBgWFEb+e9H11S5Qdn63YnIVwhmmQdS1Bptcu1IPeJbkpJmvghnzhwBZ
         D/8bFpCMwifvBTGVZ3NVne8GXukyfqODsTrSTLJyVJDZY87Q8UR28xK+yDmunzZ7NfBZ
         rGjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761238983; x=1761843783;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lRFOS9vWQLsIf7YSp0CpPuUhihCN5JPDMh7Wa4ZB3VY=;
        b=q75U3JP8uOY3+1U5tcBTb5HzXi9pRaIysa3Y7hGoz8mqGkVzGJaxfOUA+v8CjqgoY4
         dKhtJnMDkwem8VAjGI1KxPGoFaUYsyPoXrgI2TEZ+uYsQEgbDZQDfFLBiqHu96LqZFLN
         VJhrGZbkLO6HP14b0GefUQpyVTiFTMylmbRrZVN1mgXdiit7LyM0vaBVbrXlAQuVGG1d
         d888vLGiQnupI83V/MjZ1qEhyyWY/cFJb13la3UbxcU7rPZADetHL97abjHL2qs2zsxL
         u0jCXvs581SWp+ZKVhpNlPUWtUJOJ0IULnQA8xWFDXG85D3NYLt5ew67TVSpYMJStB0Y
         56xw==
X-Forwarded-Encrypted: i=1; AJvYcCVXA4womPysRXV7brcb98I2DyYlRLidnpySajmteBmd2s3ZM7t/TOSemcUGV7ErEphHlTA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxw1CivD8vWOcw/+WVg2bdLNbjE8xljr1lXdzLUZJRszWat+ncE
	JaE1KmtDX3tr5SZnbqNHQg+MT2TvkuR2RZ4y6aUsO5AjexesYZbdyn+J
X-Gm-Gg: ASbGncs/TU/ql8uDZcrnUr7TD8iUAwhBFOlzyROxzvBhd67+v0vIOtJY4DtihuLDdkY
	PsFstxs30a1S8FCFjD5cmb86/NqKTKiFnZTwiJaua/wcSI09ONWt8xEkRvamtHwDbHeDPqqg/FV
	xIBZHo3RyZayAone7UtR4cyO0Yx4O4pAyOV7Xi9IivuW4UE0IBeyYzGVxYDmDmpc83r8R4Q7GZe
	Q0XJ3ZkC2YmLX5elFNAlD1s2rGx9/5v1zOBq5TfOtuux8JN7YQtw2OzTT9qxPQBE5qIFmeDPxID
	GFmLJJQCROxkd/daJv+ti2YZ+YbqqRjyvDADw2Mjw0x2E8IrLimkVDi5eRom2SG+sJ0M3aW/5Jy
	99Ok08gFh+ChahLJbYzBn9GCP7XfpqVYsJE5BdZVPPQAWw06kIAv5CVBkyYc5tHZmlnHVIJlNBh
	BEeBEG5pplAXkQ4Uqj48I2wp6Uuexa74j/jNUKeeHeVm4=
X-Google-Smtp-Source: AGHT+IFoCA0ZxzVDg1+ILaAZKVQzRMksVjUmfnL1RLSWuIAUgydiwvg/IRa3z+n8QNHpG8feaoY6fg==
X-Received: by 2002:a17:907:d93:b0:b32:2b60:f13 with SMTP id a640c23a62f3a-b6473f42d62mr3091022766b.54.1761238982590;
        Thu, 23 Oct 2025 10:03:02 -0700 (PDT)
Received: from ehlo.thunderbird.net (ip-109-41-114-163.web.vodafone.de. [109.41.114.163])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b6d511d012bsm311143066b.7.2025.10.23.10.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Oct 2025 10:02:59 -0700 (PDT)
Date: Thu, 23 Oct 2025 17:02:56 +0000
From: Bernhard Beschow <shentey@gmail.com>
To: =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org, Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 Mohamed Mediouni <mohamed@unpredictable.fr>
CC: Alexander Graf <agraf@csgraf.de>,
 Richard Henderson <richard.henderson@linaro.org>,
 Cameron Esfahani <dirty@apple.com>, Mads Ynddal <mads@ynddal.dk>,
 qemu-arm@nongnu.org, Ani Sinha <anisinha@redhat.com>,
 Phil Dennis-Jordan <phil@philjordan.eu>,
 Eduardo Habkost <eduardo@habkost.net>,
 Sunil Muthuswamy <sunilmut@microsoft.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Igor Mammedov <imammedo@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Yanan Wang <wangyanan55@huawei.com>,
 =?ISO-8859-1?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>,
 Shannon Zhao <shannon.zhaosl@gmail.com>, kvm@vger.kernel.org,
 Peter Maydell <peter.maydell@linaro.org>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 =?ISO-8859-1?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>,
 Pedro Barbuda <pbarbuda@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Roman Bolshakov <rbolshakov@ddn.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v7_24/24=5D_whpx=3A_apic=3A_use_non-deprec?=
 =?US-ASCII?Q?ated_APIs_to_control_interrupt_controller_state?=
In-Reply-To: <0C41CA0E-C523-4C00-AD07-71F6A7890C0E@gmail.com>
References: <20251016165520.62532-1-mohamed@unpredictable.fr> <20251016165520.62532-25-mohamed@unpredictable.fr> <2cbd9feb-2c20-46e0-af40-0bd64060dfba@linaro.org> <6982BC4E-1F59-47AD-B6E6-9FFF4212C627@gmail.com> <60cd413d-d901-4da7-acb6-c9d47a198c9c@linaro.org> <0C41CA0E-C523-4C00-AD07-71F6A7890C0E@gmail.com>
Message-ID: <4F98A2AD-02A7-4A7F-91B8-269E9EC8E5B1@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



Am 23=2E Oktober 2025 09:23:58 UTC schrieb Bernhard Beschow <shentey@gmail=
=2Ecom>:
>
>
>Am 23=2E Oktober 2025 06:33:18 UTC schrieb "Philippe Mathieu-Daud=C3=A9" =
<philmd@linaro=2Eorg>:
>>On 20/10/25 12:27, Bernhard Beschow wrote:
>>>=20
>>>=20
>>> Am 16=2E Oktober 2025 17:15:42 UTC schrieb Pierrick Bouvier <pierrick=
=2Ebouvier@linaro=2Eorg>:
>>>> On 10/16/25 9:55 AM, Mohamed Mediouni wrote:
>>>>> WHvGetVirtualProcessorInterruptControllerState2 and
>>>>> WHvSetVirtualProcessorInterruptControllerState2 are
>>>>> deprecated since Windows 10 version 2004=2E
>>>>>=20
>>>>> Use the non-deprecated WHvGetVirtualProcessorState and
>>>>> WHvSetVirtualProcessorState when available=2E
>>>>>=20
>>>>> Signed-off-by: Mohamed Mediouni <mohamed@unpredictable=2Efr>
>>>>> ---
>>>>>    include/system/whpx-internal=2Eh |  9 +++++++
>>>>>    target/i386/whpx/whpx-apic=2Ec   | 46 +++++++++++++++++++++++++--=
-------
>>>>>    2 files changed, 43 insertions(+), 12 deletions(-)
>>>>=20
>>>> Reviewed-by: Pierrick Bouvier <pierrick=2Ebouvier@linaro=2Eorg>
>>>=20
>>> Couldn't we merge this patch already until the rest of the series is f=
igured out?
>>
>>OK if you provide your Tested-by tag (:
>
>Oh, I did for an older version of the series w/o this patch: <https://lor=
e=2Ekernel=2Eorg/qemu-devel/5758AEBA-9E33-4DCA-9B08-0AF91FD03B0E@gmail=2Eco=
m/>
>
>I'll retest=2E

Unfortunately I get:

WHvSetVirtualProcessorInterruptControllerState failed: c0350005

and the VM terminates=2E Reverting the patch resolves the problem=2E

Best regards,
Bernhard

