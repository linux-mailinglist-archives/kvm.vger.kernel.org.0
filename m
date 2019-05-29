Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9139A2D353
	for <lists+kvm@lfdr.de>; Wed, 29 May 2019 03:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbfE2B37 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 21:29:59 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38561 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbfE2B37 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 21:29:59 -0400
Received: by mail-wm1-f67.google.com with SMTP id t5so371712wmh.3
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 18:29:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=d+bGedX5o6nE+Y5FXR8KV1S9iuqLVRpYMqTJ+aAu2NM=;
        b=Juy+cKyFvcO2JRZuuh8MP5ExCj/x5eMRjNAB08SmCQnTyeKs7fKLvHV43DdM/Himht
         YFRANLWBE/wrB8CDt4G7OmmxTo1ZCfvd0P+qv1lYZSjOIpfUkfrA2ZEcEjvy83c0PC4A
         bXDaUjZNMjB0FztK2r2KdOmREKSoKDnnxr8JQNxvyO/JUF+mSChgpXl1u2Jb3bol8lSL
         FwhgQU0Nm5KelJdMSG5BYT51ZLcOHqq5nXODsff15TAod3HxHQNKY3J9Bqpd8GJ4BpCY
         mg2RugLDtLmiAL5Iwbl5GHmCkgdX/6Dk5xFrBum9rxDrfPR1wEXVftGtiS0DjcuXeKZE
         9i7A==
X-Gm-Message-State: APjAAAVC9+51XFwlEAsL1JW4nTXKD0jUvEmXM2QFxydhjHbqlGk0BbKm
        5Yb2wR93pBhfHcT3bBY/zaeqgw==
X-Google-Smtp-Source: APXvYqx7CoRBGsCUgLmAD6bmavoIJXGvbBLl4jlFCFwYsR96PCBp0L0QpXGHgsUTRsYeE1z5tZgL0g==
X-Received: by 2002:a1c:678a:: with SMTP id b132mr4862856wmc.17.1559093397185;
        Tue, 28 May 2019 18:29:57 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id i17sm12789322wrr.46.2019.05.28.18.29.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 18:29:56 -0700 (PDT)
Subject: Re: [PATCH v2 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
To:     Tao Xu <tao3.xu@intel.com>, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, jingqi.liu@intel.com
References: <20190524075637.29496-1-tao3.xu@intel.com>
 <20190524075637.29496-3-tao3.xu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c9f5050a-6144-adbc-25ef-8a7543176ac6@redhat.com>
Date:   Wed, 29 May 2019 03:29:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524075637.29496-3-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/19 09:56, Tao Xu wrote:
> +
> +	if (rdmsrl_safe(MSR_IA32_UMWAIT_CONTROL, &host_umwait_control))
> +		return;
> +

Does the host value ever change?  If not, this can perhaps be read once
when kvm_intel is loaded.  And if it changes often, it should be
shadowed into a percpu variable.

Paolo
