Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD4189961
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2019 11:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbfHLJG0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Aug 2019 05:06:26 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45833 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727233AbfHLJG0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Aug 2019 05:06:26 -0400
Received: by mail-ot1-f67.google.com with SMTP id m24so3220409otp.12;
        Mon, 12 Aug 2019 02:06:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7w4cBPzdpuAIPtnuVqHY6slc5DSv5Z5fINkYhZ4kFBE=;
        b=eLsvuMytdZ23YbdvsFSsywprInWIcwLJKm5Jf1JAaHsCb5HFDune2mgxPQkw6h2OFh
         iCtDhlGIpN5wZQySaKLLh65EcNf32OhPeKCqvHtJYsOD4vw4wfsjmnncNPw6WMtLwgUX
         vTw/cX9laJEXAP0e13wYCPMAhAvDrvrFAOdP0WgyUwg9LSAKR4T/o2hGrbZozMVb72Mi
         AA0WyQjSshym53yVFWDuY4zr93d7TMFs2MpxoNNAYzonaE6SUlZ56k6x34Yr4W4J9WKc
         fBk1lxKpGX0TVz8xM/d/o81CoYaLSP6Xrhzf8UkvBrZiXEEGE7H0rMUTI8Gs5LNNBi0p
         gDbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7w4cBPzdpuAIPtnuVqHY6slc5DSv5Z5fINkYhZ4kFBE=;
        b=eg0uOXfSR8Dsqr1qzARLxUCSfgj2l0ea5+wXCreYsUe/46m+IdplebX3g/GZtK7DWR
         4nNCrwsgQ2maI+hU/kkONdHx717SdWjtFbU2qVj4Vmvnh2L6niUTwzjEC0CAQ81B3kwK
         WgnnmeKIOuI/cimO1aEXn8SoJssRUg1AEjUoR8kdspJY196MIqWPqb1TtG7mZ023wdiT
         iA9lmKGi9yCBuhCjORLkDmNGFrv7yeUTTiANkLvye8GYm65EvPTS7rMXjDmE5lhxdJM1
         jrbV25avfxYZ0qjr2tsV/olrcsqfHiWpwxlj3j6DNQrgY8IQ3wEJNqB8mi7ZbxLjTClo
         RqAg==
X-Gm-Message-State: APjAAAW4QtU59L6dPjALI519PkuHaq4W5EjkEgg1ZOe6aaJaVWA/523e
        W5b0eDv262s42nh9EHMAJceiQA3l2UFPKtFqJcEWHg==
X-Google-Smtp-Source: APXvYqygkorYMLSfFNEA3bxN8+EKejmowoY0qiA0RLVnVfVu1KYAp0SAzGiY0aQVCSgV7h4tF/hD+1olBekb+bCAI+c=
X-Received: by 2002:a05:6808:3:: with SMTP id u3mr12906212oic.141.1565600785312;
 Mon, 12 Aug 2019 02:06:25 -0700 (PDT)
MIME-Version: 1.0
References: <1565329531-12327-1-git-send-email-wanpengli@tencent.com> <fad8ceed-8b98-8fc4-5b6a-63bbca4059a8@redhat.com>
In-Reply-To: <fad8ceed-8b98-8fc4-5b6a-63bbca4059a8@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 12 Aug 2019 17:06:15 +0800
Message-ID: <CANRm+CwMMUEyZXmiUu5Y8GA=BEUYGLw31CRyZTc2uA+ct4Bamg@mail.gmail.com>
Subject: Re: [PATCH] KVM: LAPIC: Periodically revaluate appropriate lapic_timer_advance_ns
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 9 Aug 2019 at 18:24, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/08/19 07:45, Wanpeng Li wrote:
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > Even if for realtime CPUs, cache line bounces, frequency scaling, presence
> > of higher-priority RT tasks, etc can cause different response. These
> > interferences should be considered and periodically revaluate whether
> > or not the lapic_timer_advance_ns value is the best, do nothing if it is,
> > otherwise recaluate again.
>
> How much fluctuation do you observe between different runs?

Sometimes can ~1000 cycles after converting to guest tsc freq.

Regards,
Wanpeng Li
