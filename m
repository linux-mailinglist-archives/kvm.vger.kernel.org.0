Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1721554A7
	for <lists+kvm@lfdr.de>; Fri,  7 Feb 2020 10:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgBGJ3V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Feb 2020 04:29:21 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:44728 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726619AbgBGJ3V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Feb 2020 04:29:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581067760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iOOYHtkvRPysCVjAW2MS9yml97iZ6MtUp4OwxVIj6eU=;
        b=PXtvKLxvyqyQGQB953weifZNzcvVjPFdC3OWx2soJYgfRZEMf/4W6menjLKoIuERGJlCpN
        FP1Scz3hOcWSaa2X1MTwUGpAp3kw6Dmk12Nxg+YHfReah1ez5WjhGkVHdYQmgk6kYBJbic
        fDCXkCWISHX2Xb2a3xibqTxN+L5ff28=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-GGwjmHBkNUeDk7jIeWUJTQ-1; Fri, 07 Feb 2020 04:29:19 -0500
X-MC-Unique: GGwjmHBkNUeDk7jIeWUJTQ-1
Received: by mail-wr1-f71.google.com with SMTP id w6so943973wrm.16
        for <kvm@vger.kernel.org>; Fri, 07 Feb 2020 01:29:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=iOOYHtkvRPysCVjAW2MS9yml97iZ6MtUp4OwxVIj6eU=;
        b=KxUhfVNnCvHew5QRt06HT9zD3FNAvxlcMCuB/Cnajz1JKJGcDjVUY7wvuNgklH9Tb7
         yyfsbjyZBrbwZdZ6BmNz4vGx+HYQdK4WiG5g7vU7ChQQzTBeg77Ak4S0+GKiaPrn7DAN
         FHAgSbXGsJZza6iueOeaikCprauPhMW7ca0dzoF/dZEzWdO/iYrVn99TrvH5zEK+bFIt
         BN7Q9qEYngVojAk/tKXr7d6TeamFHy+XstC9FnfhmOIPY972BFjcrnOkUDqjbi2RBaS+
         kHlgXERs/pTdyWj03PwaTafr3kZ/1g82sHrnYpeM+zwir8vKI970U9PZvI9hss0/7bOT
         RQNA==
X-Gm-Message-State: APjAAAUZBgs5kC7AUUmBquAQfFfIFGkTFIYDnQe01tsEPpwlsV3lXTn0
        n9c5774/wVmILeQdG7IpmMMUkeCAb6Bk5qRruMyQp0rORZI0g8kux7z7AUPadfkMxhUXe7VR1GT
        2GiMRoeYhptTq
X-Received: by 2002:adf:b193:: with SMTP id q19mr3640674wra.78.1581067757766;
        Fri, 07 Feb 2020 01:29:17 -0800 (PST)
X-Google-Smtp-Source: APXvYqx52CMjinFmLJOvrK2em63PNSJWTz7pU6FQlu7AlGQ+F6sZ8fFrI8mL3eJCa7Fib456Wxes2A==
X-Received: by 2002:adf:b193:: with SMTP id q19mr3640645wra.78.1581067757491;
        Fri, 07 Feb 2020 01:29:17 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id u4sm2599245wrt.37.2020.02.07.01.29.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Feb 2020 01:29:16 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Avoid retpoline on ->page_fault() with TDP
In-Reply-To: <20200206221434.23790-1-sean.j.christopherson@intel.com>
References: <20200206221434.23790-1-sean.j.christopherson@intel.com>
Date:   Fri, 07 Feb 2020 10:29:16 +0100
Message-ID: <878sleg2z7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sean Christopherson <sean.j.christopherson@intel.com> writes:

> Wrap calls to ->page_fault() with a small shim to directly invoke the
> TDP fault handler when the kernel is using retpolines and TDP is being
> used.  Denote the TDP fault handler by nullifying mmu->page_fault, and
> annotate the TDP path as likely to coerce the compiler into preferring
> the TDP path.
>
> Rename tdp_page_fault() to kvm_tdp_page_fault() as it's exposed outside
> of mmu.c to allow inlining the shim.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---

Out of pure curiosity, if we do something like

if (vcpu->arch.mmu->page_fault == tdp_page_fault)
    tdp_page_fault(...)
else if (vcpu->arch.mmu->page_fault == nonpaging_page_fault)
   nonpaging_page_fault(...)
...

we also defeat the retpoline, right? Should we use this technique
... everywhere? :-)

-- 
Vitaly

