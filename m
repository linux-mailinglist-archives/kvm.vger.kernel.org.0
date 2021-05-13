Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69BE37F556
	for <lists+kvm@lfdr.de>; Thu, 13 May 2021 12:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhEMKIK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 May 2021 06:08:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20384 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231521AbhEMKHu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 May 2021 06:07:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620900400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=RMOsz2t/mRlUyOAJdwbfXrYTXX+qDedCv5t5vQJhcyI=;
        b=KXW+Af2La0izx/tf0VSoa9Ct4tsqpLGzY7FJm7JMWLYybtxeo60gYZpftWnJDMo5SFAbL8
        Aab0+O5YouKbg29f1eKRVYM8ciAVFq4kz/wThraAYX9TkkYGnZ1EEW2nJQwcAkfb49BPrq
        L/aHlZWD+7gWHnqU2Wo2S4HfYTMZg4M=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-ZkILQSZVPz67Qrb_WYu49w-1; Thu, 13 May 2021 06:06:38 -0400
X-MC-Unique: ZkILQSZVPz67Qrb_WYu49w-1
Received: by mail-ed1-f72.google.com with SMTP id i17-20020a50fc110000b0290387c230e257so14369970edr.0
        for <kvm@vger.kernel.org>; Thu, 13 May 2021 03:06:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RMOsz2t/mRlUyOAJdwbfXrYTXX+qDedCv5t5vQJhcyI=;
        b=e0AdpFZmjI1lXLzew4DUfo69kI66ZnYkKQxaNyraiRtq/E5MPv1u5Qhoo6tNBTd064
         luUqWdiP3FtJGOAEbfpQzHNurSN93uNSm4k5j13EncN0jkq8T+wrQ9AzXFGBew2Kqud9
         d7vEgSTxjU9MQVIxTTb72fce/tKekd0lXIueaaPICG/Et9bflJO2rrdT4qCNyP92l+fK
         oxYl/W+uj3MnChRm8DbRPEPVapt7bQnmd3hqojBmyOwCw6ci4sgN0V2tmJnFKYHrYqlz
         Ns2Dhiru9NLDT9kcDj1pWElkOYyLse7qV1xePBHk/RvwjhB7ajw7ZbXe8Hq/ZRv+Tblr
         w4ew==
X-Gm-Message-State: AOAM532z1OC/YSCRPteQ65kKxjXUpC7IJhJkVht+EwjuVn36IwQEKyTm
        SmxC51bDzMmR02/3Xc472lHmJojXTLfCGpcQdn7+WQhEnZgcRcDKW3Cxiyb8/n+LfJC6QJXyMdU
        DCQ1AJcyCWd0S
X-Received: by 2002:a17:906:3c4e:: with SMTP id i14mr42248967ejg.245.1620900397738;
        Thu, 13 May 2021 03:06:37 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3O4iQxlXCi1GllQpwvPabgCL7TvJbTYdKwTmeguDJMTth5gmakaI+PntWstKbRROM1jebww==
X-Received: by 2002:a17:906:3c4e:: with SMTP id i14mr42248945ejg.245.1620900397520;
        Thu, 13 May 2021 03:06:37 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id h8sm1512799ejb.104.2021.05.13.03.06.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 03:06:37 -0700 (PDT)
Date:   Thu, 13 May 2021 12:06:30 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, nikos.nikoleris@arm.com,
        andre.przywara@arm.com, eric.auger@redhat.com
Subject: Re: [PATCH kvm-unit-tests v3 8/8] arm/arm64: psci: Don't assume
 method is hvc
Message-ID: <20210513100630.sjlflypkc54wa66k@gator>
References: <20210429164130.405198-1-drjones@redhat.com>
 <20210429164130.405198-9-drjones@redhat.com>
 <3dd4b8f6-612d-e0c0-f5b5-d8a380213a1d@arm.com>
 <20210513070857.z22utxgp3vooar7u@gator>
 <6c800117-9a08-2b97-f938-85e10809196b@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c800117-9a08-2b97-f938-85e10809196b@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 13, 2021 at 10:08:09AM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 5/13/21 8:08 AM, Andrew Jones wrote:
> > On Wed, May 12, 2021 at 05:14:24PM +0100, Alexandru Elisei wrote:
> >> Hi Drew,
> >>
> >> On 4/29/21 5:41 PM, Andrew Jones wrote:
> >>> The method can be smc in addition to hvc, and it will be when running
> >>> on bare metal. Additionally, we move the invocations to assembly so
> >>> we don't have to rely on compiler assumptions. We also fix the
> >>> prototype of psci_invoke. It should return long, not int, and
> >>> function_id should be an unsigned int, not an unsigned long.
> >> Sorry to harp on this again, but to be honest, it's still not clear to me why the
> >> psci_invoke_{hvc,smc} functions return a long int.
> >>
> >> If we only expect the PSCI functions to return error codes, then the PSCI spec
> >> says these are 32-bit signed integers. If we want to support PSCI functions
> >> returning other values, like PSCI_STAT_{RESIDENCY,COUNT}, then the invoke
> >> functions should return an unsigned value.
> >>
> >> The only case we're supporting is the error return for the SMC calling convention
> >> (which says that error codes are 32/64bit signed integers).
> > psci_invoke_{hvc,smc} should implement the SMC calling convention, since
> > they're just wrapping the smc/hvc call. PSCI calls that build on that,
> > e.g. psci_cpu_on, can define their own return type and then translate
> > the signed long returned by SMC into, e.g. 32-bit signed integers. Indeed
> > that's what psci_cpu_on does.
> >
> > I would write something like that in the commit message or rename
> > psci_invoke to smc_invoke.
> 
> I agree that psci_invoke_* use the SMC calling convention, but we're not
> implementing *all* the features of the SMC calling convention, because SMCCC can
> return more than one result in registers r0-r3. In my opinion, I think the easiest
> solution and the most consistent with both specifications would be to keep the
> current names and change the return value either to an int, and put a comment
> saying that we only support PSCI functions that return an error, either to a long
> unsigned int, meaning that we support *all* PSCI functions as defined in ARM DEN
> 0022D.
> 
> What do you think? Does that make sense?
>

OK, I'll change it back to an int return for psci_invoke and remove the
sentences in the commit message about it. I won't write any new comments
though, because I'd actually rather reduce the common PSCI code, than
to try and ensure we support it completely. We should do as little PSCI
in lib/arm* as possible. The psci unit test (arm/psci.c) is the one that
should worry the most about the specifications, and it should actually
define its own interfaces in order to inspect all bits, including the ones
that aren't supposed to be used, when it does its tests.

Thanks,
drew

