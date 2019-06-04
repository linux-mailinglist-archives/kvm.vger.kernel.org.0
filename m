Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B6934E49
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2019 19:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727957AbfFDREV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jun 2019 13:04:21 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36779 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFDREV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jun 2019 13:04:21 -0400
Received: by mail-wm1-f67.google.com with SMTP id v22so851185wml.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2019 10:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kPXGLb38N6H/+wwst2iGdWy1wyR9qcrafJbTXY1BG2A=;
        b=P7WMFTN6ERnTLdKkP1e60AtnamNxGVZTM6h6pAUEp5C+B/fdshjUumzUHbgrUPPbm5
         Ri0U1yBHCGW0+PzbO1yx1kUFDeIZhKw/7Gm0tfVmgoKFlySrxiFN555A4jEnFDDder7D
         ZwPbQ8WBRxgB68pPZQ74cVcEoNwYfP+O7KS5vtfD8rpXs+OmM9QEDsYK7954qwhjgDJL
         c43GribFCFNR/ppE/sIdqn/hH3pQ6S9RVApAec79pgFNlvGcdLpRP2MaUXGgYBaJCqw0
         C/p1kHyLoMGMccbxxG/2e//72Ve5UPvRtH6J1lzs6Y48bR+fcQjXUEuapZwzg+lzuEIh
         BSkg==
X-Gm-Message-State: APjAAAXzGzyLmpOcEaMsa1lcbt+l9TZL+KNS9qvViRa1LO9/BMa8PjB5
        Vmq3W0QQ+a3SpCiXxVfC5hitcg==
X-Google-Smtp-Source: APXvYqw1+yx+Dh8EWIgfzGNDblZ+PqgZlOBu5wlbywRftoadTC5olWeGts7o/BJ4CsuNUElkIITQdg==
X-Received: by 2002:a1c:cc02:: with SMTP id h2mr18750687wmb.13.1559667858914;
        Tue, 04 Jun 2019 10:04:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id k10sm8836943wmj.37.2019.06.04.10.04.17
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 04 Jun 2019 10:04:18 -0700 (PDT)
Subject: Re: [PATCH 0/2] Fix reserved bits calculation errors caused by MKTME
To:     Kai Huang <kai.huang@linux.intel.com>, kvm@vger.kernel.org,
        rkrcmar@redhat.com
Cc:     sean.j.christopherson@intel.com, junaids@google.com,
        thomas.lendacky@amd.com, brijesh.singh@amd.com,
        guangrong.xiao@gmail.com, tglx@linutronix.de, bp@alien8.de,
        hpa@zytor.com, kai.huang@intel.com
References: <cover.1556877940.git.kai.huang@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <b4858fd6-4343-2d9c-8609-c843fa0dd207@redhat.com>
Date:   Tue, 4 Jun 2019 19:04:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <cover.1556877940.git.kai.huang@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/05/19 12:08, Kai Huang wrote:
> This series fix reserved bits related calculation errors caused by MKTME. MKTME
> repurposes high bits of physical address bits as 'keyID' thus they are not
> reserved bits, and to honor such HW behavior those reduced bits are taken away
> from boot_cpu_data.x86_phys_bits when MKTME is detected (exactly how many bits
> are taken away is configured by BIOS). Currently KVM asssumes bits from
> boot_cpu_data.x86_phys_bits to 51 are reserved bits, which is not true anymore
> with MKTME, and needs fix.
> 
> This series was splitted from the old patch I sent out around 2 weeks ago:
> 
> kvm: x86: Fix several SPTE mask calculation errors caused by MKTME
> 
> Changes to old patch:
> 
>   - splitted one patch into two patches. First patch is to move
>     kvm_set_mmio_spte_mask() as prerequisite. It doesn't impact functionality.
>     Patch 2 does the real fix.
> 
>   - renamed shadow_first_rsvd_bits to shadow_phys_bits suggested by Sean.
> 
>   - refined comments and commit msg to be more concise.
> 
> Btw sorry that I will be out next week and won't be able to reply email.
> 
> Kai Huang (2):
>   kvm: x86: Move kvm_set_mmio_spte_mask() from x86.c to mmu.c
>   kvm: x86: Fix reserved bits related calculation errors caused by MKTME
> 
>  arch/x86/kvm/mmu.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++----
>  arch/x86/kvm/x86.c | 31 ---------------------------
>  2 files changed, 57 insertions(+), 35 deletions(-)
> 

Queued, thanks.

Paolo
