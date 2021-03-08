Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2467B331814
	for <lists+kvm@lfdr.de>; Mon,  8 Mar 2021 21:04:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230342AbhCHUEK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Mar 2021 15:04:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbhCHUDh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Mar 2021 15:03:37 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC70C06174A
        for <kvm@vger.kernel.org>; Mon,  8 Mar 2021 12:03:36 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id j6-20020a17090adc86b02900cbfe6f2c96so3787422pjv.1
        for <kvm@vger.kernel.org>; Mon, 08 Mar 2021 12:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=XL4SKSuVZ6Yj1jQfVk7MXJrNi/u+CDGXCA0ezp+9goE=;
        b=RUpFxG3HMCek9rYP4dxy7AY6HZh7WXbQeW9aTsV9NyKTdsGipu3MujdQA8XW4dcN8t
         M4TS65Ci+yvnFDEqfJG2qOZTdRnBht15BBIFQF3fRBnGd/9B3uwezoMXCtGdXYKOl6Kk
         rdG3xdRLiBuoM6eyUMNA1fAsFJKYZzk6KMNoH9gMh+0PPfE7MumMVCD8IIErh5sDAwgs
         v6/ydwTdMl3JphMwZ15XMYiwUA8H+y/5K1CVi7z38Xy9k7kTObMrFxTXgI2DnOSNuOg9
         i7Svks7gg9vgJBdecN3YCMdIGJpvnLIJmlQXR5VuOLGc59rJp02PxYP8EjVYwQ4F2JbW
         A5jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=XL4SKSuVZ6Yj1jQfVk7MXJrNi/u+CDGXCA0ezp+9goE=;
        b=QyXqrYEzzAgzDvA98eYmabDpS9Oz1o4CrNrrdH0WMV2JFBLm1kCwiOPetYAETMr+Wq
         xPIILuhCzYmj1tzePEpqwvEehHKBwC1DMb9wxxHfTDfnTpQsx3bIb5GF9NIrKwa4mMmt
         e6dY9xHh83fJaUaHyoLLnAi70znRt0weu6kDhJcMOyANQ22sE+4EcmTk1zS134T5ssjY
         C8gPWjq+MXEY5dWrbrm9JA1W9zXhULrXPoRNUHlLo2hKDVrxJegiNPzkc9zr1OTJOqOI
         LnyWy7+lNDLz7iM6CoK2TU7OxFIlbNRFsyybbqqpZQBpL3+8+g6Gezx8MTIngYIC/FnN
         l7Kg==
X-Gm-Message-State: AOAM531fSfR2iZMNkwsaaUAxda6jXOG2uAnKZS07riMTZa79WQtLGsE8
        VU+D1KZcv3erIE2JnT6ciBY=
X-Google-Smtp-Source: ABdhPJwwMoM5tA7KQM/9h3fgjRsuqE8ZMqRnyvR3bdBHtYtQWhvt4ZjMjmJrSky8gA+YFkEBmx16Bg==
X-Received: by 2002:a17:90a:e642:: with SMTP id ep2mr600745pjb.62.1615233816237;
        Mon, 08 Mar 2021 12:03:36 -0800 (PST)
Received: from [192.168.88.245] (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id e83sm3179117pfh.80.2021.03.08.12.03.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Mar 2021 12:03:35 -0800 (PST)
From:   Nadav Amit <nadav.amit@gmail.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: The use of smp_call_function_many() in kvm_emulate_wbinvd_noskip()
Message-Id: <E7C0FC7D-150F-4A11-BCEB-1735852438CB@gmail.com>
Date:   Mon, 8 Mar 2021 12:03:34 -0800
Cc:     KVM <kvm@vger.kernel.org>
To:     Jan Kiszka <jan.kiszka@siemens.com>,
        Paolo Bonzini <pbonzini@redhat.com>
X-Mailer: Apple Mail (2.3654.60.0.2.21)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM is none of my business these days, but I was reviewing the use of
smp_call_function_many(), as I made some changes to related code. During
this review, I was looking at kvm_emulate_wbinvd_noskip(), and it seems wrong
to me.

As you may or might now know, smp_call_function_many() does not execute the
provided function on the local core. Considering this behavior, I am not sure
the behavior of kvm_emulate_wbinvd_noskip() is correct. IIUC, there is an
expectation that wbinvd_ipi() would run on the local core, but it would not.

If this behavior is wrong, consider using on_each_cpu_mask() instead
of smp_call_function_many().

To be fair, I guess do not understand the code too well, since it really
looks all racy to me (clearing wbinvd_dirty_mask instead of clearing local
CPU from wbinvd_ipi()).


static int kvm_emulate_wbinvd_noskip(struct kvm_vcpu *vcpu)
{
        if (!need_emulate_wbinvd(vcpu))   
                return X86EMUL_CONTINUE;  

        if (static_call(kvm_x86_has_wbinvd_exit)()) {
                int cpu = get_cpu();      

                cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
                smp_call_function_many(vcpu->arch.wbinvd_dirty_mask,
                                wbinvd_ipi, NULL, 1);
                put_cpu();                
                cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
        } else
                wbinvd();                 
        return X86EMUL_CONTINUE;          
}

