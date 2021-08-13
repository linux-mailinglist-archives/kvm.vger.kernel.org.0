Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92DD53EB43B
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 12:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240185AbhHMKpD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 06:45:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239223AbhHMKo5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 06:44:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628851470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CCRKNaL8rUMbzILuCY+AB0BP3lwlD4VuYd7MDG+p8TM=;
        b=dT5ADOLMvVRXTm6PCG7t35yuMmu6O5UD3+m+01SNt5QuV84/DhdIQAa8XKzT4KGCO4PTgs
        wbMk9fbKFyCkaZ2/mjLc/dzc2e0Dv/WBoVMp/YFgyeLUxOYs9Qt9WcsR+Fk3hTtCXDOg85
        tPU/c0qv4VXsMv15vSKqvmXY0xnIDmE=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-HG_VEAT9M5OhT9_esjbcQQ-1; Fri, 13 Aug 2021 06:44:29 -0400
X-MC-Unique: HG_VEAT9M5OhT9_esjbcQQ-1
Received: by mail-ej1-f70.google.com with SMTP id ju25-20020a17090798b9b029058c24b55273so2825043ejc.8
        for <kvm@vger.kernel.org>; Fri, 13 Aug 2021 03:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CCRKNaL8rUMbzILuCY+AB0BP3lwlD4VuYd7MDG+p8TM=;
        b=Xa3enwA6PIIUidJts9JA7fnTRprsB/LgKN9ZDAZwFnaYEKcKaZ89LeTPC3Y0upyI1j
         fozWGVCtnExTpUsAbAcsPehhULOAVRVuukYRQNPDpLPY7dAwGs4fH3qTnGJBU3QNKXHv
         PvC6OIQLCOsVZeEUJHbtHzIEeuFqi1sYEq05qVpy+Z2ygsg2IXsxDpSQXeglYaZvaU7H
         1oyC9R5+XM28uLQU3cc2oEYRvuCsNbIt35N+QbEoYD0Kz2rkXpMRV1yccST91pp/Km2h
         c/D5AEMn5k8CHwQkadW09XdiadVtu9twZPIqcnK8yNE92aOpBbBA3dR+TajtwFGi7+mD
         4tbg==
X-Gm-Message-State: AOAM5309DZDwax4kcCDVKDCLmmJeZh2FiLZUpTN8eIwGizeMeJ/7eisZ
        DglVo9kPwXYYkt5hsJ+IiejWqBbOjOUFru8qtb9MGvkz7NEs9YCBy2Vp03lP7vGcDsj7njCRCR4
        EwTxrP/v56XZU
X-Received: by 2002:a17:906:6b0c:: with SMTP id q12mr141882ejr.0.1628851468596;
        Fri, 13 Aug 2021 03:44:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzbOi0KwA+drc3M+Egn5GSdsceHGVvGcEGdWBkM4ljas5GpNbvsJOOdudbDSGWUVsAACOZz2w==
X-Received: by 2002:a17:906:6b0c:: with SMTP id q12mr141872ejr.0.1628851468394;
        Fri, 13 Aug 2021 03:44:28 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m19sm484596edd.38.2021.08.13.03.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 03:44:27 -0700 (PDT)
Subject: Re: [PATCH v6 01/21] KVM: x86: Fix potential race in KVM_GET_CLOCK
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
References: <20210804085819.846610-1-oupton@google.com>
 <20210804085819.846610-2-oupton@google.com>
 <78eeaf83-2bfa-8452-1301-a607fba7fa0c@redhat.com>
 <CAOQ_QsiwzKpaXUadGR6cWC2k0pg1P4QgkAxNdo0gpVAP1P3hSQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0b415872-7a67-d38b-ae01-62c38b365be0@redhat.com>
Date:   Fri, 13 Aug 2021 12:44:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAOQ_QsiwzKpaXUadGR6cWC2k0pg1P4QgkAxNdo0gpVAP1P3hSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/08/21 12:39, Oliver Upton wrote:
> Might it make sense to fix this issue under the existing locking
> scheme, then shift to what you're proposing? I say that, but the
> locking change in 03/21 would most certainly have a short lifetime
> until this patch supersedes it.

Yes, definitely.  The seqcount change would definitely go in much later. 
  Extracting KVM_{GET,SET}_CLOCK to separate function would also be a 
patch of its own.  Give me a few more days of frantic KVM Forum 
preparation. :)

Paolo

