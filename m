Return-Path: <kvm+bounces-36135-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 349E3A18193
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 16:59:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16D48164F24
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2025 15:59:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F161F472B;
	Tue, 21 Jan 2025 15:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kKsrIlb3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C391F1505;
	Tue, 21 Jan 2025 15:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737475174; cv=none; b=G21L0m+LHpvP8n5D93vAAqjVYzYHpfqqYH4nkl3Ra+plqIgRsH77jNYB4AzzJGHuw+yuU+OLoNEFmAJAzyhSXL/jWoBc9d1JshZz/pTPlgErXt3EdLJKcQPKWaA4FUHRhRMsRUuSCu+LVC9djdTKN6apqp3AO2h0X0qz+ZRwkVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737475174; c=relaxed/simple;
	bh=/Q0T30jgTYhIi4Y567kml+Oi8mAO/3iJcnxgEtBAPlY=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=tG6xA4ZPH0OKmgQN44SyqYRwy8DoswgkBw//VMER1yzVjA7jcBoWDplR96TPWWZ9puXE8V8teZykFND83NXKvhYBEjU/vqKgyTsLFv5N95bQcS+/tsh2YSIPfI3KL8C/ob8efwTOdJljgjc5ToS5yEW0b1N/+CiI4Rq+Czsduhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kKsrIlb3; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-38a34e8410bso3049912f8f.2;
        Tue, 21 Jan 2025 07:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737475171; x=1738079971; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=5OLsjHzyq/LJBcjwujNKyBJhOLqaam0VKEvf4djvkd8=;
        b=kKsrIlb3j/Uu4YlwP7zugTLqar0BaWsgNancL0ukfqS219+9CeMUkhn0sZ7W7o8Uws
         /oMG3IeBnguk+L2AK8hA+irTNfcMXwXzdlrhx6PfMm5IKy6nfwa3okwvIsNuyYRJ3+xM
         +3t2JC6sGLtgCwWT8BY1MulCGy5+EM8yhbBiQlbJLWLUUx31iel01FVc+dOWenYBcAku
         e6BVL+hRdh6EoxX3X/5JVPJfrzhSb84WjyWFtfQjBKpcK9yJ8ZU2+wH58S3h5kewdzuR
         0A06biYb/6HBL3g19AOKiAiU4CwA+TreCEpBEEyhdbgqtvlsJxtx2v0W3SVv1SUKLZEa
         VlVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737475171; x=1738079971;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5OLsjHzyq/LJBcjwujNKyBJhOLqaam0VKEvf4djvkd8=;
        b=VTCT14Txmi2GcFLMPF2WU5rE1ZQI7rUzx5LN9zzldGooHrxguZVcTTjVo6jf03UaE0
         Rd6UkI0rHz1k5D7iuTKcARM15HgRg52Uvrs0vWzNgcoOsdRwG0ogwDLrkhhWPnKYDrA+
         uRKcjTyDZvwtL52h2ZYuGNW6ZGsXkLMh9AqMoB/rXEfBfOevOLq8pzKQMX45jL+X7ehV
         +BuAe0nf7GV6VcenGiWNJHhZFn6JbfEcPERlxa2+FQrvAU7wbHEsNDKReTBz9Q/AyNdr
         t5HrAZgQqA+GH+kBSsVGksp4MXCqhPBJOr7ZScWyNBAxrFd/np7P2hjfRuFCNUA9fYhQ
         xYcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUB117GJNh9ITTkKeut768JuD0yrBC06sNftBR+zld5urN7JM15p+477J+67FIh7qKhRblJ7hfLHOZXLBnv@vger.kernel.org, AJvYcCUsEvSobQl4+Aomhx9wba7QACYQO4L179tWNq9wpMbOtW0+QZjwtshx76hto4ZQp7VoyN4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz+HCKdyJPKTMftleLY/j1drMnltLG2L6h7Hg5pe6LiFjrfre1h
	DF47OdjbwNw4AiljAUBo+NoIZIETEOELoJEL8dGjcwVLXrnJJlFi
X-Gm-Gg: ASbGncsJCVCtf3ViA0uWzXVH4GDnyz6r273Z2sr0rQPl2Go8Ax5oNMIhKl71W3Y23pa
	6UmMH05NSlb5zUbiJshrE78Jf7ihknWyb5CjVpmT2KbDv+ek3DoYXx/L5TWH5equlkOXdRk0wET
	lvQ60gVpHPbWyxyajM24sn17qB7ljfDx4JAuxZTFKDCwxRNMafbOr65M3T0hlFbe5I9rgm5/fXm
	sBj6z2nfmKj//EoVOsBLXrUmpborOguG1KVsPYTADvZfWM7Z9Gda7X8N49tYRvfEZ6nVLjMRwPU
	zWIRMz0uwmE3yXwqcYtcXfNZ+A==
X-Google-Smtp-Source: AGHT+IErnnUvQbaO26YCZVXCqDz5WwE/7Hvf43v2PzwaqnaHytvckfynXJKWzv06cFtb/IP/UUmd3g==
X-Received: by 2002:adf:a28a:0:b0:385:dc45:ea06 with SMTP id ffacd0b85a97d-38bf5684d6bmr13123990f8f.13.1737475171183;
        Tue, 21 Jan 2025 07:59:31 -0800 (PST)
Received: from [192.168.19.15] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4389046250csm181639875e9.25.2025.01.21.07.59.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2025 07:59:30 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <eb45ff29-f551-483e-9930-1fa545fb83aa@xen.org>
Date: Tue, 21 Jan 2025 15:59:29 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 09/10] KVM: x86: Setup Hyper-V TSC page before Xen PV
 clocks (during clock update)
To: Sean Christopherson <seanjc@google.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse
 <dwmw2@infradead.org>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>
References: <20250118005552.2626804-1-seanjc@google.com>
 <20250118005552.2626804-10-seanjc@google.com> <8734hd8rrx.fsf@redhat.com>
 <Z4_AwrFFsKg2VgYW@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <Z4_AwrFFsKg2VgYW@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/01/2025 15:44, Sean Christopherson wrote:
[snip]
> 
> I think it's ok to keep the Hyper-V TSC page in this case.  It's not that the Xen
> PV clock is truly unstable, it's that some guests get tripped up by the STABLE
> flag.  A guest that can't handle the STABLE flag has bigger problems than the
> existence of a completely unrelated clock that is implied to be stable.
> 

Agreed.

>> I don't know if anyone combines Xen and Hyper-V emulation capabilities for
>> the same guest on KVM though.)
> 
> That someone would have to be quite "brave" :-D

Maybe :-)

Reviewed-by: Paul Durrant <paul@xen.org>


