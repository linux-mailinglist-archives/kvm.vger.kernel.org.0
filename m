Return-Path: <kvm+bounces-10890-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1ACC887199A
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 10:29:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9EE921F2302D
	for <lists+kvm@lfdr.de>; Tue,  5 Mar 2024 09:29:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08ABF52F92;
	Tue,  5 Mar 2024 09:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jzv1XxVK"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6618524B1
	for <kvm@vger.kernel.org>; Tue,  5 Mar 2024 09:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709630982; cv=none; b=nMTOhdCsxWmwRLlzneP9dFcC4pacla0AwdmTC/sacXMnWGktq96eRIgfTGfT54AX81ptTcEDuRUNlvDITmla//+btyidRxzy+aoVAidiBtGpqFDtahE1zpUd0w5FRPFJpMdImfyKXMXVnxVR/E/1lpn2uXhBzJICEFIgoo0jkGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709630982; c=relaxed/simple;
	bh=So0ky33PyVGswJuSEzBUYSdaA+QXuJFbrH+hZezXjoY=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=nmppOVa+KyApQ1peY6OFsgKyBiKYZsS6V/crJjRpE6wxCZztkNNVvwJtiB/ggvAxabQTFRt8G1ZJfNvse5mRvzogHXNrCb9W0Hb0b8+K4QvqaGun0nYTdiKS+1Up+9oyOgnMlU4ZP8NxI2TUUvoeNPnbc9ZC9uLFSOulbLyGH0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jzv1XxVK; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-412ededaf07so1828545e9.3
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 01:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709630979; x=1710235779; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=bZYTqncmNW1eARtGdAHLKkGjyHFXxuYT4eSOhqyunzI=;
        b=Jzv1XxVKNE/5Ds1ZVPmB79OKQQxq1T7MqmY8xy6EWTSwVw79pmwoTsIe61u6Mo9ciX
         fnSkZvAr5BKLa6IP5CDuCvzsvLwZYw/2carXabDAmcjJ6DR/DTXHVjPRaXssSpFCMp8Y
         GcrOSxGrqSpNApH9V9qpPsGRy9e5YPJ8Ax9XhI/kyW54pYMGpwClk0eRzDdF28oNd+GA
         rgcecEHuEFrP8+JzpiIvXJO1720Z8hu2G4imwDx7ZjtGg6h/3txYfr/nTVnd0shdO6n/
         NEy5SCStzehTfwloQ/q+EU/BxsgpMfkiDjnc4HAD+rmxrVJ0dVzN7Vtrlhv7mn5wCaaQ
         ml4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709630979; x=1710235779;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bZYTqncmNW1eARtGdAHLKkGjyHFXxuYT4eSOhqyunzI=;
        b=I2ujIWcKYeYZ24SW6gOA/4YwQAuPc0b6fdpvesz3EUl555bMWG+ZVmS80eDDpuu6SP
         r0EV982+93mye9DLgbk+fXw57FmWrwTJ2loe5WqQw6x2DvK4DhFwjQZvIgio3lCXmngG
         shEOgIRKp3dm6O4Ox1s0bg+eULkDhON7mKBEAF1zX5D4+e/80gOJeOPa9flFdN3J/bAa
         rtdS1OzY7zFqyDrpv88JhD9JxX1tu8T38TwOuaqh5bOsKdJsEY2e854gcc/fV3nH2i/6
         0dl3qCCUuWv7Yj/XrQqrQ28A6pwa223XJdzuIae/edT33Sd1xXxb4OeZYq7GFuRpgNgs
         wUwg==
X-Gm-Message-State: AOJu0YxcHQc19W/1Mx6BeffXB/nnV1KIAlTrN+YY0S9K3QIXaH9znQPV
	LqD95SxoiLfs9Frs9KyFy5E7oGRcWF0BUX7pa0igpi5eBGKALqCL4Bt/p5VKFR8=
X-Google-Smtp-Source: AGHT+IHxc/aL6Iy5pSTNDMKRu2smgEdYN3ViojwOxZVbk5sdPREfhEmENLfZD6antzed80DeBycWDQ==
X-Received: by 2002:a05:600c:4f51:b0:412:ec05:adbc with SMTP id m17-20020a05600c4f5100b00412ec05adbcmr1011950wmq.22.1709630978702;
        Tue, 05 Mar 2024 01:29:38 -0800 (PST)
Received: from [192.168.19.5] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id jz12-20020a05600c580c00b00411a6ce0f99sm16936421wmb.24.2024.03.05.01.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Mar 2024 01:29:38 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <c72f8a65-c67e-4f11-b888-5d0994f8ee11@xen.org>
Date: Tue, 5 Mar 2024 09:29:35 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 1/8] KVM: x86/xen: improve accuracy of Xen timers
To: Sean Christopherson <seanjc@google.com>,
 David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Michal Luczaj <mhal@rbox.co>, David Woodhouse <dwmw@amazon.co.uk>
References: <20240227115648.3104-1-dwmw2@infradead.org>
 <20240227115648.3104-2-dwmw2@infradead.org> <ZeZc549aow68CeD-@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <ZeZc549aow68CeD-@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/03/2024 23:44, Sean Christopherson wrote:
> On Tue, Feb 27, 2024, David Woodhouse wrote:
>> +	/* Xen has a 'Linux workaround' in do_set_timer_op() which
>> +	 * checks for negative absolute timeout values (caused by
>> +	 * integer overflow), and for values about 13 days in the
>> +	 * future (2^50ns) which would be caused by jiffies
>> +	 * overflow. For those cases, it sets the timeout 100ms in
>> +	 * the future (not *too* soon, since if a guest really did
>> +	 * set a long timeout on purpose we don't want to keep
>> +	 * churning CPU time by waking it up).
>> +	 */
> 
> I'm going to massage this slightly, partly to take advantage of reduced indentation,
> but also to call out when the workaround is applied.  Though in all honesty, the
> extra context may just be in response to a PEBKAC on my end, as I misread the diff
> multiple times.
> 
>> +	if (linux_wa) {
>> +		if ((unlikely((int64_t)guest_abs < 0 ||
> 
> No need for a second set of parantheses around the unlikely.
> 
>> +			      (delta > 0 && (uint32_t) (delta >> 50) != 0)))) {
> 
> And this can all easily fit into one if-statement.
> 
>> +			delta = 100 * NSEC_PER_MSEC;
>> +			guest_abs = guest_now + delta;
>> +		}
>> +	}
> 
> This is what I'm going to commit, holler if it looks wrong (disclaimer: I've only
> compile tested at this point).
> 
> 	/*
> 	 * Xen has a 'Linux workaround' in do_set_timer_op() which checks for
> 	 * negative absolute timeout values (caused by integer overflow), and
> 	 * for values about 13 days in the future (2^50ns) which would be
> 	 * caused by jiffies overflow. For those cases, Xen sets the timeout
> 	 * 100ms in the future (not *too* soon, since if a guest really did
> 	 * set a long timeout on purpose we don't want to keep churning CPU
> 	 * time by waking it up).  Emulate Xen's workaround when starting the
> 	 * timer in response to __HYPERVISOR_set_timer_op.
> 	 */
> 	if (linux_wa &&
> 	    unlikely((int64_t)guest_abs < 0 ||
> 		     (delta > 0 && (uint32_t) (delta >> 50) != 0))) {

Now that I look at it again, since the last test is simply a '!= 0', I 
don't really see why the case is necessary. Perhaps lose that too. 
Otherwise LGTM.

> 		delta = 100 * NSEC_PER_MSEC;
> 		guest_abs = guest_now + delta;
> 	}


