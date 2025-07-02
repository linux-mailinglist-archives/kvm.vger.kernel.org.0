Return-Path: <kvm+bounces-51236-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DF26CAF075C
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 02:44:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D0D917E813
	for <lists+kvm@lfdr.de>; Wed,  2 Jul 2025 00:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA17312B73;
	Wed,  2 Jul 2025 00:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JWlQHYhm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6D34A2D
	for <kvm@vger.kernel.org>; Wed,  2 Jul 2025 00:44:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751417068; cv=none; b=nAG5kci/InM3bUjSc2RPJ8sMEXp/jvZReCLRmT190n+u67TYVmXlfYJyihWpsrolO/j39sGDij+DCBwFtvNH+I77BwK45BuhKZhsgP+qu1Z500QlPl7qEUnK7SUjh8t982ZOwkxAqkII//+2v78XkWN7AnquL/KLSoAty0/PLrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751417068; c=relaxed/simple;
	bh=GMM9Xc4S93NZsBFQxZ/Narp+exl6rKh0KT3abCEuCg4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X58M5iZLFNGm/LsXA2G08bQr2PBjF7UTA/on/HxMjspQU1Jfy+4OqLHIaL8stcLQkU61bNM1a4TdDKJjdq4Er1FpAe8C6Ft5mgHki4BC0ir+HJetObgqJHsBkSv0s7JymO9fD58IzLME/7YnjFVT7ujsU9MpApTBXG6NtWNH+Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JWlQHYhm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751417065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WE68W0bXQaTpxl/iIASF1f+Xh1LT+vGRhkdJSNq736g=;
	b=JWlQHYhmNIADWjwlmqrAXB3rlavuGQXzFuKTfEESbej8eaf/PQlt31vC5i2c8BH2zf+jJ7
	FiB8AQ/SDh1NAr5pHDd3OGukYbvi8+OgKeAo9I0zcTNwA2dEVUnZNwnFk5sfv1t1Y0zNmb
	BhObrJQ34prpbogWUzTUyBXlAZeIfNc=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-pQp8qwrSOd262KDWcQGG1g-1; Tue, 01 Jul 2025 20:44:23 -0400
X-MC-Unique: pQp8qwrSOd262KDWcQGG1g-1
X-Mimecast-MFC-AGG-ID: pQp8qwrSOd262KDWcQGG1g_1751417062
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-235eefe6a8fso45382475ad.1
        for <kvm@vger.kernel.org>; Tue, 01 Jul 2025 17:44:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751417062; x=1752021862;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WE68W0bXQaTpxl/iIASF1f+Xh1LT+vGRhkdJSNq736g=;
        b=bkTYeMXb6+YfriJ522X48YemONiKV0z4U+zEv3Ou5/1ZMD37E5hhVA28ppRE8+6BzS
         enNm1wvoqrQuVKj66zY1svwjvhIfZADN8zVGutdE6HaLRtDT1tNPFaILyCRTQW4QvRRc
         lcWvV2UZQub6unK4kpl0HsOTCBl1fZFWOGUgk4Yh2ORMDv3ke1gE+oRqN+srPpm8G/tB
         VGd3uXsWzrPEWo9pdCeZV+k8QMMSlKWgYwynXXs1XLShMroz71apN5YAsTkhw89mz+YE
         zOZEM+T/x3JtoXsBUCIGy6b+AcLUvoOK5h1xh2ghGH7AO5zI6hM1rIdm39N5ATsVRcaY
         vuqg==
X-Forwarded-Encrypted: i=1; AJvYcCXqWcOn16RYr8u7f9TjqiJNAmB56WeKnrAnxS2bHmSBm8o+2FlD/ALEtXbMbnFASbutYj8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxK/qZMesK9MtK1gXx/9pigW/ZW0/lIEizqypTL3Xq2vLKow4cD
	ZY+wi1eH7U+9bFco3nYRq3wk96Kgd3ebDeS0OcSB4BPQ0Xxiaz8/Lnaod475M+JmXOzMen9kygZ
	DeENIVJ/NkAh08/mGFIKQpwhbIBi0NQ1XMG9ONGiNGoDGauzlM29SDA==
X-Gm-Gg: ASbGncsIN7aXcw4TI/cIGunpdawuVsx+jaPkp/dPFFNL3RylhrK7zkVX3oaV+T1iTsU
	WgD+jHUm7NY+P67Ds53nc8bV38N+cnNUKKRlWLrVPVoWYVMSJ1u28Yp0LxO+2elbBOE8BAElRZG
	AcDnbCYQxRaja3PAKdJ6R22DS6g/BU5J+g4G7UJoVG/14GgyQi/M1BHn+6GuYx3V6BPZGRISimD
	8iULEjzJcZY+LapUIuBhkX5JjxxdWqNEXag9zrcVDJrnseXyUZMEY58ZZDw0XloC2cTVdlpVw3J
	8WtMqs3Oua7gZBcwn2azb1ZDFm7XyqQ4EzW5d3iK/GTDutD0LADG7QGmHK2lOQ==
X-Received: by 2002:a17:902:f644:b0:234:ef42:5d75 with SMTP id d9443c01a7336-23c6e583731mr8506625ad.20.1751417062335;
        Tue, 01 Jul 2025 17:44:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG8Xe02tQUQpMvQ7JmZ6r+aJbfGWHLqnMc6SvZ+9EXS76Rb9Lau8L3Ze+pH8UDez4MEnO2doA==
X-Received: by 2002:a17:902:f644:b0:234:ef42:5d75 with SMTP id d9443c01a7336-23c6e583731mr8506155ad.20.1751417061963;
        Tue, 01 Jul 2025 17:44:21 -0700 (PDT)
Received: from [192.168.68.51] (n175-34-62-5.mrk21.qld.optusnet.com.au. [175.34.62.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3b871csm114358215ad.187.2025.07.01.17.44.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jul 2025 17:44:21 -0700 (PDT)
Message-ID: <5eef96b4-2a33-4d52-a68a-323709beee5b@redhat.com>
Date: Wed, 2 Jul 2025 10:44:12 +1000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 17/43] arm64: RME: Handle RMI_EXIT_RIPAS_CHANGE
To: Steven Price <steven.price@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Emi Kisanuki <fj0570is@fujitsu.com>
References: <20250611104844.245235-1-steven.price@arm.com>
 <20250611104844.245235-18-steven.price@arm.com>
Content-Language: en-US
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20250611104844.245235-18-steven.price@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/11/25 8:48 PM, Steven Price wrote:
> The guest can request that a region of it's protected address space is
> switched between RIPAS_RAM and RIPAS_EMPTY (and back) using
> RSI_IPA_STATE_SET. This causes a guest exit with the
> RMI_EXIT_RIPAS_CHANGE code. We treat this as a request to convert a
> protected region to unprotected (or back), exiting to the VMM to make
> the necessary changes to the guest_memfd and memslot mappings. On the
> next entry the RIPAS changes are committed by making RMI_RTT_SET_RIPAS
> calls.
> 
> The VMM may wish to reject the RIPAS change requested by the guest. For
> now it can only do with by no longer scheduling the VCPU as we don't
> currently have a usecase for returning that rejection to the guest, but
> by postponing the RMI_RTT_SET_RIPAS changes to entry we leave the door
> open for adding a new ioctl in the future for this purpose.
> 
> Signed-off-by: Steven Price <steven.price@arm.com>
> ---
> Changes since v8:
>   * Make use of ripas_change() from a previous patch to implement
>     realm_set_ipa_state().
>   * Update exit.ripas_base after a RIPAS change so that, if instead of
>     entering the guest we exit to user space, we don't attempt to repeat
>     the RIPAS change (triggering an error from the RMM).
> Changes since v7:
>   * Rework the loop in realm_set_ipa_state() to make it clear when the
>     'next' output value of rmi_rtt_set_ripas() is used.
> New patch for v7: The code was previously split awkwardly between two
> other patches.
> ---
>   arch/arm64/kvm/rme.c | 46 ++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 46 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>


