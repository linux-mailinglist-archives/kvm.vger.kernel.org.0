Return-Path: <kvm+bounces-11117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 64227873308
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 10:49:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95E901C20613
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 09:49:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF17F5F470;
	Wed,  6 Mar 2024 09:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I25eSikL"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7BF5EE89
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 09:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709718529; cv=none; b=oddeybglj1iD3rZJMijbaGUGkjPOMcSfZBSXGPh7rF2oG4HKuaezVnkGF6ws1pJfxC8lF9suhqYcGtajYov49PvI92O415k/yfsJlbtuLHaq7ytBL1eOiktSd48JLyJ439602mOX+hsF1YvPlKYeo5d8WsdlPUYBXibfteA9MhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709718529; c=relaxed/simple;
	bh=YRD1fhJWrVGBbviakyGMRyNBXQ9dBaPLtguIPJ9Xtuk=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=TFuKEhfaSqD4hWTCE91/kRTQEfKdVYHYFdX/t835WaXfB8ihL4Cue3ad6uI86A4rQXThKQFqsIs54DXkZBgp9esaAvf0zgEYFXq7UCQlcRGEWGKDm6liBuhbQgQd0ppAZiIPZmG5fFdCCV13aQg+Tc0pvG+12TmITGC9T3JDUXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I25eSikL; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-412ee276dc9so11261895e9.1
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 01:48:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709718526; x=1710323326; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9HzdUZ1J7AKZfZrG1a4rxBCT4svb4x3WcPPcAPsIlio=;
        b=I25eSikLJlyqNIS3kRMp4hEQFf7rHvxyxmOkPCrtbiF5hO12Ff4xTLFIDZOLQ5EeT2
         7U4d6PEAo3YMzrmzBN9ke0+yh2f11EcVAxxOV8QuJ4bmgUepe9SHZJ1+0XHjwD26NvdD
         hy5qYScLjL8fNGBwMs0KVTKaiFPyj1AGCkMcDyCQ2kVXhZXIVzx14Ip7PtIl8Zh5Kyw8
         4J3r3KOqLWhTeMYyCW4X2T1bqjU+WPzYkOwr1pNb0OzMjGSkCFZ2lODrbMgi/EtGaopF
         cFJER0AAywxxouPITqVcX95/heXBqtwldRcT3jWZcIrn3lKxBAGb3/dfXQfAGVatLqsX
         k0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709718526; x=1710323326;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9HzdUZ1J7AKZfZrG1a4rxBCT4svb4x3WcPPcAPsIlio=;
        b=hSL8L5vDiTRbO3VELLJ5uJu1iMUygfDbbtkmTqrWaBC05oFjnJ0BcpyhAcLTyz1/13
         cEaaQgcj6yPI6gRbDuWWEcD38CM8EkNY69hqp/bmDoynicnfxHo5hXdCvVm4/yGnFqNr
         XVYTixBUlXIu8oRxb7WSn6OLh7Qq6yyWEHMu4SD0vIhHauksYwefJS6ZItIJI5YeTG1N
         4ggH6HQy7I3UJnN3x0oCoToKXun/R2BF8OsIY7+wxE+mt4nTQPiBCMOeoP2FII60Hghm
         nFgVKWUq8yOfkW98imLQIAs6mcXEqYf35SoyLUzGSuAriPiIp/vqBzQWXxCHIfwNOtBV
         gF1Q==
X-Forwarded-Encrypted: i=1; AJvYcCWoULQPT4mV5P7nnShhtp5LhMoR3NXdDCGmye6916DidTg7+7N5mjSVBKac2Shcnzr9GuN8FIqpnlUikdn+/DyZOYox
X-Gm-Message-State: AOJu0YyiaHfuicv7vPe0i/jPX4TLxMXUoH6KE/oBVvocu7+JwCZSHni1
	ZkONg4+d4bJ/O1apfiYcWkWaErkHBN59hTiTbK0aRbrv6uELxr9Z
X-Google-Smtp-Source: AGHT+IF3uBhZPsbxKtog4DooYtaptZrDQeswZs6zz6H+YwmZFORmjIZnjb2TPNl0cAvPxVvSyHbLTQ==
X-Received: by 2002:a05:600c:1912:b0:412:e79f:3f8e with SMTP id j18-20020a05600c191200b00412e79f3f8emr5157428wmq.15.1709718525428;
        Wed, 06 Mar 2024 01:48:45 -0800 (PST)
Received: from [192.168.18.114] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id d15-20020a05600c34cf00b00412f5bb2469sm1418536wmq.25.2024.03.06.01.48.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 01:48:45 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <a11bac5d-03cb-47a5-accb-1b5ee06bd931@xen.org>
Date: Wed, 6 Mar 2024 09:48:41 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 1/8] KVM: x86/xen: improve accuracy of Xen timers
To: Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
 Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>,
 David Woodhouse <dwmw@amazon.co.uk>
References: <20240227115648.3104-1-dwmw2@infradead.org>
 <20240227115648.3104-2-dwmw2@infradead.org> <ZeZc549aow68CeD-@google.com>
 <c72f8a65-c67e-4f11-b888-5d0994f8ee11@xen.org> <ZeeK0lkwzBRdgX2z@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <ZeeK0lkwzBRdgX2z@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/03/2024 21:12, Sean Christopherson wrote:
> On Tue, Mar 05, 2024, Paul Durrant wrote:
>> On 04/03/2024 23:44, Sean Christopherson wrote:
>>> On Tue, Feb 27, 2024, David Woodhouse wrote:
>>> 	/*
>>> 	 * Xen has a 'Linux workaround' in do_set_timer_op() which checks for
>>> 	 * negative absolute timeout values (caused by integer overflow), and
>>> 	 * for values about 13 days in the future (2^50ns) which would be
>>> 	 * caused by jiffies overflow. For those cases, Xen sets the timeout
>>> 	 * 100ms in the future (not *too* soon, since if a guest really did
>>> 	 * set a long timeout on purpose we don't want to keep churning CPU
>>> 	 * time by waking it up).  Emulate Xen's workaround when starting the
>>> 	 * timer in response to __HYPERVISOR_set_timer_op.
>>> 	 */
>>> 	if (linux_wa &&
>>> 	    unlikely((int64_t)guest_abs < 0 ||
>>> 		     (delta > 0 && (uint32_t) (delta >> 50) != 0))) {
>>
>> Now that I look at it again, since the last test is simply a '!= 0', I don't
>> really see why the case is necessary. Perhaps lose that too. Otherwise LGTM.
> 
> Hmm, I think I'll keep it as-is purely so that the diff shows that it's a just
> code movement.  There's already enough going on in in this patch, and practically
> speaking I doubt anything other than checkpatch will ever care about the "!= 0".
> 
> Thanks!

... and now I see I typo-ed 'cast' to 'case'... it was more that 
'(uint32_t)' than the superfluous '!= 0' that caught my eye but yes, I 
agree, it's code movement so separate cleanup is probably better.


