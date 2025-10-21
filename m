Return-Path: <kvm+bounces-60679-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 70A1FBF76C6
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 17:38:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E8AD8348FE2
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 15:38:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A623431EE;
	Tue, 21 Oct 2025 15:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MKnWa5x7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88382340A6F
	for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 15:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761061085; cv=none; b=LmGYJoH//l25zsyQ9s4NP1X28ylheAKCWAJ/VOyCqg9l7KFRNhmQh5tEbevecwvCkwGJ/S58x3AQJEmMo5leLXRLPYq1XReHZTLvR+lLMjiGb3toUPXDF9obmJh+qkHkndMQfcAHGorgfYaR/KdQjTGMeEoepvL/nO5yqfpCQ7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761061085; c=relaxed/simple;
	bh=Xltkqvk9wsNCSS6fJ/DElH7YNzWxHVeWC/z2Swu7qwc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MokFChjiH0frQVeeSClhTuuzc+sMAbSfaWsjOZ+9srrPqyps2BjvTuCYYS+0gnATSFJiXDBbk7dLWDIpRT5zo74D2A73+RkpoMLvdxUddA7jjqKtU1XzQQxD2blS337bU4Wa/verd3EzeHL/idurKEUTeWjJk6efqeueTqgE7Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MKnWa5x7; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b5515eaefceso4706734a12.2
        for <kvm@vger.kernel.org>; Tue, 21 Oct 2025 08:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761061083; x=1761665883; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HTPDHRHyFpbb4wO3dMS1kqyE3mXJLkbAQA5zC5/qZy0=;
        b=MKnWa5x74NJNdK8EA+xr+ZCaoAhNT6baCeR7bAM4PBpD5qD2qJwfFPPNqSOrQyFejg
         mcvOJjHU8+kIsG7PV5GUMaqgfpV7DbqvEC9A5Oe0JCY5PFtWmLNm5LZYf8w886Pl+tk5
         8hz0mp0hcD9TE1MFcdKvxoUTI5ZQMne9wj1lmvFT6F3z2duSn0Cxz4Fk77yYoTQEmWpS
         govtLk07bxflSLDXmT66u6IwHzj7lqXLSJv06ksq+rdM/A/zJxVQVlmy1c9mlpqWPnhz
         bKgCq/63T0nJGfyCwfB01LwhPlhng5II3O7GPEClaKCWHnSQ3szHcPcrFNmUrqnDdLkH
         uueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761061083; x=1761665883;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=HTPDHRHyFpbb4wO3dMS1kqyE3mXJLkbAQA5zC5/qZy0=;
        b=vK1uoDj/Oo6QpHDqOQmCkkuwT0hvqql6w3elHvEunhJ0vuW4e4pNFeUAXcrrV1fPod
         U5tvMZh5zvtZ03c5Qk/EhcJmlzdfZLhUiNONYcPQdrQqqGNNOaH+InBObPajaBif/a8T
         v7L20tdZWVpHl2XYBnqaDKe11PvMu3CaEfDA7FacdhhjYsJRqe9Q6BFVFk0s4Hcumqoh
         S5v/vAxW2T9no8udQG9JlcvXFU18/nVTojNMn4ttDm2ne42krr5vmLDbhJFwa3KMEiyk
         o5UNY0OewhAvwU5tYA9smmqLqMQV4P+grAnQbrGlMTwdiYLYorOXzZHaIO/5G6Sg9Pex
         SDoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXH6U5QbMwamJ9N5WHX6g7WK9Rf7ATub/zkhfdPqXCt3MN8qmV/Gj5hAtfYzlxOkMCO4oQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwaRXPoF49G9bXzsY0olcDxbX4BECojMmCX1WYKYJzbHzUdI+Ps
	3vFDcZoKcRtctIKKXKM7yuRi8YvpcRc75GrxXDfokrSWoyR2ZEFVxL3v
X-Gm-Gg: ASbGncvhTW589oKiJGw1H8bJHsA5a+J55a9bKZ9ED5pQ1Aru1Qic4lelHKYEOnbFcgu
	NUPuclsIgAcNU1VqDuu+XUjv9AeyWh1tGp8/lfLskL0XgfJ+og2D5iKX1pWiHmIzEccf8qzHBhp
	oNWZjuIBVWnRqRS/pbXxdEcZtDkVYUdhhYLLuoCqjd8kfxPcY4XbSObD9VzPslureW7ABNcXm/Z
	2vdDtIGvfBsIFqZH013h0NBN+HopMwH42E6GH+YsU5d1+UZCFt3xNduskHLuRYwkXBY1vbEvWL3
	U8OUVKJAn7NVe7Me5qGwAQteycmKfEg9qOcfwYs9i4uuIu1bZeKTCSkDGbOxy6B9EcG/46jxjJ+
	BIwy1V3Ji4+GM5ZMwfry971qyxbmsF6pQPJYvDAc/fKfbqQB6ePylUhiq+huIOTxquJ7XfaVf3d
	KGf3sqRx+ivA==
X-Google-Smtp-Source: AGHT+IFD5nLuJkhct3AKTxoFVtA9YBDMtterxMe030U32OIMqiYbVASma+GE98S4msp7WNMY/wSxSQ==
X-Received: by 2002:a17:903:1a0e:b0:26a:23c7:68da with SMTP id d9443c01a7336-290ca02353emr215062845ad.25.1761061082785;
        Tue, 21 Oct 2025 08:38:02 -0700 (PDT)
Received: from [10.253.78.230] ([129.227.63.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29247207788sm112311755ad.99.2025.10.21.08.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:38:02 -0700 (PDT)
Message-ID: <5f35565e-ddda-4b3e-954d-7f865baede05@gmail.com>
Date: Tue, 21 Oct 2025 23:37:57 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND] avoid hv timer fallback to sw timer if delay
 exceeds period
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, yu chen <chen.yu@easystack.com>,
 dongxu zhang <dongxu.zhang@easystack.com>
References: <20251013125117.87739-1-fuqiang.wng@gmail.com>
 <aO2LV-ipewL59LC6@google.com>
 <c87d11a7-b4dd-463e-b40a-188fd2219b3b@gmail.com>
 <aPJnxDj4mFSJc0tV@google.com>
From: fuqiang wang <fuqiang.wng@gmail.com>
In-Reply-To: <aPJnxDj4mFSJc0tV@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/17/25 11:59 PM, Sean Christopherson wrote:

>> ====
>> IMHO
>> ====
>>
>> 1. for period timer
>> ===================
>>
>> I think for periodic timers emulation, the expiration time is already adjusted
>> to compensate for the delays introduced by timer emulation, so don't need this
>> feature to adjust again. But after use the feature, the first timer expiration
>> may be relatively accurate.
>>
>> E.g., At time 0, start a periodic task (period: 10,000 ns) with a simulated
>> delay of 100 ns.
>>
>> With this feature enabled and reasonably accurate prediction, the expiration
>> time set seen by the guest are: 10000, 20000, 30000...
>>
>> With this feature not enabled, the expiration times set: 10100, 20100, 30100...
>>
>> But IMHO, for periodic timers, accuracy of the period seems to be the main
>> concern, because it does not frequently start and stop. The incorrect period
>> caused by the first timer expiration can be ignored.
>
> I agree it's superfluous, but applying the advancement also does no harm, and
> avoiding it would be moreeffort than simply letting KVM predict the first expiration.
>

Yes, that’s indeed the case.

> KVM unconditionally emulates TSC-deadline mode, and AFAIK every real-world kernel
> prefers TSC-deadline over one-shot, and so in practice the benefits of applying
> the advancement to one-shot hrtimers.  That was also the way the world was headed
> back when Marcelo first implemented the support.  I don't know for sure why the
> initial implementation targeted only TSC-deadline mode, but I think it's safe to
> assume that the use case Marcelo was targeting exclusively used TSC-deadline.

Yes, it appears that focusing on TSC-deadline emulation fits the current use
cases.

>
> I'm not entirely opposed to playing the advancement games with one-shot hrtimers,
> but it's also not clear to me that it's worth doing.  E.g. supporting one-shot
> hrtimers would likely require a bit of extra complexity to juggle the different
> time domains.  And if the only use cases that are truly sensitive to timer
> programming latency exclusively use TSC-deadline mode (because one-shot mode is
> inherently "fuzzy"), then any amount of extra complexity is effectively dead weight.
>
>> should not be applied to:
>> sw/hv period
>
> I wouldn't say "should not be applied to", I think it's more "doesn't provide much
> benefit to".

Thanks again for your clear explanation and insights. This really helped me
understand the design choices better. :)

Regards,
fuqiang

