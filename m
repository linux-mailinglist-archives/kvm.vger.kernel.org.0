Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2AF4BBF4B
	for <lists+kvm@lfdr.de>; Tue, 24 Sep 2019 02:15:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503584AbfIXAPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 20:15:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48074 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503575AbfIXAPn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 20:15:43 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C452781F07
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 00:15:42 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id w10so25534wrl.5
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 17:15:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hhPTSVV7Ljq+kvFH1rF6tm4Uro9YskXd35cRRez5krA=;
        b=A1uum3T+LxaiQguSLuTmmkdCMIZimvDHklSvuBldgedx5MhGuBRjQGPo4jgsiLhASJ
         JyLg6qpDolaQGGNj4zGPx+3eM06QvIzj5Qrh6CRj2S946aU3SA+q2vMoRS/fwbTf0ELP
         fk9BsSqlXLNwtpr7usv1kflFKR+EfYScGMifKA1rRbraV1VWtfYhVkkUc683pPtw7lu0
         u4kIaDqDBRMv2QlOBuLpbY0KZ7Ivs7eHRWK3i3JdXVkjcDIpOCrSRMXtzzJTeqj4LgFo
         DboQRjJsJl1DU9npAndGvDrq89JZRYBcPGgKuoGyreZ+4M88pL8aqvwQeruUYGZXC48E
         +Ocg==
X-Gm-Message-State: APjAAAUyU2dJzepk9Y0pIO8PO0bNada3szTsVlg7gXM+L0BsudIQ/cDV
        IGnNNXqa+I0fCY/NXVwP4iqY4UbzQyudO/1anOA2isEG7xwi2OozKIEpn8G9qqoxk1Y0XZfoZgx
        xYmW1SQtA7iW6
X-Received: by 2002:a1c:c742:: with SMTP id x63mr154253wmf.126.1569284141474;
        Mon, 23 Sep 2019 17:15:41 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwwcyNABkvGGY5zjzh+d1Nvb5uPVQbuCrvHOUy7k0svqrNAU8kQctD8Ji9xWiw/ma2dHQ2ktQ==
X-Received: by 2002:a1c:c742:: with SMTP id x63mr154239wmf.126.1569284141164;
        Mon, 23 Sep 2019 17:15:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id 33sm56960wra.41.2019.09.23.17.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 17:15:40 -0700 (PDT)
Subject: Re: [PATCH 15/17] KVM: retpolines: x86: eliminate retpoline from
 vmx.c exit handlers
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-16-aarcange@redhat.com>
 <87o8zb8ik1.fsf@vitty.brq.redhat.com>
 <7329012d-0b3b-ce86-f58d-3d2d5dc5a790@redhat.com>
 <20190923190514.GB19996@redhat.com> <20190923202349.GL18195@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ccfa85b7-b484-7052-f991-78ad05ce7fe7@redhat.com>
Date:   Tue, 24 Sep 2019 02:15:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190923202349.GL18195@linux.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/19 22:23, Sean Christopherson wrote:
>  
> +int nested_vmx_handle_vmx_instruction(struct kvm_vcpu *vcpu)
> +{
> +	switch (to_vmx(vcpu)->exit_reason) {
> +	case EXIT_REASON_VMCLEAR:
> +		return handle_vmclear(vcpu);
> +	case EXIT_REASON_VMLAUNCH:
> +		return handle_vmlaunch(vcpu);
> +	case EXIT_REASON_VMPTRLD:
> +		return handle_vmptrld(vcpu);
> +	case EXIT_REASON_VMPTRST:
> +		return handle_vmptrst(vcpu);
> +	case EXIT_REASON_VMREAD:
> +		return handle_vmread(vcpu);
> +	case EXIT_REASON_VMRESUME:
> +		return handle_vmresume(vcpu);
> +	case EXIT_REASON_VMWRITE:
> +		return handle_vmwrite(vcpu);
> +	case EXIT_REASON_VMOFF:
> +		return handle_vmoff(vcpu);
> +	case EXIT_REASON_VMON:
> +		return handle_vmon(vcpu);
> +	case EXIT_REASON_INVEPT:
> +		return handle_invept(vcpu);
> +	case EXIT_REASON_INVVPID:
> +		return handle_invvpid(vcpu);
> +	case EXIT_REASON_VMFUNC:
> +		return handle_vmfunc(vcpu);
> +	}
> +

Do you really need that?  Why couldn't the handle_* functions simply be
exported from nested.c to vmx.c?

Paolo
