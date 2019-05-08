Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2398182A6
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 01:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727623AbfEHXVV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 19:21:21 -0400
Received: from mail-it1-f182.google.com ([209.85.166.182]:54329 "EHLO
        mail-it1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfEHXVV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 19:21:21 -0400
Received: by mail-it1-f182.google.com with SMTP id a190so460847ite.4
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 16:21:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2G/qPyOLlddrXZzJkN3Q3iXVgoS23yR8dAbQAMl7uH0=;
        b=wFJAtQmaWIxIY8ee0TtVxC5pYEKhSFQUknspDYunT0XNFolWSFGzULzhvEPUp5jYUN
         DST52XcL8TwK65CDBSfANAexVFO6US9fPdrEy8YmtdWdGgOmHqXzKuR76Sd6qLP2DeN+
         LEiL8mdwLbgtaBpHN9uMihA4vO+HincMCU7W1lnaihbFFoKVyrOxra4Gx9ck4s/sNrvr
         ji9l5OZ5FqEEiwudK9eVmyzPv8Ky5Dx4Ccb+dvEjlhkSve0MfvUx4XMkNClifcZLe22A
         ywVoSAhXS46SKSKfJdiBnxmhEkDHv+3JGzriFJLGgaqainLwkLuh6WRFUZJUSjhLG4uB
         y+sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2G/qPyOLlddrXZzJkN3Q3iXVgoS23yR8dAbQAMl7uH0=;
        b=NG/Z/81KUAndqPbEJnjN3JGEVUI6cG6tvgGqCf+HDRLLlJfLFHHodlTYly3kf5gS9D
         slcGB+u6u8/k8azJFUV8dYNislqQltyZTqomq6UVNyyu997MAaQeMLwGvT4S+F1ZyjkV
         QFd3upaGiJsPbAbaWN2nuyjAY5GpiT0wTEedzNeVbPwpEIpCp5yfl4cayH+kSz4oCIhi
         dST3RvgyzJi9XVb85Ft1+Cbfq7DiTPrllTEa3GpDh3d7WNgqxGDYuNGJBa5qObXwDTIs
         OElyeKbmHeWJ2ZgPXANF3fAc+bH5oYubjWhcBGW+ET5wFGr/p/xpMOiMR+WdhWBHJcAE
         zZ9w==
X-Gm-Message-State: APjAAAXZV+3wnTPPu9zMirmWRbVKq2W3TDqC+PjBydzksObupnfV63u3
        EZE+XaNTG5VGBhg9F/lo4NJ0VLxFrKrAhr1lGauftA==
X-Google-Smtp-Source: APXvYqytjwNExZw3cx6ijFEVE1rNal/6mXNs5IEJYS/dBzhjSIj4wTI2yLv5RD1lSVoUS0ostlzGgEs2aescpAjs+kM=
X-Received: by 2002:a02:1384:: with SMTP id 126mr598921jaz.72.1557357680065;
 Wed, 08 May 2019 16:21:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190508102715.685-1-namit@vmware.com> <20190508102715.685-3-namit@vmware.com>
In-Reply-To: <20190508102715.685-3-namit@vmware.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 8 May 2019 16:21:08 -0700
Message-ID: <CALMp9eTE8vsrSC0K7KVArT_KFA_NGBZ5t6eW_Gh8cdJ_88JM+Q@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 2/2] x86: nVMX: Set guest as active after
 NMI/INTR-window tests
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Nadav Amit <nadav.amit@gmail.com>
Date: Wed, May 8, 2019 at 10:47 AM
To: Paolo Bonzini
Cc: <kvm@vger.kernel.org>, Nadav Amit, Jim Mattson, Sean Christopherson

> From: Nadav Amit <nadav.amit@gmail.com>
>
> Intel SDM 26.6.5 says regarding interrupt-window exiting that: "These
> events wake the logical processor if it just entered the HLT state
> because of a VM entry." A similar statement is told about NMI-window
> exiting.
>
> However, running tests which are similar to verify_nmi_window_exit() and
> verify_intr_window_exit() on bare-metal suggests that real CPUs do not
> wake up. Until someone figures what the correct behavior is, just reset
> the activity state to "active" after each test to prevent the whole
> test-suite from getting stuck.
>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Nadav Amit <nadav.amit@gmail.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

I think I have been assuming that "wake the logical processor" means
"causes the logical processor to enter the 'active' activity state."
Maybe that's not what "wake" means?
