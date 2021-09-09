Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C2E4054B4
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 15:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351171AbhIINB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 09:01:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:24849 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1344530AbhIIMuk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 08:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631191769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/WIIV9R0O9293cVKltmhNKEdIknXhvoAmfpR0+Emkrc=;
        b=QA2TDyvUImPRNeJYKF1PAZE5Qs8XQ5L3etWkHSowvvXidV1sRO/Xhpklgq/fUnxl/y79O6
        c/RwCGwsKXiZavjFO+jNALE5qKiKfsCEeyHXIlu8UbcoxKti84dygC+BuAA3XnN1wNERAK
        7XG6lwMEpxG0s3dkKdL61dtLhP3G3Tc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-476-RXK86191OiuCKwwD61hYYQ-1; Thu, 09 Sep 2021 08:49:28 -0400
X-MC-Unique: RXK86191OiuCKwwD61hYYQ-1
Received: by mail-wm1-f71.google.com with SMTP id n30-20020a05600c3b9e00b002fbbaada5d7so710248wms.7
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 05:49:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/WIIV9R0O9293cVKltmhNKEdIknXhvoAmfpR0+Emkrc=;
        b=M/TMg2M5kYUAx9EbSl1WvktxcTdYmplnSk/dC1POccbVyID3JBtV2wrJmu4U5R1dsN
         LA4NCUkCRi5u/+4RZakDY+NHsH+oDIp1v8V2QGSiEI1EcLi8ZVGK+mqwuv16RxvlZMLW
         xM5FAgFk7tbr/5JF/dh42Ee/FaI1P/ggXFXkSm1x9TRIDQzrXCI/GGTVCAiPMnGB9Wsu
         vulBQqbtTlKs2CSYjWFA+9b6C5QbeCB74HE/2ueNhAzftaOP4KKOdyTH/uRXjqJlUMQR
         c2xX9Z5RqItw8wxZfp1gAFWUuaSZvUCMkVbjrACXt3S0C/6R0a0j3VyYTZ+pbm/s7v4K
         vU4A==
X-Gm-Message-State: AOAM531CiMcjwMjjTb7pLUAtsvhBy8D1LICMWKH94EgfStuhvMg4MWqM
        XoqkNI5u32qZnzkvYAh3IHgqo/z0ZUdcDMLnE0Xgr5wR+FapxbCU53q8Bs6zwObFDcX8omJxFwL
        BTaQ5ttKvtEwA
X-Received: by 2002:a1c:f315:: with SMTP id q21mr2914788wmq.76.1631191767073;
        Thu, 09 Sep 2021 05:49:27 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyhRToFiGZDeV90P9U2++KGI827ZasghlkgDnXG6Np7ns/pBENdzsEK0QomGtIIK6/dnfSjDQ==
X-Received: by 2002:a1c:f315:: with SMTP id q21mr2914753wmq.76.1631191766841;
        Thu, 09 Sep 2021 05:49:26 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id t17sm1658091wra.95.2021.09.09.05.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 05:49:26 -0700 (PDT)
Date:   Thu, 9 Sep 2021 14:49:24 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 3/5] run_tests.sh: Add kvmtool support
Message-ID: <20210909124924.xcuehgluucvs7gb2@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-4-alexandru.elisei@arm.com>
 <20210907101730.trnsig2j4jmhinyu@gator>
 <587a5f8c-cf04-59ec-7e35-4ca6adf87862@arm.com>
 <20210908150912.3d57akqkfux4fahj@gator>
 <56289c06-04ec-1772-6e15-98d02780876d@arm.com>
 <20210908154943.z7d6bhww3pnbaftd@gator>
 <58d25f89-ff19-2dbc-81bc-3224b8baa9fb@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58d25f89-ff19-2dbc-81bc-3224b8baa9fb@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 09, 2021 at 12:33:11PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 9/8/21 4:49 PM, Andrew Jones wrote:
> > On Wed, Sep 08, 2021 at 04:46:19PM +0100, Alexandru Elisei wrote:
> >> Hi Drew,
> >>
> >> On 9/8/21 4:09 PM, Andrew Jones wrote:
> >>> On Wed, Sep 08, 2021 at 03:33:19PM +0100, Alexandru Elisei wrote:
> >>> ...
> >>>>>> +fixup_kvmtool_opts()
> >>>>>> +{
> >>>>>> +    local opts=$1
> >>>>>> +    local groups=$2
> >>>>>> +    local gic
> >>>>>> +    local gic_version
> >>>>>> +
> >>>>>> +    if find_word "pmu" $groups; then
> >>>>>> +        opts+=" --pmu"
> >>>>>> +    fi
> >>>>>> +
> >>>>>> +    if find_word "its" $groups; then
> >>>>>> +        gic_version=3
> >>>>>> +        gic="gicv3-its"
> >>>>>> +    elif [[ "$opts" =~ -machine\ *gic-version=(2|3) ]]; then
> >>>>>> +        gic_version="${BASH_REMATCH[1]}"
> >>>>>> +        gic="gicv$gic_version"
> >>>>>> +    fi
> >>>>>> +
> >>>>>> +    if [ -n "$gic" ]; then
> >>>>>> +        opts=${opts/-machine gic-version=$gic_version/}
> >>>>>> +        opts+=" --irqchip=$gic"
> >>>>>> +    fi
> >>>>>> +
> >>>>>> +    opts=${opts/-append/--params}
> >>>>>> +
> >>>>>> +    echo "$opts"
> >>>>>> +}
> >>>>> Hmm, I don't think we want to write a QEMU parameter translator for
> >>>>> all other VMMs, and all other VMM architectures, that we want to
> >>>>> support. I think we should add new "extra_params" variables to the
> >>>>> unittest configuration instead, e.g. "kvmtool_params", where the
> >>>>> extra parameters can be listed correctly and explicitly. While at
> >>>>> it, I would create an alias for "extra_params", which would be
> >>>>> "qemu_params" allowing unittests that support more than one VMM
> >>>>> to clearly show what's what.
> >>>> I agree, this is a much better idea than a parameter translator. Using a dedicated
> >>>> variable in unittests.cfg will make it easier for new tests to get support for all
> >>>> VMMs (for example, writing a list of parameters in unittests.cfg should be easier
> >>>> than digging through the scripts to figure exactly how and where to add a
> >>>> translation for a new parameter), and it allow us to express parameters for other
> >>>> VMMs which don't have a direct correspondent in qemu.
> >>>>
> >>>> By creating an alias, do you mean replacing extra_params with qemu_params in
> >>>> arm/unittests.cfg? Or something else?
> >>> Probably something like this
> >>>
> >>> diff --git a/scripts/common.bash b/scripts/common.bash
> >>> index 7b983f7d6dd6..e5119ff216e5 100644
> >>> --- a/scripts/common.bash
> >>> +++ b/scripts/common.bash
> >>> @@ -37,7 +37,12 @@ function for_each_unittest()
> >>>                 elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
> >>>                         smp=${BASH_REMATCH[1]}
> >>>                 elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
> >>> -                       opts=${BASH_REMATCH[1]}
> >>> +               elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
> >>> +                       qemu_opts=${BASH_REMATCH[1]}
> >>> +               elif [[ $line =~ ^qemu_params\ *=\ *(.*)$ ]]; then
> >>> +                       qemu_opts=${BASH_REMATCH[1]}
> >>> +               elif [[ $line =~ ^kvmtool_params\ *=\ *(.*)$ ]]; then
> >>> +                       kvmtool_opts=${BASH_REMATCH[1]}
> >>>                 elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
> >>>                         groups=${BASH_REMATCH[1]}
> >>>                 elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
> >>>
> >>> and all other changes needed to support the s/opts/qemu_opts/ change
> >>> should work. Also, an addition to the unittests.cfg documentation.
> >> Got it, replace extra_opts with qemu_opts in the scripts.
> >>
> >> Yes, the documentation for unittests.cfg (at the top of the file) should
> >> definitely be updated to document the new configuration option, kvmtool_params.
> >>
> >>> The above diff doesn't consider that a unittests.cfg file could have
> >>> both an 'extra_params' and a 'qemu_params' field, but I'm not sure
> >>> we care about that. Users should read the documentation and we
> >>> should review changes to the committed unittests.cfg files to avoid
> >>> that.
> >> What do you feel about renaming extra_params -> qemu_params in unittests.cfg?
> > Yes, that's what I would expect the patch to do.
> >
> >> I'm
> >> thinking it would make the usage clearer, improve consistency (we would have
> >> qemu_params and kvmtool_params, instead of extra_params and kvmtool_params), and
> >> remove any confusions regarding when they are used (I can see someone thinking
> >> that extra_params are used all the time, and are appended to kvmtool_params when
> >> --target=kvmtool). On the other hand, this could be problematic for people using
> >> out-of-tree scripts that parse the unittest.cfg file for whatever reason (are
> >> there people that do that?).
> > I'm not as worried about that as about people using out-of-tree
> > unittests.cfg files that will break when the 'extra_params' field
> > disappears. That's why I suggested to make 'extra_params' an alias.
> 
> I'm sorry, but I'm still having trouble parsing what alias means in this context.
> Do you mean keep extra_params for current tests, encourage qemu_params for new
> tests, document that they mean the same thing and going forward qemu_params should
> be used?

Exactly, which just amounts to keeping the parsing line

           elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
                 qemu_opts=${BASH_REMATCH[1]}

and some documentation changes.

Thanks,
drew

> 
> Thanks,
> 
> Alex
> 
> >
> > Thanks,
> > drew
> >
> >> Thanks,
> >>
> >> Alex
> >>
> >>> Thanks,
> >>> drew
> >>>
> 

