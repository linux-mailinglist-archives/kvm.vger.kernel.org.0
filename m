Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 026E094D40
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 20:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbfHSSwl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 14:52:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:29061 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728214AbfHSSwl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 14:52:41 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Aug 2019 11:52:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,405,1559545200"; 
   d="scan'208";a="172210414"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga008.jf.intel.com with ESMTP; 19 Aug 2019 11:52:40 -0700
Date:   Mon, 19 Aug 2019 11:52:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Adalbert =?utf-8?B?TGF6xINy?= <alazar@bitdefender.com>
Cc:     kvm@vger.kernel.org, linux-mm@kvack.org,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tamas K Lengyel <tamas@tklengyel.com>,
        Mathieu Tarral <mathieu.tarral@protonmail.com>,
        Samuel =?iso-8859-1?Q?Laur=E9n?= <samuel.lauren@iki.fi>,
        Patrick Colp <patrick.colp@oracle.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Weijiang Yang <weijiang.yang@intel.com>, Zhang@vger.kernel.org,
        Yu C <yu.c.zhang@intel.com>,
        Mihai =?utf-8?B?RG9uyJt1?= <mdontu@bitdefender.com>
Subject: Re: [RFC PATCH v6 55/92] kvm: introspection: add KVMI_CONTROL_MSR
 and KVMI_EVENT_MSR
Message-ID: <20190819185240.GC1916@linux.intel.com>
References: <20190809160047.8319-1-alazar@bitdefender.com>
 <20190809160047.8319-56-alazar@bitdefender.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190809160047.8319-56-alazar@bitdefender.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 09, 2019 at 07:00:10PM +0300, Adalbert Lazăr wrote:
> +int kvmi_arch_cmd_control_msr(struct kvm_vcpu *vcpu,
> +			      const struct kvmi_control_msr *req)
> +{
> +	int err;
> +
> +	if (req->padding1 || req->padding2)
> +		return -KVM_EINVAL;
> +
> +	err = msr_control(vcpu, req->msr, req->enable);
> +
> +	if (!err && req->enable)

This needs a comment explaining that it intentionally calls into arch
code only for the enable case so as to avoid having to deal with tracking
whether or not it's safe to disable interception.  At first (and second)
glance it look like KVM is silently ignoring the @enable=false case.

> +		kvm_arch_msr_intercept(vcpu, req->msr, req->enable);

Renaming to kvm_arch_enable_msr_intercept() would also help communicate
that KVMI can't be used to disable msr interception.  The function can
always be renamed if someone takes on the task of enhancing the arch code
to handling disabling interception.

> +
> +	return err;
> +}
