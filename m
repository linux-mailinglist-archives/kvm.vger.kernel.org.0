Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3374D34510B
	for <lists+kvm@lfdr.de>; Mon, 22 Mar 2021 21:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230154AbhCVUoM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Mar 2021 16:44:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:6375 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230401AbhCVUnm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Mar 2021 16:43:42 -0400
IronPort-SDR: pPvnHkauOfHFcap+6f3WR6TVnPbeWyrYRiXRGe8JFZhX2RTqrv69APW0ZzEAPBNQLpzJemnwtk
 ZJekEp/alsKQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9931"; a="190439916"
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="190439916"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:43:41 -0700
IronPort-SDR: 7OpqJlrd48XSOrSdb+msx2toQeYW7bM0OKsuOKo8ovXkhgg4AmURcTAP9jvf1G2ER8lB11nUNv
 F/1GMu2ednXg==
X-IronPort-AV: E=Sophos;i="5.81,269,1610438400"; 
   d="scan'208";a="524577166"
Received: from zssigmon-mobl.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.254.92.253])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2021 13:43:38 -0700
Date:   Tue, 23 Mar 2021 09:43:36 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@alien8.de>, kvm@vger.kernel.org,
        x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com
Subject: Re: [PATCH v3 03/25] x86/sgx: Wipe out EREMOVE from
 sgx_free_epc_page()
Message-Id: <20210323094336.ab622e64594a79d54f55e3d7@intel.com>
In-Reply-To: <a2e01d7b-255d-bf64-f258-f3b7f211fc2a@redhat.com>
References: <cover.1616136307.git.kai.huang@intel.com>
        <062acb801926b2ade2f9fe1672afb7113453a741.1616136308.git.kai.huang@intel.com>
        <20210322181646.GG6481@zn.tnic>
        <YFjoZQwB7e3oQW8l@google.com>
        <a2e01d7b-255d-bf64-f258-f3b7f211fc2a@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 22 Mar 2021 20:11:57 +0100 Paolo Bonzini wrote:
> On 22/03/21 19:56, Sean Christopherson wrote:
> > EREMOVE can only fail if there's a kernel or hardware bug (or a VMM bug if
> > running as a guest).  IME, nearly every kernel/KVM bug that I introduced that
> > led to EREMOVE failure was also quite fatal to SGX, i.e. this is just the canary
> > in the coal mine.
> 
> That was my recollection as well from previous threads but, to be fair 
> to Boris, the commit message is a lot more scary (and, which is what 
> triggers me, puts the blame on KVM).  It just says "KVM does not track 
> how guest pages are used, which means that SGX virtualization use of 
> EREMOVE might fail".

I don't see the commit msg being scary.  EREMOVE might fail but virtual EPC code
can handle that.  This is the reason to break out EREMOVE from original
sgx_free_epc_page(), so virtual EPC code can have its own logic of handling
EREMOVE failure.
