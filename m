Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78D04691F7
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 10:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239961AbhLFJJ7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 04:09:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:57572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239928AbhLFJJ7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 6 Dec 2021 04:09:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1638781590;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vVIHKBsFBEu5zZ965qZJ2FXtzIGfRwaA3qUe2cZhBzw=;
        b=fgPsjWeqvcfWVYt/LyMoMyOq0WW4xsr3/P09RYEhq4745kcHb5XPaW73KlsHJ3BZ9VdY0O
        u3aTdVKhNhk27EDHlnUFfYlCirj6tH6PcrywWliRnBqyAkfu1pOEbME9v7UHBv7POYZJjZ
        AgE/Y1gwXvTqwZIzlZjCqqIp5MLAny0=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-231-kEG1AlYLPzCQKNzj3e8CIQ-1; Mon, 06 Dec 2021 04:06:28 -0500
X-MC-Unique: kEG1AlYLPzCQKNzj3e8CIQ-1
Received: by mail-ed1-f69.google.com with SMTP id m12-20020a056402430c00b003e9f10bbb7dso7746364edc.18
        for <kvm@vger.kernel.org>; Mon, 06 Dec 2021 01:06:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=vVIHKBsFBEu5zZ965qZJ2FXtzIGfRwaA3qUe2cZhBzw=;
        b=VEAhtQaOt18HVdKMfjgxy1qMYn90EFoanB1coBXk03VUIf+Tyf2uIxJDLg1aX5NZ2v
         CaAFgKPco7aUiB9BlDStkV8i8Dew8+tFtkcCpqtEgRgXl6k6VXiIAq7lGtKzBRYwCyqw
         gBDICZrQejXstCpjOV4hwMmWnKI7l2dQFA1GEeFzZiHVjfFSC2x+wMjuAeDonbiiBduI
         1jaIaPOylazAnhzEdvUSuJ1g8c3AgOAj4auDS8N1OyzIpkcMMyeWn2m8RFj4pO417Zjo
         YESUtADLrA1GeTHo4aL8A/1sU9nhTGkkbw3G2R0N3ki26edsjzLDeJUmBddIqwIW9m/4
         CfQA==
X-Gm-Message-State: AOAM533iKUWecqqLNMLHCr4MolGS5ogBdsGpDuk6fWTUXmt5EakuGb7R
        dAy7eBL6VYXWdWqRtvBOwi3kDwgYZhlUOckmzC0BJfkqQfA6YlFp4x/G87INTFpKszw+mUGm057
        zVjgeJP9+KZTi
X-Received: by 2002:a50:9514:: with SMTP id u20mr52142564eda.117.1638781587837;
        Mon, 06 Dec 2021 01:06:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNCU153xrFqJiuFOZtm9RCUodEdli+fDVWDvQKBTNgkxa9VBQ5k3uG8wPNQRYAsOJmsj2Jeg==
X-Received: by 2002:a50:9514:: with SMTP id u20mr52142542eda.117.1638781587686;
        Mon, 06 Dec 2021 01:06:27 -0800 (PST)
Received: from fedora (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id h2sm7467053edl.85.2021.12.06.01.06.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 01:06:27 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Ameer Hamza <amhamza.mgc@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        amhamza.mgc@gmail.com, pbonzini@redhat.com, seanjc@google.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com
Subject: Re: [PATCH] KVM: x86: fix for missing initialization of return
 status variable
In-Reply-To: <20211205194719.16987-1-amhamza.mgc@gmail.com>
References: <20211205194719.16987-1-amhamza.mgc@gmail.com>
Date:   Mon, 06 Dec 2021 10:06:26 +0100
Message-ID: <87ee6q6r1p.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ameer Hamza <amhamza.mgc@gmail.com> writes:

> If undefined ioctl number is passed to the kvm_vcpu_ioctl_device_attr
> function, it should return with error status.
>
> Addresses-Coverity: 1494124 ("Uninitialized scalar variable")
>
> Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e0aa4dd53c7f..55b90c185717 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -5001,7 +5001,7 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
>  				      void __user *argp)
>  {
>  	struct kvm_device_attr attr;
> -	int r;
> +	int r = -EINVAL;
>  
>  	if (copy_from_user(&attr, argp, sizeof(attr)))
>  		return -EFAULT;

The reported issue is not real, kvm_vcpu_ioctl_device_attr() is never
called with anything but [KVM_HAS_DEVICE_ATTR, KVM_GET_DEVICE_ATTR,
KVM_SET_DEVICE_ATTR] as 'ioctl' and the switch below covers all
three. Instead of initializing 'r' we could've added a 'default' case to
the switch, either returning something like EINVAL or just BUG(). Hope
it'll silence coverity.

-- 
Vitaly

