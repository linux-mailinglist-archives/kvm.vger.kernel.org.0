Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C92F4DAF22
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 12:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355474AbiCPLwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 07:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355413AbiCPLwV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 07:52:21 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F76963515;
        Wed, 16 Mar 2022 04:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647431468; x=1678967468;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i/v3E4RJIm6gecB7pSj0ZbHHvH0XR3ySxeRDA6z9eYg=;
  b=ZAs8cRTG1ogBx1lqDOR5SXrsAWzkJObuD2vAhUYgmDM4Dr8RMPUt3YKp
   UkNd94+QQBz2Cd5L+MUJR0d5Gf7iavKvYXKGRGRpR3kQM4TMt9ZjDQrGD
   JTizY6OFCxnv0FKjTsWB1nLZVNme9FlMNvfmXjPDS8YVS9J7ot1YKCzaD
   MJE6Au912DrZqmoEEfMiykU2JKk02qhvwl2Z741wI5V9RtOmaPVSp0pI5
   a5UjqT2y7fvJwPzB+IshH96cKb7hcl2Mo9SnySt46AM2mFjLsvrSTLFQU
   ar0j02qSqF96y3iWg8pn/icbao+VmJZFhNV0482YrBufMyz28iGRSC1kU
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10286"; a="255388249"
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="255388249"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 04:51:07 -0700
X-IronPort-AV: E=Sophos;i="5.90,186,1643702400"; 
   d="scan'208";a="557401762"
Received: from gao-cwp.sh.intel.com (HELO gao-cwp) ([10.239.159.23])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 04:51:02 -0700
Date:   Wed, 16 Mar 2022 19:50:59 +0800
From:   Chao Gao <chao.gao@intel.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Zeng Guang <guang.zeng@intel.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>
Subject: Re: [PATCH v6 6/9] KVM: x86: lapic: don't allow to change APIC ID
 unconditionally
Message-ID: <20220316115057.GA22309@gao-cwp>
References: <YihCtvDps/qJ2TOW@google.com>
 <6dc7cff15812864ed14b5c014769488d80ce7f49.camel@redhat.com>
 <YirPkr5efyylrD0x@google.com>
 <29c76393-4884-94a8-f224-08d313b73f71@intel.com>
 <01586c518de0c72ff3997d32654b8fa6e7df257d.camel@redhat.com>
 <2900660d947a878e583ebedf60e7332e74a1af5f.camel@redhat.com>
 <20220313135335.GA18405@gao-cwp>
 <fbf929e0793a6b4df59ec9d95a018d1f6737db35.camel@redhat.com>
 <20220315151033.GA6038@gao-cwp>
 <c903e82ed2a1e98f66910c35b5aabdcf56e08e72.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c903e82ed2a1e98f66910c35b5aabdcf56e08e72.camel@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 05:30:32PM +0200, Maxim Levitsky wrote:
>Yep, I  have a patch for this ( which I hope to be accepted really soon
>(KVM: x86: SVM: allow AVIC to co-exist with a nested guest running)
> 
>I also implemented working support for nested AVIC, which includes support for IPI without vm exits
>between L2's vCPUs. I had sent an RFC for that.
> 
>With all patches applied both L1 and L2 switch hands on AVIC, L1's avic is inhibited
>(only locally) on the vCPU which runs nested, and while it runs nested, L2 uses AVIC
>to target other vCPUs which also run nested.
> 
>I and Paolo talked about this, and we reached a very promising conclusion.
>
>I will add new KVM cap, say KVM_CAP_READ_ONLY_APIC, which userspace will set
>prior to creating a vCPU, and which will make APIC ID fully readonly when set.

Will KVM report violations to QEMU? then, QEMU can know the VM attempted
to change APIC ID and report an error to admin. Then admin can relaunch
the VM without setting this new cap.  

> 
>As a bonus, if you don't object, I will also make this cap, make APIC base read-only,
>since this feature is also broken in kvm, optional in x86 spec, and not really
>used by guests just like writable apic id.
>
>I hope to have patches in day or two for this.

Great. And no objection to making APIC base read-only.
