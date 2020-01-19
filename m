Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAD0E141D1D
	for <lists+kvm@lfdr.de>; Sun, 19 Jan 2020 10:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbgASJNH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 19 Jan 2020 04:13:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33179 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726538AbgASJNH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 19 Jan 2020 04:13:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579425186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WyiLQXhvJwA98XL6pwIyMDHQL3u/aXEaDfxPnFPM7YA=;
        b=EhdoEBKSCnzDo0iLKMg9dst/k5iZdXhjPNRopN3HI4WKqNZVTgMCHi/hEhCWzYKrR1B2J0
        xSBdNc4pIhaAE7bcUZqmq/tAm8DNf+jsMJn4eNoluBKycZiUtYMHRLyfReJgWvnY3hRKJj
        0ANh1PS4H7ko9ENbsrliZ/0E8lYjjnw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-wGA4bQv1O_WjfMfX67Q6-A-1; Sun, 19 Jan 2020 04:13:04 -0500
X-MC-Unique: wGA4bQv1O_WjfMfX67Q6-A-1
Received: by mail-wr1-f69.google.com with SMTP id z14so12726718wrs.4
        for <kvm@vger.kernel.org>; Sun, 19 Jan 2020 01:13:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WyiLQXhvJwA98XL6pwIyMDHQL3u/aXEaDfxPnFPM7YA=;
        b=bA6AdE7QRneLspGJ74kVw2lykm1J36GtHtTn/NwEWS+NL8rMiHXHJLHXtTcEOw7FQd
         /z6GrdP2Wti1L1nhLcC2jag0kClfFpHJnjx/sqQadiWCNAAiSd7WQnf4VZBLh4qMc8ui
         6zP7Qf42YD14/mCw/C9k52s+siEDEfaqA8b56SCGHke9PrGlE424R6Q+i5IY5//LGHJF
         8wnvORBeMS+pHDFqRgiW5xILGCCCRFfyouYgRhl9uNKu5Qy4Fikbqj2TP0X5AvbtNc/s
         o+mHjDPnM7i/j3tMvkYl9kC/9WG0DbDeKQm3xWQDLGJL84CW/cMhx23jWWt9tmG0AbIp
         vUdg==
X-Gm-Message-State: APjAAAXopYjj1CrOVJEwK+KBiLXw5cF5iWtzMZ9xyQqFClPF5sBGglrL
        jSfWqLCAlYCs3V4JHtxYVDWv6WYlBch6CoeSj3Ix15gwIwkoYbypiXmycln1ws23LpXIzkqsRfk
        354b3CMoOQPkP
X-Received: by 2002:adf:e984:: with SMTP id h4mr12867742wrm.275.1579425183734;
        Sun, 19 Jan 2020 01:13:03 -0800 (PST)
X-Google-Smtp-Source: APXvYqxOWz1xwLvoAQiTHjZj1wO0CnsVKJKncX2L8gVKtlK3QemhtNmiTpUHEmZZx2FEjI3om0SdPQ==
X-Received: by 2002:adf:e984:: with SMTP id h4mr12867726wrm.275.1579425183529;
        Sun, 19 Jan 2020 01:13:03 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e0d6:d2cd:810b:30a9? ([2001:b07:6468:f312:e0d6:d2cd:810b:30a9])
        by smtp.gmail.com with ESMTPSA id b18sm42954791wru.50.2020.01.19.01.13.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 01:13:03 -0800 (PST)
Subject: Re: [PATCH 0/2 v3] KVM: nVMX: Check GUEST_DR7 on vmentry of nested
 guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
Cc:     jmattson@google.com
References: <20200116005433.5242-1-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <771b683c-7677-7408-73fc-20b8c0d79153@redhat.com>
Date:   Sun, 19 Jan 2020 10:13:05 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200116005433.5242-1-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/01/20 01:54, Krish Sadhukhan wrote:
> v2 -> v3:
> 	The following changes have been made to patch# 1:
> 	  i) Commit message body mentions the reason for doing this check in
> 	     software.
> 	  i) The CONFIG_X86_64 guard in nested_vmx_check_guest_state() is
> 	     removed.
> 	  ii) The data type of the parameter to kvm_dr7_valid() is
> 	      'unsigned long'.
> 
> 
> [PATCH 1/2 v3] KVM: nVMX: Check GUEST_DR7 on vmentry of nested guests
> [PATCH 2/2 v3] kvm-unit-test: nVMX: Test GUEST_DR7 on vmentry of nested guests
> 
>  arch/x86/kvm/vmx/nested.c | 4 ++++
>  arch/x86/kvm/x86.c        | 2 +-
>  arch/x86/kvm/x86.h        | 6 ++++++
>  3 files changed, 11 insertions(+), 1 deletion(-)
> 
> Krish Sadhukhan (1):
>       nVMX: Check GUEST_DR7 on vmentry of nested guests
> 
>  x86/vmx_tests.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
> 
> Krish Sadhukhan (1):
>       nVMX: Test GUEST_DR7 on vmentry of nested guests
> 

Queued, thanks.

Paolo

