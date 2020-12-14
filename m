Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F346C2DA2BC
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 22:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503583AbgLNVq1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 16:46:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33808 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503565AbgLNVqS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Dec 2020 16:46:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607982292;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y5+S7Ad2XyX9pkxnkrXX2LGZ2aRhSIyfHipDehm+l+E=;
        b=L1H+m8+YRl71EexhEwq9at0A6xffBmkgYf8LnfWfW9bgw4bRv+IsVItvyCBkJYEm2oinU1
        dwEijEDQgJ7kOrxrBiWRX70DzxwRp8nOzbpPgmnYSknlEd3aaZtwBYmdRApp8GZkgGuFxJ
        qYI9pXWDWdD/x6wq9S3Ih9TPes08vz8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-484-bgBY6BcYPlmx4X6yEMLN_A-1; Mon, 14 Dec 2020 16:44:50 -0500
X-MC-Unique: bgBY6BcYPlmx4X6yEMLN_A-1
Received: by mail-ed1-f72.google.com with SMTP id d12so8980606edx.23
        for <kvm@vger.kernel.org>; Mon, 14 Dec 2020 13:44:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Y5+S7Ad2XyX9pkxnkrXX2LGZ2aRhSIyfHipDehm+l+E=;
        b=OTHAMH7SRiYSH3hCBSEfVpgMkSB7WHe3mWMC3RisKnCwRalKSPAPYpHZiomg1lRorc
         2nTKGcqmKt2FyllbaI5MX2s/Ob47YGLqmAEF7Q88Tg0/4+AMbg/fgbV2CiSGL2Amzmbh
         1BQKL6Ai3UnIfHQTpCib+jLlVIkcJuBHLQ+D7OUPSdFAvwmrTmAYIB5LlP9rzaz7KjTg
         nC5zEYAaYHRwCvel2vXbZfCAFVKCEXwEv1p981Oy0cvAdrmTWcrCgUvxefrDgHvKZalL
         2xZ/eO9D14UEQSsfzVS43XlnhZpEiXMR2sCB7W8l98IkQQKpcZCBwJgEk/Xuow85ttBr
         cubQ==
X-Gm-Message-State: AOAM5307lIdU9slG/WXu3tWZO4qS9G2GqW4u9eZhLGyM1ypM/YD3OXZn
        jpeayFt53IA5iYkXVIjP9L5V0wXoLGYkvGpkEre+mXGPbWJk2FNEHwekSJBjdsUuOxNYuAKFpLK
        RFBv2EXd6bnxK
X-Received: by 2002:a17:906:7146:: with SMTP id z6mr24248208ejj.379.1607982289242;
        Mon, 14 Dec 2020 13:44:49 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzpP/qHyvqyAW3R6HFy98z0QrKXZtowZdOYvRvJsjvgoFnL/28dB06toMKKxPeFTfy30xKWZA==
X-Received: by 2002:a17:906:7146:: with SMTP id z6mr24248186ejj.379.1607982289063;
        Mon, 14 Dec 2020 13:44:49 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id i4sm165405eje.90.2020.12.14.13.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 13:44:48 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Sean Christopherson <seanjc@google.com>, graf@amazon.com,
        iaslan@amazon.de, pdurrant@amazon.com, aagch@amazon.com,
        fandree@amazon.com
Subject: Re: [PATCH v3 02/17] KVM: x86/xen: fix Xen hypercall page msr handling
In-Reply-To: <58AC82A4-ADE4-4A8F-9522-16B8A4B9CBDD@infradead.org>
References: <20201214083905.2017260-1-dwmw2@infradead.org>
 <20201214083905.2017260-3-dwmw2@infradead.org>
 <87czzcw020.fsf@vitty.brq.redhat.com>
 <58AC82A4-ADE4-4A8F-9522-16B8A4B9CBDD@infradead.org>
Date:   Mon, 14 Dec 2020 22:44:47 +0100
Message-ID: <877dpkvz8w.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> writes:

>>> @@ -3001,6 +3001,9 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu,
>>struct msr_data *msr_info)
>>>  	u32 msr = msr_info->index;
>>>  	u64 data = msr_info->data;
>>>  
>>> +	if (msr && (msr == vcpu->kvm->arch.xen_hvm_config.msr))
>>> +		return xen_hvm_config(vcpu, data);
>>> +
>>
>>Can we generalize this maybe? E.g. before handling KVM and
>>architectural
>>MSRs we check that the particular MSR is not overriden by an emulated
>>hypervisor, 
>>
>>e.g.
>>	if (kvm_emulating_hyperv(kvm) && kvm_hyperv_msr_overriden(kvm,msr)
>>		return kvm_hyperv_handle_msr(kvm, msr);
>>	if (kvm_emulating_xen(kvm) && kvm_xen_msr_overriden(kvm,msr)
>>		return kvm_xen_handle_msr(kvm, msr);
>
> That smells a bit like overengineering. As I said, I did have a play
> with "improving" Joao's original patch but nothing I tried actually
> made more sense to me than this once the details were ironed out.

This actually looks more or less like hypercall distinction from after PATCH3:

	if (kvm_xen_hypercall_enabled(vcpu->kvm))
		return kvm_xen_hypercall(vcpu);

        if (kvm_hv_hypercall_enabled(vcpu->kvm))
  	        return kvm_hv_hypercall(vcpu);

....

so my idea was why not do the same for MSRs?

-- 
Vitaly

