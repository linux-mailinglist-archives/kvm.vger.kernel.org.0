Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB04188BE0
	for <lists+kvm@lfdr.de>; Tue, 17 Mar 2020 18:18:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgCQRSG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Mar 2020 13:18:06 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:42247 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726148AbgCQRSF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Mar 2020 13:18:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584465484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WXUpo1ZhaHsxegJLjY6D/kOQQn485KZpkhgRPPqUjR0=;
        b=PevM1FrTcCIEG9DJITqOVjrv7tYqJNaiyOQDckZNUSh7c+x9tlBcQFTByYH3iATnFnjxWA
        fFvjrouUwMVjTgSS5NYjC0i+RWTCbljJShdVJQeWN46kQu+KjvXEAhdLptgwtSTZsknGND
        LcTsiC8/zMQY9WJx1or68y0Wwo/LEn0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-444-q3wDp8gpNl-sMiOd56OQ-w-1; Tue, 17 Mar 2020 13:18:02 -0400
X-MC-Unique: q3wDp8gpNl-sMiOd56OQ-w-1
Received: by mail-wr1-f69.google.com with SMTP id p2so8447497wrw.8
        for <kvm@vger.kernel.org>; Tue, 17 Mar 2020 10:18:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WXUpo1ZhaHsxegJLjY6D/kOQQn485KZpkhgRPPqUjR0=;
        b=j9ewuBMsL43Ez2t65T0mkYoHrR/SA28l1V4EqqZLzVH90bhvF7ahBsLMZKB4QwbWtB
         7QVSA4acOCUHmtGJEC3iN4sZDp13kpptzigao529eZGjDmzUy3HcOpqASB/+Iogv/+Ta
         LcTC+4Zv0dDYvLDQZfA55Q+CsY66ZmnaB0sNd5mfjyyIPbWUiRn87pQM2mfMYdACULK+
         r9yc/hLdHsc5tu3xG/FyqZkOB93FlNo8Me4jIy1dfuOA65CHoZIe+DSAA0hRGxgH2W1l
         aXdbI/3wOw3RVbgvijCuCIBiHWppDanKXYWAbWXKadEQzn0EXL1jcwQ55svPw9yX8/Fh
         dl5w==
X-Gm-Message-State: ANhLgQ1NmB7UxJ35dZtdVcd5iUiLW+GGB0zFk1nigpF7ok1crS/tH1uo
        VjY+Nnjo9OBMr3WL+iJuzPBwqgUz9L1VXP76bQob2cug1+elX1xynIvJjmQQisoCGczWR5WPnN5
        mZvcNMnLc8PFM
X-Received: by 2002:a7b:c115:: with SMTP id w21mr68906wmi.158.1584465481606;
        Tue, 17 Mar 2020 10:18:01 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuKYTV/Kjwq397PdHeEtnqiG4fFlpYodL/S4xQgC/bL3dV7vsEF/9gjXQGnOI/m6nnmoB/C1A==
X-Received: by 2002:a7b:c115:: with SMTP id w21mr68878wmi.158.1584465481345;
        Tue, 17 Mar 2020 10:18:01 -0700 (PDT)
Received: from [192.168.178.58] ([151.21.15.227])
        by smtp.gmail.com with ESMTPSA id z6sm5095665wrp.95.2020.03.17.10.17.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Mar 2020 10:18:00 -0700 (PDT)
Subject: Re: [PATCH v2 23/32] KVM: nVMX: Add helper to handle TLB flushes on
 nested VM-Enter/VM-Exit
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
 <20200317045238.30434-24-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0975d43f-42b6-74db-f916-b0995115d726@redhat.com>
Date:   Tue, 17 Mar 2020 18:17:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200317045238.30434-24-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/03/20 05:52, Sean Christopherson wrote:
> +	nested_vmx_transition_tlb_flush(vcpu, vmcs12);
> +
> +	/*
> +	 * There is no direct mapping between vpid02 and vpid12, vpid02 is
> +	 * per-vCPU and reused for all nested vCPUs.  If vpid12 is changing
> +	 * then the new "virtual" VPID will reuse the same "real" VPID,
> +	 * vpid02, and so needs to be sync'd.  Skip the sync if a TLB flush
> +	 * has already been requested, but always update the last used VPID.
> +	 */
> +	if (nested_cpu_has_vpid(vmcs12) && nested_has_guest_tlb_tag(vcpu) &&
> +	    vmcs12->virtual_processor_id != vmx->nested.last_vpid) {
> +		vmx->nested.last_vpid = vmcs12->virtual_processor_id;
> +		if (!kvm_test_request(KVM_REQ_TLB_FLUSH, vcpu))
> +			vpid_sync_context(nested_get_vpid02(vcpu));
>  	}

Would it make sense to move nested_vmx_transition_tlb_flush into an
"else" branch?  And should this also test that KVM_REQ_TLB_FLUSH_CURRENT
is not set?

Paolo

