Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1F778D968
	for <lists+kvm@lfdr.de>; Wed, 30 Aug 2023 20:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237073AbjH3SdE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Aug 2023 14:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240568AbjH3GoX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Aug 2023 02:44:23 -0400
Received: from torres.zugschlus.de (torres.zugschlus.de [IPv6:2a01:238:42bc:a101::2:100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9399194;
        Tue, 29 Aug 2023 23:44:19 -0700 (PDT)
Received: from mh by torres.zugschlus.de with local (Exim 4.96)
        (envelope-from <mh+linux-kernel@zugschlus.de>)
        id 1qbEw3-002tne-1d;
        Wed, 30 Aug 2023 08:44:15 +0200
Date:   Wed, 30 Aug 2023 08:44:15 +0200
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
Message-ID: <ZO7lP1JKa7ptcFUP@torres.zugschlus.de>
References: <ZO2RlYCDl8kmNHnN@torres.zugschlus.de>
 <ZO2piz5n1MiKR-3-@debian.me>
 <ZO3sA2GuDbEuQoyj@torres.zugschlus.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZO3sA2GuDbEuQoyj@torres.zugschlus.de>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

while debugging in the direction of qemu/kvm continues, I think that
this is an actual problem with the serial code.

On Tue, Aug 29, 2023 at 03:00:51PM +0200, Marc Haber wrote:
> my bisect came out at
> 84a9582fd203063cd4d301204971ff2cd8327f1a being the first bad commit.
> This is a rather big one, that does not easily back out of the 6.5
> release. Sadly, just transplanting drivers/tty/serial from a 6.4.12 tree
> doesn't even build. I'm adding Tony Lindgren, the author of the commit,
> to the Cc list.

Last night, I tried hard to roll back that commit and ended up with
doing

git checkout v6.5
git checkout 84a9582fd2^ -- drivers/tty/serial/
git checkout 84a9582fd2^ -- include/linux/serial_8250.h
git checkout 84a9582fd2^ -- include/linux/serial_core.h

which resulted in a 6.5 kernel that actually works without obvious
regression on the VM in question.

Thanks to Hilko Bengen and Bastian Blank who helped with the git
gymnastics and with understanding the patch in question. I wouldn't have
been able to roll that back without their help.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Leimen, Germany    |  lose things."    Winona Ryder | Fon: *49 6224 1600402
Nordisch by Nature |  How to make an American Quilt | Fax: *49 6224 1600421
