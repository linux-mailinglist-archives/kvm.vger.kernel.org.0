Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F54521AFFD
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 09:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgGJHVl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 03:21:41 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42001 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726664AbgGJHVk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 10 Jul 2020 03:21:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594365698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=thZZhjE96lspt7ZWi/AjVIw8iXBnP2Haw9UKtlJ1Dbo=;
        b=cjpEc0fnNItHvJPMn/hJw/Ml3KtcO1MVC+hZsxbflqX1ZNx5phbqtm+Xr9V0S0noJ+sfAI
        620pkIdRsgwF4TXmTJAaLtIpPk4LB7GIdDM8bZDPX0xD305zGbunqUmkDYDzEwWXYFdVK6
        g2T3F5cmPEgc+F7drBUX313iyFWKnd8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-244-C6UrREDIMsCrxN5BbX9tiQ-1; Fri, 10 Jul 2020 03:21:37 -0400
X-MC-Unique: C6UrREDIMsCrxN5BbX9tiQ-1
Received: by mail-wr1-f70.google.com with SMTP id w4so4965168wrm.5
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 00:21:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=thZZhjE96lspt7ZWi/AjVIw8iXBnP2Haw9UKtlJ1Dbo=;
        b=ABr4J/rA7qfA9nZMGe3QARKYkQ/ksbDM+j33gN/uDlJfLJdGHSf8gFy75YnB7WxKjK
         /xJu7Hr8lj4xWtce1Vis7Ml5O9MCiEwSQRQAGmZQc+/8buQF5FYyCl9J/9q76q+A6hOW
         TP8p5YX5Nn6j3veqevp714N1Ru0pbKDJtBR1o8SFLIvie1auH71Fn7vG8vxcPuO9DJRF
         O2jkCAe8n2Bt2TRKMrfUUAG1xuutySzxpnIIInqHrziQ6GOnUiTU3Ys7wEPh7U97llBy
         XAfBfkEO/S5gsZH3kmEeX5sYMXILuXU+44IwEwbkB6/SQbj+Gm5+rbwtwkfYWZ9jQjOq
         BuVw==
X-Gm-Message-State: AOAM532fHKa/cCaXDRGfSrz9jESh9Nfa443fKkUYvnI8CXXz7dbjd4iZ
        tZyh7hClCWuFpHhX01ymGs6WfS7bgn7Ezd7Nv/ac+x4SO2QntjeeCsrJqupqlFOuXql7PxkS5LM
        R4Yx8MIOdsnbv
X-Received: by 2002:a7b:cf2b:: with SMTP id m11mr3784723wmg.110.1594365696041;
        Fri, 10 Jul 2020 00:21:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztrqfFhLUoPqzGe81U1WJL4B0m7Zi1Hwk37qAkI4LJiFVNWEfsHtmUroXU+sw+Zb85GHLflA==
X-Received: by 2002:a7b:cf2b:: with SMTP id m11mr3784712wmg.110.1594365695812;
        Fri, 10 Jul 2020 00:21:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id w7sm8311083wmc.32.2020.07.10.00.21.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 00:21:35 -0700 (PDT)
Subject: Re: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR
 for hosts that don't support it
To:     Jim Mattson <jmattson@google.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Cc:     =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, mtosatti@redhat.com,
        Pedro Principeza <pedro.principeza@canonical.com>,
        kvm list <kvm@vger.kernel.org>, libvir-list@redhat.com,
        Dann Frazier <dann.frazier@canonical.com>,
        Guilherme Piccoli <gpiccoli@canonical.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Christian Ehrhardt <christian.ehrhardt@canonical.com>,
        qemu-devel@nongnu.org, Mohammed Gamal <mgamal@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>, fw@gpiccoli.net,
        rth@twiddle.net
References: <20200619155344.79579-1-mgamal@redhat.com>
 <20200619155344.79579-3-mgamal@redhat.com>
 <20200708171621.GA780932@habkost.net> <20200708172653.GL3229307@redhat.com>
 <20200709094415.yvdh6hsfukqqeadp@sirius.home.kraxel.org>
 <CALMp9eQnrdu-9sZhW3aXpK4pizOW=8G=bj1wkumSgHVNfG=CbQ@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c81254b6-e6ae-9d2e-917c-4ce42c8baab0@redhat.com>
Date:   Fri, 10 Jul 2020 09:21:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eQnrdu-9sZhW3aXpK4pizOW=8G=bj1wkumSgHVNfG=CbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 19:00, Jim Mattson wrote:
>>
>>     Mostly fine.  Some edge cases, like different page fault errors for
>>     addresses above GUEST_MAXPHYADDR and below HOST_MAXPHYADDR.  Which I
>>     think Mohammed fixed in the kernel recently.
> Doesn't this require intercepting MOV-to-CR3 when the guest is in PAE
> mode, so that the hypervisor can validate the high bits in the PDPTEs?

In theory yes, but in practice it just means we'd use the AMD behavior
of loading guest PDPT entries on demand during address translation
(because the PDPT would point to nonexistent memory and cause an EPT
violation on the PDE).

Paolo

