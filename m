Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDFA3E050C
	for <lists+kvm@lfdr.de>; Wed,  4 Aug 2021 17:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239570AbhHDP7O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Aug 2021 11:59:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22635 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239291AbhHDP7O (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 4 Aug 2021 11:59:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628092740;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IBbl1Amo90R+k1Y+bblCXqnRdgEv8aSsZacu36H7zns=;
        b=BEPxMC4NJM9/o/smqaii6COSHLmku41u8C1xxl3thV/bSG1Om2eheyvGipxINEDBHKJXl1
        L6ekwsI3yzZ10KDtycdiGsSbpOoz2x7WKkg94zDTSuRwblKA0aNdAFAyLs73CNcV8ih+aF
        KXNgWLdQz0crdNJ2OM89X30aN5F1gV8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-102-Cgp894l8MKCvSUns9vOvfQ-1; Wed, 04 Aug 2021 11:58:59 -0400
X-MC-Unique: Cgp894l8MKCvSUns9vOvfQ-1
Received: by mail-wm1-f71.google.com with SMTP id f10-20020a7bcc0a0000b0290229a389ceb2so2061338wmh.0
        for <kvm@vger.kernel.org>; Wed, 04 Aug 2021 08:58:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=IBbl1Amo90R+k1Y+bblCXqnRdgEv8aSsZacu36H7zns=;
        b=I31mKL782hwKmvRnqnuEhjX4UFhs1rMIw9PQoLoOfyKsQwPMFHm2CkCE182WiYZOa+
         QjcDsZHVEDcUT90UFFFGao1+EIJ1E967gyQrle6UYiICNOphpCIYWM48naxiFGcBg5ie
         P7YRTI9IBeG2BXjb09YlLT4gPpCIqaLFHbZ0QakWEQmQPXa70PX2+Pc8Do5ncNI5nDzL
         ZW1RTwF1Qbedlpw1y1jDb0faIJ8Z1F10tzq2pibFpzYh3AQKloyNlGisE2/Qd80g/aDy
         fvEYZiriKvGvBIOy/U58aP7SwblvwdYwZPPhbmZnVkqouoZ9bC6UQMT94Cx35yu+ylS7
         9+ZQ==
X-Gm-Message-State: AOAM533Q3NdfkUTcYNczMjZrdOUtxn21uNZrABLeYLFrZEonLAWzPeOv
        kXeTAkxalQ8/liD8lQe6Lh2sPy4yCLJKUD3t7AY2EHmCqX0aK0bNF08PC0PaylBAktGILjpoGNu
        w0odMoo1GRViw
X-Received: by 2002:a1c:7907:: with SMTP id l7mr10485263wme.87.1628092737253;
        Wed, 04 Aug 2021 08:58:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJydjiCPwcEOXpPhsukO54NtljI5cRc4RO8AwleIPX3kGu7GjIlDGeegxMgpcbd6fiL11eq7GQ==
X-Received: by 2002:a1c:7907:: with SMTP id l7mr10485249wme.87.1628092737067;
        Wed, 04 Aug 2021 08:58:57 -0700 (PDT)
Received: from work-vm (cpc109021-salf6-2-0-cust453.10-2.cable.virginm.net. [82.29.237.198])
        by smtp.gmail.com with ESMTPSA id p10sm5965958wme.30.2021.08.04.08.58.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 08:58:56 -0700 (PDT)
Date:   Wed, 4 Aug 2021 16:58:54 +0100
From:   "Dr. David Alan Gilbert" <dgilbert@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: Possible minor CPU bug on Zen2 in regard to using very high GPA
 in a VM
Message-ID: <YQq5PmDeZpAcLr6J@work-vm>
References: <f8071f73869de34961ea1a35177fc778bb99d4b7.camel@redhat.com>
 <YQq1SVV9DKaZDhLp@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YQq1SVV9DKaZDhLp@google.com>
User-Agent: Mutt/2.0.7 (2021-05-04)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Sean Christopherson (seanjc@google.com) wrote:
> On Wed, Aug 04, 2021, Maxim Levitsky wrote:
> > Hi!
> >  
> > I recently triaged a series of failures that I am seeing on both of my AMD machines in the kvm selftests.
> > 
> > One test failed due to a trivial typo, to which I had sent a fix, but most of the other tests failed
> > due to what I now suspect to be a very minor but still a CPU bug.
> >  
> > All of the failing tests except two tests that timeout (and I haven't yet triaged them),
> > use the perf_test_util.c library.
> > All of these fail with SHUTDOWN exit reason.
> > 
> > After a relatively recent commit ef4c9f4f6546 ("KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()"),
> > vm_get_max_gfn() was fixed to return the maximum GFN that the guest can use.
> > For default VM type this value is obtained from 'vm->pa_bit's which is in turn obtained
> > from guest's cpuid in kvm_get_cpu_address_width function.
> >  
> > It is 48 on both my AMD machines (3970X and 4650U) and also on remote EPYC 7302P machine.
> > (all of them are Zen2 machines)
> >  
> > My 3970X has SME enabled by BIOS, while my 4650U doesn't have it enabled.
> > The 7302P also has SME enabled.
> > SEV was obviously not enabled for the test.
> > NPT was enabled.
> >  
> > It appears that if the guest uses any GPA above 0xFFFCFFFFF000 in its guest paging tables, 
> > then it gets #PF with reserved bits error code.
> 
> LOL, I encountered this joy a few weeks back.  There's a magic Hyper-Transport
> region at the top of memory that is reserved, even for GPAs.  You and I say
> "CPU BUG!!!", AMD says "working as intended" ;-)
> 
> https://lkml.kernel.org/r/20210625020354.431829-2-seanjc@google.com

Hmm, it might be nice if in one of the AMD manuals there was a list of
all address spaces and for each one, a list of things we should expect
to be surprised by.

Dave

-- 
Dr. David Alan Gilbert / dgilbert@redhat.com / Manchester, UK

