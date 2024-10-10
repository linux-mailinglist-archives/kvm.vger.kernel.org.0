Return-Path: <kvm+bounces-28427-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8955998761
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 15:17:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1DC99B21B8F
	for <lists+kvm@lfdr.de>; Thu, 10 Oct 2024 13:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3AA01C8FD7;
	Thu, 10 Oct 2024 13:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QIlSJkhU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7516C1E507
	for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 13:17:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728566243; cv=none; b=utXRrIDvHVLvk366F3mMxxdxm+FXGpn+GxZsn75gqjShlDE9MO+FrMwrxu+ambocOTU+6bKfDI/FijwzicCajCC/1y63fh5FtcewC+dssvgMCMO2U5h+j64l4SB5BPosJ5cjfydgJRpLAX124IGuUYzSu6dlX6mVhq9YhpXn3Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728566243; c=relaxed/simple;
	bh=uoNm7/yDc3CJ2KfHAFfskJvO8wswI40meX1BSv6I8rA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gDu80PLhIpDAZhfcQsOKrFjbMUf1AKMz1Os/vg3cO+XuyYQA4nLUbJ5E7T5dedzO4ygtgSmaeHj0i+iL30sy9Xd/1b8o8SWQ3AiyetABxYU7HIdenBk2022bCqkSTgeeVSS00MekMrTkVAgvT1YrV+GEzPx/kSr1mYrjrsKbHok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QIlSJkhU; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728566241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tW61VWT1190yosWqG11QNSDaPixl9Zxqyixjvrrfz3U=;
	b=QIlSJkhUunp534LVHpcS9Clk4sjyWggr3Vn6iP7oG86bgqv6l3AJj7DNo4LFjhtwNcM1EW
	B9kJuvDYfA+NdLKZKoQMclvcrBVrYiIg2zCib0fM985vldSaCxZAu30p5zTMMBD8DMxEMQ
	dYDWSblLfR3hPsFsdeRZCQ8WdlbsEps=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-zb5Hx9ahM7SXK3y9t4TqMw-1; Thu, 10 Oct 2024 09:17:20 -0400
X-MC-Unique: zb5Hx9ahM7SXK3y9t4TqMw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5398fabdfe3so928955e87.1
        for <kvm@vger.kernel.org>; Thu, 10 Oct 2024 06:17:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728566239; x=1729171039;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tW61VWT1190yosWqG11QNSDaPixl9Zxqyixjvrrfz3U=;
        b=F/3upMXtreJcM8cdBfkfqumU609mFN1MDm1no2AVOwfkmK7C0mhid2zmim+RnPJ4Ie
         leRXXmoWhJ74XOKF0creDT20/Cz9GGcwpNL1hdkKyu3sqxOfByezqA5GHr+WwUwehq6V
         SfJgs2NY8HINaiuSlGkmQt0Eru2qeOCwH9vmeEtNT9JV0aIgdxCThUdja+5mmNHxYUho
         zWy4eVs5zWVxMbQ+7fUASIkiO57hil7O+j2/OtVkNrhsABETygzdEEHXhy1B6mivWW7f
         nlIYQtBYd3AHJCMIRRKbs5gZa6ODSvumskSJhL/UBy+TIQzK7m4Hq1Xndxusb/zw3wU6
         uNhg==
X-Forwarded-Encrypted: i=1; AJvYcCUfwSBaHrYBZ72c8vs/u8hutgfw4JAqcAYZQUMBLhsPdcamFqwuIR3MIs5BJy2avuu3Xhw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6UuJo2gUkOmt382B56UIFgCW0IOc0AMj3rrj1LtFvMxpKG5m4
	jAR75xB9/jm9Wpz17E7C/vjZjYvekoHSr7R7blwN2JOvVE4ekhOByRqhq/zUtFlymxbFubLL3lO
	TG8xjqKXiNVhBKzSo6+o7DO3V3TmkBP4Q9ywqfu+/fDf5NW0cTw==
X-Received: by 2002:a05:6512:1281:b0:539:8b49:893e with SMTP id 2adb3069b0e04-539c4967f89mr4218283e87.38.1728566238591;
        Thu, 10 Oct 2024 06:17:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFljLrIMPYNITNfXxdoNMDLVXmnBFchxnTeiHmhRHZUm0FcNwVxbQJqmZlCCv/SI3/hmPb1Sg==
X-Received: by 2002:a05:6512:1281:b0:539:8b49:893e with SMTP id 2adb3069b0e04-539c4967f89mr4218258e87.38.1728566238121;
        Thu, 10 Oct 2024 06:17:18 -0700 (PDT)
Received: from [192.168.10.81] ([151.81.124.37])
        by smtp.googlemail.com with ESMTPSA id 4fb4d7f45d1cf-5c937298cc5sm762640a12.93.2024.10.10.06.17.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Oct 2024 06:17:17 -0700 (PDT)
Message-ID: <9bd5659c-6066-46f9-a096-10f585f8561e@redhat.com>
Date: Thu, 10 Oct 2024 15:17:16 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] target/i386: Add more features enumerated by
 CPUID.7.2.EDX
To: Chao Gao <chao.gao@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Cc: qemu-devel@nongnu.org, jmattson@google.com,
 pawan.kumar.gupta@linux.intel.com, jon@nutanix.com, kvm@vger.kernel.org
References: <20240919051011.118309-1-chao.gao@intel.com>
 <ZwY1AeJPlrniISB1@intel.com> <ZwY69phzk3GpGvsh@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <ZwY69phzk3GpGvsh@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 10:12, Chao Gao wrote:
>>> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
>>> index 85ef7452c0..18ba958f46 100644
>>> --- a/target/i386/cpu.c
>>> +++ b/target/i386/cpu.c
>>> @@ -1148,8 +1148,8 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>>>       [FEAT_7_2_EDX] = {
>>>           .type = CPUID_FEATURE_WORD,
>>>           .feat_names = {
>>> -            NULL, NULL, NULL, NULL,
>>> -            NULL, "mcdt-no", NULL, NULL,
>>> +            "intel-psfd", "ipred-ctrl", "rrsba-ctrl", "ddpd-u",
>>> +            "bhi-ctrl", "mcdt-no", NULL, NULL,
>>
>> IIUC, these bits depend on "spec-ctrl", which indicates the presence of
>> IA32_SPEC_CTRL.
>>
>> Then I think we'd better add dependencies in feature_dependencies[].
> 
> (+ kvm mailing list)
> 
> Thanks for pointing that out. It seems that any of these bits imply the
> presence of IA32_SPEC_CTRL. According to SDM vol4, chapter 2, table 2.2,
> the 'Comment' column for the IA32_SPEC_CTRL MSR states:
> 
>    If any one of the enumeration conditions for defined bit field positions holds.
> 
> So, it might be more appropriate to fix KVM's handling of the
> IA32_SPEC_CTRL MSR (i.e., guest_has_spec_ctrl_msr()).
> 
> what do you think?

You're right, the spec-ctrl CPUID feature covers the IBRS bit of 
MSR_IA32_SPEC_CTRL and also the IBPB feature of MSR_IA32_PRED_CMD.  It 
does not specify the existence of MSR_IA32_SPEC_CTRL.

In practice it's probably not a good idea to omit spec-ctrl when passing 
other features to the guest that cover that MSR; but the specification 
says it's fine.

Paolo


