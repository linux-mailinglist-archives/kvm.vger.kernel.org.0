Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12FA9D0CF2
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 12:41:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730678AbfJIKk6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 06:40:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbfJIKk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 06:40:57 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5FE7BC03D478
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 10:40:57 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id z17so913489wru.13
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 03:40:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=abCd/PKSbtDlFwGQhdNXFUNQ7UiKs2xVKNU/aJBjBBk=;
        b=WJUCEInOTsY0JUjsWhBXgPvHHMedFonrsWgtAP7qhEndiNCxx0r3DFWBtVXCQHnPF/
         bM+PBXqku3gUfG35HCAH4U7ZYda/nkdc7r9w2xODYg84WQOLqR2VEMxYIHNFc1NTP9yC
         hD6cT0gZrhcB3a+IFlC1T4XehNT+KV98xYwVFvBvccUQHQLa2Abjc7mAUimiAwW1ygq3
         DxonTq9KlbcRY+KkOkg9dFxkqKwN3Up4976J5gTzDkUP8fsV9QSEnXOllysFPf/6iMhM
         RXVOVY+fU4mRPNFI84ZRG7NNrqn4fd4e7ZSeAp4pils1Ls8W3ZOq4+JgC3Qw2rlEtbQI
         g2rg==
X-Gm-Message-State: APjAAAWkFVyuZ99jARVcbGiCy+Eh++v/3fl9u4ie1SR0OY3zes3WcmZI
        Eu51xf+K9Wq4h4NluffyZeEeXfcDLgn88idCvKFQ0ZmOynmzEJTFh2WrLz8wEGIyWiW1ls6zmJd
        T4TCU3PBgqGs4
X-Received: by 2002:a1c:2681:: with SMTP id m123mr2216809wmm.92.1570617655925;
        Wed, 09 Oct 2019 03:40:55 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwT2x/b1oBSgwdq+6U7Wh93Jf0B2d8CCa3AaNhng0FeeOSIcddFsBpCniq0qNd7tXS1DtNUgg==
X-Received: by 2002:a1c:2681:: with SMTP id m123mr2216782wmm.92.1570617655636;
        Wed, 09 Oct 2019 03:40:55 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id d78sm1880033wmd.47.2019.10.09.03.40.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 03:40:55 -0700 (PDT)
Subject: Re: [PATCH v2 4/8] KVM: VMX: Optimize vmx_set_rflags() for
 unrestricted guest
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
 <20190927214523.3376-5-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <99e57095-d855-99d7-e10e-a415c6ef13b2@redhat.com>
Date:   Wed, 9 Oct 2019 12:40:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190927214523.3376-5-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/09/19 23:45, Sean Christopherson wrote:
> Rework vmx_set_rflags() to avoid the extra code need to handle emulation
> of real mode and invalid state when unrestricted guest is disabled.  The
> primary reason for doing so is to avoid the call to vmx_get_rflags(),
> which will incur a VMREAD when RFLAGS is not already available.  When
> running nested VMs, the majority of calls to vmx_set_rflags() will occur
> without an associated vmx_get_rflags(), i.e. when stuffing GUEST_RFLAGS
> during transitions between vmcs01 and vmcs02.
> 
> Note, vmx_get_rflags() guarantees RFLAGS is marked available.

Slightly nicer this way:

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8de9853d7ab6..62ab19d65efd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1431,9 +1431,17 @@ unsigned long vmx_get_rflags(struct kvm_vcpu *vcpu)
 void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	unsigned long old_rflags = vmx_get_rflags(vcpu);
+	unsigned long old_rflags;
+
+	if (enable_unrestricted_guest) {
+		__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
+		vmx->rflags = rflags;
+		vmcs_writel(GUEST_RFLAGS, rflags);
+		return;
+	}
+
+	old_rflags = vmx_get_rflags(vcpu);
 
-	__set_bit(VCPU_EXREG_RFLAGS, (ulong *)&vcpu->arch.regs_avail);
 	vmx->rflags = rflags;
 	if (vmx->rmode.vm86_active) {
 		vmx->rmode.save_rflags = rflags;

Paolo
