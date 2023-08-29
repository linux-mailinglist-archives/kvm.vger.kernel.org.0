Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D7DC78C4BE
	for <lists+kvm@lfdr.de>; Tue, 29 Aug 2023 15:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235262AbjH2NCx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Aug 2023 09:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbjH2NCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Aug 2023 09:02:42 -0400
X-Greylist: delayed 103 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 29 Aug 2023 06:02:39 PDT
Received: from torres.zugschlus.de (torres.zugschlus.de [IPv6:2a01:238:42bc:a101::2:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A808EBF;
        Tue, 29 Aug 2023 06:02:39 -0700 (PDT)
Received: from mh by torres.zugschlus.de with local (Exim 4.96)
        (envelope-from <mh+linux-kernel@zugschlus.de>)
        id 1qayKx-002WmK-1M;
        Tue, 29 Aug 2023 15:00:51 +0200
Date:   Tue, 29 Aug 2023 15:00:51 +0200
From:   Marc Haber <mh+linux-kernel@zugschlus.de>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: Linux 6.5 speed regression, boot VERY slow with anything systemd
 related
Message-ID: <ZO3sA2GuDbEuQoyj@torres.zugschlus.de>
References: <ZO2RlYCDl8kmNHnN@torres.zugschlus.de>
 <ZO2piz5n1MiKR-3-@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZO2piz5n1MiKR-3-@debian.me>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[Please keep me on Cc, I am only subscribed to linux-kernel]

Hi Bagas,

thanks for your quick answer.

On Tue, Aug 29, 2023 at 03:17:15PM +0700, Bagas Sanjaya wrote:
> In any case, bisecting kernel is highly appreciated in order to pin down
> the culprit.

Without having read the docs (that came too late, need to read up on
that again), my bisect came out at
84a9582fd203063cd4d301204971ff2cd8327f1a being the first bad commit.
This is a rather big one, that does not easily back out of the 6.5
release. Sadly, just transplanting drivers/tty/serial from a 6.4.12 tree
doesn't even build. I'm adding Tony Lindgren, the author of the commit,
to the Cc list.

But, since the commit is related to serial port, I began fiddling around
with the serial port setting on the misbehaving VM and found out that
running the VM without the serial console that I am using (thus removing
"console=ttyS0,57600n8" from the kernel command line) makes the machine
boot up just fine with the 6.5 kernel that I built yesterday. It is not
even necessary to remove the virtual serial port.

The issue is still somehow connected to the host the machine is running
on, since my VMs all have a serial console and the test VMs running on
different hosts are running fine with 6.5.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
