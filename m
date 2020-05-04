Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E281C3B2E
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 15:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgEDN0E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 09:26:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52834 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726922AbgEDN0D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 May 2020 09:26:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588598762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i4pzL4umPonPhC4u7wWwTYbUYUN1KN4vROxppSrw3+E=;
        b=DXuHeBD55BYoq0T3ETff1t7WXd6w9XGllrlXndeI5VFK2y3icxH8YnzjI6ww6FAbCQrSIh
        3ngQbmZQ2A77wvMQ+8ECc6Y413jHzJVxrnNWab93pSegN226BaLPkU7JLhWrJxNyphhbHU
        DE2n4PlwVxj3/aDVGWH9cpSCPNXfMAI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-320-eNzbowHlNJOUnydVvS_nRQ-1; Mon, 04 May 2020 09:26:00 -0400
X-MC-Unique: eNzbowHlNJOUnydVvS_nRQ-1
Received: by mail-wm1-f70.google.com with SMTP id h184so4865078wmf.5
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 06:26:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=i4pzL4umPonPhC4u7wWwTYbUYUN1KN4vROxppSrw3+E=;
        b=C3uxeeD3mlriittaIbx/bRdFwc6v5FGIrRnqy/jt8fu3sHx0Du7IZQWOn/UqztQOOP
         4u+FY6BLxgnp1p6lAlq++8xu/vX/d2Ny+tKwM7aAFtY8fZdN9xbNT7Z6bW/IYeQlFFsa
         iyClZgTscD9Gh/rLC7HU7FT6WuXO+6B2u5QJvPfgB4GwZFb6ON3ODc1pqfz9XMsWUF0u
         ZJ/ojmlHWq/h59aCn/Vjl7qdldAYoETBwbrW04DLYm5aMRic6IwOaXrqaEioulqJwooZ
         zqFF5E9lowvgG87MWTVUDkz2tOXWykSzYYxDwssgva2A1ZSFXJsrt5GCxzzPiqfTY9I2
         xIKw==
X-Gm-Message-State: AGi0Pua1AuYtDA0xU4Rs9dk/dEJ1r2OTrq+kUGPXJhC5FWYhQ4bYa04O
        ZiXISQZlvCYb8fG7VCPkIF8npM5oHV+v4rS2bfP2YHw3r/Wq3HLjhbrOYpdY57eyxayKUzT82pl
        /VRfQreJdUylh
X-Received: by 2002:adf:b246:: with SMTP id y6mr19634358wra.205.1588598759722;
        Mon, 04 May 2020 06:25:59 -0700 (PDT)
X-Google-Smtp-Source: APiQypJDk5TIWUOHalS5JGIMZEe9cIgedoGf1dImAxSG/0eN+CuQo328XZeIltJiaklS1Cr1myn0gg==
X-Received: by 2002:adf:b246:: with SMTP id y6mr19634338wra.205.1588598759507;
        Mon, 04 May 2020 06:25:59 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id l16sm18526002wrp.91.2020.05.04.06.25.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 06:25:59 -0700 (PDT)
Subject: Re: [PATCH 00/10] KVM: x86: Misc anti-retpoline optimizations
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200502043234.12481-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <76c2fc30-58e3-4d90-4b66-85b6fb4741b5@redhat.com>
Date:   Mon, 4 May 2020 15:25:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200502043234.12481-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/05/20 06:32, Sean Christopherson wrote:
> A smattering of optimizations geared toward avoiding retpolines, though
> IMO most of the patches are worthwhile changes irrespective of retpolines.
> I can split this up into separate patches if desired, outside of the
> obvious combos there are no dependencies.

Most of them are good stuff anyway, I agree.

Since I like to believe that static calls _are_ close, I queued these:

      KVM: x86: Save L1 TSC offset in 'struct kvm_vcpu_arch'
      KVM: nVMX: Unconditionally validate CR3 during nested transitions
      KVM: VMX: Add proper cache tracking for CR4
      KVM: VMX: Add proper cache tracking for CR0
      KVM: VMX: Move nested EPT out of kvm_x86_ops.get_tdp_level() hook
      KVM: x86/mmu: Capture TDP level when updating CPUID

and I don't disagree with the DR6 one though it can be even improved a
bit so I'll send a patch myself.

Paolo

