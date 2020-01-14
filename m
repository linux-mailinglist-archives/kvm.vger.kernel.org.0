Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82C4713B18D
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2020 18:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgANR6j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jan 2020 12:58:39 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:34717 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728783AbgANR6f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jan 2020 12:58:35 -0500
Received: by mail-il1-f194.google.com with SMTP id s15so12345512iln.1
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2020 09:58:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=W0yqmoqqiQGX5X+3SmIFIDXs37Fo/K9SpA39UM1ElC0=;
        b=ghRtCYAQQPaZ9qzmq0BODMZTzaTYbw2CZc2MtwgqKseSozW3nHj+wMLMKE4yBZKHGj
         1r6EjlAlRKSy7M8wmBJg0LYSPDDHVzABjJyDY2T2OWc+7DpLZh9s4GpXcopCTcZIFXu0
         r5vPpMAZgLUuL2vwDXeCiGE7ceLoi4BdG9mx0dyDymiL7XqROmZ2RQUmo33TMr2EUMyi
         YGrQmT3+xfdymFpKDRFtX7VfQPFJvb4gzrxZ7c0bJlOv44kbilDO0ZqaNjN7k5kSolcr
         8sRa6kBMXMGN7DKCYuUPcIEaAwlsfTCshJLUJXCoVuBwb/D6FfcHKP23V9umZOQ927ra
         0LUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=W0yqmoqqiQGX5X+3SmIFIDXs37Fo/K9SpA39UM1ElC0=;
        b=BaVVQgMCxJ59Q6DX+0ReY7Ria5wDZ6ln3K+J2X+Ku4dOg1Wi21R0YWlH9wc2uvzVfm
         3hlq9WOkAdznWQ0vSB0vLxZzyOlqqwYxnXNnJcpy6YGPe+TvFuzgCvoFVFLDbQmpHqdW
         jK6FWFjPPjiItzdwxRA3uaFZYdzENhZNct21DQ7nb2zmyf6JUHuARFSS46OIBigHXoMG
         F/zeEfv2iVdbiEipN5B5/ngx/l2ekLjHFdHNqZ3lXxiCzHaeTMTG1klcWwv/WyM28e/j
         Fu/19P0Xop6SRh2BT4GXikXPb958tgURs9CHGt75rqsnjNgdMh94BJtblAVu+Dt9aHVj
         cSsg==
X-Gm-Message-State: APjAAAU4aXWNdhip1M/wLM7bAxF/hC7UgBfUaZNgtWKfB+b9isIznpQj
        6YaO3g/rrurZsps4WVqqwurvUP1XiMG/Coe8Ehm8MMU/
X-Google-Smtp-Source: APXvYqwQxkwd3AtCqY4VnE9c8aMtHdj2rgYPEH36Ngsm4ontALAUNWCIewNvyq8Gu9lP0UVm+nyMb4dco4vRG5kfIrM=
X-Received: by 2002:a92:8141:: with SMTP id e62mr4466025ild.119.1579024714237;
 Tue, 14 Jan 2020 09:58:34 -0800 (PST)
MIME-Version: 1.0
References: <20200113221053.22053-1-oupton@google.com> <20200113221053.22053-3-oupton@google.com>
 <20200114000517.GC14928@linux.intel.com>
In-Reply-To: <20200114000517.GC14928@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 14 Jan 2020 09:58:22 -0800
Message-ID: <CALMp9eR0444XUptR6a57JVZwrCSks9dndeDZcQBZ-v0NRctcZg@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: Emulate MTF when performing instruction emulation
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Oliver Upton <oupton@google.com>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Shier <pshier@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 13, 2020 at 4:05 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:

> Another case, which may or may not be possible, is if INIT is recognized
> on the same instruction, in which case it takes priority over MTF.  SMI
> might also be an issue.

Don't we already have a priority inversion today when INIT or SMI are
coincident with a debug trap on the previous instruction (e.g.
single-step trap on an emulated instruction)?
