Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E19188BE6
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 18:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgCQRSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 13:18:47 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:39227 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726713AbgCQRSq (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 13:18:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584465525;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g5XpwPdHQEwJufVi+3YndUETigdnZ6TaIE8j53RUJmw=;
        b=dMIYTf82BxImmF6QiRzghUY0yuiTY47v8G+BmatbDrIy3hrpwKzFKmEhdQMm2A9bf21OFz
        jWMyN/ZmApvACgNIU0ZWkvFDi1ECJ8Nc39JIzL4aGSB9sOdY8WIy4+Y3LPwbA/xlsevEvY
        ZPaPkYKlir34S7ahVjrSVppgZ9i0/ac=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-308-HKN03uMaPmugN7B3a1SpLw-1; Tue, 17 Mar 2020 13:18:44 -0400
X-MC-Unique: HKN03uMaPmugN7B3a1SpLw-1
Received: by mail-wr1-f70.google.com with SMTP id c6so10913061wrm.18
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 10:18:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g5XpwPdHQEwJufVi+3YndUETigdnZ6TaIE8j53RUJmw=;
        b=EQqC/PhvR4mMlx+d7m/Kk1hpfWKo+4LfyMcEgZchXLiR3fEtqK0iEPJ8ZGi5CS1YyG
         xoRBn+hsa9PG8t8geQfkI1caHFXOgytRFqTb3fVEUQwb4iW+/HKwNEmpKXQmTYXZ28oc
         NlyxiKOFyVCOXhqN/PVhguuXC2jYDvkPsd+oVixDIPphdA2Rn+Lajmr07+2qLXyo/XGJ
         3k6/xUHiDmbXbfVOy+53P+DYJfJ0x5UaB5h18DWoIT2Y/RoXqk1Nf/FQyx4Zz8tih2Or
         sa9OjsIoNf3fqddOZcRL1pyd3ljACGLTOX+S52m6+Sc/IsaIUESNFCAp2iVf7k+bogTO
         R7kg==
X-Gm-Message-State: ANhLgQ0Dq5ujJxbudwB5PrjA/Cr4EhjZAxsxOnRFFCRxoYTk7++iTkqH
        ML8aehAuO0OVDpAWfKNdQ6eOL2c5Hu1Ys3wBrHY8Qx62oIGqhgtG9vRNeYE8SW9Va4R12bKyOKQ
        H+GkFU/gYy9pb
X-Received: by 2002:a7b:c341:: with SMTP id l1mr67449wmj.146.1584465520443;
        Tue, 17 Mar 2020 10:18:40 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtzzek2Rz3ChXItSdk+lQxOau9MzPKMaLEjYAxMfONZx6YbAwlKCBYgiLOLumRQXRY2A42boA==
X-Received: by 2002:a7b:c341:: with SMTP id l1mr67427wmj.146.1584465520187;
        Tue, 17 Mar 2020 10:18:40 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.227])
        by smtp.gmail.com with ESMTPSA id o3sm92469wme.36.2020.03.17.10.18.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 10:18:39 -0700 (PDT)
Subject: Re: [PATCH v2 31/32] KVM: nVMX: Don't flush TLB on nested VM
 transition with EPT enabled
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
References: <20200317045238.30434-1-sean.j.christopherson@intel.com>
 <20200317045238.30434-32-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <97f91b27-65ac-9187-6b60-184e1562d228@redhat.com>
Date:   Tue, 17 Mar 2020 18:18:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200317045238.30434-32-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/20 05:52, Sean Christopherson wrote:
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index d816f1366943..a77eab5b0e8a 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1123,7 +1123,7 @@ static int nested_vmx_load_cr3(struct kvm_vcpu *vcpu, unsigned long cr3, bool ne
>  	}
>  
>  	if (!nested_ept)
> -		kvm_mmu_new_cr3(vcpu, cr3, false);
> +		kvm_mmu_new_cr3(vcpu, cr3, enable_ept);

Even if enable_ept == false, we could have already scheduled or flushed
the TLB soon due to one of 1) nested_vmx_transition_tlb_flush 2)
vpid_sync_context in prepare_vmcs02 3) the processor doing it for
!enable_vpid.

So for !enable_ept only KVM_REQ_MMU_SYNC is needed, not
KVM_REQ_TLB_FLUSH_CURRENT I think.  Worth adding a TODO?

Paolo

>  	vcpu->arch.cr3 = cr3;
>  	kvm_register_mark_available(vcpu, VCPU_EXREG_CR3);
> -- 2.24.1

