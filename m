Return-Path: <kvm+bounces-21961-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B048937C9F
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 20:42:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D41481F222FF
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2024 18:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9477147C89;
	Fri, 19 Jul 2024 18:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jxGK+R1e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E20F12D76F;
	Fri, 19 Jul 2024 18:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721414515; cv=none; b=CHH+fr9rFG9qdOGH2eBsJ7PZ31k/UpGa3DuP1q+49P4aRfjAFV4kkIpopxBxf/IYvtoiwEg+DiLG14iYKBpGcWTZfm3REdXsWaI2Uacaq3OjXau7TykNQOtBLG7Ej5AQFOPkAAtnqdqT3b9hnhY6ZK2SnSAls0RgkbPU44oPhhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721414515; c=relaxed/simple;
	bh=e3cnJ9xrMQgxBOt27OhwCdqyj2Rl3b1CwhJlmsuVUfM=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=Mjt6tiIVXS1ZTYWRb7BD/EfMIibFJoTLv0WFMcsWfENxbAHTgKkdgKuyJLCvjVgSSGJvYBudpupihOoEDyXK5zDySaxb3Ma5U2udM3vwLfOrGiRqLN2MOqKRjnx++mzRrJC4hLAn39KwiBEzTM8Zk0SgC3LIBhQ4iXm6YV3wOhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jxGK+R1e; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-368557c9e93so793054f8f.2;
        Fri, 19 Jul 2024 11:41:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721414511; x=1722019311; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u0iaRWSdXWUNnZ+fVmGuUdLWev/rZhsvGTanSK8paG8=;
        b=jxGK+R1ev9jH5lCtelFpzJi64e1/PEP6Kit9Ruw7EvXGqwns9MR0fRjArIS4u+Ut2o
         fWgaljnPqiID1xKPh2npORCz1PhM9EKFeU/iLUZiq7xwfQwZWpGn0OMBCZegRLP+PdiF
         /llmXMruLmTjgHd+DbVLDElWJclR8Upe9vfcVY0YgugGLNZSLxna3pbJjnrrqg0AcFeM
         hWvGeTBUMJiqxaVdSHCLFhARb8h/N54KseQLQIe811STRS5uwsW0/19NSnVGq4mjTDwQ
         xnpAKtAnGbmdJ1z1oH2kmInr0cl1EyHhYrrI8TbbK1arO17sbiqdBMRfuciMDskUsd+T
         t2Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721414511; x=1722019311;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u0iaRWSdXWUNnZ+fVmGuUdLWev/rZhsvGTanSK8paG8=;
        b=TkEZZ9iaN61rEvK3JBt0TFAcFt+l3ftuNEVqbtFDTpHcVSZug+2WW0Gdgkp74gq/qD
         /DL1e0zdsnYYq8r2Z1EPf2X/W/k/uydzoHZt86Yl4v6cKsh+ZapeqvmuAfYQhR6lujXr
         hhO8bnfl4VPiFlHPuk3HsfdXG1VwU7eQFRP5CIKCkcU9/ZLEJnpqQ7XyTO04CHNZtcFc
         bPKGuI2mmJV+F+6qRe6oMdY+bx6QpkSm3Zr3vmMncY2hMJ/PzexuLr1tRtr4RRUMRHxG
         FY6jsJsHN3qiCBgRkuhsixAP01EuW4IuigY5FtvH4F5P6Ef+Y5ffyeZPkgXKyPPzUjvT
         DLPg==
X-Forwarded-Encrypted: i=1; AJvYcCWe0hJRlYdFjIfXjYcf22JXmtCMNJS+I3Jc3xTSmmUS0xD3aJrPkQJuWf5YJM+Gek7V5GmMvwTKAeKBpYdX+HIcDLttvImtHwjEa99e
X-Gm-Message-State: AOJu0YxGEDWzRLnSg7pPs/DoiCgbvb/l5NS0rFmo6DFyal97t8pf7Ufe
	64dxigAz71MA23vkkNsZ/RZF2D4F+9VgSgbV1YMZMYhzbvXtU2ZQaqdq6ybw
X-Google-Smtp-Source: AGHT+IF4giFfBkDbzlGg+1z9xTX2s1adg7P6ePcRpCqpJd/FFpIIoa4Zxa4QuUmdHFKzR7ODEm3FXQ==
X-Received: by 2002:adf:9b9e:0:b0:366:e9f9:99c1 with SMTP id ffacd0b85a97d-3683171dc1bmr4914287f8f.53.1721414511399;
        Fri, 19 Jul 2024 11:41:51 -0700 (PDT)
Received: from [192.168.178.20] (dh207-42-168.xnet.hr. [88.207.42.168])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3687868477fsm2300867f8f.12.2024.07.19.11.41.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Jul 2024 11:41:51 -0700 (PDT)
Message-ID: <b44227c5-5af6-4243-8ed9-2b8cdc0e5325@gmail.com>
Date: Fri, 19 Jul 2024 20:41:47 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
From: Mirsad Todorovac <mtodorovac69@gmail.com>
Subject: =?UTF-8?Q?=5BBUG=5D_arch/x86/kvm/vmx/vmx=5Fonhyperv=2Eh=3A109=3A36?=
 =?UTF-8?B?OiBlcnJvcjogZGVyZWZlcmVuY2Ugb2YgTlVMTCDigJgw4oCZ?=
To: kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi, all!

Here is another potential NULL pointer dereference in kvm subsystem of linux stable vanilla 6.10,
as GCC 12.3.0 complains.

(Please don't throw stuff at me, I think this is the last one for today :-)

arch/x86/include/asm/mshyperv.h
-------------------------------
  242 static inline struct hv_vp_assist_page *hv_get_vp_assist_page(unsigned int cpu)
  243 {
  244         if (!hv_vp_assist_page)
  245                 return NULL;
  246 
  247         return hv_vp_assist_page[cpu];
  248 }

arch/x86/kvm/vmx/vmx_onhyperv.h
-------------------------------
  102 static inline void evmcs_load(u64 phys_addr)
  103 {
  104         struct hv_vp_assist_page *vp_ap =
  105                 hv_get_vp_assist_page(smp_processor_id());
  106 
  107         if (current_evmcs->hv_enlightenments_control.nested_flush_hypercall)
  108                 vp_ap->nested_control.features.directhypercall = 1;
  109         vp_ap->current_nested_vmcs = phys_addr;
  110         vp_ap->enlighten_vmentry = 1;
  111 }

Now, this one is simple: hv_vp_assist_page(cpu) can return NULL, and in line 104 it is assigned
to wp_ap, which is dereferenced in lines 108, 109, and 110, which is not checked against returning
NULL by hv_vp_assist_page().

Commits 50a82b0eb88c1 and a46d15cc1ae5a are related to the issue.

Hope this helps.

Best regards,
Mirsad Todorovac

