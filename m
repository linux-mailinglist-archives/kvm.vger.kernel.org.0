Return-Path: <kvm+bounces-33914-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id A0B3F9F47C9
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 10:42:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 07FDA1883BA3
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 09:42:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB5421DED56;
	Tue, 17 Dec 2024 09:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XfL3iiSm"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F831D45EF
	for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 09:41:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734428510; cv=none; b=BFveo3gDVxfJwBZAaxf1gG491psJi+/3XOOOpjeoQwQvqVvZeGNNVsLh2Ke4WqLHWd0tNaDHXGiuZcGzaxq0avMQndvNJgAxLHdnHoiN6ODVzPNNT0KjckWlw6kxu5Z5l28wHvkdxVBkliRzGirfMr6IEKGSUaM1XIMhV1PspaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734428510; c=relaxed/simple;
	bh=O7iWLI/j+BiMLlgdZy77+6GKClT1MsHhGkVoQjlkJBg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tT5do5HUfG+ls0VjTeietzvKsfzDg6KoInH+zG14jdxG6m+XoY5AeIMnt5rpmkRPsomWIjg4MK/9881mRA67RTCPcy4bHMuAaHb50HMwyVcBAmDWODcsrUocmNbt0B7OTY8P4fRIKZFPLHQ0FuxsIne18vENcu/tNejtK+pjxfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XfL3iiSm; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734428508;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fXqH9um9w5h8Ggdovb54C2n4fbfuDUHfmKGXh4mGHQA=;
	b=XfL3iiSmmj4XLmQS/zAtK+6aQggqr4+kypIz3X2uYIIKRo99lDj7RUkR0Ipf1xIoiCCf5F
	L420Xq0yf12An3ELnsy4j+CWfy87cK4QgrAqDU0lVH7y7f6kEhwuD21MB5En0OiJ/xd+1A
	n+lHSYVQh1o+XLwiTsHInU/npBWtKSI=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-451-4uJsW3ADOlWum1ye4iR46w-1; Tue, 17 Dec 2024 04:41:45 -0500
X-MC-Unique: 4uJsW3ADOlWum1ye4iR46w-1
X-Mimecast-MFC-AGG-ID: 4uJsW3ADOlWum1ye4iR46w
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-385e3cbf308so2091706f8f.2
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 01:41:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734428504; x=1735033304;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fXqH9um9w5h8Ggdovb54C2n4fbfuDUHfmKGXh4mGHQA=;
        b=mNZNUjztAfJfT2n5CCdOjMLloiYT8kfBLJNDh7DvLH7nVU/efi79gwprkHtvRJJt5N
         LBFlxDmXpg+4lMW5jmKLaburzKmRZy+4Fwu4FqD6xAsjZIpSqmlM/6vymktKI0Xj5tT2
         kruR3EPSWLc0VMEwe93xU2XY18BYGKBX54lWA9J5kZpSFuBCXr+EHYKlwxUxfUX0VNba
         1Jo2ATtpBrw3MITzhpYKQvRQSW8UwfZEHeITq5B1iaTl+8oVM5FgXa29Q0skwVim7y3+
         SyxEAPVQCpxJj08C1l111+Hht+5MwKrw5VwJLJ7s20mivzkAEZgLw5bZLMiu73LTiaIk
         wdtA==
X-Forwarded-Encrypted: i=1; AJvYcCXYf1iE3DdPBKENw6qBriDk9bWaoOPk30oK7TJX5+B4vS0LYDHcEILMBs+V/PwMn4Zp5L0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrsBXdEL0GZng18NNRMjwIUEKoT3+D35VFIAYi8mw5wTHrz1CB
	Nxtd0YWTvbPnz0EIZ57CzrETsG4bEelkxvZ4WNetnd5AcwT+vEgyDEfM62bM0q1JUbhaj1/8ViU
	vUrq/lYPKLWRs1SxXrPkh6PVOoC5n/bZpiGu30/2HH4YcN9aADQ==
X-Gm-Gg: ASbGnctpbz6W3WPK5WqyZue2SVGvXBxDjj/ToORxr4VDl7EbLkcwB/LkdrcGVD0koPU
	GZB6qqOeSN6IWHUYhVvqokzkCyv+NOdCLEEf7DkKP6U2FcEnqiS9bO28hEoGDByFZ6JVzKX1Aol
	eQFysQPSCzRbkjXFklLoymn8LeSO/3SzlK4ZYhNAX9SsWi1PdEqlwikBqRhv7xarwecsujB6ecT
	vcD/pZFyAqSi6dl7xEqaXp6pBe5abq0OKfcgl88YXYK7dSEqa7DFILSFP2p
X-Received: by 2002:a5d:648a:0:b0:385:f677:8594 with SMTP id ffacd0b85a97d-3888e0f30ccmr11614376f8f.43.1734428503928;
        Tue, 17 Dec 2024 01:41:43 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEpe13aD2kSJpTmfKM9PKcTiCkzTDRM65j9w6bpOOqimB7xacV0EEtG4T0dXT4blDMOwOlxUg==
X-Received: by 2002:a5d:648a:0:b0:385:f677:8594 with SMTP id ffacd0b85a97d-3888e0f30ccmr11614339f8f.43.1734428503582;
        Tue, 17 Dec 2024 01:41:43 -0800 (PST)
Received: from [192.168.10.47] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-388c801a8bbsm10648723f8f.56.2024.12.17.01.41.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 01:41:42 -0800 (PST)
Message-ID: <8011ba26-d0eb-4e18-be8d-b464235e89b8@redhat.com>
Date: Tue, 17 Dec 2024 10:41:36 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 43/60] i386/tdx: Only configure MSR_IA32_UCODE_REV in
 kvm_init_msrs() for TDs
To: Ira Weiny <ira.weiny@intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>
Cc: Riku Voipio <riku.voipio@iki.fi>,
 Richard Henderson <richard.henderson@linaro.org>,
 Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Igor Mammedov <imammedo@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Yanan Wang <wangyanan55@huawei.com>, Cornelia Huck <cohuck@redhat.com>,
 =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org, qemu-devel@nongnu.org
References: <20241105062408.3533704-1-xiaoyao.li@intel.com>
 <20241105062408.3533704-44-xiaoyao.li@intel.com>
 <Z1xHztTldnFDih8W@iweiny-mobl>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <Z1xHztTldnFDih8W@iweiny-mobl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 15:42, Ira Weiny wrote:
> On Tue, Nov 05, 2024 at 01:23:51AM -0500, Xiaoyao Li wrote:
>> For TDs, only MSR_IA32_UCODE_REV in kvm_init_msrs() can be configured
>> by VMM, while the features enumerated/controlled by other MSRs except
>> MSR_IA32_UCODE_REV in kvm_init_msrs() are not under control of VMM.
> 
> I'm confused by this commit message.  If these features are not under VMM
> control with TDX who controls them?  I assume it is the TDX module.  But where
> are the qemu hooks to talk to the module?  Are they not needed in qemu at all?

The TDX module controls the values of the MSRs, and the values cannot be 
affected by QEMU so there is nothing that QEMU needs to (or can) do.

> Also, why are the has_msr_* flags true for a TDX TD in the first place?

KVM only provides a system ioctl for this purpose, not a VM ioctl; so 
there is currently no way to obtain the information for the VM.

Paolo


