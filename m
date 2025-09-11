Return-Path: <kvm+bounces-57334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BD7B7B53885
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 18:01:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBC863BB041
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 16:00:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98C335A2AC;
	Thu, 11 Sep 2025 15:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SOF8lDfV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841DE35A290
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 15:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757606358; cv=none; b=I45m/nh95l9szQXCZz4Z2gZJ2FF6nZCbfIAxVUn3uuW8AUkGkEpugvjbV/aJ3pH3fbh2KW7NFI7NiFvRRrjvp5cccO2P15exOSZC0gagxM+5qFLj3CjgdQ2CIi/fs+tp8Iz6HKLQYLzW69vf82WOZGKn9TJXW3w/jzUiCL10BT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757606358; c=relaxed/simple;
	bh=+keLsDcloT+l1tCpllvPad+fvbNkbpnm2LprNAM9gj0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=jNxLegxATJUpMhi5d02Jg4Ek7UAPLz2/b0P5bmaIcvvWLXOvWzKv+5PJTWU4BZK0WX+EmupA0jZflLU6AMBvW5dHtxz93AgudV7EWrdxgc/VKv9ys6BU+d8EyqHePrfvm/cYSizaXPlIaonxSy+JavDl61BHbNCVSLAn4Ljpagg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SOF8lDfV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757606355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m5Gl87lWcfunzoYrVE0pRSftB8AHiSUHljE7szKd1ws=;
	b=SOF8lDfVrWfTTzp53yPRKXlLjiRp2VBx6MftptPIP10BBq+fVnLRnwBOJccXerkkAzcDVS
	xjiMafgQH8qrN8B2Juno38aUtIA+WksjXklsdEsqqxo+vjXm+ZTP4/2f17DBHlJDsvyQYl
	ltpoadxoOgaIXrLUQB4EfYgL6jk3F4U=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-166-Xm-TwT6CPX-Vz7R9LGIrSA-1; Thu, 11 Sep 2025 11:59:14 -0400
X-MC-Unique: Xm-TwT6CPX-Vz7R9LGIrSA-1
X-Mimecast-MFC-AGG-ID: Xm-TwT6CPX-Vz7R9LGIrSA_1757606353
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e04ea95c6cso444662f8f.1
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 08:59:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757606353; x=1758211153;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m5Gl87lWcfunzoYrVE0pRSftB8AHiSUHljE7szKd1ws=;
        b=a9L8jQ7UknAITj9Q5bhb5LSrjK344UMKCo2/tAomiTI53Ck3Dj46xCyo022Xtjl7Vm
         DkzF+3rLyi8xII+Gb7AzI3sJUIGWT472GzcfgDoeauHQi4mNkyLtN8QYM4xRpQAftG9i
         Dbd8ggVJOL87QcCThcSEezmPefxw2+CJl92SZnQLmFKsG0U7p32CcNhMKq0ta59EZJAB
         W8nmSJStyPg2rXDtEHv+88tEUnVAQ9S7t6Qy3Gv1YBIwz0O+0uu8s8CzYlyZsAax8OU5
         UtsUQF0HvTlsA2KW59Fjz8Hz5K37eRd3Lhq6cqi4AVl8WLidW9U+8xfz9pl3Jzcd6puK
         TDtA==
X-Forwarded-Encrypted: i=1; AJvYcCUOkDkS9vPTWd3Cxy3vjfRKpzDg/AqocIZj881XJPo2wL7WwVhGbVhI3OFj0CEm9AMU4sY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzMD3g9O2piFGbYNE/+XyRnC/WiYBzcizENcRm6YQFX1oshey5x
	Cvs8KOsVY+FYqJHvIVKM9StrKFwEsEiBog5nmNfnYrm8BRZfbDVm11OU9ZZKGEpQd9dotH8yOBW
	9XH//qPXOi8cSp5AsQTctWlpx5KVUIAbVOF1ZFrUnBsy7evuLGchw9Bu5B4ZQhw==
X-Gm-Gg: ASbGncvFtdMfulSL6Jq9tBLx535vzNMTRRB4W3LaeM16YeLq6NV3XII+naEgA6PNK8p
	Px1SOlf1EIhkC8K4pAMyLcFwUD1wBjEP2uQd2bmf83sG9QmoVZjWtJv0JSicc3vPdXcC0IM9chW
	RmtABohrNNh57+1w+Jx6BY/Kc4MuXpTbFDJ7Hywc/XeUt5UPCKD1wGsQa3GBIlcwuC8yZACOdXA
	8pkXCDyYr8FFx2VulCPuWpASh+i8PJj0m3nmoQF4oWyEFDY4XYNKzr3gY63BI/7Lmvj/1YN87QW
	gSaT/RCUHcF8rTqsDOlwr8rAHjdYdqtmJz+4Q64s7LFHOyp3fDCh0Njp82icB4uxVbJlJ7O/pqU
	SXiK+9c5+fa7rVQ==
X-Received: by 2002:a05:6000:2c0c:b0:3e7:468e:9327 with SMTP id ffacd0b85a97d-3e7468e96a8mr14020609f8f.2.1757606352715;
        Thu, 11 Sep 2025 08:59:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHSrB5/to6QW2nPvAuUd/WlR4t/Ppb/lRN0E5cuL+7TESs6xG+MxArSdkCRJmxRGYUa2+tbqA==
X-Received: by 2002:a05:6000:2c0c:b0:3e7:468e:9327 with SMTP id ffacd0b85a97d-3e7468e96a8mr14020593f8f.2.1757606352333;
        Thu, 11 Sep 2025 08:59:12 -0700 (PDT)
Received: from rh (p200300f6af131a0027bd20bfc18c447d.dip0.t-ipconnect.de. [2003:f6:af13:1a00:27bd:20bf:c18c:447d])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e01865ff7sm16651975e9.2.2025.09.11.08.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Sep 2025 08:59:11 -0700 (PDT)
Date: Thu, 11 Sep 2025 17:59:10 +0200 (CEST)
From: Sebastian Ott <sebott@redhat.com>
To: Peter Maydell <peter.maydell@linaro.org>
cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, 
    qemu-devel@nongnu.org, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
In-Reply-To: <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
Message-ID: <8bca09f1-48fe-0868-f82f-cdb0362699e1@redhat.com>
References: <20250911144923.24259-1-sebott@redhat.com> <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

On Thu, 11 Sep 2025, Peter Maydell wrote:
> On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>>
>> This series adds a vcpu knob to request a specific PSCI version
>> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>>
>> Note: in order to support PSCI v0.1 we need to drop vcpu
>> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
>> Alternatively we could limit support to versions >=0.2 .
>>
>> Sebastian Ott (2):
>>   target/arm/kvm: add constants for new PSCI versions
>>   target/arm/kvm: add kvm-psci-version vcpu property
>
> Could we have some rationale, please? What's the use case
> where you might need to specify a particular PSCI version?

The use case is migrating between different host kernel versions.
Per default the kernel reports the latest PSCI version in the
KVM_REG_ARM_PSCI_VERSION register (for KVM_CAP_ARM_PSCI_0_2) -
when that differs between source and target a migration will fail.

This property allows to request a PSCI version that is supported by
both sides. Specifically I want to support migration between host
kernels with and without the following Linux commit:
 	8be82d536a9f KVM: arm64: Add support for PSCI v1.2 and v1.3

Regards,
Sebastian


