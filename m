Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5A7B672C
	for <lists+kvm@lfdr.de>; Wed, 18 Sep 2019 17:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730338AbfIRPdN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 11:33:13 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46604 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726983AbfIRPdM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Sep 2019 11:33:12 -0400
Received: by mail-io1-f67.google.com with SMTP id d17so64760ios.13
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2019 08:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YyyqoKMzvgrtzqzYekctgZmNgeV8r3al5EpVVZgew9k=;
        b=Rtva8T5Vbj9vctbozM/vV+Q6OSlA3kebewTu74PRTJDZyOvCDurQ7d/ZvAhAkl9Jkr
         LcfuokOIioWAE80+2jdHdFNm6rlIbMOdVRH51cs2DO/b1q68/eIcy20mlb7L75MBUDsk
         nJvQMOzZysoG31ijHCaOaojrrrRBfV8KkEKXmnPw6eAQTBy1CseExEbdW/uOOy/E4z/4
         odVf4qMg4bI+ufliefHYzXO3JPLpAG4tLw2ZtbfhKB+vWzvrwfPBboi1D6BmuLFH9SNL
         WiYPzLHGUu8bOPF+cWCILZjAQYlahuINA/Q2Opddh9W9mCnMXIuDolRy/8hMaFa8LDkj
         idJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YyyqoKMzvgrtzqzYekctgZmNgeV8r3al5EpVVZgew9k=;
        b=FLazWm9ohpiXW/JmWD1qwnon9IN5LQPjgO7qvLo9JbILEMQWbgYxTIYipmUUcJCik0
         eKfJDHpjifwBfHSZYMKpJkq5Ya77bEKhZ90aQgwYeAmde0p/ReV6LugnWpoVuywF19H8
         KC3Rqj1zFx/u2PnpvVXxOvG+gihpX4r90Ouh7+aF3wnHVqv1Vr+68VRde08L2a8pw3BH
         xO+s2UJFgTFrQQGttz9RThp9KJUqkRXcUpKE2I1qQDumQdyWTTk0a4i6BaqDtQ6HrHWq
         /tsb1K0Q4TojZ5xzXwjasj0jKdC0GuiJ+uBzFZpOcNxd6DLvcUMUR41v5S2cGA53tEi5
         WA6A==
X-Gm-Message-State: APjAAAUo9weD1+CInWaz4exjQO5AKOBlSuNnk5G4YZcMoOoTrYtUy7VA
        5AkGP5KmzUVzmPpHAd/Ww5ttbs84jhL1nNjOVlFtJi8eamk=
X-Google-Smtp-Source: APXvYqzj+efXJ5b9/Ie/wWzM5LpwVVP8q27A0mM2FUYwbsHX44PPooRyTAqsxZH6a472RT2ufpD6zAi6AB1dIZeqY4o=
X-Received: by 2002:a6b:9085:: with SMTP id s127mr458570iod.26.1568820790093;
 Wed, 18 Sep 2019 08:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190912232753.85969-1-jmattson@google.com>
In-Reply-To: <20190912232753.85969-1-jmattson@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 18 Sep 2019 08:32:58 -0700
Message-ID: <CALMp9eRz02uUbWdF_tfyoj0y1bfgeg3swsHW1wqxkSJQk-PrfQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] kvm: x86: Improve emulation of CPUID leaves 0BH and 1FH
To:     kvm list <kvm@vger.kernel.org>
Cc:     Steve Rutherford <srutherford@google.com>,
        Jacob Xu <jacobhxu@google.com>, Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 12, 2019 at 4:28 PM Jim Mattson <jmattson@google.com> wrote:
>
> If these CPUID leaves are implemented, the EDX output is always the
> x2APIC ID, regardless of the ECX input. Furthermore, the low byte of
> the ECX output is always identical to the low byte of the ECX input.
>
> KVM's CPUID emulation doesn't report the correct ECX and EDX outputs
> when the ECX input is greater than the first subleaf for which the
> "level type" is zero. This is probably only significant in the case of
> the x2APIC ID, which should be the result of CPUID(EAX=0BH):EDX or
> CPUID(EAX=1FH):EDX, without even setting a particular ECX input value.
>
> Create a "wildcard" kvm_cpuid_entry2 for leaves 0BH and 1FH in
> response to the KVM_GET_SUPPORTED_CPUID ioctl. This entry does not
> have the KVM_CPUID_FLAG_SIGNIFCANT_INDEX flag, so it matches all
> subleaves for which there isn't a prior explicit index match.
>
> Add a new KVM_CPUID flag that is only applicable to leaves 0BH and
> 1FH: KVM_CPUID_FLAG_CL_IS_PASSTHROUGH. When KVM's CPUID emulation
> encounters this flag, it will fix up ECX[7:0] in the CPUID output. Add
> this flag to the aforementioned "wildcard" kvm_cpuid_entry2.
>
> Note that userspace is still responsible for setting EDX to the x2APIC
> ID of the vCPU in each of these structures, *including* the wildcard.
>
> Qemu doesn't pass the flags from KVM_GET_SUPPORTED_CPUID to
> KVM_SET_CPUID2, so it will have to be modified to take advantage of
> these changes. Note that passing the new flag to older kernels will
> have no effect.
>
> Unfortunately, the new flag bit was not previously reserved, so it is
> possible that a userspace agent that already sets this bit will be
> unhappy with the new behavior. Technically, I suppose, this should be
> implemented as a new set of ioctls. Posting as an RFC to get comments
> on the API breakage.
>
> Fixes: 0771671749b59a ("KVM: Enhance guest cpuid management")
> Fixes: a87f2d3a6eadab ("KVM: x86: Add Intel CPUID.1F cpuid emulation support")
> Signed-off-by: Jim Mattson <jmattson@google.com>
> Reviewed-by: Steve Rutherford <srutherford@google.com>
> Reviewed-by: Jacob Xu <jacobhxu@google.com>
> Reviewed-by: Peter Shier <pshier@google.com>

No comments on the API breakage? Shall I resubmit as an actual patch?
