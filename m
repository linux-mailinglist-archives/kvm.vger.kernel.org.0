Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04A33C2B84
	for <lists+kvm@lfdr.de>; Sat, 10 Jul 2021 00:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231405AbhGIW5v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Jul 2021 18:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbhGIW5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Jul 2021 18:57:50 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9286C0613E5
        for <kvm@vger.kernel.org>; Fri,  9 Jul 2021 15:55:05 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 75-20020a9d08510000b02904acfe6bcccaso11052392oty.12
        for <kvm@vger.kernel.org>; Fri, 09 Jul 2021 15:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K66QBtJ+phE9JDS05iwl9n97KF/7XWVHefoFggtflzM=;
        b=Z/XPwxtaDaG7Js+AzZfVg7udevUwQeigbzx2kcOEOIMdKZCh9sVF/Y/W06OI71vVY3
         /JFy9RUt7+y/MUHSyhiCbN0oEp++Y/QF5Dl0C24seRliY5YF1z/DxkR1b6RRINEMW0l6
         wHP88x0UyOI+fAuhMGHr1/BTlWWbdRtPdhwY3YekmvTa2k8DK8hN7h/TzM94IiMazauB
         qaQYgLjYTLudt5LMQ9+WnOErefGfuM2g0Il0p2lfBprzLIfyiPixrppmC8YRQ6oQgCLT
         vYmXal5xRAmgHE9kR9Fle9PnTRkGe52G3gJayqOeCBkJixnxV4N1r6jOM91CDa4ivbai
         GKLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K66QBtJ+phE9JDS05iwl9n97KF/7XWVHefoFggtflzM=;
        b=BgAngJwmC7gQRVVAz5vUCvcOCIJ73nM1QICU9lLromH3CQwZNtM+RH7sIF6Q6FHGss
         1Z8ZSYTO+qo5AXeCEMFVifPinqjlwVBYafN8hVIVSCtkloQe9Oj4q30+szlUKa6Duqcu
         z7BVZ2s9TYG9r+J2k80UAWUMmt6gvXyqsjq0wsASJ2006EkNEqOcrJpui9dgMnWFWZ6T
         frFrd2xI0yztjmoyuuMXBIssbM9y6hkYfm8BOdP/S78Jf460fY3uwoBHAjBWXgYZ8DLd
         XYWsfIvT/b4wUbdq/xMu4f5k2nTdqqql0pXg2kt57jCLzVbYCpNHah2XcEkjFkvzonwY
         BIrA==
X-Gm-Message-State: AOAM532f22f25VaWujz871bVBkDKeXaY/47nxkBY3/0FEkrlNl3xPfhd
        Q3HUCD3yxzVKz4SU+EVJMttzTbE3ZWB8U5OPYjhdRA==
X-Google-Smtp-Source: ABdhPJy5uCAPcDt5kVVjgCYzDengiFvxQ8jSXjkQFK9bVgyvt+tzXMN3MUek0UZoagdOIr7X/Uavr8JUjm6YJkR+0wM=
X-Received: by 2002:a05:6830:25cb:: with SMTP id d11mr24792741otu.56.1625871304819;
 Fri, 09 Jul 2021 15:55:04 -0700 (PDT)
MIME-Version: 1.0
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com> <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
In-Reply-To: <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 9 Jul 2021 15:54:53 -0700
Message-ID: <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL state
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
> and reload it after vm-exit.

I don't see anything being done here "before VM-entry" or "after
VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.

In any case, I don't see why this one MSR is special. It seems that if
the host is using the architectural LBR MSRs, then *all* of the host
architectural LBR MSRs have to be saved on vcpu_load and restored on
vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
