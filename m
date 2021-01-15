Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F355F2F7E71
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 15:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731366AbhAOOoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 09:44:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:37443 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbhAOOoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 09:44:06 -0500
IronPort-SDR: mnoeSRfLYLv5wvn1xXwNqE7pcPg4ae+o0bNrMhH2Fu/goX/7WPsPmxmvfT0SrmFfP6AD9AnW27
 1vH1/4BrEJFA==
X-IronPort-AV: E=McAfee;i="6000,8403,9864"; a="197222870"
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="197222870"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 06:43:25 -0800
IronPort-SDR: eflR4KatMJrsfWwRaQOCwkoZCwYrX+93asKiciwWpSso1xfx+z3lRCaE8IB+4Ji1CBSw9cDgvi
 jX3ApRf5S63Q==
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="499939478"
Received: from sanjanar-mobl.amr.corp.intel.com ([10.251.19.188])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2021 06:43:21 -0800
Message-ID: <a522e6bd7bc588775eab889896dadac5e52eb717.camel@intel.com>
Subject: Re: [RFC PATCH 00/23] KVM SGX virtualization support
From:   Kai Huang <kai.huang@intel.com>
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     linux-sgx@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org,
        seanjc@google.com, luto@kernel.org, dave.hansen@intel.com,
        haitao.huang@intel.com, pbonzini@redhat.com, bp@alien8.de,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        jethro@fortanix.com, b.thiel@posteo.de, jmattson@google.com,
        joro@8bytes.org, vkuznets@redhat.com, wanpengli@tencent.com,
        corbet@lwn.net
Date:   Sat, 16 Jan 2021 03:43:18 +1300
In-Reply-To: <20210112150756.f3fb039ac1bb176262da5e52@intel.com>
References: <cover.1609890536.git.kai.huang@intel.com>
         <2422737f6b0cddf6ff1be9cf90e287dd00d6a6a3.camel@kernel.org>
         <20210112141428.038533b6cd5f674c906a3c43@intel.com>
         <X/0DRMx7FC5ssg0p@kernel.org>
         <20210112150756.f3fb039ac1bb176262da5e52@intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-01-12 at 15:07 +1300, Kai Huang wrote:
> > > > > 
> > > > > To support virtual EPC, add a new misc device /dev/sgx_virt_epc to SGX
> > > > > core/driver to allow userspace (Qemu) to allocate "raw" EPC, and use it as
> > > > > "virtual EPC" for guest. Obviously, unlike EPC allocated for host SGX
> > > > > driver,
> > > > > virtual EPC allocated via /dev/sgx_virt_epc doesn't have enclave
> > > > > associated,
> > > > > and how virtual EPC is used by guest is compeletely controlled by guest's
> > > > > SGX
> > > > > software.
> > > > 
> > > > I think that /dev/sgx_vepc would be a clear enough name for the device. This
> > > > text has now a bit confusing "terminology" related to this.
> > > 
> > > /dev/sgx_virt_epc may be clearer from userspace's perspective, for instance,
> > > if people see /dev/sgx_vepc, they may have to think about what it is,
> > > while /dev/sgx_virt_epc they may not.
> > > 
> > > But I don't have strong objection here. Does anyone has anything to say here?
> > 
> > It's already an abberevation to start with, why leave it halfways?
> > 
> > Especially when three remaining words have been shrunk to single
> > characters ('E', 'P' and 'C').
> > 
> 
> I have expressed my opinion above. And as I said I don't have strong objection
> here. I'll change to /dev/sgx_vepc if no one opposes.

Hi Jarkko,

I am reluctant to change to /dev/sgx_vepc now, because there are lots of
'sgx_virt_epc' in the code.  For instance, 'struct sgx_virt_epc', and function names
in sgx/virt.c are all sgx_virt_epc_xxx(), which has 'sgx_virt_epc' as prefix. I feel
changing to /dev/sgx_vepc only is kinda incomplete, but I really don't want to change
so many 'sgx_virt_epc' to 'sgx_vepc'. 

(Plus I still think  'virt_epc' is more obvious than 'vepc' from userspace's
perspective.)

Does it make sense?


