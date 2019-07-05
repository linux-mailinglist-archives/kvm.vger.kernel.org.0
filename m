Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1351860606
	for <lists+kvm@lfdr.de>; Fri,  5 Jul 2019 14:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfGEMhr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Jul 2019 08:37:47 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:50575 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728848AbfGEMhr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Jul 2019 08:37:47 -0400
Received: by mail-wm1-f68.google.com with SMTP id n9so8742146wmi.0
        for <kvm@vger.kernel.org>; Fri, 05 Jul 2019 05:37:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XMEfTsFYfJMndGqPjo03pluC2RJFLgJPB47NoVMy6DM=;
        b=akrIhFfE5IFqZagHkiZIrlz9MJfdIyGS81EV4duJ/HeDXr1WiPNsszLFHfgoEbobaD
         Bb/LX1r80KTcu61VtEReOH3Y6dRHUVa2nnf+msJjHSaso0pAfODPOFv/OUYlKmyfX/Mw
         fIFjle7Yhf843/i5PG22KscyCcQ66DG0lj07DIPXWf8ugLJX4J9NFAzVIbEzova2fszY
         lv9CXdvLq/WkP2KCdZKjg2iSR4wutHD3cklqC2vUNEWmxNbxhkYJMB+/byFR9J+zmmk0
         xe7Wpys9xevkgkizuURodPJgwjDAoXv4QgMzpcG5dN+6PeodmDxSw1LuJHYWtD76uWM9
         JHug==
X-Gm-Message-State: APjAAAUN91lxfbF/BMHOY+fxdSB1HTo9vs6CIrfnNP0utaHtHWhpBmZg
        XGxGCPmjI8HDa0Evmigaw4blsQ==
X-Google-Smtp-Source: APXvYqzTxkUxVcI3WUEckO89s+RKrelZQJ/tSe+7p+Csnzma0UWsucyj9RicaSopIlzmC0mhGsBBkA==
X-Received: by 2002:a7b:cae2:: with SMTP id t2mr3382337wml.157.1562330265650;
        Fri, 05 Jul 2019 05:37:45 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:e943:5a4e:e068:244a? ([2001:b07:6468:f312:e943:5a4e:e068:244a])
        by smtp.gmail.com with ESMTPSA id l2sm1859000wmj.4.2019.07.05.05.37.44
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 05:37:45 -0700 (PDT)
Subject: Re: [PATCH v5 2/4] KVM: LAPIC: Inject timer interrupt via posted
 interrupt
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <1561110002-4438-1-git-send-email-wanpengli@tencent.com>
 <1561110002-4438-3-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <587f329a-4920-fcbf-b2b1-9265a1d6d364@redhat.com>
Date:   Fri, 5 Jul 2019 14:37:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1561110002-4438-3-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/06/19 11:40, Wanpeng Li wrote:
> +bool __read_mostly pi_inject_timer = 0;
> +module_param(pi_inject_timer, bool, S_IRUGO | S_IWUSR);
> +
>  #define KVM_NR_SHARED_MSRS 16
>  
>  struct kvm_shared_msrs_global {
> @@ -7032,6 +7036,7 @@ int kvm_arch_init(void *opaque)
>  		host_xcr0 = xgetbv(XCR_XFEATURE_ENABLED_MASK);
>  
>  	kvm_lapic_init();
> +	pi_inject_timer = housekeeping_enabled(HK_FLAG_TIMER);

This overwrites whatever the user specified, so perhaps:

u8 __read_mostly pi_inject_timer = -1;
module_param(pi_inject_timer, bool, S_IRUGO | S_IWUSR);

...
	if (pi_inject_timer == -1)
		pi_inject_timer = housekeeping_enabled(HK_FLAG_TIMER);

Also, do you want to disable the preemption timer if pi_inject_timer and
enable_apicv are both true?

Paolo
