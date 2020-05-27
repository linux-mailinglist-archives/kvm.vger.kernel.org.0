Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C561A1E49D0
	for <lists+kvm@lfdr.de>; Wed, 27 May 2020 18:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390459AbgE0QW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 May 2020 12:22:56 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44711 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389867AbgE0QWz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 27 May 2020 12:22:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590596573;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kkIuCDubwsQgXBHRbq8HuCA0dPFnsG7/F0u1pND+K1M=;
        b=PSKVQkgYf8bdrK8Yz3rapq5/gz7ifUI85peHYI7cLIBOMnC36nOSAay20BMHczFBLOgZJj
        YXSpc0Xl2g5CmXGKrSrkUWg37yv/TfEiF53BLjHYw83C3+f/cLV5NQfxYJLjtAF2Pr8HsD
        GyshPwb4EFF7GT6oRrLamGINkIbzdng=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-XJi9OcmxMpSpoupniVrxFQ-1; Wed, 27 May 2020 12:22:49 -0400
X-MC-Unique: XJi9OcmxMpSpoupniVrxFQ-1
Received: by mail-wr1-f71.google.com with SMTP id j8so4661828wrb.9
        for <kvm@vger.kernel.org>; Wed, 27 May 2020 09:22:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kkIuCDubwsQgXBHRbq8HuCA0dPFnsG7/F0u1pND+K1M=;
        b=K/fou9tQRECJY2mEXlF2AyOAi6WU31gG2439gXt1AfDlFe95rY43mZ/wYvUDi+pFeX
         DiUp0uATLYRrOuTSfHNjvat6JxHX2MX+LR/0Ql0oIIApiXYvbRMYzeZVnjtuRQS0auZa
         G9v5azTcWkzjlfRHrSlnvnAAwOaSIzkbzeS6C/EwoZt+Lv6cV4Ax56STcqFYVmtZV1zP
         bRSnTooGiyLrRxQtNqy9KbgYel5z+uZci3OO1aSYdEmWTGAJHqjAF6z3E70e9TtkL7Ym
         LLLMUViqodiyAfxurehEr65q76vzx+Z8Y83AYud74bpkGiU9wdRobW9GK1rHzqNCm5ni
         AAQA==
X-Gm-Message-State: AOAM5301P35Sf91lIDgZOo0xc+yGD4h9nlYjgvJCd2XauHb4tFV4hTNI
        tyx2YQ4S5jOroQipaJZ5DzVt+8gzf9JSvhkdi1dfXXSV3PmUoF9kMT1lB0FfDO5VdLBruprrf3b
        nH2npjOgedMD0
X-Received: by 2002:adf:e749:: with SMTP id c9mr27943896wrn.25.1590596568781;
        Wed, 27 May 2020 09:22:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzU3W3wlPdrHjX3Eo7+1zUe99QF6D/QC0CsMz9GjINfl7vO7s5L+Un71SevMMLQtw9y6E7K/A==
X-Received: by 2002:adf:e749:: with SMTP id c9mr27943874wrn.25.1590596568568;
        Wed, 27 May 2020 09:22:48 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:3c1c:ffba:c624:29b8? ([2001:b07:6468:f312:3c1c:ffba:c624:29b8])
        by smtp.gmail.com with ESMTPSA id o9sm3477803wmh.37.2020.05.27.09.22.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:22:48 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: nSVM: Preserve registers modifications done
 before nested_svm_vmexit()
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Cathy Avery <cavery@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20200527090102.220647-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ca770778-5f89-c24a-7350-a590e4e194ca@redhat.com>
Date:   Wed, 27 May 2020 18:22:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200527090102.220647-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/05/20 11:01, Vitaly Kuznetsov wrote:
> L2 guest hang is observed after 'exit_required' was dropped and nSVM
> switched to check_nested_events() completely. The hang is a busy loop when
> e.g. KVM is emulating an instruction (e.g. L2 is accessing MMIO space and
> we drop to userspace). After nested_svm_vmexit() and when L1 is doing VMRUN
> nested guest's RIP is not advanced so KVM goes into emulating the same
> instruction which caused nested_svm_vmexit() and the loop continues.
> 
> nested_svm_vmexit() is not new, however, with check_nested_events() we're
> now calling it later than before. In case by that time KVM has modified
> register state we may pick stale values from VMCB when trying to save
> nested guest state to nested VMCB.
> 
> nVMX code handles this case correctly: sync_vmcs02_to_vmcs12() called from
> nested_vmx_vmexit() does e.g 'vmcs12->guest_rip = kvm_rip_read(vcpu)' and
> this ensures KVM-made modifications are preserved. Do the same for nSVM.
> 
> Generally, nested_vmx_vmexit()/nested_svm_vmexit() need to pick up all
> nested guest state modifications done by KVM after vmexit. It would be
> great to find a way to express this in a way which would not require to
> manually track these changes, e.g. nested_{vmcb,vmcs}_get_field().
> 
> Co-debugged-with: Paolo Bonzini <pbonzini@redhat.com>

Huh, not really, but thanks. :)  Patch queued!

Paolo

