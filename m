Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757193CBFCD
	for <lists+kvm@lfdr.de>; Sat, 17 Jul 2021 01:34:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238173AbhGPXgq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 19:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbhGPXgp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jul 2021 19:36:45 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D39AC061760
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 16:33:48 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id f93-20020a9d03e60000b02904b1f1d7c5f4so11557083otf.9
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 16:33:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p4sJXPq51knQRXxfT1Fmba0meWahSlo3pLoib5wqgPM=;
        b=XvjJnvEXW1hM1N8JQPVoI2NHYjOctl0J68IDS9lGsydmUOnoTmFyJkGSSvL6HHFMJY
         T+3SmBIRcXxcc3fiVzzIn8MrysN19gt60URfcRYO8/Q+3aXhGVLQPsfZmk/abBH1jGXI
         5pC5h4rpUz1B2wIDMe3rsweXiXxO2fnz86YriAmY5IPLPqxPswYf6NGMDomxDE6VoEhB
         xIY98kP8U9rZC5P699W06KTtqoLB2Wvc6Ei6tGZQOBrzEr1yAo8yDXSqxVlE/TVAGMGI
         JiXY/jFj56J+H/C35xYnzf8TLiU/cChv9ACa6l91zc6e1tv5A7WCPe2bkfyxdp7KaJU8
         2yzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p4sJXPq51knQRXxfT1Fmba0meWahSlo3pLoib5wqgPM=;
        b=i4ox9xRIpEBUG1VN0ZSdxg1ceT5GLV+bwDzQGoXcX2zd4zHSoDbhAz74UMAV4GqWpX
         thBq7AX2qxuKBiUlHI4jW57EBPHX2HwSLxapJ7rnLggvD+OEJi9UDiF9WFnLfSTgSj1S
         fZllJw88W6Hh3BXSg7ZSA8CCDSTU4iYoZyWLLwLzZg1AdPKHv8s+49yOVnwFySY6R70l
         7KLdyanJfpnSmw5uAhovNQ/1hwmiq1LCkdWU+s09WRO8RxvhdC99q+J3tqq5xvVs8R3H
         MVsjoYaWmfHWuapZ5qgS02Zi4A/JhQeU93rQLdpskEKUvnR+2NZkEPqincfJAZ6g3PqY
         mJ6A==
X-Gm-Message-State: AOAM5321BJIWhMxkZKQNIZAOUthVIcm9dY91ghi9Ykjr4Hw7LtHkto+O
        trBCQlltYTLNcDBdDjE+U3LF7ASdKEFV4t1kQOlO1A==
X-Google-Smtp-Source: ABdhPJx8yOzbofIVDQTUnc+VNQJDvUAiVMIP+aWbMOFNH240uSnZ2wHaWt1+3bffRyEcm5kyO/gJeTb2hWnLCake18E=
X-Received: by 2002:a9d:63c6:: with SMTP id e6mr9800065otl.295.1626478427511;
 Fri, 16 Jul 2021 16:33:47 -0700 (PDT)
MIME-Version: 1.0
References: <1626425406-18582-1-git-send-email-weijiang.yang@intel.com> <1626425406-18582-5-git-send-email-weijiang.yang@intel.com>
In-Reply-To: <1626425406-18582-5-git-send-email-weijiang.yang@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 16 Jul 2021 16:33:36 -0700
Message-ID: <CALMp9eQR1u_iXWEg+EEtL0_4mVC_T4d_3QqWy-8a4gncN7CmHQ@mail.gmail.com>
Subject: Re: [PATCH v6 04/12] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        wei.w.wang@intel.com, like.xu.linux@gmail.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 16, 2021 at 1:36 AM Yang Weijiang <weijiang.yang@intel.com> wrote:
>
> From: Like Xu <like.xu@linux.intel.com>
>
> The number of Arch LBR entries available is determined by the value
> in host MSR_ARCH_LBR_DEPTH.DEPTH. The supported LBR depth values are
> enumerated in CPUID.(EAX=01CH, ECX=0):EAX[7:0]. For each bit "n" set
> in this field, the MSR_ARCH_LBR_DEPTH.DEPTH value of "8*(n+1)" is
> supported.
>
> On a guest write to MSR_ARCH_LBR_DEPTH, all LBR entries are reset to 0.
> KVM writes guest requested value to the native ARCH_LBR_DEPTH MSR
> (this is safe because the two values will be the same) when the Arch LBR
> records MSRs are pass-through to the guest.
>
> Signed-off-by: Like Xu <like.xu@linux.intel.com>
> Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>

It might be worth noting that KVM_SET_MSRS cannot be used to emulate a
wrmsr instruction in the guest, but maybe that's already implicit.

Reviewed-by: Jim Mattson <jmattson@google.com>
