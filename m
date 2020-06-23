Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CBE2204E1C
	for <lists+kvm@lfdr.de>; Tue, 23 Jun 2020 11:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732011AbgFWJiQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jun 2020 05:38:16 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:32168 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731929AbgFWJiQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Jun 2020 05:38:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592905095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=49gqC52SNruUIJgdOHQWjZ/EQ4cGKnvSIHeC7qzdXXc=;
        b=XUj2kzOPO/JItT4O5zzlqQiEauuB/YJm+MSoIAKD0OS/iDop43sMpbipFtCwdtfxOmrYjh
        Y08sB/XQncp9XuyuUM8924b8cAy4fATsCEPqLXSVVk9Z3XRvMbOb+Tnc43cc32atBTPWiM
        cfcmgwS2s8qXkjDFEG8CTRmrzUs1CWs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-135-woHQ_uYeNdqDviNH-gxw0g-1; Tue, 23 Jun 2020 05:38:14 -0400
X-MC-Unique: woHQ_uYeNdqDviNH-gxw0g-1
Received: by mail-wm1-f70.google.com with SMTP id o13so3356553wmh.9
        for <kvm@vger.kernel.org>; Tue, 23 Jun 2020 02:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=49gqC52SNruUIJgdOHQWjZ/EQ4cGKnvSIHeC7qzdXXc=;
        b=MSb6swp9VBDUvscvzd6vPuur0cfEvmsUFZ/+jq4ktA3Z39oV0anWjZItVwVwI0jPNN
         RGrS0d9utl0JqjYDXHNGrqEa5i6NbvMi0Npa1QQqysHZkos/AOc96kQLkHj3ZIDdYnKJ
         RwMMaS5HFz48XLRWxC7IaOidioFv52KBplSqdoaGlMTt4AShvvYoAvwopKqbdK1pBI3a
         P0cSzgNS/huWpSbcfdEkaYKL8IuFrDPwClk8WRqO3Niwaw439DlTpkh9N/SBUbUC/Xvl
         qUlYwygwtBOUlDQGPqbxuDl3I6RwfAOvYi4cU1ixMMNRvP71LqIm6zsykieGLvJWbS97
         DsiA==
X-Gm-Message-State: AOAM532Xc3qWuGVDYNXic+r39Sjbz5U/UO2VJfBVAvLjyIdQYssqgzRe
        SsCgzeaFx/sRXTQucgETJgLa3eP09PlkxfxT5pmj5eU0hwkIv5uGSUvhbtGZnBlm614e5dLYhuj
        SkUPx7ih5e5Fv
X-Received: by 2002:a1c:4187:: with SMTP id o129mr3125323wma.38.1592905092960;
        Tue, 23 Jun 2020 02:38:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwq/0679MuZvIaPvX1WWewRB4gARTUFIStDzpJ6aOYCG5tFW9wcbNINeQOYcdxwA9/inspg3Q==
X-Received: by 2002:a1c:4187:: with SMTP id o129mr3125310wma.38.1592905092755;
        Tue, 23 Jun 2020 02:38:12 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:fd64:dd90:5ad5:d2e1? ([2001:b07:6468:f312:fd64:dd90:5ad5:d2e1])
        by smtp.gmail.com with ESMTPSA id n16sm2777677wmc.40.2020.06.23.02.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jun 2020 02:38:12 -0700 (PDT)
Subject: Re: [PATCH] KVM: nVMX: Wrap VM-Fail valid path in generic VM-Fail
 helper
To:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20200609015607.6994-1-sean.j.christopherson@intel.com>
 <CALMp9eQNF0b8q3naibxtKxo=pym554hRoMJ5ro5febzOUBU-=A@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8f7f7592-7d6f-b1ac-aa85-e5904865b21a@redhat.com>
Date:   Tue, 23 Jun 2020 11:38:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQNF0b8q3naibxtKxo=pym554hRoMJ5ro5febzOUBU-=A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/20 19:54, Jim Mattson wrote:
> On Mon, Jun 8, 2020 at 6:56 PM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>>
>> Add nested_vmx_fail() to wrap VM-Fail paths that _may_ result in VM-Fail
>> Valid to make it clear at the call sites that the Valid flavor isn't
>> guaranteed.
>>
>> Suggested-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Reviewed-by: Jim Mattson <jmattson@google.com>
> 

Queued, thanks.

Paolo

