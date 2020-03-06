Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42E3217B9D6
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2020 11:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgCFKG5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Mar 2020 05:06:57 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28614 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726079AbgCFKG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Mar 2020 05:06:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583489215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CNDhmKPPyjU/I8ZjQqjbJHAaz9m6Pife/JBLkiK4lO0=;
        b=Fbq6E4aayTeqC7ax+TfWPFZsVBHiViY7afgvbA8Ynj4Whh9AsPmqmEIkzTvrmq6nGV6TCF
        HlwX4pjGvfVRqaJvBmsuXdOWsrpdAyvXQZg9+q6tkRwweXnBXJfrAOlYwVTmq2tyw60Css
        frJ1p70NGJpEaJCkOYZ1LwqKlKxYkZI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-cCtNAOQhPjWfRgPeQRiBVQ-1; Fri, 06 Mar 2020 05:06:54 -0500
X-MC-Unique: cCtNAOQhPjWfRgPeQRiBVQ-1
Received: by mail-wm1-f70.google.com with SMTP id q20so447638wmg.1
        for <kvm@vger.kernel.org>; Fri, 06 Mar 2020 02:06:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=CNDhmKPPyjU/I8ZjQqjbJHAaz9m6Pife/JBLkiK4lO0=;
        b=cXtWE0OlRJjXnsEtxfeuhSu40K43Dnt7OVig5SdtMjsKZjE+LqxIBWDK1txUzbA3Es
         9DDj+6RFgdmLqq51REh/WgqZspEfgjTTpkp8/mAyQOfbEpAHM1xIrXzxyTA0A3wnWKjW
         BHvolpMbS1VHDx4ASpxoQQRGoErxUafk2HBzvqzI1VgEVdXxA75Lzz80VIu41c9/keKv
         gxU48K9WD2g5dyJOr1Yumd7JkLWykKQlrTnYz9ygKjQD9mQdXDcz7WWJomR0kwfTmRtf
         FNgOJaBFOP1JIVK7mpbp/pzavH05TFu73m5virCVjHrVmu9CWik9NBovSavTJwCIOXlW
         omJA==
X-Gm-Message-State: ANhLgQ1elbL7GUlzJaAAMW5vdIsaf0OPPoz9FPSWpMrdmpxno6g9t7my
        7GJYMOBJqMtd8uan/rzGT+nlFvqeimb0vw8/1qTGoilwmCUIhz1tbzRW0SHfItebKInVkaUW7c0
        IDLAZKFf0E6ZA
X-Received: by 2002:a05:600c:2f01:: with SMTP id r1mr3145205wmn.31.1583489213314;
        Fri, 06 Mar 2020 02:06:53 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsCpKnLythwz5ylIW58CeFo2DLM+USTBNualw4sqyWdiqnoAs2Lj09ZRAWLj+zXfMhkGZXnnA==
X-Received: by 2002:a05:600c:2f01:: with SMTP id r1mr3145181wmn.31.1583489213031;
        Fri, 06 Mar 2020 02:06:53 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id s2sm10338017wmj.15.2020.03.06.02.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2020 02:06:52 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] KVM: VMX: untangle VMXON revision_id setting when using eVMCS
In-Reply-To: <20200305201000.GQ11500@linux.intel.com>
References: <20200305183725.28872-1-vkuznets@redhat.com> <20200305183725.28872-3-vkuznets@redhat.com> <20200305201000.GQ11500@linux.intel.com>
Date:   Fri, 06 Mar 2020 11:06:51 +0100
Message-ID: <87pndper0k.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> On Thu, Mar 05, 2020 at 07:37:25PM +0100, Vitaly Kuznetsov wrote:
>> As stated in alloc_vmxon_regions(), VMXON region needs to be tagged with
>> revision id from MSR_IA32_VMX_BASIC even in case of eVMCS. The logic to
>> do so is not very straightforward: first, we set
>> hdr.revision_id = KVM_EVMCS_VERSION in alloc_vmcs_cpu() just to reset it
>> back to vmcs_config.revision_id in alloc_vmxon_regions(). Simplify this by
>> introducing 'enum vmcs_type' parameter to alloc_vmcs_cpu().
>> 
>> No functional change intended.
>> 
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>
> ...
>
>> +	 * However, even though not explicitly documented by TLFS, VMXArea
>> +	 * passed as VMXON argument should still be marked with revision_id
>> +	 * reported by physical CPU.
>
> LOL, nice.
>
>
>> +	 */
>> +	if (type != VMXON_REGION && static_branch_unlikely(&enable_evmcs))
>>  		vmcs->hdr.revision_id = KVM_EVMCS_VERSION;
>>  	else
>>  		vmcs->hdr.revision_id = vmcs_config.revision_id;
>>  
>> -	if (shadow)
>> +	if (type == SHADOW_VMCS_REGION)
>>  		vmcs->hdr.shadow_vmcs = 1;
>>  	return vmcs;
>>  }
>
>> -struct vmcs *alloc_vmcs_cpu(bool shadow, int cpu, gfp_t flags);
>> +enum vmcs_type {
>> +	VMXON_REGION,
>> +	VMCS_REGION,
>> +	SHADOW_VMCS_REGION,
>> +};
>> +
>> +struct vmcs *alloc_vmcs_cpu(enum vmcs_type type, int cpu, gfp_t flags);
>>  void free_vmcs(struct vmcs *vmcs);
>>  int alloc_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
>>  void free_loaded_vmcs(struct loaded_vmcs *loaded_vmcs);
>> @@ -498,8 +504,8 @@ void loaded_vmcs_clear(struct loaded_vmcs *loaded_vmcs);
>>  
>>  static inline struct vmcs *alloc_vmcs(bool shadow)
>
> I think it'd be cleaner overall to take "enum vmcs_type" in alloc_vmcs().
> Then the ternary operator goes away and the callers (all two of 'em) are
> self-documenting.

Ya, it didn't seem to be needed with my initial suggestion to rename
alloc_vmcs_cpu() to alloc_vmx_area_cpu() because in case we think of
VMXON region as something different from VMCS we have only two options:
normal VMCS or shadow VMCS and bool flag works perfectly. 

v3 is on the way, stay tuned!

-- 
Vitaly

