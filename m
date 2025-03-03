Return-Path: <kvm+bounces-39868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28494A4BC00
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 11:25:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A40C53A5818
	for <lists+kvm@lfdr.de>; Mon,  3 Mar 2025 10:25:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DFAC1F0E50;
	Mon,  3 Mar 2025 10:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RIduwpy3"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7631D63F7
	for <kvm@vger.kernel.org>; Mon,  3 Mar 2025 10:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740997518; cv=none; b=H87OgzttaNYaHZ19ZH5GfDDQIz4n94CR7cKUp8ZHW2Szz8IZkAXeQp9ID/vH+yDpSaVRl6Xr7N9toFpdVb96MQ6zw9rWLz5PGTaqYlgBsgLHUHiS/ttMynPQHUkP0lwJrR3hO6KyzP3qxWzhQ7lyKVMhLB0fTFPDD9kaM6gToDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740997518; c=relaxed/simple;
	bh=/ej80E7fEmOiXCG0edfmWSRHo8xkFIG8fEhkazypN4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q226EbLhGNbQLoGiGQjaeyqh1j63CIPlPbia+jSOX+5DwD2FmZYwd13Qw3KV7bWUJzHQBXZnhZOf/5SpG8W0tTcC/fTUbBeQxdrnq9z38zQL8j125Xc5pQ1XE4TiMwxVERSz8rd50/1ZoTBGMQAJumHXBKfZU/1GWEFEPMbQHw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RIduwpy3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740997515;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TrKzv35DZjV35KvtzHUKUqHwEc+skHulVpKIiaH0xSg=;
	b=RIduwpy3Py/1A5LlT1E+WTHYK0B7ghJ4bL3W4qO/CZatDB5O7TfaIW6v8H6pbPii/nGuok
	wRWggTCSTxBMf/MxkHRWvoG/ll08T5QIyNFAtZg0tQ9Mf9Y2vY1tKfs+FTOJ8SfbtlTzZq
	bSggX1Es7TxxnFWKLV4v8MQwuOI5JMw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-645-L1F3LQcwNHSKX4bWSjhl-Q-1; Mon, 03 Mar 2025 05:25:12 -0500
X-MC-Unique: L1F3LQcwNHSKX4bWSjhl-Q-1
X-Mimecast-MFC-AGG-ID: L1F3LQcwNHSKX4bWSjhl-Q_1740997511
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-390e8df7ab6so1411644f8f.3
        for <kvm@vger.kernel.org>; Mon, 03 Mar 2025 02:25:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740997511; x=1741602311;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TrKzv35DZjV35KvtzHUKUqHwEc+skHulVpKIiaH0xSg=;
        b=ouDRhEbgbJ/ZRwg9f6nQh3qkBUWGszWsUetTZvMrGQVibHPcUV6hifFsYtXLlyV8ET
         rlOfxq+M3QYj+VSi4S2I/Wk/XVqgq+J75it9WQpVknZn82+VWOW185U13A4rFMzw9VL1
         4tjJoTysBYwr4ycF/XNEUS7K1Q9Gnm01OPfIczMmWWo98YySuT3Vki8R8eo2yYybMNE7
         R3iugIUqndQhuC38OsGYZoUG8lgsOjipDj8XaFIrmtkfxsV9R5hlQy2Vo6DXrdIWAnuL
         6OpNlWZ6/N0joLV+bVJxmmnRklS9noTBhDVr8+CRHTSyXbYt97riCpStRsTxXqCJZuug
         o9tA==
X-Forwarded-Encrypted: i=1; AJvYcCUehA6NEOmPysD3QonyyJGwcTE6sNN+iZGdMH1x38oA57CZtaoSAOdoi8UzqqNGDv/Ugx0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzdFNrGpUTAiD1FqG9j4Pc51jwh9lXlbFTnysLLYzZqoBVqeX1J
	4gGXdm9QFsUOkpbMCOCbNnaiHfxAMa5qxfmAOa+gCXw+URd0DhDRpJOZHbXk1ZfU6uVXCJod6ZC
	Vt+7115DRBwkmnlUIJxBkttzAjS9T5DGAE2X/d6gxh6cmvhrsWQ==
X-Gm-Gg: ASbGnctA+VM1Vqt0+/tZV9sve8adwUMEhCf1S3xkjcNxTbRIOHvosW1Ol47Nzz0lkTj
	Rk5ACGINbQ+oESxjSKmuuQkCI3yiEMJB7c9cxNAKQk4UcCg64jtzW/jjdKRk5yAPvLQCofqKcAG
	GWpLhtXRpKc0mbdOXnS90tT/4rQGeWfqL7VplMZ5ySDxDEyCYe6dTgOt/u7HGNv2/tB2QxKYemD
	HgK4a7oK9GTepgt5tMJyDIhBbUTxBHAQCoM88qE6tF7/DmOSY0zrg8NFWghMh0TEUq7Iz0x+w49
	XzmyxSlHw+TefPOd6Bk=
X-Received: by 2002:a5d:5f81:0:b0:390:f607:9656 with SMTP id ffacd0b85a97d-390f60796f9mr8129019f8f.34.1740997511100;
        Mon, 03 Mar 2025 02:25:11 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG8JPrmyld9of7zduHKshilPng6cArXdQbF0Bz4Ey1KeSVNMKTj1pzN69el5Z/nX9jXjAwrfA==
X-Received: by 2002:a5d:5f81:0:b0:390:f607:9656 with SMTP id ffacd0b85a97d-390f60796f9mr8128994f8f.34.1740997510738;
        Mon, 03 Mar 2025 02:25:10 -0800 (PST)
Received: from [192.168.10.48] ([151.95.119.44])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-390e4796517sm13839957f8f.5.2025.03.03.02.25.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Mar 2025 02:25:10 -0800 (PST)
Message-ID: <1e077351-6fc4-4106-b4fe-a36b8be75233@redhat.com>
Date: Mon, 3 Mar 2025 11:25:08 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] KVM: x86: Introduce quirk
 KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
To: Yan Zhao <yan.y.zhao@intel.com>
Cc: seanjc@google.com, rick.p.edgecombe@intel.com, kevin.tian@intel.com,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20250224070716.31360-1-yan.y.zhao@intel.com>
 <ecbc1c50-fad2-4346-a440-10fbc328162b@redhat.com>
 <Z8UBpC76CyxCIRiU@yzhao56-desk.sh.intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z8UBpC76CyxCIRiU@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/3/25 02:11, Yan Zhao wrote:
>> the main issue with this series is that the quirk is not disabled only for
>> TDX VMs, but for *all* VMs if TDX is available.
> Yes, once TDX is enabled, the quirk is disabled for all VMs.
> My thought is that on TDX as a new platform, users have the option to update
> guest software to address bugs caused by incorrect guest PAT settings.
> 
> If you think it's a must to support old unmodifiable non-TDX VMs on TDX
> platforms, then it's indeed an issue of this series.

Yeah, unfortunately I think we need to keep the quirk for old VMs.  But 
I think the code changes needed to do so are small and good to have anyway.

>> There are two concepts here:
>>
>> - which quirks can be disabled
>>
>> - which quirks are active
>>
>> I agree with making the first vendor-dependent, but for a different reason:
>> the new KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT must be hidden if self-snoop is
>> not present.
>
> I think it's a good idea to make KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT out of
> KVM_CAP_DISABLE_QUIRKS2, so that the quirk is always enabled when self-snoop is
> not present as userspace has no way to disable this quirk.
> 
> However, this seems to contradict your point below, especially since it is even
> present on AMD platforms.
> 
> "we need to expose the quirk anyway in KVM_CAP_DISABLE_QUIRKS2, so that
> userspace knows that KVM is *aware* of a particular issue",  "even if disabling
> it has no effect, userspace may want to know that it can rely on the problematic
> behavior not being present".

There are four cases:

* quirk cannot be disabled: example, "ignore guest PAT" on 
non-self-snoop machines: the quirk must not be in KVM_CAP_DISABLE_QUIRKS2

* quirk can be disabled: the quirk must be in KVM_CAP_DISABLE_QUIRKS2

* quirk is always disabled: right now we're always exposing those in 
KVM_CAP_DISABLE_QUIRKS2, so we should keep that behavior.  If desired we 
could add a capability like KVM_CAP_DISABLED_QUIRKS

* for some VMs, quirk is always disabled: this is the case also for the 
zap_all quirk that you have previously introduced.  Right now there's no 
way to query it, but KVM_CAP_DISABLED_QUIRKS would also cover this.  If 
KVM_CAP_DISABLED_QUIRKS was introduced, zap_all could be added too.

> So, could we also expose KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT in
> KVM_CAP_DISABLE_QUIRKS2 on Intel platforms without self-snoop, but ensure that
> disabling the quirk has no effect?

To keep the API clear, disabling the quirk should *always* have the 
effect of going to the non-quirky behavior.  Which may be no effect at 
all if the non-quirky behavior is the only one---but the important thing 
is that you don't want the quirky/buggy/non-architectural behavior after 
a successful KVM_ENABLE_CAP(KVM_CAP_DISABLE_QUIRKS2).

There is a pre-existing bug in that I think 
KVM_ENABLE_CAP(KVM_CAP_DISABLE_QUIRKS2) should be cumulative, i.e. 
should not allow re-enabling a previously-disabled quirk.  I think we 
can change that without worrying about breaking userspace there, as the 
current behavior is the most surprising.

>> As to the second, we already have an example of a quirk that is also active,
>> though we don't represent that in kvm->arch.disabled_quirks: that's
>> KVM_X86_QUIRK_CD_NW_CLEARED which is for AMD only and is effectively always
>> disabled on Intel platforms.  For those cases, we need to expose the quirk
> I also have a concern about this one. Please find my comments in v2.

Ok, I'll reply there too.

>> anyway in KVM_CAP_DISABLE_QUIRKS2, so that userspace knows that KVM is
>> *aware* of a particular issue.  In other words, even if disabling it has no
>> effect, userspace may want to know that it can rely on the problematic
>> behavior not being present.
>>
>> I'm testing an alternative series and will post it shortly.
>   
> Thanks a lot for helping with refining the patches!

Thanks to you and sorry that the patches weren't of the best quality - I 
mostly wanted to start the discussion on the userspace API side before 
the beginning of the week in your time zone.

Paolo


