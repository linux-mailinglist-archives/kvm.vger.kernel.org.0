Return-Path: <kvm+bounces-27673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E46C989F0E
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 12:01:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7FB97B26614
	for <lists+kvm@lfdr.de>; Mon, 30 Sep 2024 10:01:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A3918E039;
	Mon, 30 Sep 2024 09:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="END76dyT"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F6018C011
	for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 09:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727690384; cv=none; b=aOfWm5Wzvj2KanzuHLrtqJvNebLbxkDCUAqp4SMv4ov+GbbZfdfaH0lH3/AdvojCLW0ILp1m/DgMkcXAupZBgodsWaDu4+30QBqv0I4rmSSZY7DoTmtK9JU4GHJNePR0pOSQaqIfWmHtzpoHQ4Jpuy+1ROy68ULkOlrms/iQ3+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727690384; c=relaxed/simple;
	bh=WAJ6Wi+YQ0Os0c/LUUNFeApVMyhsSUYzpTbbqzAegbY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=Omm78LioSbxQiIS74l1EXbuxKMLQ5qae3vo6FVYvdMfwDZaOojozm9XjsgzTLTX362z44ybZT/SJfl1+4TCiba6oX99VhXlOYX69LX2qk3QPHuMHY0PpMMPEMqbJ/fYic+E2vfyfKjx6n+2EB5x0h9Rn3ml03YZSq1kFNXeUFag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=END76dyT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727690381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7AHK5SExUsiemEnpNI5Wh7Ji94huWLGDyLlvxGfVapQ=;
	b=END76dyTcmQBI6ZbF1x/kawcjuIz+cuq4E6F16nsWAvk5E5Es3QxPUhyhuyb0P+FPRAM4A
	gt/JjpNNmJlL7wNysFNnK64QezMjDxnfwZgqlghFAUhF9w38d+FutYlrIXR96MLUTgGXMq
	96cjTl9IFnkSS98gkpFJHpKPvFOnRYk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-zjmsY4ylOkWz70UWzF9s9g-1; Mon, 30 Sep 2024 05:59:39 -0400
X-MC-Unique: zjmsY4ylOkWz70UWzF9s9g-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-42cb050acc3so22048385e9.1
        for <kvm@vger.kernel.org>; Mon, 30 Sep 2024 02:59:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727690378; x=1728295178;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7AHK5SExUsiemEnpNI5Wh7Ji94huWLGDyLlvxGfVapQ=;
        b=KoJSbSlo7jeFAZPH42zoDi6BSP02TgTcx57z2tk5bLUV43EU6yChf4Pzlf/RkCeKfP
         iyA5go/7qdMtOFYIt/RNLbpjiwe4jZILpLISUtlfV/NFe9m+/EQRpHn3GoidO+sBVTd4
         yrtBXeRhbfdjkskUsPAfXTZ1PE8cXEBZeXFfEWWAGkXT/rdk90ntYv7xfRYvjk9sZp1R
         Z0bvLrA4HjaYT+BTMprruBB9WiMGNsV/Pl9huKN+cdm7GxRlPO2MCFLQdT4jlHgD+vV6
         +ezociGGW+gY3XZXgTLMnA9DRabWKUG1ZXmerGySau5VzqC6oIFtsW3lMDrQw2FSarjy
         CSlQ==
X-Forwarded-Encrypted: i=1; AJvYcCVOdER8e7wT+hROStbEda4cWIUIG8rPrJBIBpxbSlDu6UyHRy2ZxJjB8o8ZI4UcWfN4f4g=@vger.kernel.org
X-Gm-Message-State: AOJu0YzARHJn+3EApoLe9vE3LBXo1bOtKuRgtb96ZZ3AHuq2VaKyfbNk
	oyFJQaeAbjTwf+AK4TzNi/OaKYwK/xMTnN66uZMHCXfFZHkMsPeIGtqdp7DePpD0ZcdB+vCRSLq
	Vygz9N5rSJxVIJ0gEuzp1Flc3u2piTMOEYzou4bXxVylXg+gefg==
X-Received: by 2002:a05:600c:1ca9:b0:42c:b67b:816b with SMTP id 5b1f17b1804b1-42f521c42famr93341105e9.1.1727690377993;
        Mon, 30 Sep 2024 02:59:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFXgmKZegqfT1L8VbvhCoDAAY5hNnrSVIJfuFR120fwW5rC9UXmwaARjoNjUKZHAeFh+J3OOw==
X-Received: by 2002:a05:600c:1ca9:b0:42c:b67b:816b with SMTP id 5b1f17b1804b1-42f521c42famr93340885e9.1.1727690377509;
        Mon, 30 Sep 2024 02:59:37 -0700 (PDT)
Received: from [192.168.10.81] ([151.95.43.71])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-42e969ddb1fsm145611885e9.3.2024.09.30.02.59.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2024 02:59:36 -0700 (PDT)
Message-ID: <a402dec0-c8f5-4f10-be5d-8d7263789ba1@redhat.com>
Date: Mon, 30 Sep 2024 11:59:35 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [GIT PULL] KVM/x86 changes for Linux 6.12
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sean Christopherson <seanjc@google.com>, Kai Huang <kai.huang@intel.com>,
 Chao Gao <chao.gao@intel.com>, Farrah Chen <farrah.chen@intel.com>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20240928153302.92406-1-pbonzini@redhat.com>
 <CAHk-=wiQ2m+zkBUhb1m=m6S-H1syAgWmCHzit9=5y7XsriKFvw@mail.gmail.com>
Content-Language: en-US
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <CAHk-=wiQ2m+zkBUhb1m=m6S-H1syAgWmCHzit9=5y7XsriKFvw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On Sun, Sep 29, 2024 at 7:36 PM Linus Torvalds <torvalds@linux-foundation.org> wrote:
> The culprit is commit 590b09b1d88e ("KVM: x86: Register "emergency
> disable" callbacks when virt is enabled"), and the reason seems to be
> this:
>
>   #if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
>   void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback);
>   ...
>
> ie if you have a config with KVM enabled, but neither KVM_INTEL nor
> KVM_AMD set, you don't get that callback thing.
>
> The fix may be something like the attached.

Yeah, there was an attempt in commit 6d55a94222db ("x86/reboot:
Unconditionally define cpu_emergency_virt_cb typedef") but that only
covers the headers and the !CONFIG_KVM case; not the !CONFIG_KVM_INTEL
&& !CONFIG_KVM_AMD one that you stumbled upon.

Your fix is not wrong, but there's no point in compiling kvm.ko if
nobody is using it.

This is what I'll test more and submit:

------------------ 8< ------------------
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH] KVM: x86: leave kvm.ko out of the build if no vendor module is requested
     
kvm.ko is nothing but library code shared by kvm-intel.ko and kvm-amd.ko.
It provides no functionality on its own and it is unnecessary unless one
of the vendor-specific module is compiled.  In particular, /dev/kvm is
not created until one of kvm-intel.ko or kvm-amd.ko is loaded.
     
Use CONFIG_KVM to decide if it is built-in or a module, but use the
vendor-specific modules for the actual decision on whether to build it.
     
This also fixes a build failure when CONFIG_KVM_INTEL and CONFIG_KVM_AMD
are both disabled.  The cpu_emergency_register_virt_callback() function
is called from kvm.ko, but it is only defined if at least one of
CONFIG_KVM_INTEL and CONFIG_KVM_AMD is provided.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 4287a8071a3a..aee054a91031 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -17,8 +17,8 @@ menuconfig VIRTUALIZATION
  
  if VIRTUALIZATION
  
-config KVM
-	tristate "Kernel-based Virtual Machine (KVM) support"
+config KVM_X86_COMMON
+	def_tristate KVM if KVM_INTEL || KVM_AMD
  	depends on HIGH_RES_TIMERS
  	depends on X86_LOCAL_APIC
  	select KVM_COMMON
@@ -46,6 +47,9 @@ config KVM
  	select KVM_GENERIC_HARDWARE_ENABLING
  	select KVM_GENERIC_PRE_FAULT_MEMORY
  	select KVM_WERROR if WERROR
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support"
  	help
  	  Support hosting fully virtualized guest machines using hardware
  	  virtualization extensions.  You will need a fairly recent
diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 5494669a055a..4304c89d6b64 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -32,7 +32,7 @@ kvm-intel-y		+= vmx/vmx_onhyperv.o vmx/hyperv_evmcs.o
  kvm-amd-y		+= svm/svm_onhyperv.o
  endif
  
-obj-$(CONFIG_KVM)	+= kvm.o
+obj-$(CONFIG_KVM_X86_COMMON) += kvm.o
  obj-$(CONFIG_KVM_INTEL)	+= kvm-intel.o
  obj-$(CONFIG_KVM_AMD)	+= kvm-amd.o
  
------------------ 8< ------------------

On top of this, the CONFIG_KVM #ifdefs could be changed to either
CONFIG_KVM_X86_COMMON or (most of them) to CONFIG_KVM_INTEL; I started
cleaning up the Kconfigs a few months ago and it's time to finish it
off for 6.13.

Paolo


