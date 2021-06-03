Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A1A39A0D8
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 14:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhFCMa4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 08:30:56 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:39799 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhFCMaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 08:30:55 -0400
Received: by mail-ot1-f54.google.com with SMTP id 5-20020a9d01050000b02903c700c45721so4481082otu.6
        for <kvm@vger.kernel.org>; Thu, 03 Jun 2021 05:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JSAZo468btl5h+81ZQoc4rkUXIfRohA0D+Skemi7f4c=;
        b=t1mX+FKgztbD8cgqo/Mg/kcb27HWRN9xEUYJIg7MFBt7Xd8kAL1hv0pAP9aVpGwqen
         ApMh6K4D+miy3e1EltFIBV+Go0k029IIm0OTYwaMcUK3xCr13mSVu6JUz44Po+XF3VvK
         MZDSnBN/FW1MaFlb1XMscH1rXBqTTFQ1g3HK89SOvdeLF5x1iOl36ZZoLU9cc1JEOiQ9
         3/55OA/DjB/djZ9L743CHJ9T0pFjavAyh3vCVkZEthIVHuFsEoH18/ILX9XAUTMGh/HL
         CxOpV3Y2/r2sF32BNuqA3NYoi7pQTTydW3U9sRvfZncqUJPt1nI+dQ5jK4cU/zQ+TSv3
         zMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JSAZo468btl5h+81ZQoc4rkUXIfRohA0D+Skemi7f4c=;
        b=jxgUXoAD+QGquJkZciSIYFZoKjiiU+n5gX4XHs16TwU1J7fNSd15KuKIn8YQOfJ/lO
         wHwejceQV5zRgaLY+nMLCvTngyECo4ad2D714vJ3rmGSKI3yiKCPs/xVLnhvrBZsgMmt
         0T60nBNXnkU2SZGeAaM+eOVyy3Y0I4byP4aYOtnwdbJCvQaEjepU04M39hpyTMc+60kU
         1z9uXJHDrGzjDbwafy773DP2HC+3T382XAJjdoLmww0HbC6sJS4Yf1piE+69yBhhPV0Z
         BN05AqpBEz/hZ2P7e3jFRJSp8kryJXg5VqxB4LRjN9OEveEVGXu8K6L26DNjrfeCXvex
         VnoA==
X-Gm-Message-State: AOAM530J8T15MpT/C2lS+MxC6UHaf1hEvZPksaLpJPtHTeHO7IuHUaWr
        2+BbZAUS2cHirOOdMUA1ZPGb2BLTNTBw1Ibr/IIH1Q==
X-Google-Smtp-Source: ABdhPJyfqTh3RyhrbLLKVaZQU6m2lY60v3CeuzincqeamG/lTK7kAUd8htUpZgRW5aEBnKXf/RquiYR9w1cIeTkKj+0=
X-Received: by 2002:a9d:131:: with SMTP id 46mr30430846otu.241.1622723278062;
 Thu, 03 Jun 2021 05:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <1622710841-76604-1-git-send-email-wanpengli@tencent.com> <1622710841-76604-2-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1622710841-76604-2-git-send-email-wanpengli@tencent.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Jun 2021 05:27:46 -0700
Message-ID: <CALMp9eSK-_xOp=WdRbOOHaHHMHuJkPhG+7h4M+_+=4d-GCNzwA@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: LAPIC: reset TMCCT during vCPU reset
To:     Wanpeng Li <kernellwp@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 3, 2021 at 2:01 AM Wanpeng Li <kernellwp@gmail.com> wrote:
>
> From: Wanpeng Li <wanpengli@tencent.com>
>
> The value of current counter register after reset is 0 for both Intel
> and AMD, let's do it in kvm.
>
> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>

How did we miss that?

Reviewed-by: Jim Mattson <jmattson@google.com>
