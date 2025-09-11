Return-Path: <kvm+bounces-57330-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F3729B53777
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 17:20:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 490577B93E1
	for <lists+kvm@lfdr.de>; Thu, 11 Sep 2025 15:18:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E5BF34F497;
	Thu, 11 Sep 2025 15:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Sfxn/A3N"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D916C3203B4
	for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 15:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757603897; cv=none; b=QBovGHBRd2pTeaxaubtXK5UlQw0te3TJxwSmXnaXE3zUHsfq81COOmihRoNmaURvB3hQjQbTA3PZiyF54Su5M3lsMEpblptj0lUR4/bc/Bwrn5I3L6oFGYWGTDS+3LqWw4t+ehOCA3/6GuNXybzyatV4h9NUiIkt3dJiLpApEyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757603897; c=relaxed/simple;
	bh=4kGiMNWl70c+t1jpo2wDVgJIIXlrUNj+YdEfV+tcftE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=upVydareKCRwKiq1Outtcw4AbJV9kkkBuT0jMl/aZX6XMKNjlEHWWEO5Ytq9YUd9jxI+MFJ5m+KNXrhpGRIVakoPt4Nlc0AvPbOjrUHGleUhqcxmORX43vF/57kxphpLHQTHmXHES6lLABpGC+c7NZ3lD5MUVIzRCL+0F6rfnN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Sfxn/A3N; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-71d60157747so6311517b3.0
        for <kvm@vger.kernel.org>; Thu, 11 Sep 2025 08:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757603894; x=1758208694; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=knG17Yq8OEl51CMsovL2EtZQpAt43iivBldwrOwPUGA=;
        b=Sfxn/A3Nng3qfH+65OF1hOz95AOOfKEqAyalh22622ATKtkl4jPEKyUjrJJ1EVzq/Q
         HJ1tJ9VUkTKxf7LGue83GmCTpGm4VGrUJeTUM2Kd2S5l0cmJSnHYl9+bc43rm5/9t/8u
         5f6d/SJT655+gcQmw/89nEaJJu3NT6q6BK336jN9CXgF/f3Hjm15b241xSf8yqtLwDrp
         PSXJLl0xNPCMCjmjze1OH3CV5p+wAaV5/KqeTO+5hkArqYnzPi1+wniM9/9a0ob9/YCg
         oxVkpzSZQQpZ/Tu4SdtAIFesavOU6Gg+jaJllLeDySCVZLnTNhazXpAQ6gV1LlbsNLzY
         Fkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757603894; x=1758208694;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=knG17Yq8OEl51CMsovL2EtZQpAt43iivBldwrOwPUGA=;
        b=krOuPkLdFZ5Mzv5HQCEXPW5mU2deiyiyhXbuF4ByPEuypmmam8KH5oBg7Vv+n3tgZ+
         JE+HDJvC6rPrr4J3zQVzeo6ecba318g+IoW1of8gpadjnxkA6vRCyDXTWnFce/P++hcB
         j12uRKVOJk1lsRhXKO+AXyN/NTxFkUhZzeVxlTLzcgZ7HAK2wlI3JC4XZPaVnmPZIqer
         rn3+QEKYNRuCaRIn//fNjQw7TZYVE9gdayM8969KDaybV+vvwjPcIrx7LswUZ8L3JY/K
         GJHlXl6ruCgO9zgZxHqgj+GuvXfM8bnx0s+fXxeReBCWhihFSah3QePDRx6nWOgDR4GJ
         dCcg==
X-Forwarded-Encrypted: i=1; AJvYcCXYd+/Pta0rD0BOPxiFaWAv455rh6VnampekyENLjyOmOC1qEK+AI8ZdlWaXZBJU1EPhY0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyaCV8EF78F0kiyJ4xDATBOy0ptADtalV7UVLBoFpIASMf0AlrH
	P0QDP9hLID3ilBXwGDBQdkq5QuBedqf/sNIAbcWjtfYNsJOR+W3C+bpvdcVkmFiSpp5KAb4DTCk
	Ymjzl4fLvW5b3FgzfAvenN+oq8nDjNySJXo2z2V9OGA==
X-Gm-Gg: ASbGnculr9S6IHFiP2M3y/05RpkorRAzAsy+TTOOyBgFttyur3tJbo6iqHj+LP0vfqL
	v+Tq7jK+Rytz7DDtE8mXwkKOiqrDyle9LiAEfr8ffO5e6BJOo1cPnVz/Ke3cpJsg8PqA1syJLv6
	0GOXI3r+ajI8OUJVoxFE/Fah4FSAKD0Juvt9xbJALkyPrw/USh8Metn46ukl2Ieye9UG5jr1Ogu
	Ba/dptHKUk7x0xPsdU=
X-Google-Smtp-Source: AGHT+IF3H557iKfUovfqwt2gL5bCvaJImvBqsOCUlSfE7rbWLqZkyw3UKcIFfROpG6jQIj6ebdJJMvpqUVlLx0flUXw=
X-Received: by 2002:a05:690c:b9c:b0:722:8611:7979 with SMTP id
 00721157ae682-727f534c628mr212302917b3.26.1757603893463; Thu, 11 Sep 2025
 08:18:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911144923.24259-1-sebott@redhat.com>
In-Reply-To: <20250911144923.24259-1-sebott@redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Thu, 11 Sep 2025 16:18:02 +0100
X-Gm-Features: Ac12FXz6fXkfCmLnxnecWlBKlTxswjmrip5hHL8mvpSj6aSPT4PhMhm5w4RtkfM
Message-ID: <CAFEAcA8EDJT1+ayyWNsfdOvNoGzczzWV-JSyiP1c1jbxmcBshQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] arm: add kvm-psci-version vcpu property
To: Sebastian Ott <sebott@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, qemu-arm@nongnu.org, qemu-devel@nongnu.org, 
	kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Sept 2025 at 15:49, Sebastian Ott <sebott@redhat.com> wrote:
>
> This series adds a vcpu knob to request a specific PSCI version
> from KVM via the KVM_REG_ARM_PSCI_VERSION FW register.
>
> Note: in order to support PSCI v0.1 we need to drop vcpu
> initialization with KVM_CAP_ARM_PSCI_0_2 in that case.
> Alternatively we could limit support to versions >=0.2 .
>
> Sebastian Ott (2):
>   target/arm/kvm: add constants for new PSCI versions
>   target/arm/kvm: add kvm-psci-version vcpu property

Could we have some rationale, please? What's the use case
where you might need to specify a particular PSCI version?

thanks
-- PMM

