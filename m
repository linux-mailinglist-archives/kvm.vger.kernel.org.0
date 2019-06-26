Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B25B565C2
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2019 11:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfFZJjo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jun 2019 05:39:44 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50394 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726157AbfFZJjm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jun 2019 05:39:42 -0400
Received: by mail-wm1-f66.google.com with SMTP id c66so1369644wmf.0
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2019 02:39:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=0oLx6Rnuo9a2CrlixJQ1TNptd79xT0odw2gDg+gLUkM=;
        b=FfsNRPPaOICXlGDH+pm8Pu7dpu1cnmr2KQE6mNP9azK8t4l5VTE4+RSbSaxqNH2D9+
         +F9aoLK6cXct8clJrZySY4z8DWhEm1L4uIbpA8HjVxQCmJJ9dVIO0m6Dqa5VGmyhurp2
         MsjfUSPOuWBcK+mtlPzaKUblE0qqaFd8/p02aNGHr7TAXNP86b3Ov47J+VycJ7h+4KAa
         3eCKqpEqafHxY1JdTWe9xk4PE8UDa4mxdZK3RXbgF+nLeuni30p+/FCV0KGjG3xngNDv
         ZyW4OLih6oAF+vBcyhKZTKEyYF5ciZbQBDQDvvNDmixJynQqkTwn909VnMYFXMtHuz0x
         YkIQ==
X-Gm-Message-State: APjAAAUuvFkjO5WhOsb1HYQPUk1WVSwhsa2AJuQdSJqJSpCqGbqelJrx
        RtOlwzZ8b526PCFu5EqIaK8lqNHwjOo=
X-Google-Smtp-Source: APXvYqysu4XkmlTfX3pnryWiqDuf/fsvEmP4YQwQk5dJtOFdmaY1wHQXydtGgRz2Lpe8hgMDa5BhPg==
X-Received: by 2002:a1c:cb43:: with SMTP id b64mr2120394wmg.86.1561541980070;
        Wed, 26 Jun 2019 02:39:40 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t140sm1761455wmt.0.2019.06.26.02.39.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 02:39:39 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Subject: Re: [PATCH] x86/kvm/nVMCS: fix VMCLEAR when Enlightened VMCS is in use
In-Reply-To: <69274969-E2BE-442C-B2D2-0AF94338C31B@oracle.com>
References: <20190624133028.3710-1-vkuznets@redhat.com> <CEFF2A14-611A-417C-BC0A-8814862F26C6@oracle.com> <87r27jdq68.fsf@vitty.brq.redhat.com> <69274969-E2BE-442C-B2D2-0AF94338C31B@oracle.com>
Date:   Wed, 26 Jun 2019 11:39:38 +0200
Message-ID: <87k1d8d6sl.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Liran Alon <liran.alon@oracle.com> writes:

>> On 24 Jun 2019, at 17:16, Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>> 
>> 
>> That said I'm ok with dropping nested_release_evmcs() for consistency
>> but we can't just drop 'if (vmptr == vmx->nested.hv_evmcs_vmptr)’.
>
> Right. I meant that we can just change code to:
>
> /* Add relevant comment here as this is not trivial why we do this */
> If (likely(!vmx->nested.enlightened_vmcs_enabled) ||
>     nested_enlightened_vmentry(vcpu, &evmptr)) {
>
>     if (vmptr == vmx->nested.current_vmptr)
>         nested_release_vmcs12(vcpu);
>
>     kvm_vcpu_write_guest(…);
> }
>

The change, to my surprise, resulted in a set of L2 guest crashes. After
some debugging I figured out that clean fields is to blame: after
Windows does VMCLEAR it doesn't maintain clean field data before the
next VMLAUNCH - and nested_vmx_handle_enlightened_vmptrld() does nothing
in case evmcs_vmptr stays unchanged (so VMLAUNCH follows VMCLEAR on the
same vCPU). We apparently need to invalidate clean fields data on every
VMLAUCH. This is fix of its own, I'll do more testing and send v2.

-- 
Vitaly
