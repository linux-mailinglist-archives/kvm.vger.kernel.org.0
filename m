Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04D6A46E78B
	for <lists+kvm@lfdr.de>; Thu,  9 Dec 2021 12:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbhLIL3v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Dec 2021 06:29:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235554AbhLIL3u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Dec 2021 06:29:50 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5850EC061746;
        Thu,  9 Dec 2021 03:26:17 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id w1so18354719edc.6;
        Thu, 09 Dec 2021 03:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6I7gcf5wC47jbwDo1JFSLG4r1VHdFOvTP1BivCmF0hY=;
        b=CS+uz0etQyLnpDt0mL0vLTBDDW4RoOjwnzqNw1rGSH9xPONOjPWZlSlf4K/T1e9KOW
         RW+eaoU2vCu3/Ci0d1vUsgc8dQ/USnElm3wLZ1zKQSaBhsE2OQUiW9sueTesXxltipWD
         wUddLZoyjnQrxIa2kUvM7qoOyWcp2teOYzbNERumsfTLLp/qi7ZfT9YPKFDz2D+v7g/E
         VGRr+wpe2dNDf/bjVvBB60mVPCh5xCc1swjziKTh6os+WN5AmW7p+Ty2ZJc3wdLAugF6
         lcu4qJE+NfJGMpjX7DInICmmfMMvD/NyxoO08KH+gZxmGtlXTGJy04pI/utcTIX9T0EC
         yNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6I7gcf5wC47jbwDo1JFSLG4r1VHdFOvTP1BivCmF0hY=;
        b=fvWAfJdYHDs3T3O3eh+vABu2zmrSoQci++CEJ2Z+MYxilWER6SASs0xRgLxPtXa0Ef
         iuEP7kLq3cBDfCa0tTalwV8tGqNLCoidzSOr7HHLZ9KYi68uZlWQXYXXdz6BP5Mfe6PS
         yGWn26ZHgXNfgQKJHTR/AMq25eb+PqFZhx8wehtrJRsgWQMgLC9bxR0zqRGMY0VezigM
         k8ExIr09fV4JY4HcfJleNSew1uykap19gRDU7uPgNftN7UTbxDDmczj9JcfGXqtaBTRw
         +9R39zexuEWtNbtd01GaWHWPQIlsB/U5ORxhTah3JXf7ep2vquaPxTsqlqdoRWX+sdOP
         mkVQ==
X-Gm-Message-State: AOAM530zAz2P1T7RSltZGV/JUalrv6Ywj7rrCNKb+xuramq7vh1hnz/m
        FIisLoEUKhUHW57gbIS96Kc=
X-Google-Smtp-Source: ABdhPJzQUAk/nnR/ZGguzZslyhqKPWxv1/TTFLH0O6nxkwyQXgKu+O396y31Jt1KzIsrgwX0LldNwg==
X-Received: by 2002:a05:6402:190c:: with SMTP id e12mr28771087edz.396.1639049173867;
        Thu, 09 Dec 2021 03:26:13 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id cw5sm3089837ejc.74.2021.12.09.03.26.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Dec 2021 03:26:13 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <b3f9f46d-a424-a58c-e503-9069f46585f3@redhat.com>
Date:   Thu, 9 Dec 2021 12:26:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/4] KVM: VMX: Fix handling of invalid L2 guest state
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+f1d2136db9c80d4733e8@syzkaller.appspotmail.com,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20211207193006.120997-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211207193006.120997-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/7/21 20:30, Sean Christopherson wrote:
> Fixes and a test for invalid L2 guest state.  TL;DR: KVM should never
> emulate L2 if L2's guest state is invalid.
> 
> Patch 01 fixes a regression found by syzbot. Patch 02 closes what I suspect
> was the hole the buggy patch was trying to close.  Patch 03 is a related
> docs update.  Patch 04 is a selftest for the regression and for a subset
> of patch 02's behavior.
> 
> Sean Christopherson (4):
>    KVM: VMX: Always clear vmx->fail on emulation_required
>    KVM: nVMX: Synthesize TRIPLE_FAULT for L2 if emulation is required
>    KVM: VMX: Fix stale docs for kvm-intel.emulate_invalid_guest_state
>    KVM: selftests: Add test to verify TRIPLE_FAULT on invalid L2 guest
>      state
> 
>   .../admin-guide/kernel-parameters.txt         |   8 +-
>   arch/x86/kvm/vmx/vmx.c                        |  36 ++++--
>   tools/testing/selftests/kvm/.gitignore        |   1 +
>   tools/testing/selftests/kvm/Makefile          |   1 +
>   .../x86_64/vmx_invalid_nested_guest_state.c   | 105 ++++++++++++++++++
>   5 files changed, 138 insertions(+), 13 deletions(-)
>   create mode 100644 tools/testing/selftests/kvm/x86_64/vmx_invalid_nested_guest_state.c
> 

Queued, thanks.

Paolo
