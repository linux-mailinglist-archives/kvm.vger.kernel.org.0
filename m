Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B125348D12
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 10:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230078AbhCYJhG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 05:37:06 -0400
Received: from mga14.intel.com ([192.55.52.115]:36885 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229716AbhCYJgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Mar 2021 05:36:36 -0400
IronPort-SDR: Zfcmp/c37s+hrRD6WnINh7nMLaW98I6yP1K9OchdhGL2ejcbocD5oZEGLtxlBeheBTLYj2Xr5i
 mEqdQ46N1IRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9933"; a="190316892"
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="190316892"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 02:36:32 -0700
IronPort-SDR: 9myTIJq0f1tCIy0NWElSFm44pXiiHB7ggH9dUXwTQZVYKyhSOlw4ECcDU6xPh8am7afnUIAgAa
 /tX/6EsccC0w==
X-IronPort-AV: E=Sophos;i="5.81,277,1610438400"; 
   d="scan'208";a="443325855"
Received: from phanl-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.251.4.149])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2021 02:36:28 -0700
Date:   Thu, 25 Mar 2021 22:36:25 +1300
From:   Kai Huang <kai.huang@intel.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-sgx@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <seanjc@google.com>, <jarkko@kernel.org>, <luto@kernel.org>,
        <dave.hansen@intel.com>, <rick.p.edgecombe@intel.com>,
        <haitao.huang@intel.com>, <pbonzini@redhat.com>, <bp@alien8.de>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>
Subject: Re: [PATCH v3 05/25] x86/sgx: Introduce virtual EPC for use by KVM
 guests
Message-Id: <20210325223625.f46ad939c72674830c1ecc53@intel.com>
In-Reply-To: <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
References: <cover.1616136307.git.kai.huang@intel.com>
        <0c38ced8c8e5a69872db4d6a1c0dabd01e07cad7.1616136308.git.kai.huang@intel.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> +
> +static int sgx_vepc_free_page(struct sgx_epc_page *epc_page)
> +{
> +	int ret;
> +
> +	/*
> +	 * Take a previously guest-owned EPC page and return it to the
> +	 * general EPC page pool.
> +	 *
> +	 * Guests can not be trusted to have left this page in a good
> +	 * state, so run EREMOVE on the page unconditionally.  In the
> +	 * case that a guest properly EREMOVE'd this page, a superfluous
> +	 * EREMOVE is harmless.
> +	 */
> +	ret = __eremove(sgx_get_epc_virt_addr(epc_page));
> +	if (ret) {
> +		/*
> +		 * Only SGX_CHILD_PRESENT is expected, which is because of
> +		 * EREMOVE'ing an SECS still with child, in which case it can
> +		 * be handled by EREMOVE'ing the SECS again after all pages in
> +		 * virtual EPC have been EREMOVE'd. See comments in below in
> +		 * sgx_vepc_release().
> +		 *
> +		 * The user of virtual EPC (KVM) needs to guarantee there's no
> +		 * logical processor is still running in the enclave in guest,
> +		 * otherwise EREMOVE will get SGX_ENCLAVE_ACT which cannot be
> +		 * handled here.
> +		 */
> +		WARN_ONCE(ret != SGX_CHILD_PRESENT,
> +			  "EREMOVE (EPC page 0x%lx): unexpected error: %d\n",
> +			  sgx_get_epc_phys_addr(epc_page), ret);

Hi Boris,

With the change to patch 3, I think perhaps this WARN_ONCE() should also be
changed to:

                WARN_ONCE(ret != SGX_CHILD_PRESENT, EREMOVE_ERROR_MESSAGE,
                                ret, ret);

> +		return ret;
> +	}
> +
> +	sgx_free_epc_page(epc_page);
> +
> +	return 0;
> +}
>
