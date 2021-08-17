Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBAAF3EEFE4
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 17:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240332AbhHQP7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 11:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241126AbhHQP7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Aug 2021 11:59:20 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338C4C0698D7
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 08:54:45 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id mq2-20020a17090b3802b0290178911d298bso7042652pjb.1
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 08:54:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I1l3vZa0URKOckP8ZHcl+lHfQe0Kl3UQRzLmDqnGS5U=;
        b=czc5bHBd4pE61LajmSvZA9qVMzb7K1LIIpHFoK7naUz/DrEH6GsyB/vtfxxH7MeMHC
         oFxES/GzckeHiNOoYE3eK2W65/I+pe2/W7Y7o4++P2U9aR3DiL5vBJr3ElmFh8LDD4NE
         p/2302BHhPW3kAVjKIEmCxEmOOigwxfEYmWpCYt+wratu4wehskS2Vv+j75xJjOx8iQe
         sxpCvIJLN8iAIifnBLUNt/bILG8K65zZIzNmT+dg6NgqtogFYqiyDHXLyI4keLt4OJwD
         p1A6LzggV+eCX7pFdiZKbfItYGm9Fb0CK+fYpKo9qC5y+a889tsjC087sdycQJxE9yKp
         K9oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I1l3vZa0URKOckP8ZHcl+lHfQe0Kl3UQRzLmDqnGS5U=;
        b=kY4GMGqIWDEWvSs3d271i9/r1L9qZOzZCCEzH3hssDosE8kfJvxilFIfeANPdLdI2d
         2BzB/cibICD1R4mFKIrLNlMJQxCxcNtBoVCI+r9Mmio8nROFnsoSkd1I56cj57j4borX
         O1E5fO3akiJuTMc5zANAQIbIfCzK0hN18pTYFjW4oHvUAgiw+ciAj3w7BfHwUlyiRJ34
         JxBgHdZVqlRpTakoRL2gpLkZR85QNWHN9r6kQSNgurIj9z8XBOcf+bZ9B1cgdhVDY+gw
         7tZvMH+QMLsVTEZUryq2TkZor9sQ3Dn6+U59tr9pwUmO/ueeE4wQcEJ8HrwYFvjU5Dcv
         uFjA==
X-Gm-Message-State: AOAM531a1Y9SrjYFHEfzxgHuc1DvZ/oQG8VoxjO/kk9nHTOJYIL4SPmI
        17QP8q6ugyDZ4XAob+hg7ZlZhg==
X-Google-Smtp-Source: ABdhPJxJLTgQK/vAiqla8Vk97OlAx7/e1Q0CJK9MNPf5E1wI7Xh8Eb3eE3HzeUjTPkkFONhKH8MRnw==
X-Received: by 2002:a65:67d8:: with SMTP id b24mr4123928pgs.407.1629215684481;
        Tue, 17 Aug 2021 08:54:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id y12sm3099983pfa.25.2021.08.17.08.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Aug 2021 08:54:43 -0700 (PDT)
Date:   Tue, 17 Aug 2021 15:54:38 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <YRvbvqhz6sknDEWe@google.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
 <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 17, 2021, Robert Hoo wrote:
> In vmcs12_{read,write}_any(), check the field exist or not. If not, return
> failure. Hence their function prototype changed a little accordingly.
> In handle_vm{read,write}(), above function's caller, check return value, if
> failed, emulate nested vmx fail with instruction error of
> VMXERR_UNSUPPORTED_VMCS_COMPONENT.
> 
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
> Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>

Assuming Yu is a co-author, this needs to be:

  Co-developed-by: Yu Zhang <yu.c.zhang@linux.intel.com>
  Signed-off-by: Yu Zhang <yu.c.zhang@linux.intel.com>
  Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>

See "When to use Acked-by:, Cc:, and Co-developed-by:" in
Documentation/process/submitting-patches.rst.

> ---
>  arch/x86/kvm/vmx/nested.c | 20 ++++++++++++------
>  arch/x86/kvm/vmx/vmcs12.h | 43 ++++++++++++++++++++++++++++++---------
>  2 files changed, 47 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index b8121f8f6d96..9a35953ede22 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -1547,7 +1547,8 @@ static void copy_shadow_to_vmcs12(struct vcpu_vmx *vmx)
>  	for (i = 0; i < max_shadow_read_write_fields; i++) {
>  		field = shadow_read_write_fields[i];
>  		val = __vmcs_readl(field.encoding);
> -		vmcs12_write_any(vmcs12, field.encoding, field.offset, val);
> +		vmcs12_write_any(vmcs12, field.encoding, field.offset, val,
> +				 vmx->nested.vmcs12_field_existence_bitmap);

There is no need to perform existence checks when KVM is copying to/from vmcs12,
the checks are only needed for VMREAD and VMWRITE.  Architecturally, the VMCS is
an opaque blob, software cannot rely on any assumptions about its layout or data,
i.e. KVM is free to read/write whatever it wants.   VMREAD and VMWRITE need to be
enforced because architecturally they are defined to fail if the field does not exist.

Limiting this to VMREAD/VMWRITE means we shouldn't need a bitmap and can use a
more static lookup, e.g. a switch statement.  And an idea to optimize for fields
that unconditionally exist would be to use bit 0 in the field->offset table to
denote conditional fields, e.g. the VMREAD/VMRITE lookups could be something like:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index bc6327950657..ef8c48f80d1a 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5064,7 +5064,7 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
        /* Decode instruction info and find the field to read */
        field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));

-       offset = vmcs_field_to_offset(field);
+       offset = vmcs_field_to_offset(vmx, field);
        if (offset < 0)
                return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);

@@ -5167,7 +5167,7 @@ static int handle_vmwrite(struct kvm_vcpu *vcpu)

        field = kvm_register_read(vcpu, (((instr_info) >> 28) & 0xf));

-       offset = vmcs_field_to_offset(field);
+       offset = vmcs_field_to_offset(vmx, field);
        if (offset < 0)
                return nested_vmx_fail(vcpu, VMXERR_UNSUPPORTED_VMCS_COMPONENT);

diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
index 2a45f026ee11..3c27631e0119 100644
--- a/arch/x86/kvm/vmx/vmcs12.h
+++ b/arch/x86/kvm/vmx/vmcs12.h
@@ -364,7 +364,8 @@ static inline void vmx_check_vmcs12_offsets(void)
 extern const unsigned short vmcs_field_to_offset_table[];
 extern const unsigned int nr_vmcs12_fields;

-static inline short vmcs_field_to_offset(unsigned long field)
+static inline short vmcs_field_to_offset(struct vcpu_vmx *vmx,
+                                        unsigned long field)
 {
        unsigned short offset;
        unsigned int index;
@@ -378,9 +379,10 @@ static inline short vmcs_field_to_offset(unsigned long field)

        index = array_index_nospec(index, nr_vmcs12_fields);
        offset = vmcs_field_to_offset_table[index];
-       if (offset == 0)
+       if (offset == 0 ||
+           ((offset & 1) && !vmcs12_field_exists(vmx, field)))
                return -ENOENT;
-       return offset;
+       return offset & ~1;
 }

 static inline u64 vmcs12_read_any(struct vmcs12 *vmcs12, unsigned long field,
