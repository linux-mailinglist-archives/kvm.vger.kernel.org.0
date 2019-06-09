Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE8E3A486
	for <lists+kvm@lfdr.de>; Sun,  9 Jun 2019 11:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbfFIJhX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jun 2019 05:37:23 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:55126 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727720AbfFIJhX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jun 2019 05:37:23 -0400
Received: by mail-wm1-f51.google.com with SMTP id g135so5804344wme.4
        for <kvm@vger.kernel.org>; Sun, 09 Jun 2019 02:37:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N/JT6wxx8SnEUHFdFMXDjIDadpkBg6G764joNYPh7l8=;
        b=rfSsX6rFs3jNsZUnhny8bBYoLkvb3wn9pbFy7raGbWuKiZZY7rRTwIEHpY7cbI6haG
         QBP9xpjfKrDJU3Wtj3Cujj1R8TIfSZDujPg6YXbeUX+aYAM12nqMFDGYAoMvkyAa28eq
         grWf8osu0Wpdpz+vIu6qSB30OWmPHNvEqH9scN5Ll8+oSCDVxUwrbi3HCJrc/3RDkhU4
         590jOBPhMu0gGc+WerZPIHz4v6UPCUztTB7wiVRcCgNLZksNvTiRfGM2hs26EeiCAbZB
         Sh8DMEwzL4w1kUEaNxeP2P3xs/aA/TGYKtJJgv73nSUZRDbt252zyJGVIefCruWld9bf
         nhlw==
X-Gm-Message-State: APjAAAVmD+o6F0p9lTPWuEVKHrKWoifhPxTZD2nHjgSL3x+4p/0L3+s1
        +TJhTPQT5cATlqixS+OHml/Akg==
X-Google-Smtp-Source: APXvYqyAtJD90KBreJ8YMy512INUJXccvzCGcpA/XJQQf/F7Ze/ETljJlq57FHnss/Ayp0CtUHfiww==
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr9949310wmc.77.1560073041026;
        Sun, 09 Jun 2019 02:37:21 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8cc3:8abd:4519:2cd6? ([2001:b07:6468:f312:8cc3:8abd:4519:2cd6])
        by smtp.gmail.com with ESMTPSA id b5sm7097123wru.69.2019.06.09.02.37.20
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 09 Jun 2019 02:37:20 -0700 (PDT)
Subject: Re: Reference count on pages held in secondary MMUs
To:     Christoffer Dall <christoffer.dall@arm.com>, kvm@vger.kernel.org
Cc:     aarcange@redhat.com, kvmarm@lists.cs.columbia.edu
References: <20190609081805.GC21798@e113682-lin.lund.arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3ca445bb-0f48-3e39-c371-dd197375c966@redhat.com>
Date:   Sun, 9 Jun 2019 11:37:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190609081805.GC21798@e113682-lin.lund.arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/19 10:18, Christoffer Dall wrote:
> In some sense, we are thus maintaining a 'hidden', or internal,
> reference to the page, which is not counted anywhere.
> 
> I am wondering if it would be equally valid to take a reference on the
> page, and remove that reference when unmapping via MMU notifiers, and if
> so, if there would be any advantages/drawbacks in doing so?

If I understand correctly, I think the MMU notifier would not fire if
you took an actual reference; the page would be pinned in memory and
could not be swapped out.

Paolo
