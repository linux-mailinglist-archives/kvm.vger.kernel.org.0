Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD77154EEB
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 23:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbgBFWaI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 17:30:08 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59462 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726509AbgBFWaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 17:30:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581028206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y9cBxEKgtYZ4SHZJ2KCZ291mafsQUmmbyOmTI5C6x9c=;
        b=XtU6R1g1DzR7pDkOvp+BNKtATHbXUm90+/6GQRFQ9uNmo8psreNAsY2ftxMiGhOS92tTCK
        FqguwxiD1MhiFn+CRt1r9PB391onsqLQdmK/iW/zXKIraySs/NP8xsLMIUIcxDY1chJMPP
        8eIvakGDCKnQ+J8Mo6ManhkTvzGnOY8=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-344-q3yPLmLFMk6fxh8HqMYUTw-1; Thu, 06 Feb 2020 17:30:05 -0500
X-MC-Unique: q3yPLmLFMk6fxh8HqMYUTw-1
Received: by mail-qt1-f200.google.com with SMTP id r9so288708qtc.4
        for <kvm@vger.kernel.org>; Thu, 06 Feb 2020 14:30:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y9cBxEKgtYZ4SHZJ2KCZ291mafsQUmmbyOmTI5C6x9c=;
        b=sfagLCAUvaHFHUKJrYUYOw9sHWelUbF1ai6fKwvJMSFq2er793f709fqfH1x3jjSuO
         fo3lph0QFhP9ax7KwG2iJZ+KEE66CofCZr7n/H94yVvMuRCQjl0qKUU36fwkk0vF8as7
         oGpUZ9dA2UCVcBm4hdOVjd8fu/ftR4t9p1psfZNpSiq8v/qv3OsphVAjSimwTCAkCxj8
         MA6aK2EnzgqTbNwsakEPSlEpQR0mlM5LAmfDSB8HaZ5RVCJcr6Xvz/1z/gLloVeIOcM0
         xuN5es+fp2se2L963sVu2g+DKWofy4NoM9UuoQcZNojZJNdJNDNcxAuKVll5iZfjq+In
         sKqA==
X-Gm-Message-State: APjAAAV5yAIC26rfuXSH4S6TxTRA7z/NnGy3dxG31IrlbFe4Pn5QJxM/
        sZHQM2X4aIHwDA5xzZb7XibKYaD5NPtZpEAUIdYLRVo2M4iWAwlv6btVnu/OU7MbCJoAZMvMq8f
        Usj3c3jNWbk06
X-Received: by 2002:a37:7884:: with SMTP id t126mr4700933qkc.288.1581028204604;
        Thu, 06 Feb 2020 14:30:04 -0800 (PST)
X-Google-Smtp-Source: APXvYqzvEhS0XgXcsen5IJpPtTelaoRM0D8F8yYe4NbZxtsmBW+xmvTRWnxA6Vkem/WNxI4KksN37A==
X-Received: by 2002:a37:7884:: with SMTP id t126mr4700901qkc.288.1581028204379;
        Thu, 06 Feb 2020 14:30:04 -0800 (PST)
Received: from xz-x1 ([2607:9880:19c8:32::2])
        by smtp.gmail.com with ESMTPSA id z185sm352349qkb.116.2020.02.06.14.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 14:30:03 -0800 (PST)
Date:   Thu, 6 Feb 2020 17:30:01 -0500
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
Subject: Re: [PATCH v5 19/19] KVM: selftests: Add test for
 KVM_SET_USER_MEMORY_REGION
Message-ID: <20200206223001.GJ700495@xz-x1>
References: <20200121223157.15263-1-sean.j.christopherson@intel.com>
 <20200121223157.15263-20-sean.j.christopherson@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200121223157.15263-20-sean.j.christopherson@intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 02:31:57PM -0800, Sean Christopherson wrote:
> Add a KVM selftest to test moving the base gfn of a userspace memory
> region.  Although the basic concept of moving memory regions is not x86
> specific, the assumptions regarding large pages and MMIO shenanigans
> used to verify the correctness make this x86_64 only for the time being.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

(I'm a bit curious why write 2 first before 1...)

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

