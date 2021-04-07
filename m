Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2C0835781F
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 00:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbhDGW7f (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 18:59:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:43303 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229662AbhDGW7f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 18:59:35 -0400
IronPort-SDR: KOSkU+odbUO/TiZAP6iuuF50I33N1yT3B/ALojLN17veUIUIHV2DKXTxX+qqVzWDL9L/gLYKpp
 lcBkmEbxJ5zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9947"; a="180547879"
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="180547879"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 15:59:24 -0700
IronPort-SDR: YuCWSBzOPHDq4g6DV6PGY9R1imPuPClu+lvyth2PHojmrt1b19sJ//AwGE2Vd1ywwctWOEDc4F
 lxFbGtvNZXWg==
X-IronPort-AV: E=Sophos;i="5.82,204,1613462400"; 
   d="scan'208";a="458557778"
Received: from tkokeray-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.113.100])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Apr 2021 15:59:22 -0700
Date:   Thu, 8 Apr 2021 10:59:20 +1200
From:   Kai Huang <kai.huang@intel.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-sgx@vger.kernel.org,
        pbonzini@redhat.com, bp@alien8.de, jarkko@kernel.org,
        dave.hansen@intel.com, luto@kernel.org, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com
Subject: Re: [PATCH v4 06/11] KVM: VMX: Frame in ENCLS handler for SGX
 virtualization
Message-Id: <20210408105920.69d08e02f23b162cc6302205@intel.com>
In-Reply-To: <YG42a4to8ecl+m6v@google.com>
References: <cover.1617825858.git.kai.huang@intel.com>
        <4be4b49f63a6c66911683d0f093ca5ef0d3996d5.1617825858.git.kai.huang@intel.com>
        <YG4vWwwhr01vZGp6@google.com>
        <20210408103349.c98c3adc94efa66ca048ce2c@intel.com>
        <YG4ztLkCZbJ2ffE+@google.com>
        <20210408104414.29e93147fdd93305846a6ee6@intel.com>
        <YG42a4to8ecl+m6v@google.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 7 Apr 2021 22:47:07 +0000 Sean Christopherson wrote:
> On Thu, Apr 08, 2021, Kai Huang wrote:
> > On Wed, 7 Apr 2021 22:35:32 +0000 Sean Christopherson wrote:
> > > On Thu, Apr 08, 2021, Kai Huang wrote:
> > > > On Wed, 7 Apr 2021 22:16:59 +0000 Sean Christopherson wrote:
> > > > > On Thu, Apr 08, 2021, Kai Huang wrote:
> > > > > > +int handle_encls(struct kvm_vcpu *vcpu)
> > > > > > +{
> > > > > > +	u32 leaf = (u32)vcpu->arch.regs[VCPU_REGS_RAX];
> > > > > 
> > > > > Please use kvm_rax_read(), I've been trying to discourage direct access to the
> > > > > array.  Which is ironic because I'm 100% certain I'm to blame for this. :-)
> > > > 
> > > > Sure. But I think still, we should convert it to (u32) explicitly, so:
> > > > 
> > > > 	u32 leaf = (u32)kvm_rax_read(vcpu); 
> > > > 
> > > > ?
> > > 
> > > Ya, agreed, it helps document that it's deliberate.
> > 
> > Do you have any other comments regarding to other patches? If no I can send
> > another version rather quickly :)
> 
> Nope, nothing at this time.  Though I'd give folks a few days to review before
> sending the next version, I don't think any of my feedback will affect other
> reviews.

My thinking too, but OK I'll wait for other people's review, plus I'd like to
hear about on how to proceed given the current series has some merge conflicts
with latest kvm/queue, although they are quite straightforward to resolve.
