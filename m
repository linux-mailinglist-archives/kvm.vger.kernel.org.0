Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79A247416D
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 12:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhLNLYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 06:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233532AbhLNLYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 06:24:53 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEC7C061574;
        Tue, 14 Dec 2021 03:24:52 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id z9so7321578edb.5;
        Tue, 14 Dec 2021 03:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Gi8RWAGQiNmIoGHwdzspSi43uqAcj/GOO0MFBwRaPoI=;
        b=IfWWiDX5jVFFu0B3ddGZNAusdJcyG9IX6+DRUAluS+eTvYJz9gNRJrx3M8AAby8hsD
         ZSMQozk0iUTV4i9UzPxajlTN4+quIij+4k8Yb1s7+KpkkrIq+1DHehN1o8BmH1d1GuB+
         8J4GC8aVJbrjDt8QupVMroIA9n5yIflNkTz48Jgn13283otm7udVvOyNs0PikOyIDUHK
         0i6XRG9IEaYhG5ntprpwNScHueOl4pXXPpWJkqPL/IqX9ujF4kx7dJxil0l8l96RMZLv
         0COXMWB+ghTNvfSe4DL444e2oFipg9XS/ISQX8ZAf2lbZSEhXUfzGx1vRjmB5/sxxjtl
         JwWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Gi8RWAGQiNmIoGHwdzspSi43uqAcj/GOO0MFBwRaPoI=;
        b=REHLwvMXry53ubKlELESwWJYId+xrJf3F9mYQjascSYU4MgioESrj+a1JfrOTRB46m
         0wlrdxHoHRcyEERvyymTY53Kzz+JPHG4xxKVGq98HrgpSM2cyuGId/14q0V7t9nACC17
         CHaRpJrAalZtBpdbAjpLfFswR8CilBgAvrs55GQQSJ+GnpHeW5vvMJGS+h93EHE44H87
         R+dD9qLmRFsXnhSHcp751fZiBUqw8XFJbNgrnlGgUJxbIDK73lnngB6LfS7n3GgD5BhX
         rLhdI0XLt9CRdIKc6cVO42sj6A15PpoxCLLgC9BwTD6MoQ27iY8qpq2iAtDKKiJ5Vc6r
         pBkw==
X-Gm-Message-State: AOAM532CzzDSfAjwN8mTykriNVlGAsA+G1Wp9x2y4pX3XKdElWExfhDN
        /ISWWK6vEKfEalenCCZbvqE=
X-Google-Smtp-Source: ABdhPJx1tJz+OIgYK8aRcvyHsWg1WHl3Xo63MeoukglXRXKNPTttkY02hGUDXONX/TAmsFLMu27KEA==
X-Received: by 2002:a50:da48:: with SMTP id a8mr7036863edk.155.1639481090570;
        Tue, 14 Dec 2021 03:24:50 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id v3sm7837607edc.69.2021.12.14.03.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 03:24:50 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <85401305-2c71-e57f-a01e-4850060d300a@redhat.com>
Date:   Tue, 14 Dec 2021 12:24:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 10/19] kvm: x86: Emulate WRMSR of guest IA32_XFD
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com, seanjc@google.com,
        jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-11-yang.zhong@intel.com>
 <fd16797c-b80f-c414-a731-0b9b73a3732e@redhat.com>
 <20211214102619.GA25456@yangzhon-Virtual>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211214102619.GA25456@yangzhon-Virtual>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/21 11:26, Yang Zhong wrote:
>    Paolo, Seems we do not need new KVM_EXIT_* again from below thomas' new patchset:
>    git://git.kernel.org/pub/scm/linux/kernel/git/people/tglx/devel.git x86/fpu-kvm
> 
>    So the selftest stll need support KVM_GET_MSR/KVM_SET_MSR for MSR_IA32_XFD
>    and MSR_IA32_XFD_ERR? If yes, we only do some read/write test with vcpu_set_msr()/
>    vcpu_get_msr() from new selftest tool? or do wrmsr from guest side and check this value
>    from selftest side?

You can write a test similar to state_test.c to cover XCR0, XFD and the
new XSAVE extensions.  The test can:

- initialize AMX and write a nonzero value to XFD

- load a matrix into TMM0

- check that #NM is delivered (search for vm_install_exception_handler) and
that XFD_ERR is correct

- write 0 to XFD

- load again the matrix, and check that #NM is not delivered

- store it back into memory

- compare it with the original data

All of this can be done with a full save&restore after every step
(though I suggest that you first get it working without save&restore,
the relevant code in state_test.c is easy to identify and comment out).

You will have to modify vcpu_load_state, so that it does
first KVM_SET_MSRS, then KVM_SET_XCRS, then KVM_SET_XSAVE.
See patch below.

Paolo

>    I checked some msr selftest reference code, tsc_msrs_test.c, which maybe better for this
>    reference. If you have better suggestion, please share it to me. thanks!


------------------ 8< -----------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] selftest: kvm: Reorder vcpu_load_state steps for AMX

For AMX support it is recommended to load XCR0 after XFD, so that
KVM does not see XFD=0, XCR=1 for a save state that will eventually
be disabled (which would lead to premature allocation of the space
required for that save state).

It is also required to load XSAVE data after XCR0 and XFD, so that
KVM can trigger allocation of the extra space required to store AMX
state.

Adjust vcpu_load_state to obey these new requirements.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/tools/testing/selftests/kvm/lib/x86_64/processor.c b/tools/testing/selftests/kvm/lib/x86_64/processor.c
index 82c39db91369..d805f63f7203 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/processor.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/processor.c
@@ -1157,16 +1157,6 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
  	struct vcpu *vcpu = vcpu_find(vm, vcpuid);
  	int r;
  
-	r = ioctl(vcpu->fd, KVM_SET_XSAVE, &state->xsave);
-        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
-                r);
-
-	if (kvm_check_cap(KVM_CAP_XCRS)) {
-		r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
-		TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i",
-			    r);
-	}
-
  	r = ioctl(vcpu->fd, KVM_SET_SREGS, &state->sregs);
          TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_SREGS, r: %i",
                  r);
@@ -1175,6 +1165,16 @@ void vcpu_load_state(struct kvm_vm *vm, uint32_t vcpuid, struct kvm_x86_state *s
          TEST_ASSERT(r == state->msrs.nmsrs, "Unexpected result from KVM_SET_MSRS, r: %i (failed at %x)",
                  r, r == state->msrs.nmsrs ? -1 : state->msrs.entries[r].index);
  
+	if (kvm_check_cap(KVM_CAP_XCRS)) {
+		r = ioctl(vcpu->fd, KVM_SET_XCRS, &state->xcrs);
+		TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XCRS, r: %i",
+			    r);
+	}
+
+	r = ioctl(vcpu->fd, KVM_SET_XSAVE, &state->xsave);
+        TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_XSAVE, r: %i",
+                r);
+
  	r = ioctl(vcpu->fd, KVM_SET_VCPU_EVENTS, &state->events);
          TEST_ASSERT(r == 0, "Unexpected result from KVM_SET_VCPU_EVENTS, r: %i",
                  r);
