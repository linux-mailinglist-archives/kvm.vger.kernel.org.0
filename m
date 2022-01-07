Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61DB0487C6A
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 19:48:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbiAGSs3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 13:48:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiAGSs2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jan 2022 13:48:28 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86191C061574
        for <kvm@vger.kernel.org>; Fri,  7 Jan 2022 10:48:28 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id h10so2598238wrb.1
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 10:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=raftlsgfS0DQzuOTvWNeZTfeD+RimU34KWwkH9tPzXs=;
        b=NbTWi5M8MEUi0BMTcfYbnzqyj+f5aYFWoCxMXQurA9exrgDjgLVAbGS+vN0aZiDYI+
         1IRQc1VOo4NukUiZql4qunI9YKvTBUesEeqQkYh01nkestt8s8wPyNhE4B9UuBq652zj
         6mBQaM4bY+JlzD0ZwhnawuXxUVaJllVSTx2bNHQXbszLB2O1wiy0Qzi6tHOTxL/kUdbt
         1ZQNNfqV8ePvLwNVxEBZ0kzLTz1varW700B07QaJCeUTv64LmtUvragToRP5fvHeSan9
         0opvPRk+00khMAQRIRzwT7qQjZfPRz+Wc4QM5UUsXWMtSEvV+uf9Ws7IWSrkQhZjtFJB
         0W5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=raftlsgfS0DQzuOTvWNeZTfeD+RimU34KWwkH9tPzXs=;
        b=1J2T39XoihzD/cofQ//fCoM3MUTzxLZy0i5VOuP2g2fUmA03qzOJarzqmtkoPRYsa7
         Qr8RRhPZDToH9/8bbNYghgI5pXspV340x2aCCuJYf4Xx5Mb2r2VVBc5rc99LBir+gEVH
         KWoolKX5FCIdZ1AFPg8VSLEP0E+D2AriD/dm5H2RY1EbQQZB6jeFqrMv2LAQ7YYDVRi8
         /U95Hx1bAaiQp8gjEK/Z4IbvgPQkjprtxC1RaCDCi7X6vc0kwkEAemoWJuhMlgu3/G4Q
         FknMs6HWbUwJqZmJGfxx+kOBrMJKEPajO7P6AYZc4LpRAP1+C6L4hlU33zlSCJVhGZJH
         JinA==
X-Gm-Message-State: AOAM5329jNyMLPCmGZBaXRDTI7o/cqJ1TYL2KnLQ7uMytd+MzWAS9WuB
        qcGRzl+q1b5NGY8R7nmouf6kZO3jEb9ikSj3v2ozNg==
X-Google-Smtp-Source: ABdhPJxSrCyrEJr1EOWUT8XHqQX7+3cJ1ZfTXpm2LDTyfxkzeXIDtwiHj6P1/dInVJ97Wnu5CZ4/oDt3wl8O0HKcwDM=
X-Received: by 2002:a5d:52c4:: with SMTP id r4mr34251380wrv.521.1641581307149;
 Fri, 07 Jan 2022 10:48:27 -0800 (PST)
MIME-Version: 1.0
References: <20211227211642.994461-1-maz@kernel.org> <20211227211642.994461-4-maz@kernel.org>
 <ef8b3500-04ab-5434-6a04-0e8b1dcc65d1@redhat.com> <871r1kzhbp.wl-maz@kernel.org>
 <d330de15-b452-1f9c-14fa-906b88a8b4c4@redhat.com> <87y23rtnny.wl-maz@kernel.org>
In-Reply-To: <87y23rtnny.wl-maz@kernel.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Fri, 7 Jan 2022 18:48:16 +0000
Message-ID: <CAFEAcA8KCZFfiYA_AAxA-ChfN5vZd7EF1jGcFxmcpq=fi4ToeQ@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] hw/arm/virt: Honor highmem setting when computing
 the memory map
To:     Marc Zyngier <maz@kernel.org>
Cc:     eric.auger@redhat.com, qemu-devel@nongnu.org,
        Andrew Jones <drjones@redhat.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 7 Jan 2022 at 18:18, Marc Zyngier <maz@kernel.org> wrote:
> This is a chicken and egg problem: you need the IPA size to compute
> the memory map, and you need the memory map to compute the IPA
> size. Fun, isn't it?
>
> At the moment, virt_set_memmap() doesn't know about the IPA space,
> generates a highest_gpa that may not work, and we end-up failing
> because the resulting VM type is out of bound.
>
> My solution to that is to feed the *maximum* IPA size to
> virt_set_memmap(), compute the memory map there, and then use
> highest_gpa to compute the actual IPA size that is used to create the
> VM. By knowing the IPA limit in virt_set_memmap(), I'm able to keep it
> in check and avoid generating an unusable memory map.

Is there any reason not to just always create the VM with the
maximum supported IPA size, rather than trying to create it
with the smallest IPA size that will work? (ie skip the last
step of computing the IPA size to create the VM with)

-- PMM
