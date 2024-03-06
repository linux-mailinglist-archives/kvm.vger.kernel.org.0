Return-Path: <kvm+bounces-11157-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 026CA873BE9
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 17:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00DB91F21505
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 16:17:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7417136661;
	Wed,  6 Mar 2024 16:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JB7MyXIU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801DC2D7B8
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709741859; cv=none; b=f3nQmKddGE2p+N/6xfFqo8enFyRM0LAnFa7eJT8MlMAh4dUyEy9a9su06T9le09nteakGszNnCpUy17EZGJGr9XuNMfukGsZKm4Rf6jMSWuTBBlAmF2CIZdcQw8kBOy1K/QZAEu4akjW/1AfHCwRypuDNKQ2ULzNWxdDMBrUFpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709741859; c=relaxed/simple;
	bh=+D2h24fGZtb+G9V1cxn4axbIUMyFdhvcMO8hqWRbMM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rjMXBeLrJIyhAKS/kAfJyqSETAL6ZQjN7r6vcl8pxIR+fi0yGZWhsvVogugO6Sb9Sz56RJQGVnBsNcgrtK34TA+JlWau/FkynnTyVyvniUDUyosRs+i0Rsth0dSHJkVyFtTi2NBGQQnz25im4SVxPDKTwaJrFVi7sOGPUVBwI8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JB7MyXIU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709741856;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5aQNGuV01RTwG4kKUb3wU3nGLg7WahN0q+xF2TWObO4=;
	b=JB7MyXIUCQ4364bvg00NK5O3LYfEo2lPdyK7KgnkhoaHOJncf20fafkmgs2QK34Z31+74d
	11Z2ADNX3ZJ2BKubE/7gkWwO6r/vb0ea1trQ2BBY8K6W6Sds07EhXJ8qpWbevzuTjHq2Mv
	nYwurMKrdqMs6AR0Z3lm0FAsqaD8/Rg=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-BVAXcO_gOD2XbXgLNcL0Fw-1; Wed, 06 Mar 2024 11:17:34 -0500
X-MC-Unique: BVAXcO_gOD2XbXgLNcL0Fw-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-513332823cfso2083275e87.3
        for <kvm@vger.kernel.org>; Wed, 06 Mar 2024 08:17:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709741853; x=1710346653;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5aQNGuV01RTwG4kKUb3wU3nGLg7WahN0q+xF2TWObO4=;
        b=H0uqtOu83Z80+8+4E1qm58nW/itKlnqGTN8hGDiaWGq1ZjE65TKMKeNq5xNSEwsoBW
         kQ57AP60e1yJIP3zKpRp4oRtkuINdOz6yL3m7G0BIbYSo8GkQrsoB3PtpDCMxBS9ZXzH
         9tZhkZKk81zJVp8ittgZproi4B9MEPuDSCmcVVRoheUWZ6e1X1R0bSB1QWRZV3yVTC3c
         ROCZmb53v35cAFRmsSdmnOUgDSEG8x5cmmAd/lHYvmUfjBSL35PyGz+NHP9KMeWpmIFb
         LZSLLwvBVzBEfu8ByG9qGPlzn2s9pUfHYz3IR3Pd5kJEhKq5TGXXBM5rvIRQu+D88KNA
         +qrg==
X-Forwarded-Encrypted: i=1; AJvYcCW+wmZ0ZQOb6xOZPZ+HFVeaJzyshAJsllAXoBvSUWilU5q2ypmE1yqOJEzbOdfURK6NyD9yWnLSovpZcNLSdRInGrhu
X-Gm-Message-State: AOJu0YydwHwdoFppeVZTZGymn1TlSgrNr1HFWjB42YBtG18plWXxZhP7
	cw7lh4cFAIStj2CRPM4zSK13kc/Z9k330n1lXMIHvH1KlnkukVuzD/TplSqCFWLvi6+ALNgQQ6z
	DW9A+z/leuAN9NGJDeF/vz1sEYUV+NsWN6eKKBWbLqZCGTtV4/A==
X-Received: by 2002:a19:f806:0:b0:513:4705:a4f3 with SMTP id a6-20020a19f806000000b005134705a4f3mr3407232lff.65.1709741853444;
        Wed, 06 Mar 2024 08:17:33 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEVXtlo5GmRAhd9UJW8Q66n6wmSJzzI9FhyQJf7Q0vCVx4xcdodUO1LtZKnnPF6787iV5+ghA==
X-Received: by 2002:a19:f806:0:b0:513:4705:a4f3 with SMTP id a6-20020a19f806000000b005134705a4f3mr3407215lff.65.1709741852972;
        Wed, 06 Mar 2024 08:17:32 -0800 (PST)
Received: from [192.168.0.9] (ip-109-43-178-151.web.vodafone.de. [109.43.178.151])
        by smtp.gmail.com with ESMTPSA id i7-20020a17090639c700b00a45ae9636d2sm1486501eje.107.2024.03.06.08.17.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Mar 2024 08:17:32 -0800 (PST)
Message-ID: <01e2d014-9fc0-4a3c-9152-19c6c373269c@redhat.com>
Date: Wed, 6 Mar 2024 17:17:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.1 04/18] hw/usb/hcd-xhci: Remove XHCI_FLAG_SS_FIRST
 flag
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Igor Mammedov <imammedo@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, kvm@vger.kernel.org,
 Marcelo Tosatti <mtosatti@redhat.com>, devel@lists.libvirt.org,
 David Hildenbrand <david@redhat.com>, Ani Sinha <anisinha@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 "Michael S. Tsirkin" <mst@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>
References: <20240305134221.30924-1-philmd@linaro.org>
 <20240305134221.30924-5-philmd@linaro.org>
From: Thomas Huth <thuth@redhat.com>
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20240305134221.30924-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 05/03/2024 14.42, Philippe Mathieu-Daudé wrote:
> XHCI_FLAG_SS_FIRST was only used by the pc-i440fx-2.0 machine,
> which got removed. Remove it and simplify various functions in
> hcd-xhci.c.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> ---
>   hw/usb/hcd-xhci.h     |  1 -
>   hw/usb/hcd-xhci-nec.c |  2 --
>   hw/usb/hcd-xhci-pci.c |  1 -
>   hw/usb/hcd-xhci.c     | 42 ++++++++----------------------------------
>   4 files changed, 8 insertions(+), 38 deletions(-)
> 
Reviewed-by: Thomas Huth <thuth@redhat.com>


