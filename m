Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E492D2A287C
	for <lists+kvm@lfdr.de>; Mon,  2 Nov 2020 11:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgKBKrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Nov 2020 05:47:32 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52654 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728457AbgKBKrc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Nov 2020 05:47:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604314050;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dte52e25xBoC2/b3aj6vhffLW479SBHbzp6Yy/rEPiI=;
        b=YlIYiJG7HVJYiRw6Y3w3Hg+Li8RClTMRvBWiauhSxRfJCzGFy8/IBi++iYh5+4s8jZ/rGs
        QoeW8IfkEh3CLQ21IXfY1l4hLN67bgNDumZvQzgboWGXP0Sm/4qLniYYe+lL1eIBYgZPgY
        dFZKNwDIDIBKlSlJtcF8DHv/7Ls0AYQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-H92V8Ia-OqOoGg3xNt_OjQ-1; Mon, 02 Nov 2020 05:47:29 -0500
X-MC-Unique: H92V8Ia-OqOoGg3xNt_OjQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E1D038015B1;
        Mon,  2 Nov 2020 10:47:27 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.222])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA99C1002C24;
        Mon,  2 Nov 2020 10:47:22 +0000 (UTC)
Date:   Mon, 2 Nov 2020 11:47:19 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Auger Eric <eric.auger@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, pbonzini@redhat.com
Subject: Re: [kvm-unit-tests RFC PATCH v2 3/5] arm64: spe: Add introspection
 test
Message-ID: <20201102104719.qqrt6l6rlx6n7i6o@kamzik.brq.redhat.com>
References: <20201027171944.13933-1-alexandru.elisei@arm.com>
 <20201027171944.13933-4-alexandru.elisei@arm.com>
 <5745ad18-be1a-da91-7289-a48682ad59a5@redhat.com>
 <66ff5a16-1771-9423-9205-5aabb4635c1b@arm.com>
 <c78da5aa-f429-d651-c460-b6cc46d6f188@redhat.com>
 <96204ef8-7afc-2dd4-f226-8efcbacaa564@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96204ef8-7afc-2dd4-f226-8efcbacaa564@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 30, 2020 at 05:50:35PM +0000, Alexandru Elisei wrote:
> Hi Eric,
> 
> On 10/30/20 5:09 PM, Auger Eric wrote:
> > Hi Alexandru,
> >
> > On 10/30/20 4:59 PM, Alexandru Elisei wrote:
> > [..]
> >>>> +	spe.align = 1 << spe.align;
> >>>> +
> >>>> +	pmsidr = read_sysreg_s(SYS_PMSIDR_EL1);
> >>>> +
> >>>> +	interval = (pmsidr >> SYS_PMSIDR_EL1_INTERVAL_SHIFT) & SYS_PMSIDR_EL1_INTERVAL_MASK;
> >>>> +	spe.min_interval = spe_min_interval(interval);
> >>>> +
> >>>> +	spe.max_record_size = (pmsidr >> SYS_PMSIDR_EL1_MAXSIZE_SHIFT) & \
> >>>> +		      SYS_PMSIDR_EL1_MAXSIZE_MASK;
> >>>> +	spe.max_record_size = 1 << spe.max_record_size;
> >>>> +
> >>>> +	spe.countsize = (pmsidr >> SYS_PMSIDR_EL1_COUNTSIZE_SHIFT) & \
> >>>> +			SYS_PMSIDR_EL1_COUNTSIZE_MASK;
> >>>> +
> >>>> +	spe.fl_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FL_SHIFT);
> >>>> +	spe.ft_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FT_SHIFT);
> >>>> +	spe.fe_cap = pmsidr & BIT(SYS_PMSIDR_EL1_FE_SHIFT);
> >>> Why did you remove the report_info() section? I think those human
> >>> readable info can be useful.
> >> I made them part of the test. Since the architecture says they are 1, I think
> >> making sure their value matches is more useful than printing something that the
> >> architecture guarantees.
> > OK for those caps which are always 1 anyway but I was more thinking about
> >
> > report_info("Align= %d bytes, Min Interval=%d Single record Max Size =
> > %d bytes", spe.align, spe.min_interval, spe.maxsize);
> >
> > I'd prefer to keep it.
> 
> Oh, I think I see what you mean, I chose to print them using printf in main().
> This is very similar to what the timer test does, only it does it directly in
> main(), instead of calling another function (print_timer_info(), in the case of
> the timer test). I can move the printfs to spe_probe() if that's what you prefer.

Please use report_info(). When tests fail it's popular to diff the failing
results against the passing results. Some output changes each run, even
in the same environment, and some output really isn't that important. We
should keep important, non-test test results in INFO messages. Then, when
diffing, we can filter out anything without a prefix.

(BTW, I was cc'ed, or maybe bcc'ed, on this series from the beginning.)

Thanks,
drew

> 
> Thanks,
> 
> Alex
> 

