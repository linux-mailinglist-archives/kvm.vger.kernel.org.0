Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A91D919242C
	for <lists+kvm@lfdr.de>; Wed, 25 Mar 2020 10:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbgCYJds (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 05:33:48 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:44612 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727158AbgCYJds (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 25 Mar 2020 05:33:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585128827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FqKcPmzDmL8rF2Z/EiXuHTwdjieWNY5JJ3KzgO/0zPg=;
        b=IuEmDoBcCSJf4i3qXqD5bEP2SC8puZzwnpncjQ/YCwoJoeHILNHjZHjfD6oKR3jS1mQGtX
        VlRqSSdKTekveojnXZVf+HTLoWVLVea5dxXMhRAV/vHJi3KKYHYNyAzGBc8lnwDlQfSR4O
        5BKp8BLNU+igcJrPGPu8U+zNuYrxBq8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-meZ72gZiOYKKz9TRAcN62w-1; Wed, 25 Mar 2020 05:33:45 -0400
X-MC-Unique: meZ72gZiOYKKz9TRAcN62w-1
Received: by mail-wr1-f70.google.com with SMTP id d17so853514wrw.19
        for <kvm@vger.kernel.org>; Wed, 25 Mar 2020 02:33:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=FqKcPmzDmL8rF2Z/EiXuHTwdjieWNY5JJ3KzgO/0zPg=;
        b=r+5UxVS7WSwEK2pObz0NAeUwF9Qtyyiesui0LgkPbg2hNefMgCf4C6nZIeYX9PIMXX
         zIFv/PvDtQdGaHbSNTLzMLrgWLd4+vyiiB5e2vLZyWG8Muw9a+yRfTyQq+XUUcaNdmoN
         6brSNSxLt7/MdWpMWb2zje0BNBYuIzru3mqVSYNWkHhwBddjbQBF42UcqNC9ULCtyb8n
         K7XaIjirfycjA+WlVLZ5xi7voUD4rssniPseCPaXWFCfKnURcFPB85TPWBTJadVRlbGI
         O/CbXYHTA3PFvV5c4g4qiU8k2D9u+lWPasjzQHkwDqR9vKy42uYEX1CZgmcqnJh2ufXX
         lKBw==
X-Gm-Message-State: ANhLgQ3ue7d3glXFrupJgPJ/5izjxTbOxyzWf7nalV9beVTCfikvrXZf
        lzJuYbsu2/t0JDXYeENnrN3HiIPMMqw0ZZiCgNXS6tUyElUarPvq+Hz07el4csFpaPeVm5QMQt8
        WZf6Xz65qVJ11
X-Received: by 2002:a5d:62c9:: with SMTP id o9mr2519038wrv.2.1585128824624;
        Wed, 25 Mar 2020 02:33:44 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvQpW/9fkYnOQqZExpXHTfk1pdnBJ6eo/ok7Y4W/2/lHPQf6KxLZ0Xeuq73xxY9DUlYJgklVg==
X-Received: by 2002:a5d:62c9:: with SMTP id o9mr2519008wrv.2.1585128824381;
        Wed, 25 Mar 2020 02:33:44 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j6sm31648430wrb.4.2020.03.25.02.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 02:33:43 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v3 08/37] KVM: VMX: Skip global INVVPID fallback if vpid==0 in vpid_sync_context()
In-Reply-To: <20200320212833.3507-9-sean.j.christopherson@intel.com>
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-9-sean.j.christopherson@intel.com>
Date:   Wed, 25 Mar 2020 10:33:41 +0100
Message-ID: <877dz87p8q.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Skip the global INVVPID in the unlikely scenario that vpid==0 and the
> SINGLE_CONTEXT variant of INVVPID is unsupported.  If vpid==0, there's
> no need to INVVPID as it's impossible to do VM-Enter with VPID enabled
> and vmcs.VPID==0, i.e. there can't be any TLB entries for the vCPU with
> vpid==0.  The fact that the SINGLE_CONTEXT variant isn't supported is
> irrelevant.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/vmx/ops.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/ops.h b/arch/x86/kvm/vmx/ops.h
> index 45eaedee2ac0..33645a8e5463 100644
> --- a/arch/x86/kvm/vmx/ops.h
> +++ b/arch/x86/kvm/vmx/ops.h
> @@ -285,7 +285,7 @@ static inline void vpid_sync_context(int vpid)
>  {
>  	if (cpu_has_vmx_invvpid_single())
>  		vpid_sync_vcpu_single(vpid);
> -	else
> +	else if (vpid != 0)
>  		vpid_sync_vcpu_global();
>  }

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

(personally, I also prefer 'vpid !=0' to '!vpid', however, nested.c
uses expressions like '&& !vmcs12->virtual_processor_id' instead...)

-- 
Vitaly

