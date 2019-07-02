Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F07D5D443
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:30:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfGBQaq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:30:46 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51313 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbfGBQaq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:30:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id 207so1487438wma.1
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:30:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7t5fxGxFhnlaD4K11RN900eA9G9cmbm1+9mO0Myb9vc=;
        b=G6oTlCba49rPaNXNQ9emk0AAaAtHVfPgwcBTvI5GM4q6BDPCK3E9Uib/2CMB8stqc9
         hvOTZvqbWBC0e2CUFUFFlmvoIsvUlVcjDEhXZugmkxYU7SaSVrb90KxKDtMWTeZcHa6a
         lo7ZvkfuAseB2V1gJBz7QXvxuXZ1vCBSWeO7vDaqbd8F2dq6UJ2jb5QNkvltRFUm3PVu
         CN7AFwa6v3DMQajvy8VW5DhfQXPNaLleqsVc2YdGLQoO7FSQr9QuqcfHBMXAJduRWeSr
         7r+0sj5cCXR05+OlOxZYPYtluY1qrCbQn/Ddkkn/qQ/CgRk01+A5+Meny3+3YpdvJ2SD
         pv9A==
X-Gm-Message-State: APjAAAVKsnN/HpK8nCS6mpUx3zkLGbmc4w3Rj/OxnIP4AFiS00pJXfqZ
        T0hdbbC2VvG6q6u2p4t86xHUtg==
X-Google-Smtp-Source: APXvYqzSIufNHM2Ytv+tIVnOfNtbDHMos5vGPw9lWMOfGrNOPeHY4NRc25xl6t4RrFJUaFf5q5Ow6w==
X-Received: by 2002:a7b:ce10:: with SMTP id m16mr3928214wmc.21.1562085044674;
        Tue, 02 Jul 2019 09:30:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id z5sm1902471wmf.48.2019.07.02.09.30.43
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:30:43 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] x86/kvm/nVMX: fix Enlightened VMCLEAR
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Liran Alon <liran.alon@oracle.com>
References: <20190628112333.31165-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <41362dc0-a4d5-93ec-848d-193a76a9bd0c@redhat.com>
Date:   Tue, 2 Jul 2019 18:30:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190628112333.31165-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/06/19 13:23, Vitaly Kuznetsov wrote:
> VMCLEAR implementation for Enlightened VMCS is not entirely correct
> when something else than the currently active eVMCS on the calling vCPU
> is targeted. In case there's no currently active eVMCS on the calling vCPU
> we are corrupting the targeted area by writing to the non-existent
> launch_state field.
> 
> Fix the logic by always treating the targeted area as 'enlightened' in case
> Enlightened VMEntry is enabled on the calling vCPU.
> 
> Changes since v1:
> - 'evmcs_vmptr' -> 'evmcs_gpa' [Paolo Bonzini]
> - avoid nested_release_evmcs() in handle_vmclear even for the currently
>   active eVMCS on the calling vCPU [Liran Alon], PATCH1 added to support
>   the change.
> 
> Vitaly Kuznetsov (2):
>   x86/KVM/nVMX: don't use clean fields data on enlightened VMLAUNCH
>   x86/kvm/nVMX: fix VMCLEAR when Enlightened VMCS is in use
> 
>  arch/x86/kvm/vmx/evmcs.c  | 18 ++++++++++++++
>  arch/x86/kvm/vmx/evmcs.h  |  1 +
>  arch/x86/kvm/vmx/nested.c | 52 ++++++++++++++++++++++-----------------
>  3 files changed, 49 insertions(+), 22 deletions(-)
> 

Queued, thanks.

Paolo
