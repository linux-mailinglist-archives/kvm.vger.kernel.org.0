Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A436C183608
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 17:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbgCLQWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 12:22:08 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:42032 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726571AbgCLQWI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 12:22:08 -0400
Received: by mail-il1-f193.google.com with SMTP id x2so6015849ila.9
        for <kvm@vger.kernel.org>; Thu, 12 Mar 2020 09:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FsBkMfXUDJCMIz03y9mCTBZqiTPEgGnz8wIzFbdqMVg=;
        b=O9FcjZXMFD8GF6IEEZhFGDBqTuIvQesX2WgNd1l19a+/9ldD7XjP711gfSHVvdOrvl
         VpoABOR24wJ3MkWXbnwbBK0SX9XLfLw1rq2HLT/vXJNfpdVx4nFl1+9AxJfUzvyccbEH
         bOd8AEJTeXTBLHxc1tlQ9780vwc+907tRLl3RYP+ls5TB+gYWNZxUKv+FsBAxFfPpC2r
         0/cxKtUldX8FFJmLTsLaVB9sTY1T7cIBzwRdxwNj9fhKvpVlj/JUr8mp8/vXJ+2Ri2BW
         MQsDlrvKcj/Cob1s3k819pATx0c73VmZmD6HcPcge2D5wm8AIuPeVk2ki8IK3xrLLaA7
         OZtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FsBkMfXUDJCMIz03y9mCTBZqiTPEgGnz8wIzFbdqMVg=;
        b=KQHVGgzHsI1sQUjiGYUwB0EFIatBKn+sPF5tYOjQbwuFPSOEMXv6bcB4JNKzx1ge60
         t0wwVte9u5qtahBLO271Mkf/hIg6FuexyR/IoXc1I8s02gnt/tDWolA4PrX9KcT8lBXV
         9HtTfYYyXh+dULCGd8n2sf9cI5S0KLCGECicpfU8udhzS5no157mRT9wOI6Wkzk7WxJA
         zA15//Xqp4AaoEfQ05emgX5t8MjiiK3sspKaih+6NHbJNbN+bht9BG74WiLENX2k1mSG
         bqgPjt3MtkMoHAvA3/Rg1/YkvUDht/Q1OXNXb4X/cht0DFoscL+n4NODplc+B0s+tOmh
         yeqA==
X-Gm-Message-State: ANhLgQ2c4QyXlptkfvHnOqh38gCaax0YfLH0CvykSJ5hrAyRPcepZMXs
        1h0qNx5ABMAoVQiCT1xC6hbTicBgcmY5rC/Uxea/AQ==
X-Google-Smtp-Source: ADFU+vsYoFaQWCvdsUUBGMsErE22s1DxtdbVFv/QXw7OaCvbCK7kW/R1LOrb7DXZTMApMqd/mSlLWyL6ClUWb0Nwkf0=
X-Received: by 2002:a92:8458:: with SMTP id l85mr9084710ild.296.1584030127144;
 Thu, 12 Mar 2020 09:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <1584007547-4802-1-git-send-email-wanpengli@tencent.com> <87r1xxrhb0.fsf@vitty.brq.redhat.com>
In-Reply-To: <87r1xxrhb0.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 12 Mar 2020 09:21:56 -0700
Message-ID: <CALMp9eTSBpaPYKE6toPCbSfCQGhM9M4=1Z1FFBGQ9Bm_pKSpuQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: VMX: Micro-optimize vmexit time when not exposing PMU
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 12, 2020 at 3:36 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Also, speaking about cloud providers and the 'micro' nature of this
> optimization, would it rather make sense to introduce a static branch
> (the policy to disable vPMU is likely to be host wide, right)?

Speaking for a cloud provider, no, the policy is not likely to be host-wide.
