Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04E0313E051
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2020 17:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgAPQkN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jan 2020 11:40:13 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:43977 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgAPQkN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jan 2020 11:40:13 -0500
Received: by mail-ot1-f67.google.com with SMTP id p8so19901044oth.10
        for <kvm@vger.kernel.org>; Thu, 16 Jan 2020 08:40:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nYAUE2nnyeDshvTu7pIzpU64iJrg7qrenO7ys1Dxxjw=;
        b=woYkD56TT4VCIBc2vrqR+aUhpmqUXOPywHLUbQE8IDLw8Ne8bFBNNiIDStDHO92/Mw
         OAKZmwTTwde7sQUxx6xfA57WzItiAmlyjhOtolgvJnpNR6p8JGYPpQNYwh+1g8lMKdx3
         wfFNwNOLXi54UWK3roQaPN9ydHyIem3V2IUsetxsMeY0yphOUZW5GxzD3HdTTi5iYObA
         g4OXDIAGacflRUUce6S3FXSlnu52xNQjnNDEBdogFYwMfVdpGIm9eAJpvU51kIu2UudN
         6QDYmNF4cT8aRFyPTqTou8oX8p7ATScsqEkY/ybU71fhxxg/BEhfmQAn/GOqDjb/GPmw
         ya6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nYAUE2nnyeDshvTu7pIzpU64iJrg7qrenO7ys1Dxxjw=;
        b=YrRsOzNfd8FYlZ0I1gz72fvFAFyG9/Krwmtnlv57o390uV7AoLe398b/u82pEcmyrF
         R+7jBdYn5zJ5SL+Jj+2DwVOZcejmpI1BInm6CCdbKWLIipzfccg5Z5ss9IlIsYn2wTnI
         p/itcx7qnNZO8BvhhkdvyLbOQsFz4u8hZ786k84Pyr+t4zmJ4IXURP05TBKMpB40sXp/
         7o2yankrZApjSp1O4kMD1dHdZlm1h2zq9TNf8YFzybYcVeudD2tdta3xlftkAWSqINxN
         k6FCdyxwiB/cfOFnZ5R4xGN90Br1Zls6Cb1G4p2RN3P/iBWNPhCNZ5r7dABUyQpnOWT9
         bQRA==
X-Gm-Message-State: APjAAAVKD1+ey71o+LjjG3j4mB5lo656X98tyhSxqVP3/aKJzCRNWZ29
        y6z0qd2j6icabALadrSGA8/uGCaYyURBVbzxN8xrgw==
X-Google-Smtp-Source: APXvYqx/emCu+rrCc6WG6o6dKNsnHDt6h8pMhVbFZ6t7fFuXEEJhoMyAfWCqWNoLl5KtNLC8zD9IL7H2fgVXXxDJ9qs=
X-Received: by 2002:a05:6830:1586:: with SMTP id i6mr2574132otr.221.1579192812062;
 Thu, 16 Jan 2020 08:40:12 -0800 (PST)
MIME-Version: 1.0
References: <1578483143-14905-1-git-send-email-gengdongjiu@huawei.com>
 <1578483143-14905-9-git-send-email-gengdongjiu@huawei.com> <CAFEAcA_=PgkrWjwPxD89fCi85XPpcTHssXkSmE04Ctoj7AX0kA@mail.gmail.com>
In-Reply-To: <CAFEAcA_=PgkrWjwPxD89fCi85XPpcTHssXkSmE04Ctoj7AX0kA@mail.gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Thu, 16 Jan 2020 16:40:01 +0000
Message-ID: <CAFEAcA9tFcsMrX8_VQwh1P4h3BcwpLoo2h6COHBdQaK=0CoL5g@mail.gmail.com>
Subject: Re: [PATCH v22 8/9] target-arm: kvm64: handle SIGBUS signal from
 kernel or KVM
To:     Dongjiu Geng <gengdongjiu@huawei.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Fam Zheng <fam@euphon.net>,
        Richard Henderson <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "xuwei (O)" <xuwei5@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        James Morse <james.morse@arm.com>,
        QEMU Developers <qemu-devel@nongnu.org>,
        kvm-devel <kvm@vger.kernel.org>, qemu-arm <qemu-arm@nongnu.org>,
        Zheng Xiang <zhengxiang9@huawei.com>,
        Linuxarm <linuxarm@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jan 2020 at 16:28, Peter Maydell <peter.maydell@linaro.org> wrote:
> This function (kvm_arch_on_sigbus_vcpu()) will be called in two contexts:
>
> (1) in the vcpu thread:
>   * the real SIGBUS handler sigbus_handler() sets a flag and arranges
>     for an immediate vcpu exit
>   * the vcpu thread reads the flag on exit from KVM_RUN and
>     calls kvm_arch_on_sigbus_vcpu() directly
>   * the error could be MCEERR_AR or MCEERR_AO
> (2) MCE errors on other threads:
>   * here SIGBUS is blocked, so MCEERR_AR (action-required)
>     errors will cause the kernel to just kill the QEMU process
>   * MCEERR_AO errors will be handled via the iothread's use
>     of signalfd(), so kvm_on_sigbus() will get called from
>     the main thread, and it will call kvm_arch_on_sigbus_vcpu()
>   * in this case the passed in CPUState will (arbitrarily) be that
>     for the first vCPU
>
> For MCEERR_AR, the code here looks correct -- we know this is
> only going to happen for the relevant vCPU so we can go ahead
> and do the "record it in the ACPI table and tell the guest" bit.
>
> But shouldn't we be doing something with the MCEERR_AO too?
> That of course will be trickier because we're not necessarily
> in the vcpu thread, but it would be nice to let the guest
> know about it.

An IRC discussion with Paolo came to the conclusion that
the nicest approach here would be for kvm_on_sigbus() to
use run_on_cpu() to call the whole of kvm_arch_on_sigbus_vcpu()
in the vcpu thread for the cpu it gets passed. Then the code
here would not have to worry about the "not on the right thread"
case. This would be a refactoring of the x86 code, which currently
does the run_on_cpu inside its implementation, in
cpu_x86_inject_mce().

thanks
-- PMM
