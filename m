Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE3663E57BC
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 11:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbhHJKAD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 06:00:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37804 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239501AbhHJJ76 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 05:59:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628589576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3ld0ov5ZFUXowL08LtrrPHuGTJpIQ0NXDqTK+zb0kPo=;
        b=Ec43FRyt+UpKO6ROs4MQEkNN7AUp4JyL2/TNaSHHTE8k1P+SYaDG9m+Vo+fTYVfqbcOYca
        rg5VT38Aa+2zE2eVcAAjZU/tRyfLlodU8FAzEKxWHox4qcJYJpJuyNKz6fZYzFUwPf/Lri
        TsSPHk3kCfPu7pK4/HiTqlZIZxK1wJQ=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-197-AuQIT9FjMdefWc3oTiDYjw-1; Tue, 10 Aug 2021 05:59:35 -0400
X-MC-Unique: AuQIT9FjMdefWc3oTiDYjw-1
Received: by mail-ej1-f72.google.com with SMTP id kf21-20020a17090776d5b02905af6ad96f02so1662078ejc.12
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 02:59:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ld0ov5ZFUXowL08LtrrPHuGTJpIQ0NXDqTK+zb0kPo=;
        b=XumCTlB0KLitVcI+dfb5xIWFbBczGbUoHXxyH9uqaaCmqXDQf3qFnsD5Xh6xXqj1fE
         Zl85cDHWkoxe/f/SAp6yzFqWuY0eJ63gD2TCXUY0yTIJC6iEaHedHmZIiKKqnxFKURWq
         JP3JH5UR1NKMuNuZGVjr2H3ezkcNSYJ64qgKqVI6j5B04fpVfWqfpCPw5P/RGhBXxcJ1
         PALymsFR6bcc5/ZYiyladO5m26TfrB3htunjExQVvFdmA7fV3H/xQ4IitJqNSBj0Qz3J
         lfebbEg4y7yQ2SxTeey6YLFHA0Wj3kl1Exf7PQqCoksRx3z53K6xMv+6j/Xv2UDhE5I9
         xknw==
X-Gm-Message-State: AOAM532Tb3O4n1u0z8YiWErr1j/7MTzNyesOX5FBBu1Ls+O06k6E0Lw7
        cW221EDZkSu2hLdA2Vw8t2ZZXSTgpLlTuhZHS/nrg88HhrzuvcW/3iT3VYPm3d13MDVnZilstCA
        MDkfzOP4RFZRqvW6rO6DALQm9m0MLz1M56W4TCLv0Si3G6B4txxx9TUJbog1yBs8q
X-Received: by 2002:a50:bb2e:: with SMTP id y43mr3967361ede.103.1628589573625;
        Tue, 10 Aug 2021 02:59:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5saJYoklO3PlR4J0I3tkMX/trMfPhYNaGzws5Cn/JV+9a9cwjuu9i9GaWViUAQy7+HEBujw==
X-Received: by 2002:a50:bb2e:: with SMTP id y43mr3967341ede.103.1628589573452;
        Tue, 10 Aug 2021 02:59:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id b5sm6683059ejq.56.2021.08.10.02.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 02:59:32 -0700 (PDT)
Subject: Re: [PATCH] KVM: X86: Don't reset dr6 unconditionally when the vcpu
 being scheduled out
To:     Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Lai Jiangshan <laijs@linux.alibaba.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        kvm@vger.kernel.org
References: <20210808232919.862835-1-jiangshanlai@gmail.com>
 <YRFdq8sNuXYpgemU@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8726aff8-f7d0-d4e0-ed59-aeffc2a4c2f5@redhat.com>
Date:   Tue, 10 Aug 2021 11:59:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YRFdq8sNuXYpgemU@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/08/21 18:54, Sean Christopherson wrote:
> Not directly related to this patch, but why does KVM_DEBUGREG_RELOAD exist?
> Commit ae561edeb421 ("KVM: x86: DR0-DR3 are not clear on reset") added it to
> ensure DR0-3 are fresh when they're modified through non-standard paths, but I
> don't see any reason why the new values_must_  be loaded into hardware.  eff_db
> needs to be updated, but I don't see why hardware DRs need to be updated unless
> hardware breakpoints are active or DR exiting is disabled, and in those cases
> updating hardware is handled by KVM_DEBUGREG_WONT_EXIT and KVM_DEBUGREG_BP_ENABLED.

The original implementation of KVM_DEBUGREG_WONT_EXIT (by yours truly) 
had a bug where it did not call kvm_update_dr7 and thus 
KVM_DEBUGREG_BP_ENABLED was not set correctly.  I agree that commit 
70e4da7a8ff6 ("KVM: x86: fix root cause for missed hardware 
breakpoints") should have gotten rid of KVM_DEBUGREG_RELOAD altogether.


Paolo

