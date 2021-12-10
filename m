Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D0D47058E
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 17:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242965AbhLJQ1J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 11:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241418AbhLJQ1G (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 11:27:06 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C2C5C0617A1;
        Fri, 10 Dec 2021 08:23:30 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id o20so32013726eds.10;
        Fri, 10 Dec 2021 08:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jru1WtZAAl1v87srU8rHvIkDe0HcCeKGzsDJdVp8o6s=;
        b=fBN9N1xUKuyv1pl5VLRbqrfdTGOQWHGsMkMqeSwexMhFhgFeYPBp546U9GCXrgYLQT
         zr/CyErCRV32MziAhW8a7puLaVyer3HewWLZZMgAKMkCS1L2f+NrhyidaFZkd9J/dhDN
         2M/CMo9XDmD4jbF77WPI/PAVhii9ldPXP15ju+aBU9phpNic6IBcvVAmq8ogbOJUgQNB
         7rHiyswiwCxsFfZxtDA3qWT01Q/wXxq9slX5wo/nUCz2FHJdJSstwDJoVN621mhXOrTs
         dZ2io6a/F8qcuRFkzKSVxx1bYzSrguRnNU5EiL+XMlhuS9NMrTSgJgbhbdPKrIHYMLDo
         UmYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jru1WtZAAl1v87srU8rHvIkDe0HcCeKGzsDJdVp8o6s=;
        b=fRY3G3+a5qXF3YyxdeUK1TxuSKhJACtbHk6bYyX0KKJhkqmFhuxt/NL1istEsqaGWf
         uarkarg1Dwxz8v1oaTz2SlAqvCbBMcr4yGvpKLxZJK1O/Kd0egIZycvzTi1jFEzc+jdi
         LKYGDiQdhPY++cja9C5OQJpTgG20XUAEmsAFuZ+k8E+GoSS/T84pMrWOLB+3XghpxTbO
         GvAQgIGQbQJEs0rTRUZsN8dDMJTsJNHwxUT+uw1r3HS83cKyyrOP/4HRaZfrYt0JFQXn
         JXOFIYiFw8VT+38S4b73vnm+qromEsY8iM8gLnOwBeBdBC8eDBsul5rsocJwC4RBtEeM
         PMVQ==
X-Gm-Message-State: AOAM532TQTi/tQVH2U6NreSfPSUFUtfcQ7te4wjzHAAirQpZ93nE3V0C
        2ZhQJu55tbHl4vOA0UPtTsA=
X-Google-Smtp-Source: ABdhPJxnTQZ6SeIm11KFhuVTjmU6bFDXfkPz1UECBGG0Glgq74LmC78V01j/zfsEJCWEiDInPLsLoQ==
X-Received: by 2002:a05:6402:100e:: with SMTP id c14mr40678595edu.196.1639153407714;
        Fri, 10 Dec 2021 08:23:27 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id s16sm1685046edt.30.2021.12.10.08.23.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 08:23:27 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <fbfb1377-a6e7-a0c0-2001-606c6529ce0f@redhat.com>
Date:   Fri, 10 Dec 2021 17:23:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-16-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-16-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:03, Yang Zhong wrote:
>   		kvm_steal_time_set_preempted(vcpu);
>   	srcu_read_unlock(&vcpu->kvm->srcu, idx);
>   
> +	if (vcpu->preempted)
> +		fpu_save_guest_xfd_err(&vcpu->arch.guest_fpu);
> +

Instead of checking vcpu->preempted, can you instead check if the active 
FPU is the guest FPU?  That is, save if 
current->thread.fpu->fpstate->is_guest?

Paolo
