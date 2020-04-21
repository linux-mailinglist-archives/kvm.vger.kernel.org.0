Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CE81B24DD
	for <lists+kvm@lfdr.de>; Tue, 21 Apr 2020 13:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728742AbgDULS4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Apr 2020 07:18:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46402 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbgDULSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Apr 2020 07:18:55 -0400
Received: by mail-wr1-f67.google.com with SMTP id f13so15997002wrm.13;
        Tue, 21 Apr 2020 04:18:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qCp5DNb4ZAvkPCOozDe5/doN7bHhlCVyg+LRZHqfBt8=;
        b=MPFNMoVkMg3TIaujF4XS/o2YH9roY53WCekKz3grzMfZg0W0bV4TGfHysOtlXy6Pi+
         gq+AgdTTj6MxILkMCTehDUPHjKqo/gr2D9GpUGY4WwoJOmziolIMZ3ss/z4QeE3VMxKO
         3VNajf/qfKXQkCCVW3qCnUqFgTjIfznO1gsmlUW1UQNRtTOTCx1sT+ngDUr5uCP7VLqz
         Y/kTCUxghhmBVk6EyRz49EYCO2WA2W9M+uGKBMhYuAOmzO6zPSRP1MNajANqxvTj0GJt
         qhsou9Sb/eAPb/ktKjiuYqTyA/HXe2E/M7iKSMfM7mgIOqXQcO1qY0jyEN8b5hKe8u/I
         F4Kg==
X-Gm-Message-State: AGi0PuYKUJRYEs6KC8zVJW//ffJoZQMk4WV3j6O6WAs7r/hNx2V2mepq
        nMRVW3uo7Ub/71cCj4N/RB0=
X-Google-Smtp-Source: APiQypKd0QYEZFmZZJ1Im1slvn1183fIeoEwlakzdaqUJ5LLdo23VbLSi80Qo3Tmr8OyDNizUxyHEg==
X-Received: by 2002:a5d:460b:: with SMTP id t11mr23312849wrq.319.1587467933712;
        Tue, 21 Apr 2020 04:18:53 -0700 (PDT)
Received: from debian (44.142.6.51.dyn.plus.net. [51.6.142.44])
        by smtp.gmail.com with ESMTPSA id p190sm3026171wmp.38.2020.04.21.04.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 04:18:53 -0700 (PDT)
Date:   Tue, 21 Apr 2020 12:18:51 +0100
From:   Wei Liu <wei.liu@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wei Liu <wei.liu@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org
Subject: Re: [PATCH 1/4] KVM: x86: hyperv: Remove duplicate definitions of
 Reference TSC Page
Message-ID: <20200421111851.3zi7lzic62nfdgh5@debian>
References: <20200420173838.24672-1-mikelley@microsoft.com>
 <20200420173838.24672-2-mikelley@microsoft.com>
 <20200421092925.rxb72yep4paruvi6@debian>
 <6c2bae31-14a8-39cf-6e6d-139d84146477@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c2bae31-14a8-39cf-6e6d-139d84146477@redhat.com>
User-Agent: NeoMutt/20180716
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 21, 2020 at 01:16:42PM +0200, Paolo Bonzini wrote:
> On 21/04/20 11:29, Wei Liu wrote:
> > On Mon, Apr 20, 2020 at 10:38:35AM -0700, Michael Kelley wrote:
> >> The Hyper-V Reference TSC Page structure is defined twice. struct
> >> ms_hyperv_tsc_page has padding out to a full 4 Kbyte page size. But
> >> the padding is not needed because the declaration includes a union
> >> with HV_HYP_PAGE_SIZE.  KVM uses the second definition, which is
> >> struct _HV_REFERENCE_TSC_PAGE, because it does not have the padding.
> >>
> >> Fix the duplication by removing the padding from ms_hyperv_tsc_page.
> >> Fix up the KVM code to use it. Remove the no longer used struct
> >> _HV_REFERENCE_TSC_PAGE.
> >>
> >> There is no functional change.
> >>
> >> Signed-off-by: Michael Kelley <mikelley@microsoft.com>
> >> ---
> >>  arch/x86/include/asm/hyperv-tlfs.h | 8 --------
> >>  arch/x86/include/asm/kvm_host.h    | 2 +-
> >>  arch/x86/kvm/hyperv.c              | 4 ++--
> > 
> > Paolo, this patch touches KVM code. Let me know how you would like to
> > handle this.
> 
> Just include it, I don't expect conflicts.
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Ack.
