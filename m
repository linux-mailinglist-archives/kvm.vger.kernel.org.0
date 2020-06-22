Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1EB204415
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 00:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731110AbgFVWxU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 18:53:20 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23150 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730970AbgFVWxU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Jun 2020 18:53:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592866399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=opFQqNN7yTSwuKd+JxjwXkah+/KWifMnnM11JXOBi50=;
        b=hmZa6FU5Em1v37bZZPAu9s82wSLIxcbILQEmgOgyHQQ0JeeMAQ5OUs1sYXVdCOwoEePEtq
        YLX5O004ZqUtpvF1E5ow3NLHno0sFF2DfuQjXWTZob4rPkMe3PmkkiJVRQTcUDt0oPiYW5
        ohuJlNvGQ1v9nE2wjcByN72EpUIxZlk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-52-HAmsOtblOwmOvLuVdbiuiA-1; Mon, 22 Jun 2020 18:53:17 -0400
X-MC-Unique: HAmsOtblOwmOvLuVdbiuiA-1
Received: by mail-wm1-f70.google.com with SMTP id t18so956408wmj.5
        for <kvm@vger.kernel.org>; Mon, 22 Jun 2020 15:53:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=opFQqNN7yTSwuKd+JxjwXkah+/KWifMnnM11JXOBi50=;
        b=LYzGR3RdIV+8dG60CoJwiKmdADcr1aQNudHfZu7GE9SmPtJdFlrMIadc4bgS10ycoe
         9jdOMtCmvtBZSox++l4PIhG9HUOi8ALI0GnT88Zs3NTkx7ymfiLX6aTgmPw8IgVAmEwl
         Q+hvkaPI49D3a1ZBEwHqHrh67naA8TBj7iTzz5DlX41us145IPl6vflHCxvIsP6dcI7I
         BDDzplU79/gjt6M6AHewaoyWLdUgL78NXdfLEv61tIbk8UuIXxSG0zw5DQo/clME1aF6
         wRPL7/FcoNNVdMBV+dE0Xa2h419u04itzOLyJ2KtdEy5fSVb9kKp6Q433yb2YXAnka4g
         eYGg==
X-Gm-Message-State: AOAM532yY/wKd4aqNnMIQVfsgINagFDMqeBfvaTm/vhr2EL7i6AW6s2y
        nVQRDmLT19Jom1dJ0wNKB9bqcznM85scIrsBv9+3DrcqOwonL7Qm6a4HtmENLQGSS+ozaTvHhQD
        2a9gcOWSMqN/3
X-Received: by 2002:adf:f542:: with SMTP id j2mr7218145wrp.61.1592866396258;
        Mon, 22 Jun 2020 15:53:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyf27AYsmfHOiwx93ASBnyneRClsppOWxeUsRJNfYRFhoTPIzlaWDYr3TtIgIyROSUKHBrMeQ==
X-Received: by 2002:adf:f542:: with SMTP id j2mr7218106wrp.61.1592866395945;
        Mon, 22 Jun 2020 15:53:15 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.170.5])
        by smtp.gmail.com with ESMTPSA id v4sm4675011wro.26.2020.06.22.15.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2020 15:53:15 -0700 (PDT)
Subject: Re: [PATCH] kvm: nVMX: flush TLB when decoded insn != VM-exit reason
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>
References: <20200616224305.44242-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <72d71987-15c1-a963-cddd-468a88342f4f@redhat.com>
Date:   Tue, 23 Jun 2020 00:53:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200616224305.44242-1-oupton@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/06/20 00:43, Oliver Upton wrote:
> -		if (!nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC))
> -			return X86EMUL_CONTINUE;
> -
> -		/* FIXME: produce nested vmexit and return X86EMUL_INTERCEPTED.  */
> +		intercepted = nested_cpu_has2(vmcs12, SECONDARY_EXEC_DESC);
>  		break;
>  

[...]

> +	/*
> +	 * The only uses of the emulator in VMX for instructions which may be
> +	 * intercepted are port IO instructions, descriptor-table accesses, and
> +	 * the RDTSCP instruction. As such, if the emulator has decoded an
> +	 * instruction that is different from the VM-exit provided by hardware
> +	 * it is likely that the TLB entry and page-table mapping for the
> +	 * guest's RIP are out of sync.
> +	 *
> +	 * Rather than synthesizing a VM-exit into L1 for every possible
> +	 * instruction just flush the TLB, resume L2, and let hardware generate
> +	 * the appropriate VM-exit.
> +	 */

So you're saying that (in the SECONDARY_EXEC_DESC case above for an
example) this should have been handled earlier by
nested_vmx_l1_wants_exit.  But what about LGDT and friends from an MMIO
address?  I would say we could just not care, but an infinite #UD loop
is an ugly failure mode.

(Or perhaps it's just not my day for reviewing code...).

Paolo

