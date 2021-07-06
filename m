Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01CA3BD8DA
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 16:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbhGFOt4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 10:49:56 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55291 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232141AbhGFOtz (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 6 Jul 2021 10:49:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625582835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cn4J7G4tuvS6OiK2L10T2Hq0RndQq16jPtOwTvn2o60=;
        b=T7l6yaEMKKvY/ZiQ7ROXYVROT4fk2lPpCh0U+/l3zsR9GyTWF2lELq2x1laZ1nyhhtykYu
        8kiDSuumKqfTgZWm1Z1buAzY6dxpimsdW38tBOgzveImFeAlmAbcaC8k9VRvsM5jSXn3Lj
        9mkFOt9POm2upXCGqonBDSHaqJYzRuY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-258-SFoZp9rSPPyu9GpOto46ng-1; Tue, 06 Jul 2021 09:56:58 -0400
X-MC-Unique: SFoZp9rSPPyu9GpOto46ng-1
Received: by mail-ed1-f72.google.com with SMTP id y18-20020a0564022712b029038ffac1995eso10929952edd.12
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 06:56:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cn4J7G4tuvS6OiK2L10T2Hq0RndQq16jPtOwTvn2o60=;
        b=KmtiWB31IECIP3n/eSpWoAukq6RXxJ83ZDjy5/3gIgA1Wyawy96L7+2CG1seq8zGEG
         jUK5gHFnxR12csqR9vHST40oP/JTIyNwO59N0O1oGsnXFSgoV94lHahp/ddJU0EIIGc+
         i1LC1dCedcdcyJwnRMzD36z9BImdIrkEuEeMgml/BnhcauAKc2IME1e3SaEGm3PGmFAd
         esTO1ZYt6HFnlmmsbLLDPSAuRc9+gnnrblZTwkbnWiaz09Imw5qsEdD4HNGGlZ26g5VK
         tQXYCDGZTjdiZVa6KRlcNbAuHXfx+yiK0lAPggKzDk2IUyIX8SQYCRh5xg65wxPTQoVf
         rZAg==
X-Gm-Message-State: AOAM530Ysv6/KlBapVGf+AiLOwGcc58JzIp8XXn5qjXHsw06O2ZOUBnd
        CqteE95/9whK9GrTGm6GjW2DWMHhENSNN5UwtQJcU0V/TExaU25jo1L5hhi+jegwci5V+L3m2st
        RwXsP29AVtGqG
X-Received: by 2002:a05:6402:10cc:: with SMTP id p12mr23684315edu.328.1625579817781;
        Tue, 06 Jul 2021 06:56:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBEjrKLA2on/19nD0Yrx16CtK6qfZTo+SZiIj4Qb4FDWHAn0TYddMFnDv/qyTK4JPOFjaIjA==
X-Received: by 2002:a05:6402:10cc:: with SMTP id p12mr23684293edu.328.1625579817648;
        Tue, 06 Jul 2021 06:56:57 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id ec40sm7301496edb.57.2021.07.06.06.56.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 06:56:57 -0700 (PDT)
Subject: Re: [RFC PATCH v2 22/69] KVM: x86: Add vm_type to differentiate
 legacy VMs from protected VMs
To:     isaku.yamahata@intel.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, erdemaktas@google.com,
        Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     isaku.yamahata@gmail.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
References: <cover.1625186503.git.isaku.yamahata@intel.com>
 <8eb87cd52a89d957af03f93a9ece5634426a7757.1625186503.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e2270f66-abd8-db17-c3bd-b6d9459624ec@redhat.com>
Date:   Tue, 6 Jul 2021 15:56:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8eb87cd52a89d957af03f93a9ece5634426a7757.1625186503.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/07/21 00:04, isaku.yamahata@intel.com wrote:
>   
>   struct kvm_arch {
> +	unsigned long vm_type;

Also why not just int or u8?

Paolo

