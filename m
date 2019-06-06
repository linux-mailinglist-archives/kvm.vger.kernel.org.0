Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3AA537540
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 15:31:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfFFNb6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 09:31:58 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46359 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727519AbfFFNb6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 09:31:58 -0400
Received: by mail-wr1-f66.google.com with SMTP id n4so2410517wrw.13
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 06:31:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4BDfdiakx4aSQdRzQ5npeD/TnGGGrN7v3yEs6PxEyyU=;
        b=f7kUJSpgYSc8R1wLDDE8J7DnLgMx3nQYjXujhWhAZoL7JCSlBQ37HdrRazXkHouBDv
         E9wVA01C193/d5NQM9DsRZCcwxpzuHzy1010ltph5/ECs1mWRiluW6jpwQgaHu/SGLGK
         Vzn3hGU3IQiwlI0gN+TiGgZ2o4Jy04IwvLnO8SUeYdsx3jfJk0bny9R8kJwnnHxKJPhQ
         OBgt7XqEbHZ9LL2LZ+I2q0Gf+urdTlSUQFX6AhRPWyW698+vQIwGCUmwvqv7lqwk4WVh
         V4Dgo6lBo7XYJSc6z2LPmv9tkaW6Lz3F3KGAXSepwe4t6qWbG1uq7E6tP6EECqoz7pIu
         nIYQ==
X-Gm-Message-State: APjAAAXomfkd9sPM5caGwCmsghCmVkiMgmrbll5godPxnS7pv8nRL8ZH
        SpIKAK3Nz8UvCd6KR+2LaHkKOQ==
X-Google-Smtp-Source: APXvYqxPTY5sAxqZ93d+/oBnuiOC2zEXxCtc+4jn2WMwKZvBcD5NLHJEsAY7zkHLV93di74HhiA4Yw==
X-Received: by 2002:a5d:6b03:: with SMTP id v3mr10118041wrw.309.1559827916956;
        Thu, 06 Jun 2019 06:31:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id r5sm720714wrg.10.2019.06.06.06.31.56
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 06:31:56 -0700 (PDT)
Subject: Re: [PATCH 2/7] KVM: nVMX: Intercept VMWRITEs to
 GUEST_{CS,SS}_AR_BYTES
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Liran Alon <liran.alon@oracle.com>
References: <20190507153629.3681-1-sean.j.christopherson@intel.com>
 <20190507153629.3681-3-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <def2b7f5-6bbf-600a-9edc-53a15f98b478@redhat.com>
Date:   Thu, 6 Jun 2019 15:31:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190507153629.3681-3-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/05/19 17:36, Sean Christopherson wrote:
> Since the AR_BYTES emulation is done only for intercepted VMWRITE, if a
> future patch (re)exposed AR_BYTES for both VMWRITE and VMREAD, then KVM
> would end up with incosistent behavior on pre-Haswell hardware, e.g. KVM
> would drop the reserved bits on intercepted VMWRITE, but direct VMWRITE
> to the shadow VMCS would not drop the bits.

Whoever gets that WARN will have probably a hard time finding again all of this, so:

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index cd51ef68434e..8c5614957e04 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -93,7 +93,7 @@ static void init_vmcs_shadow_fields(void)
 
 		WARN_ONCE(field >= GUEST_ES_AR_BYTES &&
 			  field <= GUEST_TR_AR_BYTES,
-			  "Update vmcs12_write_any() to expose AR_BYTES RW");
+			  "Update vmcs12_write_any() to drop reserved bits from AR_BYTES");
 
 		/*
 		 * PML and the preemption timer can be emulated, but the


Paolo
