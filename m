Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7702E6C85
	for <lists+kvm@lfdr.de>; Tue, 29 Dec 2020 00:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728416AbgL1X3U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Dec 2020 18:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728299AbgL1X3T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Dec 2020 18:29:19 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8085DC061793
        for <kvm@vger.kernel.org>; Mon, 28 Dec 2020 15:28:39 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id p18so8167484pgm.11
        for <kvm@vger.kernel.org>; Mon, 28 Dec 2020 15:28:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YHXv2Jc7uDRYfCGmkxwRFDrFxzJk/xjA57oTL7WqPAk=;
        b=IG4n+U0iEnyjsOCZ36oBibFHyoOloR7t5DabLazjPAe2lmK9D0UpcdC1dKKsDHKU92
         +cNGcUFXNXP9hkO3LbUWCr4BRQi8Whnn0wu2z0IWJBCvbK2HBZGFiD4+Zxu0/hukuw4o
         lk5/1GiSFtPGVEp627njimpcVjMqmpIG/+hZ/x7/ZGthyf687XFMXEzCjJ1BNbefxYu1
         Ckfm4sTb/14a3XTyZzu4k0DcHLu3bTxHYOdScTu399djk0ZSL++S4f0s0e8oFurmTvbQ
         2KnzVqjqU5gz8irc4zLW+QTUznTF3rr51hGWnCeJsWt/b+EdNpgkby/LqoXldqBS97Se
         5wpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YHXv2Jc7uDRYfCGmkxwRFDrFxzJk/xjA57oTL7WqPAk=;
        b=AVD7ceUmIiH5how0Wsm2JWmjMtg69zlR1ROP2P0Dc1mUUnVczHmF2ePnXdY8WWiMCm
         dYUmSrPz4Pzs6luoYKaTjOcVHNKjwYLKTbd0cB6qXIdgQPNfKIlQS0HnanErApT9w6t6
         KYfek3f0nS8hPoVknYYWcOyMaHTCCUFu4wRLA/Kg0nlvDO3A4iv5QevseKTToXB8DxJz
         7pVIwQXdXdtD70kJecyQDAkJrexNNfcFlPh+V82iMhj6TOj/O2JKo+spG/7jQDzlGsDL
         jRC+Xl4znidvQNT9F3miHSt3Bs2Lszyq1dCbxti1lTQ1iqppr28lgyAuhoKzJv6yauT7
         D23g==
X-Gm-Message-State: AOAM5323ZSc3kSXTqTfoXB34tGIOwIN1fm+mGUrtkxPc6hZEpPW9Xtb8
        CEsbDjy4vT5Qz5WRq5uSSQtaRg==
X-Google-Smtp-Source: ABdhPJweRY8jL3It79h5jMNDyIgtwp8n/71UFFCLfDWomYceM6Sn3/Me6p1fMh1We7VQeu4ROtUHLA==
X-Received: by 2002:a63:44d:: with SMTP id 74mr45370796pge.170.1609198118926;
        Mon, 28 Dec 2020 15:28:38 -0800 (PST)
Received: from google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
        by smtp.gmail.com with ESMTPSA id c199sm38708633pfb.108.2020.12.28.15.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Dec 2020 15:28:38 -0800 (PST)
Date:   Mon, 28 Dec 2020 15:28:31 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Zhimin Feng <fengzhimin@bytedance.com>
Cc:     zhouyibo@bytedance.com, zhanghaozhong@bytedance.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC: timer passthrough 0/9] Support timer passthrough for VM
Message-ID: <X+pqH77bs9nyhK8w@google.com>
References: <20201228091559.25745-1-fengzhimin@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201228091559.25745-1-fengzhimin@bytedance.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 28, 2020, Zhimin Feng wrote:
> The main motivation for this patch is to improve the performance of VM.

Do you have numbers that show when this improves performance, and by how much?

This adds hundreds of cycles of overhead (VMWRITEs, WRMSRs, RDMSRs, etc...) to
_every_ VM-Exit roundtrip, and the timer IRQ still incurs a VM-Exit.  It's not
obvious that this is a net win, and it adds a fair amount of complexity and
subtlety, e.g. there are multiple corner cases this gets wrong.  I suspect
you'll have a tough time getting this reviewed, let alone merged, without hard
numbers to justify the complexity and review effort.
