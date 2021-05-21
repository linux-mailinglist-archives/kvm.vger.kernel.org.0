Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCFC838CBF9
	for <lists+kvm@lfdr.de>; Fri, 21 May 2021 19:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbhEURWm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 May 2021 13:22:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55625 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230145AbhEURWl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 May 2021 13:22:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621617677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qwR/0GNmU1erDIzfTwdpHCjLZxYNU+OZQVJXmXfAYfM=;
        b=W5fWme5Hd+Jcv5dARmQY20ECe0ju151UZ2O4BRqkF9W7SpHktRUhD452X9/vUAxRBtNVxy
        kCb+SSt1RjAeP0VBG0j9twQuC+M0EKckf8fiOi48pwgVw77eUXZd04NbKtCIAZJYgBch0d
        i6gzM/MpCDuLtqoC/M1TI39U0pQ/UiE=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-593-EkDu_OJKOW6u_LEMrJaaIQ-1; Fri, 21 May 2021 13:21:16 -0400
X-MC-Unique: EkDu_OJKOW6u_LEMrJaaIQ-1
Received: by mail-ej1-f69.google.com with SMTP id x20-20020a1709061354b02903cff4894505so6456545ejb.14
        for <kvm@vger.kernel.org>; Fri, 21 May 2021 10:21:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qwR/0GNmU1erDIzfTwdpHCjLZxYNU+OZQVJXmXfAYfM=;
        b=b3hqNUe38zFEUtCpYLfwsxofMAyJbBJdRkbsagdPyuHyrlYOS5Wrb7PJp8ZCIh11Fy
         +wZ1Moq8a35YO9fOcMJGfYctN5MmI41cPnuGVBKQtXQzL4ySalohzaITErNc5LYYpwqO
         2I81+8jAB3yyWtkvdBk67tqfPiZMh0thq8gB/qCTGr0Y/Pr9cjj1KqyfnShM66D6/FYU
         qQOFBWKc6MTg+s5LbOKj1zwXTHSXDthFHCpPNqeHuFLwAlMx4eiJAuLrbcMdIW1PCFiB
         QEbSIOmZMSS1Lx2JWg9F6oHefR+GUaNGBO4Pw0F3IbsE3vEle+i7SLuxrq6PEUf8WR89
         asvA==
X-Gm-Message-State: AOAM5301UodRssWrLNd0Sui1XYT/+uVFeAXE9xAhmHoMcVCakL4Wz7RK
        grozVqYQ9BgMok+roj5po4yHANywbW9VMjoswxDMkuWrNPR8XlLSLMA2xbYK8wA6wZkCcHWw3B6
        TdvvJGQsekO2i
X-Received: by 2002:aa7:cd03:: with SMTP id b3mr12350067edw.206.1621617675166;
        Fri, 21 May 2021 10:21:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxs1PPEtRit2YsbPl3fyEJzFG+BMaVTPI5cJbO+TcDqnJ8UNSbmnYU1JgZsPGIv6fh/e498XA==
X-Received: by 2002:aa7:cd03:: with SMTP id b3mr12350048edw.206.1621617675016;
        Fri, 21 May 2021 10:21:15 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id m12sm4079494edc.40.2021.05.21.10.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 10:21:14 -0700 (PDT)
To:     Palmer Dabbelt <palmerdabbelt@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     anup@brainfault.org, Anup Patel <Anup.Patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, corbet@lwn.net, graf@amazon.com,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev
References: <mhng-37377fcb-af8f-455c-be08-db1cd5d4b092@palmerdabbelt-glaptop>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v18 00/18] KVM RISC-V Support
Message-ID: <ff55329c-709d-c1a5-a807-1942f515bba7@redhat.com>
Date:   Fri, 21 May 2021 19:21:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <mhng-37377fcb-af8f-455c-be08-db1cd5d4b092@palmerdabbelt-glaptop>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/05/21 19:13, Palmer Dabbelt wrote:
>> 
> 
> I don't view this code as being in a state where it can be
> maintained, at least to the standards we generally set within the
> kernel.  The ISA extension in question is still subject to change, it
> says so right at the top of the H extension 
> <https://github.com/riscv/riscv-isa-manual/blob/master/src/hypervisor.tex#L4>
> 
>   {\bf Warning! This draft specification may change before being 
>   accepted as standard by the RISC-V Foundation.}

To give a complete picture, the last three relevant changes have been in
August 2019, November 2019 and May 2020.  It seems pretty frozen to me.

In any case, I think it's clear from the experience with Android that
the acceptance policy cannot succeed.  The only thing that such a policy
guarantees, is that vendors will use more out-of-tree code.  Keeping a
fully-developed feature out-of-tree for years is not how Linux is run.

> I'm not sure where exactly the line for real hardware is, but for
> something like this it would at least involve some chip that is
> widely availiable and needs the H extension to be useful

Anup said that "quite a few people have already implemented RISC-V
H-extension in hardware as well and KVM RISC-V works on real HW as 
well".  Those people would benefit from having KVM in the Linus tree.

Paolo

