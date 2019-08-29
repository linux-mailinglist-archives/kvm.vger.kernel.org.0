Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCA27A2257
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2019 19:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbfH2ReA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Aug 2019 13:34:00 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:42553 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbfH2ReA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Aug 2019 13:34:00 -0400
Received: by mail-io1-f67.google.com with SMTP id n197so6566007iod.9
        for <kvm@vger.kernel.org>; Thu, 29 Aug 2019 10:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CNek1fVHCD9jq7GVONQj/8IrfQemgkO9NPK3haIUnqg=;
        b=r4pCzBzHZqDIpJS5nUp9rf4MZeWjkgd0WiicFUOrxPMpMZDpBsGRh8lSpDdtJEiUQi
         CT4Hv+CMgFIFRe2Iwj4FAPkppV1O29qcEtdcZ3yp/xi/XfIdWnzuIdjbpmHuJE/g5Vnr
         kBLoPuCXm9IgH4q0GiQjoXqLdwlCzZ+zum9FbGNFVlluA1HNyTlRjuWZ070S/ydgdML0
         0XpT91eLlgDBg0ay9f+D7hEYGjPsicCgVu+Ka4MqnCuzhy9EVk0uZc247z2xFN6RAcRC
         A73K2TCZREazVAENIqpTEmur2LsjxnvB+K/z98j+eQlpWDpu0aFJlsGu2IfmbdSCzzlD
         1gBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CNek1fVHCD9jq7GVONQj/8IrfQemgkO9NPK3haIUnqg=;
        b=Z6E3cX/+rpL0I8Xuw9PYl78Jke4RI3VjCBS4jWe8z8kcOd2NV5zWPQb+EZKEU/xaEo
         sftxJRQHD7LkDlBIY7FdFJXUz3DpzWjofDypnUc+840qqFk4l40uOAh75i+x9Eypo63p
         zkhveRO/hY1tRE+HwB3ks5DKjdVmMiHgZiukQSVAvSkr9+Kd/IqsOtqFzG3CBd0s1B4v
         alTgmuSVj1Vf6FeAoU6K1KGgxifsArUp66JPJViA24dSL23FOa72qYHw/akeZHWocGkP
         TGJPIEswBIOk1aoMsbt8FVo++SngLtanPTV74ja3SajZLkl2Ov4eGIxHu/JkxPonZn9i
         T6eg==
X-Gm-Message-State: APjAAAVo4V640hDauLHXAQLAT5wfJJzHYu7ijLqWxsgQ8ffcBVtfsaoY
        nEa4xfbj0DDOTfWSYoxtqeY7yuRgPtKvd7mGq3eLAw==
X-Google-Smtp-Source: APXvYqwbiLf8amTZooXDdCyycgdenayhJpu7SAvyOlQOLjAlLl9kJKZ1BxTJYBajnnpLpuapFRXgD0CQRFYxYb1DO5I=
X-Received: by 2002:a5e:a811:: with SMTP id c17mr12246431ioa.122.1567100039138;
 Thu, 29 Aug 2019 10:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190828234134.132704-1-oupton@google.com> <20190828234134.132704-8-oupton@google.com>
In-Reply-To: <20190828234134.132704-8-oupton@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 29 Aug 2019 10:33:48 -0700
Message-ID: <CALMp9eTsd2YQxqDu9cXfJiMr1DK41oJbnBW3zRAw10k+uNuGmA@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 7/7] x86: VMX: Add tests for nested "load IA32_PERF_GLOBAL_CTRL"
To:     Oliver Upton <oupton@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 28, 2019 at 4:41 PM Oliver Upton <oupton@google.com> wrote:
>
> Tests to verify that KVM performs the correct checks on Host/Guest state
> at VM-entry, as described in SDM 26.3.1.1 "Checks on Guest Control
> Registers, Debug Registers, and MSRs" and SDM 26.2.2 "Checks on Host
> Control Registers and MSRs".
>
> Test that KVM does the following:
>
>     If the "load IA32_PERF_GLOBAL_CTRL" VM-entry control is 1, the
>     reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
>     GUEST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
>     should fail with an exit reason of "VM-entry failure due to invalid
>     guest state" (33).
>
>     If the "load IA32_PERF_GLOBAL_CTRL" VM-exit control is 1, the
>     reserved bits of the IA32_PERF_GLOBAL_CTRL MSR must be 0 in the
>     HOST_IA32_PERF_GLOBAL_CTRL VMCS field. Otherwise, the VM-entry
>     should fail with a VM-instruction error of "VM entry with invalid
>     host-state field(s)" (8).

Could you add a simple functionality test as well? That is, after a
successful nested VM-entry, the L2 guest should be able to observe the
GUEST_IA32_PERF_GLOBAL_CTRL value when it reads the
IA32_PERF_GLOBAL_CTRL MSR, and after a subsequent nested VM-exit, the
L1 guest should be able to observe the HOST_IA32_PERF_GLOBAL_CTRL
value when it reads the IA32_PERF_GLOBAL_CTRL MSR.
