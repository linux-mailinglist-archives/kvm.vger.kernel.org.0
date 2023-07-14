Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC285752F7F
	for <lists+kvm@lfdr.de>; Fri, 14 Jul 2023 04:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbjGNCk3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+kvm@lfdr.de>); Thu, 13 Jul 2023 22:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjGNCk3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 22:40:29 -0400
X-Greylist: delayed 388 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 13 Jul 2023 19:40:27 PDT
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6EB622121;
        Thu, 13 Jul 2023 19:40:27 -0700 (PDT)
Received: from [IPv6:::1] (localhost.localdomain [127.0.0.1])
        by gate.crashing.org (8.14.1/8.14.1) with ESMTP id 36E2WobL023295;
        Thu, 13 Jul 2023 21:32:50 -0500
Message-ID: <2838d716b08c78ed24fdd3fe392e21222ee70067.camel@kernel.crashing.org>
Subject: VFIO (PCI) and write combine mapping of BARs
From:   Benjamin Herrenschmidt <benh@kernel.crashing.org>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, alex.williamson@redhat.com,
        osamaabb@amazon.com, linux-pci@vger.kernel.org,
        Clint Sbisa <csbisa@amazon.com>
Date:   Fri, 14 Jul 2023 12:32:49 +1000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.4-0ubuntu1 
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Folks !

I'd like to revive an old discussion as we (Amazon Linux) have been
getting asks for it.

What's the best interface to provide the option of write combine mmap's
of BARs via VFIO ?

The problem isn't so much the low level implementation, we just have to
play with the pgprot, the question is more around what API to present
to control this.

One trivial way would be to have an ioctl to set a flag for a given
region/BAR that cause subsequent mmap's to use write-combine. We would
have to keep a bitmap for the "legacy" regions, and use a flag in
struct vfio_pci_region for the others.

One potentially better way is to make it strictly an attribute of
vfio_pci_region, along with an ioctl that creates a "subregion". The
idea here is that we would have an ioctl to create a region from an
existing region dynamically, which represents a subset of the original
region (typically a BAR), with potentially different attributes (or we
keep the attribute get/set separate).

I like the latter more because it will allow to more easily define that
portions of a BAR can need different attributes without causing
state/race issues between setting the attribute and mmap.

This will also enable other attributes than write-combine if/when the
need arises.

Any better idea ? thoughs ? objections ?

This is still quite specific to PCI, but so is the entire regions
mechanism, so I don't see an easy path to something more generic at
this stage.

Cheers,
Ben.

