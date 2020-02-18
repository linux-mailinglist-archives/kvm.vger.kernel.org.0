Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C64B0162C3E
	for <lists+kvm@lfdr.de>; Tue, 18 Feb 2020 18:15:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgBRRPB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 12:15:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29147 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726647AbgBRRO7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 12:14:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582046099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JfsHq8FXaZ0WyNMC2vdaaoGHFKHETrOhlNj0vSeLcqM=;
        b=V1MZQ1PcDwRcYrdalk6zUeSWVfS3IRzPaQa5qTDK8A4RPt2WxYgSZCImflP5r/kpJkF9kd
        pV2J7YdVhJ94cPn0cKXb0jvAfzmzf66WFpMo7KWpg2VdR6ywQSCpPLvJFzoAPwyhnmoYjA
        JYFzH6oQW73XgHFkfHI3woDbWuKd4es=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-8Umqm8alNaCJDnOdptchGw-1; Tue, 18 Feb 2020 12:14:51 -0500
X-MC-Unique: 8Umqm8alNaCJDnOdptchGw-1
Received: by mail-wm1-f70.google.com with SMTP id w12so344076wmc.3
        for <kvm@vger.kernel.org>; Tue, 18 Feb 2020 09:14:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=JfsHq8FXaZ0WyNMC2vdaaoGHFKHETrOhlNj0vSeLcqM=;
        b=NjAXL9gy2pTQ9OqD0h+kbpjDzOO7GAEUm67y5CjTTQkw7mcUJATRuV0S2joNpartn8
         C9h1cs/qjp5zvj4gE9R2e7Obu41DkgV8GclrGO+EH0jmnU5CsIxOdJoQZt+S2TOhP+rp
         zs4PX4K/2vOHfvtGlQ/7vewnH1j9f/5eRbj9nJkvLaS7tGUhWV4LvNQ0OXU0g47LRvf9
         /6WPzWdiBxyf6TanekoTgbFkc0zqkwWig+tEbDm3XIL7yKcMVAtEAZV/7k7FF4WJBFI1
         di/yX4f/5vixw0PS3lv+AZOs85lYxJpdlDX18tRFVkXQ7h1Y5RTRwm7mhSK13kllaAwT
         wIhQ==
X-Gm-Message-State: APjAAAW/faIkmr50cZgQZhTF8GK76nJ+H8BKRoMkBKGa6oTggz7Jjbai
        E+aucEl97QPBnpGBu6tyjkqJk4L6VjroX6GjR2vhRWloX2w3MI8Vmhq/2mWMfe8RNDZMYo0ZX1T
        +5k0+6hjUh3ms
X-Received: by 2002:a5d:4a8c:: with SMTP id o12mr29230336wrq.43.1582046089272;
        Tue, 18 Feb 2020 09:14:49 -0800 (PST)
X-Google-Smtp-Source: APXvYqxi6b63+py5Mn2YyRuY6BikZi2vFKPXvOnPfJFaH2rpDMGfHkl4Qga0oQk8ioy8nYBgUIrURQ==
X-Received: by 2002:a5d:4a8c:: with SMTP id o12mr29230318wrq.43.1582046089043;
        Tue, 18 Feb 2020 09:14:49 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id k10sm7013588wrd.68.2020.02.18.09.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 09:14:48 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     ehabkost@redhat.com, kvm@vger.kernel.org, mtosatti@redhat.com,
        liran.alon@oracle.com, rkagan@virtuozzo.com, pbonzini@redhat.com,
        rth@twiddle.net
Subject: Re: [PATCH RFC] target/i386: filter out VMX_PIN_BASED_POSTED_INTR when enabling SynIC
In-Reply-To: <158204497899.18888.4612758973157728331@a1bbccc8075a>
References: <158204497899.18888.4612758973157728331@a1bbccc8075a>
Date:   Tue, 18 Feb 2020 18:14:47 +0100
Message-ID: <87h7zn95rs.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

no-reply@patchew.org writes:

> Patchew URL: https://patchew.org/QEMU/20200218144415.94722-1-vkuznets@redhat.com/
>
>
>
> Hi,
>
> This series failed the docker-quick@centos7 build test. Please find the testing commands and
> their output below. If you have Docker installed, you can probably reproduce it
> locally.

Hm, honestly I don't see how this can be related to my patch:

--- /tmp/qemu-test/src/tests/qemu-iotests/041.out	2020-02-18 14:42:30.000000000 +0000
+++ /tmp/qemu-test/build/tests/qemu-iotests/041.out.bad	2020-02-18 16:50:07.383069241 +0000
@@ -1,5 +1,29 @@
-...........................................................................................
+..................................E........................................................
+======================================================================
+ERROR: test_pause (__main__.TestSingleBlockdev)
+----------------------------------------------------------------------
...
+Exception: Timeout waiting for job to pause
+

something else is broken?

-- 
Vitaly

