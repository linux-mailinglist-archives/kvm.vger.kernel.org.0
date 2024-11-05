Return-Path: <kvm+bounces-30737-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 854EE9BCF2A
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 15:24:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44879283B0F
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 14:23:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 031691D9A48;
	Tue,  5 Nov 2024 14:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CJIyPJBh"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29EF31D8A1D
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 14:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730816593; cv=none; b=NKnvovSnKg/9LWdVRyKd2fINS7AXGvCuhpA3+/D4t6m70yiobsVJWChWN8jP1z1hXtWgdTkQ1SVJars5iwAW5G3iJQKWXTmYzLkM1jFDmqK6Yw4+QWTbTGj27gabQwT1J7uIgLe8+QCPd+OaystTNiDwE/TDEYqI9NLKSwavQPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730816593; c=relaxed/simple;
	bh=Djuvr14RRZ0MPd9vYf8MC5jG3XF9zVIwAC+KIuA+dXk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U1nIy/AGI7VEAf6fsXwPgPXY6aRSidCO90VAI04MVqZdMlllvkncrk9/o8n4bTcVqoc4uyaAECn0+9BEuYo3IU28nMNzUqPzm0PYUWs+0STjqwamVCVa0yV5ud0tCKlbGTl69OoXp2bs6i+jtbfgpyDL5EFghKMs2XkXpJXSFX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CJIyPJBh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730816590;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3YxwCYFjvqWjHGFgyPBfEwCVE702KHg6Ilhczj8Xs2E=;
	b=CJIyPJBhtgL4WMeUkdiLi5FF0IhPydjqiByaxPPqZj8RD5GjHupKkW2TkaGH3ba3pV6Kyv
	D8b5RlgRucCuIyhe0zudXp1xh/3W3Il1Hhin2LWqYXBrZMpkIKwMP+6Xp78Of9nqN9GcbJ
	D8kfnIasNe2qcnVebTLgH23efia9IOc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-590-4uITFdi3Pjuvce0kGY48-Q-1; Tue, 05 Nov 2024 09:23:09 -0500
X-MC-Unique: 4uITFdi3Pjuvce0kGY48-Q-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-43151a9ea95so35920745e9.1
        for <kvm@vger.kernel.org>; Tue, 05 Nov 2024 06:23:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730816588; x=1731421388;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3YxwCYFjvqWjHGFgyPBfEwCVE702KHg6Ilhczj8Xs2E=;
        b=XfHNlBndcB0jxrGz9pB4StER1iqrXjRijcO9SIx0wbfa5IJ+UxH1xp2aCnEd/St7ny
         cAeo7t2FrCcqKrCGGN3C4YSGFk6oyULnqcrGgB61bUGJ7kJXMwWwj2IzxYBomtS9yNh2
         hKeu7LvMCUpQiYUsm7+MX31iEcYdXnDMYFy1C+yfCsSkbjnHIxgSNyBAlizdXe2m5x2w
         GVJWEza3HI+KnmXSFegwwNeJ9yAZbPgc8/GWuSdGxgJo2pBI73rLQM80ZZFXi5jnl8I0
         w0SL9pXO/vNIZfFzcGxL7EUSYDXoFtATwTlnrQcQBma5IgARQG+9MjMlCABvJ2dUBJX4
         T3xw==
X-Forwarded-Encrypted: i=1; AJvYcCW/Kej3E2janxcJIl6lyxPcbNQQ0rgZL6ChLhVvCplKiUgWY6qBlsvPdpFvb+sd5desYjs=@vger.kernel.org
X-Gm-Message-State: AOJu0YwByrXeZgoFnjh80JcjEFLz55Ja+pNDg+czzSFQ10Ikmh5vMWOX
	7RPMDN6rC7iPUd3PdTWPjNQEMOCPaYqtyUUQoTCb9tReVy69FvWJ9wgHuyYu4meYFatNeUphwI0
	5qdjxPyDyLyplmvY3t1qCW4q0XT9uNMcR8T8GKjeLmtuzaF+G1g==
X-Received: by 2002:a05:600c:3c9a:b0:431:57cf:f13d with SMTP id 5b1f17b1804b1-4327da727f5mr151566425e9.3.1730816587689;
        Tue, 05 Nov 2024 06:23:07 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHFzLlg/UFV4hvoZU6Iw2VzJemFRsBauC2gDiC/tx72Okl4O7Eqe9A/VJThWHUfJ3/aMqjNCw==
X-Received: by 2002:a05:600c:3c9a:b0:431:57cf:f13d with SMTP id 5b1f17b1804b1-4327da727f5mr151566205e9.3.1730816587326;
        Tue, 05 Nov 2024 06:23:07 -0800 (PST)
Received: from [192.168.10.28] ([151.49.226.83])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-4327d5bf429sm186909505e9.12.2024.11.05.06.23.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Nov 2024 06:23:06 -0800 (PST)
Message-ID: <a90e29a6-0e07-46a3-8dfc-658e02af9856@redhat.com>
Date: Tue, 5 Nov 2024 15:23:03 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 45/60] i386/tdx: Don't get/put guest state for TDX VMs
To: Xiaoyao Li <xiaoyao.li@intel.com>, Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>
Cc: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-46-xiaoyao.li@intel.com>
 <8cd78103-5f49-4cbd-814d-a03a82a59231@redhat.com>
 <e5d02d7f-a989-4484-b0c1-3d7ac804ec73@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <e5d02d7f-a989-4484-b0c1-3d7ac804ec73@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/5/24 12:25, Xiaoyao Li wrote:
> On 11/5/2024 5:55 PM, Paolo Bonzini wrote:
>> On 11/5/24 07:23, Xiaoyao Li wrote:
>>> From: Sean Christopherson <sean.j.christopherson@intel.com>
>>>
>>> Don't get/put state of TDX VMs since accessing/mutating guest state of
>>> production TDs is not supported.
>>>
>>> Note, it will be allowed for a debug TD. Corresponding support will be
>>> introduced when debug TD support is implemented in the future.
>>>
>>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
>>> Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
>>> Acked-by: Gerd Hoffmann <kraxel@redhat.com>
>>
>> This should be unnecessary now that QEMU has 
>> kvm_mark_guest_state_protected().
> 
> Reverting this patch, we get:
> 
> tdx: tdx: error: failed to set MSR 0x174 to 0x0
> tdx: ../../../go/src/tdx/tdx-qemu/target/i386/kvm/kvm.c:3859: 
> kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
> error: failed to set MSR 0x174 to 0x0
> tdx: ../../../go/src/tdx/tdx-qemu/target/i386/kvm/kvm.c:3859: 
> kvm_buf_set_msrs: Assertion `ret == cpu->kvm_msr_buf->nmsrs' failed.
Difficult to "debug" without even a backtrace, but you might be calling 
kvm_mark_guest_state_protected() too late.  For SNP, the entry values of 
the registers are customizable, for TDX they're not.  So for TDX I think 
it should be called even before realize completes, whereas SNP only 
calls it on the first transition to RUNNING.

Paolo


