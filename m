Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A2811BF98B
	for <lists+kvm@lfdr.de>; Thu, 30 Apr 2020 15:32:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbgD3NcY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Apr 2020 09:32:24 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45538 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726809AbgD3NcX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Apr 2020 09:32:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588253542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n+aTxk90D7+j/ZxikiZm7htr7ihgz4RE8XZxOaPVLGY=;
        b=gtPPVFgPExyl948+/cke/+sl18/aQd+1htu9rRcfPanZnn/E8z02WY2GUODVchxoe7f2jf
        HptQstYJA5lx/JrtZJR7sew71SdnqrwOvQEtvGs8uHWj6fyxH4qCbE5qhpUyAGrHQ18nIJ
        ANkszvIfHmhUvBVqChwZZ9noKutDTMU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-410-XEhHhp-qOnWCEG_l9m1Y3w-1; Thu, 30 Apr 2020 09:32:19 -0400
X-MC-Unique: XEhHhp-qOnWCEG_l9m1Y3w-1
Received: by mail-wm1-f70.google.com with SMTP id j5so855917wmi.4
        for <kvm@vger.kernel.org>; Thu, 30 Apr 2020 06:32:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=n+aTxk90D7+j/ZxikiZm7htr7ihgz4RE8XZxOaPVLGY=;
        b=auHrxGVVZQIdakFp7Kj/hizMWTTwGndaCTdI/kKNvDRMd4q3QFoSCgmkXAYUb3XS2t
         HfJix6bcc6zob12VMHpPjyyumjYCYN0h37s32l0YQuVfZwU75/xWez0xxe22Xm4J5sPl
         Y2aTb5dvrYVpXYBjsTZqyMtZuYTCaX1nTKML3/0ml7Do8bVg+WIfFY9Vf/YhVkK3cSSX
         FlIEpuQJ427lC7vJvNot8SZQ6aCZxFgTve/XTx3QFU/9Cg6+bAFfkEt9jSArWc97WOgK
         q5MEQulOT0002Xvidd6hMdU/fMKeervTG+zUg1gMip+B+BR/ZMrtsKcbLVT6/SvTAgAE
         GJ6g==
X-Gm-Message-State: AGi0PuZPxVkZKyr/lQGx5cFal9XovPLYcznhFGzf8HDLn4mJOR5JdkmD
        eCqt0+aiAu7ggaqZkv/8J83LuIPJvbp3sSb1xfLuIC5A+pWasD1M5pQgWhB6AYEaXnjDXA+hRV6
        gr0OYpOznNHNA
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr3164047wml.133.1588253538322;
        Thu, 30 Apr 2020 06:32:18 -0700 (PDT)
X-Google-Smtp-Source: APiQypLZwuDOopSSlnP92U8HygTNBmhhTn4PWDpNdu4eD+Pq/bkj6FBcQrWnMY670cOB2vZJ5e/KIA==
X-Received: by 2002:a05:600c:210b:: with SMTP id u11mr3164026wml.133.1588253538120;
        Thu, 30 Apr 2020 06:32:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ac19:d1fb:3f5f:d54f? ([2001:b07:6468:f312:ac19:d1fb:3f5f:d54f])
        by smtp.gmail.com with ESMTPSA id s6sm12332481wmh.17.2020.04.30.06.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2020 06:32:17 -0700 (PDT)
Subject: Re: [PATCH v4 5/7] KVM: VMX: Optimize posted-interrupt delivery for
 timer fastpath
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
 <1588055009-12677-6-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <66fd6180-8e8b-1f9c-90f1-a55af1467388@redhat.com>
Date:   Thu, 30 Apr 2020 15:32:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <1588055009-12677-6-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/20 08:23, Wanpeng Li wrote:
> -	if (exit_fastpath == EXIT_FASTPATH_REENTER_GUEST &&
> -	    kvm_vcpu_exit_request(vcpu))
> -		exit_fastpath = EXIT_FASTPATH_NOP;
> +	if (exit_fastpath == EXIT_FASTPATH_REENTER_GUEST) {
> +		if (!kvm_vcpu_exit_request(vcpu))
> +			vmx_sync_pir_to_irr(vcpu);
> +		else
> +			exit_fastpath = EXIT_FASTPATH_NOP;
> +	}

This part should be in patch 3; not a big deal, I can reorganize that
myself.

Paolo

