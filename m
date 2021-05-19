Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB5A3886E9
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 07:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244374AbhESFru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 May 2021 01:47:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348873AbhESFpa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 May 2021 01:45:30 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2656CC061349
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:41:58 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s4so4818459plg.12
        for <kvm@vger.kernel.org>; Tue, 18 May 2021 22:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Ao//7r1KFld4qVZ1tXpzzorSlFP6vtsPLPVYqG20G0=;
        b=DigzqK4GdOu/HgdltA+7CkfEWC3DDrxUDEut8nZl4w7mYY+abYcumxMRYwNdPazlcQ
         hZwdeOoqQCRyH/IJVIbx7u5JsEQp3koYrSAcUu4Bs7dqaOGtc85ogx64GdzwfXAiYg4y
         gHaRXNUYM7ssVx4xi/bK+U1B5bubY4WMmSDxEsoVgO4TJ0eN+sHUkahea23M1/XXuigN
         4nY3uekDRNR/xaeR049tVB1HXhOihgQFOwE4TY8QnVdMGtkYOCLTJ5OBybaqnjV7MCAq
         Qnooo2JEOMCg0CrikKZi9PPskMSLvrWWhPdRQfoQvl1Nwfz4AZSdTsiBAhHBNguFGjv+
         L1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Ao//7r1KFld4qVZ1tXpzzorSlFP6vtsPLPVYqG20G0=;
        b=rzd5wJbOnXQDdPTFi7slyvnPNdueeKxb1AE8dqeKWwYjMy4hHvhPL1fWD4HzP4vBNp
         NRfq8QInbiM/B0tFM3aZMzwTIT560Wpbagbh1GlFIH9jMDtelUIsvM1FZKyeXRdoGSIH
         VwrV+AHSlIHnK2bjI3Am4JYwbnUvS3YVGIa+zceHkAgnyIK7N7l790t19iBDXw5TMNqx
         m66S0Z7oTFTbDKGU1kyYomciuHxA1Aqi+AX9fc9CA/ROWyIvuMhYMYOQJ2rwm475N+07
         VAV4sAKdhwjEC00uSj05m/pYNzooweD/13jdpNV91C2UZYkXY3wX6i32blKIag+QQzBW
         +lTQ==
X-Gm-Message-State: AOAM531YH3OX2vUPBRLV8HqiQok9pnQAsUpCPLuZo9DW11ELOWB/lBib
        rqnySF4saceT5FW5xt14qyc/FWnxggv4uU6VzJGNHg==
X-Google-Smtp-Source: ABdhPJymSSPRYI+9qpROTR12WK1J8yU5xK+sJWHNGj0HyH48UspUw6MPn6/2+CPKH19SOJ8VF/J6MwGzb5tcOSmG0co=
X-Received: by 2002:a17:90b:1185:: with SMTP id gk5mr5813526pjb.168.1621402917077;
 Tue, 18 May 2021 22:41:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com> <20210424004645.3950558-5-seanjc@google.com>
In-Reply-To: <20210424004645.3950558-5-seanjc@google.com>
From:   Reiji Watanabe <reijiw@google.com>
Date:   Tue, 18 May 2021 22:41:40 -0700
Message-ID: <CAAeT=FzCs5GUC448TmNoUeG_mrB0VR6riop11A-3bfk2PUvrxw@mail.gmail.com>
Subject: Re: [PATCH 04/43] KVM: SVM: Fall back to KVM's hardcoded value for
 EDX at RESET/INIT
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 23, 2021 at 5:47 PM Sean Christopherson <seanjc@google.com> wrote:
>
> At vCPU RESET/INIT (mostly RESET), stuff EDX with KVM's hardcoded,
> default Family-Model-Stepping ID of 0x600 if CPUID.0x1 isn't defined.
> At RESET, the CPUID lookup is guaranteed to "miss" because KVM emulates
> RESET before exposing the vCPU to userspace, i.e. userspace can't
> possibly have done set the vCPU's CPUID model, and thus KVM will always
> write '0'.  At INIT, using 0x600 is less bad than using '0'.
>
> While initializing EDX to '0' is _extremely_ unlikely to be noticed by
> the guest, let alone break the guest, and can be overridden by
> userspace for the RESET case, using 0x600 is preferable as it will allow
> consolidating the relevant VMX and SVM RESET/INIT logic in the future.
> And, digging through old specs suggests that neither Intel nor AMD have
> ever shipped a CPU that initialized EDX to '0' at RESET.
>
> Regarding 0x600 as KVM's default Family, it is a sane default and in
> many ways the most appropriate.  Prior to the 386 implementations, DX
> was undefined at RESET.  With the 386, 486, 586/P5, and 686/P6/Athlon,
> both Intel and AMD set EDX to 3, 4, 5, and 6 respectively.  AMD switched
> to using '15' as its primary Family with the introduction of AMD64, but
> Intel has continued using '6' for the last few decades.
>
> So, '6' is a valid Family for both Intel and AMD CPUs, is compatible
> with both 32-bit and 64-bit CPUs (albeit not a perfect fit for 64-bit
> AMD), and of the common Families (3 - 6), is the best fit with respect to
> KVM's virtual CPU model.  E.g. prior to the P6, Intel CPUs did not have a
> STI window.  Modern operating systems, Linux included, rely on the STI
> window, e.g. for "safe halt", and KVM unconditionally assumes the virtual
> CPU has an STI window.  Thus enumerating a Family ID of 3, 4, or 5 would
> be provably wrong.
>
> Opportunistically remove a stale comment.
>
> Fixes: 66f7b72e1171 ("KVM: x86: Make register state after reset conform to specification")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Reiji Watanabe <reijiw@google.com>
