Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2ED1F1467
	for <lists+kvm@lfdr.de>; Mon,  8 Jun 2020 10:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgFHIU5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Jun 2020 04:20:57 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:38968 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729060AbgFHIU4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 8 Jun 2020 04:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591604454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PgnSUhvnGmVlTMkExDgba+ehKY/BZAg587suJPnB15E=;
        b=NRIuqQqOr7O84CDOFkH/Y/nLz2Vr3f1Uh6o8p/DnT89rh64GpFd+oN929vpRXcBVdEw42k
        jPLBkQ1YG6EylBI5pfkHzKZgx15mfsnnL67Bh1xBr8i5apz6h6zcjZyMyRXx4vAi1grBj0
        LYrKrAeDvLaYHPbxYyjGx/P6Ku4cPG4=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-sWE8SV-SPOmQK9CVjEnElA-1; Mon, 08 Jun 2020 04:20:47 -0400
X-MC-Unique: sWE8SV-SPOmQK9CVjEnElA-1
Received: by mail-ej1-f72.google.com with SMTP id b24so3996906ejb.8
        for <kvm@vger.kernel.org>; Mon, 08 Jun 2020 01:20:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=PgnSUhvnGmVlTMkExDgba+ehKY/BZAg587suJPnB15E=;
        b=PGnxSrLtYJRD74sZTRVdTk6T1U7Axuuh5Zmf8ffihKZwLv/vWKIFtkUzZvqoKaPDA3
         lgqQWO+JZKxCkcl23fsXextIJEm4CQeXPA/Xwr8AO+hYmFwq7qGtXS0JuZvuHQLybu3L
         w7d5K2rBA6tOlK7sRJzhQQkDC2qX1CrHP5jfvd0Juw7J9J38/JQt351hTcgK6EDzwBUB
         KwdmV/PAb3hZJ9TrIiPPHlIYgA3RFeUhJ6ozcAtH+x9ukc8czg9QfICVIPJAcvq65iY5
         7v8NEcdBVsDxH58cytfsjX7iD1c+NeszdTI/BczD0J8Ra2FV/2ZzoDXnA+uLQGLHXWPl
         urjA==
X-Gm-Message-State: AOAM532qrbS6o1a9gxklU0Bmq+iAEQWHMjSsgWaaKddvL6V/Ju0oaYhh
        fhcLijknuLYzUysH3SUG6e2cp4EYP8skFbTqztISl/+qm2/ToKJvmsEkyHsioL+uaqCzZkJEAd1
        f6BNjaxAdNt26
X-Received: by 2002:aa7:cd4b:: with SMTP id v11mr21652715edw.356.1591604446386;
        Mon, 08 Jun 2020 01:20:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwOniuyMpVDAXmY9mtdQWcLY3TxxXpZEu8EMxsFfa1XUuHyKUuTjPkXBMFkMe7XQkw0Uy6jJA==
X-Received: by 2002:aa7:cd4b:: with SMTP id v11mr21652704edw.356.1591604446164;
        Mon, 08 Jun 2020 01:20:46 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id d11sm7157315edy.79.2020.06.08.01.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 01:20:45 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KVM: nVMX: Properly handle kvm_read/write_guest_virt*() result
In-Reply-To: <20200605200651.GC11449@linux.intel.com>
References: <20200605115906.532682-1-vkuznets@redhat.com> <20200605200651.GC11449@linux.intel.com>
Date:   Mon, 08 Jun 2020 10:20:44 +0200
Message-ID: <878sgyc6jn.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Fri, Jun 05, 2020 at 01:59:05PM +0200, Vitaly Kuznetsov wrote:
>> Introduce vmx_handle_memory_failure() as an interim solution.
>
> Heh, "interim".  I'll take the over on that :-D.
>

We just need a crazy but real use-case to start acting :-)

>> Note, nested_vmx_get_vmptr() now has three possible outcomes: OK, PF,
>> KVM_EXIT_INTERNAL_ERROR and callers need to know if userspace exit is
>> needed (for KVM_EXIT_INTERNAL_ERROR) in case of failure. We don't seem
>> to have a good enum describing this tristate, just add "int *ret" to
>> nested_vmx_get_vmptr() interface to pass the information.

On a loosely related note, while writing this patch I was struggling
with our exit handlers calling convention (that the return value is '1'
- return to the guest, '0' - return to userspace successfully, '< 0' -
return to userspace with an error). This is intertwined with normal
int/bool functions and make it hard to read. At the very minimum we can
introduce an enum for 0/1 return values from exit handlers. Or, maybe,
we can introduce KVM_REQ_USERSPACE_EXIT/KVM_REQ_INTERNAL_ERROR/.. and
make all the exit handlers normal functions returning 0/error?

>> 
>> Reported-by: syzbot+2a7156e11dc199bdbd8a@syzkaller.appspotmail.com
>> Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>
> ...
>
>> +/*
>> + * Handles kvm_read/write_guest_virt*() result and either injects #PF or returns
>> + * KVM_EXIT_INTERNAL_ERROR for cases not currently handled by KVM. Return value
>> + * indicates whether exit to userspace is needed.
>> + */
>> +int vmx_handle_memory_failure(struct kvm_vcpu *vcpu, int r,
>> +			      struct x86_exception *e)
>> +{
>> +	if (r == X86EMUL_PROPAGATE_FAULT) {
>> +		kvm_inject_emulated_page_fault(vcpu, e);
>> +		return 1;
>> +	}
>> +
>> +	/*
>> +	 * In case kvm_read/write_guest_virt*() failed with X86EMUL_IO_NEEDED
>> +	 * while handling a VMX instruction KVM could've handled the request
>
> A nit similar to your observation on the shortlog, this isn't limited to VMX
> instructions.
>

Yea, it all started with nested_vmx_get_vmptr() then Paolo discovered
vmwrite/vmread/vmptrst/invept/invvpid and then I discovered invpcid but
forgot to update the comment ...

>> +	 * correctly by exiting to userspace and performing I/O but there
>> +	 * doesn't seem to be a real use-case behind such requests, just return
>> +	 * KVM_EXIT_INTERNAL_ERROR for now.
>> +	 */
>> +	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
>> +	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_EMULATION;
>> +	vcpu->run->internal.ndata = 0;
>> +
>> +	return 0;
>> +}
>

-- 
Vitaly

