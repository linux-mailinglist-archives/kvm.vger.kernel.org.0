Return-Path: <kvm+bounces-34359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 608D79FBFAA
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 16:31:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9B6A61884951
	for <lists+kvm@lfdr.de>; Tue, 24 Dec 2024 15:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D3F11C5482;
	Tue, 24 Dec 2024 15:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hpBS6w/U"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D7A14287
	for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 15:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735054298; cv=none; b=eJCuYgeJdDlrYzS8h7oCBjwMMr6iGUqUXA67k30oltGWCC5103vMj2WZ9latf1LfJbC5mpn0if2M/qCdsvroBc2bsH19NkKNFoOKY9KphP7jIa1cGl8pMdDoH9zK101QfmETI8Cw0cavjU1UPBHbbSh7N6JweZzyLi0U5S732gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735054298; c=relaxed/simple;
	bh=Wg31Gf3NmvgcYcUO+WAXDMYCTIUvodKz27RIL0bSJPI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttvsJwqkJZtJjLrKni0OW3QDHRRPnC88fduK+DZ92I/fKCwgT+kMgAuYplTqPW+4xfxUzoleTHGrC0sQogmPrIwlAxdJ2v//iEdbxJ2icZ1bfa6oL7tgzCiQAGcW284A9ImhXvo1issESUvu/4c3Lsp2nRPlPlzp+RdUOHhWUm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hpBS6w/U; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1735054295;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sttA86JlVJRPGR1pZfidlTi6I1TCvbAFziqdjrjC9pk=;
	b=hpBS6w/U396GkCa4jjI+ojdGx9IaLauhzEaF8J+Tvv3XPjuK2UgMxKkboACPCxJe8M4b2+
	oE8s4LXu9KuUl4X4E9WqQF+O+eMFmDMqrIVTaAOV7WQjqd/orY7gQgItxFw2Jf3IyHiGiD
	qDMCX6jEXiTKpy6180IRBN23loXz4Xg=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-103-457ObTcBOG-6zbKaKcGFMg-1; Tue, 24 Dec 2024 10:31:33 -0500
X-MC-Unique: 457ObTcBOG-6zbKaKcGFMg-1
X-Mimecast-MFC-AGG-ID: 457ObTcBOG-6zbKaKcGFMg
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3860bc1d4f1so2978661f8f.2
        for <kvm@vger.kernel.org>; Tue, 24 Dec 2024 07:31:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735054292; x=1735659092;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sttA86JlVJRPGR1pZfidlTi6I1TCvbAFziqdjrjC9pk=;
        b=DB9nX2ujOZdlw0yEsXJw9EeyjE5AWmYn6DCpYBRSsI1iDvWoqgf/qvPS5dkfZ1ulFZ
         6SugSjn/elAWwFGWZkF8t/8pwqxc3atAztw26yE6LaHAaRah3MEb0hL85kgnFqI/+Rfv
         QQFNq0AcPtyQcxkbdnr9h6QOxyMYit8gXn+3mwaqEhKCa0/nKdeYHcBl0+2yOK16e2J2
         UvcafwkonKlGdDxUaXvY4GzHiQLlMCcN1vgvUVR0dT6pYeltKNiwp3sf+qLYmK19A2C0
         C+wtes+ZCuSnas0SmBW5mXnCncvr8K3aaFSD/SX6qhki7SXlmJR9y5bDhXoOtCobxLEv
         ttmQ==
X-Forwarded-Encrypted: i=1; AJvYcCUfIErwoj/C/wFA2P5Wc0HFmU9zEpG+pH2iv13QI+x3s63no+bmWYk7gXQ59Wdj/cjGifQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzOVziK89CUiSIObJQSP36EBSoiC7HZ+bkxCh8k8pWaDtGG4PY5
	Zy2PkWG9KX6TkwgW2aa8gaDGTeTj3i6wJpghb+zPOgHJJtHQAJZ2uGsEZz4hjIv4K1xVctyOM79
	EM0rWTy++E4sU/nto2v6z84/OiuXNjqeHStKIkNZgiK/ZtmRp+A==
X-Gm-Gg: ASbGncsi5yvzg7BYECt5CJKcLx+pMGURbo1PlUcMyQ8CMa79+0PNPIZEAKlwZYcwPNi
	PzU6pnncYGgqgG32fim/kQRDOG2PS4nGmp42CicVUm6aIH8cfYg7MBsOR9ILI3RdqSlzaWtnY75
	L49odtkAkQd57lUZm/dPBq+eWYa0tTjrrAUy2KbbxO909CPzwxlD7/5X5fgEKe1TJFkyw1cnxYF
	AeigvsctKrSx4TGEFwX6DY3MQOZCYnrEFxg8Eq/Wwt8rzQTKGvuTo7T/fuO
X-Received: by 2002:adf:a453:0:b0:38a:2b39:679d with SMTP id ffacd0b85a97d-38a2b396927mr5880324f8f.32.1735054292546;
        Tue, 24 Dec 2024 07:31:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGjDev92cI1a9hEfMDA+fr2hM4oSjxKaQxdL1upD0q+0U/fRFDrGLeO5ylm0YCPlcX6RSvckQ==
X-Received: by 2002:adf:a453:0:b0:38a:2b39:679d with SMTP id ffacd0b85a97d-38a2b396927mr5880306f8f.32.1735054292219;
        Tue, 24 Dec 2024 07:31:32 -0800 (PST)
Received: from [192.168.10.27] ([151.81.118.45])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-38a1c8292adsm14314648f8f.19.2024.12.24.07.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Dec 2024 07:31:31 -0800 (PST)
Message-ID: <9d60933c-4713-4d61-b11f-64d4bb667e04@redhat.com>
Date: Tue, 24 Dec 2024 16:31:28 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/11] target/i386/kvm: Only save/load kvmclock MSRs
 when kvmclock enabled
To: Zhao Liu <zhao1.liu@intel.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Eduardo Habkost <eduardo@habkost.net>, "Michael S . Tsirkin"
 <mst@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>, Tao Su <tao1.su@linux.intel.com>
Cc: Xiaoyao Li <xiaoyao.li@intel.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20241106030728.553238-1-zhao1.liu@intel.com>
 <20241106030728.553238-5-zhao1.liu@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20241106030728.553238-5-zhao1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 04:07, Zhao Liu wrote:
> MSR_KVM_SYSTEM_TIME and MSR_KVM_WALL_CLOCK are attached with the (old)
> kvmclock feature (KVM_FEATURE_CLOCKSOURCE).
> 
> So, just save/load them only when kvmclock (KVM_FEATURE_CLOCKSOURCE) is
> enabled.
> 
> Signed-off-by: Zhao Liu <zhao1.liu@intel.com>
> 

The MSRs contains the same values as the "new" pair; QEMU only has to 
save/restore one of them but the code should be active for both feature 
bits and thus use

+        if (env->env.features[FEAT_KVM] & (CPUID_KVM_CLOCK |
+                                           CPUID_KVM_CLOCK2)) {

Paolo


