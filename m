Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC522C18A4
	for <lists+kvm@lfdr.de>; Mon, 23 Nov 2020 23:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732760AbgKWWmS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Nov 2020 17:42:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34282 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732634AbgKWWmS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Nov 2020 17:42:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606171336;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9zGeqvusgvDh5D3QbEzY+8R0OhW+NzwGCp0SgQ9rAFk=;
        b=SHipMzJumSAaiilbk8I6e2wkOZKteUJ9yRz4g4HBXcd66FmhUxuRMyQl6GvBEliWeUzYEz
        z6mZyeGBUPGknrnvQlrPGh3FdvuDOD8C1ADK+iB3YNECex6GJlTxYDarSyu/mtLCM4q6sK
        20XEUNSDLhEyFftyDGOmdXmI6D2T7lw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-385-w_wewZ2iNPGDRjHu2TReog-1; Mon, 23 Nov 2020 17:42:15 -0500
X-MC-Unique: w_wewZ2iNPGDRjHu2TReog-1
Received: by mail-wr1-f69.google.com with SMTP id g5so6317711wrp.5
        for <kvm@vger.kernel.org>; Mon, 23 Nov 2020 14:42:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9zGeqvusgvDh5D3QbEzY+8R0OhW+NzwGCp0SgQ9rAFk=;
        b=gL+uDy/ZUjueuvJQgMutNNRxQY0RzieZz4X5MQDuZx2a342VCap8Hw3ImLbAn5wC3N
         S4s4ANogy8ekxHa1E7XCyEkM1lSjgZmib69dVfz50wq6sMqIMVpruioI2SCXvfdH9k1I
         BRDPNkhvnKNbRBa1dk5UVvx7DVFtRf7OON860+PdwdHcCS5KfnqCIgh3eaw9b/yJnK4D
         WbFku8ftfTyzrBnJozwMC6iHnT9PhioaU+RGTTXMJNuECxuMifIRIgvrLzwpRhf+qAmU
         qk7BUYWf3AAIueeISb6j5dIj9XvqKVQpl3iuTdzmE8kNiPmtAM0Y4+qT6W0vAzku4pzG
         Fz3Q==
X-Gm-Message-State: AOAM530KE9+UGtHI/dViXSu2614iHGzw3UhJcz0UxzNiGBeSm2viH7Wk
        B5HnkEfJyhS8ZR3HS//VIQ/dKh9Zbv/zDtwcxcu+E5aheHQy5TVwjD9shhSnL2CwFFMlLAWtQ9L
        ELTcgE5O0ZaV8
X-Received: by 2002:a05:6000:10cd:: with SMTP id b13mr1974190wrx.220.1606171333489;
        Mon, 23 Nov 2020 14:42:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwEqkwz+YcT1eHiNg5brEn9vKL04UBaGnLpn2lesmKa0eGyVMk6L1ZsKARO5DCGXZ6GTP3sKQ==
X-Received: by 2002:a05:6000:10cd:: with SMTP id b13mr1974177wrx.220.1606171333235;
        Mon, 23 Nov 2020 14:42:13 -0800 (PST)
Received: from [192.168.10.118] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id o10sm16211456wrx.2.2020.11.23.14.42.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Nov 2020 14:42:12 -0800 (PST)
To:     Oliver Upton <oupton@google.com>
Cc:     idan.brown@ORACLE.COM, jmattson@google.com, kvm@vger.kernel.org,
        liam.merwick@ORACLE.COM, wanpeng.li@hotmail.com, seanjc@google.com
References: <95b9b017-ccde-97a0-f407-fd5f35f1157d@redhat.com>
 <20201123192223.3177490-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 11/11] KVM: nVMX: Wake L2 from HLT when nested
 posted-interrupt pending
Message-ID: <4788d64f-1831-9eb9-2c78-c5d9934fb47b@redhat.com>
Date:   Mon, 23 Nov 2020 23:42:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201123192223.3177490-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/11/20 20:22, Oliver Upton wrote:
> The pi_pending bit works rather well as it is only a hint to KVM that it
> may owe the guest a posted-interrupt completion. However, if we were to
> set the guest's nested PINV as pending in the L1 IRR it'd be challenging
> to infer whether or not it should actually be injected in L1 or result
> in posted-interrupt processing for L2.

Stupid question: why does it matter?  The behavior when the PINV is 
delivered does not depend on the time it enters the IRR, only on the 
time that it enters ISR.  If that happens while the vCPU while in L2, it 
would trigger posted interrupt processing; if PINV moves to ISR while in 
L1, it would be delivered normally as an interrupt.

There are various special cases but they should fall in place.  For 
example, if PINV is delivered during L1 vmentry (with IF=0), it would be 
delivered at the next inject_pending_event when the VMRUN vmexit is 
processed and interrupts are unmasked.

The tricky case is when L0 tries to deliver the PINV to L1 as a posted 
interrupt, i.e. in vmx_deliver_nested_posted_interrupt.  Then the

                 if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true))
                         kvm_vcpu_kick(vcpu);

needs a tweak to fall back to setting the PINV in L1's IRR:

                 if (!kvm_vcpu_trigger_posted_interrupt(vcpu, true)) {
                         /* set PINV in L1's IRR */
			kvm_vcpu_kick(vcpu);
		}

but you also have to do the same *in the PINV handler* 
sysvec_kvm_posted_intr_nested_ipi too, to handle the case where the 
L2->L0 vmexit races against sending the IPI.

What am I missing?

Paolo

