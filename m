Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 300C4153AF3
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2020 23:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727456AbgBEW2h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Feb 2020 17:28:37 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55195 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727106AbgBEW2g (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 5 Feb 2020 17:28:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580941715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xN2n9jkJvkSR0RH/zWMkRvEj2quGdHH6HsawLgUOQOY=;
        b=dZayu8PSLv8/6Ghp/Mvv7c0KUzqbWjN5IIgGibeer+EBeiKqDOlXCaalVEpr6ZHR95R2GI
        VzU86wDDsDrXGyCnKZv+jIJlIvU+xnJCrs0cxrgFbboUOecFaMHeazhhK/Mzufp6KD09Vt
        vg+jgAiZu2w8ckESHO35/pIAhmie0tQ=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-63-TEkUgV6ROnWI1Te2B6wR7w-1; Wed, 05 Feb 2020 17:28:34 -0500
X-MC-Unique: TEkUgV6ROnWI1Te2B6wR7w-1
Received: by mail-qv1-f69.google.com with SMTP id g6so2476391qvp.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2020 14:28:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xN2n9jkJvkSR0RH/zWMkRvEj2quGdHH6HsawLgUOQOY=;
        b=UTX8XJLZ/0yX7n66McEfUjjQh89+VohTQGjaOSy1Z+1EitqtDRmaNTSYQ03xtIMAkk
         CDjEQR7ulTxIFoRmXVrsCDyUdgqV8ak2yfnvuPsAweBt4UkmW/DeRaK05BkHYYHRMweX
         MAcKFjMpj7JgzsmscZLglZBc7CtBqXH4qMZZqMeGQLOU8FylQjhMsJ0rgnYEmVzn4f/P
         VS8QxW6WmX4K9VCn/nyn6zE7vYCpd0rN61g545KNjDxKJTADHBWXWdUht9bI+g7aT7LT
         Qcco2E0lle/4okZ6kkmiCvy6TCNEX5cGHTfrcBBAWCvk7CID8kUx8p1o1Kov8sLN7RJB
         LSlQ==
X-Gm-Message-State: APjAAAUa9Neid/g1zjlmzYA7SqT/nKIC8uc9StKQSe/9c8vG7RQvxZds
        gVDTKovKwM0njPz7HeO0tjXA/euTqPhk59DO583i/bw2iMWbFb/ScIHb6Z5S3FRzjyOgbvauwRQ
        KCL7aYjXbc/QG
X-Received: by 2002:a05:620a:a46:: with SMTP id j6mr13674qka.164.1580941714103;
        Wed, 05 Feb 2020 14:28:34 -0800 (PST)
X-Google-Smtp-Source: APXvYqzgDC/fBZ4GnRbk3BQEXE+eWIhbbieAb4nE+MGEKdPSLikBImrRnbk5qAuaCcwE1K66PslinA==
X-Received: by 2002:a05:620a:a46:: with SMTP id j6mr13650qka.164.1580941713724;
        Wed, 05 Feb 2020 14:28:33 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id c184sm503353qke.118.2020.02.05.14.28.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Feb 2020 14:28:33 -0800 (PST)
Date:   Wed, 5 Feb 2020 17:28:29 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        Christoffer Dall <christoffer.dall@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <f4bug@amsat.org>
Subject: Re: [PATCH v5 03/19] KVM: Don't free new memslot if allocation of
 said memslot fails
Message-ID: <20200205222829.GF387680@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-4-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-4-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:41PM -0800, Sean Christopherson wrote:
> The two implementations of kvm_arch_create_memslot() in x86 and PPC are
> both good citizens and free up all local resources if creation fails.
> Return immediately (via a superfluous goto) instead of calling
> kvm_free_memslot().
> 
> Note, the call to kvm_free_memslot() is effectively an expensive nop in
> this case as there are no resources to be freed.

(I failed to understand why that is expensive.. but the change looks OK)

> 
> No functional change intended.
> 
> Acked-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

