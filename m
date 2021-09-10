Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6BCF4072EF
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 23:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234581AbhIJVaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Sep 2021 17:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbhIJVaH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Sep 2021 17:30:07 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C791C061756
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 14:28:56 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so2407857pjc.3
        for <kvm@vger.kernel.org>; Fri, 10 Sep 2021 14:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gG9IwTokKzd7dSKb8PeJxanH6u5ukkUKIIJ5lnDDNxI=;
        b=l/+q/oSUDmPIKALXMZ3wqCtJEI78CDp8YhLDB0hTM1i/xoQaF2NJUFB2hU0OSNPn6j
         8EguJiZuSqHXLv6mukv7N6+jp0HKzKe9MncTbtbNjrj5oGr3hvzuz5iRpnO9VLpqTdnI
         SnRUBXZu3KFv/2yjOFSWMYotHqt375Z37om2C8tHekDo8qXK/kcjpsMzsC6nizejtx1U
         HNE5/5fbyIVRf5iPSj1CWkscu82lKU7c6rFFn+eDCnkE7McNCmnFgCktxI3a/VqJHOA9
         ux6zGpUpV6BQGPjnvpSB8TG4lnxiHCot901phaBjcUZBMRaPdpkzPJOjrKO1ugJ4G7+k
         w3FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gG9IwTokKzd7dSKb8PeJxanH6u5ukkUKIIJ5lnDDNxI=;
        b=MLbAcVqmNwxa2M9UqphpwaDp10e7FZws6Hiig1mOSwYdjKRWGNbHevOrBrt2Vx8lD0
         q34iY16o6rRI3qeEBl33h6nyZajC0iPPcpFSryZy4b6icEqWBQX9Zs2juGf4296DBWgo
         yKkDCaNyd3LlH0PbS0fZnbrmrVvfb+AgaDJz3SRsQ453MlIyXibsnzNAuub+x8u2BWlT
         rdYtg0ADLgEeQuKZLITzPwzKqBbgz8+yZn0mfIg6L3uliVUIeerDznkaQhGKvGaATSn3
         or5sDGHBT+o8P7PkYCvFwIut2m3HwliH5BcG27+pOxsavew37AOVlZkLfwlUF0+1mSeW
         iTGw==
X-Gm-Message-State: AOAM531SWTxboi3N/uxW9Y+ykLbd6mY9nPAQZCZi7lc7T/UvMMrsX7y2
        oDjSudeVuiybafJBaxxPH3l/67RcaRtq+g==
X-Google-Smtp-Source: ABdhPJxNtsdV+HthlH6Eua/ONGurdm934+6DceWpILF+CAFY1RN1ZUzv02K1zg2EL5p8esPE1sy/7Q==
X-Received: by 2002:a17:90b:1d0e:: with SMTP id on14mr11540807pjb.97.1631309335655;
        Fri, 10 Sep 2021 14:28:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id u12sm10827pjx.31.2021.09.10.14.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 14:28:55 -0700 (PDT)
Date:   Fri, 10 Sep 2021 21:28:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Kai Huang <kai.huang@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Robert Hu <robert.hu@intel.com>,
        Gao Chao <chao.gao@intel.com>,
        Robert Hoo <robert.hu@linux.intel.com>
Subject: Re: [PATCH v4 2/6] KVM: VMX: Extend BUILD_CONTROLS_SHADOW macro to
 support 64-bit variation
Message-ID: <YTvOE3p7WRGYUg9h@google.com>
References: <20210809032925.3548-1-guang.zeng@intel.com>
 <20210809032925.3548-3-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809032925.3548-3-guang.zeng@intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021, Zeng Guang wrote:
> +static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)	\
> +{									\
> +	return vmx->loaded_vmcs->controls_shadow.lname;			\
> +}									\

This conflicts with commit 389ab25216c9 ("KVM: nVMX: Pull KVM L0's desired controls
directly from vmcs01"), I believe the correct resolution is:

---
 arch/x86/kvm/vmx/vmx.h | 59 ++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 28 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 4858c5fd95f2..1ae43afe52a7 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -408,35 +408,38 @@ static inline u8 vmx_get_rvi(void)
 	return vmcs_read16(GUEST_INTR_STATUS) & 0xff;
 }

-#define BUILD_CONTROLS_SHADOW(lname, uname)				    \
-static inline void lname##_controls_set(struct vcpu_vmx *vmx, u32 val)	    \
-{									    \
-	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		    \
-		vmcs_write32(uname, val);				    \
-		vmx->loaded_vmcs->controls_shadow.lname = val;		    \
-	}								    \
-}									    \
-static inline u32 __##lname##_controls_get(struct loaded_vmcs *vmcs)	    \
-{									    \
-	return vmcs->controls_shadow.lname;				    \
-}									    \
-static inline u32 lname##_controls_get(struct vcpu_vmx *vmx)		    \
-{									    \
-	return __##lname##_controls_get(vmx->loaded_vmcs);		    \
-}									    \
-static inline void lname##_controls_setbit(struct vcpu_vmx *vmx, u32 val)   \
-{									    \
-	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	    \
-}									    \
-static inline void lname##_controls_clearbit(struct vcpu_vmx *vmx, u32 val) \
-{									    \
-	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	    \
+#define BUILD_CONTROLS_SHADOW(lname, uname, bits)			\
+static inline								\
+void lname##_controls_set(struct vcpu_vmx *vmx, u##bits val)		\
+{									\
+	if (vmx->loaded_vmcs->controls_shadow.lname != val) {		\
+		vmcs_write##bits(uname, val);				\
+		vmx->loaded_vmcs->controls_shadow.lname = val;		\
+	}								\
+}									\
+static inline u##bits __##lname##_controls_get(struct loaded_vmcs *vmcs)\
+{									\
+	return vmcs->controls_shadow.lname;				\
+}									\
+static inline u##bits lname##_controls_get(struct vcpu_vmx *vmx)	\
+{									\
+	return __##lname##_controls_get(vmx->loaded_vmcs);		\
+}									\
+static inline								\
+void lname##_controls_setbit(struct vcpu_vmx *vmx, u##bits val)		\
+{									\
+	lname##_controls_set(vmx, lname##_controls_get(vmx) | val);	\
+}									\
+static inline								\
+void lname##_controls_clearbit(struct vcpu_vmx *vmx, u##bits val)	\
+{									\
+	lname##_controls_set(vmx, lname##_controls_get(vmx) & ~val);	\
 }
-BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS)
-BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS)
-BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL)
-BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL)
-BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL)
+BUILD_CONTROLS_SHADOW(vm_entry, VM_ENTRY_CONTROLS, 32)
+BUILD_CONTROLS_SHADOW(vm_exit, VM_EXIT_CONTROLS, 32)
+BUILD_CONTROLS_SHADOW(pin, PIN_BASED_VM_EXEC_CONTROL, 32)
+BUILD_CONTROLS_SHADOW(exec, CPU_BASED_VM_EXEC_CONTROL, 32)
+BUILD_CONTROLS_SHADOW(secondary_exec, SECONDARY_VM_EXEC_CONTROL, 32)

 static inline void vmx_register_cache_reset(struct kvm_vcpu *vcpu)
 {
--
