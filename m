Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B351945629C
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 19:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhKRSnw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 13:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhKRSnw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 13:43:52 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236B6C06173E
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:40:52 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id b11so5995018pld.12
        for <kvm@vger.kernel.org>; Thu, 18 Nov 2021 10:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=grrMnij3a2kLK2nD9/+zi8H0lxQV5j7EQVRD7AIwS2E=;
        b=DnjI9osT+moWRQdwwunhhgYe2YGuzWKrQy5JwjvEJNUqQcpvnb0WoX5Pei6uXI5OdC
         7eGLhv3YIzk62P6sC5D7JBPnUohj6O7s664U/+jqNIv857J2ijyYc9lxkutY0si+1Jso
         ztfH/9rMsVdRRal+62dCEzvALKr3rtl5XahGBeHA8m4ynGczBHkUGlN7RYWuUfQGcFke
         WSfMnan0Kg6M9yWEVCFKWFu1Oy/he0ioyfZD1myK/YDRWIUpBN/5hc73yoNPRxPOyT9C
         VLzYMyPNfdN9orn15Wn6MlOWGc4Qs8aD/O0pRMiPP4mF4KE17PRSHz5sCFRZguQ3AWZA
         KcTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=grrMnij3a2kLK2nD9/+zi8H0lxQV5j7EQVRD7AIwS2E=;
        b=1wpocJLqfDl+6DRCW2mNAQIeM/9zfjGM+DnzMKGyGBqxpjKFG87CLpl9qe7cDPIO19
         7gGaaLQjbQFVJWyg+XpN7jugcJTGEqhxBPSpVCDM2vN+TvVOvqHUd9YvrjLfcAAicxVL
         m+uLkAFzsqJL6+4QTyaFeA+ek9Rpc/4HEFUtd7QmlH7AwYDJDdfxsHMPfQTBziXG8x2e
         v5b/nzHvamFDJvJXlx/e4CGSLlIio274StUNlYPkragkqYmax9J3KYnjZa05plEH9T9Y
         tJJz2nxiyS9AQluxXdeRpeUAxSCz5r2Hii49GqWS7kSF7Fwe9wdtentlba/WrNZPwEt4
         IZRg==
X-Gm-Message-State: AOAM533hZr0/V7oL4m35PSZMO0StXYSHcjT5fbDXuav/0x6HzH3BgR5R
        NcnDuoXrmiOxl2lb9g+RqAMoMQ==
X-Google-Smtp-Source: ABdhPJxTT+sS2hBA2CisuiyQO1bWgOM4L3odX2TF09Y4yJcQHjhUg5+FNsR41T/1dQnqfraxxzIiPQ==
X-Received: by 2002:a17:90a:af94:: with SMTP id w20mr12506911pjq.223.1637260851435;
        Thu, 18 Nov 2021 10:40:51 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a12sm8600266pjq.16.2021.11.18.10.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:40:50 -0800 (PST)
Date:   Thu, 18 Nov 2021 18:40:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        "jmattson @ google . com" <jmattson@google.com>,
        "wanpengli @ tencent . com" <wanpengli@tencent.com>,
        "vkuznets @ redhat . com" <vkuznets@redhat.com>,
        "mtosatti @ redhat . com" <mtosatti@redhat.com>,
        "joro @ 8bytes . org" <joro@8bytes.org>, karahmed@amazon.com,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anup Patel <anup.patel@wdc.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        kvm-riscv@lists.infradead.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 08/12] KVM: Propagate vcpu explicitly to
 mark_page_dirty_in_slot()
Message-ID: <YZaeL5YztL3p1nLM@google.com>
References: <20211117174003.297096-1-dwmw2@infradead.org>
 <20211117174003.297096-9-dwmw2@infradead.org>
 <85d9fec17f32c3eb9e100e56b91af050.squirrel@twosheds.infradead.org>
 <4c48546b-eb4a-dff7-cc38-5df54f73f5d4@redhat.com>
 <20b5952e76c54a3a5dfe5a898e3b835404ac6fb1.camel@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20b5952e76c54a3a5dfe5a898e3b835404ac6fb1.camel@infradead.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021, David Woodhouse wrote:
> That leaves the one in TDP MMU handle_changed_spte_dirty_log() which
> AFAICT can trigger the same crash seen by butt3rflyh4ck — can't that
> happen from a thread where kvm_get_running_vcpu() is NULL too? For that
> one I'm not sure.

I think could be trigger in the TDP MMU via kvm_mmu_notifier_release()
-> kvm_mmu_zap_all(), e.g. if the userspace VMM exits while dirty logging is
enabled.  That should be easy to (dis)prove via a selftest.

And for the record :-)

On Mon, Dec 02, 2019 at 12:10:36PM -0800, Sean Christopherson wrote:
> IMO, adding kvm_get_running_vcpu() is a hack that is just asking for future
> abuse and the vcpu/vm/as_id interactions in mark_page_dirty_in_ring()
> look extremely fragile.

On 03/12/19 20:01, Sean Christopherson wrote:
> In case it was clear, I strongly dislike adding kvm_get_running_vcpu().
> IMO, it's a unnecessary hack.  The proper change to ensure a valid vCPU is
> seen by mark_page_dirty_in_ring() when there is a current vCPU is to
> plumb the vCPU down through the various call stacks.
