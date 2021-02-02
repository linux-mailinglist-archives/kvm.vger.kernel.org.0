Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC71930CB8F
	for <lists+kvm@lfdr.de>; Tue,  2 Feb 2021 20:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239753AbhBBT25 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 14:28:57 -0500
Received: from mga18.intel.com ([134.134.136.126]:27190 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239763AbhBBT0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 14:26:11 -0500
IronPort-SDR: WmRM3o8XHv3vbiGATlmotJ+iFau9tUgY6RnAieCKCmU0wb/4DbuaGrKZaIqaEJrMmHC7iwPmS7
 nPj/siDM+s2g==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="168593487"
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="168593487"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 11:25:19 -0800
IronPort-SDR: VIsgfvd+pYtRvxtZ1BRz1sUh/cS8WnNQvN6bNhIxaebnXwluYl76YdCF9dPOAptXXfvKV2tyzY
 9Q/CaGhT0cVw==
X-IronPort-AV: E=Sophos;i="5.79,396,1602572400"; 
   d="scan'208";a="372082524"
Received: from asalasax-mobl2.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.7.175])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2021 11:25:15 -0800
Date:   Wed, 3 Feb 2021 08:25:13 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Dave Hansen <dave.hansen@intel.com>, linux-sgx@vger.kernel.org,
        kvm@vger.kernel.org, x86@kernel.org, seanjc@google.com,
        jarkko@kernel.org, luto@kernel.org, haitao.huang@intel.com,
        bp@alien8.de, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC PATCH v3 04/27] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210203082513.35b924312bfdb8c7d6f650ac@intel.com>
In-Reply-To: <32df1e72-b53d-bdf7-9018-a5eee4550dc4@redhat.com>
References: <cover.1611634586.git.kai.huang@intel.com>
        <d93adaec3d4371638f4ea2d9c6efb28e22eafcb3.1611634586.git.kai.huang@intel.com>
        <8250aedb-a623-646d-071a-75ece2c41c09@intel.com>
        <20210127142537.9e831f66f925cbf82b9ab45d@intel.com>
        <32df1e72-b53d-bdf7-9018-a5eee4550dc4@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2 Feb 2021 19:00:48 +0100 Paolo Bonzini wrote:
> On 27/01/21 02:25, Kai Huang wrote:
> > On Tue, 26 Jan 2021 08:04:35 -0800 Dave Hansen wrote:
> >> On 1/26/21 1:30 AM, Kai Huang wrote:
> >>> From: Jarkko Sakkinen <jarkko@kernel.org>
> >>>
> >>> Encapsulate the snippet in sgx_free_epc_page() concerning EREMOVE to
> >>> sgx_reset_epc_page(), which is a static helper function for
> >>> sgx_encl_release().  It's the only function existing, which deals with
> >>> initialized pages.
> >>
> >> Yikes.  I have no idea what that is saying.  Here's a rewrite:
> >>
> >> EREMOVE takes a pages and removes any association between that page and
> >> an enclave.  It must be run on a page before it can be added into
> >> another enclave.  Currently, EREMOVE is run as part of pages being freed
> >> into the SGX page allocator.  It is not expected to fail.
> >>
> >> KVM does not track how guest pages are used, which means that SGX
> >> virtualization use of EREMOVE might fail.
> >>
> >> Break out the EREMOVE call from the SGX page allocator.  This will allow
> >> the SGX virtualization code to use the allocator directly.  (SGX/KVM
> >> will also introduce a more permissive EREMOVE helper).
> > 
> > Thanks.
> > 
> > Hi Jarkko,
> > 
> > Do you want me to update your patch directly, or do you want to take the
> > change, and send me the patch again?
> 
> I think you should treat all these 27 patches as yours now (including 
> removing them, reordering them, adjusting commit message etc.).

Agreed. Thank you Paolo for starting to review this series :)
