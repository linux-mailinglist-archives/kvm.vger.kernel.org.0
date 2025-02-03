Return-Path: <kvm+bounces-37121-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4AB2A255BC
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 10:22:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6CD743A8893
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2025 09:22:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 862CD1FF1D5;
	Mon,  3 Feb 2025 09:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X6LBmSnq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA8E1D5AA7;
	Mon,  3 Feb 2025 09:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738574534; cv=none; b=mr0EJWyEd5Wr2IoXizSdtBBLBm+HhrUjJ3dbf+Nnxz5sxRMesh52L1/axQ8YaABvDXICCuEJTaVNrMjSjOoX0Hc3xzjXf6VheVIsd803QywK+lg5GOmJvtQ5nDe6CdzV41jVn72XeY8d12G3rQ/o2Wlnydcya2n/+TAZu9TzYc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738574534; c=relaxed/simple;
	bh=20W7wg+ziUDqOb4d3gSvJEsK4QMpIiqm3uhJH5quZuk=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=P5cyM5HXztuAOh94cTuW3inHb+RPwYr+aHoNFxTDuc6ybt/HAEjxNJBeqwLVkQcu7h6iI9icUmk4JmA2hSsLNW7zqWbDw/3EBcKUd4Ctn37GpJitHu3cJ5XsEVuIWi+68OposuxSFBdF0bt2OPjW02xDDnF0PUOb0uDbqQar4Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X6LBmSnq; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-53f22fd6832so4647265e87.1;
        Mon, 03 Feb 2025 01:22:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738574530; x=1739179330; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yIXWEX/fki23xEx1MTLR8DwGT+6Sp3aUsbK+iYz9lnc=;
        b=X6LBmSnqdNrpDFOl9BWECMWkNqK88JdeAwKG1aRsLXCDWZ3LZtxVxUOuMloV0dSVOc
         IuN+7Rsc8sWXOoIxCBGn2hOa3VHdZU/FJaLCEy1/2skn28qZ10oZVNkEAgEL0JKEJSS8
         ze8ZPwcoSX8RnDFr6zWjHpZnnEOUj1ey90wyCuE2fKn40pNUXNoGPtYLOMPx+0ULgCl+
         EQ1RuFeOSOddtUdZB670gGvvGMY9AFriiZGKnAEbAsjXZ7+3uk+FtRV5ZWYcsz5Cv875
         SvTRhh5Spl8+wyzKtWjcfXAJ5No5WRV3odsuTAO85WMO7Wep1LQB/x0Tl1YoeSkbUVvK
         3CaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738574530; x=1739179330;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yIXWEX/fki23xEx1MTLR8DwGT+6Sp3aUsbK+iYz9lnc=;
        b=Srv76h8chMOavo+cmLflwOlKk2z7HiyXpmm86IHddv6G2LpcXtz+gpNo0Q5eXAYdHA
         ja5t8eEKOLMgGulm/0JVvQC0CtcjVhvEmV/2QB7YEBts2wLfk2BJyU4os8fYTpQKrCw7
         IWZjdVMd12NagHXrNePRIwAsxfBSWYQJ0S3SX2+fdlOj56E4ckyIC+y7ooLANT5xzidI
         cvcasP3f8FXpXICtl1jJOG4UWIWUJDOJYeK2zaU3DCXtnd2QnrDvm05Ev2qR/0UAEwBR
         dGtRJlCgrfw9ncbDB6p2OOU3MRL6Ws0mzFczbXGOQKQQk5jsZhB9sOlFOnwf78wbrWD9
         PKzw==
X-Forwarded-Encrypted: i=1; AJvYcCWL6DkM5fHQoAsbUh8MyP0MMJlJTJdG1tZppNbQswv0s6i/HIBbBfDc1CnIJqjVWMN/01nfpY5Yj1xVkP0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzsjqPhJX603W95DmomE/NUB8NJ8KS44n10pGOEq9CwOsBiKGKv
	JR1Cjri4tQNSthm2DLWZEBJfCKoKf63NN8kEdRPERwqPWlRjcq3eohAhjkLQThw=
X-Gm-Gg: ASbGncv/cP2ArXCDr642kdWchHQ3V8Mb7LrLj5SmR2rZfDjt4WuDdMRmVd30h4F9T53
	EYnlTqcZS4E1g2ziMh8eH9fGm21jnDCiJ8C2qvPIpsw+ZRjulPWEBLlBSrxaEVkjqToOkylubsD
	vXwoDWrs8iTK91bsKrMA492HMBWey+epzVshBrwW4WQjx3Y+M9/WC4kRsKqV5ZMb3V0s6WE9bQf
	Lrc5XNUFnX1x3N/iyMQ+R7axWHUGtjT6fTODy4plVfEcCC1oqEZ+2gL55MuBUnPMLBsUMqZ+i06
	A80qj3oDPKyw91S2UKyxxrM1WfiovFNhlpL8gfAvjZMh9Bd/
X-Google-Smtp-Source: AGHT+IFAfh6CuN4mPpsqYQFFS83SrY+ks455Ypv/WyQCmUxITnet6Qhhv/Fqe8UlJCMte3/UoQr48A==
X-Received: by 2002:a05:6402:42d6:b0:5d3:baa3:29f with SMTP id 4fb4d7f45d1cf-5dc5efbf457mr22322737a12.9.1738574519186;
        Mon, 03 Feb 2025 01:21:59 -0800 (PST)
Received: from [192.168.14.180] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5dc72407bd6sm7606265a12.48.2025.02.03.01.21.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 01:21:58 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <b8aea898-e344-4fe3-813c-1fdacd337f9d@xen.org>
Date: Mon, 3 Feb 2025 09:21:57 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH 5/5] KVM: x86/xen: Move kvm_xen_hvm_config field into
 kvm_xen
To: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, David Woodhouse <dwmw2@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzbot+cdeaeec70992eca2d920@syzkaller.appspotmail.com,
 Joao Martins <joao.m.martins@oracle.com>, David Woodhouse <dwmw@amazon.co.uk>
References: <20250201011400.669483-1-seanjc@google.com>
 <20250201011400.669483-6-seanjc@google.com>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20250201011400.669483-6-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 01/02/2025 01:14, Sean Christopherson wrote:
> Now that all KVM usage of the Xen HVM config information is buried behind
> CONFIG_KVM_XEN=y, move the per-VM kvm_xen_hvm_config field out of kvm_arch
> and into kvm_xen.
> 
> No functional change intended.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>   arch/x86/include/asm/kvm_host.h |  3 ++-
>   arch/x86/kvm/x86.c              |  2 +-
>   arch/x86/kvm/xen.c              | 20 ++++++++++----------
>   arch/x86/kvm/xen.h              |  6 +++---
>   4 files changed, 16 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 7f9e00004db2..e9ebd6d6492c 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1180,6 +1180,8 @@ struct kvm_xen {
>   	struct gfn_to_pfn_cache shinfo_cache;
>   	struct idr evtchn_ports;
>   	unsigned long poll_mask[BITS_TO_LONGS(KVM_MAX_VCPUS)];
> +

nit: extraneous blank line?

> +	struct kvm_xen_hvm_config hvm_config;
>   };
>   #endif
>   

Reviewed-by: Paul Durrant <paul@xen.org>

