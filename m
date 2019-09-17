Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C4DB52DE
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 18:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfIQQXv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 12:23:51 -0400
Received: from mx01.bbu.dsd.mx.bitdefender.com ([91.199.104.161]:46258 "EHLO
        mx01.bbu.dsd.mx.bitdefender.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726741AbfIQQXv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Sep 2019 12:23:51 -0400
Received: from smtp.bitdefender.com (smtp01.buh.bitdefender.com [10.17.80.75])
        by mx01.bbu.dsd.mx.bitdefender.com (Postfix) with ESMTPS id B7930307489B;
        Tue, 17 Sep 2019 19:23:48 +0300 (EEST)
Received: from localhost (unknown [195.210.4.22])
        by smtp.bitdefender.com (Postfix) with ESMTPSA id 9F14130BC822;
        Tue, 17 Sep 2019 19:23:48 +0300 (EEST)
From:   Adalbert =?iso-8859-2?b?TGF643I=?= <alazar@bitdefender.com>
Subject: Re: [PATCH v5 0/9] Enable Sub-page Write Protection Support
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Yang Weijiang <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        mst@redhat.com, rkrcmar@redhat.com, jmattson@google.com,
        yu.c.zhang@intel.com
In-Reply-To: <20190917125904.GB22162@char.us.oracle.com>
References: <20190917085304.16987-1-weijiang.yang@intel.com>
        <20190917125904.GB22162@char.us.oracle.com>
Date:   Tue, 17 Sep 2019 19:24:15 +0300
Message-ID: <15687374550.b5d3c.30742@host>
User-agent: void
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 17 Sep 2019 08:59:04 -0400, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Tue, Sep 17, 2019 at 04:52:55PM +0800, Yang Weijiang wrote:
> > EPT-Based Sub-Page write Protection(SPP)is a HW capability which allows
> > Virtual Machine Monitor(VMM) to specify write-permission for guest
> > physical memory at a sub-page(128 byte) granularity. When this
> > capability is enabled, the CPU enforces write-access check for sub-pages
> > within a 4KB page.
> > 
> > The feature is targeted to provide fine-grained memory protection for
> > usages such as device virtualization, memory check-point and VM
> > introspection etc.
> > 
> > SPP is active when the "sub-page write protection" (bit 23) is 1 in
> > Secondary VM-Execution Controls. The feature is backed with a Sub-Page
> > Permission Table(SPPT), SPPT is referenced via a 64-bit control field
> > called Sub-Page Permission Table Pointer (SPPTP) which contains a
> > 4K-aligned physical address.
> > 
> > To enable SPP for certain physical page, the gfn should be first mapped
> > to a 4KB entry, then set bit 61 of the corresponding EPT leaf entry. 
> > While HW walks EPT, if bit 61 is set, it traverses SPPT with the guset
> > physical address to find out the sub-page permissions at the leaf entry.
> > If the corresponding bit is set, write to sub-page is permitted,
> > otherwise, SPP induced EPT violation is generated.
> > 
> > This patch serial passed SPP function test and selftest on Ice-Lake platform.
> > 
> > Please refer to the SPP introduction document in this patch set and
> > Intel SDM for details:
> > 
> > Intel SDM:
> > https://software.intel.com/sites/default/files/managed/39/c5/325462-sdm-vol-1-2abcd-3abcd.pdf
> > 
> > SPP selftest patch:
> > https://lkml.org/lkml/2019/6/18/1197
> > 
> > Previous patch:
> > https://lkml.org/lkml/2019/8/14/97
> 
> I saw the patches as part of the introspection patch-set.
> Are you all working together on this?

Weijiang helped us to start using the SPP feature with the introspection
API and tested the integration when we didn't had the hardware
available. I've included the SPP patches in the introspection patch
series in order to "show the full picture".

> Would it be possible for some of the bitdefender folks who depend on this
> to provide Tested-by adn could they also take the time to review this patch-set?

Sure. Once we rebase the introspection patches on 5.3, we'll replace
the previous version this new one in our tree and test it.
