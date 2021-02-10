Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADEDD31650D
	for <lists+kvm@lfdr.de>; Wed, 10 Feb 2021 12:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231447AbhBJLVA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Feb 2021 06:21:00 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:8702 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhBJLSi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Feb 2021 06:18:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1612955918; x=1644491918;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=39nDYrTke6Yq8uhjpYDqR4C8vhoesUJmMcMZ0GAw5uQ=;
  b=bDNrmdWkaF6njFksRdwqraW+BkxhaJs3ZDL0I/OH6yVj/5ZZESTmZ+q+
   MEe47QP6JEqymjoFbdBw1dPy9XNqe1tOuYuE4+S8ai2fB1AISWVa5xLnh
   Pwj0phTo31aaHoZxGTkKCkC9xb50wc94An+DaLHue/5l8aEryU6/HR+fC
   E=;
X-IronPort-AV: E=Sophos;i="5.81,168,1610409600"; 
   d="scan'208";a="84079494"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 10 Feb 2021 11:17:50 +0000
Received: from EX13MTAUWC002.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-74cf8b49.us-east-1.amazon.com (Postfix) with ESMTPS id 6B303C0190;
        Wed, 10 Feb 2021 11:17:46 +0000 (UTC)
Received: from EX13D20UWC001.ant.amazon.com (10.43.162.244) by
 EX13MTAUWC002.ant.amazon.com (10.43.162.240) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Feb 2021 11:17:45 +0000
Received: from freeip.amazon.com (10.43.160.66) by
 EX13D20UWC001.ant.amazon.com (10.43.162.244) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 10 Feb 2021 11:17:41 +0000
Subject: Re: [RFC PATCH 0/2] Introduce a way to adjust CLOCK_BOOTTIME from
 userspace for VM guests
To:     Hikaru Nishida <hikalium@chromium.org>,
        <linux-kernel@vger.kernel.org>
CC:     <suleiman@google.com>, Andra Paraschiv <andraprs@amazon.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        KVM list <kvm@vger.kernel.org>, <mtosatti@redhat.com>
References: <20210210103908.1720658-1-hikalium@google.com>
From:   Alexander Graf <graf@amazon.com>
Message-ID: <d9127c33-e067-9b49-5985-0b09e3ede279@amazon.com>
Date:   Wed, 10 Feb 2021 12:17:37 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210210103908.1720658-1-hikalium@google.com>
Content-Language: en-US
X-Originating-IP: [10.43.160.66]
X-ClientProxiedBy: EX13D03UWA002.ant.amazon.com (10.43.160.144) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)
Content-Type: text/plain; charset="windows-1252"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10.02.21 11:39, Hikaru Nishida wrote:
> =

> From: Hikaru Nishida <hikalium@chromium.org>
> =

> =

> Hi folks,
> =

> We'd like to add a sysfs interface that enable us to advance
> CLOCK_BOOTTIME from userspace. The use case of this change is that
> adjusting guest's CLOCK_BOOTTIME as host suspends to ensure that the
> guest can notice the device has been suspended.
> We have an application that rely on the difference between
> CLOCK_BOOTTIME and CLOCK_MONOTONIC to detect whether the device went
> suspend or not. However, the logic did not work well on VM environment
> since most VMs are pausing the VM guests instead of actually suspending
> them on the host's suspension.
> With following patches, we can adjust CLOCK_BOOTTIME without actually
> suspending guest and make the app working as intended.
> I think this feature is also useful for other VM solutions since there
> was no way to do this from userspace.
> =

> As far as I checked, it is working as expected but is there any concern
> about this change? If so, please let me know.

I don't fully grasp why you want the guest to manually adjust its =

CLOCK_BOOTTIME. Wouldn't it make more sense to extend kvmclock's notion =

of wall clock time to tell you about suspended vs executed wall clock?


Alex




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



