Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBF92A0CD1
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 18:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgJ3Rth (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 13:49:37 -0400
Received: from foss.arm.com ([217.140.110.172]:41276 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725844AbgJ3Rth (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Oct 2020 13:49:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C4D551063;
        Fri, 30 Oct 2020 10:49:36 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A3353F719;
        Fri, 30 Oct 2020 10:49:35 -0700 (PDT)
Subject: Re: [kvm-unit-tests RFC PATCH v2 3/5] arm64: spe: Add introspection
 test
To:     Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     drjones@redhat.com, pbonzini@redhat.com
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-4-alexandru.elisei@arm.com>
 <5745ad18-be1a-da91-7289-a48682ad59a5@redhat.com>
 <66ff5a16-1771-9423-9205-5aabb4635c1b@arm.com>
 <c78da5aa-f429-d651-c460-b6cc46d6f188@redhat.com>
From:   Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <96204ef8-7afc-2dd4-f226-8efcbacaa564@arm.com>
Date:   Fri, 30 Oct 2020 17:50:35 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <c78da5aa-f429-d651-c460-b6cc46d6f188@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 10/30/20 5:09 PM, Auger Eric wrote:
> Hi Alexandru,
>
> On 10/30/20 4:59 PM, Alexandru Elisei wrote:
> [..]
>>>> +	spe.align = 1 << spe.align;
>>>> +
>>>> +	pmsidr = read_sysreg_s(SYS_PMSIDR_EL1);
>>>> +
>>>> +	interval = (pmsidr >> SYS_PMSIDR_EL1_INTERVAL_SHIFT) & SYS_PMSIDR_EL1_INTERVAL_MASK;
>>>> +	spe.min_interval = spe_min_interval(interval);
>>>> +
>>>> +	spe.max_record_size = (pmsidr >> SYS_PMSIDR_EL1_MAXSIZE_SHIFT) & \
>>>> +		      SYS_PMSIDR_EL1_MAXSIZE_MASK;
>>>> +	spe.max_record_size = 1 << spe.max_record_size;
>>>> +
>>>> +	spe.countsize = (pmsidr >> SYS_PMSIDR_EL1_COUNTSIZE_SHIFT) & \
>>>> +			SYS_PMSIDR_EL1_COUNTSIZE_MASK;
>>>> +
>>>> +	spe.fl_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FL_SHIFT);
>>>> +	spe.ft_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FT_SHIFT);
>>>> +	spe.fe_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FE_SHIFT);
>>> Why did you remove the report_info() section? I think those human
>>> readable info can be useful.
>> I made them part of the test. Since the architecture says they are 1, I think
>> making sure their value matches is more useful than printing something that the
>> architecture guarantees.
> OK for those caps which are always 1 anyway but I was more thinking about
>
> report_info("Align= %d bytes, Min Interval=%d Single record Max Size =
> %d bytes", spe.align, spe.min_interval, spe.maxsize);
>
> I'd prefer to keep it.

Oh, I think I see what you mean, I chose to print them using printf in main().
This is very similar to what the timer test does, only it does it directly in
main(), instead of calling another function (print_timer_info(), in the case of
the timer test). I can move the printfs to spe_probe() if that's what you prefer.

Thanks,

Alex

