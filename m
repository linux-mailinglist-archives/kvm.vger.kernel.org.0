Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49A61756A9
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 10:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgCBJOT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 04:14:19 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39872 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgCBJOT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 04:14:19 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so3960566plp.6
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 01:14:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WI3BhEOgCILS/5NQolnVkhvq10Fu9d9XB21BRwy0dCQ=;
        b=E2VcbI8TiKGymGO7uZ4sqeJ/bDheg1P5kkg9uAOhN7RpT9oSmyzlU45xtqAyPvqZht
         pOxHHlqtGZb3FwhVPrPkLPhyZzu3onq7HCral72GYvpz2f2fue+OEatQ2bIHzVc13zU9
         T3X+QE+2C6dsUF25wItDxMjfHbB8ZpaUjyFXVJWR+D4qRkXY+yLrxQhNytIn6SymmlaO
         vkz0odIUo3LTgJngKDe8ke+9HOMwNgMnH5nfDUm+fYVuIruEbduba8qQn+LMstMtELQ9
         j+hrbYdzesNmtLzqMSU2ZhxBsweTuCuNqLJm70TxUvQ8mYek3iaeGhn/needlWGOsMMd
         FvwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WI3BhEOgCILS/5NQolnVkhvq10Fu9d9XB21BRwy0dCQ=;
        b=cOTR7HU6Ob8eArmKLqO3c7KPhjss002S3NxiLfeQUxLPlITslfF6yGqJDKxVhT0lNx
         0Mnja4kIeiX/xZytTmjhl6eamcyoggW7ySCpL8VwDJC+VSFVkhH9ecDynQGcoL+C3C3H
         fdB6JuPfl7a03j75FSqh9QRnCjdpGMYYHMtlX91dV4pfsqp90Z/+we6Yvj4527yVqvLg
         Q6ZiCUYq1n1A6sbZ9bPVaK+eEB/18apY+xQ/5Wh/Y8/lZ1it8v8AKfOVX8qPcWtFw47m
         IRbAkR7eNaIHmJ8dp+gS3eLv4lcE6thbvzd584ipwVZOixKkoxjySlH72oJaMUANr8aX
         F77w==
X-Gm-Message-State: APjAAAXqpUyuFT3LnfDBHejbn6rt5+Prol9QpyTtbgtykbVI8ec1uvux
        +SA003DI560lB5bvgcL3NxvBSw==
X-Google-Smtp-Source: APXvYqyvkuFoYOFh9coq9E6HV6lY0IFgP646++rxHRiOj9Tu1BOXZzI3/ur1toym++ddLWXzcFnG7Q==
X-Received: by 2002:a17:902:ab98:: with SMTP id f24mr16763181plr.338.1583140458697;
        Mon, 02 Mar 2020 01:14:18 -0800 (PST)
Received: from localhost ([122.167.24.230])
        by smtp.gmail.com with ESMTPSA id b133sm20112998pga.43.2020.03.02.01.14.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Mar 2020 01:14:17 -0800 (PST)
Date:   Mon, 2 Mar 2020 14:44:16 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH] KVM: X86: Fix dereference null cpufreq policy
Message-ID: <20200302091416.od5ag3tokup4ha5m@vireshk-i7>
References: <1583133336-7832-1-git-send-email-wanpengli@tencent.com>
 <ab51f6c9-a67d-0107-772a-7fe57a2319cf@redhat.com>
 <20200302081207.3kogqwxbkujqgc7z@vireshk-i7>
 <73a7db77-c4c7-029f-fd8a-080911fde41e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73a7db77-c4c7-029f-fd8a-080911fde41e@redhat.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02-03-20, 09:39, Paolo Bonzini wrote:
> On 02/03/20 09:12, Viresh Kumar wrote:
> > On 02-03-20, 08:55, Paolo Bonzini wrote:
> >> On 02/03/20 08:15, Wanpeng Li wrote:
> >>> From: Wanpeng Li <wanpengli@tencent.com>
> >>>
> >>> cpufreq policy which is get by cpufreq_cpu_get() can be NULL if it is failure,
> >>> this patch takes care of it.
> >>>
> >>> Fixes: aaec7c03de (KVM: x86: avoid useless copy of cpufreq policy)
> >>> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> >>> Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
> >>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> >>
> >> My bad, I checked kobject_put but didn't check that kobj is first in
> >> struct cpufreq_policy.
> >>
> >> I think we should do this in cpufreq_cpu_put or, even better, move the
> >> kobject struct first in struct cpufreq_policy.  Rafael, Viresh, any
> >> objection?
> >>
> >> Paolo
> >>
> >>>  		policy = cpufreq_cpu_get(cpu);
> >>> -		if (policy && policy->cpuinfo.max_freq)
> >>> -			max_tsc_khz = policy->cpuinfo.max_freq;
> >>> +		if (policy) {
> >>> +			if (policy->cpuinfo.max_freq)
> >>> +				max_tsc_khz = policy->cpuinfo.max_freq;
> >>> +			cpufreq_cpu_put(policy);
> >>> +		}
> > 
> > I think this change makes sense and I am not sure why should we even
> > try to support cpufreq_cpu_put(NULL).
> 
> For the same reason why we support kfree(NULL) and kobject_put(NULL)?

These two helpers are used widely within kernel and many a times the
resource is taken by one routine and dropped by another, and so
someone needed to check if it can call the resource-free helper safely
or not. IMO, that's not the case with cpufreq_cpu_put(). It is used
mostly by the cpufreq core only and not too often by external
entities. And even in that case we don't need to call
cpufreq_cpu_put() from a different routine than the one which called
cpufreq_cpu_get(). Like in your case. And so there is no need of an
extra check to be made.

I don't think we need to support cpufreq_cpu_put(NULL), but if Rafael
wants it to be supported, I won't object to it.

-- 
viresh
