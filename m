Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244EB1859EB
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 04:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727738AbgCOD4G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 23:56:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57494 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727447AbgCOD4F (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 23:56:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584244564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G7U9eOBxycUxXuaSYt7hoS9gbd47jdv119MFjfE5TZ4=;
        b=M+f3VMz9FU3iWNCBdKmvcKjhmYAEEHBcD0MZfDTBg9+OTKHkQngSJOl+X9wMHb3dayfrQe
        2bLkgAaZDzETJXGmtcCGhaqFz0kb9Vbv1GiORXGYF+7Td6ArDwTyIaM+k5uDvnT39xkRfF
        GyIEdrRBGMGJADzVhCYSdJRRtUytFFs=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-111-Y777FTvjOv-WeHNXz_D_fA-1; Sat, 14 Mar 2020 07:52:32 -0400
X-MC-Unique: Y777FTvjOv-WeHNXz_D_fA-1
Received: by mail-wr1-f69.google.com with SMTP id t4so2903686wrv.9
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 04:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=G7U9eOBxycUxXuaSYt7hoS9gbd47jdv119MFjfE5TZ4=;
        b=GRyLPswp8dZJtX0TFocgN3cY7ulCfs3t8nVE50ARTbXPDw69rx1nnpWJm9nrDtNqS8
         NI4pANB+V+32F2VV98yjMVO+IzZMVr0HiMQqiaR94JPoHTJvUlkgb8YiADduEj0dTmrr
         EEjmeLiglFkXp8uDFo9goFv4nv5yQM96LMCdVtfpmw4H00r2+3+9uD4R1f6sYwU2ekXi
         gL+g+qeeqgcTkcCr3gVjpRyY0PLBVpMloyWXT0WebQD2xLR0TDr0A2g/WZ/3Mlff8fZ4
         KC2dDRuBAq6VnvsDbRdX8sPM0l9swci5S1DTPTKsnV29uO/F8tPpHY2bE2Eupiso73Zc
         2IDg==
X-Gm-Message-State: ANhLgQ164OtQj/yKHgOeaqa+kH2voblFU4NP09vluFkfzXn8inwDumrp
        0XOjAFFQuugp2VoL+iBikWjpUztdKEaepOFH97rhwzGRfWYl3tldU6MfG1X8hk2NzZ8J5ltKtQV
        hY9PJO2WFIkWH
X-Received: by 2002:adf:e3cc:: with SMTP id k12mr19942151wrm.266.1584186751099;
        Sat, 14 Mar 2020 04:52:31 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtbO2E61XdLtXp/96mfvEQSV5mUdgZ8xyNKOMzmTPGn0uJp/s3kNcRw4aIWCJobbf0eDb3gIg==
X-Received: by 2002:adf:e3cc:: with SMTP id k12mr19942136wrm.266.1584186750833;
        Sat, 14 Mar 2020 04:52:30 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7de8:5d90:2370:d1ac? ([2001:b07:6468:f312:7de8:5d90:2370:d1ac])
        by smtp.gmail.com with ESMTPSA id k126sm21021489wme.4.2020.03.14.04.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 04:52:30 -0700 (PDT)
Subject: Re: [PATCH 0/6] KVM: nVMX: propperly handle enlightened vmptrld
 failure conditions
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
References: <20200309155216.204752-1-vkuznets@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1cebb8c1-45f3-4991-f3d9-40cea1be1871@redhat.com>
Date:   Sat, 14 Mar 2020 12:52:30 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309155216.204752-1-vkuznets@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/03/20 16:52, Vitaly Kuznetsov wrote:
> Miaohe Lin noticed that we incorrectly handle enlightened vmptrld failures
> in nested_vmx_run(). Trying to handle errors correctly, I fixed
> a few things:
> - NULL pointer dereference with invalid eVMCS GPAs [PATCH1]
> - moved eVMCS mapping after migration to nested_get_vmcs12_pages() from
>   nested_sync_vmcs12_to_shadow() [PATCH2]
> - added propper nested_vmx_handle_enlightened_vmptrld() error handling
>   [PATCH3]
> - added selftests for incorrect eVMCS revision id and GPA [PATCHes4-6]
> 
> PATCH1 fixes a DoS and thus marked for stable@.
> 
> Vitaly Kuznetsov (6):
>   KVM: nVMX: avoid NULL pointer dereference with incorrect EVMCS GPAs
>   KVM: nVMX: stop abusing need_vmcs12_to_shadow_sync for eVMCS mapping
>   KVM: nVMX: properly handle errors in
>     nested_vmx_handle_enlightened_vmptrld()
>   KVM: selftests: define and use EVMCS_VERSION
>   KVM: selftests: test enlightened vmenter with wrong eVMCS version
>   KVM: selftests: enlightened VMPTRLD with an incorrect GPA
> 
>  arch/x86/kvm/vmx/evmcs.h                      |  7 ++
>  arch/x86/kvm/vmx/nested.c                     | 64 +++++++++++++------
>  tools/testing/selftests/kvm/include/evmcs.h   |  2 +
>  tools/testing/selftests/kvm/lib/x86_64/vmx.c  |  2 +-
>  .../testing/selftests/kvm/x86_64/evmcs_test.c | 25 ++++++--
>  5 files changed, 72 insertions(+), 28 deletions(-)
> 

Queued, thanks.

Paolo

