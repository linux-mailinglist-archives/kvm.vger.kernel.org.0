Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23CC8374BB
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2019 15:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfFFNCF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jun 2019 09:02:05 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44254 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfFFNCF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jun 2019 09:02:05 -0400
Received: by mail-wr1-f67.google.com with SMTP id b17so1237979wrq.11
        for <kvm@vger.kernel.org>; Thu, 06 Jun 2019 06:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eLboJq5KIwRRnKVXuH7SOZO0ap3IiacPT4U+ga54RF4=;
        b=i3dpdts2D9CbNc1Wm0tAjTs3Q+2ejlcYX1WPVG3ltLnaEghNz+HUykSZgUQdQyAE1L
         UEXel8kKRGPyr5klDdVOiWhLLKW+6KpL2MplLMOZPfdR+qWV8X0Ie4EDpk2H+aoW2bsp
         /SDOv3l8wHg6OCN+gsMxBWhRuFsj+RzNLFuPuPpwHM5XKtQZDtyljs2iyaR/8LLwz7RW
         OVdSs5nRhI/JmyU4ldWCdSxfl/JkHyNZcjI75Uu5mj3DlINAzxkO7bqtsh+6220Wlqo9
         dz4OKWtKBoMKVc7TgAQacsGwoYR0naxKr2WPipeLfr2Qe6ZLdnro5IpiGdMfVpLTmMyy
         Ex8g==
X-Gm-Message-State: APjAAAVFDoOILSJAsh2iFWBVZuMsD50SoetjwsB4auyad9PLyY4dRBNC
        E6voIjiopUpYgtRLqSYnqQjtnA==
X-Google-Smtp-Source: APXvYqwXjSCq16u4Y2vx4YOGkuFrOj/YI3RazZpWWtWtoSgiTPcbNGs1RGlzJD3ta+mDJo/ApBawlw==
X-Received: by 2002:adf:ce8f:: with SMTP id r15mr17891956wrn.122.1559826124171;
        Thu, 06 Jun 2019 06:02:04 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id k185sm1343804wma.3.2019.06.06.06.02.03
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 06:02:03 -0700 (PDT)
Subject: Re: [PATCH 2/5] KVM: VMX: Read cached VM-Exit reason to detect
 external interrupt
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20190420055059.16816-1-sean.j.christopherson@intel.com>
 <20190420055059.16816-3-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <77943c3f-405e-9cab-7535-cbe9cb1fc89b@redhat.com>
Date:   Thu, 6 Jun 2019 15:02:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190420055059.16816-3-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/04/19 07:50, Sean Christopherson wrote:
> Generic x86 code blindly invokes the dedicated external interrupt
> handler blindly, i.e. vmx_handle_external_intr() is called on all
> VM-Exits regardless of the actual exit type.

That's *really* blindly. :)  Rephrased to

    Generic x86 code invokes the kvm_x86_ops external interrupt handler
    on all VM-Exits regardless of the actual exit type.

-		unsigned long entry;
-		gate_desc *desc;
+	unsigned long entry;

I'd rather keep the desc variable to simplify review (with "diff -b")
and because the code is more readable that way.  Unless you have a
strong reason not to do so, I can do the change when applying.

Paolo
