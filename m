Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1070403CD2
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 17:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349576AbhIHPu6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 11:50:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60145 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349633AbhIHPu5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Sep 2021 11:50:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631116189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=40UFBHRGhw7kqtdgKZE841ipL5pc0UoJdYE+Qv6yqos=;
        b=h820ZvBQ1iARuwOK50tEmfUsB/2ll/X2P7mAltw2xnYuO1rt8+NKLfkGi/hg1R8oB/a70O
        3U0NK6ndQpNh314Q8hmgDXX6i6kkWEhy1joOOwOYXuHS3+560gvdMYyjyDW9fBW6jL29bO
        S8iT0id4o/1WLPbXvKeQYmMjb4ARjoA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-cu6yBtL3Nv2DqCJGKfNrAQ-1; Wed, 08 Sep 2021 11:49:48 -0400
X-MC-Unique: cu6yBtL3Nv2DqCJGKfNrAQ-1
Received: by mail-ej1-f71.google.com with SMTP id jw25-20020a17090776b900b005ca775a2a00so1228039ejc.1
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 08:49:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=40UFBHRGhw7kqtdgKZE841ipL5pc0UoJdYE+Qv6yqos=;
        b=XtfUVyq1op2fVFCDB8LAoWu+7NxnUF2NWPboInXE80K0TUAGMELFPGR/hZAg6XTiT6
         S1C1QA7Ki2F58QjG4iiwPJFaFZYK/099zx9tjHf6VhwdWn6tj+9KyDru181lMKral+Si
         kQJSCx/YgliVVpng394G6BZjSQRVteny3e2nd3CuxydhrxhBYF1hp5kbGk7Xe7/ChN3D
         6qLdlv/TyA/XqJUD2QBiFTaoZwd9LCVDoOXS3a2YRMFf+WVVFw72oy6VAs3QGYTNDJYO
         CtbbE5z66I7ltaQ/UKgpQ3UVEv2a5CvT3/I3R7xpvH3nQVjwislb0qYAGeYlD3JIdrk4
         UZdw==
X-Gm-Message-State: AOAM531fKCdKvU6YlIBla5WeI8ySdZX+8nmlucECagIg3uCqxwDXUI4e
        fIJRMjbEhHNxRtCENhgxsc9URksChhaQkAuwCxepq+h4CCmnnKecT+7SCQa4pCM9jmhDpgKh22S
        /x/xVAt1zD3Qe
X-Received: by 2002:a17:906:b052:: with SMTP id bj18mr546488ejb.55.1631116187168;
        Wed, 08 Sep 2021 08:49:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwXu4ZttkpvQjuCVBMIYjCKsZn9H35dFZn58PHwzeCurWJGXZpuFqkrf66aLT/CwHYOOp5Rdw==
X-Received: by 2002:a17:906:b052:: with SMTP id bj18mr546467ejb.55.1631116186921;
        Wed, 08 Sep 2021 08:49:46 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id t16sm1226386ejj.54.2021.09.08.08.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 08:49:45 -0700 (PDT)
Date:   Wed, 8 Sep 2021 17:49:43 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com,
        kvm-ppc@vger.kernel.org, david@redhat.com, frankja@linux.ibm.com,
        cohuck@redhat.com, imbrenda@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andre.przywara@arm.com,
        maz@kernel.org, vivek.gautam@arm.com
Subject: Re: [kvm-unit-tests RFC PATCH 3/5] run_tests.sh: Add kvmtool support
Message-ID: <20210908154943.z7d6bhww3pnbaftd@gator>
References: <20210702163122.96110-1-alexandru.elisei@arm.com>
 <20210702163122.96110-4-alexandru.elisei@arm.com>
 <20210907101730.trnsig2j4jmhinyu@gator>
 <587a5f8c-cf04-59ec-7e35-4ca6adf87862@arm.com>
 <20210908150912.3d57akqkfux4fahj@gator>
 <56289c06-04ec-1772-6e15-98d02780876d@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56289c06-04ec-1772-6e15-98d02780876d@arm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 08, 2021 at 04:46:19PM +0100, Alexandru Elisei wrote:
> Hi Drew,
> 
> On 9/8/21 4:09 PM, Andrew Jones wrote:
> > On Wed, Sep 08, 2021 at 03:33:19PM +0100, Alexandru Elisei wrote:
> > ...
> >>>> +fixup_kvmtool_opts()
> >>>> +{
> >>>> +    local opts=$1
> >>>> +    local groups=$2
> >>>> +    local gic
> >>>> +    local gic_version
> >>>> +
> >>>> +    if find_word "pmu" $groups; then
> >>>> +        opts+=" --pmu"
> >>>> +    fi
> >>>> +
> >>>> +    if find_word "its" $groups; then
> >>>> +        gic_version=3
> >>>> +        gic="gicv3-its"
> >>>> +    elif [[ "$opts" =~ -machine\ *gic-version=(2|3) ]]; then
> >>>> +        gic_version="${BASH_REMATCH[1]}"
> >>>> +        gic="gicv$gic_version"
> >>>> +    fi
> >>>> +
> >>>> +    if [ -n "$gic" ]; then
> >>>> +        opts=${opts/-machine gic-version=$gic_version/}
> >>>> +        opts+=" --irqchip=$gic"
> >>>> +    fi
> >>>> +
> >>>> +    opts=${opts/-append/--params}
> >>>> +
> >>>> +    echo "$opts"
> >>>> +}
> >>> Hmm, I don't think we want to write a QEMU parameter translator for
> >>> all other VMMs, and all other VMM architectures, that we want to
> >>> support. I think we should add new "extra_params" variables to the
> >>> unittest configuration instead, e.g. "kvmtool_params", where the
> >>> extra parameters can be listed correctly and explicitly. While at
> >>> it, I would create an alias for "extra_params", which would be
> >>> "qemu_params" allowing unittests that support more than one VMM
> >>> to clearly show what's what.
> >> I agree, this is a much better idea than a parameter translator. Using a dedicated
> >> variable in unittests.cfg will make it easier for new tests to get support for all
> >> VMMs (for example, writing a list of parameters in unittests.cfg should be easier
> >> than digging through the scripts to figure exactly how and where to add a
> >> translation for a new parameter), and it allow us to express parameters for other
> >> VMMs which don't have a direct correspondent in qemu.
> >>
> >> By creating an alias, do you mean replacing extra_params with qemu_params in
> >> arm/unittests.cfg? Or something else?
> > Probably something like this
> >
> > diff --git a/scripts/common.bash b/scripts/common.bash
> > index 7b983f7d6dd6..e5119ff216e5 100644
> > --- a/scripts/common.bash
> > +++ b/scripts/common.bash
> > @@ -37,7 +37,12 @@ function for_each_unittest()
> >                 elif [[ $line =~ ^smp\ *=\ *(.*)$ ]]; then
> >                         smp=${BASH_REMATCH[1]}
> >                 elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
> > -                       opts=${BASH_REMATCH[1]}
> > +               elif [[ $line =~ ^extra_params\ *=\ *(.*)$ ]]; then
> > +                       qemu_opts=${BASH_REMATCH[1]}
> > +               elif [[ $line =~ ^qemu_params\ *=\ *(.*)$ ]]; then
> > +                       qemu_opts=${BASH_REMATCH[1]}
> > +               elif [[ $line =~ ^kvmtool_params\ *=\ *(.*)$ ]]; then
> > +                       kvmtool_opts=${BASH_REMATCH[1]}
> >                 elif [[ $line =~ ^groups\ *=\ *(.*)$ ]]; then
> >                         groups=${BASH_REMATCH[1]}
> >                 elif [[ $line =~ ^arch\ *=\ *(.*)$ ]]; then
> >
> > and all other changes needed to support the s/opts/qemu_opts/ change
> > should work. Also, an addition to the unittests.cfg documentation.
> 
> Got it, replace extra_opts with qemu_opts in the scripts.
> 
> Yes, the documentation for unittests.cfg (at the top of the file) should
> definitely be updated to document the new configuration option, kvmtool_params.
> 
> >
> > The above diff doesn't consider that a unittests.cfg file could have
> > both an 'extra_params' and a 'qemu_params' field, but I'm not sure
> > we care about that. Users should read the documentation and we
> > should review changes to the committed unittests.cfg files to avoid
> > that.
> 
> What do you feel about renaming extra_params -> qemu_params in unittests.cfg?

Yes, that's what I would expect the patch to do.

> I'm
> thinking it would make the usage clearer, improve consistency (we would have
> qemu_params and kvmtool_params, instead of extra_params and kvmtool_params), and
> remove any confusions regarding when they are used (I can see someone thinking
> that extra_params are used all the time, and are appended to kvmtool_params when
> --target=kvmtool). On the other hand, this could be problematic for people using
> out-of-tree scripts that parse the unittest.cfg file for whatever reason (are
> there people that do that?).

I'm not as worried about that as about people using out-of-tree
unittests.cfg files that will break when the 'extra_params' field
disappears. That's why I suggested to make 'extra_params' an alias.

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
> 

