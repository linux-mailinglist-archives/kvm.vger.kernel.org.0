Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4DB61749B8
	for <lists+kvm@lfdr.de>; Sat, 29 Feb 2020 23:31:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgB2WbF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 29 Feb 2020 17:31:05 -0500
Received: from mail-il1-f178.google.com ([209.85.166.178]:41932 "EHLO
        mail-il1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727314AbgB2WbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 29 Feb 2020 17:31:05 -0500
Received: by mail-il1-f178.google.com with SMTP id f10so6056868ils.8
        for <kvm@vger.kernel.org>; Sat, 29 Feb 2020 14:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Bj3Q/TfNLeb/DtyjrvoZT2dQg1+UfeuV5tMH0laoWeQ=;
        b=Mw5n9CWxVW+ZHRhqrHjMm4NSSbsW53EQ7jXZM/TVPMP9kC1PMt/Y1y+vCmccRoFUDi
         6ODUTs50VRaEgJpbWCO8LGWIHmrQBAMJfe8wvJ1lyssU3q2O+vQYZb/PPzlDzVL1Q6GI
         RSOKKAcZZoJpcjfUm8/A2+DKrLB8lgQgeIbDkygTlMTw+2JE56nLMINW1fsntNiHWzr1
         eogHRf3lGdkcxgGvMwDsaSzcl2n4EQKkBsfEYXW2xBopXbAgcz3uIfdzmrZ5JYnjvSOE
         LYL7n8jJ1veaFAk1XpxhK/QhfxsrrenKKF0h+ekoPNzzejlpNYOhhcqgDHLp4xMJtTc6
         3y4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Bj3Q/TfNLeb/DtyjrvoZT2dQg1+UfeuV5tMH0laoWeQ=;
        b=Aa8FxfYyFyuj5m5fq+F2KLklviK6LhnbTpTmqadi9YXFO2h3YWHuLSoDnJpx2ismfj
         UVP85NKeVTFtKGgFYfz7YcQ5dhgCx/dMz7gs2I1Q0rnvpgMzsobgwmIAE2kVT6V8tb8P
         y5WnQI0CrRltHfNlrfLFUMUSRHcmChAUxll6skG+e/0LOLykKsKHV3532fP18cipk/8j
         yrP5Ex83VlXkc5ktXETyKLAnx0p7syd/9lN3n1fVqVIVHp3yN13gYTkR012SdCoDVlfp
         2sUjsIyO+dI0dXEuXoHAN9e5nW9dUDYK7jUiOCmI809gV+FVKMLd2bQT3Ywi+jFg3nl6
         CfxA==
X-Gm-Message-State: APjAAAWTK9VQJtf7GICisFXy5MkZVsLhADhGofYJZeQuZ6mCLGiVk8eM
        vQh6qbEn1FNN8cQNE+AmU8ruOwhb8X2cNLBvUFHf7gYl
X-Google-Smtp-Source: APXvYqwK8FMBZVIsVyTIsGBZQ8NK4+QwKwEb4g/qta+SCVB8R0KfWhK5xvj9iJJzsw/x3uHLbwWX5YKASjHDC2DIvvs=
X-Received: by 2002:a92:8458:: with SMTP id l85mr10549769ild.296.1583015463929;
 Sat, 29 Feb 2020 14:31:03 -0800 (PST)
MIME-Version: 1.0
From:   Jim Mattson <jmattson@google.com>
Date:   Sat, 29 Feb 2020 14:30:53 -0800
Message-ID: <CALMp9eQqAfehUnNmTU6QuiZPWQ-FtYhLXZ_SNHe=YRkGVJsKLw@mail.gmail.com>
Subject: Nested virtualization and software page walks in the L1 hypervsior
To:     kvm list <kvm@vger.kernel.org>
Cc:     Peter Feiner <pfeiner@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Feiner asked me an intriguing question the other day. If you
have a hypervisor that walks  its guest's x86 page tables in software
during emulation, how can you make that software page walk behave
exactly like a hardware page walk? In particular, when the hypervisor
is running as an L1 guest, how is it possible to write the software
page walk so that accesses to L2's x86 page tables are treated as
reads if L0 isn't using EPT A/D bits, but they're treated as writes if
L0 is using EPT A/D bits? (Paravirtualization is not allowed.)

It seems to me that this behavior isn't virtualizable. Am I wrong?
