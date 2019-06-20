Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8447F4D9B0
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 20:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726804AbfFTSps (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 14:45:48 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38280 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbfFTSps (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 14:45:48 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so843475ioa.5
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 11:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hSxoaZBOkmQZaJYH3j6SOT3eABhlSAaxFaI9XP1STUE=;
        b=W7qC76hrhQauOTxzpwZYpacR1kGn/isREGEgNVFuKJhrup3Bka80hXojC5ioJ5vEHs
         367fzE0tqcEb5OVmLcHY6In+7Y9kx4dv/HP6fdMT43vXr4lqDuLRi4QPIUBr0Af2T8zm
         WFXiOobb2Mx9cHhQ5I4KeWIygTreeEgY886JMk3jQs3LwlCdTJ1tuIKmMLHZKpkxoDcU
         8hzJTPZjEohYhagJ9x8ZTK1cnARAysCGuFgcWmWBSJboor1d1onzcgpTVaSxs8xLjToE
         wJBbjvGwWjfiL3bm69Wd4dUjS04qper6sWx71JRMJxl/VyzLMEtHPeRDZY56WwcFmLxp
         EwSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hSxoaZBOkmQZaJYH3j6SOT3eABhlSAaxFaI9XP1STUE=;
        b=R3xqA/sn+9u8mj+QYPzBnHFKmNdPMALlYrurRo+O518cR8qp06rxRXBDJA3IO+h5jm
         akbSVGv5M5K7/tdTPoh8Iyxg44iwbFD/EeemNKaNqqAlNLVDzlXeWaOfqt+aTZW787zg
         FU88PWgLtXuI5dvFPXv7swiRrljYm+sxY+pBX62vwkAkkHIsSrmAXx7/35qJsyrA8syu
         JLvL7mcebe2c5VHEj7onDheipa7IHgO6yCNne/kjDESm9BzOyOxD5RMYOhLie68dZH7W
         LXvLcbrL6ZW9p1LBrI659wfKgyz28BhAOczopQNIftysgMG61fmbsQtGKxX1aHzTZWeX
         1XXQ==
X-Gm-Message-State: APjAAAWhV+U4hTmW1r7B4RdGug4KgAK+3prZa2FaQshgZss6t3M9cE3d
        fVc0oIlGRA6JNKj2IidB7dIpQgBN6VHxflkN1FDgLQ==
X-Google-Smtp-Source: APXvYqxZrwLtmE2tJmKgoglFKu3htrn3jMn2x9r1huRL2cMraHKfJd0fPXf9ONzsse4cK8tjmXFC/Z7TrRxFSd9aBs8=
X-Received: by 2002:a02:1a83:: with SMTP id 125mr27916903jai.54.1561056347525;
 Thu, 20 Jun 2019 11:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190620110240.25799-1-vkuznets@redhat.com> <20190620110240.25799-3-vkuznets@redhat.com>
In-Reply-To: <20190620110240.25799-3-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Jun 2019 11:45:36 -0700
Message-ID: <CALMp9eQh3yJZbDkSj2pQ4xrq=ZJc9rBsqdL2B7nJf-_p6+R3Tg@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] x86: KVM: svm: avoid flooding logs when
 skip_emulated_instruction() fails
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 20, 2019 at 4:02 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> When we're unable to skip instruction with kvm_emulate_instruction() we
> will not advance RIP and most likely the guest will get stuck as
> consequitive attempts to execute the same instruction will likely result
> in the same behavior.
>
> As we're not supposed to see these messages under normal conditions, switch
> to pr_err_once().
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
