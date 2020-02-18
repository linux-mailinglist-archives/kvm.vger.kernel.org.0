Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2243162B91
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 18:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbgBRRIY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 12:08:24 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:29518 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726411AbgBRRIY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 18 Feb 2020 12:08:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582045703;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bQ24iXtvMkreFZJJl4JQ5Z/nYZE2Ewp8tzNT/yktqgQ=;
        b=MV4B5mgfohb5fIUgI5OghKyEN9nDzfFtJXk1TT2DBr6PShzc9geTM1PxPejgXgRH7od9tz
        +fqEUEOI/GFjhwr/6oDWaNx6pUSgE4JYJeqn8/0Ctj4VeXr+HIe/md64r4X3pQE544D5Cx
        HqiQDOvpS+7otBl7lW6zI0z0aUW1B1g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-250-0joK8r3jPriQuybJF-skiQ-1; Tue, 18 Feb 2020 12:08:22 -0500
X-MC-Unique: 0joK8r3jPriQuybJF-skiQ-1
Received: by mail-wm1-f69.google.com with SMTP id q125so320829wme.1
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 09:08:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bQ24iXtvMkreFZJJl4JQ5Z/nYZE2Ewp8tzNT/yktqgQ=;
        b=MLI5yeT8K3wTw2/7zvZutkEuB+DtFtVmFHvoxvduiXQwQwpNYZab0JY1RXIcI5QsOC
         9imoOC3C2OG4Tz4CY/+sjlBAebDiG2pVfp9ABI2S4XFQLas0ZOEn1RLSVYUe5iTuwdh3
         /EJbk5D2ztp9aI47BY7cUK8+e85Z6iCi59v01kgzI7vUCYtxiKq9ftC+t/aronx3C2h8
         lTV7A2nKeluIgWjrr6d3JXryPmwS3ng7T4R6WkALZYoZR4WkWGPIJ4Sce9qcQhOECXjP
         iOlftTPLJ678y+O7HY+XdCsU+EoH3zsynPDQdPsFqOIiBNjJNTijua5SIYsH3+sFe5Tf
         9zPw==
X-Gm-Message-State: APjAAAU/t8n1XpIFXI+DK9hcczF1pFJPgWdxvfkdhnAYSlnBAiv5Qhu4
        N92i82ZrAUj87qCukvvgO0Eo23krFiiWd7Uj0Rxe83bgFbMw0Ocrcwp2hnn80bDzn4mrOCnb3jY
        xMahUkUAYmy4z
X-Received: by 2002:adf:f744:: with SMTP id z4mr25738797wrp.318.1582045700382;
        Tue, 18 Feb 2020 09:08:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqx4269LzqtF1igS5EeXvERpHG3e2WaJaLsyunGtXgftLoNRPN2kjNmkBgQzhHGcdLTjfzTsYg==
X-Received: by 2002:adf:f744:: with SMTP id z4mr25738770wrp.318.1582045700126;
        Tue, 18 Feb 2020 09:08:20 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id p15sm4075130wma.40.2020.02.18.09.08.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:08:19 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Liran Alon <liran.alon@oracle.com>,
        Roman Kagan <rkagan@virtuozzo.com>, kvm@vger.kernel.org
Subject: Re: [PATCH RFC] target/i386: filter out VMX_PIN_BASED_POSTED_INTR when enabling SynIC
In-Reply-To: <9b4b46c2-e2cf-a3d5-70e4-c8772bf6734f@redhat.com>
References: <20200218144415.94722-1-vkuznets@redhat.com> <9b4b46c2-e2cf-a3d5-70e4-c8772bf6734f@redhat.com>
Date:   Tue, 18 Feb 2020 18:08:18 +0100
Message-ID: <87k14j962l.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> On 18/02/20 15:44, Vitaly Kuznetsov wrote:
>> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
>> ---
>> RFC: This is somewhat similar to eVMCS breakage and it is likely possible
>> to fix this in KVM. I decided to try QEMU first as this is a single
>> control and unlike eVMCS we don't need to keep a list of things to disable.
>
> I think you should disable "virtual-interrupt delivery" instead (which
> in turn requires "process posted interrupts" to be zero).  That is the
> one that is incompatible with AutoEOI interrupts.

I'm fighting the symptoms, not the cause :-) My understanding is that
when SynIC is enabled for CPU0 KVM does

kvm_vcpu_update_apicv()
	vmx_refresh_apicv_exec_ctrl()
		pin_controls_set()

for *all* vCPUs (KVM_REQ_APICV_UPDATE). I'm not sure why
SECONDARY_EXEC_APIC_REGISTER_VIRT/SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY
are not causing problems and only PIN_BASED_POSTED_INTR does as we clear
them all (not very important atm).

>
> The ugly part about fixing this in QEMU is that in theory it would be
> still possible to emulate virtual interrupt delivery and posted
> interrupts, because they operate on a completely disjoint APIC
> configuration than the host's.  I'm not sure we want to go there though,
> so I'm thinking that again a KVM implementation is better.  It
> acknowledges that this is just a limitation (workaround for a bug) in KVM.

The KVM implementation will differ from what we've done to fix eVMCS. We
will either need to keep the controls on (and additionally check
kvm_vcpu_apicv_active() if guest tries to enable them) and again filter
VMX MSR reads from the guest or do the filtering on MSR write from
userspace (filter out the unsupported controls and not fail).

Actually, I'm starting to think it would've been easier to just filter
all VMX MSRs on KVM_SET_MSRS leaving only the supported controls and not
fail the operation. That way we would've fixed both eVMCS and SynIC
issues in a consistent way shifting the responsibility towards
userspace (document that VMX MSRs are 'special' and enabling certain
features may result in changes; if userspace wants to see the actual
state it may issue KVM_GET_MSRS any time) May not be the worst solution
after all...

-- 
Vitaly

