Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C9D3350015
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 14:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235487AbhCaMVL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Mar 2021 08:21:11 -0400
Received: from mga14.intel.com ([192.55.52.115]:10878 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235289AbhCaMU4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Mar 2021 08:20:56 -0400
IronPort-SDR: hyHlmO4d+qUvp2U8p81kHEl5/PEvTtq4K/ijcLoepbEz0iLlg4jCz4OOASBtz7lqqHhHmAbNIZ
 gC9XX8ztgflw==
X-IronPort-AV: E=McAfee;i="6000,8403,9939"; a="191472601"
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="191472601"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 05:20:48 -0700
IronPort-SDR: DFRP9CKn4qqWlB9oUSS6aBdCdsx/WHAppkGubpuzrtS6asZXzpH/1hOE8B8ICKbElp0stjOH8W
 uoYqAbXZSJrQ==
X-IronPort-AV: E=Sophos;i="5.81,293,1610438400"; 
   d="scan'208";a="412136132"
Received: from mwamucix-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.24.224])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 05:20:44 -0700
Date:   Thu, 1 Apr 2021 01:20:39 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Boris Petkov <bp@alien8.de>, <seanjc@google.com>,
        <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jarkko@kernel.org>, <luto@kernel.org>, <dave.hansen@intel.com>,
        <rick.p.edgecombe@intel.com>, <haitao.huang@intel.com>,
        <pbonzini@redhat.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210401012039.c78f02ea2ba9f1e5fd504621@intel.com>
In-Reply-To: <20210331215345.cad098cfcfcaabf489243807@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
        <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
        <20210326150320.GF25229@zn.tnic>
        <20210331141032.db59586da8ba2cccf7b46f77@intel.com>
        <D4ECF8D3-C483-4E75-AD41-2CEFDF56B12D@alien8.de>
        <20210331195138.2af97ec1bb4b5e4202f2600d@intel.com>
        <3889C4C6-48E2-4C97-A074-180EB18BDA29@alien8.de>
        <20210331215345.cad098cfcfcaabf489243807@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 31 Mar 2021 21:53:45 +1300 Kai Huang wrote:
> On Wed, 31 Mar 2021 09:44:39 +0200 Boris Petkov wrote:
> > On March 31, 2021 8:51:38 AM GMT+02:00, Kai Huang <kai.huang@intel.com> wrote:
> > >How about adding explanation to Documentation/x86/sgx.rst?
> > 
> > Sure, and then we should point users at it. The thing is also indexed by search engines so hopefully people will find it.
> 
> Thanks. Will do and send out new patch for review.
> 
Hi Boris,

Could you help to review whether below change is OK?

diff --git a/Documentation/x86/sgx.rst b/Documentation/x86/sgx.rst
index 5ec7d17e65e0..49a840718a4d 100644
--- a/Documentation/x86/sgx.rst
+++ b/Documentation/x86/sgx.rst
@@ -236,3 +236,19 @@ As a result, when this happpens, user should stop running
any new SGX workloads, (or just any new workloads), and migrate all valuable
workloads. Although a machine reboot can recover all EPC, the bug should be
reported to Linux developers.
+
+Virtual EPC
+===========
+
+Separated from SGX driver for creating and running enclaves in host, SGX core
+also supports virtual EPC driver to support KVM SGX virtualization. Unlike SGX
+driver, EPC page allocated via virtual EPC driver is "raw" EPC page and doesn't
+have specific enclave associated. This is because KVM doesn't track how guest
+uses EPC pages.
+
+As a result, SGX core page reclaimer doesn't support reclaiming EPC pages
+allocated to KVM guests via virtual EPC driver. If user wants to deploy both
+host SGX applications and KVM SGX guests on the same machine, user should
+reserve enough EPC (by taking out total virtual EPC size of all SGX VMs from
+physical EPC size) for host SGX applications so they can run with acceptable
+performance.

In my local, I have squashed above change to this patch, and also added below
paragraph to the commit message:

    Also add documenetation to explain what is virtual EPC, and suggest
    users should be aware of virtual EPC pages are not reclaimable and take
    this into account when deploying both host SGX applications and KVM SGX
    guests on the same machine.
