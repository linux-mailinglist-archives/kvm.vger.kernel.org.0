Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 307E75827B8
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 15:31:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbiG0Nbb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 09:31:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbiG0Nb3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 09:31:29 -0400
Received: from proxmox-new.maurer-it.com (proxmox-new.maurer-it.com [94.136.29.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C050EE23;
        Wed, 27 Jul 2022 06:31:27 -0700 (PDT)
Received: from proxmox-new.maurer-it.com (localhost.localdomain [127.0.0.1])
        by proxmox-new.maurer-it.com (Proxmox) with ESMTP id 26CEA43AFC;
        Wed, 27 Jul 2022 15:31:26 +0200 (CEST)
Date:   Wed, 27 Jul 2022 15:31:24 +0200
From:   Stoiko Ivanov <s.ivanov@proxmox.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, bgardon@google.com,
        Jim Mattson <jmattson@google.com>, t.lamprecht@proxmox.com
Subject: Re: [PATCH] KVM: x86: enable TDP MMU by default
Message-ID: <20220727153124.1afdad67@rosa.proxmox.com>
In-Reply-To: <20dcddad9f6c8384c49f9d8ec95a826df35fc92d.camel@redhat.com>
References: <20210726163106.1433600-1-pbonzini@redhat.com>
        <20220726165748.76db5284@rosa.proxmox.com>
        <ffc99463-6a61-8694-6a4e-3162580f94ee@redhat.com>
        <20dcddad9f6c8384c49f9d8ec95a826df35fc92d.camel@redhat.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Jul 2022 13:22:48 +0300
Maxim Levitsky <mlevitsk@redhat.com> wrote:

> On Tue, 2022-07-26 at 17:43 +0200, Paolo Bonzini wrote:
> > On 7/26/22 16:57, Stoiko Ivanov wrote:  
> > > Hi,
> > > 
> > > Proxmox[0] recently switched to the 5.15 kernel series (based on the one
> > > for Ubuntu 22.04), which includes this commit.
> > > While it's working well on most installations, we have a few users who
> > > reported that some of their guests shutdown with
> > > `KVM: entry failed, hardware error 0x80000021` being logged under certain
> > > conditions and environments[1]:
> > > * The issue is not deterministically reproducible, and only happens
> > >    eventually with certain loads (e.g. we have only one system in our
> > >    office which exhibits the issue - and this only by repeatedly installing
> > >    Windows 2k22 ~ one out of 10 installs will cause the guest-crash)
> > > * While most reports are referring to (newer) Windows guests, some users
> > >    run into the issue with Linux VMs as well
> > > * The affected systems are from a quite wide range - our affected machine
> > >    is an old IvyBridge Xeon with outdated BIOS (an equivalent system with
> > >    the latest available BIOS is not affected), but we have
> > >    reports of all kind of Intel CPUs (up to an i5-12400). It seems AMD CPUs
> > >    are not affected.
> > > 
> > > Disabling tdp_mmu seems to mitigate the issue, but I still thought you
> > > might want to know that in some cases tdp_mmu causes problems, or that you
> > > even might have an idea of how to fix the issue without explicitly
> > > disabling tdp_mmu?  
> > 
> > If you don't need secure boot, you can try disabling SMM.  It should not 
> > be related to TDP MMU, but the logs (thanks!) point at an SMM entry (RIP 
> > = 0x8000, CS base=0x7ffc2000).  
> 
> No doubt about it. It is the issue.
> 
> > 
> > This is likely to be fixed by 
> > https://lore.kernel.org/kvm/20220621150902.46126-1-mlevitsk@redhat.com/.
Thanks to both of you for the quick feedback and the patches!

We ran our reproducer with the patch-series above applied on top of
5.19-rc8 from
git://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/linux/+git/kinetic
* without the patches the issue occurred within 20 minutes,
* with the patches applied issues did not occur for 3 hours (it usually
  does within 1-2 hours at most)

so fwiw it seems to fix the issue on our setup.
we'll do some more internal tests and would then make this available
(backported to our 5.15 kernel) to our users, who are affected by this.

Kind regards,
stoiko


