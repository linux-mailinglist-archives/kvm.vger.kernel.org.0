Return-Path: <kvm+bounces-10313-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F2AD86BA92
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 23:10:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8AB32888D2
	for <lists+kvm@lfdr.de>; Wed, 28 Feb 2024 22:10:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E24881361DD;
	Wed, 28 Feb 2024 22:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SXdvy6cH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB501361CE
	for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 22:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709158205; cv=none; b=WK/PbyHGq86dKU9f4MnEFwafjFElB3iQUQJ2aeZQQF9BavnzKKIL6d1uSJIpI6fQAQyhdNsJPd7vmHFBEc6UgryPt5X5li6FmLGivf2bqhQGuUcSxyo+NTbVoa2BWd8egMDefbfWQ1M31vlDWYe60rUBvpMZ7MI88PmNW1cebSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709158205; c=relaxed/simple;
	bh=FQZMCebfNSkeDmZFSWAulJ5x1GW1PgsPZyHv7UHk+Qs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HmPrcbgVeylRkDsIS774fgsVF/m9KSqDKcqeS88sVRmwW8WoqCkkf5OyeHQpQsbAXrqTVEPXmxFP5N/aczXSW3cqe2VudwbSe9c2ycpDJji25hwroLSpjX4lDMCnLLUCSNVRNgBW7tALMRm2lQvO+RgBkFn2cQz7BasF16R+Ti4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SXdvy6cH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709158202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=B+EV2lT6BWSdE6oX0hxuy5LN6iik9wzjXnU7iqkhDv0=;
	b=SXdvy6cH58Nl3pRATGegNxyBgzfibVe6VN9GXnTfPMTNq7qHe331G88JbBXuSx5BYOn/do
	YhH370hg4QCR7L8QXQspY3YPNj7KEVtu+XiGWhnKa+78vRkPJVbesHXHSx6dEXJXxhLbkS
	xHQVkRlgVao/zc6VQq5YcIfwEcrggMw=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-4pgbtbQOPVuEfnxOkJkG7w-1; Wed, 28 Feb 2024 17:09:59 -0500
X-MC-Unique: 4pgbtbQOPVuEfnxOkJkG7w-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5664cac7b14so215315a12.0
        for <kvm@vger.kernel.org>; Wed, 28 Feb 2024 14:09:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709158193; x=1709762993;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B+EV2lT6BWSdE6oX0hxuy5LN6iik9wzjXnU7iqkhDv0=;
        b=n/Tp07LLkVwXE5MqK/xoIA+MHcwmW/v5548e36MtEQw/XVWnnIVq8WhhuexCL5n5fi
         mEb0TXur3rjpVerYIpPTFfGyN49yqVdcU6+BtQFl/AXEio9Cy+4lvlndNDc5MyMChu8s
         uIlhClein6CJvX1iVXsuA9e2hfIUiM41iD7N2WK+UY72CfvPzO5rO1VX6rFJTzOY+Jea
         fTTs6rBV1s/yyDGoyld+rg3CMUlGpFjVfFzH0E47YLUuMmPYwxQDPavM1PiyPWN1RKo2
         VCziRoLQOM3RT1gRfsJG4mCYA6kBp4V6tI/3JoIzShFaHq5xXMWXzpw0wHpiwOtnEri0
         +phw==
X-Forwarded-Encrypted: i=1; AJvYcCWxO8n97J7qqJ8K8ckGcE9mLQKb//l/dzns9Xpq7GRV0Yiu6QfsqTlwvumtMknMaDDqZhceyGiPPIdV2Bc3r7PMQHON
X-Gm-Message-State: AOJu0Yy5JphErvZlmcxIXDL6cPCffR5CbmAdWSMr5IntS58uNhGgIGnb
	a3VqFeoGuiaqp6T+17V993rvbkwSJ5kYwFeNtZlCJcmHNAGogTFxDutyOvecfXEYJwCIoAKVfza
	coH3DGCoAQi8M/Xbl1jXmirb4gs8fkytOVh9TS9NE/2v1/3lvyNmc5BjevQ==
X-Received: by 2002:a05:6402:30bc:b0:566:1794:394c with SMTP id df28-20020a05640230bc00b005661794394cmr129065edb.24.1709158193116;
        Wed, 28 Feb 2024 14:09:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEmfu24bp7UkGvEcQ4+tEbIWqtnZpk5H8albcf/QuQmopUid88So6QN4WY3xD6rZZKzDvbECw==
X-Received: by 2002:a05:6402:30bc:b0:566:1794:394c with SMTP id df28-20020a05640230bc00b005661794394cmr129057edb.24.1709158192759;
        Wed, 28 Feb 2024 14:09:52 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id en18-20020a056402529200b0056691924615sm184389edb.2.2024.02.28.14.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Feb 2024 14:09:52 -0800 (PST)
Message-ID: <54595439-1dbf-4c3c-b007-428576506928@redhat.com>
Date: Wed, 28 Feb 2024 23:09:50 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CVE-2021-46978: KVM: nVMX: Always make an attempt to map eVMCS
 after migration
Content-Language: en-US
To: cve@kernel.org, linux-kernel@vger.kernel.org,
 KVM list <kvm@vger.kernel.org>, Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: gregkh@kernel.org
References: <2024022822-CVE-2021-46978-3516@gregkh>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <2024022822-CVE-2021-46978-3516@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/24 09:14, Greg Kroah-Hartman wrote:
> From: gregkh@kernel.org
> 
> Description
> ===========
> 
> In the Linux kernel, the following vulnerability has been resolved:
> 
> KVM: nVMX: Always make an attempt to map eVMCS after migration

How does this break the confidentiality, integrity or availability of 
the host kernel?  It's a fix for a failure to restart the guest after 
migration.  Vitaly can confirm.

Apparently the authority to "dispute or modify an assigned CVE lies 
solely with the maintainers", but we don't have the authority to tell 
you in advance that a CVE is crap, so please consider this vulnerability 
to be disputed.

Unlike what we discussed last week:

- the KVM list is not CC'd so whoever sees this reply will have to find 
the original message on their own

- there is no list gathering all the discussions/complaints about these 
CVEs, since I cannot reply to linux-cve-announce@vger.kernel.org.

This is not the way to run this, and you're not getting more complaints 
just because people don't care, not because it's all fine.

Paolo

[1] 
https://lore.kernel.org/linux-cve-announce/2024022259-CVE-2024-26592-58f7@gregkh/T/#u

> When enlightened VMCS is in use and nested state is migrated with
> vmx_get_nested_state()/vmx_set_nested_state() KVM can't map evmcs
> page right away: evmcs gpa is not 'struct kvm_vmx_nested_state_hdr'
> and we can't read it from VP assist page because userspace may decide
> to restore HV_X64_MSR_VP_ASSIST_PAGE after restoring nested state
> (and QEMU, for example, does exactly that). To make sure eVMCS is
> mapped /vmx_set_nested_state() raises KVM_REQ_GET_NESTED_STATE_PAGES
> request.
> 
> Commit f2c7ef3ba955 ("KVM: nSVM: cancel KVM_REQ_GET_NESTED_STATE_PAGES
> on nested vmexit") added KVM_REQ_GET_NESTED_STATE_PAGES clearing to
> nested_vmx_vmexit() to make sure MSR permission bitmap is not switched
> when an immediate exit from L2 to L1 happens right after migration (caused
> by a pending event, for example). Unfortunately, in the exact same
> situation we still need to have eVMCS mapped so
> nested_sync_vmcs12_to_shadow() reflects changes in VMCS12 to eVMCS.
> 
> As a band-aid, restore nested_get_evmcs_page() when clearing
> KVM_REQ_GET_NESTED_STATE_PAGES in nested_vmx_vmexit(). The 'fix' is far
> from being ideal as we can't easily propagate possible failures and even if
> we could, this is most likely already too late to do so. The whole
> 'KVM_REQ_GET_NESTED_STATE_PAGES' idea for mapping eVMCS after migration
> seems to be fragile as we diverge too much from the 'native' path when
> vmptr loading happens on vmx_set_nested_state().
> 
> The Linux kernel CVE team has assigned CVE-2021-46978 to this issue.
> 
> 
> Affected and fixed versions
> ===========================
> 
> 	Issue introduced in 5.10.13 with commit 0faceb7d6dda and fixed in 5.10.38 with commit c8bf64e3fb77
> 	Issue introduced in 5.11 with commit f2c7ef3ba955 and fixed in 5.11.22 with commit 200a45649ab7
> 	Issue introduced in 5.11 with commit f2c7ef3ba955 and fixed in 5.12.5 with commit bd0e8455b85b
> 	Issue introduced in 5.11 with commit f2c7ef3ba955 and fixed in 5.13 with commit f5c7e8425f18
> 
> Please see https://www.kernel.org or a full list of currently supported
> kernel versions by the kernel community.
> 
> Unaffected versions might change over time as fixes are backported to
> older supported kernel versions.  The official CVE entry at
> 	https://cve.org/CVERecord/?id=CVE-2021-46978
> will be updated if fixes are backported, please check that for the most
> up to date information about this issue.
> 
> 
> Affected files
> ==============
> 
> The file(s) affected by this issue are:
> 	arch/x86/kvm/vmx/nested.c
> 
> 
> Mitigation
> ==========
> 
> The Linux kernel CVE team recommends that you update to the latest
> stable kernel version for this, and many other bugfixes.  Individual
> changes are never tested alone, but rather are part of a larger kernel
> release.  Cherry-picking individual commits is not recommended or
> supported by the Linux kernel community at all.  If however, updating to
> the latest release is impossible, the individual changes to resolve this
> issue can be found at these commits:
> 	https://git.kernel.org/stable/c/c8bf64e3fb77cc19bad146fbe26651985b117194
> 	https://git.kernel.org/stable/c/200a45649ab7361bc80c70aebf7165b64f9a6c9f
> 	https://git.kernel.org/stable/c/bd0e8455b85b651a4c77de9616e307129b15aaa7
> 	https://git.kernel.org/stable/c/f5c7e8425f18fdb9bdb7d13340651d7876890329
> 


