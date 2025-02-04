Return-Path: <kvm+bounces-37213-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C43DA26E41
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 10:26:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 69EFD1887164
	for <lists+kvm@lfdr.de>; Tue,  4 Feb 2025 09:26:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C047207DF3;
	Tue,  4 Feb 2025 09:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VtS+W+uJ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EEA207A19;
	Tue,  4 Feb 2025 09:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738661167; cv=none; b=O7BlSVUvruYoT2lM4yJV1r8RJH6HDwKfl4yCAVfdx2KZHAC1imVr/lxuwa5zFzVo+faObpRmMsLfVsKswyVScTr3X+BdMeXt0bP8DmDUFC2GKTEpOzEdOiVUavB59g3jwh5ioFbdJETVRirViXxLV3CANXUu10sjwPH33TSuC/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738661167; c=relaxed/simple;
	bh=331X12ABmtKtadCN0VISYt/VT6Fe3g4NktVCXvB5x0M=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=nXgR8cAGpWEjmSS4Hci3oqF6uCx6+NLYWNDaQF+mi6K23R5ZUSMUQJSmQHXWfrLXA7PabhVTFsCkeGDFhxnhWUDp1g6UgcpgjkdDxjgn08S6ukYktBB0fxeZ1nR87fiLUM8jZQJcuMzR5HLx0QS3JbcEKb6xiw6jsRzgIiAUbt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VtS+W+uJ; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ab39f84cbf1so988800766b.3;
        Tue, 04 Feb 2025 01:26:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738661163; x=1739265963; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eZepQE8ATxhdhl2/9eNZi/ijc5MSv3CHMhMwgnFtZgo=;
        b=VtS+W+uJWqncbjUiq8cBr55i3eAsZv/LoNU9mzOVhytbuxJlUSk6B1pf4KbTse7OGL
         q5smVGfLvpTvq39FQRO41Dn9uoYRnnmwRumq7aDpwNGv5MhodN/90t5ZJOX/sY0BtMeL
         LZdCcQz9QjNiX2zW8JLhGCRzPj3kyBPe74QEg+166AzyKuiCjnrif24yQm/jVCKlqlV0
         7iDqMcgWBdvxgB9CGpfcQ8Q69LsbPvRw0j+VNPgDA9+jxD0jn9mRtxr9yGT9T/4ooJV9
         zZcUolOyiRwpB3kDSjES8ZoKoifdvmHGyypfYWsxStaq3iajyahhZHcWncnNSEvipZxY
         Hl1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738661163; x=1739265963;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZepQE8ATxhdhl2/9eNZi/ijc5MSv3CHMhMwgnFtZgo=;
        b=VRW5b+6o9iAU97Nvs9chPN3rVzroJI8Wzvw6fjFWOSj/ZPdjFlKtRhFUFDczpW2eQd
         3iOS/dP7pss7G+h/qL1rJRYc1qHEvEmtMvLi+1JaMQ/047E2IhFHbrlFLkQ6NpqaYIJo
         b81VnXScpQuV7SiOctCSVFVp+tPnFD+LbJoqz++iRqsbW3ieE+NZbgm9NkRfZwi8mOm0
         spDO5dZ5MbFIBBak0KV0qQLP8WuLHW4ZWsrDL8D8RV4B6m0g0HV0To62oF+TzGog1HbP
         /x5bFhfkAbQvw+5+l18iFvC8wJ0TFKIFO79R8UQDno3n+8LMBGxBfreSapRxmJOlfW3g
         48Uw==
X-Forwarded-Encrypted: i=1; AJvYcCWmKfKOkRHLFWhQFg6c9bjojUSaJ+3XIDwac68I/hninJf29BcWwvWbREQxQqU8AW1tNrGpvot9bZCqGoU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx1LgC96X65YMC62LR6a9mazEYbDIiiq5de8D/ZLlqnVvFRmZh9
	9L4E/dFlbzmRt2das3iwZcc21CdBlWAYuXZXeCIwEGekTOUgi1J/
X-Gm-Gg: ASbGnctySS4zYPt96ZgL2jam2TXoCmrMl+5Pi5834fr8WbgYv7+rwfR6+XTtw6R3zyl
	V4T1oxvV4kTfie8PeFXezl2Duzjgjcq/vA7+B9PJDMS/bmdnhApbVPJFkzoHCHIrrlbntRw6hJG
	OJj8PZVGTb+u7J5P5LlukZ0W0XOqIFvc76JDTyYlZgkQWrTqnqAntFx+pfwPK2e86aPXmFy7wRi
	wjSj2W4SKbaXZlPkjXU7tJcNKNkAd10PO+4FR50oE0m5Ein+J6YOj/D0nNXj7plxj2TwweHIidl
	YwUp6uKibAo4nzBU2fUj/MlAccy9JE8l93wGWX4evmv4YNs=
X-Google-Smtp-Source: AGHT+IHea567Tc9kQT3q3eSxLmJX9qtB2Hl24o51Jk9ZOWjMhNbOukk4ehLZB3YlafJ7jFl6r5Y4Bw==
X-Received: by 2002:a17:907:72c4:b0:aa6:5eae:7ed6 with SMTP id a640c23a62f3a-ab6cfce8dbbmr2576618066b.13.1738661163361;
        Tue, 04 Feb 2025 01:26:03 -0800 (PST)
Received: from [192.168.20.51] (54-240-197-238.amazon.com. [54.240.197.238])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab706ce9a53sm634409766b.72.2025.02.04.01.26.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Feb 2025 01:26:03 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <99ad4b92-7598-4ee3-92da-60efb87d08f1@xen.org>
Date: Tue, 4 Feb 2025 09:26:01 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 05/11] KVM: x86/xen: Use guest's copy of pvclock when
 starting timer
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+352e553a86e0d75f5120@syzkaller.appspotmail.com,
 Paul Durrant <pdurrant@amazon.com>, David Woodhouse <dwmw@amazon.co.uk>,
 Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20250201013827.680235-1-seanjc@google.com>
 <20250201013827.680235-6-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250201013827.680235-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/02/2025 01:38, Sean Christopherson wrote:
> Use the guest's copy of its pvclock when starting a Xen timer, as KVM's
> reference copy may not be up-to-date, i.e. may yield a false positive of
> sorts.  In the unlikely scenario that the guest is starting a Xen timer
> and has used a Xen pvclock in the past, but has since but turned it "off",
> then vcpu->arch.hv_clock may be stale, as KVM's reference copy is updated
> if and only if at least one pvclock is enabled.
> 
> Furthermore, vcpu->arch.hv_clock is currently used by three different
> pvclocks: kvmclock, Xen, and Xen compat.  While it's extremely unlikely a
> guest would ever enable multiple pvclocks, effectively sharing KVM's
> reference clock could yield very weird behavior.  Using the guest's active
> Xen pvclock instead of KVM's reference will allow dropping KVM's
> reference copy.
> 
> Fixes: 451a707813ae ("KVM: x86/xen: improve accuracy of Xen timers")
> Cc: Paul Durrant <pdurrant@amazon.com>
> Cc: David Woodhouse <dwmw@amazon.co.uk>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/kvm/xen.c | 65 ++++++++++++++++++++++++++++++++++++++++++----
>   1 file changed, 60 insertions(+), 5 deletions(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

