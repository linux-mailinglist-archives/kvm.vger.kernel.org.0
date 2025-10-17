Return-Path: <kvm+bounces-60360-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FAB8BEB641
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 21:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 737584E6110
	for <lists+kvm@lfdr.de>; Fri, 17 Oct 2025 19:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89215310762;
	Fri, 17 Oct 2025 19:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L6/AZYt4"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55B92FC01B
	for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 19:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760729683; cv=none; b=q8q968OK0d6IISPRDqmPmj+b0SlmmVk5sGo+bev1qv2dVul/3bKe3XWRZ+wiIVF8ADMicDtxR5n7IE8hTGtywmd/QljQsgBnc3G/Sh0is+Xvbukb+w9jNtXFpoJcyZWXaHUthTzdthtbAuouf0NOXoqQNCfZD4R+Jj7Ax/4ENaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760729683; c=relaxed/simple;
	bh=mRdqTkYMdVm8XfRraSwu080msXDR2HkJyRm1J/nM9Ak=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=NlU8S3weN2CfyviKUqO0TTU55KhcYQzN490wnsfuo+nJliBE4bp+uAFgkslI9mGUwg9g7DwFbMtDZf0IsB4eWQ/66UlhXgIh0as9BRzwWAqcCyk+MgzE6CC1AwcyHjGtFRNrOA9p802oX+NWsmYEdZsy+h/3M6R1PukXNLrxUjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L6/AZYt4; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4270491e9easo1141342f8f.2
        for <kvm@vger.kernel.org>; Fri, 17 Oct 2025 12:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760729680; x=1761334480; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qMJV026dRbiXNw2a4Oxt82ibZLr50tUzegy5c9LVdz4=;
        b=L6/AZYt4MXzhl1J4BEHn3r332m7Wpb8noeCgRVogzZeVbHSZZTTRGblno7Oro9Fyry
         lMfcWYg/DRIEHarscVH41x+4B3WT4XlIbcGEPrQtZsh0C02W1sTznHUlhYrss7vLJ63+
         H97r+YJQt/R1/8u0V3LdvUYVkMuwOWavgzC1PE+jv2EVCp49oSHEvc07RdaH2PHKzs7R
         YymvcM+IcqQUrflXNGieMLMese5oSAhSsT5TE2sx454kCAXuotDF5kJZ/3NLx1IeVloS
         t7Gd78RjyTxDAOlv1cN45eRkn5rKtCg00qoaDDLE+fcHdoEVdzwiZQVJuYMOanA+GpPd
         iaOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760729680; x=1761334480;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qMJV026dRbiXNw2a4Oxt82ibZLr50tUzegy5c9LVdz4=;
        b=Jq1E2OLFgoM32icTuonEqajV5IdtfCnaSnmJIbFpHfzVALCV5LiYbRog4ivVcKGtTf
         /Cc/eun01q8FbEGalhgNMld8Dh9g9qnFonw6ex1pZpt6iniPRp1P/0e8r4n/pEXKMc+D
         ILLPFUb9ti0Sq3eu0Kf9aKrEJCxazz0zUwbHmFwislQWHdW7tc9aR+0lnPm3kwdH3KZf
         EiHwlvT3rTPl8t26tjd9XW5Xzz1zhTYvaqvx8ZVzSoK73bMxlQFyIVwK3ujnDtxCaIx5
         a/tFaWEeitA3Eh45Druo8mZOQao0294riXBbsUrpIkSYn5rAT2W+8xup0o/sDmZzi1rD
         ixQA==
X-Forwarded-Encrypted: i=1; AJvYcCUQVckzDaPwwEpUhgosY+TD7zRxP1Tf1GjU2Kn+LMLJ0yswP970Ouk02Pb1t/St8A5SwAs=@vger.kernel.org
X-Gm-Message-State: AOJu0YzRaKOhyg01eCDTeSRZDZt435MqRnF8D+7MKaQ4ia2oghuUnv7d
	pSG/bNi4ewR4NH4hbKJTRt0F5x4msUHvii5/ZNMNPS0boCKZfXmvqy/M
X-Gm-Gg: ASbGncvShduwrbzw+EIbAMt28dQxH8gsQSGuvfDTvQWnSV0e8ee9RWlmdJ3xXsbqusw
	STNd+hbMkmzPyMwtTQ8j5gUjEn7JcsDQjiZLiE/87aE8DGPwMxaNC4YrUruugwS8j4YZQkCrD5l
	pqzjJWCOO7JqYx3eeD4WhmboSPP40TYohWR+gmjhgR79LQLIwGiPY/d9NYwzDIwWrH8rro5UPfG
	l2Mip2RguMxJFsR64VYt4CvtKTs144escOsPBZBwf2JpkxXENTdjXj7ugj2M7C8g3DZte3JoYve
	YXfHxuJLcSIO9C4IJilI5k2JtglcB96kJewLzhLuuXrHkukqdJvO28jzsDVSk9zA5fZaYn+cfsu
	xZIkVOWSj9+cF7w50GUGyUB5GYInm8aTDODP7mDmuS9f3Z7mmpwOcDagQtQu78YkHFm7s3o8RF9
	/+jONYLNlDUxleEpiwlRLgjdzyi0vOPOat7MxmReNtfEKhSL69wDSSvSDzI2EV/6eqmPU5xujIz
	34hrKif4jQ=
X-Google-Smtp-Source: AGHT+IHGjetnftVuysT/GTbROlmqCuOV4BZY3KYmTrCujddx2P4/UmIBc6Wo1oHWDywfaY714OaLRA==
X-Received: by 2002:a05:6000:2887:b0:427:9a9:4604 with SMTP id ffacd0b85a97d-42709a9465fmr1647206f8f.45.1760729679739;
        Fri, 17 Oct 2025 12:34:39 -0700 (PDT)
Received: from ehlo.thunderbird.net (p200300faaf271400485132244674f203.dip0.t-ipconnect.de. [2003:fa:af27:1400:4851:3224:4674:f203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711442d3ddsm95764585e9.5.2025.10.17.12.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 12:34:39 -0700 (PDT)
Date: Fri, 17 Oct 2025 19:34:36 +0000
From: Bernhard Beschow <shentey@gmail.com>
To: Michael Tokarev <mjt@tls.msk.ru>, qemu-devel@nongnu.org
CC: Roman Bolshakov <rbolshakov@ddn.com>, Laurent Vivier <laurent@vivier.eu>,
 Eduardo Habkost <eduardo@habkost.net>, Cameron Esfahani <dirty@apple.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Sunil Muthuswamy <sunilmut@microsoft.com>, Zhao Liu <zhao1.liu@intel.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Fabiano Rosas <farosas@suse.de>, qemu-trivial@nongnu.org,
 Gerd Hoffmann <kraxel@redhat.com>, qemu-block@nongnu.org,
 Phil Dennis-Jordan <phil@philjordan.eu>, John Snow <jsnow@redhat.com>,
 kvm@vger.kernel.org, Laurent Vivier <lvivier@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_v2_09/11=5D_hw/intc/apic=3A_Ensure_?=
 =?US-ASCII?Q?own_APIC_use_in_apic=5Fregister=5F=7Bread=2C_write=7D?=
In-Reply-To: <f074aed2-7702-4a4a-a7d5-7abeb29ea663@tls.msk.ru>
References: <20251017141117.105944-1-shentey@gmail.com> <20251017141117.105944-10-shentey@gmail.com> <f074aed2-7702-4a4a-a7d5-7abeb29ea663@tls.msk.ru>
Message-ID: <3C9DA9B8-8836-42F6-85CD-AB60327363EC@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable



Am 17=2E Oktober 2025 14:58:50 UTC schrieb Michael Tokarev <mjt@tls=2Emsk=
=2Eru>:
>17=2E10=2E2025 17:11, Bernhard Beschow wrote:
>> =2E=2E=2E In apic_mem_{read,write}, the
>> own APIC instance is available as the opaque parameter
>
>> diff --git a/hw/intc/apic=2Ec b/hw/intc/apic=2Ec
>
>> @@ -876,7 +870,7 @@ static uint64_t apic_mem_read(void *opaque, hwaddr =
addr, unsigned size)
>>       }
>>         index =3D (addr >> 4) & 0xff;
>> -    apic_register_read(index, &val);
>> +    apic_register_read(opaque, index, &val);
>
>I think it would be better to use local variable here:
>
> APICCommonState *s =3D opaque;
>
>and use it down the line=2E  Yes, there's just one usage, but it is
>still clearer this way (in my opinion anyway)=2E
>
>Ditto in apic_mem_write=2E

I agree=2E Will fix in the next iteration=2E

Best regards,
Bernhard

>
>But it's more a nitpick really=2E
>
>Thanks,
>
>/mjt

