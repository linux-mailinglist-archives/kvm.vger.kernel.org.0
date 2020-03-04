Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C911786F6
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2020 01:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727864AbgCDAXK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Mar 2020 19:23:10 -0500
Received: from mail-vs1-f54.google.com ([209.85.217.54]:42183 "EHLO
        mail-vs1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbgCDAXK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Mar 2020 19:23:10 -0500
Received: by mail-vs1-f54.google.com with SMTP id w142so25768vsw.9
        for <kvm@vger.kernel.org>; Tue, 03 Mar 2020 16:23:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vkq15fTmUQpExSNOgV9L6YbvOTkV5MiJlu4IVsNI6RM=;
        b=o+7Fbz5EVb+o8P1f2VzexE3uIA2rk1zJZ/UhmUkcB9g4RHUUmuBWaW6PrrxojMxVZf
         ugAT7VoZQrNDX4eqERDBZdNsWy9xDE2lGOYqaBD+ZqmWJ/DvDSO4Qbi7B9NsiJCWov66
         j7argAtZicHqDGAxFU8tir/YBfrguYoR+Pz6t/QnRormg70uV7nt081xKl57NBIFF4tq
         yOGMK/FltpsmGY4bQmtVops5+eiF1htKW3FHOpeSpyykEvfNsZCnwxRdPZpLKv2bMdB5
         ux1oMVI5vis6NS4zqpq1cB79j6Z+DTU6ME2JEnq02iPD/2Fy9V/pNOujCWspbuESxLQQ
         ZuKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vkq15fTmUQpExSNOgV9L6YbvOTkV5MiJlu4IVsNI6RM=;
        b=XmnndemboTq0fTT7QvpEOYLmH1t01q63LhwLNf9H2rtupMGmGkQMisJujTSir2T6d4
         juFxdkDtHKCBBU90NgGRMSzNDT8fpK2zM8Za6+3Dt44PCkselTB3nXMpViYMaB250XlX
         BRDbnprn7hodRpreOrKjvkuTldj77apRYVaNUs3w1dXHnkXNDnycHAcqOTVuy7vkubjj
         FyvF0id7+bj07PsKg4UTUTWwh2yLna6pZM3y+0FlCSLglr7f7n1voxHNwFgp3AUDOHIU
         NlApgbp2vadpB1E+iSmVCgio4Ol6uNldC8oSJVU2RsqRPWNsbzLO0BscUTK1O8FLL0au
         WoTw==
X-Gm-Message-State: ANhLgQ1Kitdxdzehn85n//Qx6gsW0WLYDJky465iL8IS8SySKQPh7HCZ
        MkM6L+X8dVh+f9aNvYDSjA1AFId+28/OGQ7qdb4LBTKTz6I=
X-Google-Smtp-Source: ADFU+vvjkpISzsey288JlKFz9LB5YEzG5O1mdD8s+bhv7EyQ/LmeQcMYlUKLPV7COelTUeBE4zb4/bECvOD0hQ/Rh+Y=
X-Received: by 2002:a05:6102:85:: with SMTP id t5mr370173vsp.134.1583281388599;
 Tue, 03 Mar 2020 16:23:08 -0800 (PST)
MIME-Version: 1.0
References: <CALMp9eQqAfehUnNmTU6QuiZPWQ-FtYhLXZ_SNHe=YRkGVJsKLw@mail.gmail.com>
In-Reply-To: <CALMp9eQqAfehUnNmTU6QuiZPWQ-FtYhLXZ_SNHe=YRkGVJsKLw@mail.gmail.com>
From:   Peter Feiner <pfeiner@google.com>
Date:   Tue, 3 Mar 2020 16:22:57 -0800
Message-ID: <CAM3pwhEXonbu-He1KD52ggEHHKVWok4Bac-4Woq7FvYL9pHykA@mail.gmail.com>
Subject: Re: Nested virtualization and software page walks in the L1 hypervsior
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Feb 29, 2020 at 2:31 PM Jim Mattson <jmattson@google.com> wrote:
>
> Peter Feiner asked me an intriguing question the other day. If you
> have a hypervisor that walks  its guest's x86 page tables in software
> during emulation, how can you make that software page walk behave
> exactly like a hardware page walk? In particular, when the hypervisor
> is running as an L1 guest, how is it possible to write the software
> page walk so that accesses to L2's x86 page tables are treated as
> reads if L0 isn't using EPT A/D bits, but they're treated as writes if
> L0 is using EPT A/D bits? (Paravirtualization is not allowed.)
>
> It seems to me that this behavior isn't virtualizable. Am I wrong?

Jim, I thought about this some more after talking to you. I think it's
entirely moot what L0 sees so long as L1 and L2 work correctly. So,
the question becomes, is there anything that L0 could possibly rely on
this behavior for? My first thought was dirty tracking, but that's not
a problem because *writes* to the L2 x86 page tables' A/D bits will
still be intercepted by L0. The missing D bit on a guest page that
doesn't actually change doesn't matter :-)
