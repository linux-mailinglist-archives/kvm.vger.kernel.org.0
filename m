Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F1B276982
	for <lists+kvm@lfdr.de>; Thu, 24 Sep 2020 08:52:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727265AbgIXGwO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Sep 2020 02:52:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35378 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727235AbgIXGwF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Sep 2020 02:52:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600930323;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OnQ7RnpQyCWKyHzqHkBwFITRaelVc+b99566RYUlUuU=;
        b=O/+e6CwYa5Q2dvEeSvN6fnZaR1kjkz8xaxEGwZi7kkzMrwv37RgaRgAwLCRnPWKKNdWP9A
        26G8DqbCFEPygXMJAjRq8ocaJlvRalKNvprq9HGRhti0uVoo7HueHJPjmn2r0bRZWFuThf
        pOK2R4GD/eyz/cOQWPPekivxJVZ2Ue0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-OGBFZug3OU2-rUrHE-ocIQ-1; Thu, 24 Sep 2020 02:51:59 -0400
X-MC-Unique: OGBFZug3OU2-rUrHE-ocIQ-1
Received: by mail-wm1-f70.google.com with SMTP id y18so512480wma.4
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 23:51:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OnQ7RnpQyCWKyHzqHkBwFITRaelVc+b99566RYUlUuU=;
        b=GYws/2K1iAa774bHBK4vNqlRKgRPKfx8+1EteD5cBBwGpU6OcwxnRuqxlQT7NmpAoY
         NwGHw3jA6tYVGQxTStpORn6Mj7KZqpf8B+TnFlNoy9cVA4OdCPQaIrzGGqeSe54O966e
         HZb2vVPhNg5fk+gm+sSTMtgye6q8CbMbuktNIuZMOF/JCsAe0c48ZFmw1Gh4Zhrb7ft5
         qBfypZELKz/KBJdhbQnbqVqzmjSiF3mmHrF3xoPkOGGxSEKOQ/dD2BCcHvnBBkOhljcP
         q/w50VY1Q5L/uP4UDTyqMf0KKUgQRCXiLobT2J0NR4Da8nGG3Ify/sghzRRoZjOFdrrQ
         u/tQ==
X-Gm-Message-State: AOAM5330RA2mzHcI3cbdeZUV4lGy3F3MrIPWQGs6mowCWbyf8nFfJppd
        NXwlkg5Wxcqga4OaYTBoVorVyZqPk86uLi1fio1KZ0pIOlIEVvtluMuDld6pgtQEQUkg5zumXoz
        F1NidTOu4nyXu
X-Received: by 2002:a7b:c095:: with SMTP id r21mr3254610wmh.133.1600930318653;
        Wed, 23 Sep 2020 23:51:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIeIX5AT7dBIOdJC7LRZQn1fAtdurXZZQW16RpkfOrEWOzAPYZlFOar52I36l0bKFZs60P9g==
X-Received: by 2002:a7b:c095:: with SMTP id r21mr3254593wmh.133.1600930318446;
        Wed, 23 Sep 2020 23:51:58 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:d80e:a78:c27b:93ed? ([2001:b07:6468:f312:d80e:a78:c27b:93ed])
        by smtp.gmail.com with ESMTPSA id n4sm2287101wrp.61.2020.09.23.23.51.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 23:51:57 -0700 (PDT)
Subject: Re: [PATCH] KVM: SVM: Add a dedicated INVD intercept routine
To:     Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <16f36f9a51608758211c54564cd17c8b909372f1.1600892859.git.thomas.lendacky@amd.com>
 <20200923203241.GB15101@linux.intel.com>
 <12be5ce2-2caf-ce8a-01f1-9254ca698849@amd.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <d260b1e1-1a53-a7ee-e613-a806395582f6@redhat.com>
Date:   Thu, 24 Sep 2020 08:51:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <12be5ce2-2caf-ce8a-01f1-9254ca698849@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 22:40, Tom Lendacky wrote:
>>> +static int invd_interception(struct vcpu_svm *svm)
>>> +{
>>> +	/*
>>> +	 * Can't do emulation on an SEV guest and INVD is emulated
>>> +	 * as a NOP, so just skip the instruction.
>>> +	 */
>>> +	return (sev_guest(svm->vcpu.kvm))
>>> +		? kvm_skip_emulated_instruction(&svm->vcpu)
>>> +		: kvm_emulate_instruction(&svm->vcpu, 0);
>>
>> Is there any reason not to do kvm_skip_emulated_instruction() for both SEV
>> and legacy?  VMX has the same odd kvm_emulate_instruction() call, but AFAICT
>> that's completely unecessary, i.e. VMX can also convert to a straight skip.
> 
> You could, I just figured I'd leave the legacy behavior just in case. Not
> that I can think of a reason that behavior would ever change.

Yeah, let's do skip for both SVM and VMX.

Paolo

