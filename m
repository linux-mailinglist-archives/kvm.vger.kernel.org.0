Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E595137EBD0
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 00:23:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244590AbhELTh7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 15:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238033AbhELSUu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 14:20:50 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A269C06138B
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 11:19:20 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id x188so19158978pfd.7
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 11:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=fS0mMcts/E8IIj4gW57Ss++TBSsYalzhdwWI/2ggkwU=;
        b=tgKLtlrfzUhUujo3RCHwzYT9wgoRlv1p1+Zd5L3GqDZlfBrYefsgbF2clCUVRjNq7L
         98IpPUYG5WhtBe5q9IurPZ6NxksdASM7dlXLB0SXJhfQkOaitZVlG35Ql+xnMB4cp1Ax
         HbxtI7CYObaD3bNriubWH90KRpJ6muSADr8AqiCWffxF1eb6JH4yVJKVZjNXsyoIFl1q
         3shktnBwgaAsjSTj7acaOHybUW8hUgIlRk44ItC32gLIlf57CFH71VBgTBFvf9li8TuA
         HS/DucL9XB4Ma9rOe7D/lkrLJ0Dpp7Sb0bPtngG5v873rqvmaCuMgc5pCXDNKNNgimba
         GsaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=fS0mMcts/E8IIj4gW57Ss++TBSsYalzhdwWI/2ggkwU=;
        b=tCHlUhL1BsHwunat4AqFKaK1CIAZOuq7TVXE6WiGhIxFWjrDqZODS2v3ywqKTRyWiM
         A1XrcUbxLBevHdf4IdwTm3+S/m5bcfRa/Kfl27f1vlaIIK1KlyrMiSocbTL50EpVghKJ
         e4OPx7kKAeYV4Y6ptqQUO7WfUFMgd3Ui51yKMwLR3WJIlpIreR5yB7y3LV/sJH873Quc
         igsQ80l146Yl6R4CQQLfP7Dn3nPkGSGVUagio8uesLD2bXAyYTYgAdlPnoH2v3lNRIdv
         6ZC442ggrgYheeGWXDi/Vclfj8y5N7qJ0ww398dF2Bp9TvRO5QvnA5U59ZHqQ3ohA1v5
         AxVQ==
X-Gm-Message-State: AOAM531e3CNqjqIKCYy1j8z1CwgtVLfWlSLCgvK1eUcCBiYU/asFgLkm
        5netKOETAlm+PzETCJM2MMuSzw==
X-Google-Smtp-Source: ABdhPJxZEGuJVcCMmSyaGF079OcscxPB7VYzw19DJlsaNbCjiasnq4m4eSEAyfmL7tXUl+W7rrL9xg==
X-Received: by 2002:a63:4145:: with SMTP id o66mr14611568pga.4.1620843560013;
        Wed, 12 May 2021 11:19:20 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id c23sm437160pgj.50.2021.05.12.11.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 11:19:19 -0700 (PDT)
Date:   Wed, 12 May 2021 18:19:15 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     Jim Mattson <jmattson@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/3] KVM: nVMX: Add a new VCPU statistic to show if VCPU
 is running nested guest
Message-ID: <YJwcI+X5ToPleBh8@google.com>
References: <20210512014759.55556-1-krish.sadhukhan@oracle.com>
 <20210512014759.55556-3-krish.sadhukhan@oracle.com>
 <CALMp9eTCgEG=kkQTn+g=DqniLq+RRmzp7jeK_iexoq++qiraxQ@mail.gmail.com>
 <c5c4a9d2-73b5-69eb-58ee-c52df4c2ff18@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c5c4a9d2-73b5-69eb-58ee-c52df4c2ff18@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 12, 2021, Krish Sadhukhan wrote:
> 
> On 5/12/21 9:01 AM, Jim Mattson wrote:
> > On Tue, May 11, 2021 at 7:37 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> > > Add the following per-VCPU statistic to KVM debugfs to show if a given
> > > VCPU is running a nested guest:
> > > 
> > >          nested_guest_running
> > > 
> > > Also add this as a per-VM statistic to KVM debugfs to show the total number
> > > of VCPUs running a nested guest in a given VM.
> > > 
> > > Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
> > This is fine, but I don't really see its usefulness. OTOH, one
> 
> Two potential uses:
> 
>     1. If Live Migration of L2 guests is broken/buggy, this can be used to
> determine a safer time to trigger Live Migration of L1 guests.

This seems tenuous.  The stats are inherently racy, so userspace would still need
to check for "guest mode" after retrieving state.  And wouldn't you want to wait
until L1 turns VMX/SVM _off_?  If migrating L2 is broken, simply waiting until L2
exits likely isn't going to help all that much.

>     2. This can be used to create a time-graph of the load of L1 and L2 in a
> given VM as well across the host.

Hrm, I like the idea of being able to observe how much time a vCPU is spending
in L1 vs. L2, but cross-referencing guest time with "in L2" seems difficult
and error prone.  I wonder if we can do better, i.e. explicitly track L1 vs. L2+
usage.  I think that would also grant Jim's wish of being able to more precisely
track nested virtualization utilization.

> > statistic I would really like to see is how many vCPUs have *ever* run
> > a nested guest.
