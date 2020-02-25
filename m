Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC9E716E9A8
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 16:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbgBYPKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 10:10:23 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:22709 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729947AbgBYPKX (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 Feb 2020 10:10:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582643422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QRFD3PMjjqRPLYE/BqYxDm6sJvPkBl4qX28FKWyGGt0=;
        b=ThrqcSwNl7zJ66bvrLSKf0MCEfX88FnYDczxaCZMtdeym8mWp+eB1Dxo373xv355MzkfGT
        Burj2qOiBzCl7edjLDZQgR+Tr0qpwBVTRJLe6WCTCRFDrB6PCCif1l7tyeF8yEub0vktyH
        S6aL0bn0L4tB8fQ4OJop82o9B/LucFQ=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-57-3qv5-C3ROySPONiHb2xBeg-1; Tue, 25 Feb 2020 10:10:20 -0500
X-MC-Unique: 3qv5-C3ROySPONiHb2xBeg-1
Received: by mail-wr1-f71.google.com with SMTP id p5so1895222wrj.17
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 07:10:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QRFD3PMjjqRPLYE/BqYxDm6sJvPkBl4qX28FKWyGGt0=;
        b=OZtdThuSvSs0IpTKip+tbpXdPmfV0DRkDitCMqY6UK7zlFsQwWIxG2HHv64rsWKS2S
         c1S2/2T+zf+3yWi4GOWK7KxZPSmb4lvEaLzrRIMKEUiMUy3cHtej6WU6QseAPaDK2grR
         oeiIQpyjQGK6Uetqd5Fcd1tf0cechYs/OA+84330F5y0yhwQcM945fTczYyaQJekctra
         3L3fCy9z37bc1K6B8Kx3WelHGfunGwf7moVeXWg+TGDwYbsZpIIozdTqbrTuEyloiIzC
         Mfn3OgwPbVFXFwnyJsESjtz2oJpkCc7e/dOQpdLfTAQqeFFkvx/KKGqSdTwLPGzrWWTh
         23sQ==
X-Gm-Message-State: APjAAAVtuT8O/rAENnvRJc5+wM2TKppo+7TS9EVZPMcIQ1sB8jS6wca4
        +77oUlQW8uEfCsLUmGW30UhCWLxvu/R7ChFanODZgF0Rg34BY3gglnFkP3BX8Rod3RFZxt+gIRw
        oiJhA8/JyQPQG
X-Received: by 2002:a7b:c019:: with SMTP id c25mr29144wmb.126.1582643419596;
        Tue, 25 Feb 2020 07:10:19 -0800 (PST)
X-Google-Smtp-Source: APXvYqzSlTbehjzt6fQaWvLGS5yyGzUn9gYwXqID+MDIjftANEs2/W8YYDcK4izZDikzk+F4PoUasw==
X-Received: by 2002:a7b:c019:: with SMTP id c25mr29114wmb.126.1582643419296;
        Tue, 25 Feb 2020 07:10:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:3577:1cfe:d98a:5fb6? ([2001:b07:6468:f312:3577:1cfe:d98a:5fb6])
        by smtp.gmail.com with ESMTPSA id b7sm16100391wrs.97.2020.02.25.07.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 07:10:18 -0800 (PST)
Subject: Re: [PATCH 39/61] KVM: SVM: Convert feature updates from CPUID to KVM
 cpu caps
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200201185218.24473-1-sean.j.christopherson@intel.com>
 <20200201185218.24473-40-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0f21b023-000d-9d78-b9b4-b9d377840385@redhat.com>
Date:   Tue, 25 Feb 2020 16:10:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200201185218.24473-40-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/02/20 19:51, Sean Christopherson wrote:
> +	/* CPUID 0x8000000A */
> +	/* Support next_rip if host supports it */
> +	if (boot_cpu_has(X86_FEATURE_NRIPS))
> +		kvm_cpu_cap_set(X86_FEATURE_NRIPS);

Should this also be conditional on "nested"?

Paolo

