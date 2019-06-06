Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0767D37AAF
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 19:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbfFFRMu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 13:12:50 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45577 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727522AbfFFRMt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 13:12:49 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so3209550wre.12
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 10:12:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vUHpvlEqWlZmVbGhbWmVRO3WSH0hTbKnylJIiexic9s=;
        b=ntAuD+PuxB9a6/oTM6nWzhmBWba8lFdtghrO8SRe37KPo0LmM+gztCgsIWHj9hCI8S
         dLX6AftPlnZIPrfdXGyFH8ScxqtMwXfInlBuhBhC0rPhGIn05dH0Q8KAGLFfukqhzZ5E
         h7IicuDOfsBRozeCCXpfA7ayuWDUAFCxz0mlFc7uAH9MPIHtrahzbmkR618JJWbeqG7U
         o7D+60Y6cCszK1Anq951l7HCzSBWg3qdDmxzO8MQmLlL6rdZvNYTvKSSCYvsCfPzf56B
         TVUkNck7JukaGTzM4y2bd1MCJtzbaoJmOOV7HEVSeED8x80NsiiZaZr7uJXebrF6rpSx
         oe0Q==
X-Gm-Message-State: APjAAAUJZIR25wSPkBjutBx0x56FPm07QuKxAFHwMwXs2GEks7312vKL
        Izk8OYbFvLYbiVizRPHhCEvYBNaRKUU=
X-Google-Smtp-Source: APXvYqxnP9cAPcOu/1wUJbVpEAaTbsNYjPTiAAcVvC/d4v98ByaeapHiU3e2xavzv3Ne0VprIISi1w==
X-Received: by 2002:adf:f542:: with SMTP id j2mr17183604wrp.16.1559841167995;
        Thu, 06 Jun 2019 10:12:47 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id e13sm4529102wra.16.2019.06.06.10.12.47
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 10:12:47 -0700 (PDT)
Subject: Re: [PATCH 09/13] KVM: nVMX: Preserve last USE_MSR_BITMAPS when
 preparing vmcs02
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190507191805.9932-1-sean.j.christopherson@intel.com>
 <20190507191805.9932-10-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a111a422-0256-d7ed-f538-5dd9712d9d52@redhat.com>
Date:   Thu, 6 Jun 2019 19:12:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507191805.9932-10-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 21:18, Sean Christopherson wrote:
> KVM dynamically toggles the CPU_BASED_USE_MSR_BITMAPS execution control
> for nested guests based on whether or not both L0 and L1 want to pass
> through the same MSRs to L2.  Preserve the last used value from vmcs02
> so as to avoid multiple VMWRITEs to (re)set/(re)clear the bit on nested
> VM-Entry.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Needs a comment in code, and also leaves you puzzled as to why it's only 
necessary to clear it.  We can even let the compiler merge the
two "exec_control &= ~FOO" so that we don't even spend a precious instruction
on the AND:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 1150831e4a9b..2e086d5ab837 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2048,10 +2048,18 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 	 * A vmexit (to either L1 hypervisor or L0 userspace) is always needed
 	 * for I/O port accesses.
 	 */
-	exec_control &= ~CPU_BASED_USE_IO_BITMAPS;
 	exec_control |= CPU_BASED_UNCOND_IO_EXITING;
-	if (!(exec_controls_get(vmx) & CPU_BASED_USE_MSR_BITMAPS))
-		exec_control &= ~CPU_BASED_USE_MSR_BITMAPS;
+	exec_control &= ~CPU_BASED_USE_IO_BITMAPS;
+
+	/*
+	 * This bit will be computed in nested_get_vmcs12_pages, because
+	 * we do not have access to L1's MSR bitmap yet.  For now, keep
+	 * the same bit as before, hoping to avoid multiple VMWRITEs that
+	 * only set/clear this bit.
+	 */
+	exec_control &= ~CPU_BASED_USE_MSR_BITMAPS;
+	exec_control |= exec_controls_get(vmx) & CPU_BASED_USE_MSR_BITMAPS;
+
 	exec_controls_set(vmx, exec_control);
 
 	/*


Paolo
