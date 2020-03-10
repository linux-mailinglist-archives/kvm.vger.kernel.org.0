Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66877180C9E
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 00:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgCJXvw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Mar 2020 19:51:52 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:43479 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgCJXvw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Mar 2020 19:51:52 -0400
Received: by mail-io1-f65.google.com with SMTP id n21so32988ioo.10
        for <kvm@vger.kernel.org>; Tue, 10 Mar 2020 16:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8SPXllyhY9qBgfU5KxOjh1PIYsjxfdd5RYvm6TNpnvI=;
        b=kE6Q3SP9HJN++OjEi8Kp1rMh+YdafYPKlokFHIart6N3G8zximJUE7VIvViLh2aSNN
         xwSg/iFsbZZ7kx4+LzEu4K2f/Pkpn2PZuwKyEQW3K0FsM4tugihkAFRHEfHDcbStoNq8
         fDGY5YnPR04DEmaftDpyannPaIq9cvpVRZQOl90nMdvIh8olNtBoqd+waaqbRclELvvR
         gqUfNtOx3fOVNyqDsPYuovUgTO9AkQFL2OEx2GGCLmdCPmpQTz1cPMrDzlpOdi8CTaR9
         e8Q22hUhMMmkjijIItXCE8ikmqAtrst2MMmqrU3HsUBSV9ckqfZJ75qounPkJLlCzKR+
         E0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8SPXllyhY9qBgfU5KxOjh1PIYsjxfdd5RYvm6TNpnvI=;
        b=k5+R/mbQsx6+jwEeXGO2rlV/HZHWuwhYm3cUBJwFaCWJyQ+fzk4s+I9KFSRpauoiZ3
         b6YS6HthjyvZwRDAwDGNMUcz+zNCvOq5UUXiL1n+sdWs3y/T/k/+FG3q7++ZRjh7JV+l
         8UA/wOi/4F2FhgsiF67fcOBZs7qrlitK67wtDwkMZySjNwPrvuB9Pve8+54+joxndqcB
         z5e8Ohic4OgqkUDU+S1yOifsbX1vTjMbep3e/UbTBDho8ENHEQNuhby+T4sQAEWdbMmi
         /9sATQVzp/yTMLwrotxAciDrP7sPh77svGOFhJMVF1KKaVWFjT4RjAFiQXuEPykSIlT1
         F5JQ==
X-Gm-Message-State: ANhLgQ3YNTXm4qGsOTRpT/A67dH20RPQZnBHkWoWRtuZgbMql3LzM2Z0
        f6XKlvDbRcsTi86pLLAbRUAZwXQX5l7MJiNy1M1uoA==
X-Google-Smtp-Source: ADFU+vsLUBKM0uwvZy+15P2P/7VwHgZd/43BeyMe4wXBIEK1G6aHJp97mh20WooAdpBHF6fBTc5ZHfRvvOIzFk2QsL4=
X-Received: by 2002:a02:9081:: with SMTP id x1mr592669jaf.75.1583884311500;
 Tue, 10 Mar 2020 16:51:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
In-Reply-To: <20200310225149.31254-1-krish.sadhukhan@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 10 Mar 2020 16:51:40 -0700
Message-ID: <CALMp9eR9hL9OQPBfekDbRAFHx5j-wgBcijjAV0T22NGoSpxpdA@mail.gmail.com>
Subject: Re: [PATCH] kvm-unit-test: nVMX: Test Selector and Base Address
 fields of Guest Segment registers
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 10, 2020 at 4:29 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
> Even thought today's x86 hardware uses paging and not segmentation for memory
> management, it is still good to have some tests that can verify the sanity of
> the segment register fields on vmentry of nested guests.
>
> The test on SS Selector field is failing because the hardware (I am using
> Intel Xeon Platinum 8167M 2.00GHz) doesn't raise any error even if the
> prescribed bit pattern is not set and as a result vmentry succeeds.

Are you sure this isn't just an L0 bug? For instance, does your L0 set
"unrestricted guest" in vmcs02, even when L1 doesn't set it in vmcs12?
