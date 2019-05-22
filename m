Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6F825FCD
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 10:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbfEVIwF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 04:52:05 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:41984 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfEVIwE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 04:52:04 -0400
Received: by mail-oi1-f195.google.com with SMTP id w9so991655oic.9;
        Wed, 22 May 2019 01:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dJ4wm+mdjXtu+eOzSO5zfL1pe6lE6wK9af8XsWQTncE=;
        b=qqCo3fFW9XUWHn252Q2WFlLZvSAu/rSqSVOpdnL+6JkaWkvBV9db/TsdE2hCqPjcUO
         vDbOuJSjDyOQlbu2Vz5fwhkmY6ko36t+1UTqukYQKdCXaQjYX3qvFXSDEdm9/jr5OaNu
         FPGLbailOOLuQc78LlQGUivYQB2PGrtA5blcV516e4qRRIKOCKZgfrSUpkUyha73IJxD
         oKyD7cO2RBYEOaRC41OIO68QqOs3OfwaXSkrRbVGw0Lvby++KY/ra7wXZkr8TKdylBJY
         6mHbK73xzWpqxrigHqu4zTlA+2Sg5GIrVKSV4ecXgFXYUxqdLKpE5xcknZsBumyAShbl
         R6xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dJ4wm+mdjXtu+eOzSO5zfL1pe6lE6wK9af8XsWQTncE=;
        b=FN6f4viuBOcdsKEW1/zv3PfMCUnXRpwAWohL+YBNkD1mq3y3jEJ0gYI6N7h4wi+4FA
         MDG1mjSY9QcAXNO2cI8SIwR4ssXfpQQa4/Kcf3OYhQ08ypUTVle4nf9olUSQFykow5Xf
         xGMRQ7oIyNJts+oLaZEvre8xVyg07DdCcaGSKlf9lSs/kqayKDkVqXuxFES8JdXI9V3h
         MmRTBGgwqH3RlhXcPI1Nzpd4GTIKDOlCuOft5XCvDK8IExPdAzTb96wXr47n8fJaSjWV
         OPUvQJbL8zZFXDT02iztK2cM8oqipJbAb4+t2d5XgFyi8ugNrpVlNjnOXDK+JyD6hRIQ
         zIbQ==
X-Gm-Message-State: APjAAAWFbxWDOF8Fvpgnbbkj+JchaFh0i5m+x2zu80g8pX8UgQYZxX1j
        LZIa8I+jzpwaNXJyd3QrmsqEYCrmzfoz+y/Aox27Zg==
X-Google-Smtp-Source: APXvYqzWqtntfEpUbYhbg9b1uoi4VMeSgM35pQjyl/6kZpkGpdPxywV+CDrw7U5YeNuJgTdSJL2wuSuRTFh2RhcfP/o=
X-Received: by 2002:aca:bf83:: with SMTP id p125mr6252674oif.47.1558515124059;
 Wed, 22 May 2019 01:52:04 -0700 (PDT)
MIME-Version: 1.0
References: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1558340289-6857-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 22 May 2019 16:51:52 +0800
Message-ID: <CANRm+Cx0o14p_pTp5_dk5-W=mL20E9DHAFK-qYYNNv+5VuSR=Q@mail.gmail.com>
Subject: Re: [PATCH v4 0/5] KVM: LAPIC: Optimize timer latency further
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 20 May 2019 at 16:18, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> Advance lapic timer tries to hidden the hypervisor overhead between the
> host emulated timer fires and the guest awares the timer is fired. However,
> it just hidden the time between apic_timer_fn/handle_preemption_timer ->
> wait_lapic_expire, instead of the real position of vmentry which is
> mentioned in the orignial commit d0659d946be0 ("KVM: x86: add option to
> advance tscdeadline hrtimer expiration"). There is 700+ cpu cycles between
> the end of wait_lapic_expire and before world switch on my haswell desktop.
>
> This patchset tries to narrow the last gap(wait_lapic_expire -> world switch),
> it takes the real overhead time between apic_timer_fn/handle_preemption_timer
> and before world switch into consideration when adaptively tuning timer
> advancement. The patchset can reduce 40% latency (~1600+ cycles to ~1000+
> cycles on a haswell desktop) for kvm-unit-tests/tscdeadline_latency when
> testing busy waits.

Testing on a Skylake Server, w/ nohz=off, idle=poll in the guest.
Reduces average cyclictest latency from 3us to 2us.

Regards,
Wanpeng Li
