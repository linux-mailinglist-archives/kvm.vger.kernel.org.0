Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E954177BC5
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 17:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgCCQVO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 11:21:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:42293 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729382AbgCCQVN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 11:21:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583252473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DCeZj5j9NdL7UBpxH3v0lLKGG3Zlc6FhMXze5Z03xF8=;
        b=WjBP76CYiACr3MaxrTuUIkC80U9QjOgItxhzGxFBbYSzqFGYvWrp+GIjKFIzDP3waYJJMq
        RYAMlj4bTeoRRG993yXzpJWTwLocduN+ZMKErULdqW2TL1zr2nUq6ZxlLA3ceMYHdvUe1v
        51GiGM8j49GytSd0foZ9R+LVBX9P3zg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-206-xNRjjaiUPOOWkMQDHwl0iQ-1; Tue, 03 Mar 2020 11:21:11 -0500
X-MC-Unique: xNRjjaiUPOOWkMQDHwl0iQ-1
Received: by mail-wm1-f70.google.com with SMTP id r19so1315181wmh.1
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 08:21:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DCeZj5j9NdL7UBpxH3v0lLKGG3Zlc6FhMXze5Z03xF8=;
        b=eyn9wX+HOKrZlbK10yLl36hNu9iEZzaIyfeBgBd+l9GGA7tnmrHkuoN1MznzbbDQEw
         wJizSQC706aGEevSI4cyYNQY6PoG/+LCOW4Hke3FunmFxNebZ61fixy0y5kncSyOi+G1
         oB8xUUtAfH19rg9Q+TrGwdq3dxMUlkUOFFh1UhRUq58Dsq0DZCKUpy3lO/nYJujYz++A
         gZ/qTAAT9l6nC8BES85Un3letBHdeMbne0qhXjt/R6yqAh4L0X1X38P7IgejKtwJNeSo
         EIkBwSCw3rpCqnaA/d5Px4ZvxMzQq6anKz8aszNGiArBfJnOsMaDAAw93xxi0XR7YGsa
         NGBQ==
X-Gm-Message-State: ANhLgQ0MKeVmUHToOV5+lijQF9b511R2pzBK+ytYt6d8QwpSj5pnWr17
        /Hn3czkyW+jLVaxL4h3kVZFmCw/lAlK99VS2KFtGRCEsgAf7YcviTiO3DCSOYe6YmfczpYrfoGU
        RYNoBBB4mmhQF
X-Received: by 2002:a5d:4dc2:: with SMTP id f2mr6141668wru.293.1583252470206;
        Tue, 03 Mar 2020 08:21:10 -0800 (PST)
X-Google-Smtp-Source: ADFU+vvsutRpekH5hSIMUkCUQL3Af25B6EYt6WV4MX0oXaABfru5qSw5Hb/cPaoCQBFFCRN89HfuKw==
X-Received: by 2002:a5d:4dc2:: with SMTP id f2mr6141655wru.293.1583252469994;
        Tue, 03 Mar 2020 08:21:09 -0800 (PST)
Received: from [192.168.178.40] ([151.20.254.94])
        by smtp.gmail.com with ESMTPSA id z14sm31327373wrg.76.2020.03.03.08.21.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 08:21:09 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: x86: clear stale x86_emulate_ctxt->intercept
 value
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Bandan Das <bsd@redhat.com>, Oliver Upton <oupton@google.com>,
        linux-kernel@vger.kernel.org
References: <20200303143316.834912-1-vkuznets@redhat.com>
 <20200303143316.834912-2-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4f933f77-6924-249a-77c5-3c904e7c052b@redhat.com>
Date:   Tue, 3 Mar 2020 17:21:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200303143316.834912-2-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/03/20 15:33, Vitaly Kuznetsov wrote:
> Commit c44b4c6ab80e ("KVM: emulate: clean up initializations in
> init_decode_cache") reduced the number of fields cleared by
> init_decode_cache() claiming that they are being cleared elsewhere,
> 'intercept', however, seems to be left uncleared in some cases.
> 
> The issue I'm observing manifests itself as following:
> after commit 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest
> mode") Hyper-V guests on KVM stopped booting with:
> 
>  kvm_nested_vmexit:    rip fffff802987d6169 reason EPT_VIOLATION info1 181
>     info2 0 int_info 0 int_info_err 0
>  kvm_page_fault:       address febd0000 error_code 181
>  kvm_emulate_insn:     0:fffff802987d6169: f3 a5
>  kvm_emulate_insn:     0:fffff802987d6169: f3 a5 FAIL
>  kvm_inj_exception:    #UD (0x0)

Slightly rephrased:

After commit 07721feee46b ("KVM: nVMX: Don't emulate instructions in guest
mode") Hyper-V guests on KVM stopped booting with:

 kvm_nested_vmexit:    rip fffff802987d6169 reason EPT_VIOLATION info1 181
    info2 0 int_info 0 int_info_err 0
 kvm_page_fault:       address febd0000 error_code 181
 kvm_emulate_insn:     0:fffff802987d6169: f3 a5
 kvm_emulate_insn:     0:fffff802987d6169: f3 a5 FAIL
 kvm_inj_exception:    #UD (0x0)

"f3 a5" is a "rep movsw" instruction, which should not be intercepted
at all.  Commit c44b4c6ab80e ("KVM: emulate: clean up initializations in
init_decode_cache") reduced the number of fields cleared by
init_decode_cache() claiming that they are being cleared elsewhere,
'intercept', however, is left uncleared if the instruction does not have
any of the "slow path" flags (NotImpl, Stack, Op3264, Sse, Mmx, CheckPerm,
NearBranch, No16 and of course Intercept itself).

Paolo

