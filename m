Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89DA6456AF2
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 08:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbhKSHfk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 02:35:40 -0500
Received: from mga05.intel.com ([192.55.52.43]:23832 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229521AbhKSHfj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 02:35:39 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10172"; a="320586846"
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="320586846"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 23:32:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,246,1631602800"; 
   d="scan'208";a="647082781"
Received: from sqa-gate.sh.intel.com (HELO robert-ivt.tsp.org) ([10.239.48.212])
  by fmsmga001.fm.intel.com with ESMTP; 18 Nov 2021 23:32:16 -0800
Message-ID: <0287cc7a09ffcdd0882a0e1a99691fc704ce2fd1.camel@linux.intel.com>
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
From:   Robert Hoo <robert.hu@linux.intel.com>
To:     Sean Christopherson <seanjc@google.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Jim Mattson <jmattson@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, wanpengli@tencent.com, joro@8bytes.org,
        kvm@vger.kernel.org
Date:   Fri, 19 Nov 2021 15:32:15 +0800
In-Reply-To: <YZWqJwUrF2Id9hM2@google.com>
References: <CALMp9eT+uAvPv7LhJKrJGDN31-aVy6DYBrP+PUDiTk0zWuCX4g@mail.gmail.com>
         <YVzeJ59/yCpqgTX2@google.com>
         <20211008082302.txckaasmsystigeu@linux.intel.com>
         <85da4484902e5a4b1be645669c95dba7934d98b5.camel@linux.intel.com>
         <CALMp9eTSkK2+-W8AVRdYv3MEsMKj-Xc2-v7DsavJRh5FLsVuCQ@mail.gmail.com>
         <3360abf3841a5d3234ac5983dd2df62b24e5fc47.camel@linux.intel.com>
         <CALMp9eQruRB3WEuwe2PEyEmbYUcJC_vR86Dd_wPTuqjb212h+w@mail.gmail.com>
         <32f506647ff99f58441ed1281c1db84599d48c8c.camel@linux.intel.com>
         <YYr3R8ehb/1tsCDj@google.com>
         <20211110053548.tewdtkebhl77dmye@linux.intel.com>
         <YZWqJwUrF2Id9hM2@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-11-18 at 01:19 +0000, Sean Christopherson wrote:
> On Wed, Nov 10, 2021, Yu Zhang wrote:
> > On Tue, Nov 09, 2021 at 10:33:43PM +0000, Sean Christopherson
> > wrote:
> > > On Wed, Nov 03, 2021, Robert Hoo wrote:
> > > > On Fri, 2021-10-29 at 12:53 -0700, Jim Mattson wrote:
> > > > > On Fri, Oct 8, 2021 at 5:05 PM Robert Hoo <
> > > > > robert.hu@linux.intel.com>
> > > > > wrote:
> > > > > > 
> > > > > > On Fri, 2021-10-08 at 16:49 -0700, Jim Mattson wrote:
> > > > > > > We have some internal patches for virtualizing VMCS
> > > > > > > shadowing
> > > > > > > which
> > > > > > > may break if there is a guest VMCS field with index
> > > > > > > greater than
> > > > > > > VMX_VMCS_ENUM.MAX_INDEX. I plan to upstream them soon.
> > > > > > 
> > > > > > OK, thanks for letting us know.:-)
> > > > > 
> > > > > After careful consideration, we're actually going to drop
> > > > > these
> > > > > patches rather than sending them upstream.
> > > > 
> > > > OK.
> > > > 
> > > > Hi, Paolo, Sean and Jim,
> > > > 
> > > > Do you think our this series patch are still needed or can be
> > > > dropped
> > > > as well?
> > > 
> > > IMO we should drop this series and take our own erratum.
> > > 
> > 
> > Thanks, Sean.
> > 
> > Do we need a patch in kvm-unit-test to depricate the check against
> > the max index from MSR_IA32_VMX_VMCS_ENUM?
> 
> Hmm, yes, unless there's an easy way to tell QEMU to not override the
> VMX MSRs.
> I don't see any point in fighting too hard with QEMU.

OK. I just sent out the kvm-unit-tests patch. Copied from last mail
from Yu.
https://lore.kernel.org/kvm/1637306107-92967-1-git-send-email-robert.hu@linux.intel.com/T/#u

