Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36102103DF6
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 16:05:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbfKTPFq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 10:05:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:56727 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728030AbfKTPFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 10:05:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574262345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=XIYnrCUEYGZooNbi5Qcyd8gI3d85pVdDs8CghR6VpAY=;
        b=Ku3EN/Tp4S+KL8ZJY9fPS80WJHCSMPwQ8PkEddtbPY6TxyuzYmy7C9TbCRngghLiFUiLeK
        9nAN7cRPbI4lPMOI8lWDtIgbYxVEioDHbc6L6kxAPz1Ptf8lmFjiI6vuEMqnhSaOSbZbRL
        tZ1QplQbM3iP6Q6V1adoWcpZy+GyQxc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-fb4ljzP3P7-tMvmd7rpefQ-1; Wed, 20 Nov 2019 10:05:43 -0500
Received: by mail-wm1-f69.google.com with SMTP id y14so4655442wmj.9
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 07:05:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cP6Y0Y2FTtRbIYgs6ZXasrAcdMcWh8XhX6tTnulznEU=;
        b=Wm0axql7vRPned4fCWwZXZbVsg5sAjgJox72upMYqAl/9WEbykVDa0N9BsN77cevzy
         xxM4dkdsFQb40PAa/B4ZGrbj1zmwGkDnedYqMNhDILpMIjp3529Zzj+jCcTyK4r/D5s5
         CdOvj/UyQWgYf5UEdADqAiGStDJ6lb1UuE6uxtV1CqwUZSAGK96EEiDHbqMV+Gvsmqy/
         JqSA69bTzYQaDwGyT6P82cdp3TJE9TYmcukEpRlXnFR8F+ZUy2MWtp6LCNq6HddK95SG
         VPIMMWEgGuISOb6Q2KO7h1W+tgxFQlsX8gYUhWweBw5pPM1eBKqc84yP/cyRxlQFHom1
         RYfA==
X-Gm-Message-State: APjAAAXI5642SPCyN36rwgSxIKJCLY8Njw5fkaAbOC/ZblxMZNJOGng0
        phNr5UsGTPGayvDW2+bvfLdHV8fpxcneGfQBATtKetZxtOfOwtawlcGBRXUkaBoG93V32Zk8Nnb
        2aU+bHbh/vJNR
X-Received: by 2002:adf:f282:: with SMTP id k2mr4052879wro.387.1574262342537;
        Wed, 20 Nov 2019 07:05:42 -0800 (PST)
X-Google-Smtp-Source: APXvYqzPHF5rOoBbmqXRSeWc3ngbFY4fnPjS5tXIpFuBAd/S+LUKUN5kYp77zEFvnEDxXOE47twiyQ==
X-Received: by 2002:adf:f282:: with SMTP id k2mr4052833wro.387.1574262342249;
        Wed, 20 Nov 2019 07:05:42 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:dc24:9a59:da87:5724? ([2001:b07:6468:f312:dc24:9a59:da87:5724])
        by smtp.gmail.com with ESMTPSA id p9sm21622545wrs.55.2019.11.20.07.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 07:05:41 -0800 (PST)
Subject: Re: [PATCH] KVM: nVMX: Remove unnecessary TLB flushes on L1<->L2
 switches when L1 use apic-access-page
To:     Liran Alon <liran.alon@oracle.com>, rkrcmar@redhat.com,
        kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, jmattson@google.com,
        vkuznets@redhat.com, Joao Martins <joao.m.martins@oracle.com>
References: <20191120143307.59906-1-liran.alon@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <d7d4629a-c605-72bc-9d71-dd97cb6c0ab4@redhat.com>
Date:   Wed, 20 Nov 2019 16:05:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191120143307.59906-1-liran.alon@oracle.com>
Content-Language: en-US
X-MC-Unique: fb4ljzP3P7-tMvmd7rpefQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/19 15:33, Liran Alon wrote:
> "Virtualize APIC accesses" VM-execution control was changed
> from 0 to 1, OR the value of apic_access_page was changed.
>=20
> Examining prepare_vmcs02(), one could note that L0 won't flush
> physical TLB only in case: L0 use VPID, L1 use VPID and L0
> can guarantee TLB entries populated while running L1 are tagged
> differently than TLB entries populated while running L2.
> The last condition can only occur if either L0 use EPT or
> L0 use different VPID for L1 and L2
> (i.e. vmx->vpid !=3D vmx->nested.vpid02).
>=20
> If L0 use EPT, L0 use different EPTP when running L2 than L1
> (Because guest_mode is part of mmu-role) and therefore SDM section
> 28.3.3.4 doesn't apply. Otherwise, L0 use different VPID when
> running L2 than L1 and therefore SDM section 28.3.3.3 doesn't
> apply.

I don't understand this.  You could still have a stale EPTP entry from a
previous L2 vmenter.   If L1 uses neither EPT nor VPID, it expects a TLB
flush to occur on every vmentry, but this won't happen if L0 uses EPT.

Paolo

