Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3308657DC
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 15:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728406AbfGKNZR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 09:25:17 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44969 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728161AbfGKNZQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 09:25:16 -0400
Received: by mail-wr1-f68.google.com with SMTP id p17so6275926wrf.11
        for <kvm@vger.kernel.org>; Thu, 11 Jul 2019 06:25:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NiPzgCya2hoSH4eKrxi8qdW5Qk89gH2cnlBBWoaa/xg=;
        b=hjUpgRxhJOZg5Nl7cpx6IDDqn1PHUiJIcVdu66kQtDcZSmk4QMIutRMV8IwdowyVz6
         HbCSuCYsrX01SqbmIjr8qwn8jf0WNy0UqHXbJ4lC/pOlrOE9bwXitU5Waj4Q6uKzjZma
         dpqhXuwTAQst5tZhAfqFaG5NDNF8kcTxsZ5P0hWqM67QZKS7XratjFHzbGNsfElyMGZa
         mcvd/IwDrbccAjjPFu+AC79dpIXokveJabdVHLnK64GbcehGOI4TvzwfKbJKGAd+B1sX
         TeQT9stPdpVxGv3ltfud4mE6JQzJD0ziqplUdmORCeSfuz/BaU408IowsigbA4f7slLK
         0jXQ==
X-Gm-Message-State: APjAAAWeipqMInACG12OQnG1tK7oLTsOdVYTDjRV/HiimV1RqomtQ+HU
        uK9wJgxQcyVzWZWsdCn08Pm1NOGCSeY=
X-Google-Smtp-Source: APXvYqxwk8GF3EpHoEhDlHvKnuLbWejXVJYdh2lNTENdeBRa32LLelWUbAycMad3uNrwe2Sr84lu1Q==
X-Received: by 2002:adf:b1cb:: with SMTP id r11mr5074310wra.328.1562851514545;
        Thu, 11 Jul 2019 06:25:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d066:6881:ec69:75ab? ([2001:b07:6468:f312:d066:6881:ec69:75ab])
        by smtp.gmail.com with ESMTPSA id t1sm7823335wra.74.2019.07.11.06.25.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 11 Jul 2019 06:25:13 -0700 (PDT)
Subject: Re: [PATCH v6 2/3] KVM: vmx: Emulate MSR IA32_UMWAIT_CONTROL
To:     Tao Xu <tao3.xu@intel.com>, rkrcmar@redhat.com, corbet@lwn.net,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        sean.j.christopherson@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        fenghua.yu@intel.com, xiaoyao.li@linux.intel.com,
        jingqi.liu@intel.com
References: <20190621055747.17060-1-tao3.xu@intel.com>
 <20190621055747.17060-3-tao3.xu@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <43814a5e-12bf-ceb5-e4fb-12bbb32cd4cb@redhat.com>
Date:   Thu, 11 Jul 2019 15:25:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190621055747.17060-3-tao3.xu@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/06/19 07:57, Tao Xu wrote:
> +	if (guest_cpuid_has(vcpu, X86_FEATURE_WAITPKG))
> +		atomic_switch_umwait_control_msr(vmx);
> +

guest_cpuid_has is slow.  Please replace it with a test on
secondary_exec_controls_get(vmx).

Are you going to look into nested virtualization support?  This should
include only 1) allowing setting the enable bit in secondary execution
controls, and passing it through in prepare_vmcs02_early; 2) reflecting
the vmexit in nested_vmx_exit_reflected.

Thanks,

Paolo
